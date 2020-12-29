//
//  BurstingActivityPayBtn.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BurstingActivityPayBtn.h"
#import "UIImage+YY.h"
@interface BurstingActivityPayBtn()
@property (weak, nonatomic) IBOutlet UILabel *lableBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation BurstingActivityPayBtn
- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"BurstingActivityPayBtn" owner:self options:nil].lastObject;
    if (self) {
      UIImage*image =  [[UIImage createImageWithColor:[UIColor colorFromHexString:@"FB5016 "] size:CGSizeMake(270, 43)] zsyy_imageByRoundCornerRadius:22];
        self.iconView.image = image;
    }
    return self;
}
-(void)setNum:(NSInteger)num{
    _num = num;
    if (num>0) {
        self.hidden = NO;
        NSMutableAttributedString*string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"支付%ld参与活动",num]];
        [string addAttribute:NSFontAttributeName value:PingFangSCMedium17 range:NSMakeRange(0, string.length)];;
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length)];;
        NSTextAttachment *attchImage = [[NSTextAttachment alloc] init];
        // 表情图片
        attchImage.image = [UIImage imageNamed:@"514_goldc_"]; // 设置图片大小
        attchImage.bounds = CGRectMake(0, 0, 16, 16); NSAttributedString *stringImage = [NSAttributedString attributedStringWithAttachment:attchImage];
        [string insertAttributedString:stringImage atIndex:2];
        
        self.lableBtn.attributedText = string;
    }else if(num == -1){
        self.hidden = NO;
         NSMutableAttributedString*string = [[NSMutableAttributedString alloc]initWithString:@"查看获奖详情"];
        [string addAttribute:NSFontAttributeName value:PingFangSCMedium17 range:NSMakeRange(0, string.length)];;
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length)];;
        self.lableBtn.attributedText = string;
    }else{
        self.hidden = YES;
    }
   
    
}
- (IBAction)btnclick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(burstingActivityPay)]) {
        [self.delegate burstingActivityPay];
    }
}

@end
