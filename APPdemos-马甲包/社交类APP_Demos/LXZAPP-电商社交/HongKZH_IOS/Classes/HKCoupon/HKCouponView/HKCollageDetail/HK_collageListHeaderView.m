//
//  HK_collageListHeaderView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_collageListHeaderView.h"

#import "UIButton+LXMImagePosition.h"

#import "HK_CollageBtn.h"
@interface HK_collageListHeaderView ()

@end
@implementation HK_collageListHeaderView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
        [self SetUI];
    }
    return self;
}

-(void)SetUI {
    NSArray * btnTitleArr  =@[@"最新",@"价格",@"销量",@"分类"];
    CGFloat btnW = kScreenWidth / btnTitleArr.count;
    CGFloat btnH = 40;
    //销量和分类选择图标
    UIImage * recruit_downIM =[UIImage imageNamed:@"recruit_down"];
    //价格默认图标
    UIImage *priceIM =[UIImage imageNamed:@"news_pce"];
    for (int i= 0; i< btnTitleArr.count; i++) {
        HK_CollageBtn * rowBtn=[HK_CollageBtn buttonWithType:UIButtonTypeCustom];
        rowBtn.frame = CGRectMake(i*btnW,0,btnW,btnH);
        [rowBtn setTitle:btnTitleArr[i] forState:UIControlStateNormal];
        [rowBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
        rowBtn.titleLabel.font = PingFangSCRegular14;
        rowBtn.tag = 1000+i;
        [rowBtn addTarget:self action:@selector(setClick:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 1:
            {
                [rowBtn setImage:priceIM forState:UIControlStateNormal];
                [rowBtn setImagePosition:1 spacing:2
                 ];
                rowBtn.states= 1;
            }
                break;
            case 2:
            case 3:
            {
                [rowBtn setImage:recruit_downIM forState:UIControlStateNormal];
                [rowBtn setImagePosition:1 spacing:2];
            }
                break;
            default:
                break;
        }
        [self addSubview:rowBtn];
    }
}
-(void)setClick:(HK_CollageBtn *)sender {
    if (self.delegete && [self.delegete respondsToSelector:@selector(changeRowBtnWithIndex:andSender:)]) {
        [self.delegete changeRowBtnWithIndex:sender.tag-1000 andSender:sender];
    }
}
@end
