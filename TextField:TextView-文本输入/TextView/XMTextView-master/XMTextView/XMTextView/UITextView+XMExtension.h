//
//  UITextView+XMExtension.h
//  XMTextView
//
//  Created by XM on 2018/6/30.
//  Copyright © 2018年 XM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (XMExtension)

/** placeholdLabel */
@property(nonatomic,readonly)  UILabel *placeholdLabel;
/** placeholder */
@property(nonatomic,copy) NSString *placeholder;
/** placeholder颜色 */
@property(nonatomic,copy) UIColor *placeholderColor;
/** 富文本 */
@property(nonnull,strong) NSAttributedString *attributePlaceholder;
/** 位置 */
@property(nonatomic,assign) CGPoint location;
/** 默认颜色 */
+ (UIColor *)defaultColor;

@end
