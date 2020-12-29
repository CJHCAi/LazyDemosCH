//
//  HK_PaymentActionSheetTwo.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_PaymentActionSheetTwo.h"

@implementation HK_PaymentActionSheetTwo

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.btnPay.layer.borderColor =[keyColor CGColor];
    self.btnPay.layer.borderWidth = 1;
    self.btnPay.layer.masksToBounds = YES;
    self.btnPay.layer.cornerRadius = 5;
    self.btnPay.backgroundColor = keyColor;
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = self.avatar.size.width/2.f;
    [self.btnPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

+ (id)showInView:(UIView *)view
{
    NSBundle *bundle=[NSBundle mainBundle];
    //读取xib文件（会创建AppsView.xib中的描述的所有对象。并且按顺序放到数组中返回）
    NSArray *objs=[bundle loadNibNamed:NSStringFromClass([HK_PaymentActionSheetTwo class]) owner:nil options:nil];
    HK_PaymentActionSheetTwo *v=[objs lastObject];
    
    if (view) {
        [view addSubview:v];
        [view bringSubviewToFront:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(view);
        }];
        
        [v freshUIWithData];
    }
    
    return v;
}

- (IBAction)actionRecharge:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(rechargeCallback)]) {
        [self.delegate rechargeCallback];
    }
    [self removeFromSuperview];
}

- (IBAction)cancelbuttonclicked:(id)sender
{
    [self removeFromSuperview];
}

- (void)freshUIWithData
{
    HK_SaveOrderBaseModel *baseModel = self.baseM;
//    if (baseModel) {
//        NSString *totalPrice = [NSString stringWithFormat:@"%li",(long)[ViewModelLocator sharedModelLocator].preorderBase.data.countegral];
//        
//        [self.btnAllPrice setTitle:totalPrice forState:UIControlStateNormal];
//        [self.btnAllPriceBottom setTitle:[NSString stringWithFormat:@"%li",(long)baseModel.data.user.integral] forState:UIControlStateNormal];
//        self.lbName.text = baseModel.data.user.name;
//        [self.avatar sd_setImageWithURL:[NSURL URLWithString:baseModel.data.user.headImg] placeholderImage:[UIImage imageNamed:@"chattes_icon"]];
//    }
    
}

-(void)configueCellWithTotalCount:(NSInteger)integal {
    NSString *totalPrice = [NSString stringWithFormat:@"%zd",integal];
    
    [self.btnAllPrice setTitle:totalPrice forState:UIControlStateNormal];
    
    [self.btnAllPriceBottom setTitle:[NSString stringWithFormat:@"%.2f",[LoginUserData sharedInstance].integral] forState:UIControlStateNormal];
    self.lbName.text = [LoginUserData sharedInstance].name;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[LoginUserData sharedInstance].headImg] placeholderImage:[UIImage imageNamed:@"chattes_icon"]];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    if (currentPoint.y < self.view_holder.origin.y) {
        [self removeFromSuperview];
    }
}
@end
