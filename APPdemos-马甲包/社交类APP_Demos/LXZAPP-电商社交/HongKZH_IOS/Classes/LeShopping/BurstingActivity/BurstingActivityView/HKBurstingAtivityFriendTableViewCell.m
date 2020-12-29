//
//  HKBurstingAtivityFriendTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingAtivityFriendTableViewCell.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+ZSYYWebImage.h"
#import "UIImage+YY.h"
@interface HKBurstingAtivityFriendTableViewCell()
@property (weak, nonatomic) IBOutlet ZSUserHeadBtn *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *right;
@property (weak, nonatomic) IBOutlet UILabel *leeLabel;
@property (weak, nonatomic) IBOutlet UILabel *num;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *backIconView;

@end

@implementation HKBurstingAtivityFriendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0];
    // Initialization code
    self.backIconView.userInteractionEnabled = YES;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickView)];
    [self.backIconView addGestureRecognizer:tap];
}
-(void)clickView{
    if ([self.delegate respondsToSelector:@selector(burstingAtivityFriendClick)]) {
        [self.delegate burstingAtivityFriendClick];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(LuckyBurstListFriend *)model{
    _model = model;
    [self.headBtn hk_setBackgroundImageWithURL:model.headImg forState:0 placeholder:kPlaceholderHeadImage];
    self.nameL.text = model.name;
    if (self.type == 0) {
        self.descLabel.text = [NSString stringWithFormat:@"能量值：%@",model.num];
        self.right.hidden = YES;
        self.leeLabel.hidden = YES;
        self.num.text = [NSString stringWithFormat:@"第%@名",model.ranking];
        self.num.hidden = NO;
        self.iconView.hidden = NO;
    }else{
        self.descLabel.text = [NSString stringWithFormat:@"能量值：%@  第%@名",model.num,model.ranking];
        self.right.hidden = NO;
        self.leeLabel.hidden = NO;
        self.num.hidden = YES;
        self.iconView.hidden = YES;
    }
    
}
-(void)setType:(int)type{
    _type = type;
    if (type == 1) {
        UIImage*image = [UIImage createImageWithColor:[UIColor whiteColor] size:CGSizeMake(kScreenWidth-30, 60)];
        image = [image zsyy_imageByRoundCornerRadius:2];
        self.backIconView.image = image;
    }else{
       UIImage*image = [UIImage imageWithColor:[UIColor whiteColor]];
        self.backIconView.image = image;
    }
}
@end
