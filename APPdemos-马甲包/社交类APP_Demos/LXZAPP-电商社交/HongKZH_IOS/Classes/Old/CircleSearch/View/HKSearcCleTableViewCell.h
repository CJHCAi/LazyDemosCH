//
//  HKSearcCleTableViewCell.h
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKSearchcircleListModel.h"
@interface HKSearcCleTableViewCell : UITableViewCell
+(instancetype)searcCleTableViewCellWithTableView:(UITableView*)tableView;
@property(nonatomic,strong)HKSearchcircleListModelData*dataM;
@end
