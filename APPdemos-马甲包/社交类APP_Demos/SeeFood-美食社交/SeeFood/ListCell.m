//
//  ListCell.m
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, width - 16, width - 16)];
        _imageView.backgroundColor = [UIColor grayColor];
        _imageView.layer.cornerRadius = width / 2 - 8;
        _imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, width, width, frame.size.height - width)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:width / 5];
        [self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)setImageViewWithImageName:(NSString *)imageName
{
    _imageView.image = [UIImage imageNamed:imageName];
}

@end
