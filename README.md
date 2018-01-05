# GYREdgeJustifiedLabel

[![CI Status](http://img.shields.io/travis/gyratorycircus/GYREdgeJustifiedLabel.svg?style=flat)](https://travis-ci.org/gyratorycircus/GYREdgeJustifiedLabel)
[![Version](https://img.shields.io/cocoapods/v/GYREdgeJustifiedLabel.svg?style=flat)](http://cocoapods.org/pods/GYREdgeJustifiedLabel)
[![License](https://img.shields.io/cocoapods/l/GYREdgeJustifiedLabel.svg?style=flat)](http://cocoapods.org/pods/GYREdgeJustifiedLabel)
[![Platform](https://img.shields.io/cocoapods/p/GYREdgeJustifiedLabel.svg?style=flat)](http://cocoapods.org/pods/GYREdgeJustifiedLabel)


EdgeJustifiedLabel is a UILabel subclass which allows two strings to be shown left and right justified on a single line, and equally scaled or truncated to fit the label bounds.

This capability is not possible using two separate UILabels and autolayout, as one will always scale before the other, nor is it possible via NSAttributedString, which does not allow left and right justified text to be displayed on a single line.

Additional options include minimum spacing between the strings, and truncation styles for each string once scaling options have been exhausted.

EdgeJustifiedLabel is also interoperable with Objective-C, and can be fully configured and previewed in Interface Builder.

## Example

![Example Screenshot](screenshot.png?raw=true "Example Screenshot")

To run this example project for yourself, clone the repo, and run `pod install` from the Example directory first.


## Usage

```
    var label = EdgeJustifiedLabel()
    label.leftText = "Left justified text"
    label.rightText = "Right justified text"
    label.minimumSpacing = 40
    label.truncationStyle = .rightTail
```

## Requirements

Compatible with Swift 3.2 or 4.0.
When installing with cocoapods, iOS 8 or later is required, though the source file itself will compile for iOS 7.

## Installation

GYREdgeJustifiedLabel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GYREdgeJustifiedLabel'
```

## Author

Tom Jendrzejek ([gyratorycircus@icloud.com](mailto:gyratorycircus@icloud.com))

## License

GYREdgeJustifiedLabel is available under the MIT license. See the LICENSE file for more info.
