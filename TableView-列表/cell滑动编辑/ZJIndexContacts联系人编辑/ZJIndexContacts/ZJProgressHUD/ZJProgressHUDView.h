//
//  ZJProgressHUDView.h
//  ZJProgressHUD
//
//  Created by ZeroJ on 16/9/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJProgressHUDView : UIView
/** 设置颜色 */
@property (strong, nonatomic) UIColor *indicatorColor;
/** 开始动画 */
- (void)startAnimation;
/** 设置文字提示 */
- (void)setText:(NSString *)text;
@end
