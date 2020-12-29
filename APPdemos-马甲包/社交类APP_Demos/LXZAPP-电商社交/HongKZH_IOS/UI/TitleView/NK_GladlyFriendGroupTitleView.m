//
//  NK_GladlyFriendGroupTitleView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/5/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "NK_GladlyFriendGroupTitleView.h"
#import "MASConstraintMaker.h"
#import "Masonry/Masonry.h"
#define Left_H 39
#define leftB_Left 11
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

@interface NK_GladlyFriendGroupTitleView ()
{
    UIView *viewbg;
    UIButton *leftBR;
    UIButton *rigthA;
    UIButton *rigthC;
    UIButton *rigthB;
    UILabel* titleL;
    
    UIView *svline;
}
@end

@implementation NK_GladlyFriendGroupTitleView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        [self setupTitleView];
    }
    return self;
}

-(void)setupTitleView
{
    viewbg = [UIView new];
    viewbg.backgroundColor = [UIColor whiteColor];
    viewbg.frame = CGRectMake(0, 0, kScreenWidth, 42);
    [self addSubview:viewbg];
//    [viewbg mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//    }];
    
    leftBR= [UIButton new];
    leftBR.backgroundColor = [UIColor clearColor];
    [leftBR setTitle:@"" forState:UIControlStateNormal];
    [leftBR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBR addTarget:self action:@selector(gotoLeftView) forControlEvents:UIControlEventTouchUpInside];
    
    [leftBR setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBR setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_back"] forState:UIControlStateNormal];
    [leftBR setBackgroundImage:[UIImage imageNamed:@"selfMediaClass_back"] forState:UIControlStateHighlighted];
    leftBR.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [leftBR.layer setCornerRadius:0];
    leftBR.titleLabel.textColor = [UIColor lightGrayColor];
    [viewbg addSubview:leftBR];
    leftBR.frame = CGRectMake(15, 8, 30, 30);
//    [leftB mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).with.offset(15);
//        make.left.equalTo(self).with.offset(8);
//        make.size.mas_equalTo(CGSizeMake(30,30));
//    }];
    
    
    
    
    rigthB= [UIButton new];
    rigthB.backgroundColor = [UIColor clearColor];
    [rigthB setTitle:@"" forState:UIControlStateNormal];
    [rigthB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rigthB addTarget:self action:@selector(gotoRigthView) forControlEvents:UIControlEventTouchUpInside];
    [rigthB setBackgroundImage:[UIImage imageNamed:@"class_search"] forState:UIControlStateNormal];
    [rigthB setBackgroundImage:[UIImage imageNamed:@"class_search"] forState:UIControlStateHighlighted];
    rigthB.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [rigthB.layer setCornerRadius:0];
    rigthB.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:rigthB];
    [rigthB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(4);
        make.left.equalTo(self.mas_right).with.offset(-75);
        make.size.mas_equalTo(CGSizeMake(rigthB_WH,rigthB_WH));
    }];
    
    
    rigthC= [UIButton new];
    rigthC.backgroundColor = [UIColor clearColor];
    [rigthC setTitle:@"" forState:UIControlStateNormal];
    [rigthC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rigthC addTarget:self action:@selector(gotoRigthView) forControlEvents:UIControlEventTouchUpInside];
    [rigthC setBackgroundImage:[UIImage imageNamed:@"look_more"] forState:UIControlStateNormal];
    [rigthC setBackgroundImage:[UIImage imageNamed:@"look_more"] forState:UIControlStateHighlighted];
    rigthC.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [rigthC.layer setCornerRadius:0];
    rigthC.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:rigthC];
    [rigthC mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(4);
        make.left.equalTo(self->rigthB.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(rigthB_WH,rigthB_WH));
    }];
    
    UIView *groupline = [UIView new];
    groupline.backgroundColor =UICOLOR_RGB_Alpha(0xf1f1f1, 1);
    [viewbg addSubview:groupline];
    [groupline mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->viewbg.mas_bottom).with.offset(-0.5);
        make.left.equalTo(self->viewbg).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,0.5));
    }];
    
}

-(void)gotoLeftView
{
//    if([self.leftdelegate respondsToSelector:@selector(gotoLeftView)]){
//        [self.leftdelegate gotoLeftView];
//    }
    if (_clickGroupBackBlock) {
        _clickGroupBackBlock();
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
