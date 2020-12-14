//
//  CompileCell.m
//  JGTaoBaoShopping
//
//  Created by 郭军 on 2017/3/16.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "CompileCell.h"

#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#define Image(name) [UIImage imageNamed:name]


@interface CompileCell ()
{
    NSString *Selected;
}
@end

@implementation CompileCell

//static BOOL Selected = NO;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _Goods_Circle = [UIButton buttonWithType:UIButtonTypeCustom];
        [_Goods_Circle addTarget:self action:@selector(Selected) forControlEvents:UIControlEventTouchUpInside];
        
        _Goods_Icon = [[UIImageView alloc]init];
        
        _Goods_Name = [[UILabel alloc]init];
        _Goods_Name.numberOfLines = 2;
        _Goods_Name.font = [UIFont systemFontOfSize:13];
        
        _Goods_Desc = [[UILabel alloc]init];
        _Goods_Desc.numberOfLines = 2;
        _Goods_Desc.font = [UIFont systemFontOfSize:12];
        _Goods_Desc.textColor = [UIColor grayColor];
        
        _Goods_Price = [[UILabel alloc]init];
        _Goods_Price.textColor = [UIColor orangeColor];
        _Goods_Price.font = [UIFont systemFontOfSize:14];
        
        _Goods_OldPrice = [[UILabel alloc]init];
        _Goods_OldPrice.textColor = [UIColor grayColor];
        _Goods_OldPrice.font = [UIFont systemFontOfSize:12];
        
        _Goods_Number = [[UILabel alloc]init];
        _Goods_Number.font = [UIFont systemFontOfSize:12];
        
        
        [self.contentView addSubview:_Goods_Icon];
        [self.contentView addSubview:_Goods_Desc];
        [self.contentView addSubview:_Goods_Name];
        [self.contentView addSubview:_Goods_Price];
        [self.contentView addSubview:_Goods_OldPrice];
        [self.contentView addSubview:_Goods_Number];
        [self.contentView addSubview:_Goods_Circle];
        
        
        [_Goods_Circle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(5);
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
            make.centerY.equalTo(self);
        }];
        
        [_Goods_Icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(40);
            make.top.equalTo(self).offset(5);
            make.bottom.equalTo(self).offset(-5);
            make.width.equalTo(@(90));
        }];
        
        [_Goods_Name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_Goods_Icon.mas_right).offset(8);
            make.top.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
        }];
        
        [_Goods_Desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_Goods_Icon.mas_right).offset(8);
            make.top.equalTo(_Goods_Name.mas_bottom).offset(5);
            make.right.equalTo(self).offset(-5);
        }];
        
        [_Goods_Price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_Goods_Icon.mas_right).offset(8);
            make.top.equalTo(_Goods_Desc.mas_bottom).offset(5);
            make.height.equalTo(@(20));
        }];
        
        [_Goods_OldPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_Goods_Price.mas_right).offset(8);
            make.top.equalTo(_Goods_Desc.mas_bottom).offset(5);
            make.height.equalTo(@(20));
        }];
        
        [_Goods_Number mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-10);
            make.top.equalTo(_Goods_Desc.mas_bottom).offset(5);
            make.height.equalTo(@(20));
        }];
        
    }
    
    
    return self;
}

-(void)withData:(NSDictionary *)info
{
    [_Goods_Circle setImage:Image(info[@"SelectedType"]) forState:UIControlStateNormal];
    
    [_Goods_Icon sd_setImageWithURL:[NSURL URLWithString:info[@"GoodsIcon"]] placeholderImage:Image(@"share_sina")];
    _Goods_Name.text = info[@"GoodsName"];
    _Goods_Desc.text = info[@"GoodsDesc"];
    _Goods_Price.text = [NSString stringWithFormat:@"￥%@",info[@"GoodsPrice"]];
    
    //中划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:info[@"GoodsOldPrice"] attributes:attribtDic];
    // 赋值
    _Goods_OldPrice.attributedText = attribtStr;
    _Goods_Number.text = [NSString stringWithFormat:@"x%@",info[@"GoodsNumber"]];
    
    Selected = info[@"Type"];
}

-(void)Selected
{
    if ([Selected isEqualToString:@"0"]) {
        [self.SelectedDelegate SelectedConfirmCell:self];
        
    }else{
        [self.SelectedDelegate SelectedCancelCell:self];
    }
    
}

@end

