//
//  OtherLoginView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "OtherLoginView.h"

#define ImageSize 50
#define GapToView (self.bounds.size.width-150)/2
#define TitleSize 60

@interface OtherLoginView ()
{
    NSArray *_titles;
    NSArray *_imageNames;
}
@end
@implementation OtherLoginView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self initUI];
    }
    return self;
}

#pragma mark *** 初始化数据 ***
-(void)initData{
    _titles = @[@"QQ登录",@"微信登录",@"微博登录"];
    _imageNames = @[@"QQ",@"weixin",@"weibo"];
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    for (int idx = 0; idx < _titles.count; idx ++) {
        
        //图片
        UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(idx*(ImageSize+GapToView), 0, ImageSize,ImageSize)];
        
        [imageBtn setBackgroundImage:[UIImage imageNamed:_imageNames[idx]] forState:UIControlStateNormal];
        imageBtn.tag = idx;
        [imageBtn addTarget:self action:@selector(respondsToImageBtn:) forControlEvents:UIControlEventTouchUpInside];
        //文字
        UILabel *loginName = [[UILabel alloc] initWithFrame:CGRectMake(idx*(ImageSize+GapToView), CGRectGetMaxY(imageBtn.frame)+5, TitleSize, TitleSize/2)];
        loginName.text = _titles[idx];
        loginName.font = [UIFont systemFontOfSize:13];
        loginName.textColor = [UIColor whiteColor];
        
        [self addSubview:imageBtn];
        [self addSubview:loginName];
    }
}
#pragma mark *** btnEvents ***
//三方按钮
-(void)respondsToImageBtn:(UIButton *)sender{
    if (_delegate &&[_delegate respondsToSelector:@selector(OtherLoginView:didSelectedBtn:)]) {
        [_delegate OtherLoginView:self didSelectedBtn:sender];
    }
}

#pragma mark *** getters ***

@end
