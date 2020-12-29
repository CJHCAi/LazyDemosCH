//
//  HKSearchModels.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearchModels.h"
#import "NSString+Extend.h"
@implementation HKSearchModels
-(void)setTitle:(NSString *)title{
    _title = title;
    CGSize sizeText=[title hk_boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) fonts:PingFangSCMedium12];
    self.w = sizeText.width+20;
}
-(void)setName:(NSString *)name{
    _name = name;
    CGSize sizeText=[name hk_boundingRectWithSize:CGSizeMake(MAXFLOAT, 12) fonts:PingFangSCMedium12];
    self.w = sizeText.width+20;
}
@end
