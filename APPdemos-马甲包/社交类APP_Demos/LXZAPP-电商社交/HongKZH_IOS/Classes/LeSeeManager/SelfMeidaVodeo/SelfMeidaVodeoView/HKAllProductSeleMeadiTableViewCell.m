//
//  HKAllProductSeleMeadiTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKAllProductSeleMeadiTableViewCell.h"
#import "AllProductByUserRespone.h"
#import "UIImageView+HKWeb.h"
@interface HKAllProductSeleMeadiTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UILabel *name1;
@property (weak, nonatomic) IBOutlet UILabel *num1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UILabel *name2;
@property (weak, nonatomic) IBOutlet UILabel *num2;

@end

@implementation HKAllProductSeleMeadiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    AllProductByUsersList*frist = dataArray.firstObject;
    [self.icon1 hk_sd_setImageWithURL:frist.imgSrc placeholderImage:kPlaceholderImage];
    self.name1.text = frist.title;
    NSMutableAttributedString*strA = [[NSMutableAttributedString alloc]initWithString:@"售价："];
    [strA addAttribute:NSFontAttributeName value:PingFangSCMedium12 range:NSMakeRange(0, strA.length)];
    [strA addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"999999"] range:NSMakeRange(0, strA.length)];
    NSMutableAttributedString*strB = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥ %ld",frist.price]];
    [strB addAttribute:NSFontAttributeName value:PingFangSCMedium12 range:NSMakeRange(0, strB.length)];
    [strB addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"EF593C"] range:NSMakeRange(0, strB.length)];
    [strA appendAttributedString:strB];
    self.num1.attributedText = strA;
    if (dataArray.count>1) {
        self.view2.hidden = NO;
        AllProductByUsersList*last = dataArray.firstObject;
        [self.icon2 hk_sd_setImageWithURL:last.imgSrc placeholderImage:kPlaceholderImage];
        self.name2.text = last.title;
        self.num2.text = [NSString stringWithFormat:@"参考价：%ld",last.price];
    }else{
        self.view2.hidden = YES;
    }
}
@end
