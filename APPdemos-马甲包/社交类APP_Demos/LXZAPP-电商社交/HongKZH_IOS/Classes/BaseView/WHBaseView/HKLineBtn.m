//
//  HKLineBtn.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/5.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLineBtn.h"
#import "UIView+BorderLine.h"
@implementation HKLineBtn
-(void)awakeFromNib{
    [super awakeFromNib];
    [self borderForColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1] borderWidth:1 borderType:UIBorderSideTypeAll];
}

@end
