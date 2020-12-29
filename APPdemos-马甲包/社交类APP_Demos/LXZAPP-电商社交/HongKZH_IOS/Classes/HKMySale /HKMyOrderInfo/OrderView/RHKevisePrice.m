//
//  RHKevisePrice.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "RHKevisePrice.h"
#import "HKRevisePiceParameter.h"
@interface RHKevisePrice()
@property (weak, nonatomic) IBOutlet UITextField *priceText;
@property (weak, nonatomic) IBOutlet UITextField *freight;
@property (weak, nonatomic) IBOutlet UILabel *allPrice;

@end

@implementation RHKevisePrice

- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"RHKevisePrice" owner:self options:nil].lastObject;
    if (self) {
        [self.priceText addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return self;
}
-(void)textFieldDidChange :(UITextField *)textField{
    self.allPrice.text = [NSString stringWithFormat:@"%.2f",self.model.freightIntegral+textField.text.integerValue];
    self.parameter.integral = [NSString stringWithFormat:@"%.2f", textField.text.integerValue+ self.model.freightIntegral];
    self.parameter.productintegral = [NSString stringWithFormat:@"%.2f", textField.text.doubleValue];
}
-(void)setModel:(HKOrderInfoData *)model{
    _model = model;
    self.priceText.text = [NSString stringWithFormat:@"%.2lf", model.productIntegral];
    self.freight.text = [NSString stringWithFormat:@"%.2lf",model.freightIntegral];
    
    self.allPrice.text = [NSString stringWithFormat:@"%.2lf", model.productIntegral+ model.freightIntegral];
    self.parameter.integral = [NSString stringWithFormat:@"%.2lf", model.productIntegral+ model.freightIntegral];
    self.parameter.productintegral = [NSString stringWithFormat:@"%.2lf", model.productIntegral];
    self.parameter.freightIntegral =[NSString stringWithFormat:@"%.2lf",model.freightIntegral];
    self.parameter.orderNumber = model.orderNumber;
}
-(HKRevisePiceParameter *)parameter{
    if (!_parameter) {
        _parameter = [[HKRevisePiceParameter alloc]init];;
    }
    return _parameter;
}
@end
