//
//  UIBarButtonItem+Extension.h
//  仿搜狗阅读
//
//  Created by Mac on 16/6/3.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)barButtonItemWithTitle:(NSString *)title
                                target:(id)target
                                action:(SEL)action;

@end
