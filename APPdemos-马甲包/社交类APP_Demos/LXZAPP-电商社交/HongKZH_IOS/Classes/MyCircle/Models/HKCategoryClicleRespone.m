//
//  HKCategoryClicleRespone.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCategoryClicleRespone.h"
#import "HKCategoryClicleModel.h"
@implementation HKCategoryClicleRespone
+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [HKCategoryClicleModel class]};
}
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end
