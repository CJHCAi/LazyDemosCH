//
//  HKFrieightPriceView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKFrieightPriceView.h"
#import "UIView+Xib.h"
@interface HKFrieightPriceView()
@property (weak, nonatomic) IBOutlet UITextField *piece;
@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UITextField *addpiece;
@property (weak, nonatomic) IBOutlet UITextField *addMoney;

@end

@implementation HKFrieightPriceView
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setupSelfNameXibOnSelf];
    [self.piece addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.money addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.addpiece addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.addMoney addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
}
-(void)textFiledDidChanged:(UITextField*)textField{
    switch (textField.tag) {
        case 0:{
            if (textField.text.length>0) {
            
            if (self.model) {
                self.model.piece = textField.text.integerValue;
            }else{
                self.subListM.piece = [textField.text integerValue];
            }
                
            }
        } break;
        case 1:{
            if (textField.text.length>0) {
                
                if (self.model) {
                    self.model.money = textField.text.integerValue;
                }else{
                    self.subListM.money = [textField.text integerValue];
                }
                
            }
        } break;
        case 2:{
            if (textField.text.length>0) {
                
                if (self.model) {
                    self.model.addPiece = textField.text.integerValue;
                }else{
                    self.subListM.addPiece = [textField.text integerValue];
                }
                
            }
        } break;
        case 3:{
            if (textField.text.length>0) {
                
                if (self.model) {
                    self.model.addMoney = textField.text.integerValue;
                }else{
                    self.subListM.addMoney = [textField.text integerValue];
                }
                
            }
        } break;
        default:
            break;
    }
    
    
        if (self.addMoney.text.length>0&&self.addpiece.text.length>0&&self.money.text.length>0&&self.piece.text.length>0) {
            if (self.subListM) {
                if (self.subListM.provinceName.length>0) {
                    self.subListM.isHasNotInput = NO;
                }else{
                    self.subListM.isHasNotInput = YES;
                }
            
            }else{
                if (self.model.provinceName.length>0) {
                    self.model.isHasNotInput = NO;
                }else{
                    self.model.isHasNotInput = YES;
                }
                
            }
        }else{
            if (self.subListM) {
            self.subListM.isHasNotInput = YES;
            }else{
                self.model.isHasNotInput = YES;
            }
        }
    
}
-(void)setModel:(HKFreightListData *)model{
    _model = model;
    self.piece.text = model.piece>0 ?[NSString stringWithFormat:@"%ld",model.piece] :@"";
    self.money.text =model.money>0? [NSString stringWithFormat:@"%ld",model.money]:@"" ;
    self.addpiece.text = model.addPiece>0?[NSString stringWithFormat:@"%ld",model.addPiece]:@"" ;
    self.addMoney.text = model.addMoney>0?[NSString stringWithFormat:@"%ld",model.addMoney]:@"" ;
}
-(void)setSubListM:(HKFreightListSublist *)subListM{
    _subListM = subListM;
    self.piece.text =subListM.piece>0? [NSString stringWithFormat:@"%ld",subListM.piece]:@"" ;
    self.money.text = subListM.money?[NSString stringWithFormat:@"%ld",subListM.money] :@"";
    self.addpiece.text = subListM.addPiece?[NSString stringWithFormat:@"%ld",subListM.addPiece] :@"";
    self.addMoney.text = subListM.addMoney>0? [NSString stringWithFormat:@"%ld",subListM.addMoney]:@"" ;
}
@end
