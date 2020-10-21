//
//  CDOneCell.m
//  CustomTabbar
//
//  Created by CDchen on 2017/9/4.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import "CDOneCell.h"

@implementation CDOneCell

-(UIImageView *)CD_Image
{
    if (!_CD_Image)
    {
        _CD_Image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
        _CD_Image.image = [UIImage imageNamed:@"nodata"];
        [self.contentView addSubview:_CD_Image];

    }
    return _CD_Image;
}

- (UILabel *)CD_Label
{
    if (!_CD_Label)
    {
        _CD_Label = [[UILabel alloc] initWithFrame:CGRectMake(70, 20, CGRectGetWidth(self.frame)-90, 70)];
        _CD_Label.numberOfLines = 0;
        _CD_Label.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_CD_Label];
    }
    CGRect rect = _CD_Label.frame;
    rect.size.height = CGRectGetHeight(self.frame)-20-20;
    _CD_Label.frame = rect;
    return _CD_Label;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}
+ (CGFloat)cellHeightWithLabel:(NSString *)Label;
{
    CGSize size = [Label stringSizeWithContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 90, MAXFLOAT) font:[UIFont systemFontOfSize:15]];
    return ceil(size.height) + 40;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
