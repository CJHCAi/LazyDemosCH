//
//  CustomCollectionViewCell.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CustomCollectionViewCell.h"



@interface CustomCollectionViewCell()


@end
@implementation CustomCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.cusImage];
        [self.contentView addSubview:self.cusLabel];
    }
    return self;
}

#pragma mark *** getters ***
-(UIImageView *)cusImage{
    if (!_cusImage) {
        _cusImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 30, 30)];
        _cusImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cusImage;
}
-(UILabel *)cusLabel{
    if (!_cusLabel) {
        _cusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.cusImage.frame)+2, 45, 20)];
        _cusLabel.font = MFont(10);
        _cusLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _cusLabel;
}
@end
