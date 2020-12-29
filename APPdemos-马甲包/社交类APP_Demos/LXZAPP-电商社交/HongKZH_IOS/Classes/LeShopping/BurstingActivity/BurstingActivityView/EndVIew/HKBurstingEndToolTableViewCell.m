//
//  HKBurstingEndToolTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/19.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingEndToolTableViewCell.h"
#import "UIImage+YY.h"
@interface HKBurstingEndToolTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleView;

@end

@implementation HKBurstingEndToolTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIImage*image = [[UIImage createImageWithColor:[UIColor colorFromHexString:@"EF593C "] size:CGSizeMake(kScreenWidth-70, 43)]zsyy_imageByRoundCornerRadius:22];
    [self.nextBtn setBackgroundImage:image forState:0];
}
-(void)setIsAward:(BOOL)isAward{
    _isAward = isAward;
    if (isAward) {
        self.titleView.text = @"折扣卷已发送至您的账户“我的卷”中";
        [self.nextBtn setTitle:@"查看奖品" forState:0];
    }else{
        self.titleView.text = @"";
        [self.nextBtn setTitle:@"去抢卷" forState:0];
    }
}
@end
