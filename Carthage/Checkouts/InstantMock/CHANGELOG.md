# Changelog


## 2.5.1

* Support verifications of types, like `Arg.eq(String.self)`
* Add unit tests
* Some Swift simplifications, `final` keyword enforcement


## 2.5.0

* Swift 5 support
* Fix https://github.com/pirishd/InstantMock/issues/70 dictionary `MockUsable` equality issue with Swift 5


## 2.2.3

* Fix documentation


## 2.2.2

* Enable to reset expectations and stubs


## 2.2.1

* Fix README


## 2.2.0

* Swift 4.2 support
* Compatible with Xcode 10
* Review README


## 2.1.0

* Add handling of property setters, with a syntax like `mock.expect().call(mock.property.set(mock.prop, value: Arg.any()))`
* Review README


## 2.0.1

* Fix podspec doc


## 2.0.0

* Swift 4 Support (introduced a limitation on the number of arguments for closure management, see Swift bug [SR-2008](https://bugs.swift.org/browse/SR-2008) and [SE-0110](https://github.com/apple/swift-evolution/blob/master/proposals/0110-distingish-single-tuple-arg.md)).


## 1.1.6

* Few enhancements in doc, tests and build


## 1.1.5

* Simplify project structure


## 1.1.4

* Add playground sample


## 1.1.3

* Review project structure to make sure Cocoapods finds tests


## 1.1.2

* Fix logo path


## 1.1.1

* Review README, add a logo


## 1.1.0

* Add rejection of expectations with `mock.reject()`


## 1.0.0

* Add support to Swift Package Manager


## 0.2.1

* Add Travis for continous integration


## 0.2.0

* Simplify syntax for `Arg.any()`


## 0.1.0

* Add `andThrow` to stubs


## 0.0.5

* Fix public visibility of initializers for `ArgumentCaptor` and `ArgumentClosureCaptor`


## 0.0.4

* Fix optional values in `Arg.verify`
* Make syntax for handling closures simpler
* Make syntax for number of expected calls simpler


## 0.0.3

* Fix API for `verify()` to take into account #file and #line
* Fix optional values in `Arg.eq`


## 0.0.2

* Attempt to generate doc


## 0.0.1

* Say Hello to InstantMock
