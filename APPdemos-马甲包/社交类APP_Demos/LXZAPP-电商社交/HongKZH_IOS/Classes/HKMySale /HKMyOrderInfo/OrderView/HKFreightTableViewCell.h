//
//  HKFreightTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKFreightTableViewCell : UITableViewCell
+(instancetype)freightTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic,assign) NSInteger freight;
@end
