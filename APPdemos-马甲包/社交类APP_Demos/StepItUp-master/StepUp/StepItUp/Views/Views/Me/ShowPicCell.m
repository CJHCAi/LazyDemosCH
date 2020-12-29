//
//  ShowPicCell.m
//  StepUp
//
//  Created by syfll on 15/6/13.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "ShowPicCell.h"

@implementation ShowPicCell

- (void)awakeFromNib {
    // Initialization code
    self.headImage.backgroundColor = [UIColor whiteColor];
    self.headImage.layer.cornerRadius = self.headImage.frame.size.width / 2;
    self.headImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];

    // Configure the view for the selected state
}
#pragma mark 修改背景图片
-(void)chageBackImage:(UIImage*)backImage{
    self.backImage.image = backImage;
}
#pragma mark 修改头像图片
-(void)chageHeadImage:(UIImage*)headImage{
    self.headImage.image = headImage;
}

@end
