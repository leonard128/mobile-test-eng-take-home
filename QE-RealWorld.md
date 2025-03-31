# Quality Engineering Documentation
This is the Documentation for probelm encountered and solutions

## 1. Building the app
Literaly building my first app in React Native.
Setting up the environment is a bit of a pain. A lot of versioning issues.
But basically everything is straightforward bash commands. Just follow the instruction and copy paste then execute.

## 2. Install maestro
Tons of tutorials online. Command line copy paste.
Meanwhile thinking about how to organize the test cases and how to make it easier to maintain.
Page Object Model is a good idea.
build up a basic login happy path test case.

## 3. This EXPO thing
Looks like a container for the app. But everytime I launch the app it goes to the expo app and ask me to login.
Solved it by building locally. Bypass the login process since it's unnecessary and we need to avoid this kind of authentication.

## 4. iOS info.plist
Tried iOS, got CFBBundleVersion Error. Searched online something about info.plist.
Anyway let's do Android first.

## 5. Android
Utilized gradle to build the app and then grab the apk file, install -> run the test. Progress!

## 6. Page Object Model or Flow Object Model
Was gonna use POM. But after digging into the code, I found POM works best with the page files written in JS.
I'm a bit OCD so decided to use Flow Object Model. The thought is to design page method and put them in separate files but in the same page folder. So in a degree of abstraction, it's similar to POM.

## 7. Expo server again
When launching the app, it goes to the expo server of localhost and I had to manually pick my app.
A small system handler is needed for test initialization.

## 8. Android is running smoothly
Android is running smoothly with local server.
A small note: when maestro studio is running, the app will not launch.

## 9. iOS
Never expect iOS could be this hard to setup. Maybe because this is my first react native app. Need to get more familiar with the framework and pipeline.
But good news is that iOS is running smoothly with local server.

## 10. Challenge
Gonna try to make it work with CI.

## 11. Note on the weekend
* Did some more research on this expo thing, seems we could biuld with configuration prod to avoid the fakakta 'server' thing. Need to modify the bash script to make it straight forward.
* Scripts are working good. 'build_android.sh' and 'build_ios.sh' will take the build work and 'test_android.sh' and 'test_ios.sh' will take the test work. Next step is to get CI working.
    * The plan is to first make the test run on maestro cloud. Then we can move to CI.
    * After reading the document of GitHub Actions, I found it's very easy to setup. Just need to create a workflow file in '.github/workflows' folder.
    * The workflow file is written in YAML. It will be triggered when there's a push to the main branch(or a PR towards it).
    * The workflow file will run the bash script for testing.