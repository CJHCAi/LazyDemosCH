//
//  HKTollSelfCommitViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "InfoMediaAdvCommentListRespone.h"
#import "HKCityTravelsRespone.h"
@class GetMediaAdvAdvByIdRespone;
@protocol HKTollSelfCommitViewControllerDelegate <NSObject>

@optional
-(void)showTextViewCommunt:(InfoMediaAdvCommentListModels*)model;

@end
@interface HKTollSelfCommitViewController : HKBaseViewController
@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *responde ;
@property (nonatomic, strong)HKCityTravelsRespone * cityResponse;
-(void)loadNewData;
@property (nonatomic,weak) id<HKTollSelfCommitViewControllerDelegate> delegate;
@end
