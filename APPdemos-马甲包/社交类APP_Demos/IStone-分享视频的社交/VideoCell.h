//
//  VideoCell.h
//  IStone
//
//  Created by 胡传业 on 14-7-22.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//
// 自定义的用来显示 一个视频的 cell

#import <UIKit/UIKit.h>

@class VideoModel;

@interface VideoCell : UITableViewCell

@property (nonatomic, strong) VideoModel *videoModel;

// 视频截图
@property (nonatomic, weak) UIImageView *videoImageView;

// 用户头像
@property (nonatomic, weak) UIImageView *iconView;

// 视频标题
@property (nonatomic, weak) UILabel *titleLabel;

// 点赞量
@property (nonatomic, weak) UILabel *praiseLabel;

@end
