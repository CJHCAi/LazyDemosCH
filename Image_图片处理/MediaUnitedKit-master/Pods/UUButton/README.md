# UUButton

[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://raw.githubusercontent.com/CheeryLau/UUButton/master/LICENSE)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/UUButton.svg?style=flat)](https://cocoapods.org/pods/UUButton)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/UUButton.svg?style=flat)](https://cocoapods.org/pods/UUButton)&nbsp;

![UUButton](Screenshot.png)

## 安装 [CocoaPods]

1. `pod "UUButton"`;
2. `pod install` / `pod update`;
3. `#import <UUButton.h>`.

## 使用说明

`UUButton`继承于`UIButton`，枚举内容(图片和文字)对齐方式，简化使用。用法和`UIButton`相同，只不过加了以下两个属性：

```objc
// 对齐方式
@property (nonatomic, assign) UUContentAlignment contentAlignment;
// 图文间距[默认5.0]
@property (nonatomic, assign) CGFloat spacing;
```

```objc
// 枚举
typedef NS_ENUM(NSInteger, UUContentAlignment) {
    UUContentAlignmentNormal = 0,                       //内容居中>>图左文右
    UUContentAlignmentCenterImageRight,                 //内容居中>>图右文左
    UUContentAlignmentCenterImageTop,                   //内容居中>>图上文右
    UUContentAlignmentCenterImageBottom,                //内容居中>>图下文上
    UUContentAlignmentLeftImageLeft,                    //内容居左>>图左文右
    UUContentAlignmentLeftImageRight,                   //内容居左>>图右文左
    UUContentAlignmentRightImageLeft,                   //内容居右>>图左文右
    UUContentAlignmentRightImageRight                   //内容居右>>图右文左
};
```

## END

有问题可以联系我【QQ:1539901764 要备注来源哦】，如果这个工具对你有些帮助，请给我一个star、watch。O(∩_∩)O谢谢

