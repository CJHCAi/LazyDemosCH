//
//  HKLeBuyShoppingCartTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/15.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeBuyShoppingCartTableViewCell.h"
#import "UIView+BorderLine.h"
#import "UIImageView+HKWeb.h"
#import "ConfirmationOfOrderFootVIew.h"
@interface HKLeBuyShoppingCartTableViewCell()<ConfirmationOfOrderFootVIewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *subtraction;
@property (weak, nonatomic) IBOutlet UIButton *addition;
@property (weak, nonatomic) IBOutlet UIImageView *iconVIew;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UILabel *precle;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineW;
@property (weak, nonatomic) IBOutlet ConfirmationOfOrderFootVIew *footView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deductibleW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deductidleTop;
@property (weak, nonatomic) IBOutlet ConfirmationOfOrderFootVIew *deductible;
@end

@implementation HKLeBuyShoppingCartTableViewCell

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
    self.footView.delegate = self;
    self.deductible.delegate = self;
    self.deductible.integral = 0;
}
-(void)passConTextChange:(UITextField*)textField{
    if ([self.delegate respondsToSelector:@selector(numChange:products:)]) {
        [self.delegate numChange:(textField.text.integerValue - self.model.number)*self.model.integral products:self.model];
    }
    self.model.number = textField.text.integerValue;
}
- (IBAction)subtraction:(id)sender {
    if (self.quantity.text.integerValue>0) {
        self.quantity.text = [NSString stringWithFormat:@"%ld",self.quantity.text.integerValue-1];
        self.model.number --;
         self.precle.text = [NSString stringWithFormat:@"￥%.2lf",self.model.integral*self.model.number];
        if ([self.delegate respondsToSelector:@selector(numChange:products:)]) {
            [self.delegate numChange:-self.model.integral products:self.model];
        }
    }
    
}
- (IBAction)add:(id)sender {
    self.model.number ++;
    self.quantity.text = [NSString stringWithFormat:@"%ld",self.quantity.text.integerValue+1];
    self.precle.text = [NSString stringWithFormat:@"￥%.2lf",self.model.integral*self.model.number];
    if ([self.delegate respondsToSelector:@selector(numChange:products:)]) {
        [self.delegate numChange:self.model.integral products:self.model];
    }
}
-(void)setOrderData:(HKConfirmationOfOrderData *)orderData{
    _orderData = orderData;
    [self.deductible setDeductible:orderData.userIntegral countOffsetCoin:orderData.countOffsetCoin];
    
}
-(void)setModel:(getCartListDataProducts *)model{
    _model = model;
    [self.iconVIew hk_sd_setImageWithURL:model.imgSrc placeholderImage:kPlaceholderImage];
    self.precle.text = [NSString stringWithFormat:@"￥%.2lf",model.integral*model.number];
    self.quantity.text = [NSString stringWithFormat:@"%ld",model.number];
    self.descL.text = [NSString stringWithFormat:@"%@ | %@",model.colorName,model.specName];
    self.selectBtn.selected = model.isSelect;
    self.nameL.text= model.title;
    
    if (model.couponId.length>0) {
        self.footView.isSelected = YES;
    }else{
         self.footView.isSelected = NO;
    }
//    self.deductible.integral = model.integral;
}
-(void)selectCoin:(BOOL)isCoin{
    if ([self.delegate respondsToSelector:@selector(selectCoinWithIsCoin:getCartListDataProducts:)]) {
        [self.delegate selectCoinWithIsCoin:isCoin getCartListDataProducts:self.model];
    }
}
-(void)translateGoods{
    if ([self.delegate respondsToSelector:@selector(translateList:)]) {
        [self.delegate translateList:self.model];
    }
}
- (IBAction)selectGood:(id)sender {
    self.model.isSelect =  !self.model.isSelect;
    if ([self.delegate respondsToSelector:@selector(selectCartListDataProducts:isSelect:indexPath:)]) {
        [self.delegate selectCartListDataProducts:self.model isSelect:self.model.isSelect indexPath:self.indexPath];
    }
}
-(void)setIsHideLeft:(BOOL)isHideLeft{
    _isHideLeft = isHideLeft;
    if (isHideLeft) {
        self.selectBtn.hidden = YES;
        self.actionW.constant = 15;
        self.actionBtn.hidden = YES;
        self.lineW.constant = 0;
        if (self.model.couponCount>0) {
            self.deductidleTop.constant = 123;
            self.footView.hidden = NO;
            self.footView.couponCount = self.model.couponCount;
        }else{
            self.deductidleTop.constant = 73;
            self.footView.hidden = YES;
        }
        
        self.deductible.hidden = NO;
    }else{
        self.selectBtn.hidden = NO;
        self.actionW.constant = 44;
        self.actionBtn.hidden = NO;
        self.lineW.constant = 10;
        self.footView.hidden = YES;
        self.deductible.hidden = YES;
        self.deductidleTop.constant = 23;
        
    }
}
- (IBAction)gotoINfo:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoInfo:)]) {
        [self.delegate gotoInfo:self.model];
    }
}
@end
