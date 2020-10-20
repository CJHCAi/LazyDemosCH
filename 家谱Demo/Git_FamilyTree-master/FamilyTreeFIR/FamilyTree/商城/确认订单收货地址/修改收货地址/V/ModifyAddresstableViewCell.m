//
//  ModifyAddresstableViewCell.m
//  CheLian
//
//  Created by imac on 16/5/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ModifyAddresstableViewCell.h"



@implementation ModifyAddresstableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 50)];
    [self addSubview:backV];
    backV.backgroundColor = [UIColor whiteColor];
    
    _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 80, 30)];
    _titleLb.font = MFont(13);
    [backV addSubview:_titleLb];
    
    _detailTV = [[UITextField alloc]initWithFrame:CGRectMake(95, 10, __kWidth-130, 30)];
    _detailTV.font = MFont(13);
    [backV addSubview:_detailTV];
    
    _chooseIV = [[UIImageView alloc]initWithFrame:CGRectMake(__kWidth-35, 15, 20, 20)];
    _chooseIV.layer.cornerRadius=10;
    _chooseIV.image = MImage(@"非默认");
    [backV addSubview:_chooseIV];
    _chooseIV.hidden=YES;
    
    _addressTF = [[UITextView alloc]initWithFrame:CGRectMake(95, 10, __kWidth-130, 60)];
    [backV addSubview:_addressTF];
    _addressTF.backgroundColor = [UIColor whiteColor];
    _addressTF.font = MFont(13);
    _addressTF.hidden = YES;
}

@end
