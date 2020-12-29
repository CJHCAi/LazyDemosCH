//
//  HKAddreesTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKMobileModel;
@interface HKAddreesTableViewCell : UITableViewCell
+(instancetype)addreesTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic, strong)HKMobileModel *model;
@property (nonatomic, copy)NSString* name;
@end
