//
//  BFNavView.m
//  自定义cell编辑状态
//
//  Created by bxkj on 2017/8/3.
//  Copyright © 2017年 周冰烽. All rights reserved.
//

#import "BFNavView.h"
#import "Masonry.h"
#import "UIColor+BFColor.h"
@implementation BFNavView

- (instancetype)initWithRight:(BOOL)isRight{
    if (self = [super init]) {
        self.backgroundColor = [UIColor BF_ColorWithHex:0xF9F9F9];
        //添加标题
        [self setNavTitle];
//        //添加左上角按钮
//        [self setNavLeftBtn];
        if (isRight) {
            [self setRightBtn];
        }
    }
    return self;
}
- (void)setNavTitle{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    titleLabel.textColor = [UIColor blackColor];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(28);
    }];
    self.titleLabel = titleLabel;
}
//- (void)setNavLeftBtn{
//    UIButton *btn = [[UIButton alloc]init];
//    [btn setImage:[UIImage imageNamed:@"Rectangle 13blackicon"] forState:UIControlStateNormal];
//    [self addSubview:btn];
//    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(25);
//        make.left.equalTo(self).offset(10);
//    }];
//    self.leftBtn = btn;
//}

- (void)setRightBtn{
    UIButton *btn = [[UIButton alloc]init];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-20);
    }];
    self.rightBtn = btn;
}


@end
