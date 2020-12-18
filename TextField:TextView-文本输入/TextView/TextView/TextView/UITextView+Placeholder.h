//
//  UITextView+Placeholder.h
//  TextView
//
//  Created by 初程程 on 2017/7/6.
//  Copyright © 2017年 初程程. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)
/**
 textView placeholder text
 */
@property (nonatomic ,copy)NSString *placeholder;
/**
 textView placeholder textColor
 */
@property (nonatomic ,strong)NSDictionary *placeholderAttributes;
/**
 the max inputLenth
 */
@property (nonatomic ,assign)NSInteger maxInputLength;
@end
