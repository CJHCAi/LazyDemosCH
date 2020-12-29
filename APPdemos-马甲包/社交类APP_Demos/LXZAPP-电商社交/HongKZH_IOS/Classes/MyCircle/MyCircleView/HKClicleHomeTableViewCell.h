//
//  HKClicleHomeTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKCircleCategoryListModel;
@protocol HKClicleHomeTableViewCellDelegate <NSObject>

@optional
-(void)addGroupWithModel:(HKCircleCategoryListModel*)model;

@end
@interface HKClicleHomeTableViewCell : UITableViewCell
@property (nonatomic, strong)HKCircleCategoryListModel *model;
+(instancetype)clicleHomeTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic,weak) id<HKClicleHomeTableViewCellDelegate> delegate;
@end
