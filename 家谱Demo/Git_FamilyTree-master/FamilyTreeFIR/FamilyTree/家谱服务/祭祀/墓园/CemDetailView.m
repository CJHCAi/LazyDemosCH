//
//  CemDetailView.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CemDetailView.h"
@interface CemDetailView()

@property (nonatomic,strong) UIImageView *headView; /*头像*/
@property (nonatomic,strong) UILabel *perName; /*名字*/
@property (nonatomic,strong) UILabel *cherLabel; /*缅怀语*/
@property (nonatomic,strong) UILabel *birLabel; /*生*/
@property (nonatomic,strong) UILabel *deadLabel; /*卒*/


@end
@implementation CemDetailView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headView];
        [self addSubview:self.cherLabel];
        [self addSubview:self.perName];
        [self addSubview:self.birLabel];
        [self addSubview:self.deadLabel];
    }
    return self;
}

-(void)setCemeteryModel:(CemeteryModel *)cemeteryModel{
    _cemeteryModel = cemeteryModel;
    if (![cemeteryModel.CeMaster isEqualToString:@""]) {
       self.perName.text = [NSString verticalStringWith:[NSString stringWithFormat:@"%@%@之墓",cemeteryModel.CeTitle,cemeteryModel.CeMaster]];
    }else{
        self.perName.text = @"";
    }
    
    [self.perName sizeToFit];
    self.cherLabel.text = [NSString verticalStringWith:cemeteryModel.CeEpitaph];
    [_cherLabel sizeToFit];
    self.birLabel.text = [NSString stringWithFormat:@"生\n%@",cemeteryModel.CeBrithday];
    [_birLabel sizeToFit];
    self.deadLabel.text = [NSString stringWithFormat:@"卒\n%@",cemeteryModel.CeDeathday];
    [_deadLabel sizeToFit];
    
    [self.headView setImageWithURL:[NSURL URLWithString:cemeteryModel.CePhoto] placeholder:MImage(@"my_name_touxiang")];
}


-(UIImageView *)headView{
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithFrame:AdaptationFrame(self.bounds.size.width/2/AdaptationWidth()-85/2, 20, 85, 85)];
        //_headView.image = MImage(@"my_name_touxiang");
        
    }
    return _headView;
}
-(UILabel *)cherLabel{
    if (!_cherLabel) {
        _cherLabel = [[UILabel alloc] initWithFrame:CGRectMake(40*AdaptationWidth(), CGRectYH(self.headView)+20*AdaptationWidth(), 27*AdaptationWidth(), 280*AdaptationWidth())];
        //_cherLabel.text = [NSString verticalStringWith:@"亲恩莫失恋 离世到天庭"];
        _cherLabel.numberOfLines = 0;
        _cherLabel.font = MFont(15*AdaptationWidth());
        _cherLabel.textColor = [UIColor whiteColor];
        [_cherLabel sizeToFit];
    }
    return _cherLabel;
}
-(UILabel *)perName{
    if (!_perName) {
        _perName = [[UILabel alloc] initWithFrame:CGRectMake(self.headView.center.x-20*AdaptationWidth(), CGRectYH(self.headView)+5*AdaptationWidth(), 40*AdaptationWidth(), 300*AdaptationWidth())];
        _perName.numberOfLines = 0;
        _perName.font = MFont(27*AdaptationWidth());
        //_perName.text = [NSString verticalStringWith:@"慈父朱万成之墓"];
        _perName.textColor = self.cherLabel.textColor;
        //[_perName sizeToFit];
    }
    return _perName;
}
-(UILabel *)birLabel{
    if (!_birLabel) {
        _birLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headView.frame), CGRectYH(self.headView)+20*AdaptationWidth(), 27*AdaptationWidth(), 280*AdaptationWidth())];
        _birLabel.numberOfLines = 0;
        _birLabel.font = MFont(15*AdaptationWidth());
        //_birLabel.text = [NSString verticalStringWith:@"卒 二零零六年五月二十七日"];
        _birLabel.textColor = self.cherLabel.textColor;
        //[_birLabel sizeToFit];
    }
    return _birLabel;
}
-(UILabel *)deadLabel{
    if (!_deadLabel) {
        _deadLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectXW(self.birLabel)+10*AdaptationWidth(), CGRectYH(self.headView)+20*AdaptationWidth(), 27*AdaptationWidth(), 280*AdaptationWidth())];
        _deadLabel.numberOfLines = 0;
        _deadLabel.font = MFont(15*AdaptationWidth());
        //_deadLabel.text = [NSString verticalStringWith:@"生 一九二九年九月十五日"];
        _deadLabel.textColor = self.birLabel.textColor;
        //[_deadLabel sizeToFit];
    }
    return _deadLabel;
}
@end
