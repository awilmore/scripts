-- Hammerspoon configuration.
-- Each new Typora or SmartGit window moves to the top-right corner of the
-- external monitor. If no external monitor is connected, the built-in screen
-- is used. This works for each start: Finder, Dock, Spotlight, md or sgit.
-- Hammerspoon must have the Accessibility permission.

-- hs.ipc lets the hs command (for example hs -c "hs.reload()") use Hammerspoon.
require("hs.ipc")
hs.autoLaunch(true)
hs.window.animationDuration = 0

-- The width and the height of the window, as a part of the screen.
-- The keys are the app names.
local sizes = {
  Typora = { w = 0.7, h = 0.9 },
  SmartGit = { w = 0.8, h = 1 },
}

-- Get the first screen that is not the built-in screen.
local function targetScreen()
  for _, s in ipairs(hs.screen.allScreens()) do
    if not (s:name() or ""):find("Built%-in") then return s end
  end
  return hs.screen.primaryScreen()
end

-- Get the frame in the top-right corner of the target screen.
-- screen:frame() does not include the menu bar and the Dock.
local function frameFor(size)
  local f = targetScreen():frame()
  local w = math.floor(f.w * size.w + 0.5)
  local h = math.floor(f.h * size.h + 0.5)
  return hs.geometry.rect(f.x + f.w - w, f.y, w, h)
end

-- The timers that run. A timer that has no reference can stop.
local timers = {}

-- Move the window. An app can set its own bounds while it starts. Thus,
-- after 0.5 seconds, compare the frame with the frame that the window had
-- after the last change. If they are different, move the window again.
-- Stop after 10 tries. Do not compare with the frame that was asked for,
-- because macOS can make the window smaller than asked.
local function place(win, size, tries, last)
  local id = win:id()
  if not id then return end
  timers[id] = nil
  local ok, now = pcall(function() return win:frame() end)
  if not ok or tries > 10 or (last and now:equals(last)) then return end
  local f = frameFor(size)
  -- Set the position again after the size, because macOS can move a window
  -- that is larger than the space that is available.
  win:setTopLeft(f.topleft)
  win:setSize(f.size)
  win:setTopLeft(f.topleft)
  local after = win:frame()
  timers[id] = hs.timer.doAfter(0.5, function() place(win, size, tries + 1, after) end)
end

-- Watch only the standard windows. Dialogs stay where the app puts them.
local apps = {}
for name in pairs(sizes) do apps[name] = { allowRoles = "AXStandardWindow" } end

-- The filter is a global, so that Lua does not delete it.
windowPlacer = hs.window.filter.new(apps)
windowPlacer:subscribe(hs.window.filter.windowCreated, function(win, appName)
  place(win, sizes[appName], 0, nil)
end)

-- Cmd+click in Ghostty works as in iTerm2: it opens URLs, paths and bare file names.
-- tmux has "mouse on", and the mouse protocol cannot send Cmd. Thus, while Ghostty is the
-- front app, a Cmd+click (down, drag, up) changes into an Option+click (Meta). tmux then
-- runs ~/.local/bin/iterm-open-click on M-MouseDown1Pane (see ~/.tmux.darwin.conf).
-- If the focused Ghostty tab does not run tmux, the click gets Shift in place of the change.
-- Then Ghostty opens its own links. A click with no Cmd does not change.
-- A mouse move with Cmd gets Shift, so that Ghostty draws the line under its own links.
local ghosttyID = "com.mitchellh.ghostty"
local function ghosttyIsFront()
  local app = hs.application.frontmostApplication()
  return app ~= nil and app:bundleID() == ghosttyID
end
local ghosttyFront = ghosttyIsFront()

-- Keep the front app in a value, so that a mouse move does not ask macOS.
-- The watchers, taps and tasks are globals, so that Lua does not delete them.
ghosttyAppWatcher = hs.application.watcher.new(function(_, event, app)
  if event == hs.application.watcher.activated then
    ghosttyFront = app ~= nil and app:bundleID() == ghosttyID
  end
end)
ghosttyAppWatcher:start()

-- True if the focused Ghostty tab runs tmux: a Ghostty tmux client on any tmux server has the
-- "focused" flag (~/.tmux.conf sets focus-events on). The check takes about 0.1 seconds, which
-- is too slow for a mouse event. Thus it runs in the background when you push Cmd.
ghosttyInTmux = true
local tmuxCheck = [[
for s in "${TMUX_TMPDIR:-/tmp}/tmux-$(id -u)"/*; do
  [ -S "$s" ] && /opt/homebrew/bin/tmux -S "$s" list-clients -F '#{client_flags} #{client_termtype}' 2>/dev/null
done | grep -q 'focused.* ghostty'
]]
local function checkGhosttyTmux()
  if ghosttyTmuxTask and ghosttyTmuxTask:isRunning() then return end
  ghosttyTmuxTask = hs.task.new("/bin/sh", function(code)
    ghosttyInTmux = (code == 0)
  end, { "-c", tmuxCheck })
  ghosttyTmuxTask:start()
end

local eventTypes = hs.eventtap.event.types
ghosttyCmdKey = hs.eventtap.new({ eventTypes.flagsChanged }, function(e)
  if ghosttyFront and e:getFlags().cmd then checkGhosttyTmux() end
  return false
end)
ghosttyCmdKey:start()

-- The change for the current click: "tmux", "shift" or nil. A click keeps the change of its
-- mouse down until its mouse up, also if you release Cmd first.
local clickMode = nil
ghosttyCmdClick = hs.eventtap.new({
  eventTypes.leftMouseDown,
  eventTypes.leftMouseUp,
  eventTypes.leftMouseDragged,
  eventTypes.mouseMoved,
}, function(e)
  if not ghosttyFront then return false end
  local kind = e:getType()
  local flags = e:getFlags()
  if kind == eventTypes.leftMouseDown then
    clickMode = nil
    if flags.cmd and not flags.shift and not flags.alt then
      clickMode = ghosttyInTmux and "tmux" or "shift"
    end
  end
  local mode = clickMode
  if kind == eventTypes.mouseMoved then
    -- Cmd+Shift on a mouse move makes Ghostty draw its line under a link that it knows,
    -- for example an OSC 8 link in Claude Code. Plain text and bare names get no line.
    mode = (flags.cmd and not flags.shift) and "shift" or nil
  end
  if mode == "tmux" then
    flags.cmd = nil
    flags.alt = true
    e:setFlags(flags)
  elseif mode == "shift" then
    flags.shift = true
    e:setFlags(flags)
  end
  if kind == eventTypes.leftMouseUp then clickMode = nil end
  return false
end)
ghosttyCmdClick:start()

-- macOS stops a tap that is too slow. Start it again if that occurs.
ghosttyTapGuard = hs.timer.doEvery(5, function()
  if not ghosttyCmdClick:isEnabled() then ghosttyCmdClick:start() end
  if not ghosttyCmdKey:isEnabled() then ghosttyCmdKey:start() end
end)
