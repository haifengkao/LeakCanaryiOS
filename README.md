# LeakCanaryiOS

[![CI Status](http://img.shields.io/travis/haifengkao/LeakCanaryiOS.svg?style=flat)](https://travis-ci.org/haifengkao/LeakCanaryiOS)
[![Coverage Status](https://coveralls.io/repos/haifengkao/LeakCanaryiOS/badge.svg?branch=master&service=github)](https://coveralls.io/github/haifengkao/LeakCanaryiOS?branch=master)
[![Version](https://img.shields.io/cocoapods/v/LeakCanaryiOS.svg?style=flat)](http://cocoapods.org/pods/LeakCanaryiOS)
[![License](https://img.shields.io/cocoapods/l/LeakCanaryiOS.svg?style=flat)](http://cocoapods.org/pods/LeakCanaryiOS)
[![Platform](https://img.shields.io/cocoapods/p/LeakCanaryiOS.svg?style=flat)](http://cocoapods.org/pods/LeakCanaryiOS)

Do you want to know if there is a memory leak in your XCTest?
This is the tool for you.

Motivated by [Leak Canary](https://github.com/square/leakcanary) and [HeapInspector](https://github.com/tapwork/HeapInspector-for-iOS).
## Usage
Add the follow codes to your test case
```objc
- (void)setUp
{
    [LeakCanary beginSnapShot:@[@"UIView"]];
}

- (void)tearDown
{
    NSSet* leakedObjects = [LeakCanary endSnapShot];
    XCTAssertTrue(leakedObjects.count == 0, @"should not have leaked UIView and UIViewController objects");
}
```
If you use [Kiwi](https://github.com/kiwi-bdd/Kiwi)
```objc
#import <LeakCanary/LeakCanary.h>
#import <Kiwi/Kiwi.h>

beforeEach(^{
    [LeakCanary beginSnapShot:@[@"UIView"]];
});
afterEach(^{
    NSSet* leakedObjects = [LeakCanary endSnapShot];
    [[@(leakedObjects.count) should] equal:@(0)];
});
```


## Requirements

## Installation

LeakCanaryiOS is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "LeakCanaryiOS"
```

## Author

Hai Feng Kao, haifeng@cocoaspice.in

## License

LeakCanaryiOS is available under the MIT license. See the LICENSE file for more info.
