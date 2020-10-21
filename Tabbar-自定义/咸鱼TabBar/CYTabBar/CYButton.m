//
//  CYButton.m
//  蚁巢
//
//  Created by 张春雨 on 2016/11/17.
//  Copyright © 2016年 张春雨. All rights reserved.
//

#import "CYButton.h"
#import "CYBadgeView.h"

@interface CYButton()
// remind number
@property (weak , nonatomic)CYBadgeView * badgeView;
@end

@implementation CYButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeCenter;
        [self setTitleColor:[CYTabBarConfig shared].textColor forState:UIControlStateNormal];
        [self setTitleColor:[CYTabBarConfig shared].selectedTextColor forState:UIControlStateSelected];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.superview.frame.size.height;
    if (self.titleLabel.text && ![self.titleLabel.text isEqualToString:@""]) {
        self.titleLabel.frame = CGRectMake(0, self.frame.size.height - 16, width, 16);
        self.imageView.frame = CGRectMake(0 , 0, width, 35);
    }
    else{
        self.imageView.frame = CGRectMake(0 , 0, width, height);
    }
}

/**
 *  Set red dot item
 */
- (void)setItem:(UITabBarItem *)item {
    self.badgeView.badgeValue = [item valueForKeyPath:@"badgeValue"];
    self.badgeView.badgeColor = [item valueForKeyPath:@"badgeColor"];
}

/**
 *  getter
 */
- (CYBadgeView *)badgeView {
    if (!_badgeView) {
        CYBadgeView * badgeView = [[CYBadgeView alloc] init];
        _badgeView = badgeView;
        [self addSubview:badgeView];
    }
    return _badgeView;
}


- (void)setHighlighted:(BOOL)highlighted{
}

@end
