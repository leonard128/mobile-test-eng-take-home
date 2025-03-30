#!/bin/bash
# Script to build the React Native app and install it on an simulator
echo "🚀 Starting build and install process..."

# Navigate to project directory
cd "$(dirname "$0")"  # Navigate to the directory containing this script
echo "📍 Current directory: $(pwd)"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Prepare the app for native builds
echo "🔨 Preparing app for native build..."
npx expo prebuild --platform ios

# Install iOS dependencies
echo "📦 Installing iOS dependencies..."
cd ios
pod install
cd ..

# First, make sure the node_modules/.cache directory is clean
rm -rf node_modules/.cache

# Check if any simulator are running
echo "🔍 Checking for running simulators..."
RUNNING_SIMULATOR=$(xcrun simctl list devices | grep -i "booted" | head -1 | sed -E 's/.*\(([A-Z0-9-]+)\).*/\1/')
if [ -z "$RUNNING_SIMULATOR" ]; then
  echo "📱 No simulator running. Starting iPhone 16 Pro simulator..."
  xcrun simctl boot "iPhone 16" || xcrun simctl boot "$(xcrun simctl list devices available | grep -i 'iphone 16' | head -1 | sed -E 's/.*\(([A-Z0-9-]+)\).*/\1/')"
  sleep 5
else
  echo "📱 Found running simulator: $RUNNING_SIMULATOR"
fi

# Check if app is already installed and uninstall it
echo "🔍 Checking if app is already installed..."
SIMULATOR_ID=${RUNNING_SIMULATOR:-$(xcrun simctl list devices | grep -i "booted" | head -1 | sed -E 's/.*\(([A-Z0-9-]+)\).*/\1/')}
if xcrun simctl listapps "$SIMULATOR_ID" | grep -q "com.testengtakehome.app"; then
  echo "🗑️ Uninstalling existing app..."
  xcrun simctl uninstall "$SIMULATOR_ID" "com.testengtakehome.app"
fi

# Build and run the app on the simulator
echo "📱 Building and installing app on simulator..."
npx expo run:ios --configuration Release

echo "✅ Build, install, and test complete!"