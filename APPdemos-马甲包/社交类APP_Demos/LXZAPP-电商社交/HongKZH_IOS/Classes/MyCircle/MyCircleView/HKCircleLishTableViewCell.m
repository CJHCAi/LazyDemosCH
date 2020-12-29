//
//  HKCircleLishTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCircleLishTableViewCell.h"
//#import "HK_CludlyGoodFrendModel.h"
//#import "HK_CludlyGoodFrendData.h"
#import "HKCircleLishTableViewCell.h"
#import "ZSUserHeadBtn.h"
#import "UIButton+WebCache.h"
@interface HKCircleLishTableViewCell()
@property (nonatomic, strong)ZSUserHeadBtn * circularButtonN;
@property (nonatomic, strong)UILabel *rightBTwoNN ;
@property (nonatomic, strong)UIButton *rightBTwo ;
@property (nonatomic, strong)UILabel *titleF;
@property (nonatomic, strong)UIView *svline3;
@end

@implementation HKCircleLishTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        ZSUserHeadBtn * circularButtonN = [[ZSUserHeadBtn alloc] init];
        
        circularButtonN.backgroundColor = [UIColor clearColor];
        [circularButtonN.layer setMasksToBounds:YES];//边框宽度
        _circularButtonN = circularButtonN;
        
        UILabel *rightBTwoNN = [UILabel new];
        rightBTwoNN.backgroundColor = [UIColor clearColor];
        rightBTwoNN.font = [UIFont systemFontOfSize:16];
        rightBTwoNN.textAlignment = NSTextAlignmentCenter;
        rightBTwoNN.textColor = UICOLOR_RGB_Alpha(0x333333, 1);
        _rightBTwoNN = rightBTwoNN;
        
        UIButton *rightBTwo= [UIButton new];
        rightBTwo.backgroundColor = [UIColor clearColor];
        [rightBTwo setTitle:@"" forState:UIControlStateNormal];
        [rightBTwo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBTwo addTarget:self action:@selector(cicleBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [rightBTwo setBackgroundImage:[UIImage imageNamed:@"list_right"] forState:UIControlStateNormal];
        [rightBTwo setBackgroundImage:[UIImage imageNamed:@"list_right"] forState:UIControlStateHighlighted];
        rightBTwo.titleLabel.font = [UIFont systemFontOfSize: 16.0];
        [rightBTwo.layer setCornerRadius:0];
        rightBTwo.titleLabel.textColor = [UIColor lightGrayColor];
        _rightBTwo = rightBTwo;
        [self.contentView addSubview:circularButtonN];
        [circularButtonN mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(10);
            make.left.equalTo(self.contentView).with.offset(12);
            make.size.mas_equalTo(CGSizeMake(48,48));
        }];
        [self.contentView addSubview:rightBTwoNN];
        [rightBTwoNN mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(17);
            make.left.equalTo(circularButtonN.mas_right).with.offset(8);
            make.height.mas_lessThanOrEqualTo(100000);
            make.width.mas_lessThanOrEqualTo(100000);
        }];
        UILabel *titleF = [UILabel new];
        titleF.backgroundColor = [UIColor clearColor];
        titleF.font = [UIFont systemFontOfSize:13];
        titleF.textAlignment = NSTextAlignmentCenter;
        titleF.textColor = UICOLOR_RGB_Alpha(0x999999, 1);
        titleF.text = @"  ";
        _titleF = titleF;
        [self.contentView addSubview:titleF];
        [titleF mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rightBTwoNN.mas_bottom).with.offset(5);
            make.left.equalTo(circularButtonN.mas_right).with.offset(8);
            make.height.mas_lessThanOrEqualTo(100000);
            make.width.mas_lessThanOrEqualTo(100000);
        }];
        
        [self.contentView addSubview:rightBTwo];
        [rightBTwo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(27);
            make.left.equalTo(self.contentView.mas_right).with.offset(-26);
            make.size.mas_equalTo(CGSizeMake(16,16));
        }];
        
        
        [self.contentView addSubview:rightBTwo];
        [rightBTwo mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(27);
            make.left.equalTo(self.contentView.mas_right).with.offset(-26);
            make.size.mas_equalTo(CGSizeMake(16,16));
        }];
        UIView *svline3 = [UIView new];
        svline3.backgroundColor =UICOLOR_RGB_Alpha(0xf1f1f1, 1);
        [self.contentView addSubview:svline3];
        _svline3 = svline3;
        [svline3 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(0);
            make.left.equalTo(self.contentView).with.offset(70);
            make.size.mas_equalTo(CGSizeMake(kScreenWidth-70,0.5));
        }];
    }
    return self;
}
+(instancetype)circleLishTableViewCellWithTableView:(UITableView*)tableView{
    static NSString*ID = @"HKCircleLishTableViewCell";
    HKCircleLishTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HKCircleLishTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
//-(void)setModelWithHK_CludlyGoodFrendModel:(HK_CludlyGoodCircleModel*)model andHK_CludlyGoodFrendData:(HK_CludlyGoodCircleData*)item andshopsNew:(NSMutableArray*)shopsNew andIndexPath:(NSIndexPath*)indexPath{
//if (item && item.coverImgSrc&&[item.coverImgSrc isKindOfClass:[NSString class]]&&item.coverImgSrc.length>0) {
//    [self.circularButtonN sd_setBackgroundImageWithURL:[NSURL URLWithString:item.coverImgSrc] forState:0 placeholderImage:[UIImage imageNamed:@"imgDefault_bg"]];
//
//}
//else
//{
//    [self.circularButtonN sd_setBackgroundImageWithURL:[NSURL URLWithString:@""] forState:0 placeholderImage:[UIImage imageNamed:@"imgDefault_bg"]];
//}
//    if (item.circleName&&[item.circleName isKindOfClass:[NSString class]]&&item.circleName.length>0)
//    {
//        self.rightBTwoNN.text = item.circleName;
//    }
//    if (item.categoryName&&[item.categoryName isKindOfClass:[NSString class]]&&item.categoryName.length>0)
//    {
//        self.titleF.text = item.categoryName;
//    }
//    if (shopsNew&&shopsNew.count>0) {
//        if (indexPath.section > shopsNew.count ) {
//        }
//        NSString *imaH =  [shopsNew objectAtIndex:indexPath.section-1];
//        if ([imaH intValue] > 0 &&indexPath.row>0) {
//            self.svline3.hidden = NO;
//
//        }else{
//             self.svline3.hidden = YES;
//        }
//    }
//}

-(void)cicleBtnPressed {
    if (self.block) {
        self.block(self.model);
    }
}
-(void)setModel:(HKClicleListModel *)model{
    _model = model;
    [self.circularButtonN sd_setBackgroundImageWithURL:[NSURL URLWithString:model.coverImgSrc] forState:0 placeholderImage:[UIImage imageNamed:@"imgDefault_bg"]];
    if (model.circleName&&[model.circleName isKindOfClass:[NSString class]]&&model.circleName.length>0)
    {
        self.rightBTwoNN.text = model.circleName;
    }
    if (model.categoryName&&[model.categoryName isKindOfClass:[NSString class]]&&model.categoryName.length>0)
    {
        self.titleF.text = model.categoryName;
    }
    
    
    
    
    
    
    
//    if (shopsNew&&shopsNew.count>0) {
//        if (indexPath.section > shopsNew.count ) {
//        }
//        NSString *imaH =  [shopsNew objectAtIndex:indexPath.section-1];
//        if ([imaH intValue] > 0 &&indexPath.row>0) {
//            self.svline3.hidden = NO;
//
//        }else{
//            self.svline3.hidden = YES;
//        }
//    }
}
@end
