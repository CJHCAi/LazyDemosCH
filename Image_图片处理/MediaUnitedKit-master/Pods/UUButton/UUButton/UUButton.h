//
//  UUButton.h
//  UUButton
//
//  Created by LEA on 2017/12/8.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

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

@interface UUButton : UIButton

// 对齐方式
@property (nonatomic, assign) UUContentAlignment contentAlignment;
// 图文间距[默认5.0]
@property (nonatomic, assign) CGFloat spacing;

@end
