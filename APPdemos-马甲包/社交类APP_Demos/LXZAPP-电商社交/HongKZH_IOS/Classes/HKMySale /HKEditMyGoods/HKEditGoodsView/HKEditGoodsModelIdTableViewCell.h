//
//  HKEditGoodsModelIdTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGoodsRespone.h"
@protocol HKEditGoodsModelIdTableViewCellDelegate <NSObject>

@optional
-(void)deleteSkusWithModel:(SkusModel*)model;

@end
@interface HKEditGoodsModelIdTableViewCell : UITableViewCell
+(instancetype)ditGoodsModelIdTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)SkusModel *model;
@property (nonatomic,weak) id<HKEditGoodsModelIdTableViewCellDelegate> delegate;
@end
