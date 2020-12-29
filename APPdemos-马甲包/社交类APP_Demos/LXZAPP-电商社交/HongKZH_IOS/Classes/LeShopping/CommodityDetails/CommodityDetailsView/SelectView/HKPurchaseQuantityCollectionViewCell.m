//
//  HKPurchaseQuantityCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPurchaseQuantityCollectionViewCell.h"
#import "UIView+BorderLine.h"
@interface HKPurchaseQuantityCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIButton *subtraction;
@property (weak, nonatomic) IBOutlet UIButton *addition;
@property (weak, nonatomic) IBOutlet UITextField *quantity;

@end

@implementation HKPurchaseQuantityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.quantity.borderColor = [UIColor colorFromHexString:@"999999"];
    [self.addition borderForColor:[UIColor colorFromHexString:@"999999"] borderWidth:1 borderType:UIBorderSideTypeTop];
    [self.addition borderForColor:[UIColor colorFromHexString:@"999999"] borderWidth:1 borderType:UIBorderSideTypeRight];
    [self.addition borderForColor:[UIColor colorFromHexString:@"999999"] borderWidth:1 borderType:UIBorderSideTypeBottom];
    [self.subtraction borderForColor:[UIColor colorFromHexString:@"999999"] borderWidth:1 borderType:UIBorderSideTypeTop];
    [self.subtraction borderForColor:[UIColor colorFromHexString:@"999999"] borderWidth:1 borderType:UIBorderSideTypeLeft];
    [self.subtraction borderForColor:[UIColor colorFromHexString:@"999999"] borderWidth:1 borderType:UIBorderSideTypeBottom];
    [self.quantity borderForColor:[UIColor colorFromHexString:@"999999"] borderWidth:1 borderType:UIBorderSideTypeAll];
    [self.quantity addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    // Initialization code
}
-(void)passConTextChange:(UITextField*)textfield{
    if (textfield.text.length <= 0) {
        textfield.text = @"0";
        self.subtraction.userInteractionEnabled = NO;
    }else{
        ;
        self.subtraction.userInteractionEnabled = YES;
    }
    if (textfield.text.intValue < 0) {
        textfield.text = @"0";
      
    }
    if ([self.delegate respondsToSelector:@selector(updataNum:)]) {
        [self.delegate updataNum:self.quantity.text.intValue];
    }
}
- (IBAction)add:(id)sender {
    if (self.quantity.text.length>0) {
     self.quantity.text = [NSString stringWithFormat:@"%d",self.quantity.text.intValue +1];
        if ([self.delegate respondsToSelector:@selector(updataNum:)]) {
            [self.delegate updataNum:self.quantity.text.intValue];
        }
    }
}
- (IBAction)sub:(id)sender {
    if (self.quantity.text.length>0) {
        if (self.quantity.text.intValue>0) {
            self.quantity.text = [NSString stringWithFormat:@"%d",self.quantity.text.intValue -1];
            if ([self.delegate respondsToSelector:@selector(updataNum:)]) {
                [self.delegate updataNum:self.quantity.text.intValue];
            }
        }
        
    }
}

@end
