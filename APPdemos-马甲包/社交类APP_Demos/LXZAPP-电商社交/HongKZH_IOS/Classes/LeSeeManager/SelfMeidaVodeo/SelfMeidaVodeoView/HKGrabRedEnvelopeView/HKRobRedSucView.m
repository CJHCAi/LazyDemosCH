//
//  HKRobRedSucView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKRobRedSucView.h"
@interface HKRobRedSucView()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation HKRobRedSucView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKRobRedSucView" owner:self options:nil].lastObject;
    }
    return self;
}
- (IBAction)share:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shareToVc)]) {
        [self.delegate shareToVc];
    }
}
-(void)setNum:(NSInteger)num{
    _num = num;
    NSMutableAttributedString*strA = [[NSMutableAttributedString alloc]initWithString:@"您抢到了"];
    [strA addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, strA.length)];
    [strA addAttribute:NSFontAttributeName value:PingFangSCMedium16 range:NSMakeRange(0, strA.length)];
    
    NSMutableAttributedString *strB = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%ld",num]];
    [strB addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"E2D771"] range:NSMakeRange(0, strB.length)];
    [strB addAttribute:NSFontAttributeName value:PingFangSCMedium23 range:NSMakeRange(0, strB.length)];
    [strA appendAttributedString:strB];
    NSMutableAttributedString*strD = [[NSMutableAttributedString alloc]initWithString:@"乐币"];
    [strD addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, strD.length)];
     [strD addAttribute:NSFontAttributeName value:PingFangSCMedium16 range:NSMakeRange(0, strD.length)];
    [strA appendAttributedString:strD];
    self.numLabel.attributedText = strA;
}
@end
