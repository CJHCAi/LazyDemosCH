//
//  CemIntroViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "CemIntroViewController.h"

@interface CemIntroViewController ()

@property (nonatomic,strong) UIScrollView *backScroView; /*背景滚动图*/


@property (nonatomic,strong) UIImageView *backView; /*背景图*/
@property (nonatomic,strong) UIImageView *headView; /*头像*/

@property (nonatomic,strong) UILabel *nameLabel; /*名称*/

@property (nonatomic,strong) UILabel *birDeadLabel; /*生-卒*/

@property (nonatomic,strong) UILabel *detailLabel; /*内容*/



@end

@implementation CemIntroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];

}
#pragma mark *** 初始化数据 ***
-(void)initData{
    [self.headView setImageWithURL:[NSURL URLWithString:self.cemeteryModel.CePhoto] placeholder:MImage(@"jcjs_huamn")];
    self.nameLabel.text = self.cemeteryModel.CeMaster;
    self.birDeadLabel.text = [NSString stringWithFormat:@"(%@)",self.cemeteryModel.CeScjr];
    self.detailLabel.text = self.cemeteryModel.CeBrief;
    [self.detailLabel sizeToFit];
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    [self.view addSubview:self.backScroView];
    [self.backScroView addSubview:self.backView];
    [self.backScroView addSubview:self.headView];
    [self.backScroView addSubview:self.nameLabel];
    [self.backScroView addSubview:self.birDeadLabel];
    [self.backScroView addSubview:self.detailLabel];
}
#pragma mark *** getters ***

-(UIScrollView *)backScroView{
    if (!_backScroView) {
        _backScroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, HeightExceptNaviAndTabbar)];
        _backScroView.contentSize = AdaptationSize(720, CGRectGetMaxY(self.detailLabel.frame)/AdaptationWidth());
        _backScroView.bounces = false;
        
    }
    return _backScroView;
}

-(UIImageView *)backView{
    if (!_backView) {
        _backView = [[UIImageView alloc] initWithFrame:AdaptationFrame(0, 0, Screen_width/AdaptationWidth(), 1340)];
        _backView.image = MImage(@"jcjs_bg");
    }
    return _backView;
}
-(UIImageView *)headView{
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithFrame:AdaptationFrame(230, 126, 266, 315)];
        _headView.layer.borderWidth = 5.0f;
        _headView.layer.borderColor = LH_RGBCOLOR(40, 94, 108).CGColor;
        //_headView.image = MImage(@"jcjs_huamn");
    }
    return _headView;
}
-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(230, CGRectYH(self.headView)/AdaptationWidth()+30, 266, 40)];
        _nameLabel.font = MFont(28*AdaptationWidth());
        _nameLabel.textAlignment = 1;
        //_nameLabel.text = @"詹姆斯 ● 迪恩";
    }
    return _nameLabel;
}
-(UILabel *)birDeadLabel{
    if (!_birDeadLabel) {
        _birDeadLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(210, CGRectYH(self.nameLabel)/AdaptationWidth()+7, 306, 40)];
        _birDeadLabel.font = MFont(20*AdaptationWidth());
        _birDeadLabel.textAlignment = 1;
        //_birDeadLabel.text = @"（1931-02-08--1955-09-30）";
    }
    return _birDeadLabel;
}
-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(44, CGRectYH(self.birDeadLabel)/AdaptationWidth()+50, 624, 620)];
        
        _detailLabel.font = MFont(23*AdaptationWidth());
        _detailLabel.numberOfLines = 0;
        //_detailLabel.text = @"詹姆斯迪恩于1931年出生在印第安纳的一个小镇上，他的福气是一门压抑，母亲是一个农场主的女儿。4岁时全家前往加州。自幼受目前影响，热爱艺术和是个，母亲对他食欲明显的鼓励。迪恩8岁那年，母亲因癌症病故\n\n詹姆斯迪恩于1931年出生在印第安纳的一个小镇上，他的福气是一门压抑，母亲是一个农场主的女儿。4岁时全家前往加州。自幼受目前影响，热爱艺术和是个，母亲对他食欲明显的鼓励。迪恩8岁那年，母亲因癌症病故\n\n詹姆斯迪恩于1931年出生在印第安纳的一个小镇上，他的福气是一门压抑，母亲是一个农场主的女儿。4岁时全家前往加州。自幼受目前影响，热爱艺术和是个，母亲对他食欲明显的鼓励。迪恩8岁那年，母亲因癌症病故\n";
        //[_detailLabel sizeToFit];
    }
    return _detailLabel;
}
@end
