//
//  OrderTwoCell.m
//  ListV
//
//  Created by imac on 16/8/2.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "OrderTwoCell.h"

@implementation OrderTwoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 12.5, 65, 15)];
    [self addSubview:_titleLb];
    _titleLb.font = MFont(15);
    _titleLb.textAlignment = NSTextAlignmentLeft;

    _detailOneLb = [[UILabel alloc]initWithFrame:CGRectMake(__kWidth-160, 5, 135, 15)];
    [self addSubview:_detailOneLb];
    _detailOneLb.font = MFont(13);
    _detailOneLb.textAlignment = NSTextAlignmentRight;

    _detailTwoLb = [[UILabel alloc]initWithFrame:CGRectMake(__kWidth-160, CGRectYH(_detailOneLb), 135, 15)];
    [self addSubview:_detailTwoLb];
    _detailTwoLb.font = MFont(13);
    _detailTwoLb.textAlignment = NSTextAlignmentRight;

}

@end
