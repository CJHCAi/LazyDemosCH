//
//  HK_AboutHeaderView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_AboutHeaderView.h"

@interface HK_AboutHeaderView ()
@property (nonatomic, strong) UIImageView * icon ;
@property (nonatomic, strong) UILabel * vison;
@end

@implementation HK_AboutHeaderView

-(instancetype) initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =RGB(242,242,242);
        [self addSubview:self.icon];
        [self addSubview:self.vison];

    }
    return self;
}
-(UIImageView *)icon {
    if (!_icon) {
        UIImage *logoM =[UIImage imageNamed:@"logo"];
        _icon =[[UIImageView alloc]  initWithFrame:CGRectMake(kScreenWidth/2-logoM.size.width/2,30,logoM.size.width,logoM.size.height)];
        _icon.image = logoM;
    }
    return _icon;
}
-(UILabel *)vison {
    if (!_vison) {
        _vison =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.icon.frame)+10,kScreenWidth,10)];
        [AppUtils getConfigueLabel:_vison font:PingFangSCRegular14 aliment:NSTextAlignmentCenter textcolor:RGB(153,153,153) text:[NSString stringWithFormat:@"版本V %@",[AppUtils currentVersion]]];
    }
    return _vison;
}

@end
