//
//  MoreLableButton.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/5/2.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "MoreLableButton.h"
@interface MoreLableButton()
@end
@implementation MoreLableButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _timeL= [UILabel new];
        _timeL.backgroundColor = [UIColor clearColor];
        _timeL.font = [UIFont systemFontOfSize:20];
        _timeL.textAlignment = NSTextAlignmentCenter;
        _timeL.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
        [_timeL.layer setCornerRadius:0];
        [self addSubview:_timeL];
        [_timeL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(5);
            make.centerX.equalTo(self);
            make.height.mas_lessThanOrEqualTo(10000);
        }];
        
        _bottomL= [UILabel new];
        _bottomL.backgroundColor = [UIColor clearColor];
        _bottomL.font = [UIFont systemFontOfSize:10];
        _bottomL.textAlignment = NSTextAlignmentCenter;
        _bottomL.textColor = UICOLOR_RGB_Alpha(0x999999, 1);
        [_bottomL.layer setCornerRadius:0];
        [self addSubview:_bottomL];
        [_bottomL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self->_timeL.mas_bottom).with.offset(9);
            make.centerX.equalTo(self);
            make.height.mas_lessThanOrEqualTo(10000);
        }];
    }
    
    return self;
}

-(void)addButtonTitle:(NSString*)title onterTitle:(NSString *)onTitle
{
    _timeL.text = title;
    _bottomL.text = onTitle;
}

-(void)addButtonTitleColor:(UIColor*)titleColor onterTitleColor:(UIColor *)onTitleColor
{
    _timeL.textColor = titleColor;
    _bottomL.textColor = onTitleColor;
}
@end
