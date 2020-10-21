//
//  HeaderCollectionReusableView.m
//  ScrollerDemo
//
//  Created by 栗子 on 2017/11/14.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import "HeaderCollectionReusableView.h"

@interface HeaderCollectionReusableView()

//背景图片
@property(nonatomic,strong)UIImageView *bgVIew;

@property(nonatomic,strong)UIView *bvIew;

@end


@implementation HeaderCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        [self addSubviews];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.bgVIew.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.bvIew.frame=CGRectMake(-self.frame.origin.x, -self.frame.origin.y, LFScreenW, self.bounds.size.height);
    
    
}
-(void)addSubviews{
    self.backgroundColor=[UIColor whiteColor];
    self.bgVIew=[[UIImageView alloc]init];
    [self addSubview:self.bgVIew];
    [self.bgVIew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_offset(156);
    }];
    self.bgVIew.backgroundColor =[UIColor redColor];
    
    self.bvIew=[[UIView alloc]init];
    [self addSubview:self.bvIew];
    self.bvIew.backgroundColor=[UIColor clearColor];
    
    //头像
    self.headerIV=[[UIImageView alloc]init];
    [self.bvIew addSubview:self.headerIV];
    [self.headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(LeftRightManagerS);
        make.top.mas_offset(56);
        make.width.height.mas_offset(70);
    }];
    self.headerIV.layer.cornerRadius= 70/2;
    self.headerIV.layer.masksToBounds=YES;
    self.headerIV.layer.borderWidth=2;
    self.headerIV.layer.borderColor=[UIColor whiteColor].CGColor;
    self.headerIV.backgroundColor = [UIColor lightGrayColor];
    
    //昵称
    self.nameLB=[[UILabel alloc]init];
    [self.bvIew addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerIV.mas_right).offset(10);
        make.top.mas_offset(80);
        make.height.mas_offset(19);
        make.width.mas_offset(LFScreenW-(2*LeftRightManagerS+70+10));
    }];
    self.nameLB.text = @"昵称昵称";
    self.nameLB.textAlignment=NSTextAlignmentLeft;
    self.nameLB.textColor=[UIColor whiteColor];
    self.nameLB.font=[UIFont systemFontOfSize:17];
    
}
@end
