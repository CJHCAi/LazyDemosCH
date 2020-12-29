//
//  NK_GladlyBuyTitleView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "NK_GladlyBuyTitleView.h"
#import "MASConstraintMaker.h"
#import "Masonry/Masonry.h"
#define leftB_Left 10
#define titleL_W 76
#define titleL_H 20
#define searchB_H 24
#define searchB_WH 15
#define leftB_H 30
#define leftB_W 30

#define rigthB_WH 30

#define searchBG_W kScreenWidth-leftB_Left-leftB_W-17-17-rigthB_WH-17
#define searchBG_H 31

#define rigthB_Right 17+14

@interface NK_GladlyBuyTitleView ()
{
    UIView *viewbg;
    UIButton *leftB;
    
    UIButton *searchBG;
    UIButton *searchB;
    UILabel *searchL;
    
    UIButton *rigthB;
    UILabel* titleL;
    
    UIView *svline;
}
@end

@implementation NK_GladlyBuyTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        [self setupTitleView];
    }
    return self;
}

-(void)setupTitleView
{
    viewbg = [UIView new];
    viewbg.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewbg];
    [viewbg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    leftB= [UIButton new];
    leftB.frame = CGRectMake(10, 6, 30, 30);
    leftB.backgroundColor = [UIColor clearColor];
    [leftB setTitle:@"" forState:UIControlStateNormal];
    [leftB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftB addTarget:self action:@selector(gotoLeftView) forControlEvents:UIControlEventTouchUpInside];
    [leftB setBackgroundImage:[UIImage imageNamed:@"buy_lista"] forState:UIControlStateNormal];
    [leftB setBackgroundImage:[UIImage imageNamed:@"buy_lista"] forState:UIControlStateHighlighted];
    leftB.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [leftB.layer setCornerRadius:0];
    leftB.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:leftB];
//    [leftB mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).with.offset(6);
//        make.left.equalTo(self).with.offset(leftB_Left);
//        make.size.mas_equalTo(CGSizeMake(leftB_W,leftB_H));
//    }];
    
    
    searchBG= [UIButton new];
    searchBG.backgroundColor = UICOLOR_RGB_Alpha(0xefefef, 1);
    [searchBG setTitle:@"" forState:UIControlStateNormal];
    [searchBG setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBG addTarget:self action:@selector(gotoSearchView) forControlEvents:UIControlEventTouchUpInside];
    searchBG.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [searchBG.layer setCornerRadius:2];
    searchBG.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:searchBG];
    [searchBG mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->viewbg.mas_top).with.offset((self.frame.size.height-searchBG_H)/2);
        make.left.equalTo(self->leftB.mas_right).with.offset(17);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth*0.73,searchBG_H));
    }];
    
    
    
    searchB= [UIButton new];
    searchB.backgroundColor = [UIColor clearColor];
    [searchB setTitle:@"" forState:UIControlStateNormal];
    [searchB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchB addTarget:self action:@selector(gotoSearchView) forControlEvents:UIControlEventTouchUpInside];
    [searchB setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchB setBackgroundImage:[UIImage imageNamed:@"search"] forState:UIControlStateHighlighted];
    searchB.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [searchB.layer setCornerRadius:0];
    searchB.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:searchB];
    [searchB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->searchBG).with.offset((searchBG_H-searchB_WH)/2);
        make.left.equalTo(self).with.offset(kScreenWidth/2-79);
        make.size.mas_equalTo(CGSizeMake(16,15));
    }];
    
    
    searchL = [UILabel new];
    searchL.backgroundColor = [UIColor clearColor];
    searchL.font = [UIFont systemFontOfSize: 15.0];
    searchL.textAlignment = NSTextAlignmentCenter;
    searchL.textColor = UICOLOR_RGB_Alpha(0x999999, 1);
    searchL.text = @"请输入商品名称";
    [self addSubview:searchL];
    [searchL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->viewbg).with.offset((self.frame.size.height-12)/2);
        make.left.equalTo(self->searchBG).with.offset(0);
        make.width.mas_equalTo(searchBG_W);
        make.height.mas_equalTo(15);
    }];
    
    rigthB= [UIButton new];
    rigthB.backgroundColor = [UIColor clearColor];
    [rigthB setTitle:@"" forState:UIControlStateNormal];
    [rigthB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rigthB addTarget:self action:@selector(gotoRigthView) forControlEvents:UIControlEventTouchUpInside];
    [rigthB setBackgroundImage:[UIImage imageNamed:@"buy_more"] forState:UIControlStateNormal];
    [rigthB setBackgroundImage:[UIImage imageNamed:@"buy_more"] forState:UIControlStateHighlighted];
    rigthB.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [rigthB.layer setCornerRadius:0];
    rigthB.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:rigthB];
    [rigthB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->viewbg).with.offset((self.frame.size.height-rigthB_WH)/2);
        make.left.equalTo(self->searchBG.mas_right).with.offset(17);
        make.size.mas_equalTo(CGSizeMake(rigthB_WH,rigthB_WH));
    }];
    
    svline = [UIView new];
    svline.backgroundColor = [UIColor whiteColor];
    [svline.layer setCornerRadius:3.0];
    [self addSubview:svline];
    [svline mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(-0.5);
        make.left.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,0.5));
    }];
}

-(void)gotoLeftView
{
    if([self.leftdelegate respondsToSelector:@selector(gotoLeftView)]){
        [self.leftdelegate gotoLeftView];
    }
}

-(void)gotoSearchView
{
    if([self.seachdelegate respondsToSelector:@selector(gotoSeachView)]){
        [self.seachdelegate gotoSeachView];
    }
}

-(void)gotoRigthView
{
    if([self.rightdelegate respondsToSelector:@selector(gotoRightView)]){
        [self.rightdelegate gotoRightView];
    }
}


@end
