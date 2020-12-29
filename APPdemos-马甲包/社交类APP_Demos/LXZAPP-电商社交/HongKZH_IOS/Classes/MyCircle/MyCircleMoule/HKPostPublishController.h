//
//  HKPostPublishController.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "HKMyCircleViewModel.h"
#import "HKMyCircleRespone.h"
#import "HKMyCircleData.h"
@protocol RefreshDataDelegete <NSObject>

-(void)getNewPost;
@end

@interface HKPostPublishController : HKBaseViewController
@property (nonatomic, copy)NSString *circleId;
@property (nonatomic, strong)HKMyCircleRespone *respone;
@property (nonatomic, weak)id <RefreshDataDelegete>delegete;
@end
