//
//  UITextView+Placeholder.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)
@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;
@end
