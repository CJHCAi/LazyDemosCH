//
//  HKDeleverView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDeleverView.h"

@interface HKDeleverView ()


@end

@implementation HKDeleverView

-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        [self layoutSubviews];
    }
    return  self;
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    CGFloat btnW  =kScreenWidth /2;
    CGFloat btnH  =49;
    UIView * topV =[[UIView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,1)];
    topV.backgroundColor = RGB(224,224,224);
    [self addSubview:topV];
    NSArray * titles =@[@"立即沟通",@"应聘职位"];
    for (int i =0; i< titles.count; i++) {
        UIButton * btn =[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*btnW,1,btnW,btnH);
        if (i==0) {
            [btn setTitleColor:[UIColor colorFromHexString:@"666666"] forState:UIControlStateNormal];
            btn.backgroundColor =[UIColor colorFromHexString:@"fefefe"];
        }else {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor =[UIColor colorFromHexString:@"4a91df"];
        }
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font =PingFangSCRegular16;
        btn.tag =i+100;
        [self addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)btnClick:(UIButton *)sender {
    if (self.sendBlock) {
        self.sendBlock(sender.tag-100, sender);
    }
}
@end
