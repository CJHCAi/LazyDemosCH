//
//  HomeCell.h
//  IStone
//
//  Created by 胡传业 on 14-7-23.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell

// 视频截图
@property (nonatomic, weak) UIImageView *videoImageView;

// 用户头像
@property (nonatomic, weak) UIImageView *iconView;

// 昵称
@property (nonatomic, weak) UILabel *nameLabel;

// 点赞量
@property (nonatomic, weak) UILabel *praiseLabel;

@end
