SwiftTestingTutorial
====================

Tutorial which describes how to add unit tests and BDD to your Swift application. It also provides an introduction into CocoaPods.

The Keynote presenation used in the tutorial can be found in the repository. It is also available on [SpeakerDeck](https://speakerdeck.com/sconaty/swift-testing) if you'd like to view it in your broswer.

### Preparing the Tutorial Source Code
The tutorial projects use git submodules. As a result when you first clone the respository you'll need to execute the following shell commands in the cloned root directory.

```sh
git submodule sync
git submodule update --init --recursive
```

### Updating the Quick Submodule

If you ever want to update the submodules to latest version, enter the Quick directory and pull from the master repository:

```sh
cd BDDExample/Vendor/Quick
git pull --rebase origin master
cd ../Nimble
git pull --rebase origin master
```