//
//  UIBarButtonItem+Extension.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (instancetype)barButtonItemWithTitle:(NSString *)title
                                target:(id)target
                                action:(SEL)action;

@end
