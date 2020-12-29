//
//  HKOrderNameTableViewCell.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HKOrderFromInfoRespone.h"
@class ZSUserHeadBtn;
@interface HKOrderNameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *staue;
@property (nonatomic, strong)HKOrderInfoData *model;
+(instancetype)orderNameTableViewCellWithTableView:(UITableView*)tableView;
@end
