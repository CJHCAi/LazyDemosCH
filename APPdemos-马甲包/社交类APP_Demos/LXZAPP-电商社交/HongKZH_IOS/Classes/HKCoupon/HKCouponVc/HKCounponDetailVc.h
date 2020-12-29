//
//  HKCounponDetailVc.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

@interface HKCounponDetailVc : HK_BaseView

@property (nonatomic, copy) NSString *detailID;

@property (nonatomic, assign)BOOL hasToolBar;
//新人专享折扣劵
@property (nonatomic, assign)BOOL isVipUser;


@end
