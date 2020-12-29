//
//  Hk_detailFooterView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/30.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "Hk_detailFooterView.h"

@interface Hk_detailFooterView ()

@property (nonatomic, copy) NSString * states;

@end

@implementation Hk_detailFooterView

+(instancetype)initWithFrame:(CGRect)frame OrderStatus:(NSString *)states {
   
    Hk_detailFooterView *cycleScrollView = [[self alloc] initWithFrame:frame withStatus:states];

   cycleScrollView.backgroundColor = UICOLOR_RGB_Alpha(0xf2f2f2, 1);
    return cycleScrollView;
}
- (instancetype)initWithFrame:(CGRect)frame withStatus:(NSString *)states {

    if (self = [super initWithFrame:frame]) {
        
        self.states =states;
        [self setupMainView];
    }
    return self;
}

-(void)setupMainView {

    UIView * contentV =[[UIView alloc] initWithFrame:CGRectMake(0,10,kScreenWidth,50)];
    contentV.backgroundColor =[UIColor whiteColor];
    contentV.userInteractionEnabled = YES;
    [self addSubview:contentV];
  //已完成 已取消 添加2个按钮 联系卖家 和 在线客服
    if ([self.states isEqualToString:@"7"] ||[self.states isEqualToString:@"8"]) {
        for (int i=0; i<2; i++) {
            CGFloat BtnW = kScreenWidth/2;
            NSArray * titles =@[@"联系卖家",@"在线客服"];
            UIButton * clickB =[UIButton buttonWithType:UIButtonTypeCustom];
            clickB.frame = CGRectMake(i*BtnW,0,BtnW,50);
            [clickB setTitle:titles[i] forState:UIControlStateNormal];
            clickB.titleLabel.font = PingFangSCRegular14;
            [clickB setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
            clickB.tag =100+i;
            if (i==0) {
                UIView * linv =[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(clickB.frame),15,1,20)];
            linv.backgroundColor =[UIColor colorFromHexString:@"e2e2e2"];
                [clickB setImage:[UIImage imageNamed:@"dynamic_comment"] forState:UIControlStateNormal];
                [contentV addSubview:linv];
            }else {
                [clickB setImage:[UIImage imageNamed:@"productDestail_service"] forState:UIControlStateNormal];
            }
            [clickB addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
            [contentV addSubview:clickB];
        }
    }else {
        UIButton * clickB =[UIButton buttonWithType:UIButtonTypeCustom];
        clickB.frame = CGRectMake(0,0,kScreenWidth,50);
        clickB.titleLabel.font = PingFangSCRegular14;
        [clickB setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
        [clickB setTitle:@"在线客服" forState:UIControlStateNormal];
        [clickB setImage:[UIImage imageNamed:@"productDestail_service"] forState:UIControlStateNormal];
        [clickB addTarget:self action:@selector(contact:) forControlEvents:UIControlEventTouchUpInside];
        [contentV addSubview:clickB];
        clickB.tag =150;
    }
}

-(void)contact:(UIButton *)sender {
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(ClickFootBtnWithTag:)]) {
        [self.delegete ClickFootBtnWithTag:sender.tag];
    }
}


@end
