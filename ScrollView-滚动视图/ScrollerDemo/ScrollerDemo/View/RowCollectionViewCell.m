//
//  RowCollectionViewCell.m
//  ScrollerDemo
//
//  Created by 栗子 on 2017/11/14.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import "RowCollectionViewCell.h"

#define  TopMargin 14
#define selfWidth LFScreenW/4

@implementation RowCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        [self addSubview];
    }
    return self;
}
-(void)addSubview{
    //图片
    UIView * backView = [UIView new];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(-1);
        make.right.mas_equalTo(1);
    }];
    backView.backgroundColor = [UIColor whiteColor];
    self.IconIV=[[UIImageView alloc]init];
    [self.contentView addSubview:self.IconIV];
    [self.IconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(TopMargin);
        make.width.mas_offset(25);
        make.height.mas_offset(25);
        make.centerX.equalTo(self.mas_centerX).offset(0);
    }];
    self.IconIV.backgroundColor = [UIColor yellowColor];
    //名字
    self.nameLB=[[UILabel alloc]init];
    [self.contentView addSubview:self.nameLB];
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(5);
        make.top.equalTo(self.IconIV.mas_bottom).offset(8);
        make.height.mas_offset(13);
        make.right.mas_offset(-5);
    }];
    self.nameLB.textColor= [UIColor colorWithRed:56/255.0 green:73/255.0 blue:98/255.0 alpha:1/1.0];;
    self.nameLB.textAlignment=NSTextAlignmentCenter;
    self.nameLB.font= [UIFont fontWithName:@"PingFangSC-Regular" size:13];;

}
@end
