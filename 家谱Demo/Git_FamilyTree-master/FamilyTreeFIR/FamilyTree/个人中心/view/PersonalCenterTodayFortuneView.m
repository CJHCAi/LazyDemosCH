//
//  PersonalCenterTodayFortuneView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PersonalCenterTodayFortuneView.h"
#import "DrawStarsView.h"

@interface PersonalCenterTodayFortuneView()
/** 今日运势星级数组*/
@property (nonatomic, strong) NSMutableArray *starNumberArr;
@end

@implementation PersonalCenterTodayFortuneView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgIV = [[UIImageView alloc]initWithFrame:self.bounds];
        bgIV.image = MImage(@"gr_ct_ys_bg");
        bgIV.layer.shadowColor = [UIColor clearColor].CGColor;
        bgIV.layer.shadowOffset = CGSizeMake(2, 2);
        [self addSubview:bgIV];
        //今日运势
        UILabel *todayFortuneLB = [[UILabel alloc]initWithFrame:CGRectMake(0.0350*CGRectW(self), 15,0.4046*CGRectW(self), 0.1261*CGRectH(self))];
        todayFortuneLB.text = @"今日运势";
        todayFortuneLB.textAlignment = NSTextAlignmentCenter;
        todayFortuneLB.font = MFont(14);
        [self addSubview:todayFortuneLB];
        //续时运势
        UIButton *payForFortuneBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectXW(todayFortuneLB)+5, 15, 0.3077*CGRectW(self), 13)];
        [payForFortuneBtn setTitle:@"续时运势" forState:UIControlStateNormal];
        payForFortuneBtn.backgroundColor = [UIColor redColor];
        payForFortuneBtn.titleLabel.font = MFont(10);
        [payForFortuneBtn addTarget:self action:@selector(payForFortune:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:payForFortuneBtn];
        //运势
        //[self initFortuneStar];
    }
    return self;
}

-(void)initFortuneStar{
    NSArray *strArr = @[@"综合 :",@"桃花 :",@"事业 :",@"财富 :"];
    //self.starNumberArr = @[@3,@5,@3,@4];
    for (int i = 0; i < 4; i++) {
        UILabel *fortuneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.0745*CGRectW(self), 0.3015*CGRectH(self)+0.1695*CGRectH(self)*i, 0.2416*CGRectW(self), 0.1695*CGRectH(self))];
        fortuneLabel.font = MFont(12);
        fortuneLabel.text = strArr[i];
        [self addSubview:fortuneLabel];
        DrawStarsView *starsView = [[DrawStarsView alloc]initWithFrame:CGRectMake(CGRectXW(fortuneLabel), CGRectY(fortuneLabel)+3, 0.5*CGRectW(self), 13) SetRedNumber:[self.starNumberArr[i] intValue] SetRedImage:[UIImage imageNamed:[NSString stringWithFormat:@"gr_ct_ys_%d",i]] SetNormalImage:[UIImage imageNamed:[NSString stringWithFormat:@"gr_ct_ys_gray%d",i]]];
        [self addSubview:starsView];
        
    }
}


//点击续时运势
-(void)payForFortune:(UIButton *)sender{
    MYLog(@"点击续时运势");
   [self.delegate clickPayForFortuneBtn];
    
}

-(void)reloadData:(MemallInfoGrysModel *)grys{
    //运势星级
    self.starNumberArr = [NSMutableArray array];
    if (grys.all) {
        [self.starNumberArr addObject:@([grys.all intValue]/20)];
        [self.starNumberArr addObject:@([grys.love intValue]/20)];
        [self.starNumberArr addObject:@([grys.work intValue]/20)];
        [self.starNumberArr addObject:@([grys.money intValue]/20)];
    }else{
        [self.starNumberArr addObject:@0];
        [self.starNumberArr addObject:@0];
        [self.starNumberArr addObject:@0];
        [self.starNumberArr addObject:@0];
    }
     [self initFortuneStar];
}



@end
