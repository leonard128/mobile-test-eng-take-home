#!/bin/bash
# Script to build the React Native app and install it on an emulator

echo "🚀 Starting build and install process..."

# Navigate to project directory
cd "$(dirname "$0")/.."  # Navigate to project root using relative path

# Ensure Android SDK location is set
if [ ! -f ./android/local.properties ]; then
  echo "Creating local.properties file..."
  echo "sdk.dir=$HOME/Library/Android/sdk" > ./android/local.properties
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Prepare the app for native builds if needed
if [ ! -d "./android" ]; then
  echo "🔨 Preparing app for native build..."
  npx expo prebuild --no-install
fi

# Build the Android app in release mode
echo "🏗️ Building Android app in release mode..."
cd android
./gradlew assembleRelease
cd ..

# Check if any emulators are running
RUNNING_EMULATOR=$(adb devices | grep emulator | cut -f1)

if [ -z "$RUNNING_EMULATOR" ]; then
  echo "🔍 No emulator running. Attempting to start one..."
  
  # List available emulators
  EMULATORS=$($HOME/Library/Android/sdk/emulator/emulator -list-avds)
  
  if [ -z "$EMULATORS" ]; then
    echo "❌ No emulators found. Please create one in Android Studio first."
    exit 1
  fi
  
  # Get the first emulator from the list
  FIRST_EMULATOR=$(echo "$EMULATORS" | head -n1)
  echo "🚀 Starting emulator: $FIRST_EMULATOR"
  
  # Start the emulator in the background
  $HOME/Library/Android/sdk/emulator/emulator -avd "$FIRST_EMULATOR" &
  
  # Wait for emulator to boot
  echo "⏳ Waiting for emulator to boot..."
  adb wait-for-device
  sleep 90  # Give it a bit more time to fully boot
fi

# Check if app is already installed and uninstall it
echo "🔍 Checking if app is already installed..."
if adb shell pm list packages | grep -q "com.testengtakehome.app"; then
  echo "🗑️ Uninstalling existing app..."
  adb uninstall com.testengtakehome.app
fi

# Install the app
echo "📲 Installing app on emulator..."
adb install -r "./android/app/build/outputs/apk/release/app-release.apk"

# Run Maestro test
echo "🧪 Running Maestro test..."
maestro test ".maestro/2_tests/0_smoke/P0_features/login_test.yaml"

echo "✅ Build, install, and test complete!"

npm run android