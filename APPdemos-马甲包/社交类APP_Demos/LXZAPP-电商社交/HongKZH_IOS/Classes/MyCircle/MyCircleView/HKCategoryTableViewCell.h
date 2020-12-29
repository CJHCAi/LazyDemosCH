//
//  HKCategoryTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKCategoryClicleModel;
@interface HKCategoryTableViewCell : UITableViewCell
@property (nonatomic,assign) BOOL selectRow;
@property (nonatomic, strong)HKCategoryClicleModel *model;
+(instancetype)categoryTableViewCellWithTableView:(UITableView*)tableView;
@end
