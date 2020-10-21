//
//  VideoEditButton.h
//  VideoEditDemo
//
//  Created by JSB-hejiamin on 2018/3/20.
//  Copyright © 2018年 JSB-hejiamin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoEditButton : UIButton

@property (readwrite,nonatomic)CGFloat value;

@property (readwrite,nonatomic)BOOL canTouch;

-(void)setCanTouch:(BOOL)canTouch;

-(instancetype)initWithButtonImage:(UIImage *)image ButtonTitle:(NSString *)title;

@end
