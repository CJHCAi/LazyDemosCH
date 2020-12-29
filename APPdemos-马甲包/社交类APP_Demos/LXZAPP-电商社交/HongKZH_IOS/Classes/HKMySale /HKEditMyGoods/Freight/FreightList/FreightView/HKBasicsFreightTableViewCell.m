//
//  HKBasicsFreightTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBasicsFreightTableViewCell.h"
#import "HKFrieightPriceView.h"
@interface HKBasicsFreightTableViewCell()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *desclabel;
@property (weak, nonatomic) IBOutlet HKFrieightPriceView *editView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;

@end

@implementation HKBasicsFreightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
     [self.nameTextField addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
}
-(void)textFiledDidChanged:(UITextField*)textField{
    self.model.name = textField.text;
}
-(void)setModel:(HKFreightListData *)model{
    _model = model;
    self.editView.model = model;
    self.nameTextField.text = model.name;
    if (model.isExcept.integerValue == 1) {
        self.desclabel.text = [NSString stringWithFormat:@"偏远地区：%@",model.provinceName];
        self.rightIcon.hidden = NO;
        self.btn.hidden = NO;
    }else{
        self.desclabel.text = @"默认（除指定地区外）运费：";
        self.rightIcon.hidden = YES;
        self.btn.hidden = YES;
    }
   
}
-(void)btnClick:(UIButton*)sender{
    if ([self.delegate respondsToSelector:@selector(selectProWithModelListData:)]) {
        [self.delegate selectProWithModelListData:self.model];
    }
    
}
@end
