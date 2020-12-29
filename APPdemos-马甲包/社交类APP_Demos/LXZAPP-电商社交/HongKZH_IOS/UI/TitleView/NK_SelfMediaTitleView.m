//
//  NK_SelfMediaTitleView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "NK_SelfMediaTitleView.h"
#import "MASConstraintMaker.h"
#import "Masonry/Masonry.h"
#define leftB_Left 17
#define titleL_W 76
#define titleL_H 16
#define searchB_H 24
#define searchB_WH 15
#define leftB_H 18
#define leftB_W 10

#define rigthB_WH 14

#define searchBG_W kScreenWidth-leftB_Left-leftB_W-17-17-rigthB_WH-17
#define searchBG_H 28

#define rigthB_Right 17+14



@interface NK_SelfMediaTitleView ()
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

@implementation NK_SelfMediaTitleView

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
    viewbg.backgroundColor = [UIColor clearColor];
    [self addSubview:viewbg];
    [viewbg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    leftB= [UIButton new];
    leftB.backgroundColor = [UIColor clearColor];
    [leftB setTitle:@"" forState:UIControlStateNormal];
    leftB.frame = CGRectMake(15, 8, 30, 30);
    [leftB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftB addTarget:self action:@selector(gotoLeftView) forControlEvents:UIControlEventTouchUpInside];
    [leftB setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_back"] forState:UIControlStateNormal];
    [leftB setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_back"] forState:UIControlStateHighlighted];
    leftB.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [leftB.layer setCornerRadius:0];
    leftB.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:leftB];
    
    
    titleL = [UILabel new];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.font = [UIFont systemFontOfSize: 14.0];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    [self addSubview:titleL];
    [titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(15);
        make.centerX.equalTo(self);
        make.width.mas_lessThanOrEqualTo(100000);
        make.height.mas_lessThanOrEqualTo(100000);
    }];
    
    
    searchB= [UIButton new];
    searchB.backgroundColor = [UIColor clearColor];
    [searchB setTitle:@"" forState:UIControlStateNormal];
    [searchB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchB addTarget:self action:@selector(gotoSearchView) forControlEvents:UIControlEventTouchUpInside];
    [searchB setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_down"] forState:UIControlStateNormal];
    [searchB setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_down"] forState:UIControlStateHighlighted];
    searchB.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [searchB.layer setCornerRadius:0];
    searchB.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:searchB];
    [searchB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(20);
        make.left.equalTo(self->titleL.mas_right).with.offset(7);
        make.size.mas_equalTo(CGSizeMake(10,6));
    }];
    
    
//    searchL = [UILabel new];
//    searchL.backgroundColor = [UIColor clearColor];
//    searchL.font = [UIFont systemFontOfSize: 12.0];
//    searchL.textAlignment = NSTextAlignmentCenter;
//    searchL.textColor = UICOLOR_RGB_Alpha(0xDDDDDD, 1);
//    searchL.text = @"搜索产品名称或分类";
//    [self addSubview:searchL];
//    [searchL mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self->viewbg).with.offset((self.frame.size.height-12)/2);
//        make.left.equalTo(self->searchBG).with.offset(0);
//        make.width.mas_equalTo(searchBG_W);
//        make.height.mas_equalTo(12);
//    }];    
    
    rigthB= [UIButton new];
    rigthB.backgroundColor = [UIColor clearColor];
    [rigthB setTitle:@"" forState:UIControlStateNormal];
    [rigthB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rigthB addTarget:self action:@selector(gotoRigthView) forControlEvents:UIControlEventTouchUpInside];
    [rigthB setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_more"] forState:UIControlStateNormal];
    [rigthB setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_more"] forState:UIControlStateHighlighted];
    rigthB.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [rigthB.layer setCornerRadius:0];
    rigthB.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:rigthB];
    [rigthB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(8);
        make.left.equalTo(self.mas_right).with.offset(-36);
        make.size.mas_equalTo(CGSizeMake(21,21));
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

-(void)addtitle:(NSString *)title
{
    titleL.text = title;
    [titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(15);
        make.centerX.equalTo(self);
        make.width.mas_lessThanOrEqualTo(100000);
        make.height.mas_lessThanOrEqualTo(100000);
    }];
    [searchB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(20);
        make.left.equalTo(self->titleL.mas_right).with.offset(7);
        make.size.mas_equalTo(CGSizeMake(10,6));
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
