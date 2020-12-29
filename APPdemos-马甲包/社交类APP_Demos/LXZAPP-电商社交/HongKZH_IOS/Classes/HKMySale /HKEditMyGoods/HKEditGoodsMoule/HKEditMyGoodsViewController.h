//
//  HKEditMyGoodsViewController.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"
#import "MyGoodsRespone.h"
@protocol HKEditMyGoodsViewControllerDelegate <NSObject>

@optional
-(void)addGoods:(MyGoodsInfo*)goodsM;
-(void)updateaGoods:(MyGoodsInfo *)goodsM row:(NSIndexPath *)row;
@end
typedef void(^RowRefresh)(NSInteger row);
@interface HKEditMyGoodsViewController : HKBaseViewController
@property (nonatomic, copy)NSString *productId;
@property (nonatomic,weak) NSIndexPath *indexPath;
@property (nonatomic, copy)RowRefresh rowRefresh;
@property(nonatomic, assign) BOOL isAdd;
@property (nonatomic,weak) id<HKEditMyGoodsViewControllerDelegate> delegate;
@end
