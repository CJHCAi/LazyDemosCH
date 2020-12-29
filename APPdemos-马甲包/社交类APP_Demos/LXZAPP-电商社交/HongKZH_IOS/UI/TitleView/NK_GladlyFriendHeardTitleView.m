//
//  NK_GladlyFriendHeardTitleView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "NK_GladlyFriendHeardTitleView.h"
#define self_H  42
#define titleL_W 76
#define titleL_H 20

#define rigthB_WH 14
#define rigthB_Right 17+14
@interface NK_GladlyFriendHeardTitleView ()
{
    UIView *viewbg;
    UILabel *titleL;
    UIButton *rigthB;
    UIView *svline;
}
@end

@implementation NK_GladlyFriendHeardTitleView

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
    
    titleL = [UILabel new];
    titleL.backgroundColor = [UIColor clearColor];
    titleL.font = [UIFont systemFontOfSize: 17.0];
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
    titleL.text = @"乐友";
    [self addSubview:titleL];
    [self addSubview:titleL];
    [titleL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth,self_H));
    }];
    
    rigthB= [UIButton new];
    rigthB.backgroundColor = [UIColor clearColor];
    rigthB.frame = CGRectMake(kScreenWidth-40, 8, 30, 30);
    [rigthB setTitle:@"" forState:UIControlStateNormal];
    [rigthB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rigthB addTarget:self action:@selector(gotoRigthView) forControlEvents:UIControlEventTouchUpInside];
    [rigthB setBackgroundImage:[UIImage imageNamed:@"newFriend"] forState:UIControlStateNormal];
    [rigthB setBackgroundImage:[UIImage imageNamed:@"newFriend"] forState:UIControlStateHighlighted];
    rigthB.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [rigthB.layer setCornerRadius:0];
    rigthB.userInteractionEnabled = YES;
    rigthB.titleLabel.textColor = [UIColor lightGrayColor];
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
    if([self.rightdelegate respondsToSelector:@selector(gotoRightView)]){
        [self.rightdelegate gotoRightView];
    }
}



@end
