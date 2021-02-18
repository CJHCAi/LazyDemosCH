//
//  GennerTableViewCell.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "GennerTableViewCell.h"
@interface GennerTableViewCell()
@property (nonatomic,strong) UIScrollView *scrollView; /*左右滚动*/

@end

@implementation GennerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
          
    }
    return self;
}

#pragma mark *** 初始化数据 ***
-(void)initData{
    
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    
}

//头像和详情
-(void)initPorInfo{
    [self.contentView removeAllSubviews];
    [self.scrollView removeAllSubviews];
    [self.contentView addSubview:self.generNumber];
    [self.contentView addSubview:self.personNumber];
    [self.contentView addSubview:self.perName];
    
    UIView *bacView = [[UIView alloc] initWithFrame:AdaptationFrame(CGRectXW(self.generNumber)/AdaptationWidth(), 0, 90, 339)];
    [self.contentView addSubview:bacView];
    [CALayer drawLeftBorder:bacView];
    [CALayer drawRightBorder:bacView];
    
    NSArray *perArr = @[@"",@"",@""];
    NSArray *infoArr = @[@[@"",@"",@""],@[@"",@"",@""],@[@"",@"",@""]];
//    NSArray *proUrl = @[@[@"",@"",@""],@[@"",@"",@""],@[@"",@"",@""]];
    NSArray *proUrl = nil;

    if (_nameArr) {
        perArr = _nameArr;
    }
    if (_idArr) {
        infoArr = _idArr;
        
    }
    if (_proImageUrlArr) {
        proUrl = _proImageUrlArr;
    }
    
    for (int idx = 0; idx<perArr.count; idx++) {
        
        PortraiView *porInfo = [[PortraiView alloc] initWithFrame:AdaptationFrame(35+idx*(110+48), 43, 110, 253) portaitImageUrl:proUrl[idx] porName:perArr[idx] infoArr:infoArr[idx]];
        porInfo.mygemId = _genIdArr[idx];
        [self.scrollView addSubview:porInfo];
        self.scrollView.contentSize = AdaptationSize(35+(158)*perArr.count, 339);

    }
    
    
    //根据数据计算滚动图大小
    
    [self.contentView addSubview:self.scrollView];

    
}

#pragma mark *** getters ***

-(UILabel *)generNumber{
    if (!_generNumber) {
        _generNumber = [[UILabel alloc] initWithFrame:AdaptationFrame(0, 123, 112, 40)];
        _generNumber.text = @"第几代";
        _generNumber.textAlignment = 1;
        _generNumber.font = MFont(15);
        
    }
    return _generNumber;
}
-(UILabel *)personNumber{
    if (!_personNumber) {
        _personNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectYH(self.generNumber)+20*AdaptationWidth(), self.generNumber.bounds.size.width, _generNumber.bounds.size.height)];
        _personNumber.text = @"2人";
        _personNumber.font = MFont(14);
        _personNumber.textAlignment = 1;
        
    }
    return _personNumber;
}
-(UILabel *)perName{
    if (!_perName) {
        _perName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectXW(self.generNumber), 20*AdaptationWidth(), 95*AdaptationWidth(), 90)];
        _perName.textAlignment = 1;
        _perName.numberOfLines = 0;
        _perName.font = MFont(15);
        
    }
    return _perName;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame: AdaptationFrame(CGRectXW(self.generNumber)/AdaptationWidth()+90, 0, 35+(158)*3, 339)];
        _scrollView.contentSize = AdaptationSize(35+(158)*_nameArr.count, 339);
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}

@end
