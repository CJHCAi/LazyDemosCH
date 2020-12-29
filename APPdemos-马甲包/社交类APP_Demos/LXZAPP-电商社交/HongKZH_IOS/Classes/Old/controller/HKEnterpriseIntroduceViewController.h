//
//  HKEnterpriseIntroduceViewController.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"
#import "HK_SeclectFormModel.h"

/*
    公司介绍
 */

@interface HKEnterpriseIntroduceViewController : HK_BaseView
@property (nonatomic, assign) NSInteger source;     /* 1.公司介绍 2.职位描述*/
@property (nonatomic, weak) HK_SeclectFormModel *formModel;
@end
