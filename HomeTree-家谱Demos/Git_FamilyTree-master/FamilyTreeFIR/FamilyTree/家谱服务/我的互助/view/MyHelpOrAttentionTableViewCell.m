//
//  MyHelpOrAttentionTableViewCell.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/28.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "MyHelpOrAttentionTableViewCell.h"

@interface MyHelpOrAttentionTableViewCell()
/** 灰色背景*/
@property (nonatomic, strong) UIView *grayBackV;
/** 标题*/
@property (nonatomic, strong) UILabel *customTitleLB;
/** 状态标签*/
@property (nonatomic, strong) UILabel *typeLB;
/** 图片*/
@property (nonatomic, strong) UIImageView *infoIV;
/** 已关注人数*/
@property (nonatomic, strong) UILabel *alreadyAttentionNumLB;
/** 意向联系人数*/
@property (nonatomic, strong) UILabel *purposeConnectNumLB;
/** 剩余天数*/
@property (nonatomic, strong) UILabel *deadLineDayNumLB;
/** 进行中图*/
@property (nonatomic, strong) UIImageView *isGoingIV;
@end

@implementation MyHelpOrAttentionTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)setMyHelpModel:(MyHelpModel *)myHelpModel{
    _myHelpModel = myHelpModel;
    _customTitleLB.text = myHelpModel.ZqTitle;
    _typeLB.text = myHelpModel.ZqType;
    [_infoIV setImageWithURL:[NSURL URLWithString:myHelpModel.ZqCover] placeholder:MImage(@"")];
    _alreadyAttentionNumLB.text = [NSString stringWithFormat:@"%ld",(long)myHelpModel.ZqFollowcnt];
    [_alreadyAttentionNumLB sizeToFit];
    _purposeConnectNumLB.text = [NSString stringWithFormat:@"%ld",(long)myHelpModel.ZqIntencnt];
    [_purposeConnectNumLB sizeToFit];
    _deadLineDayNumLB.text = [NSString stringWithFormat:@"%ld",(long)myHelpModel.Syts];
    [_deadLineDayNumLB sizeToFit];
    _isGoingIV.image = [_myHelpModel.ZqState isEqualToString:@"进行中"]?MImage(@"wdhz_jinxingzhong"):MImage(@"wdhz_yiwancheng");
}

