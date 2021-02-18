//
//  CustonCollectionViewCell.m
//  UI-14.集合视图 UICollectionView
//
//  Created by saberLily on 16/1/29.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CustonCollectionViewCell.h"



@implementation CustonCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //自定义视图
        [self.contentView addSubview:self.displayLabel];
    }
    return self;
}

-(void)setHundredsNamesModel:(HundredsNamesModel *)hundredsNamesModel{
    _hundredsNamesModel = hundredsNamesModel;
    self.displayLabel.text = hundredsNamesModel.FaSurname;
}

-(UILabel *)displayLabel{
    if (!_displayLabel) {
        _displayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        _displayLabel.textAlignment = NSTextAlignmentCenter;
        _displayLabel.font = MFont(12);
    }
    return _displayLabel;
}
@end
