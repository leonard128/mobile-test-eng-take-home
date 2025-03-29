#!/bin/bash

# Script to build the React Native app and install it on an iOS simulator

echo "🚀 Starting iOS build and install process..."

# Navigate to project directory
cd /Users/linhao/Github/mobile-test-eng-take-home

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

# Clean any previous builds
rm -rf ios/build

# First, make sure the node_modules/.cache directory is clean
rm -rf node_modules/.cache

# Start the Metro bundler in a background process
echo "🚀 Starting Metro bundler..."
npx expo start --dev-client &
METRO_PID=$!

# Wait for Metro to start up
sleep 10

# Build and run the app with Expo
echo "📱 Building and running with Expo..."
npx expo run:ios 

# Run Maestro test
echo "🧪 Running Maestro test..."
maestro test ".maestro/2_tests/0_smoke/P0_features/login_test.yaml"

# Clean up Expo server process
if [ ! -z "$EXPO_PID" ]; then
  echo "🧹 Cleaning up Expo server..."
  kill $EXPO_PID
fi
# Fin