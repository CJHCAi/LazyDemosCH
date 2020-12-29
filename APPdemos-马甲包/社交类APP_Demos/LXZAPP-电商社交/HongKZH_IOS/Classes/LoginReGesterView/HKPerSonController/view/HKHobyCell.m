//
//  HKHobyCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHobyCell.h"

@interface HKHobyCell ()

@property (nonatomic, strong)UIImageView *picView;
@property (nonatomic, strong)UILabel *tagLbel;
@property (nonatomic, strong)UIImageView *selectView;

@end

@implementation HKHobyCell
{
    CGFloat _itemW;
    CGFloat _itemH;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        _itemW  =(kScreenWidth -60-40)/3;
        _itemH  =_itemW +20;
        [self addSubview:self.picView];
        [self addSubview:self.tagLbel];
        [self addSubview:self.selectView];
    }
    return  self;
}

-(UIImageView *)picView {
    if (!_picView) {
        _picView =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,_itemW,_itemW)];
       // _picView.layer.cornerRadius = 4;
       // _picView.layer.masksToBounds =YES;
    }
    return _picView;
}
-(UILabel *)tagLbel {
    if (!_tagLbel) {
        _tagLbel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.picView.frame)+10,_itemW
                                                            ,10)];
        [AppUtils getConfigueLabel:_tagLbel font:PingFangSCMedium15 aliment:NSTextAlignmentCenter textcolor:[UIColor colorFromHexString:@"333333"] text:@"标签"];
    }
    return _tagLbel;
}
-(UIImageView *)selectView {
    if (!_selectView) {
        _selectView =[[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-20-5,5,20,20)];
        _selectView.layer.cornerRadius = 10;
        _selectView.layer.masksToBounds =YES;
        _selectView.image =[UIImage imageNamed:@"Unchecked"];
    }
    return _selectView;
}

-(void)setUserModel:(HK_userHobyModel *)userModel {
    _userModel = userModel;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:userModel.imgSrc]];
    self.tagLbel.text =userModel.name;
    if (userModel.isSelect) {
        self.selectView.image =[UIImage imageNamed:@"Select"];
    }else {
        self.selectView.image =[UIImage imageNamed:@"Unchecked"];
    }
}


@end
