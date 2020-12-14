//
//  ShopHeadDetailView.m
//  IOS_ShopDetail
//
//  Created by 苟应航 on 2018/8/21.
//  Copyright © 2018年 GH. All rights reserved.
//

#import "ShopHeadDetailView.h"
@interface ShopHeadDetailView()<SDCycleScrollViewDelegate>
{
    SDCycleScrollView *_sdcylescrollview;
    NSMutableArray *_lunboArray;
    UILabel *_titlelaeb; // 头部标题
    UILabel  *_Courierlabe;// 收藏
    UILabel  *_collectionlbae;//数量
    UILabel  *_addresslabe;// 地址
    UILabel *_mothlabe;//销售量
    UILabel *_pricelabe;//价格
    UILabel *_typelabe;// 销售类型(0：酒仓，1：直供，2：预售)
    UILabel *_listinglabe; //  包装清单
    UILabel *_intrgramodel;// 送积分
}
@end

@implementation ShopHeadDetailView

-(void)setModel:(ShopModel *)model{
    _model=model;
    
}

- (instancetype)initWithFrame:(CGRect)frame countbool:(BOOL)bools{
    if (self=[super initWithFrame:frame]) {
        _lunboArray = [NSMutableArray array];
        
        [self loaddateUI];
    }
    return self;
}
-(void)loaddateUI{
    //    SCREEN_HEIGHT==812.0?-44:-22
    NSArray *arr=@[@"https://img14.360buyimg.com/n0/jfs/t14101/290/490764935/147024/5c8a1a72/5a0ced54Nbfe8b68b.jpg",@"https://img14.360buyimg.com/n0/jfs/t13321/306/499994585/112785/ed2942d1/5a0ced54N337de281.jpg"];
    _sdcylescrollview = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH,400*SCALEWITH6) delegate:self placeholderImage:nil];
    _sdcylescrollview.imageContenMode = UIViewContentModeScaleAspectFill;
    _sdcylescrollview.showPageControl=YES;
    _sdcylescrollview.currentPageDotImage=GHImage(@"sdcynorml");
    _sdcylescrollview.pageDotImage=GHImage(@"sdcyselect");
    _sdcylescrollview.pageControlAliment=SDCycleScrollViewPageContolAlimentCenter;
    _sdcylescrollview.autoScrollTimeInterval=5.0f;
   _sdcylescrollview.imageURLStringsGroup = arr;
    [self addSubview:_sdcylescrollview];
    

    
    UILabel *titlelaeb=[UILabel new];
    titlelaeb.numberOfLines=2;
    [self uilabe:titlelaeb Color:AlltexthighlightedColor Nstring:@"茅台 金王子 53度 白酒 500ml 单瓶装 口感酱香型" Font:GHSonBole(sizecenter)];
    [self addSubview:titlelaeb];
    _titlelaeb=titlelaeb;
    [titlelaeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(21*SCALEWITH6);
        make.right.mas_equalTo(self.mas_right).mas_offset(-21*SCALEWITH6);
        make.top.mas_equalTo(self->_sdcylescrollview.mas_bottom).mas_offset(30*SCALEWITH6);
    }];
    
    
    UILabel  *Courierlabe=[UILabel new];
    Courierlabe.textAlignment=NSTextAlignmentLeft;
    [self uilabe:Courierlabe Color:AlltextgrayColor Nstring:@"收藏：1234" Font:GHFont(sizemin)];
    [self addSubview:Courierlabe];
    _Courierlabe=Courierlabe;
    [Courierlabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelaeb.mas_left);
        make.top.mas_equalTo(titlelaeb.mas_bottom).mas_offset(10*SCALEWITH6);
        make.height.mas_equalTo(30*SCALEWITH6);
    }];
    
    UILabel  *collectionlbae=[UILabel new];
    collectionlbae.textAlignment=NSTextAlignmentCenter;
    [self uilabe:collectionlbae Color:AlltextgrayColor Nstring:@"数量：4345" Font:GHFont(sizemin)];
    [self addSubview:collectionlbae];
    _collectionlbae=collectionlbae;
    [collectionlbae mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Courierlabe.mas_top);
        make.height.mas_equalTo(Courierlabe.mas_height);
        make.left.mas_equalTo(SCREEN_WIDTH/3);
    }];
    
    
    
    UILabel *mothlabe=[UILabel new];
    mothlabe.textAlignment=NSTextAlignmentRight;
    [self uilabe:mothlabe Color:AlltextgrayColor Nstring:@"销售量：1234" Font:GHFont(sizemin)];
    [self addSubview:mothlabe];
    _mothlabe=mothlabe;
    [mothlabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(titlelaeb.mas_right);
        make.centerY.mas_equalTo(Courierlabe.mas_centerY);
    }];
    
    UILabel  *addresslabe=[UILabel new];
    [self uilabe:addresslabe Color:AlltextgrayColor Nstring:@"贵州贵阳" Font:GHFont(sizemin)];
    [self addSubview:addresslabe];
    _addresslabe=addresslabe;
    [addresslabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(mothlabe.mas_left).mas_offset(-30);
        make.centerY.mas_equalTo(Courierlabe.mas_centerY);    }];
    
    
    UILabel *listinglabe=[UILabel new];
    [self uilabe:listinglabe Color:AlltextgrayColor Nstring:@"包装清单：？？？" Font:GHFont(sizemin)];
    [self addSubview:listinglabe];
    _listinglabe=listinglabe;
    [listinglabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelaeb.mas_left);
        make.top.mas_equalTo(Courierlabe.mas_bottom).mas_offset(10*SCALEWITH6);
    }];
    
    
    UILabel *pricelabe=[UILabel new];
    [self uilabe:pricelabe Color:AllxianBinColor Nstring:@"¥:2344元" Font:GHSonBole(sizecenter+3)];
    [self addSubview:pricelabe];
    _pricelabe=pricelabe;
    [pricelabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titlelaeb.mas_left);
        make.top.mas_equalTo(self->_listinglabe.mas_bottom).mas_offset(30*SCALEWITH6);
    }];
    
    UILabel *typelabe=[UILabel new];
    typelabe.text=@"GH自营";
    typelabe.textColor=Kwhite;
    typelabe.font=GHFont(10);
    typelabe.textAlignment=NSTextAlignmentCenter;
    [self addSubview:typelabe];
    _typelabe=typelabe;
    [typelabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(pricelabe.mas_centerY);
        make.right.mas_equalTo(titlelaeb.mas_right);
        make.width.mas_equalTo(60*SCALEWITH6);
        make.height.mas_equalTo(20*SCALEWITH6);
    }];
    
    
    
    
    
    
    UILabel *fourleanlabe=[UILabel new];
    fourleanlabe.backgroundColor=lencolor;
    [self addSubview:fourleanlabe];
    [fourleanlabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(9*SCALEWITH6);
    }];
    
    
}
-(void)uilabe:(UILabel *)labbe Color:(UIColor *)color Nstring:(NSString *)string Font:(UIFont *)font{
    labbe.text=string;
    labbe.textColor=color;
    labbe.font=font;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
