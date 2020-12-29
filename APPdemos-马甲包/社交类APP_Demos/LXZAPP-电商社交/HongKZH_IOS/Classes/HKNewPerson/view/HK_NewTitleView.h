//
//  HK_NewTitleView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKNewPerSonTypeResponse.h"

@interface HK_NewTitleView : UIView

@property (nonatomic, strong)HKNewPerSonType * model;

//在抢购时间 点击效果UI
-(void)setDuringShopNomalUI;
//在抢购时间 默认效果
-(void)setDuringShopSelectUI;
//即将开始默认UI
-(void)setAfterLaterNomalUI;
//即将开始选中UI
-(void)setAfterLaterSelectUI;

@end
