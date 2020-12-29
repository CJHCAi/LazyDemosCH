//
//  HK_counHeaderView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_counHeaderView.h"

@interface HK_counHeaderView ()

@property (nonatomic, strong) UIImageView * iconOne;
@property (nonatomic, strong) UIImageView * iconTwo;
@property (nonatomic, strong) UIButton * saleBtn;
@property (nonatomic, strong) UIButton * userBtn;

@end

@implementation HK_counHeaderView
// 160...
-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.iconOne];
        [self addSubview:self.iconTwo];
        [self addSubview:self.saleBtn];
        [self addSubview:self.userBtn];
    }
    return  self;
}
-(UIImageView *)iconOne {
    if (!_iconOne) {
        _iconOne =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2-10-45,25,45,45)];
        _iconOne.image =[UIImage imageNamed:@"spzkq_yh_04"];
        _iconOne.layer.cornerRadius =45/2;
        _iconOne.layer.masksToBounds =YES;

    }
    return _iconOne;
}
-(UIImageView *)iconTwo {
    if (!_iconTwo) {
        _iconTwo =[[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2+10,CGRectGetMinY(self.iconOne.frame),CGRectGetWidth(self.iconOne.frame),CGRectGetHeight(self.iconOne.frame))];
        _iconTwo.image =[UIImage imageNamed:@"tx_01"];
        _iconTwo.layer.cornerRadius =45/2;
        _iconTwo.layer.masksToBounds =YES;
    }
    return _iconTwo;
}
-(UIButton *)saleBtn {
    if (!_saleBtn) {
        _saleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _saleBtn.frame =CGRectMake(kScreenWidth/2-10-150,CGRectGetMaxY(self.iconTwo.frame)+25,150,43);
        [AppUtils getButton:_saleBtn font:[UIFont boldSystemFontOfSize:15] titleColor:keyColor title:@"溢价出售"];
        _saleBtn.layer.cornerRadius =20;
        _saleBtn.layer.masksToBounds =YES;
        _saleBtn.backgroundColor =[UIColor whiteColor];
        _saleBtn.layer.borderColor =[keyColor CGColor];
        _saleBtn.layer.borderWidth =1;
        
        [_saleBtn addTarget:self action:@selector(sale) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saleBtn;
}
//出售
-(void)sale{
    if (self.delegete && [self.delegete respondsToSelector:@selector(justForSaleCoun)]) {
        [self.delegete justForSaleCoun];
    }
    
}
-(UIButton *)userBtn {
    if (!_userBtn) {
        _userBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _userBtn.frame =CGRectMake(kScreenWidth/2+10,CGRectGetMinY(self.saleBtn.frame),CGRectGetWidth(self.saleBtn.frame),CGRectGetHeight(self.saleBtn.frame));
        [AppUtils getButton:_userBtn font:[UIFont boldSystemFontOfSize:15] titleColor:[UIColor whiteColor] title:@"立即使用"];
        _userBtn.layer.cornerRadius =20;
        _userBtn.layer.masksToBounds =YES;
        _userBtn.backgroundColor =keyColor;
        [_userBtn addTarget:self action:@selector(use) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userBtn;
}
//使用..
-(void)use {
    if (self.delegete && [self.delegete respondsToSelector:@selector(JustForUSeCoun)]) {
        [self.delegete JustForUSeCoun];
    }
    
}
-(void)setResponse:(HKCollageOrderResponse *)response {
    _response = response;
    HKCollageList *listOne =response.data.list.firstObject;
    [AppUtils seImageView:self.iconOne withUrlSting:listOne.headImg placeholderImage:kPlaceholderImage];
    HKCollageList *listTwo =response.data.list.lastObject;
    [AppUtils seImageView:self.iconTwo withUrlSting:listTwo.headImg placeholderImage:kPlaceholderImage];
 
}

@end
