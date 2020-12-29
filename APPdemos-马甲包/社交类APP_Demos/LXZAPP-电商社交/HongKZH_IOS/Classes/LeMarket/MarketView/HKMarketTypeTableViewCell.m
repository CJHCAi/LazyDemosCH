//
//  HKMarketTypeTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMarketTypeTableViewCell.h"
@interface HKMarketTypeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *leftIcon;
@property (weak, nonatomic) IBOutlet UIImageView *titleIcon;

@end

@implementation HKMarketTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSection:(NSInteger)section{
    _section = section;
    if (section == 2) {
        self.leftIcon.image = [UIImage imageNamed:@"wdzkq-1"];
        self.titleIcon.image = [UIImage imageNamed:@"wdzkq_001"];
    }else{
        self.leftIcon.image = [UIImage imageNamed:@"wdhw"];
        self.titleIcon.image = [UIImage imageNamed:@"wdhw_001"];
    }
}
@end
