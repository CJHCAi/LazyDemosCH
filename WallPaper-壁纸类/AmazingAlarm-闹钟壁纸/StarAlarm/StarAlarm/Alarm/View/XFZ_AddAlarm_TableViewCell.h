//
//  XFZ_AddAlarm_TableViewCell.h
//  StarAlarm
//
//  Created by 谢丰泽 on 16/4/12.
//  Copyright © 2016年 YYL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFZ_dataModel.h"
@interface XFZ_AddAlarm_TableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *timeLebel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *xingLabel;
@property (nonatomic, strong) UIView *yyy;
@property (nonatomic, strong) UILabel *haoLabel;
@property (nonatomic, strong) UIImageView *customImageView;
@property (nonatomic, strong) ZFZ_dataModel *dataModel;

@end
