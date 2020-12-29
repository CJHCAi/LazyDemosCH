//
//  CommentCell.h
//  IStone
//
//  Created by 胡传业 on 14-7-30.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

// 自定义的显示评论的 cell

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell

// 用户头像
@property (nonatomic, weak) UIImageView *iconView;

// 对视频的评语
@property (nonatomic, weak) UILabel *comment;

// 用户昵称
@property (nonatomic, weak) UILabel *nameLabel;

@end
