//
//  HKLeSeeVideoMyGoodsViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "GetMediaAdvAdvByIdRespone.h"
@protocol HKLeSeeVideoMyGoodsViewControllerDelegate <NSObject>

@optional
-(void)gotoGoodsInfo:(GetMediaAdvAdvByIdProducts*)goodsId;
@end
@interface HKLeSeeVideoMyGoodsViewController : HKBaseViewController
@property (nonatomic,weak) id<HKLeSeeVideoMyGoodsViewControllerDelegate> delegate;
@property (nonatomic, strong)NSArray *dataArray;
@end
