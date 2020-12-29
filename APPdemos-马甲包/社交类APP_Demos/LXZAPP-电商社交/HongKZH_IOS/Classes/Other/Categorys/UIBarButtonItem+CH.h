//
//  UIBarButtonItem+CH.h
//  XiYou_IOS
//
//  Created by regan on 15/11/19.
//  Copyright © 2015年 regan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CH)
+(UIBarButtonItem*)itemWithIcon:(NSString *)icon highIcon:(NSString*)highIcon target:(nullable id)target action:(nullable SEL)action;
@end
