//
//  CommonTools.h
//  AiCai
//
//  Created by jayhomzhou on 12-2-7.
//  Copyright (c) 2012Âπ?www.AiCai.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SCREEM_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEM_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface CommonTools : NSObject

+(UIColor *) colorWithHexString: (NSString *) stringToConvert;

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert alpha:(CGFloat)alpha;

@end
