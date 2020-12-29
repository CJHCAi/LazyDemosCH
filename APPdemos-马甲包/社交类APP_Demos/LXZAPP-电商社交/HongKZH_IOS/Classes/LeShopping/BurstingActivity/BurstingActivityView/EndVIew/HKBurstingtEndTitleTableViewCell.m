//
//  HKBurstingtEndTitleTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBurstingtEndTitleTableViewCell.h"
#import "HKluckyBurstDetailRespone.h"
@interface HKBurstingtEndTitleTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *placeBtn;
@property (weak, nonatomic) IBOutlet UILabel *award;
@property (weak, nonatomic) IBOutlet UILabel *awardDesc;

@end

@implementation HKBurstingtEndTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setRespone:(HKluckyBurstDetailRespone *)respone{
    _respone = respone;
    
    [self.placeBtn setTitle:respone.data.u.ranking forState:UIControlStateNormal];
    [self.placeBtn setTitle:respone.data.u.ranking forState:UIControlStateSelected];
    if (respone.data.state.intValue == 1) {
        self.placeBtn.selected = YES;
         NSMutableAttributedString*strA  = [[NSMutableAttributedString alloc]initWithString:@"恭喜获得第"];
         [strA addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, strA.length)];
         NSMutableAttributedString*strB  = [[NSMutableAttributedString alloc]initWithString:respone.data.u.ranking];
          [strB addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"EF593C"] range:NSMakeRange(0, strB.length)];
        [strA appendAttributedString:strB];
        NSMutableAttributedString*strC  = [[NSMutableAttributedString alloc]initWithString:@"名"];
        [strC addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, strC.length)];
        [strA appendAttributedString:strC];
        [strA addAttribute:NSFontAttributeName value:PingFangSCMedium14 range:NSMakeRange(0, strA.length)];
        self.award.attributedText = strA;
        self.awardDesc.text= [NSString stringWithFormat:@"乐小转%@折扣卷1张",respone.data.title];
    }else{
        self.placeBtn.selected = NO;
        NSMutableAttributedString*strA  = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您获得了di%@名，未获奖",respone.data.u.ranking]];
        [strA addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, strA.length)];
        [strA addAttribute:NSFontAttributeName value:PingFangSCMedium15 range:NSMakeRange(0, strA.length)];
        self.award.attributedText = strA;
        self.awardDesc.text= [NSString stringWithFormat:@"很遗憾，您未获得乐小转%@折扣卷",respone.data.title];
    }
}
@end
