//
//  HKSelfVideoToolViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPageViewController.h"
#import "HKCityTravelsRespone.h"
@protocol HKSelfVideoToolViewControllerDeleagte <NSObject>

@optional
-(void)commitSuc;

@end
@class GetMediaAdvAdvByIdRespone;
@interface HKSelfVideoToolViewController : HKPageViewController
@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *responde ;
@property (nonatomic, strong)HKCityTravelsRespone *cityResponse;

@property (nonatomic,weak) id<HKSelfVideoToolViewControllerDeleagte> delegate;
@end
