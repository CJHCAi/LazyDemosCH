# WGBCommonAlertSheetView

<p align='center'>
<img src="https://img.shields.io/badge/build-passing-brightgreen.svg">
<a href="https://cocoapods.org/pods/WGBCommonAlertSheetView"> <img src="https://img.shields.io/cocoapods/v/WGBCommonAlertSheetView.svg?style=flat"> </a>
<img src="https://img.shields.io/badge/platform-iOS-ff69b4.svg">
<img src="https://img.shields.io/badge/language-Objective--C-orange.svg">
<a href=""><img src="https://img.shields.io/badge/license-MIT-000000.svg"></a>
<a href="http://wangguibin.github.io"><img src="https://img.shields.io/badge/Blog-CoderWGB-80d4f9.svg?style=flat"></a>
<img src="https://img.shields.io/badge/Enjoy-it%20!-brightgreen.svg?colorA=a0cd34">
</p>


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
 
## Usage
 
 ```objc
 
     UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 500) style:(UITableViewStylePlain)];
     tableView.backgroundColor = randomColor;
     WGBCommonAlertSheetView *sheet = [[WGBCommonAlertSheetView alloc] initWithFrame:UIScreen.mainScreen.bounds containerView:tableView];
     sheet.isNeedBlur = arc4random()%2;
     sheet.blurStyle = arc4random()%2+1;
     sheet.touchDismiss = YES;
     [sheet show];
 ```

## Requirements

 Support iOS8.0+

## Installation

WGBCommonAlertSheetView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WGBCommonAlertSheetView'
```

## Author

Wangguibin, 864562082@qq.com

## License

WGBCommonAlertSheetView is available under the MIT license. See the LICENSE file for more info.
