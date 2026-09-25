#!/bin/sh
# Xcode Cloud post-clone script to enable build tool plugins and set up secrets

set -e

# Enable SwiftLint build tool plugin
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

# Write the ZFV API key from the ZFV_API_KEY secret environment variable of the workflow
if [ -n "$ZFV_API_KEY" ]; then
    echo "ZFV_API_KEY = $ZFV_API_KEY" > "$CI_PRIMARY_REPOSITORY_PATH/Config/Secrets.xcconfig"
else
    echo "warning: ZFV_API_KEY is not set, the app will not show the UZH mensas"
fi
