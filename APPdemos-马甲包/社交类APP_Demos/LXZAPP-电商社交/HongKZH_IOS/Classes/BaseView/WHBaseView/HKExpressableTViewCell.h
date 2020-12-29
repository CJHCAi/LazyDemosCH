//
//  HKExpressableTViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKExpresListRespone.h"
@interface HKExpressableTViewCell : UITableViewCell
@property (nonatomic, strong)HKExpresModel *model;
+(instancetype)expressableTViewCellWithTableView:(UITableView*)tableView;
@end
