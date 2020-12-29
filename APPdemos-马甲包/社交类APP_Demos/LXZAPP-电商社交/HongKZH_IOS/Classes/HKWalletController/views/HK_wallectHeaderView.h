//
//  HK_wallectHeaderView.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^cashHandelBlock)( NSInteger index);

@protocol PushIncomeViewDelegete <NSObject>

-(void)enterMyIncomeVc ;

@end

@interface HK_wallectHeaderView : UIView

@property (nonatomic, weak)id <PushIncomeViewDelegete>delegete;

@property (nonatomic, copy)cashHandelBlock block;

/*
 * 今日收入
 */
@property (nonatomic, strong) UILabel * todayTipsLabel;
/*
 * 收入数量
 */
@property (nonatomic, strong) UILabel * todayCountLabel;
/*
 * 总资产
 */
@property (nonatomic, strong)UILabel * totalTipsLabel;
/*
 * 总资数量
 */
@property (nonatomic, strong) UILabel * totalCountLabel;
/*
 * (100乐币等于1元)
 */
@property (nonatomic, strong) UILabel * messageLabel;
/*
 * 充值按钮
 */
@property (nonatomic, strong) UIButton *supplyBtn ;
/*
 * 体现按钮
 */
@property (nonatomic, strong) UIButton *withDralBtn;

@end
