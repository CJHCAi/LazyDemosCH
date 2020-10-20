//
//  TopView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "TopView.h"

#define BackBtn_size 44
#define BackBtn_toleft 10
#define Frame_height CGRectGetHeight(self.bounds)/2-BackBtn_size/2
#define GapBetweenView 2
#define TitleFont 15

@interface TopView()

@property (nonatomic,strong) UIView *verticalLine; /*竖线*/

@end
@implementation TopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.regisBtn];
        [self addSubview:self.verticalLine];
        [self addSubview:self.findPassBtn];
        
    }
    return self;
}


#pragma mark *** getters ***

-(UIButton *)regisBtn{
    if (!_regisBtn) {
        _regisBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.58*Screen_width, Frame_height, 50, BackBtn_size)];
        [_regisBtn setTitle:@"注册" forState:UIControlStateNormal];
        _regisBtn.titleLabel.font = [UIFont systemFontOfSize:TitleFont];
        
    }
    return _regisBtn;
}
-(UIView *)verticalLine{
    if (!_verticalLine) {
        _verticalLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.regisBtn.frame)+GapBetweenView, Frame_height+15, 1, BackBtn_size-30)];
        _verticalLine.backgroundColor = [UIColor whiteColor];
        
    }
    return _verticalLine;
}
-(UIButton *)findPassBtn{
    if (!_findPassBtn) {
        _findPassBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.verticalLine.frame)+GapBetweenView, Frame_height, 80, BackBtn_size)];
        [_findPassBtn setTitle:@"找回密码" forState:UIControlStateNormal];
        _findPassBtn.titleLabel.font =self.regisBtn.titleLabel.font;
    }
    return _findPassBtn;
}

@end
