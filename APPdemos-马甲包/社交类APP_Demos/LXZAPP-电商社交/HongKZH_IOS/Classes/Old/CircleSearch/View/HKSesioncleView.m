//
//  HKSesioncleView.m
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSesioncleView.h"

@implementation HKSesioncleView

+(instancetype)sesioncleView{
    HKSesioncleView*view = [[NSBundle mainBundle]loadNibNamed:@"HKSesioncleView" owner:self options:nil].lastObject;
    return view;
}

@end
