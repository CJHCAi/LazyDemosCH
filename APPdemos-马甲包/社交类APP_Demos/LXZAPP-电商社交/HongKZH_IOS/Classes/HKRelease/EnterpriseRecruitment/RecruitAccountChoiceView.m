//
//  RecruitAccountChoiceView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "RecruitAccountChoiceView.h"

@interface RecruitAccountChoiceView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *textLabel;

@end

@implementation RecruitAccountChoiceView

- (instancetype)init {
    return [self initWithImage:nil text:nil color:nil];
}

- (instancetype)initWithImage:(UIImage *)image text:(NSString *)text color:(UIColor *)color{
    if (self = [super init]) {
        //背景色
        self.backgroundColor = [UIColor whiteColor];
        //icon
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];
        self.imageView = imageView;
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(25);
            make.centerY.mas_equalTo(self);
        }];
        //线
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor lightGrayColor];
        line.alpha = 0.8f;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageView.mas_right).offset(19);
            make.top.mas_equalTo(self.imageView);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(self.imageView);
        }];
        //text
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.font = [UIFont fontWithName:PingFangSCRegular size:17];
        textLabel.textColor = UICOLOR_RGB_Alpha(0x333333, 1.f);
        textLabel.text = text;
        [self addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(19);
            make.centerY.equalTo(self.imageView);
        }];
        //箭头
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-gray"]];
        [self addSubview:arrowImage];
        [arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-25);
            make.centerY.equalTo(self.imageView);
        }];
        
        //描边
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = color;
        [self addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.width.equalTo(self);
            make.top.equalTo(self.mas_bottom).offset(-10);
            make.height.mas_equalTo(10);
        }];
    }
    return self;
}

+ (instancetype)viewWithImage:(UIImage *)image text:(NSString *)text color:(UIColor *)color {
    return [[self alloc] initWithImage:image text:text color:color];
}

@end
