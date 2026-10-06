#!/bin/sh
# Xcode Cloud post-clone script to enable build tool plugins and set up secrets

set -e

# Enable SwiftLint build tool plugin
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

# Write the ZFV API key from the ZFV_API_KEY secret environment variable of the workflow
if [ -n "$ZFV_API_KEY" ]; then
    # In an xcconfig, // starts a comment and $ starts a build setting reference, so every / is written as /$()
    # and every $ as $$, which Xcode turns back into the original key
    escaped_key=$(printf '%s' "$ZFV_API_KEY" | sed -e 's/\$/$$/g' -e 's#/#/$()#g')
    printf 'ZFV_API_KEY = %s\n' "$escaped_key" > "$CI_PRIMARY_REPOSITORY_PATH/Config/Secrets.xcconfig"
else
    echo "warning: ZFV_API_KEY is not set, the app will not show the UZH mensas"
fi
