//
//  CQTopBarSegmentCell.m
//  CQTopBar
//
//  Created by CQ on 2018/1/10.
//  Copyright © 2018年 CQ. All rights reserved.
//

#import "CQTopBarSegmentCell.h"
#import "CQSegmentTitleImage.h"

@implementation CQTopBarSegmentCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.backImageView];
        
        self.segmentBtn = [[UIButton alloc] init];
        self.segmentBtn.hidden = YES;
        [self.segmentBtn addTarget:self action:@selector(segmentViewBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.segmentBtn];
        
        self.titleImage = [[CQSegmentTitleImage alloc] init];
        [self.titleImage setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.titleImage];
        self.titleImage.userInteractionEnabled = NO;
        
        self.line = [[UIView alloc] init];
        [self.contentView addSubview:self.line];
        self.crossLine = [[UIView alloc] init];
        [self.contentView addSubview:self.crossLine];
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat lineW = 0.5;
    CGFloat backImageViewY = self.index==0?10:5;
    CGFloat spacing;
        if (self.index==0) {
            spacing = 15;
        }else if (self.index+1 == self.count){
            spacing = 15;
        }else{
            spacing = 10;
        }
    self.backImageView.frame = CGRectMake(backImageViewY, 5, CGRectGetWidth(self.bounds)-spacing, CGRectGetHeight(self.bounds)-10);
    self.line.frame = CGRectMake(CGRectGetWidth(self.bounds)-lineW, CGRectGetHeight(self.bounds)/4, lineW, CGRectGetHeight(self.bounds)/2);
    self.crossLine.frame = CGRectMake(0, CGRectGetHeight(self.bounds)-lineW, CGRectGetWidth(self.bounds), lineW);
    self.titleImage.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds)-lineW, CGRectGetHeight(self.bounds));
    self.segmentBtn.frame = CGRectMake(backImageViewY, 5, CGRectGetWidth(self.bounds)-spacing, CGRectGetHeight(self.bounds)-10);
}

- (void)segmentViewBtn{
    if ([_delegate respondsToSelector:@selector(topBarSegmentCellWithBlock:)]) {
        [_delegate topBarSegmentCellWithBlock:self];
    }
}

@end
