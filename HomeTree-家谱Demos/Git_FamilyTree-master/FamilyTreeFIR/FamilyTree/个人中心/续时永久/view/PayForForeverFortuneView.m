//
//  PayForForeverFortuneView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PayForForeverFortuneView.h"

@interface PayForForeverFortuneView()
/** 中间背景框*/
@property (nonatomic, strong) UIImageView *payForForeverFortuneIV;
/** 续时时间数组*/
@property (nonatomic, strong) NSArray *timeArr;
/** 续时时间对应的钱*/
@property (nonatomic, strong) NSArray *moneyArr;
/** 花费金币数标签*/
@property (nonatomic, strong) UILabel *costMoneyLB;
@end

@implementation PayForForeverFortuneView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //中间框
        self.payForForeverFortuneIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.0406*CGRectW(self), 0.2483*CGRectH(self), 0.9188*CGRectW(self), 0.4274*CGRectH(self))];
        self.payForForeverFortuneIV.image = MImage(@"xuShi_bg");
        self.payForForeverFortuneIV.userInteractionEnabled = YES;
        [self addSubview:self.payForForeverFortuneIV];
        //续时标签
        UILabel *continueLB = [[UILabel alloc]initWithFrame:CGRectMake(0.0748*CGRectW(self.payForForeverFortuneIV), 0.1820*CGRectH(self.payForForeverFortuneIV), 0.0986*CGRectW(self.payForForeverFortuneIV), 0.1031*CGRectH(self.payForForeverFortuneIV))];
        continueLB.text = @"续时";
        continueLB.font = MFont(13);
        [self.payForForeverFortuneIV addSubview:continueLB];
        //续时按钮
        self.timeArr = @[@"一个月",@"三个月",@"半年",@"一年",@"永久"];
        self.moneyArr = @[@100,@300,@600,@1200,@2400];
        [self initContinueBtns];
        //花费
        UILabel *costLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(continueLB), 0.5155*CGRectH(self.payForForeverFortuneIV), CGRectW(continueLB), CGRectH(continueLB))];
        costLB.text = @"花费";
        costLB.font = MFont(13);
        [self.payForForeverFortuneIV addSubview:costLB];
        //金钱数
        self.costMoneyLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(costLB)+5, CGRectY(costLB)-5, 0.2041*CGRectW(self.payForForeverFortuneIV), 20)];
        self.costMoneyLB.textColor = [UIColor redColor];
        self.costMoneyLB.textAlignment = NSTextAlignmentCenter;
        [self.payForForeverFortuneIV addSubview:self.costMoneyLB];
        CALayer *border = [CALayer layer];
        float height=self.costMoneyLB.frame.size.height-1.0f;
        float width=self.costMoneyLB.frame.size.width;
        border.frame = CGRectMake(0, height, width, 1.0f);
        border.backgroundColor = LH_RGBCOLOR(115, 115, 115).CGColor;
        [self.costMoneyLB.layer addSublayer:border];

        //金币
        UILabel *moneyLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(self.costMoneyLB)+5, CGRectY(costLB), CGRectW(costLB), CGRectH(costLB))];
        moneyLB.text =@"金币";
        moneyLB.font = MFont(13);
        [self.payForForeverFortuneIV addSubview:moneyLB];
        //确认
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.2007*CGRectW(self.payForForeverFortuneIV), 0.7010*CGRectH(self.payForForeverFortuneIV), 0.2415*CGRectW(self.payForForeverFortuneIV), 0.1546*CGRectH(self.payForForeverFortuneIV))];
        [sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = MFont(13);
        sureBtn.backgroundColor = LH_RGBCOLOR(226, 0, 37);
        sureBtn.layer.cornerRadius = 2.0;
        [sureBtn addTarget:self action:@selector(clickPayForForeverFortuneSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.payForForeverFortuneIV addSubview:sureBtn];
        
        //返回
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5476*CGRectW(self.payForForeverFortuneIV), CGRectY(sureBtn), CGRectW(sureBtn), CGRectH(sureBtn))];
        [cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = MFont(13);
        cancelBtn.backgroundColor = LH_RGBCOLOR(75, 88, 91);
        cancelBtn.layer.cornerRadius = 2.0;
        [cancelBtn addTarget:self action:@selector(clickPayForForeverFortuneCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.payForForeverFortuneIV addSubview:cancelBtn];
        
    }
    return self;
}

-(void)initContinueBtns{
    for (int i = 0; i < 5; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0.2143*CGRectW(self.payForForeverFortuneIV)+0.2313*CGRectW(self.payForForeverFortuneIV)*(i/3?(i-3):i), 0.1598*CGRectH(self.payForForeverFortuneIV)+0.1546*CGRectH(self.payForForeverFortuneIV)*(i/3), 0.1701*CGRectW(self.payForForeverFortuneIV), 0.1082*CGRectH(self.payForForeverFortuneIV))];
        button.backgroundColor = LH_RGBCOLOR(218, 220, 219);
        [button setTitle:self.timeArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = MFont(14);
        button.tag = 101+i;
        [button addTarget:self action:@selector(clickContinueBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.payForForeverFortuneIV addSubview:button];
    }
}

-(void)clickContinueBtn:(UIButton *)sender{
    self.costMoneyLB.text = [NSString stringWithFormat:@"%@", self.moneyArr[sender.tag-101]];
}

-(void)clickPayForForeverFortuneSureBtn:(UIButton *)sender{
    MYLog(@"确定充值");
    [self removeFromSuperview];
    [self.delegate clickPayForForeverFortuneSure];
}

-(void)clickPayForForeverFortuneCancelBtn:(UIButton *)sender{
    MYLog(@"取消充值");
    [self removeFromSuperview];
}

@end
