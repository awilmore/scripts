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
