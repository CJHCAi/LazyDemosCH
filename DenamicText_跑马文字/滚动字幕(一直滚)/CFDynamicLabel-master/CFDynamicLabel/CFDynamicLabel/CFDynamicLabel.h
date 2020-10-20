//
//  CFDynamicLabel.h
//  CFDynamicLabel
//
//  Created by 于 传峰 on 15/8/26.
//  Copyright (c) 2015年 于 传峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFDynamicLabel : UIView

@property(nonatomic, copy) NSString* text;
@property(nonatomic, strong) UIColor* textColor;
@property(nonatomic, strong) UIFont* font;
@property(nonatomic, assign) CGFloat speed;
@end
