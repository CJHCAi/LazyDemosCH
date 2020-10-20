//
//  APXRectanglePageControl.m
//  ZhongHeBao
//
//  Created by 云无心 on 2017/7/14.
//  Copyright © 2017年 yangyang. All rights reserved.
//

#import "APXRectanglePageControl.h"

@interface APXRectanglePageControl ()

@property (nonatomic, strong) UILabel *pageLabel;

@end

@implementation APXRectanglePageControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContentView];
        [self setupContentConstraints];
    }
    return self;
}

- (void)setupContentView
{
    self.backgroundColor = ColorWithHex(0xe2e1e1);
    [self addSubview:self.pageLabel];
}

- (void)setupContentConstraints
{
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(self);
    }];
}

- (void)setTotalPage:(NSInteger)totalPage
{
    _totalPage = totalPage;
    self.pageLabel.text = [NSString stringWithFormat:@"%zd/%zd",_currentPage,_totalPage];
}
- (void)setCurrentPage:(NSInteger)currentPage
{
    _currentPage = currentPage;
    self.pageLabel.text = [NSString stringWithFormat:@"%zd/%zd",_currentPage,_totalPage];
}






- (UILabel *)pageLabel
{
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] init];
        _pageLabel.font = [UIFont systemFontOfSize:11];
        _pageLabel.textColor = [UIColor whiteColor];
    }
    return _pageLabel;
}


@end
