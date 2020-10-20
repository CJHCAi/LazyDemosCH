//
//  wjFirstFoldView.m
//  foldCellTest
//
//  Created by gouzi on 2016/12/2.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "wjFirstFoldView.h"


#define screenWidth [UIScreen mainScreen].bounds.size.width


@interface wjFirstFoldView ()

@end

@implementation wjFirstFoldView
// 分割线
- (UIView *)speratorLine {
    
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.frame = CGRectMake(13, 44, screenWidth - 13, 1);
        _separatorLine.backgroundColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];

//        _separatorLine.backgroundColor = [UIColor blackColor];
    }
    return _separatorLine;
}

- (UIImageView *)indicateImageView {

    if (!_indicateImageView) {
        _indicateImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrows-right"]];
        _indicateImageView.frame = CGRectMake(15, 17, 10, 10);
        _indicateImageView.userInteractionEnabled = YES;
    }
    
    return _indicateImageView;
}

- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.frame = CGRectMake(30, 0, screenWidth - 30, 44);
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.text = @"2015-11-20";
    }
    return _dateLabel;
}


- (instancetype)init {
    
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, screenWidth, 45);
        self.userInteractionEnabled = YES;
        
        UIImageView *imageView = self.indicateImageView;
        [self addSubview:imageView];
        UILabel *dateLabel = self.dateLabel;
        [self addSubview:dateLabel];
        UIView *line = self.separatorLine;
        [self addSubview:line];
    }
    
    return self;
}

@end
