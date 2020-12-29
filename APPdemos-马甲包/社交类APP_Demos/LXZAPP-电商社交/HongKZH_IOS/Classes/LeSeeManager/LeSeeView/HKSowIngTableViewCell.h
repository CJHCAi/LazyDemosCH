//
//  HKSowIngTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKSowIngTableViewCell : UITableViewCell
@property (nonatomic, strong)NSMutableArray *imageArray;
+(instancetype)sowIngTableViewCellWithTableView:(UITableView*)tableView;
@end
