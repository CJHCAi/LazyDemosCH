//
//  CommentCell.m
//  IStone
//
//  Created by 胡传业 on 14-7-30.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        // 头像
        UIImageView *image_2 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 4, 25, 25)];
        // 圆形用户图像
        [image_2.layer setCornerRadius:CGRectGetHeight([image_2 bounds]) / 2];
        image_2.layer.masksToBounds = YES;

        [self.contentView addSubview:image_2];
        self.iconView = image_2;
    
        // 昵称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 4, 155, 25)];
        nameLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:12];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        
        // 评论
        UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 220, 30)];
        comment.font = [UIFont fontWithName:@"AvenirNext-UltraLight" size:12];
        self.comment = comment;
        [self.contentView addSubview:comment];
        
        // 评论图标
        UIImageView *commentImage = [[UIImageView alloc] initWithFrame:CGRectMake(285, 4, 25, 25)];
        commentImage.image = [UIImage imageNamed:@"coment"];
        [self.contentView addSubview:commentImage];
        
        
//        self.contentView.backgroundColor = [UIColor grayColor];
        
        
        // cell 被选中时为无色
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