#pragma mark - 视图初始化
-(void)initUI{
    [self addSubview:self.grayBackV];
    self.grayBackV.sd_layout.leftSpaceToView(self,0).rightSpaceToView(self,0).topSpaceToView(self,0).heightIs(30);
    [self.grayBackV addSubview:self.customTitleLB];
    self.customTitleLB.sd_layout.leftSpaceToView(self.grayBackV,5).rightSpaceToView(self.typeLB,5).heightIs(30).topSpaceToView(self.grayBackV,0);
    [self.grayBackV addSubview:self.typeLB];
    self.typeLB.sd_layout.widthIs(50).heightIs(20).rightSpaceToView(self.grayBackV,10).leftSpaceToView(self.customTitleLB,5).topSpaceToView(self.grayBackV,5);
    [self addSubview:self.infoIV];
    self.infoIV.sd_layout.leftSpaceToView(self,10).topSpaceToView(self.grayBackV,10).widthIs(68).heightIs(68);
    /** 已关注人数*/
    UILabel *alreadyAttentionLB = [[UILabel alloc]init];
    alreadyAttentionLB.text = @"已关注人数:";
    alreadyAttentionLB.font = MFont(12);
    [self addSubview:alreadyAttentionLB];
    alreadyAttentionLB.sd_layout.leftSpaceToView(self.infoIV,10).topSpaceToView(self.grayBackV,10).widthIs(65).heightIs(20);
    
    UIImageView *alreadAttentionIV = [[UIImageView alloc]init];
    alreadAttentionIV.image = MImage(@"wdhz_guanzhu");
    [self addSubview:alreadAttentionIV];
    alreadAttentionIV.sd_layout.leftSpaceToView(alreadyAttentionLB,0).topSpaceToView(self.grayBackV,15).heightIs(12).widthIs(12);
    
    self.alreadyAttentionNumLB = [[UILabel alloc]initWithFrame:CGRectMake(168, 43, 100, 12)];
    self.alreadyAttentionNumLB.font = MFont(12);
    self.alreadyAttentionNumLB.textColor = LH_RGBCOLOR(251, 59, 56);
    [self addSubview:self.alreadyAttentionNumLB];
    
    UILabel *personLB1 = [[UILabel alloc]init];
    personLB1.font = MFont(12);
    personLB1.text = @"人";
    [self addSubview:personLB1];
    personLB1.sd_layout.leftSpaceToView(self.alreadyAttentionNumLB,0).topSpaceToView(self.grayBackV,14).widthIs(12).heightIs(12);
    
    /** 意向联系人数*/
    UILabel *purposeConnectLB = [[UILabel alloc]init];
    purposeConnectLB.text = @"意向联系:";
    purposeConnectLB.font = MFont(12);
    [self addSubview:purposeConnectLB];
    purposeConnectLB.sd_layout.leftEqualToView(alreadyAttentionLB).topSpaceToView(alreadyAttentionLB,5).widthIs(55).heightIs(20);
    
    UIImageView *purposeConnectIV = [[UIImageView alloc]init];
    purposeConnectIV.image = MImage(@"wdhz_yixianglianxi");
    [self addSubview:purposeConnectIV];
    purposeConnectIV.sd_layout.leftSpaceToView(purposeConnectLB,0).topSpaceToView(alreadyAttentionLB,10).heightIs(12).widthIs(12);
    
    self.purposeConnectNumLB = [[UILabel alloc]initWithFrame:CGRectMake(160, 68, 100, 12)];
    self.purposeConnectNumLB.font = MFont(12);
    self.purposeConnectNumLB.textColor = LH_RGBCOLOR(251, 59, 56);
    [self addSubview:self.purposeConnectNumLB];
    
    UILabel *personLB2 = [[UILabel alloc]init];
    personLB2.font = MFont(12);
    personLB2.text = @"人";
    [self addSubview:personLB2];
    personLB2.sd_layout.leftSpaceToView(self.purposeConnectNumLB,0).topSpaceToView(self.grayBackV,39).widthIs(12).heightIs(12);
    
    /** 剩余天数*/
    UILabel *deadLineDayLB = [[UILabel alloc]init];
    deadLineDayLB.text = @"剩余天数:";
    deadLineDayLB.font = MFont(12);
    [self addSubview:deadLineDayLB];
    deadLineDayLB.sd_layout.leftEqualToView(alreadyAttentionLB).topSpaceToView(purposeConnectLB,5).widthIs(55).heightIs(20);
    
    UIImageView * deadLineDayIV = [[UIImageView alloc]init];
    deadLineDayIV.image = MImage(@"wdhz_shixian");
    [self addSubview: deadLineDayIV];
     deadLineDayIV.sd_layout.leftSpaceToView(deadLineDayLB,0).topSpaceToView(purposeConnectLB,10).heightIs(12).widthIs(12);
    
    self.deadLineDayNumLB = [[UILabel alloc]initWithFrame:CGRectMake(160, 93, 100, 12)];
    self.deadLineDayNumLB.font = MFont(12);
    self.deadLineDayNumLB.textColor = LH_RGBCOLOR(251, 59, 56);
    [self addSubview:self.deadLineDayNumLB];
    
    UILabel *personLB3 = [[UILabel alloc]init];
    personLB3.font = MFont(12);
    personLB3.text = @"人";
    [self addSubview:personLB3];
    personLB3.sd_layout.leftSpaceToView(self.deadLineDayNumLB,0).topSpaceToView(self.grayBackV,64).widthIs(12).heightIs(12);
    
    //进行中图
    self.isGoingIV = [[UIImageView alloc]init];
    //self.isGoingIV.backgroundColor = [UIColor redColor];
    [self addSubview:self.isGoingIV];
    self.isGoingIV.sd_layout.rightSpaceToView(self,20).topSpaceToView(self.grayBackV,20).widthIs(45).heightIs(45);
}

#pragma mark - 点击方法
-(void)clickMyNeedBtn{
    MYLog(@"我需要");
}
#pragma mark - lazyLoad
-(UIView *)grayBackV{
    if (!_grayBackV) {
        _grayBackV = [[UIView alloc]init];
        _grayBackV.backgroundColor = LH_RGBCOLOR(235, 236, 237);
    }
    return _grayBackV;
}

-(UILabel *)customTitleLB{
    if (!_customTitleLB) {
        _customTitleLB = [[UILabel alloc]init];
        _customTitleLB.font = MFont(12);
        _customTitleLB.textAlignment = NSTextAlignmentLeft;
    }
    return _customTitleLB;
}

-(UILabel *)typeLB{
    if (!_typeLB) {
        _typeLB = [[UILabel alloc]init];
        _typeLB.font = MFont(11);
        _typeLB.textColor = [UIColor redColor];
        _typeLB.textAlignment = NSTextAlignmentCenter;
        _typeLB.layer.borderWidth = 1;
        _typeLB.layer.borderColor = [UIColor redColor].CGColor;
        _typeLB.layer.cornerRadius = 5.0f;

    }
    return _typeLB;
}

-(UIImageView *)infoIV{
    if (!_infoIV) {
        _infoIV = [[UIImageView alloc]init];
    }
    return _infoIV;
}
@end
