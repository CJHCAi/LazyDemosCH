//
//  ZJTextAndImageHUDView.h
//  ZJProgressHUD
//
//  Created by ZeroJ on 16/9/7.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJTextAndImageHUDView : UIView
/** 设置文字颜色 */
@property (strong, nonatomic) UIColor *textColor;
/** 设置提示文字和图片*/
- (void)setText:(NSString *)text andImage:(UIImage *)image;
@end
