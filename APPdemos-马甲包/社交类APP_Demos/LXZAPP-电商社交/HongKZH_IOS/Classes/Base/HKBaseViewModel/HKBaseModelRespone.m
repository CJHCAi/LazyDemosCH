//
//  HKBaseModelRespone.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/14.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseModelRespone.h"

@implementation HKBaseModelRespone
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end
