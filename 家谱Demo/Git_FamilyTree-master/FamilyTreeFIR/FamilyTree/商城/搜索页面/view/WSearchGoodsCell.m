//
//  WSearchGoodsCell.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WSearchGoodsCell.h"

@implementation WSearchGoodsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView sd_addSubviews:@[self.cellImage,self.cellLabel,self.cellPrice]];
//        [self.contentView addSubview:self.cellImage];
//        [self.contentView addSubview:self.cellLabel];
//        [self.contentView addSubview:self.cellPrice];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark *** getter ***

-(UIImageView *)cellImage{
    if (!_cellImage) {
        _cellImage = [[UIImageView alloc] initWithFrame:AdaptationFrame(15, 15, 268, 168)];
        _cellImage.backgroundColor = [UIColor orangeColor];
        
    }
    return _cellImage;
}
-(UILabel *)cellLabel{
    if (!_cellLabel) {
        _cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectXW(self.cellImage)+15*AdaptationWidth(), 15*AdaptationWidth(), 350*AdaptationWidth(), 128*AdaptationWidth())];
        _cellLabel.font = WFont(25);
        _cellLabel.text = @"我了大师大师大师的我了大师大师大师的我了大师大师大师的我了大师大师大师的我了大师大师大师的我了大师大师大师的";
        _cellLabel.numberOfLines = 0;
    }
    return _cellLabel;
}
-(UILabel *)cellPrice{
    if (!_cellPrice) {
        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectX(self.cellLabel), CGRectYH(self.cellLabel), 10, 25)];
        theLabel.font = WFont(25);
        theLabel.textColor = [UIColor redColor];
        theLabel.text = @"¥";
        [self.contentView addSubview:theLabel];
        
        _cellPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectXW(theLabel), CGRectY(theLabel), 100, 25)];
        _cellPrice.font = WFont(25);
        _cellPrice.textAlignment = 0;
        _cellPrice.text = @"88";
        _cellPrice.textColor = [UIColor redColor];
        
    }
    return _cellPrice;
}
@end
