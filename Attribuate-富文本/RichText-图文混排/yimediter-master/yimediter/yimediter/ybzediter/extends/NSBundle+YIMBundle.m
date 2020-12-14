//
//  NSBundle+YIMBundle.m
//  yimediter
//
//  Created by ybz on 2018/1/4.
//  Copyright © 2018年 ybz. All rights reserved.
//

#import "NSBundle+YIMBundle.h"

@implementation NSBundle (YIMBundle)

+(instancetype)YIMBundle{
    return [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"yimediter" ofType:@"bundle"]];
}

@end
