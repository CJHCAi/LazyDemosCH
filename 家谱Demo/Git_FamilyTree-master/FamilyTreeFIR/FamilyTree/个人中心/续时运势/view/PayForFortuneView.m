//
//  PayForFortuneView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PayForFortuneView.h"
#import "CALayer+drawborder.h"
@implementation PayForFortuneView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //设置中间框背景
        UIImageView *payForFortuneIV = [[UIImageView alloc]initWithFrame:CGRectMake(0.0406*CGRectW(self), 0.2737*CGRectH(self), 0.9188*CGRectW(self), 0.4253*CGRectH(self))];
        payForFortuneIV.image = MImage(@"xuShi_bg");
        payForFortuneIV.userInteractionEnabled = YES;
        [self addSubview:payForFortuneIV];
        //续时提示语
        UILabel *payForFortuneLB = [[UILabel alloc]initWithFrame:CGRectMake(0.1429*CGRectW(payForFortuneIV), 0.1897*CGRectH(payForFortuneIV), 0.7653*CGRectW(payForFortuneIV), 0.1322*CGRectH(payForFortuneIV))];
        payForFortuneLB.text = @"是否花费10积分续时我的运程一天？";
        payForFortuneLB.font = MFont(13);
        [payForFortuneIV addSubview:payForFortuneLB];
        //确定按钮
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.2007*CGRectW(payForFortuneIV), 0.4425*CGRectH(payForFortuneIV), 0.2449*CGRectW(payForFortuneIV), 0.1609*CGRectH(payForFortuneIV))];
        sureBtn.backgroundColor = LH_RGBCOLOR(226, 0, 37);
        [sureBtn setTitle:@"是" forState:UIControlStateNormal];
        sureBtn.titleLabel.font = MFont(14);
        sureBtn.layer.cornerRadius = 2.0;
        [sureBtn addTarget:self action:@selector(clickPayForFortuneSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [payForFortuneIV addSubview:sureBtn];
        //取消按钮
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.5476*CGRectW(payForFortuneIV), CGRectY(sureBtn), CGRectW(sureBtn), CGRectH(sureBtn))];
        cancelBtn.backgroundColor = LH_RGBCOLOR(75, 88, 91);
        [cancelBtn setTitle:@"否" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = MFont(14);
        cancelBtn.layer.cornerRadius = 2.0;
        [cancelBtn addTarget:self action:@selector(clickPayForFortuneCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [payForFortuneIV addSubview:cancelBtn];
        
//        //续时永久按钮
//        UIButton *PayForforeverFortuneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.6497*CGRectW(payForFortuneIV), 0.7071*CGRectH(payForFortuneIV), 0.2313*CGRectW(payForFortuneIV), 0.1092*CGRectH(payForFortuneIV))];
//        PayForforeverFortuneBtn.backgroundColor = [UIColor clearColor];
//        [PayForforeverFortuneBtn setTitle:@"续时永久？" forState:UIControlStateNormal];
//        PayForforeverFortuneBtn.titleLabel.font = MFont(13);
//        [PayForforeverFortuneBtn setTitleColor:LH_RGBCOLOR(115, 115, 115) forState:UIControlStateNormal];
//        [PayForforeverFortuneBtn addTarget:self action:@selector(clickToPayForForeverFortuneBtn:) forControlEvents:UIControlEventTouchUpInside];
//        
//        CALayer *border = [CALayer layer];
//        float height=PayForforeverFortuneBtn.frame.size.height-1.0f;
//        float width=PayForforeverFortuneBtn.frame.size.width;
//        border.frame = CGRectMake(0, height, width, 1.0f);
//        border.backgroundColor = LH_RGBCOLOR(115, 115, 115).CGColor;
//        [PayForforeverFortuneBtn.layer addSublayer:border];
//        [payForFortuneIV addSubview:PayForforeverFortuneBtn];
    }
    return self;
}

-(void)clickPayForFortuneSureBtn:(UIButton *)sender{
    MYLog(@"确定续时运势");
    NSDictionary *logDic = @{@"userid":[NSString stringWithFormat:@"%@",GetUserId],@"daynum":@1};
    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeMemySadd success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        MYLog(@"%@",jsonDic[@"data"]);
        if (succe) {
            
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    
    [self removeFromSuperview];
}

-(void)clickPayForFortuneCancelBtn:(UIButton *)sender{
    MYLog(@"取消");
    [self removeFromSuperview];
}

-(void)clickToPayForForeverFortuneBtn:(UIButton *)sender{
    MYLog(@"点击续时永久");
    [self.delegate toPayForForeverFortuneView];
    [self removeFromSuperview];
}
@end
