//
//  PersonalCenterHeaderView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/3.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PersonalCenterHeaderView.h"

@interface PersonalCenterHeaderView()
/** 金钱视图*/
@property (nonatomic, strong) UIView *moneyView;
/** 金钱标签*/
@property (nonatomic, strong) UILabel *moneyLB;
/** 同城币视图*/
@property (nonatomic, strong) UIView *sameCityMoneyView;
/** 积分标签*/
@property (nonatomic, strong) UILabel *integralLB;
@end


@implementation PersonalCenterHeaderView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMoneyView];
        [self initSameCityMoneyView];
        [self initVipBtn];
    }
    return self;
}

//金钱视图
-(void)initMoneyView{
    self.moneyView = [[UIView alloc]initWithFrame:CGRectMake(0.47*Screen_width, 8, 0.233*Screen_width, CGRectH(self)/7*4)];
    self.moneyView.backgroundColor = [UIColor whiteColor];
    self.moneyView.layer.borderWidth = 1;
    self.moneyView.layer.borderColor = LH_RGBCOLOR(225, 225, 225).CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMoneyView:)];
    [self.moneyView addGestureRecognizer:tap];
    [self addSubview:self.moneyView];
    //左边加号
    UIImageView *addIV = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, CGRectH(self.moneyView)-8, CGRectH(self.moneyView)-8)];
    addIV.image = MImage(@"human_add");
    [self.moneyView addSubview:addIV];
    
    //中间金钱
    self.moneyLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(addIV), 0, CGRectW(self.moneyView)-2*CGRectW(addIV)-8, CGRectH(self.moneyView))];
    self.moneyLB.text = [NSString stringWithFormat:@"¥%.1lf",self.money];
    self.moneyLB.font = MFont(13);
    self.moneyLB.textAlignment = NSTextAlignmentCenter;
    [self.moneyView addSubview:self.moneyLB];
    
    //右侧钱袋
    UIImageView *moneyBagIV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectXW(self.moneyLB)+3, 4, CGRectW(addIV)-3, CGRectH(addIV))];
    moneyBagIV.image = MImage(@"human_redMoney");
    [self.moneyView addSubview:moneyBagIV];
    
    
}

//同城币视图
-(void)initSameCityMoneyView{
    self.sameCityMoneyView = [[UIView alloc]initWithFrame:CGRectMake(0.727*Screen_width, 8, 0.233*Screen_width, CGRectH(self)/7*4)];
    self.sameCityMoneyView.backgroundColor = [UIColor whiteColor];
    self.sameCityMoneyView.layer.borderWidth = 1;
    self.sameCityMoneyView.layer.borderColor = LH_RGBCOLOR(225, 225, 225).CGColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSameCityMoneyView:)];
    [self.sameCityMoneyView addGestureRecognizer:tap];
    [self addSubview:self.sameCityMoneyView];
    //左边加号
    UIImageView *addIV = [[UIImageView alloc]initWithFrame:CGRectMake(4, 4, CGRectH(self.sameCityMoneyView)-8, CGRectH(self.sameCityMoneyView)-8)];
    addIV.image = MImage(@"human_add");
    [self.sameCityMoneyView addSubview:addIV];
    
    //中间金钱
    self.integralLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(addIV), 0, CGRectW(self.moneyView)-2*CGRectW(addIV)-8, CGRectH(self.moneyView))];
    self.integralLB.text = [NSString stringWithFormat:@"%ld",(long)self.sameCityMoney];
    self.integralLB.font = MFont(13);
    self.integralLB.textAlignment = NSTextAlignmentCenter;
    [self.sameCityMoneyView addSubview:self.integralLB];
    
    //右侧钱袋
    UIImageView *moneyBagIV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectXW(self.integralLB), 4, CGRectW(addIV), CGRectH(addIV))];
    moneyBagIV.image = MImage(@"human_ss");
    [self.sameCityMoneyView addSubview:moneyBagIV];
 
}

-(void)initVipBtn{
    self.vipBtn = [[UIButton alloc]init];
    self.vipBtn.titleLabel.font = MFont(15);
    [self.vipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.vipBtn addTarget:self action:@selector(clickVipBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.vipBtn];
    self.vipBtn.sd_layout.leftSpaceToView(self,5).bottomSpaceToView(self,5).topSpaceToView(self, 5).widthIs(35);
}

-(void)setMoney:(double)money{
    _money = money;
    self.moneyLB.text = [NSString stringWithFormat:@"¥%.1lf",self.money];
}

-(void)setSameCityMoney:(NSInteger)sameCityMoney{
    _sameCityMoney = sameCityMoney;
    self.integralLB.text = [NSString stringWithFormat:@"%ld",(long)self.sameCityMoney];
}


-(void)clickMoneyView:(UIButton *)sender{
    MYLog(@"点击了金钱视图");
    [self.delegate clickMoneyViewToPay];
    
}

-(void)clickSameCityMoneyView:(UIButton *)sender{
    MYLog(@"点击了同城币视图");
    [self.delegate clickSameCityMoneyViewToPay];
}

-(void)clickVipBtn:(UIButton *)sender{
    MYLog(@"点击了Vip");
    [self.delegate clickVipBtn:sender];
}
@end
