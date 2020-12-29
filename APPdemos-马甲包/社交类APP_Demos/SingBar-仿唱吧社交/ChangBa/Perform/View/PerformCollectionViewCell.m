//
//  PerformCollectionViewCell.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/16.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "PerformCollectionViewCell.h"

@implementation PerformCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
    }
    return self;
}


@end
