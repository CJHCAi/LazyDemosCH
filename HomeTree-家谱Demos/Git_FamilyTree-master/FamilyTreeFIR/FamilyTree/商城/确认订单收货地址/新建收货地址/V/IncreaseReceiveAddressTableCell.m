//
//  IncreaseReceiveAddressTableCell.m
//  CheLian
//
//  Created by 姚珉 on 16/5/19.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "IncreaseReceiveAddressTableCell.h"

@implementation IncreaseReceiveAddressTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 50)];
    [self addSubview:backView];
    _label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 30)];
    _label.font = MFont(13);
    [backView addSubview:_label];
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(95, 10, __kWidth-130, 30)];
    _textField.font = MFont(13);
    [backView addSubview:_textField];
    _chooseIV = [[UIImageView alloc]initWithFrame:CGRectMake(__kWidth-35, 15, 20, 20)];
    [backView addSubview:_chooseIV];
    _chooseIV.layer.cornerRadius = 10;
    _chooseIV.layer.masksToBounds = YES;
    _chooseIV.hidden = YES;
    
    _addressTF = [[UITextView alloc]initWithFrame:CGRectMake(95, 10, __kWidth-130, 60)];
    [backView addSubview:_addressTF];
    _addressTF.backgroundColor = [UIColor whiteColor];
    _addressTF.font = MFont(13);
    _addressTF.hidden = YES;

}


@end
