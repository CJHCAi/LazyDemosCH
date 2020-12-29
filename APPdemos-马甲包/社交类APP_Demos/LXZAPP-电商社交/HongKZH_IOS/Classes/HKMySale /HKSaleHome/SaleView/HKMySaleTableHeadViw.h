//
//  HKMySaleTableHeadViw.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKMySaleModel;
@protocol HKMySaleTableHeadViwDelegate <NSObject>

@optional
-(void)myGoods;
-(void)gotoMyOrderFrom;
@end
@interface HKMySaleTableHeadViw : UIView
@property (nonatomic, strong)HKMySaleModel *model;
@property (nonatomic,weak) id<HKMySaleTableHeadViwDelegate> delegate;
@end
