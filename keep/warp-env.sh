#!/bin/bash

CA_PATH="/Library/Application Support/Cloudflare/installed_cert.pem"
SYSTEM_CA_PATH="/etc/ssl/cert.pem"
COMBINED_CA_PATH="${HOME}/.cloudflare-combined-ca.pem"

if [ -f "$CA_PATH" ]; then
    # Create a combined CA bundle (system CAs + Cloudflare CA) so that both
    # WARP-intercepted connections and non-intercepted connections can verify.
    if [ -f "$SYSTEM_CA_PATH" ]; then
        cat "$SYSTEM_CA_PATH" "$CA_PATH" > "$COMBINED_CA_PATH"
        BUNDLE="$COMBINED_CA_PATH"
    else
        BUNDLE="$CA_PATH"
    fi

    # General Tools
    export SSL_CERT_FILE="$BUNDLE"
    export CURL_CA_BUNDLE="$BUNDLE"
    export NODE_EXTRA_CA_CERTS="$CA_PATH"

    # Python & Azure Specific
    export REQUESTS_CA_BUNDLE="$BUNDLE"
    export AZURE_CA_BUNDLE="$BUNDLE"

    # THE "MAGIC" VARIABLES FOR AZURE LOGIN ERRORS
    # This forces the underlying MSAL/ADAL libraries to use your cert
    export ADAL_PYTHON_CA_BUNDLE="$BUNDLE"
    export PYTHONHTTPSVERIFY=1

    # Persistent Config
    if command -v az &> /dev/null; then
        az config set core.ca_bundle="$BUNDLE" --only-show-errors
        echo "✅ Azure CLI configuration updated."
    fi

    echo "✅ SSL Environment variables set for Cloudflare WARP."
else
    echo "❌ Error: Cloudflare certificate not found."
fi
