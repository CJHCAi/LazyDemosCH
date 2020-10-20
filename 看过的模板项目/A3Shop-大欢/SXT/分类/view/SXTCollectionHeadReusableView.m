//
//  SXTCollectionHeadReusableView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/29.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTCollectionHeadReusableView.h"

@interface SXTCollectionHeadReusableView()

@property (strong, nonatomic)   UILabel *titleLabel;              /** title标题 */

@end

@implementation SXTCollectionHeadReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setTitleLabelText:(NSString *)titleLabelText{
    _titleLabel.text = titleLabelText;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    __weak typeof(self) weakSelf = self;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).with.insets(UIEdgeInsetsMake(0, 15, 0, 0));
    }];
    
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:13.0];
        _titleLabel.textColor = [UIColor blackColor];
        
    }
    return _titleLabel;
}

@end