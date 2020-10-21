//
//  DemoStickerView.m
//  LPStickerView
//
//  Created by 罗平 on 2017/6/14.
//  Copyright © 2017年 罗平. All rights reserved.
//

#import "DemoStickerView.h"

@interface DemoStickerView ()



@end


@implementation DemoStickerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpInit];
    }
    return self;
}

- (void)setUpInit {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    imageView.clipsToBounds = YES;
    [self.lp_contentView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.lp_contentView.bounds;
}

@end
