#!/bin/bash
# Script to build the React Native app and install it on an emulator

echo "🚀 Starting build and install process..."

# Navigate to project directory
cd /Users/linhao/Github/mobile-test-eng-take-home

# Ensure Android SDK location is set
if [ ! -f ./android/local.properties ]; then
  echo "Creating local.properties file..."
  echo "sdk.dir=$HOME/Library/Android/sdk" > ./android/local.properties
fi

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Prepare the app for native builds
echo "🔨 Preparing app for native build..."
npx expo prebuild

# Build the Android app
echo "🏗️ Building Android app..."
cd android
./gradlew assembleDebug
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

# Start Expo server in the background
echo "🚀 Starting Expo development server..."
npx expo start --android &
EXPO_PID=$!

# Give Expo server time to start
echo "⏳ Waiting for Expo server to start..."
sleep 10

# Install the app
echo "📲 Installing app on emulator..."
adb install -r ./android/app/build/outputs/apk/debug/app-debug.apk

# Run Maestro test
echo "🧪 Running Maestro test..."
maestro test ".maestro/2_tests/0_smoke/P0_features/login_test.yaml"

echo "✅ Build, install, and test complete!"

# Clean up Expo server process
if [ ! -z "$EXPO_PID" ]; then
  echo "🧹 Cleaning up Expo server..."
  kill $EXPO_PID
fi