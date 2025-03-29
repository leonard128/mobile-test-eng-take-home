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

# Run the codegen script manually before building
echo "🧬 Running React Native codegen manually..."
cd ios
SRCS_DIR=$(pwd)/build/generated/ios
mkdir -p "$SRCS_DIR"
cd ..
node node_modules/react-native/scripts/generate-codegen-artifacts.js \
  --path . \
  --targetPlatform ios \
  --outputPath ios/build/generated/ios

# Now build using Expo tools instead of xcodebuild
echo "🏗️ Building iOS app with Expo tools..."
cd ..

# Start the Metro bundler in a background process
echo "🚀 Starting Metro bundler..."
npx expo start --dev-client &
METRO_PID=$!

# Wait for Metro to start up
sleep 10

# Build and run the app with Expo
echo "📱 Building and running with Expo..."
npx expo run:ios

# Wait for the app to build and launch
echo "⏳ Waiting for app to build and launch..."
sleep 45

echo "✅ App built and launched in simulator: $RUNNING_SIMULATOR"

# Fin