//
//  HKSendRedEnvelopesTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSendRedEnvelopesTableViewCell.h"
#import "UIImage+YY.h"
#import "HKMoneyModel.h"
@interface HKSendRedEnvelopesTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *moneyName;
@property (weak, nonatomic) IBOutlet UITextField *moneyFlied;
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UILabel *patternLabel;
@property (weak, nonatomic) IBOutlet UISwitch *patternSwitch;
@property (weak, nonatomic) IBOutlet UILabel *otherPattern;
@property (weak, nonatomic) IBOutlet UILabel *excess;
@property (weak, nonatomic) IBOutlet UILabel *otherTypeLabel;

@property (nonatomic,assign) BOOL isNOSend;
@property (weak, nonatomic) IBOutlet UIButton *sure;

@end

@implementation HKSendRedEnvelopesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = MainColor;
    self.patternSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
     [self.number addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
      [self.moneyFlied addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    UIImage *imageD = [[UIImage createImageWithColor:[UIColor colorFromHexString:@"CCCCCC"] size:CGSizeMake(kScreenWidth-30, 50)]zsyy_imageByRoundCornerRadius:5];
     UIImage *imageS = [[UIImage createImageWithColor:[UIColor colorFromHexString:@"EF593C"] size:CGSizeMake(kScreenWidth-30, 50)]zsyy_imageByRoundCornerRadius:5];
    [self.sure setBackgroundImage:imageD forState:0];
    [self.sure setBackgroundImage:imageS forState:UIControlStateSelected];
}
-(void)judge{
    if (self.patternSwitch.on) {
        if (self.moneyFlied.text.integerValue*self.number.text.integerValue>200000) {
            self.isNOSend = YES;
        }else{
            self.isNOSend = NO;
        }
    }else{
        if (self.moneyFlied.text.integerValue>200000) {
            self.isNOSend = YES;
        }else{
            if (self.number.text.integerValue>0&&self.moneyFlied.text.integerValue/self.number.text.integerValue<1) {
                self.isNOSend = YES;
            }else{
            self.isNOSend = NO;
            }
        }
        
    }
}
-(void)textFieldChanged:(UITextField*)textField{
    [self judge];
}
- (IBAction)patternClick:(UISwitch *)sender {
    if (!sender.on) {
        self.patternLabel.text = @"普通模式";
        self.moneyName.text = @"单个金额";
        self.otherPattern.text = @"拼手气模式";
        self.otherTypeLabel.text =@"当前为普通模式,改为";
        if (self.number.text.integerValue>0) {
            NSInteger money = self.moneyFlied.text.integerValue/self.number.text.integerValue;
            self.moneyFlied.text = [NSString stringWithFormat:@"%ld",(long)money]  ;
        }
        
    }else{
        if (self.number.text.integerValue>0) {
             NSInteger money = self.moneyFlied.text.integerValue*self.number.text.integerValue;
            self.moneyFlied.text = [NSString stringWithFormat:@"%ld",(long)money]  ;
        }
        self.otherTypeLabel.text =@"当前为拼手气模式,改为";
        self.patternLabel.text = @"拼手气模式";
        self.moneyName.text = @"总金额";
        self.otherPattern.text = @"普通模式";
    }
    [self judge];
}
-(void)setIsNOSend:(BOOL)isNOSend{
    _isNOSend = isNOSend;
    self.sure.selected = !isNOSend;
    self.sure.userInteractionEnabled = !isNOSend;
    if (isNOSend) {
        self.excess.textColor = [UIColor colorFromHexString:@"EF593C"];
    }else{
        self.excess.textColor = [UIColor colorFromHexString:@"999999"];
    }
}
- (IBAction)sureClick:(UIButton *)sender {
    if (!self.number.text.length) {
        [EasyShowTextView showText:@"请输入红包个数"];
        return;
    }
    if (!self.moneyFlied.text.length) {
        [EasyShowTextView showText:@"请输入红包金额"];
        return;
    }
    if ([self.delegate respondsToSelector:@selector(subComplains:)]) {
        HKMoneyModel*model = [[HKMoneyModel alloc]init];
        
        model.number = self.number.text;
        
        model.money = self.moneyFlied.text;
        if (self.patternSwitch.on){
            //拼手气
            DLog(@"拼手气模式...");
            model.type = @"2";
            model.totalMoney = self.moneyFlied.text.integerValue;
        }else {
            //普通
            DLog(@"普通模式...");
            model.type = @"1";
            model.totalMoney = self.moneyFlied.text.integerValue*self.number.text.integerValue;
        }
    [self.delegate subComplains:model];
    }
}
@end
