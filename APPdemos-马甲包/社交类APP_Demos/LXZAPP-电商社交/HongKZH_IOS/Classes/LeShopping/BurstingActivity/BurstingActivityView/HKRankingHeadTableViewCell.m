//
//  HKRankingHeadTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRankingHeadTableViewCell.h"
#import "UIImage+YY.h"
@interface HKRankingHeadTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation HKRankingHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    UIImage *image = [UIImage createImageWithColor:[UIColor whiteColor] size:CGSizeMake(kScreenWidth-30, 50)];
    [image zsyy_imageByRoundCornerRadius:5];
    self.iconView.image = image;
    // Initialization code
}

-(void)setNum:(NSInteger)num{
    _num = num;
    self.numLabel.text = [NSString stringWithFormat:@"共%ld人",num];
}

@end
