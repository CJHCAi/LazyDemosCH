//
//  HK_VipFooterView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_VipFooterView.h"

@interface HK_VipFooterView ()
@property (nonatomic, strong)UILabel * footLabel;
@property (nonatomic, strong)UIImageView * AppIconView;

@end


@implementation HK_VipFooterView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
       self.backgroundColor = MainColor
        [self addSubview:self.footLabel];
        [self addSubview:self.AppIconView];
    }
    return  self;
}
-(UILabel *)footLabel {
    if (!_footLabel) {
        _footLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,10,kScreenWidth,10)];
        [AppUtils getConfigueLabel:_footLabel font:PingFangSCRegular10 aliment:NSTextAlignmentCenter textcolor:RGB(153,153,153) text:@"亲 我也是有底线的"];
    }
    return _footLabel;
}
-(UIImageView *)AppIconView {
    if (!_AppIconView) {
        _AppIconView =[[UIImageView alloc] initWithFrame:CGRectMake(15,CGRectGetMaxY(self.footLabel.frame)+25,kScreenWidth-30,90)];
//        _AppIconView.contentMode = UIViewContentModeScaleAspectFill;
//        _AppIconView.layer.masksToBounds = YES;
        _AppIconView.image =[UIImage imageNamed:@"sy_xzwp"];
    }
    return _AppIconView;
}

@end
