# SimpleArchitectureExample - an iOS Core Skills example

## TL;DR:
How to sharpen your skills? Memorize this Core Skills template: [App Architecture Template](https://github.com/Herbal7ea/SimpleArchitectureExample)

## Overview
Most technical interviews I've had revolve around some core skills:

* Simple UI
	* TableView
	* Cells
	* Detail View
* Architecture
	* MVP/MVVM/VIPER
	* Dependency Injection
	* Navigation Coordinator (Router)
* Model Responsibilities
	* Network
	* Database
	* Mock Web Server
* Unit Tests
* Threading
* Simple RxSwift (BehaviorRelay, Variable, CurrentValueSubject)

In building an application you also need these same types of pieces. 

SimpleArchitectureExample is a simple app to review & practice these skills, and place to start from to get building an app quickly with these pieces in place.

## How to Use

One of the simplest ways to sharpen your skills is to learn this code by heart:

* Copy it several times
* Break it into simple pieces: one or two word comments
* Rewrite it (from those comments)
* Study it
* Adapt it to your favorite architecture and needs.
* Help each other
* Talk about what I could have done better
* Fix my broken tests since I added CoreData Entities 😉

#### *** Disclaimer: I don't think there is a best way to do things, but I think code separation and organization is important (within reason).  This code example is constantly being updated and added to, and is by no means complete.  It gives you a strong starting point.  Start with good patterns and move to the better and better.***

## How to Re-use
If you want to reuse this repo for your own app, there is a simple way to rename the project for to your new app name.  This is talked about on [stackoverflow](https://stackoverflow.com/questions/33370175/how-do-i-completely-rename-an-xcode-project-i-e-inclusive-of-folders)

And here are the lines you need to run after you have `ack` installed.

Search & Replace: `NewProjectName` With New Name: e.g. `CoolMoneyMakingApp`

Run commands in terminal:

```
find . -name 'SimpleArchitectureExample*' -print0 | xargs -0 rename --subst-all 'SimpleArchitectureExample' 'NewProjectName'
find . -name 'SimpleArchitectureExample*'
ack --literal --files-with-matches 'SimpleArchitectureExample' --print0 | xargs -0 sed -i '' 's/SimpleArchitectureExample/NewProjectName/g'
ack --literal 'SimpleArchitectureExample'
```

## Other areas of study

[Algorithms](https://store.raywenderlich.com/products/data-structures-and-algorithms-in-swift)

[Design Patterns](https://store.raywenderlich.com/products/design-patterns-by-tutorials)

[Design System w/ Declarative UI](https://github.com/nodata/Fractal)
