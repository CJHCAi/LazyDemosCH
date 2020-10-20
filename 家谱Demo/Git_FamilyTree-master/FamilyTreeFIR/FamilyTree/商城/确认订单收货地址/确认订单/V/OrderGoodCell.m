//
//  OrderGoodCell.m
//  ListV
//
//  Created by imac on 16/8/2.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "OrderGoodCell.h"

@implementation OrderGoodCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}

-(void)initView{
    _goodIV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, __kWidth*3/8, __kWidth*3/8*17/27)];
    [self addSubview:_goodIV];

    _goodNameLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_goodIV)+10, 12, __kWidth*5/12, 50)];
    [self addSubview:_goodNameLb];
    _goodNameLb.textAlignment = NSTextAlignmentLeft;
    _goodNameLb.font = MFont(12);
    _goodNameLb.numberOfLines = 0;

    _goodMoneyLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_goodIV)+10, CGRectYH(_goodIV)-20, 50, 15)];
    [self addSubview:_goodMoneyLb];
    _goodMoneyLb.textColor = [UIColor redColor];
    _goodMoneyLb.textAlignment =NSTextAlignmentLeft;

    _goodCountLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_goodNameLb)-30, CGRectYH(_goodIV)-15, 30, 15)];
    [self addSubview:_goodCountLb];
    _goodCountLb.font = MFont(11);
    _goodCountLb.textColor = LH_RGBCOLOR(120, 120, 120);
    
}

@end
