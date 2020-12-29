//
//  NK_GladlyLookTitleView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "NK_GladlyLookTitleView.h"
#import "MASConstraintMaker.h"
#import "Masonry/Masonry.h"
#import "HKLoginViewController.h"
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

@interface NK_GladlyLookTitleView ()
{
    UIView *viewbg;
    UIButton *rigthA;
    UIButton *rigthC;
    UIButton *rigthB;
    UILabel* titleL;
    
    UIButton *searchBG;
    UIButton *searchB;
    UILabel *searchL;
    
    UIView *svline;
}
@end

@implementation NK_GladlyLookTitleView

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
#pragma mark 查看时间
    rigthB= [UIButton new];
    rigthB.backgroundColor = [UIColor clearColor];
    [rigthB setTitle:@"" forState:UIControlStateNormal];
    [rigthB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rigthB addTarget:self action:@selector(gotoLeftView) forControlEvents:UIControlEventTouchUpInside];
    [rigthB setBackgroundImage:[UIImage imageNamed:@"look_time"] forState:UIControlStateNormal];
    [rigthB setBackgroundImage:[UIImage imageNamed:@"look_time"] forState:UIControlStateHighlighted];
    rigthB.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [rigthB.layer setCornerRadius:0];
    rigthB.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:rigthB];
    [rigthB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(4);
        make.left.equalTo(self).offset(15);
        make.size.mas_equalTo(CGSizeMake(rigthB_WH,rigthB_WH));
    }];
    rigthC= [UIButton new];
    rigthC.backgroundColor = [UIColor clearColor];
    [rigthC setTitle:@"" forState:UIControlStateNormal];
    [rigthC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rigthC addTarget:self action:@selector(gotoRigthView) forControlEvents:UIControlEventTouchUpInside];
//    [rigthC setBackgroundImage:[UIImage imageNamed:@"sxj"] forState:UIControlStateNormal];
//    [rigthC setBackgroundImage:[UIImage imageNamed:@"sxj"] forState:UIControlStateHighlighted];
    [rigthC setImage:[UIImage imageNamed:@"sxj"] forState:UIControlStateNormal];
    rigthC.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [rigthC.layer setCornerRadius:0];
    rigthC.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:rigthC];
    [rigthC mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(4);
        make.right.equalTo(self).offset(-10);
        make.size.mas_equalTo(CGSizeMake(rigthB_WH,rigthB_WH));
    }];
    searchBG= [UIButton new];
    searchBG.backgroundColor = UICOLOR_RGB_Alpha(0xeeeeee, 1);
    [searchBG setTitle:@"" forState:UIControlStateNormal];
    [searchBG setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [searchBG addTarget:self action:@selector(gotoSearchView) forControlEvents:UIControlEventTouchUpInside];
    searchBG.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [searchBG.layer setCornerRadius:15];
    searchBG.titleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:searchBG];
    [searchBG mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->viewbg.mas_top).with.offset((self.frame.size.height-searchBG_H)/2);
        make.left.equalTo(self->rigthB.mas_right).offset(15);
        make.height.mas_equalTo(searchBG_H);
        make.right.equalTo(self->rigthC.mas_left).offset(-15);
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
        make.top.equalTo(self->searchBG).with.offset(9);
        make.left.equalTo(self->searchBG).with.offset(12);
        make.size.mas_equalTo(CGSizeMake(13,12));
    }];
    
    
    searchL = [UILabel new];
    searchL.backgroundColor = [UIColor clearColor];
    searchL.font = [UIFont systemFontOfSize: 13.0];
    searchL.textAlignment = NSTextAlignmentLeft;
    searchL.textColor = UICOLOR_RGB_Alpha(0x999999, 1);
    searchL.text = @"搜索";
    [self addSubview:searchL];
    [searchL mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self->searchBG).with.offset(9);
        make.left.equalTo(self->searchB.mas_right).with.offset(6);
        make.width.mas_equalTo(searchBG_W);
        make.height.mas_equalTo(13);
    }];
#pragma mark 发布视频
    

}
//logo 点击
-(void)gotoLeftView
{
    
    if([self.leftdelegate respondsToSelector:@selector(gotoLeftView)]){
        [self.leftdelegate gotoLeftView];
    }
}
//跳转搜索
-(void)gotoSearchView
{
    DLog(@"点击搜索了");
    if([self.seachdelegate respondsToSelector:@selector(gotoSeachView)]){
        [self.seachdelegate gotoSeachView];
    }
}

//发布视频
-(void)gotoRigthView
{
       DLog(@"点击发布了");
    if([self.rightdelegate respondsToSelector:@selector(gotoRightView)]){
        
        [self.rightdelegate gotoRightView];
    
    }
}
@end
