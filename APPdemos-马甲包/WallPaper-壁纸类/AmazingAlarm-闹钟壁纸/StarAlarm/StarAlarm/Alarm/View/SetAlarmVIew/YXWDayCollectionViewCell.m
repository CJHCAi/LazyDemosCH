//
//  YXWDayCollectionViewCell.m
//  StarAlarm
//
//  Created by dllo on 16/4/5.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWDayCollectionViewCell.h"

@interface YXWDayCollectionViewCell ()

@property (nonatomic, strong) UIView *spreatView;

@end

@implementation YXWDayCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatTitleLabel];
    }
    return self;
}


- (void)creatTitleLabel {
    self.titileLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 1, self.bounds.size.height)];
    self.titileLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titileLabel];
    self.titileLabel.textColor = [UIColor whiteColor];
    self.spreatView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 1, 7, 1, self.bounds.size.height - 14)];
    self.spreatView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.spreatView];

}

- (void)setData:(NSString *)data {
    _data = data;
    self.titileLabel.text = self.data;
    if ([self.data isEqualToString:@"周日"]) {
        [self.spreatView removeFromSuperview];
        self.titileLabel.frame = self.bounds;
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
