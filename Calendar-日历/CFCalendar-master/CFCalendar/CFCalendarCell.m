//
//  CFCalendarCell.m
//  CFCalendar
//
//  Created by MountainCao on 2017/8/22.
//  Copyright © 2017年 深圳中业兴融互联网金融服务有限公司. All rights reserved.
//

#import "CFCalendarCell.h"
#import "Masonry.h"
@interface CFCalendarCell ()

@property (nonatomic, strong) UILabel   *dayLabel;
@property (nonatomic, strong) UIView    *dotView;

@end

@implementation CFCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dayLabel = [[UILabel alloc]init];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.layer.borderWidth = 0.5;
        self.dayLabel.layer.borderColor = [UIColor blueColor].CGColor;
        [self addSubview:self.dayLabel];
        [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(1, 1, 1, 1));
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tap:(UITapGestureRecognizer *)tap {
    
    if (self.selectCellBlock) {
        self.selectCellBlock();
    }
}

- (UIView *)dotView {
    
    if (!_dotView) {
        
        _dotView = [[UIView alloc]init];
        _dotView.layer.cornerRadius = 4;
        _dotView.layer.masksToBounds = YES;
        _dotView.backgroundColor = [UIColor redColor];
        [self addSubview:_dotView];
        [_dotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(8, 8));
            make.top.equalTo(@10);
            make.right.equalTo(@-10);
        }];
    }
    return _dotView;
}

@end
