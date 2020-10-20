//
//  ZJGroupingCollectionViewCell.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/5/28.
//  Copyright © 2018年 James. All rights reserved.
//

#import "ZJGroupingCollectionViewCell.h"

@implementation ZJGroupingCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        CGFloat spaWidth = frame.size.width;
        CGFloat spaHeight = 50;
        
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, spaWidth, spaHeight)];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        _imageV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_imageV];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, spaHeight+15, spaWidth, 20)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_nameLabel];
        
        self.deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(spaWidth - 30, 5, 30, 30)];
        [self.deleteButton setImage:[UIImage imageNamed:@"delete_image"] forState:UIControlStateNormal];
        self.deleteButton.hidden = YES;
        [self.contentView addSubview:self.deleteButton];
    }
    return self;
}

@end
