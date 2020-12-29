//
//  HKDiscountView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDiscountView.h"
#import "UIView+Xib.h"
@interface HKDiscountView()
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *h;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation HKDiscountView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
//    UIImage *image = [UIImage imageNamed:@"xrzx_zk"];
    
    self.discountLabel.transform = CGAffineTransformMakeRotation(-M_PI*0.25);
}
-(void)setDiscount:(NSInteger)discount{
    _discount = discount;
    self.discountLabel.text = [NSString stringWithFormat:@"%ld折",discount];
    self.titleW.constant = (sqrt(self.width*self.width+self.height*self.height)*0.5 -self.h.constant*3/2)*2 ;
    self.top.constant = sqrt((sqrt(self.width*self.width+self.height*self.height)*0.5 -self.h.constant*3/2)*(sqrt(self.width*self.width+self.height*self.height)*0.5 -self.h.constant*3/2)*0.25);
    
}
-(void)setFont:(UIFont *)font{
    _font = font;
    self.discountLabel.font = font;
}
@end
