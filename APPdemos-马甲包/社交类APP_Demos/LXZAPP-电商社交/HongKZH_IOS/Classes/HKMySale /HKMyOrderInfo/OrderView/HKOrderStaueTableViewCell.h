//
//  HKOrderStaueTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKOrderStaueTableViewCell : UITableViewCell
+(instancetype)orderStaueTableViewCellWithTableView:(UITableView*)tableView;
@property (nonatomic,assign) OrderFormStatue staue;
@end
