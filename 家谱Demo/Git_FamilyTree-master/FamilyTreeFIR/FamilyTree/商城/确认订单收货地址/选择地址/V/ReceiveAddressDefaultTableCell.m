//
//  ReceiveAddressDefaultTableCell.m
//  CheLian
//
//  Created by imac on 16/5/28.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "ReceiveAddressDefaultTableCell.h"

@implementation ReceiveAddressDefaultTableCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor redColor];
        [self initView];
    }
    return self;
}

-(void)initView{
    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 82)];
    [self addSubview:backV];
    backV.backgroundColor = [UIColor clearColor];
    
        _headIV= [[UIImageView alloc]initWithFrame:CGRectMake(15, 31, 20, 20)];
        [backV addSubview:_headIV];
        _headIV.image = MImage(@"非默认.png");
        _headIV.layer.cornerRadius = 10;
        
        
        _nameLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_headIV)+5, 10, 100, 20)];
        [backV addSubview:_nameLb];
        _nameLb.font =MFont(13);
    _nameLb.textColor = [UIColor whiteColor];
    
        _addressLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_headIV)+5, 35, __kWidth-80, CGRectH(backV)-45)];
        [backV addSubview:_addressLb];
        _addressLb.font = MFont(13);
        _addressLb.numberOfLines = 0;
    _addressLb.textColor = [UIColor whiteColor];
    
    _mobileLb = [[UILabel alloc]initWithFrame:CGRectMake(__kWidth-40-170, 10, 170, 20)];
    [backV addSubview:_mobileLb];
    _mobileLb.font=MFont(12);
    _mobileLb.textAlignment = NSTextAlignmentRight;
    _mobileLb.textColor = [UIColor whiteColor];

    _editBtn = [[UIButton alloc]initWithFrame:CGRectMake(__kWidth-35, 31, 20, 20)];
    [backV addSubview:_editBtn];
    [_editBtn setImage:MImage(@"bianji2.png") forState:BtnNormal];
    [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:BtnTouchUpInside];
}

- (void)editAction:(UIButton*)sender{
    [self.delegate editAddress:sender];
}
@end
