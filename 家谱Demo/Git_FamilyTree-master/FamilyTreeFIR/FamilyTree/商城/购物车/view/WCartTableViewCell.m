//
//  WCartTableViewCell.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WCartTableViewCell.h"

@implementation WCartTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellSelectBtn];
        [self.contentView addSubview:self.cellImage];
        [self.contentView addSubview:self.cellName];
        [self.contentView addSubview:self.cellType];
        [self.contentView addSubview:self.cellNumber];
        [self.contentView addSubview:self.cellPrice];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark *** cellNumberDelegate ***
-(void)changeCountLb:(UILabel *)text action:(UIButton *)sender{
    NSInteger count = [text.text integerValue];
    if (sender.tag -90) {
        count ++;
    }else{
        if (count>1) {
            count--;
        }
    }
    
    text.text = [NSString stringWithFormat:@"%ld",(long)count];
    if (_delegate && [_delegate respondsToSelector:@selector(WCartTableViewCell:atIndexPath:changedCellNumber:)]) {
        [_delegate WCartTableViewCell:self atIndexPath:self.indexPath changedCellNumber:text.text];
    };
}
#pragma mark *** getters ***
-(UIButton *)cellSelectBtn{
    if (!_cellSelectBtn) {
        _cellSelectBtn = [[UIButton alloc] initWithFrame:AdaptationFrame(20,125, 50, 50)];
        [_cellSelectBtn setImage:MImage(@"quan") forState:UIControlStateNormal];
        [_cellSelectBtn setImage:MImage(@"gou") forState:UIControlStateSelected];
        _cellSelectBtn.userInteractionEnabled = false;
        
    }
    return _cellSelectBtn;
}
-(UIImageView *)cellImage{
    if (!_cellImage) {
        _cellImage = [[UIImageView alloc] initWithFrame:AdaptationFrame(80, 35, 170, 170)];
        _cellImage.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _cellImage;
}
-(UILabel *)cellName{
    if (!_cellName) {
        _cellName = [[UILabel alloc] initWithFrame:AdaptationFrame(CGRectXW(self.cellImage)/AdaptationWidth()+30, 24, 350, 70)];
        _cellName.text = @"";
        _cellName.font = WFont(27);
        _cellName.numberOfLines = 0;
        [_cellName sizeToFit];
    }
    return _cellName;
}
-(UILabel *)cellType{
    if (!_cellType) {
        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectX(self.cellName), CGRectYH(self.cellName)+10*AdaptationWidth(), 90*AdaptationWidth(), 45*AdaptationWidth())];
        theLabel.font = WFont(27);
        theLabel.text = @"颜色：";
        [self.contentView addSubview:theLabel];
        
        _cellType = [[UILabel alloc] initWithFrame:CGRectMake(CGRectXW(theLabel), CGRectY(theLabel), 100*AdaptationWidth(), 45*AdaptationWidth())];
        _cellType.text = @"黑色";
        _cellType.textAlignment = 1;
        _cellType.font = theLabel.font;
        _cellType.layer.borderColor = BorderColor;
        _cellType.layer.borderWidth = 1;
        
    }
    return _cellType;
}
-(GoodNumberView *)cellNumber{
    if (!_cellNumber) {
        _cellNumber = [[GoodNumberView alloc] initWithFrame:CGRectMake(CGRectX(self.cellName)-30*AdaptationWidth(), CGRectYH(self.cellType)+5, 175, 50*AdaptationWidth())];
        _cellNumber.numLabel.font = WFont(27);
        _cellNumber.numLabel.frame = CGRectMake(15, 5, 50, 15);
        _cellNumber.numLabel.text = @"数量：";
        _cellNumber.numLabel.textColor = [UIColor blackColor];
        _cellNumber.delegate = self;
    }
    return _cellNumber;
}
-(UILabel *)cellPrice{
    if (!_cellPrice) {
        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectX(self.cellName), CGRectYH(self.cellNumber), 90*AdaptationWidth(), 45*AdaptationWidth())];
        theLabel.font = WFont(27);
        theLabel.text = @"单价：";
        [self.contentView addSubview:theLabel];
        
        _cellPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectXW(theLabel), CGRectYH(self.cellNumber), 175*AdaptationWidth(), 45*AdaptationWidth())];
        _cellPrice.textColor = [UIColor redColor];
        _cellPrice.font = theLabel.font;
        _cellPrice.text = @"¥88.0";
    }
    return _cellPrice;
}
@end
