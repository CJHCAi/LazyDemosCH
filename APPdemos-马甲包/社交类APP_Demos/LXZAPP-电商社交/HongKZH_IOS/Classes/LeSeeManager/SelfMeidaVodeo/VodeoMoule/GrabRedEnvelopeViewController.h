//
//  GrabRedEnvelopeViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
@class GetMediaAdvAdvByIdRespone;
typedef enum{
    GrabRedType_Grab = 0,//还没开始抢
    GrabRedType_Suc = 1,//抢到了
    GrabRedType_Fail = 2,//没有抢到了
}GrabRedType;
@protocol GrabRedEnvelopeViewControllerDelegate <NSObject>

@optional
-(void)playNextCell;
@end
@interface GrabRedEnvelopeViewController : HKBaseViewController
@property (nonatomic, strong)GetMediaAdvAdvByIdRespone *dataM;
@property (nonatomic, copy)NSString *vodeoId;
+(void)showWithSuperVC:(HKBaseViewController*)superVc vodeoId:(GetMediaAdvAdvByIdRespone*)dataM;
@property (nonatomic,assign) GrabRedType redType;
@property (nonatomic,weak) id<GrabRedEnvelopeViewControllerDelegate> delegate;
@end
