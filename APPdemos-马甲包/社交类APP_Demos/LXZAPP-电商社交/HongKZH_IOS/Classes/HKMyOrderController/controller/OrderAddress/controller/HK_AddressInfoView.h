//
//  HK_AddressInfoView.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_BaseView.h"

#import "HK_OrderDeliverModel.h"
/** 失败回调*/
@protocol HK_AddressInfoViewDeleagte <NSObject>

@optional
-(void)changeBlock:(addressDataModel*)model;
@end
typedef void(^changeBlock)(addressDataModel * model);

@interface HK_AddressInfoView : HK_BaseView

//@property (nonatomic, copy) changeBlock block;
@property (nonatomic,weak) id<HK_AddressInfoViewDeleagte> delegate;
@end
