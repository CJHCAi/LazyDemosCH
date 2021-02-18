//
//  ExpertRecommendTableViewCell.m
//  FamilyTree
//
//  Created by 姚珉 on 16/8/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ExpertRecommendTableViewCell.h"

@interface ExpertRecommendTableViewCell ()
/** 姓名*/
@property (nonatomic, strong) UILabel *nameLB;
/** 称谓*/
@property (nonatomic, strong) UILabel *relationLB;
/** 日期*/
@property (nonatomic, strong) UILabel *timeLB;
/** 疾病或事件*/
@property (nonatomic, strong) UILabel *sickLB;
/** 详细说明按钮*/
@property (nonatomic, strong) UIButton *infoBtn;
/** 详细说明*/
@property (nonatomic, strong) NSString *infoStr;
@end

@implementation ExpertRecommendTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = LH_RGBCOLOR(215, 216, 217).CGColor;
    [self addSubview:self.nameLB];
    [self addSubview:self.relationLB];
    [self addSubview:self.timeLB];
    [self addSubview:self.sickLB];
    [self addSubview:self.infoBtn];
}

-(void)setExModel:(ExpertRecommendModel *)exModel{
    _exModel = exModel;
    self.nameLB.text = exModel.ExName;
    self.relationLB.text = exModel.ExCw;
    self.timeLB.text = [NSString stringWithFormat:@"%@/%@/%@",[exModel.ExDoctortime substringWithRange:NSMakeRange(0, 4)],[exModel.ExDoctortime substringWithRange:NSMakeRange(5,2)],[exModel.ExDoctortime substringWithRange:NSMakeRange(8, 2)]];
    self.sickLB.text = exModel.ExDisease;
    self.infoStr = exModel.ExMemo;
}

-(void)clickToLookInfo{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"说明" message:self.infoStr preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sureAction];
    [[self viewController] presentViewController:alert animated:YES completion:nil];

}

#pragma mark - lazyLoad
-(UILabel *)nameLB{
    if (!_nameLB) {
        _nameLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (Screen_width-30)/5, 35)];
        _nameLB.layer.borderWidth = 0.5;
        _nameLB.layer.borderColor = LH_RGBCOLOR(215, 216, 217).CGColor;
        _nameLB.font = MFont(11);
        _nameLB.textAlignment = NSTextAlignmentCenter;
        _nameLB.text = @"姚珉";
    }
    return _nameLB;
}

-(UILabel *)relationLB{
    if (!_relationLB) {
        _relationLB = [[UILabel alloc]initWithFrame:CGRectMake((Screen_width-30)/5, 0, (Screen_width-30)/5, 35)];
        _relationLB.layer.borderWidth = 0.5;
        _relationLB.layer.borderColor = LH_RGBCOLOR(215, 216, 217).CGColor;
        _relationLB.font = MFont(11);
        _relationLB.textAlignment = NSTextAlignmentCenter;
        _relationLB.text = @"父亲";
    }
    return _relationLB;
}

-(UILabel *)timeLB{
    if (!_timeLB) {
        _timeLB = [[UILabel alloc]initWithFrame:CGRectMake((Screen_width-30)/5*2, 0, (Screen_width-30)/5, 35)];
        _timeLB.layer.borderWidth = 0.5;
        _timeLB.layer.borderColor = LH_RGBCOLOR(215, 216, 217).CGColor;
        _timeLB.font = MFont(9);
        _timeLB.textAlignment = NSTextAlignmentCenter;
        _timeLB.text = @"2001/07/01";
    }
    return _timeLB;
}

-(UILabel *)sickLB{
    if (!_sickLB) {
        _sickLB = [[UILabel alloc]initWithFrame:CGRectMake((Screen_width-30)/5*3, 0, (Screen_width-30)/5, 35)];
        _sickLB.layer.borderWidth = 0.5;
        _sickLB.layer.borderColor = LH_RGBCOLOR(215, 216, 217).CGColor;
        _sickLB.font = MFont(11);
        _sickLB.textAlignment = NSTextAlignmentCenter;
        _sickLB.text = @"感冒";
    }
    return _sickLB;
}

-(UIButton *)infoBtn{
    if (!_infoBtn) {
        _infoBtn = [[UIButton alloc]initWithFrame:CGRectMake((Screen_width-30)/5*4, 0, (Screen_width-30)/5, 35)];
        _infoBtn.layer.borderWidth = 0.5;
        _infoBtn.layer.borderColor = LH_RGBCOLOR(215, 216, 217).CGColor;
        _infoBtn.titleLabel.font = MFont(11);
        [_infoBtn setTitle:@"点击看详情" forState:UIControlStateNormal];
        [_infoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_infoBtn addTarget:self action:@selector(clickToLookInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _infoBtn;
}



@end
