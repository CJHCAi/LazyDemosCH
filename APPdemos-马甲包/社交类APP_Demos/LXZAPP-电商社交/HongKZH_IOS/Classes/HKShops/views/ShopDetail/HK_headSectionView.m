//
//  HK_headSectionView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_headSectionView.h"

@implementation HK_headSectionView
{
    CGFloat sectionW ;
    CGFloat sectionH ;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        sectionW   = kScreenWidth /4;
        sectionH   = 50;
        
        [self addSubview:self.countLabel];
        [self addSubview:self.nameLabel];
    }
    return self;
}
-(UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,0,sectionW,15)];
        [AppUtils getConfigueLabel:_countLabel font:[UIFont boldSystemFontOfSize:18] aliment:NSTextAlignmentCenter textcolor:RGB(239,89,60) text:@""];
    }
    return _countLabel;
}
-(UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.countLabel.frame)+10,sectionW,15)];
        [AppUtils getConfigueLabel:_nameLabel font:PingFangSCRegular12 aliment:NSTextAlignmentCenter textcolor:RGB(102,102,102) text:@""];
    }
    return _nameLabel;
}

@end
