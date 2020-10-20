//
//  CLCustomRotationGestureRecognizer.h
//  菁优网首页动画
//
//  Created by JackChen on 2016/12/13.
//  Copyright © 2016年 chenlin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLCustomRotationGestureRecognizer : UIGestureRecognizer
// 记录手势最后一个改变是旋转的弧度
@property (nonatomic, assign) CGFloat rotation;
@end
