#!/bin/sh
# Xcode Cloud post-clone script to enable build tool plugins

set -e

# Enable SwiftLint build tool plugin
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
