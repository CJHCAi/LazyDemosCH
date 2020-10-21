//
//  ImageFilterBtn.m
//  GifDemo
//
//  Created by Rick on 15/5/29.
//  Copyright (c) 2015年 Rick. All rights reserved.
//
#define kImageRatio 0.8

#import "ImageFilterItem.h"

@interface ImageFilterItem ()


@end

@implementation ImageFilterItem


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.frame = CGRectMake((100-90)/2, (111-91)/2, 90, 91);
        [self addSubview:_backgroundView];
    }
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
        [_backgroundView addSubview:_imageView];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
        [_imageView addGestureRecognizer:tap];
    }
    
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.backgroundColor = RGB(255, 255, 255);
        [_backgroundView addSubview:_titleLabel];
    }
    
    _imageView.frame = CGRectMake(0, 0, 90, 67);
    _titleLabel.frame= CGRectMake(CGRectGetMinX(_imageView.frame), CGRectGetMaxY(_imageView.frame), _imageView.frame.size.width, 24);

}

-(void)imageViewTap:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(imageFilterItemClick:filterDict:)]) {
        self.selected = YES;
        [self.delegate imageFilterItemClick:self filterDict:_filterDict];
    }
}

- (void)setIconImage:(UIImage *)iconImage
{
    _imageView.image = iconImage;
}

-(void)setSelected:(BOOL)selected{
    if (selected) {
        self.titleLabel.backgroundColor = RGB(193, 226, 122);
    }else{
        self.titleLabel.backgroundColor = RGB(255, 255, 255);
    }
}
@end
