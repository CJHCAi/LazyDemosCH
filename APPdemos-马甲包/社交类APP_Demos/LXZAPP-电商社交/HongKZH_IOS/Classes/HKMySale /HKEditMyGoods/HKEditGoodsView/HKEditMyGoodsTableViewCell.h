//
//  HKEditMyGoodsTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGoodsRespone.h"
@protocol HKEditMyGoodsTableViewCellDelegate <NSObject>

@optional
-(void)dataUpdatedWithIndex:(NSInteger)index;
-(void)category;
-(void)selectFFreight;
@end
@interface HKEditMyGoodsTableViewCell : UITableViewCell
+(instancetype)editMyGoodsTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)MyGoodsInfo *model;
@property (nonatomic,weak) id<HKEditMyGoodsTableViewCellDelegate> delegate;
@end
