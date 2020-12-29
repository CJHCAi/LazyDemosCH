//
//  HK_NewTitleView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/10.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_NewTitleView.h"

@interface HK_NewTitleView ()
@property (nonatomic, strong)UILabel * textLabel;
@property (nonatomic, strong)UILabel * timeLabel;
@property (nonatomic, strong)UIImageView *backIM;

@end

@implementation HK_NewTitleView

-(instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        self.backgroundColor =[UIColor clearColor];
        [self addSubview:self.backIM];
        [self addSubview:self.textLabel];
        [self addSubview:self.timeLabel];
    }
    return  self;
}

-(UIImageView *)backIM {
    if (!_backIM) {
        _backIM =[[UIImageView alloc] initWithFrame:self.bounds];
       // _backIM.image =[UIImage imageNamed:@"bkms_qgz"];
    }
    return _backIM;
}

-(UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,5,self.frame.size.width,20)];
        [AppUtils getConfigueLabel:_textLabel font:[UIFont boldSystemFontOfSize:14] aliment:NSTextAlignmentCenter textcolor:[UIColor whiteColor] text:@"抢购中"];
    }
    return _textLabel;
}
-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.textLabel.frame)+2,CGRectGetWidth(self.textLabel.frame),10)
                     ];
        [AppUtils getConfigueLabel:_timeLabel font:[UIFont boldSystemFontOfSize:12] aliment:NSTextAlignmentCenter textcolor:[UIColor whiteColor] text:@"12:00-14:00"];
    }
    return _timeLabel;
    
}
-(void)setModel:(HKNewPerSonType *)model {
     _model = model;
    self.timeLabel.text =[NSString stringWithFormat:@"%zd:00-%zd:00",model.beginDate,model.endDate];
    //抢购中
    if (model.sortDate>=0) {
        self.backIM.image =[UIImage imageNamed:@"xrzx_qgz"];
        self.textLabel.textColor =[UIColor whiteColor];
        self.timeLabel.textColor =[UIColor whiteColor];
        self.textLabel.text =@"抢购中";
    }else {
        //即将开始
        self.backIM.image =[UIImage  imageNamed:@"xrzx_jjks"
                            ];
        self.textLabel.textColor =[UIColor colorFromHexString:@"333333"];
        self.timeLabel.textColor =[UIColor colorFromHexString:@"999999"];
        self.textLabel.text =@"即将开始";
    }
}
-(void)setDuringShopNomalUI {
    self.backIM.image =[UIImage imageNamed:@"xrzx_qgz_01"];
}
-(void)setDuringShopSelectUI {
    self.backIM.image =[UIImage imageNamed:@"xrzx_qgz"];
}
-(void)setAfterLaterNomalUI {
    self.backIM.image =[UIImage  imageNamed:@"xrzx_jjks"
                        ];
    self.textLabel.textColor =[UIColor colorFromHexString:@"333333"];
}
-(void)setAfterLaterSelectUI {
    self.backIM.image =[UIImage  imageNamed:@"xrzx_jjks_01"
                                ];
    self.textLabel.textColor =keyColor;
}
@end
