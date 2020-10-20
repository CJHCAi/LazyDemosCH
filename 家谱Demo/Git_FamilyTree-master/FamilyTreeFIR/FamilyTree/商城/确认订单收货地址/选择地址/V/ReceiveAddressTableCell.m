//
//  ReceiveAddressTableCell.m
//  CheLian
//
//  Created by imac on 16/5/4.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ReceiveAddressTableCell.h"

@implementation ReceiveAddressTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)initView{
    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 82)];
    [self addSubview:backV];
    backV.backgroundColor = [UIColor clearColor];
        _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 100, 20)];
        [backV addSubview:_nameLb];
        _nameLb.font = MFont(13);

        
        _addressLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, __kWidth-55, CGRectH(backV)-45)];
        [backV addSubview:_addressLb];
        _addressLb.font=MFont(13);
        _addressLb.numberOfLines = 0;
    
    _mobileLb = [[UILabel alloc]initWithFrame:CGRectMake(__kWidth-40-170, 10, 170, 20)];
    [backV addSubview:_mobileLb];
    _mobileLb.font=MFont(12);
    _mobileLb.textAlignment = NSTextAlignmentRight;
    _editBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-35, 31, 20, 20)];
    [backV addSubview:_editBtn];
    [_editBtn setImage:MImage(@"bianji.png") forState:BtnNormal];
    [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:BtnTouchUpInside];
    
}
- (void)editAction:(UIButton *)sender{
    [self.delegate editAddress:sender];
}

@end
