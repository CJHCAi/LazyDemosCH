//
//  HK_ImageTitleBtn.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_ImageTitleBtn.h"

@implementation HK_ImageTitleBtn

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        [self layoutSubviews];
    }
    return  self;
}

-(void)layoutSubviews {
    [self addSubview:self.imageV];
    [self addSubview:self.labelV];
}
-(UIImageView *)imageV {
    if (!_imageV) {
        _imageV =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width,40)];
    }
    return _imageV;
}
-(UILabel *)labelV {
    if (!_labelV) {
        _labelV =[[UILabel alloc] initWithFrame:CGRectMake(0,40,CGRectGetWidth(self.imageV.frame),20)];
        
        [AppUtils getConfigueLabel:_labelV font:PingFangSCMedium11 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        
    }
    return _labelV;
}

@end
