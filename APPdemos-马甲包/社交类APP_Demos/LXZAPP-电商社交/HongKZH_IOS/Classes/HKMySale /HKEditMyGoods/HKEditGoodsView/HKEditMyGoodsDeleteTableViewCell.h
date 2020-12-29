//
//  HKEditMyGoodsDeleteTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGoodsRespone.h"
@protocol HKEditMyGoodsDeleteTableViewCellDelegate <NSObject>

@optional
-(void)addGoodsGotoVc;
-(void)removeGoods;
-(void)htmlEdit;
@end
@interface HKEditMyGoodsDeleteTableViewCell : UITableViewCell
+(instancetype)editMyGoodsDeleteTableViewCell:(UITableView*)tableView;
@property (nonatomic, strong)MyGoodsInfo *model;
@property (nonatomic,weak) id<HKEditMyGoodsDeleteTableViewCellDelegate> delegate;
@property(nonatomic, assign) BOOL isAdd;
@end
