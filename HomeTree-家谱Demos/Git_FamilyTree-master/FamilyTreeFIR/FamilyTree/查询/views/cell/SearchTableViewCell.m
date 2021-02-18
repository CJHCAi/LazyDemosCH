//
//  SearchTableViewCell.m
//  FamilyTree
//
//  Created by 姚珉 on 16/5/30.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    return self;
}

-(void)initSubview{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 60)];
    backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backView];
    _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 20, 25)];
    
    [backView addSubview:_imageV];
    _titleLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_imageV)+10, CGRectY(_imageV)-5, 60, 20)];
    _titleLB.font = MFont(14);
    [backView addSubview:_titleLB];
    _detailLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(_titleLB), CGRectYH(_titleLB)+5, CGRectW(_titleLB)*2, 10)];
    _detailLB.textColor = LH_RGBCOLOR(143, 143, 143);
    _detailLB.font = MFont(12);
    [backView addSubview:_detailLB];
}
@end
