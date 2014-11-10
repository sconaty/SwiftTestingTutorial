SwiftTestingTutorial
====================

Tutorial which describes how to add unit tests and BDD to your Swift application

### Preparing the Tutorial Source Code
The tutorial projects use git submodules. As a result when you first clone the project you'll need to execute the following shell commands in the cloned root directory.

```sh
git submodule sync
git submodule update --init --recursive
```

### Updating the Quick Submodule

If you ever want to update the submodules to latest version, enter the Quick directory and pull from the master repository:

```sh
cd BDDExample/Vendor/Quick
git pull --rebase origin master
```