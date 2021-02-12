//
//  CMSubListHeadView.m
//  明医智
//
//  Created by LiuLi on 2019/1/16.
//  Copyright © 2019年 LYPC. All rights reserved.
//

#import "CMSubListHeadView.h"
#import "CMenuConfig.h"

@implementation CMSubListHeadView

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(25*Rate, 0, SCREEN_W-125*Rate, 45*Rate)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 1;
        _titleLabel.font = [UIFont systemFontOfSize:14*Rate];
        _titleLabel.textColor = [UIColor grayColor];
        [self addSubview:_titleLabel];
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.right.mas_equalTo (0);
//            make.left.mas_equalTo (25*Rate);
//        }];
    }
    return _titleLabel;
}

@end
