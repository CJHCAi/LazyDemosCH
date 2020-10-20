//
//  ZJWaterLayoutCollectionViewCell.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/13.
//  Copyright © 2018年 James. All rights reserved.
//

#import "ZJWaterLayoutCollectionViewCell.h"

@implementation ZJWaterLayoutCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 5;
        
        [self.contentView addSubview:imageView];
        self.imageView = imageView;
        //        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end
