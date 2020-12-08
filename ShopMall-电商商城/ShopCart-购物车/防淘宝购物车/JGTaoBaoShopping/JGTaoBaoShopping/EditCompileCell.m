//
//  EditCompileCell.m
//  JGTaoBaoShopping
//
//  Created by 郭军 on 2017/3/16.
//  Copyright © 2017年 ZJNY. All rights reserved.
//

#import "EditCompileCell.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
#define Image(name) [UIImage imageNamed:name]



@interface EditCompileCell ()
{
    NSString *Selected;
}
@end

@implementation EditCompileCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _Goods_Circle = [UIButton buttonWithType:UIButtonTypeCustom];
        [_Goods_Circle addTarget:self action:@selector(Selected) forControlEvents:UIControlEventTouchUpInside];
        
        _Goods_Icon = [[UIImageView alloc]init];
        
        
        _Goods_Desc = [[UILabel alloc]init];
        _Goods_Desc.numberOfLines = 2;
        _Goods_Desc.font = [UIFont systemFontOfSize:12];
        _Goods_Desc.textColor = [UIColor grayColor];
        
        _Goods_NBCount = [[PPNumberButton alloc]init];
        _Goods_NBCount.borderColor = [UIColor grayColor];
        _Goods_NBCount.increaseTitle = @"＋";
        _Goods_NBCount.decreaseTitle = @"－";
        _Goods_NBCount.resultBlock = ^(NSInteger num ,BOOL increaseStatus){
            [self.SelectedDelegate ChangeGoodsNumberCell:self Number:num];
        };
        
        _Goods_Delete = [[UIButton alloc]init];
        _Goods_Delete.backgroundColor = [UIColor redColor];
        _Goods_Delete.titleLabel.font = [UIFont systemFontOfSize:15];
        [_Goods_Delete setTitle:@"删除" forState:UIControlStateNormal];
        [_Goods_Delete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_Goods_Delete addTarget:self action:@selector(DeleteGoods) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:_Goods_Icon];
        [self.contentView addSubview:_Goods_Desc];
        
        [self.contentView addSubview:_Goods_Delete];
        [self.contentView addSubview:_Goods_NBCount];
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
        
        
        [_Goods_Delete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.height.equalTo(@(100));
            make.width.equalTo(@(self.contentView.bounds.size.width/6));
        }];
        
        [_Goods_NBCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_Goods_Icon.mas_right).offset(0);
            make.right.equalTo(_Goods_Delete.mas_left).offset(0);
            make.top.equalTo(_Goods_Icon);
            make.height.equalTo(@(40));
        }];
        
        [_Goods_Desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_Goods_Icon.mas_right).offset(8);
            make.top.equalTo(_Goods_NBCount.mas_bottom).offset(5);
            make.right.equalTo(_Goods_Delete.mas_left).offset(-8);
            make.bottom.equalTo(self).offset(-5);
        }];
        
    }
    
    
    return self;
}
-(void)withData:(NSDictionary *)info
{
    [_Goods_Circle setImage:Image(info[@"SelectedType"]) forState:UIControlStateNormal];
    
    [_Goods_Icon sd_setImageWithURL:[NSURL URLWithString:info[@"GoodsIcon"]] placeholderImage:Image(@"share_sina")];
    _Goods_Desc.text = info[@"GoodsDesc"];
    _Goods_NBCount.currentNumber = [info[@"GoodsNumber"] integerValue];
    
    
    Selected = info[@"Type"];
}
/**
 *  选中该商品
 */
-(void)Selected
{
    if ([Selected isEqualToString:@"0"]) {
        [self.SelectedDelegate SelectedConfirmCell:self];
        
    }else{
        [self.SelectedDelegate SelectedCancelCell:self];
    }
    
}
/**
 *  删除该商品
 */
-(void)DeleteGoods
{
    [self.SelectedDelegate DeleteTheGoodsCell:self];
}
@end
