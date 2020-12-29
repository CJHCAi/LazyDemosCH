//
//  HK_MyOrderCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_MyOrderCell.h"

@implementation HK_MyOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconImageView.layer.cornerRadius =1;
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.image =[UIImage imageNamed:@"legoushangcheng"];
    self.iconImageView.contentMode =UIViewContentModeScaleAspectFill;
    self.live.backgroundColor =RGB(242,242,242);
    
    self.goodNameLabel.textColor =[UIColor colorFromHexString:@"333333"];
    self.goodColorLabel.textColor = [UIColor colorFromHexString:@"999999"];
    self.MycountLabel.textColor = keyColor;
    self.ShopNumberLabel.textColor =[UIColor colorFromHexString:@"333333"];

    //储物箱
    self.storeBtn.hidden =YES;
    self.storeBtn.layer.cornerRadius  = 4;
    self.storeBtn.layer.masksToBounds =YES;
    self.storeBtn.layer.borderWidth =1;
    self.storeBtn.layer.borderColor =[[UIColor colorFromHexString:@"666666"] CGColor];
    [self.storeBtn setTitleColor:[UIColor colorFromHexString:@"666666"] forState:UIControlStateNormal];
    self.storeBtn.backgroundColor =[UIColor whiteColor];
    [self.storeBtn addTarget:self action:@selector(storeCarige) forControlEvents:UIControlEventTouchUpInside];
    [self layoutSubviews];
    
}
-(void)layoutSubviews {
}
//我的售卖
-(void)setSaleData:(HK_SubListSaleData *)saleData {
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:saleData.imgSrc] placeholderImage:[UIImage imageNamed:@"back_blck"]];
    self.goodNameLabel.text =saleData.title;
    self.ShopNumberLabel.text =[NSString stringWithFormat:@"X%zd",saleData.number];
    //设置详情..
    if (saleData.colorName.length && saleData.specName.length) {
        self.goodColorLabel.text =[NSString stringWithFormat:@"%@ | %@",saleData.colorName,saleData.specName];
    }else if (!saleData.colorName.length &&saleData.specName.length) {
        self.goodColorLabel.text =saleData.specName;
    }else if (saleData.colorName.length && !saleData.specName.length){
        self.goodColorLabel.text =saleData.colorName;
    }
    //判断是不是活动 如果是活动 用活动价 不是则用原价
    HKActiveType activeType = [self getActiveTypeByString:saleData.activityType];
    switch (activeType) {
        case HKActiveType_None:
        {
            self.activety_cover.hidden=YES;
            self.MycountLabel.text = [NSString stringWithFormat:@"￥%li",(long)saleData.integral];
        }
            break;
        case HKActiveType_BaoKuan:
        {
            self.activety_cover.hidden=NO;
            self.MycountLabel.text =[NSString stringWithFormat:@"￥%@",saleData.activityPrice];
#pragma mark 爆款指示图
            [self.activety_cover setImage:[UIImage imageNamed:@"pic_baokuan"]];
        }
            break;
        case HKActiveType_MiaoSha:
        {      self.activety_cover.hidden=NO;
              self.MycountLabel.text =[NSString stringWithFormat:@"￥%@",saleData.activityPrice];
            [self.activety_cover setImage:[UIImage imageNamed:@"pic_miaosha"]];
        }
            break;
        case HKActiveType_ZheKou:
        {
            self.activety_cover.hidden=NO;
            self.MycountLabel.text =[NSString stringWithFormat:@"￥%@",saleData.activityPrice];
            [self.activety_cover setImage:[UIImage imageNamed:@"pic_zhekou"]];
        }
            break;
        default:
            break;
    }
    
}
-(void)setModel:(Hk_subOrderList *)model {
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imgSrc] placeholderImage:[UIImage imageNamed:@"back_blck"]];
    self.goodNameLabel.text =model.title;
    self.ShopNumberLabel.text =[NSString stringWithFormat:@"X%zd",model.number];
    //设置详情..
    if (model.colorName.length && model.specName.length) {
        self.goodColorLabel.text =[NSString stringWithFormat:@"%@ | %@",model.colorName,model.specName];
    }else if (!model.colorName.length &&model.specName.length) {
        self.goodColorLabel.text =model.specName;
    }else if (model.colorName.length && !model.specName.length){
        self.goodColorLabel.text =model.colorName;
    }
    //判断是不是活动 如果是活动 用活动价 不是则用原价
    HKActiveType activeType = [self getActiveTypeByString:model.activityType];
    switch (activeType) {
        case HKActiveType_None:
        {
            self.activety_cover.hidden=YES;
            #pragma mark 修改为商品
            self.MycountLabel.text = [NSString stringWithFormat:@"￥%li",(long)model.integral];
        }
            break;
        case HKActiveType_BaoKuan:
        {
            self.activety_cover.hidden=NO;
             self.MycountLabel.text =[NSString stringWithFormat:@"￥%@",model.activityPrice];
#pragma mark 爆款指示图
            [self.activety_cover setImage:[UIImage imageNamed:@"pic_baokuan"]];
        }
            break;
        case HKActiveType_MiaoSha:
        {      self.activety_cover.hidden=NO;
             self.MycountLabel.text =[NSString stringWithFormat:@"￥%@",model.activityPrice];
            [self.activety_cover setImage:[UIImage imageNamed:@"pic_miaosha"]];
        }
            break;
        case HKActiveType_ZheKou:
        {
            self.activety_cover.hidden=NO;
             self.MycountLabel.text =[NSString stringWithFormat:@"￥%@",model.activityPrice];
            [self.activety_cover setImage:[UIImage imageNamed:@"pic_zhekou"]];
        }
            break;
        default:
            break;
    }
}
//设置详情模型
-(void)setDetailOrderCell:(orderSubMitModel *)model {
    
    self.subModel = model;
    if ([model.colorName isKindOfClass:[NSNull class]]) {
        model.colorName =@"";
    }
    if ([model.specName isKindOfClass:[NSNull class]]) {
        model.specName =@"";
    }
   //设置详情..
    if (model.colorName.length && model.specName.length) {
        self.goodColorLabel.text =[NSString stringWithFormat:@"%@ | %@",model.colorName,model.specName];
    }else if (!model.colorName.length &&model.specName.length) {
        self.goodColorLabel.text =model.specName;
    }else if (model.colorName.length && !model.specName.length){
        self.goodColorLabel.text =model.colorName;
    }
    if ([model.imgSrc isKindOfClass:[NSNull class]]) {
        model.imgSrc =@"";
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imgSrc] placeholderImage:[UIImage imageNamed:@"back_blck"]];
    
    if (![model.title isKindOfClass:[NSNull class]]) {
        self.goodNameLabel.text =model.title;
    }
    self.ShopNumberLabel.text =[NSString stringWithFormat:@"X%zd",model.number];
    self.MycountLabel.text =[NSString stringWithFormat:@"￥%zd",model.integral];
  //待支付 只有是乐购自己卖的才可以存储物
    if ([model.state isEqualToString:@"1"]&&[model.mediaUserId isEqualToString:@"0"]) {
        self.storeBtn.hidden =YES;
   
    }else {
        self.storeBtn.hidden =YES;
    }
    //判断是不是活动 如果是活动 用活动价 不是则用原价
    HKActiveType activeType = [self getActiveTypeByString:model.activityType];
    
    switch (activeType) {
        case HKActiveType_None:
        {
            self.activety_cover.hidden=YES;
            self.MycountLabel.text = [NSString stringWithFormat:@"￥%li",(long)model.integral];
        }
            break;
        case HKActiveType_BaoKuan:
        {
            self.activety_cover.hidden=NO;
             self.MycountLabel.text =[NSString stringWithFormat:@"￥%@",model.activityPrice];
#pragma mark 爆款指示图
            [self.activety_cover setImage:[UIImage imageNamed:@"pic_baokuan"]];
        }
            break;
        case HKActiveType_MiaoSha:
        {
            self.activety_cover.hidden=NO;
             self.MycountLabel.text =[NSString stringWithFormat:@"￥%@",model.activityPrice];
            [self.activety_cover setImage:[UIImage imageNamed:@"pic_miaosha"]];
        }
            break;
        case HKActiveType_ZheKou:
        {
            self.activety_cover.hidden=NO;
            self.MycountLabel.text =[NSString stringWithFormat:@"￥%@",model.activityPrice];
            [self.activety_cover setImage:[UIImage imageNamed:@"pic_zhekou"]];
        }
            break;
        default:
            break;
    }
}
#pragma mark - private
- (HKActiveType)getActiveTypeByString:(NSString *)type
{
    if ([type isKindOfClass:[NSNull class]]) {
          return HKActiveType_None;
    }
    
    if (type && [type isEqualToString:@"1"]) {
        return HKActiveType_BaoKuan;
    }
    if (type && [type isEqualToString:@"2"]) {
        return HKActiveType_MiaoSha;
    }
    if (type && [type isEqualToString:@"3"]) {
        return HKActiveType_ZheKou;
    }
    return HKActiveType_None;
}
//存入储物箱
-(void)storeCarige {
    if (self.delegete && [self.delegete respondsToSelector:@selector(saveGoodsToLocal:)]) {
        [self.delegete saveGoodsToLocal:self.subModel];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
