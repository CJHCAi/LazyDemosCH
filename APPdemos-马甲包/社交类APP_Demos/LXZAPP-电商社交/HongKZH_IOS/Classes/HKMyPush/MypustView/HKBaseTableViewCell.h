//
//  HKBaseTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKBaseTableViewCell : UITableViewCell
@property (nonatomic, copy)NSString *image;
@property (nonatomic, copy)NSString *title;
+(instancetype)baseTableViewCellWithTableView:(UITableView*)tableView;
@end
