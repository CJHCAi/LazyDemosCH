//
//  JoinShoppingVIew.m
//  LD_app_ios_NetWin
//
//  Created by 苟应航 on 2018/7/27.
//  Copyright © 2018年 lddtgroup. All rights reserved.
//

#import "JoinShoppingVIew.h"
@interface JoinShoppingVIew()
{
    UIImageView *_iconimg; // 索璐图
    
    UILabel *_shoptitile; // 文字标题
    
    UILabel *_dinPrice; //定金
    
    UILabel *_newspricelabe; //金额
    
    UILabel *_endtimelabe; //结束时间
    
    
    UILabel *_capacityredlbae; //容量
    UILabel *_numberx;
    NSInteger _intdex;
    
    BOOL _prepaidbool;
}
@end
@implementation JoinShoppingVIew

-(instancetype)initWithFrame:(CGRect)frame sender:(NSInteger)sender String:(NSString *)string Backcolor:(UIColor *)backcolor Textcolor:(UIColor *)textcolor prepaidbool:(BOOL)prepaidbool{
    if (self=[super initWithFrame:frame]) {
        _prepaidbool=prepaidbool;
        _intdex=1;
        UIView *Allview=[UIView new];
        Allview.backgroundColor=Kwhite;
        [self addSubview:Allview];
        [Allview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(340*SCALEWITH6);
        }];
        
        UIButton *joinbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [joinbtn addTarget:self action:@selector(joinbtnaction:) forControlEvents:UIControlEventTouchUpInside];
        [joinbtn setTitle:string forState:UIControlStateNormal];
        [joinbtn setTitleColor:textcolor forState:UIControlStateNormal];
        joinbtn.titleLabel.font=GHFont(14);
        joinbtn.layer.cornerRadius=5;
        joinbtn.backgroundColor=backcolor;
        joinbtn.tag=sender;
        [Allview addSubview:joinbtn];
        [joinbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(Allview.mas_centerX);
            make.bottom.mas_equalTo(Allview.mas_bottom).mas_offset(SCREEN_HEIGHT==812?-15*SCALEWITH6:-10*SCALEWITH6);
            make.width.mas_equalTo(140*SCALEWITH6);
            make.height.mas_equalTo(40*SCALEWITH6);
        }];
        
        UILabel *leanlabe=[UILabel new];
        leanlabe.backgroundColor=lencolor;
        [Allview addSubview:leanlabe];
        [leanlabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(joinbtn.mas_top).mas_offset(-10*SCALEWITH6);
            make.height.mas_equalTo(1);
        }];
        
        UIImageView *iconimg=[UIImageView new];
        [iconimg sd_setImageWithURL:[NSURL URLWithString:@"https://img.alicdn.com/imgextra/i2/2669183559/TB22jOKFAOWBuNjSsppXXXPgpXa_!!2669183559.png"] placeholderImage:nil];
        [Allview  addSubview:iconimg];
         _iconimg=iconimg;
        [iconimg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20*SCALEWITH6);
            make.top.mas_equalTo(20*SCALEWITH6);
            make.width.mas_equalTo(100*SCALEWITH6);
            make.height.mas_equalTo(80*SCALEWITH6);
        }];
        
        UILabel *exprlabes=[UILabel new];
        exprlabes.textColor=AlltexthighlightedColor;
        exprlabes.font=GHFont(14);
        exprlabes.text=@"邮费    购买酒一件，全国免邮费";
        [Allview addSubview:exprlabes];
        [exprlabes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_iconimg.mas_left);
            make.top.mas_equalTo(self->_iconimg.mas_bottom).mas_offset(10*SCALEWITH6);
            make.height.mas_equalTo(60);
        }];
        
        
        
        UILabel *shoptitile=[UILabel new];
        shoptitile.numberOfLines=2;
        shoptitile.font=GHSonBole(12);
        shoptitile.text=@"茅台 金王子 53度 白酒 500ml 单瓶装 口感酱香型";
        shoptitile.textColor=AlltexthighlightedColor;
        [Allview  addSubview:shoptitile];
        _shoptitile=shoptitile;
        [shoptitile mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(iconimg.mas_top);
            make.left.mas_equalTo(iconimg.mas_right).mas_offset(20*SCALEWITH6);
            make.right.mas_equalTo(Allview.mas_right).mas_offset(-20*SCALEWITH6);
        }];
        
     
            UILabel *newspricelabe=[UILabel new];
            newspricelabe.font=GHFont(14);
            newspricelabe.textColor=AllxianBinColor;
            newspricelabe.text=@"1253.02元";
            [Allview  addSubview:newspricelabe];
            _newspricelabe=newspricelabe;
            [newspricelabe mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(shoptitile.mas_left);
                make.bottom.mas_equalTo(iconimg.mas_bottom);
            }];
        
        
        UILabel *numberlbae=[UILabel new];
        numberlbae.text=@"数量";
        numberlbae.textColor=AlltexthighlightedColor;
        numberlbae.font=GHFont(14);
        [Allview addSubview:numberlbae];
        [numberlbae mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconimg.mas_left);
            make.bottom.mas_equalTo(leanlabe.mas_top).mas_offset(-30*SCALEWITH6);
         }];
        
        
        UIView *addviews=[UIView new];
        addviews.layer.borderColor=lencolor.CGColor;
        addviews.layer.borderWidth=1;
        [Allview addSubview:addviews];
        [addviews mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(numberlbae.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(numberlbae.mas_centerY);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(120*SCALEWITH6);
        }];
        
        UIButton *minusBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [minusBtn setTitle:@"-" forState:UIControlStateNormal];
        [minusBtn setTitleColor:AlltexthighlightedColor forState:UIControlStateNormal];
        [minusBtn addTarget:self action:@selector(minadction:) forControlEvents:UIControlEventTouchUpInside];
        minusBtn.titleLabel.font=GHFont(20);
        [addviews addSubview:minusBtn];
        [minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(addviews.mas_left);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(addviews.mas_height);
            make.width.mas_equalTo(40*SCALEWITH6);
        }];
        
        UILabel *numberlabes=[UILabel new];
        numberlabes.text=@"1";
        //    numberlabes.keyboardType=UIKeyboardTypeNumberPad;
        numberlabes.textAlignment=NSTextAlignmentCenter;
        numberlabes.textColor=AlltexthighlightedColor;
        numberlabes.font=GHFont(14);
        [addviews addSubview:numberlabes];
        _numberx=numberlabes;
        [numberlabes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(minusBtn.mas_right);
            make.height.mas_equalTo(addviews.mas_height);
            make.width.mas_equalTo(40*SCALEWITH6);
        }];
        
        
        
        UIButton *maxBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [maxBtn setTitle:@"+" forState:UIControlStateNormal];
        [maxBtn setTitleColor:AlltexthighlightedColor forState:UIControlStateNormal];
        [maxBtn addTarget:self action:@selector(maxdction:) forControlEvents:UIControlEventTouchUpInside];
        maxBtn.titleLabel.font=GHFont(20);
        [addviews addSubview:maxBtn];
        [maxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(numberlabes.mas_right);
            make.height.mas_equalTo(addviews.mas_height);
            make.width.mas_equalTo(40*SCALEWITH6);
        }];
        
        UILabel *minusBtnleanlabe=[UILabel new];
        minusBtnleanlabe.backgroundColor=lencolor;
        [addviews addSubview:minusBtnleanlabe];
        [minusBtnleanlabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(minusBtn.mas_right);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(1);
        }];
        
        UILabel *numberlabeslabe=[UILabel new];
        numberlabeslabe.backgroundColor=lencolor;
        [addviews addSubview:numberlabeslabe];
        [numberlabeslabe mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(numberlabes.mas_right);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(1);
        }];
        
        UILabel *capacitylbae=[UILabel new];
        capacitylbae.text=@"容量";
        capacitylbae.textColor=AlltexthighlightedColor;
        capacitylbae.font=GHFont(14);
        [Allview addSubview:capacitylbae];
        [capacitylbae mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconimg.mas_left);
            make.bottom.mas_equalTo(numberlabes.mas_top).mas_offset(-30*SCALEWITH6);
        }];
        
        UILabel *capacityredlbae=[UILabel new];
        capacityredlbae.text=@"500ml";
        capacityredlbae.textColor=[UIColor redColor];
        capacityredlbae.layer.borderColor=[UIColor redColor].CGColor;
        capacityredlbae.layer.borderWidth=1;
        capacityredlbae.textAlignment=NSTextAlignmentCenter;
        capacityredlbae.font=GHFont(14);
        [Allview addSubview:capacityredlbae];
        _capacityredlbae=capacityredlbae;
        [capacityredlbae mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(addviews.mas_left);
            make.centerY.mas_equalTo(capacitylbae.mas_centerY);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(30);
        }];
        
    }
    return self;
}
-(void)minadction:(UIButton *)sender{

    _intdex--;
    if (_intdex<=0) {
        _intdex=1;
    }
    _numberx.text=[NSString stringWithFormat:@"%ld",_intdex];
    
}
-(void)maxdction:(UIButton *)sender{
   
     _intdex++;
  
    _numberx.text=[NSString stringWithFormat:@"%ld",_intdex];
}
-(void)setModel:(ShopModel *)model{
    _model=model;
 
    
}

-(void)joinbtnaction:(UIButton *)sender{

  
    [self.delegate JoinOrBayAction:sender.tag count:_intdex];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
