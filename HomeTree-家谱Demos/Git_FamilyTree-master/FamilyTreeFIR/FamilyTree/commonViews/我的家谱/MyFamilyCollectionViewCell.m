//
//  MyFamilyCollectionViewCell.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "MyFamilyCollectionViewCell.h"

@implementation MyFamilyCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        self.layer.borderWidth = 1;
        self.layer.borderColor = LH_RGBCOLOR(228, 228, 228).CGColor;
        
    }
    return self;
}

#pragma mark *** getters ***

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = WFont(25);
        _titleLabel.textAlignment = 1;
        _titleLabel.textColor = [UIColor blackColor];
    
        
    }
    return _titleLabel;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];

    if (selected) {
        self.titleLabel.textColor = LH_RGBCOLOR(228, 65, 83);
        self.layer.borderColor = LH_RGBCOLOR(228, 65, 83).CGColor;
    }else{
        self.titleLabel.textColor = [UIColor blackColor];
        self.layer.borderColor = LH_RGBCOLOR(228, 228, 228).CGColor;
    }
}

@end
