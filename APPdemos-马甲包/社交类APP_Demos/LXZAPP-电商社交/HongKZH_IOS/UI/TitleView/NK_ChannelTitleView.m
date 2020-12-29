//
//  NK_ChannelTitleView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/6/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "NK_ChannelTitleView.h"
#define self_H  45
#define titleL_W 76
#define titleL_H 20

#define rigthB_WH 14
#define rigthB_Right 17+14
@interface NK_ChannelTitleView ()
{
    UIView *viewbg;
    UILabel *titleL;
    UIButton *rigthB;
    UIView *svline;
    UIButton *leftB;
    BOOL isChange;
}
@end

@implementation NK_ChannelTitleView

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
    isChange = NO;
    viewbg = [UIView new];
    viewbg.backgroundColor = [UIColor clearColor];
    [self addSubview:viewbg];
    [viewbg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
    
    titleL = [UILabel new];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.font = [UIFont systemFontOfSize: 17.0];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    titleL.text = @"频道导航";
    [self addSubview:titleL];
    [self addSubview:titleL];
    [titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,self_H));
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
    
    rigthB= [UIButton new];
    rigthB.backgroundColor = [UIColor clearColor];
    rigthB.frame = CGRectMake(kScreenWidth-46, 15, 34, 16);
    [rigthB setTitle:@"编辑" forState:UIControlStateNormal];
    [rigthB setTitleColor:UICOLOR_RGB_Alpha(0x333333, 1) forState:UIControlStateNormal];
    [rigthB addTarget:self action:@selector(gotoRigthView) forControlEvents:UIControlEventTouchUpInside];
//    [rigthB setBackgroundImage:[UIImage imageNamed:@"newFriend"] forState:UIControlStateNormal];
//    [rigthB setBackgroundImage:[UIImage imageNamed:@"newFriend"] forState:UIControlStateHighlighted];
    rigthB.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    [rigthB.layer setCornerRadius:0];
    rigthB.userInteractionEnabled = YES;
    rigthB.titleLabel.textColor = UICOLOR_RGB_Alpha(0x999999, 1);
    [self addSubview:rigthB];
    //    [rigthB mas_updateConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self).with.offset(8);
    //        make.left.equalTo(self).with.offset(kScreenWidth-40);
    //        make.size.mas_equalTo(CGSizeMake(30,30));
    //    }];
    
    svline = [UIView new];
    svline.backgroundColor = [UIColor grayColor];
    [svline.layer setCornerRadius:3.0];
    [self addSubview:svline];
    [svline mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).with.offset(-0.5);
        make.left.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,0.5));
    }];
    
}

-(void)gotoRigthView
{
    if (isChange) {
        [rigthB setTitle:@"编辑" forState:UIControlStateNormal];
        [rigthB setTitleColor:UICOLOR_RGB_Alpha(0x333333, 1) forState:UIControlStateNormal];
        isChange = !isChange;
    }
    else
    {
        [rigthB setTitle:@"完成" forState:UIControlStateNormal];
        [rigthB setTitleColor:UICOLOR_RGB_Alpha(0x999999, 1) forState:UIControlStateNormal];
        isChange = !isChange;
    }
    if([self.rightdelegate respondsToSelector:@selector(gotoRightView:)]){
        [self.rightdelegate gotoRightView:isChange];
    }
}

-(void)gotoLeftView
{
    
   
    if([self.leftdelegate respondsToSelector:@selector(gotoLeftView)]){
        [self.leftdelegate gotoLeftView];
    }
}

@end
