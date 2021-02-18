//
//  UIColor+random.m
//  指尖叫货
//
//  Created by baiqiang on 16/3/10.
//  Copyright © 2016年 白强. All rights reserved.
//

#import "UIColor+random.h"

@implementation UIColor (random)
+ (UIColor *)random {
    CGFloat red = arc4random() / INT_MAX;
    CGFloat green = arc4random() / INT_MAX;
    CGFloat blue = arc4random() / INT_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}
@end
