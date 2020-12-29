//
//  HKHisToryVideoCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHisToryVideoCell.h"

@interface HKHisToryVideoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *shortNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation HKHisToryVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.coverImageView.layer.masksToBounds = YES;
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.titleLabel.textColor =[UIColor blackColor];
    self.titleLabel.font =[UIFont boldSystemFontOfSize:17];
    self.iconImageView.layer.cornerRadius =15;
    self.iconImageView.layer.masksToBounds = YES;
    self.shortNameLabel.textColor =[UIColor colorFromHexString:@"666666"];
    self.shortNameLabel.font =PingFangSCRegular15;
    self.shortNameLabel.numberOfLines =0;
    
}
-(void)setList:(HK_DataVideoList *)list {
    _list = list;
    [AppUtils seImageView:self.coverImageView withUrlSting:list.coverImgSrc placeholderImage:[UIImage imageNamed:@"bpic21"]];
    self.titleLabel.text =list.title;
    [AppUtils seImageView:self.iconImageView withUrlSting:list.headImg placeholderImage:nil];
    self.shortNameLabel.text =list.name;
    self.timeLabel.text = list.createDate;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
