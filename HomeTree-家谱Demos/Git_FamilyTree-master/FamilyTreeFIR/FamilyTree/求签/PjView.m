//
//  PjView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/18.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PjView.h"



@implementation PjView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    UIImageView *backIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.0422*CGRectW(self), 0.2253*CGRectH(self), 0.9141*CGRectW(self), 0.5132*CGRectH(self))];
    backIV.image = MImage(@"xjtc_bg_ct");
    backIV.userInteractionEnabled = YES;
    [self addSubview:backIV];
    
    UILabel *tipLB = [[UILabel alloc]initWithFrame:CGRectMake(0.1368*CGRectW(backIV), 0.1799*CGRectH(backIV), 0.7761*CGRectW(backIV), 0.3084*CGRectH(backIV))];
    tipLB.text = @"感谢国士供奉香火，同城家谱会将收入所得的20%捐赠给孤寡老人，是否购买破解之法?";
    tipLB.textColor = [UIColor blackColor];
    tipLB.font = MFont(14);
    tipLB.numberOfLines = 0;
    [backIV addSubview:tipLB];
    
    UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.1966*CGRectW(backIV), 0.6103*CGRectH(backIV), 0.2462*CGRectW(backIV), 0.1242*CGRectH(backIV))];
    [sureBtn setTitle:@"是" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = MFont(13);
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureBtn.backgroundColor = LH_RGBCOLOR(229, 0, 37);
    [sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [backIV addSubview:sureBtn];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5521*CGRectW(backIV), CGRectY(sureBtn), CGRectW(sureBtn), CGRectH(sureBtn))];
    [cancelBtn setTitle:@"否" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = MFont(13);
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.backgroundColor = LH_RGBCOLOR(75, 88, 91);
    [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [backIV addSubview:cancelBtn];
}

-(void)clickSureBtn{
    MYLog(@"是");
    [self.delegate clickBtnToPjZcVC];
    
}

-(void)clickCancelBtn{
    [self removeFromSuperview];
}
@end
