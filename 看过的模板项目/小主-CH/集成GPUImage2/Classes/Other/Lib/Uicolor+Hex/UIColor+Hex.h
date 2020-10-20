//
//  UIColor+Hex.h
//  MIT_itrade
//
//  Created by Mega on 14-4-8.
//  Copyright (c) 2014年 ___ZhengDaXinXi___. All rights reserved.
//

/*********************************
 文件名: UIColor+Hex.h
 功能描述: 16进制转UIColor
 *********************************/
#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString: (NSString *) stringToConvert;
+ (UIColor *)colorWithSETPRICE:(NSString *)SETPRICE price:(NSString*)PRICE;
+ (UIColor *)colorWithRAISELOSE:(NSString *)RAISELOSE;
@end
