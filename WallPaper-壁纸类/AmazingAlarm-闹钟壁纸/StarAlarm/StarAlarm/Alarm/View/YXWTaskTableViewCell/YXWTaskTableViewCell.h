//
//  YXWTaskTableViewCell.h
//  StarAlarm
//
//  Created by dllo on 16/4/7.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWBaseTableViewCell.h"
#import "YXWAlarmModel.h"
#import "YXWHardView.h"

@protocol YXWTaskTableViewCellDelegate <NSObject>

-(void)pushVC:(YXWAlarmModel *)model;

@end

@interface YXWTaskTableViewCell : YXWBaseTableViewCell

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *wayLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *taskButton;
@property (nonatomic, strong) YXWHardView *hardView;
@property (nonatomic, strong) UIImageView *smallView;

@property (nonatomic, strong) YXWAlarmModel *alermModel;

//遮挡的View
@property (nonatomic, strong) UIView * coverview;

//cell的位移
- (CGFloat)cellOffset;

@property (nonatomic, strong) id<YXWTaskTableViewCellDelegate>delegate;

@end
