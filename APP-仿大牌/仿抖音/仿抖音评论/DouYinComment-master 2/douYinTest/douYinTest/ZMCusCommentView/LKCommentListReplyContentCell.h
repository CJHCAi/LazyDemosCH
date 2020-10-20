//
//  LKCommentListReplyContentCell.h
//  douYinTest
//
//  Created by Kai Liu on 2019/3/5.
//  Copyright © 2019 Kai Liu. All rights reserved.
//  二级回复cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LKContentModel;

@interface LKCommentListReplyContentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

- (void)configData:(LKContentModel *)model;

@end

NS_ASSUME_NONNULL_END
