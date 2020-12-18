//
//  ZJTextOnlyHUDView.h
//  ZJProgressHUD
//
//  Created by ZeroJ on 16/9/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ZJTextOnlyHUDView : UIView
/** 设置提示文字*/
@property (strong, nonatomic) NSString *text;
/** 设置文字颜色 */
@property (strong, nonatomic) UIColor *textColor;

@end
