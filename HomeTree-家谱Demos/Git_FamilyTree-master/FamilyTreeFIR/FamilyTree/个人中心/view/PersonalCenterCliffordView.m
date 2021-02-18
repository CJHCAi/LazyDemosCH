//
//  PersonalCenterCliffordView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/11.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PersonalCenterCliffordView.h"
#import "DivinationViewController.h"
#import "CliffordViewController.h"

@interface PersonalCenterCliffordView()
/** 签运*/
@property (nonatomic, strong) NSMutableArray *divinationsArr;
/** 总虔诚度标签*/
@property (nonatomic, strong) UILabel *devoutDgreeNumberLB;
/** 虔诚等级标签*/
@property (nonatomic, strong) UILabel *cliffordLevelNumberLB;
@end


@implementation PersonalCenterCliffordView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgIV = [[UIImageView alloc]initWithFrame:self.bounds];
        bgIV.image = MImage(@"gr_ct_jiang_bg");
        bgIV.userInteractionEnabled = YES;
        [self addSubview:bgIV];
        //求签
        //self.divinationsArr = @[@"三等中平策",@"规规矩矩"];
       
        //祈福
//        self.cliffodLevel = 3;
//        self.devoutDgree = 310;
        [self initClifford];
        //加两个视图，区分用户是要求签还是祈福
        [self initTwoTapView];
    }
    return self;
}

-(void)initDivinationLBs{
    UIButton *divinationBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(0.2238*CGRectW(self), 10, 0.7043*CGRectW(self), 20)];
    [divinationBtn1 setBackgroundImage:MImage(@"gr_ct_jiang_jz1") forState:UIControlStateNormal];
    [divinationBtn1 setTitle:self.divinationsArr[0] forState:UIControlStateNormal];
    divinationBtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    divinationBtn1.titleLabel.font = MFont(11);
    divinationBtn1.userInteractionEnabled = NO;
    [self addSubview:divinationBtn1];
    
    UIButton *divinationBtn2 = [[UIButton alloc]initWithFrame:CGRectMake(0.2238*CGRectW(self), CGRectYH(divinationBtn1)+5, 0.7043*CGRectW(self), 20)];
    [divinationBtn2 setBackgroundImage:MImage(@"gr_ct_jiang_jz1") forState:UIControlStateNormal];
    [divinationBtn2 setTitle:self.divinationsArr[1] forState:UIControlStateNormal];
    divinationBtn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    divinationBtn2.titleLabel.font = MFont(11);
    divinationBtn2.userInteractionEnabled = NO;
    [self addSubview:divinationBtn2];
}

-(void)initClifford{
    UIImageView *cliffordIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.0839*CGRectW(self), 0.5*CGRectH(self), 0.3846*CGRectW(self), 55)];
    cliffordIV.image = MImage(@"gr_ct_jiang_todayJia");
    [self addSubview:cliffordIV];
    //虔诚度等级
    UILabel *cliffordLevelLB = [[UILabel alloc]initWithFrame:CGRectMake(0.6083*CGRectW(self), 0.6555*CGRectH(self), 0.2008*CGRectW(self), 12)];
    cliffordLevelLB.text = @"等级:";
    cliffordLevelLB.font = MFont(11);
    [self addSubview:cliffordLevelLB];
    self.cliffordLevelNumberLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(cliffordLevelLB), 0.6555*CGRectH(self)-3, 25, 15)];
    self.cliffordLevelNumberLB.font = MFont(11);
    self.cliffordLevelNumberLB.textColor = [UIColor redColor];
    [self addSubview:self.cliffordLevelNumberLB];
    //总虔诚度
    UILabel *devoutDgreeLB = [[UILabel alloc]initWithFrame:CGRectMake(0.5514*CGRectW(self), CGRectYH(cliffordLevelLB)+5, 0.2598*CGRectW(self), 12)];
    devoutDgreeLB.text = @"虔诚度:";
    devoutDgreeLB.font = MFont(11);
    [self addSubview:devoutDgreeLB];
    
    self.devoutDgreeNumberLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(devoutDgreeLB), CGRectY(devoutDgreeLB)-3, 30, 15)];
    self.devoutDgreeNumberLB.textColor = [UIColor redColor];
    self.devoutDgreeNumberLB.font = MFont(12);
    [self addSubview:self.devoutDgreeNumberLB];
}

-(void)initTwoTapView{
    //点击求签部分
    UIView *divinationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectW(self), CGRectH(self)/2)];
    divinationView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickDivinationView)];
    [divinationView addGestureRecognizer:tap1];
    [self addSubview:divinationView];
    //点击祈福部分
    UIView *cliffordView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectH(self)/2, CGRectW(self), CGRectH(self)/2)];
    cliffordView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCliffordView)];
    [cliffordView addGestureRecognizer:tap2];
    [self addSubview:cliffordView];
    
}



-(void)reloadData:(MemallInfoGrqwModel *)grqw{
    //签文
    self.divinationsArr = [NSMutableArray array];
    if (grqw.qh) {
        [self.divinationsArr addObject:[NSString stringWithFormat:@"%ld",(long)grqw.qh]];
        [self.divinationsArr addObject:grqw.qwhh];
    }else{
            [self.divinationsArr addObject:@""];
            [self.divinationsArr addObject:@""];
    }
    [self initDivinationLBs];

}

-(void)reloadDevoutData:(DevoutModel *)devout{
    self.devoutDgreeNumberLB.text =[NSString stringWithFormat:@"%@",@(devout.qcdz)];
    self.cliffordLevelNumberLB.text = devout.qcdch;
}

-(void)clickDivinationView{
    MYLog(@"求签");
    DivinationViewController *divVc = [[DivinationViewController alloc] initWithTitle:@"灵签" image:nil];
    [[self viewController].navigationController pushViewController:divVc animated:YES];
}
-(void)clickCliffordView{
    MYLog(@"祈福");
    CliffordViewController *cliVC = [[CliffordViewController alloc]initWithTitle:@"祈福" image:nil];
    [[self viewController].navigationController pushViewController:cliVC animated:YES];
}


@end
