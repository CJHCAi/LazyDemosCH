//
//  HK_InfoTopCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_orderInfo.h"
@interface HK_InfoTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *infoBackView;
@property (weak, nonatomic) IBOutlet UIView *rootContentView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *RightRowBtn;

-(void)setConfigueWithModel:(HK_orderInfo *)model;

@end
