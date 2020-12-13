//
//  UIColor+YIMEditerExtend.h
//  yimediter
//
//  Created by ybz on 2017/12/3.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YIMEditerExtend)

-(nonnull NSString*)hexString;
+(nonnull UIColor*)colorWithHexString:(nonnull NSString*)hexStr;

@end
