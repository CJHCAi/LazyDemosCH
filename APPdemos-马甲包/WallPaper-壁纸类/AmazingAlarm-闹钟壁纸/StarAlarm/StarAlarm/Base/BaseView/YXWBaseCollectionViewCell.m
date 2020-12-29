//
//  YXWBaseCollectionViewCell.m
//  StarAlarm
//
//  Created by dllo on 16/3/30.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWBaseCollectionViewCell.h"

@implementation YXWBaseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
