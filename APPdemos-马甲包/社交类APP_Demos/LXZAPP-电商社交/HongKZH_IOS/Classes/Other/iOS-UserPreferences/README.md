iOS-UserPreferences
================

iOS-UserPreferences provides convenience methods to get and set user preferences including primitive types.

## Installation
If you're using [CocoaPods](http://cocoapods.org), then simply insert `pod 'iOS-UserPreferences'` in your application's `Podfile`.

Otherwise, copy  `iOS-UserPreferences.h` and `iOS-UserPreferences.m` into your project.

## Examples

Get and set user preferences:
>
    BOOL soundOn = [UserPreferences getBoolWithKey:@"soundOn" withDefault:YES];
    [UserPreferences setInt:11 withKey:@"volume"];

Check to see if a key is defined and if not return true and define it, otherwise return
false. Useful when you only want to run a block of code once.
>
    if ([UserPreferences isKeyUndefinedThenDefine:@"firstTime"]) {
        //  show intro
    }

## Authors
Norman Basham - [@nbasham](http://github.com/nbasham/)

## License
iOS-UserPreferences is made available under the Apache 2.0 License. A full copy of the license is available in the LICENSE file.