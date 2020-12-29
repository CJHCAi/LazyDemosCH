//
//  HK_GladlyLookChannelView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "XLChannelControl.h"
@interface HK_GladlyLookChannelView : HK_BaseView

-(void)addBackBlock:(VoidBlock)block;

@property (nonatomic, strong)NSMutableArray *selectArray;

@end
