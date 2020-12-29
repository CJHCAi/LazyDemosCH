//
//  HKShopHeadView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/9/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKShopHeadView.h"
#import "HK_headSectionView.h"
@interface HKShopHeadView ()
@property (nonatomic, strong)UIImageView * icon;
@property (nonatomic, strong)UILabel *shopNameLabel;
@property (nonatomic, strong)UILabel *detailLabel;
@property (nonatomic, strong)NSMutableArray *sectionArr;
@property (nonatomic, strong)UIView *lineV;

@end

@implementation HKShopHeadView

-(NSMutableArray *)sectionArr {
    if (!_sectionArr) {
        _sectionArr =[[NSMutableArray alloc] init];
    }
    return _sectionArr;
}
-(instancetype)initWithFrame:(CGRect)frame {
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        [self addSubview:self.icon];
        [self addSubview:self.shopNameLabel];
        [self addSubview:self.detailLabel];
        [self addSubview:self.saveBtn];
        [self addSubview:self.lineV];
        [self setsectionViews];
    }
    return  self;
    
}
-(UIImageView *)icon {
    if (!_icon) {
        UIImage *logo =[UIImage imageNamed:@"dp_logo_03"];
        _icon =[[UIImageView alloc] initWithFrame:CGRectMake(15,15,logo.size.width,logo.size.height)];
        _icon.image =logo;
    }
    return _icon;
}
-(UILabel *)shopNameLabel {
    if (!_shopNameLabel) {
        _shopNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.icon.frame)+10,CGRectGetMinY(self.icon.frame)+3,300,20)];
        [AppUtils getConfigueLabel:_shopNameLabel font:PingFangSCMedium15 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@"科比迪官方旗舰店"];
    }
    return _shopNameLabel;
}
-(UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.shopNameLabel.frame),CGRectGetMaxY(self.shopNameLabel.frame)+6,CGRectGetWidth(self.shopNameLabel.frame),10)];
        [AppUtils getConfigueLabel:_detailLabel font:PingFangSCRegular10 aliment:NSTextAlignmentLeft textcolor:RGB(153,153, 153) text:@"3489人收藏  销量94万件"];
    }
    return _detailLabel;
}
-(UIButton *)saveBtn {
    if (!_saveBtn) {
        UIImage *saim =[UIImage imageNamed:@"dp_sc"];
        _saveBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame = CGRectMake(kScreenWidth-15-saim.size.width,CGRectGetMinY(self.shopNameLabel.frame),saim.size.width,saim.size.height);
        [_saveBtn setImage:saim forState:UIControlStateNormal];
        [_saveBtn addTarget:self
                     action:@selector(saveShops:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

-(void)saveShops:(UIButton *)sender {
    if ([self.delegete respondsToSelector:@selector(saveBlock:)]) {
        [self.delegete saveBlock:self.response];
    }
}
-(UIView *)lineV {
    if (!_lineV) {
        _lineV =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.icon.frame)+10,kScreenWidth,1)];
        _lineV.backgroundColor = RGB(226,226,226);
    }
    return _lineV;
}

-(void)setsectionViews {
    NSArray * titles =@[@"商品",@"上新",@"热销",@"销量"];
    NSArray * count =@[@"0",@"0",@"0",@"0"];
    for (int i =0; i<titles.count; i++) {
        HK_headSectionView * sectionV =[[HK_headSectionView alloc] initWithFrame:CGRectMake(i*kScreenWidth/4,CGRectGetMaxY(self.lineV.frame)+15,kScreenWidth/4,50)];
        sectionV.countLabel.text = count[i];
        sectionV.nameLabel.text = titles[i];
        sectionV.tag =100+i;
        sectionV.userInteractionEnabled = YES;
        UITapGestureRecognizer * tapSec =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionIndexed:)];
        [sectionV addGestureRecognizer:tapSec];
        [self.sectionArr addObject:sectionV];
        [self addSubview:sectionV];
    }
}

-(void)sectionIndexed:(UITapGestureRecognizer *)tap {
    HK_headSectionView  *sec =(HK_headSectionView *)tap.view;
    if (self.delegete && [self.delegete respondsToSelector:@selector(pushHomeWithIndex:)]) {
        [self.delegete pushHomeWithIndex:sec.tag-100];
    }
}
-(void)setResponse:(HKShopResponse *)response {
    _response =response;
  //  [AppUtils seImageView:self.icon withUrlSting:response.data.imgSrc placeholderImage:nil];
    [self.icon sd_setImageWithURL:[NSURL URLWithString:response.data.imgSrc]];
    self.shopNameLabel.text =response.data.name;
    self.detailLabel.text =[NSString stringWithFormat:@"%zd人收藏  销量 %zd件",response.data.collectCount,response.data.orderCount];
    if (response.data.isCollect==1) {
        [self.saveBtn setImage:[UIImage imageNamed:@"dp_ysc"] forState:UIControlStateNormal];
    }else {
        [self.saveBtn setImage:[UIImage imageNamed:@"dp_sc"] forState:UIControlStateNormal];
    }
}
-(void)setInfo:(HKShopInfo *)info {
   //商品
    HK_headSectionView * secP =[self.sectionArr objectAtIndex:0];
    secP.countLabel.text =[NSString stringWithFormat:@"%zd",info.data.products];
   //上新
    HK_headSectionView *secNewGoods =[self.sectionArr objectAtIndex:1];
    secNewGoods.countLabel.text =[NSString stringWithFormat:@"%zd",info.data.news];
   //热销
    HK_headSectionView *secHot =[self.sectionArr objectAtIndex:2];
    secHot.countLabel.text =[NSString stringWithFormat:@"%zd",info.data.hots];
    //销量
    HK_headSectionView *secSale =[self.sectionArr objectAtIndex:3];
    secSale.countLabel.text =[NSString stringWithFormat:@"%zd",info.data.orders];
  
}
@end
