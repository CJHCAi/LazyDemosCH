//
//  HKShareLeFriendPageViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HJTabViewController.h"
#import "HKShareBaseModel.h"
@interface HKShareLeFriendPageViewController : HJTabViewController
@property (nonatomic, strong)NSMutableArray *array_vc;
@property(nonatomic, assign) NSInteger indexVC;
@property (nonatomic, strong)HKShareBaseModel *shareM;
@end
