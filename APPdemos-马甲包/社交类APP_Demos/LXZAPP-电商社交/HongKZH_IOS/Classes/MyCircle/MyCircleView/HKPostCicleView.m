//
//  HKPostCicleView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/25.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPostCicleView.h"

@interface HKPostCicleView ()

@property (nonatomic, weak)UIImageView *cicleHeadView;

@property (nonatomic, weak)UILabel *cicleNameLabel;

@property (nonatomic, weak)UILabel *cicleDetailLabel;

@property (nonatomic, weak)UIButton *rowBtn;

@end

@implementation HKPostCicleView
-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.userInteractionEnabled =YES;
        self.backgroundColor =[UIColor colorFromHexString:@"f1f1f1"];
    }
    return  self;
}
-(UIImageView *)cicleHeadView {
    if (!_cicleHeadView) {
        UIImageView *cicleHeadView =[[UIImageView alloc] init];
        cicleHeadView.image =[UIImage imageNamed:@"Man"];
        [self addSubview:cicleHeadView];
        _cicleHeadView = cicleHeadView;
    }
    return _cicleHeadView;
}
-(UILabel *)cicleNameLabel {
    if (!_cicleNameLabel) {
        UILabel *cicleNameLabel =[[UILabel alloc] init];
        [AppUtils getConfigueLabel:cicleNameLabel font:PingFangSCRegular16 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"333333"] text:@""];
        [self addSubview:cicleNameLabel];
        _cicleNameLabel = cicleNameLabel;
    }
    return _cicleNameLabel;
}
-(UILabel *)cicleDetailLabel {
    if (!_cicleDetailLabel) {
        UILabel *cicleDetal=[[UILabel alloc] init];
        [AppUtils getConfigueLabel:cicleDetal font:PingFangSCRegular13 aliment:NSTextAlignmentLeft textcolor:[UIColor colorFromHexString:@"999999"] text:@""];
        [self addSubview:cicleDetal];
        _cicleDetailLabel = cicleDetal;
    }
    return _cicleDetailLabel;
}

-(UIButton *)rowBtn {
    if (!_rowBtn) {
        UIButton *row =[UIButton buttonWithType:UIButtonTypeCustom];
        row.frame = CGRectZero;
        [row setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [row addTarget:self action:@selector(gotoCicle:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:row];
        _rowBtn = row;
    }
    return _rowBtn;
}
-(void)gotoCicle:(UIButton *)sender {
    
    if (self.delegete && [self.delegete respondsToSelector:@selector(pushCilce)]) {
        [self.delegete pushCilce];
    }
}
-(void)layoutSubviews {
    [self.cicleHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(11);
        make.width.height.mas_equalTo(48);
    }];
    self.cicleHeadView.layer.masksToBounds =YES;
    self.cicleHeadView.layer.cornerRadius =24;

    [self.cicleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cicleHeadView.mas_right).offset(10);
        make.top.equalTo(self.cicleHeadView).offset(4);
        make.height.mas_equalTo(20);
        
    }];
    [self.cicleDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cicleNameLabel);
        make.bottom.equalTo(self.cicleHeadView).offset(-4);
        make.height.equalTo(self.cicleNameLabel);
    }];
    
    [self.rowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-16);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(12);
        make.centerY.equalTo(self.cicleHeadView);
    }];
}
-(void)setResponse:(HKPostDetailResponse *)response {
    _response = response;
    [AppUtils seImageView:self.cicleHeadView withUrlSting:response.data.coverImgSrc placeholderImage:kPlaceholderHeadImage];
    self.cicleNameLabel.text = response.data.name;
    self.cicleDetailLabel.text =[NSString stringWithFormat:@"%@ %@",response.data.categoryName,response.data.userCount];
}
@end
