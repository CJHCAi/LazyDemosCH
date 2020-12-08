//
//  ARParamLoop.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARParamLoop.h"

@implementation ARParamLoop


#pragma mark - 参数循环，点击按钮时，轮流返回 0 9 18 27
+ (NSString *)paramLoop{
    
    static NSInteger startParm = 0;
    if (startParm == 0) {
        startParm = 9;
        return @"9";
    }
    if (startParm == 9){
        startParm = 18;
        return @"18";
    }
    if (startParm == 18){
        startParm = 27;
        return @"27";
    }
    else{
        startParm = 0;
        return @"0";
    }
}

@end
