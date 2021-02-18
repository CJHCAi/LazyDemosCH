//
//  StarGetView.m
//  ListV
//
//  Created by imac on 16/7/29.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "StarGetView.h"

@interface StarGetView()

@property (strong,nonatomic) NSMutableArray *starArr;
@end

@implementation StarGetView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    _starArr = [NSMutableArray array];
    UIImageView *lineV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, __kWidth, 1)];
    [self addSubview:lineV];
    lineV.backgroundColor = LH_RGBCOLOR(230, 230, 230);

    UILabel *titleLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 60, 15)];
    [self addSubview:titleLb];
    titleLb.font = MFont(14);
    titleLb.textAlignment = NSTextAlignmentLeft;
    titleLb.textColor = LH_RGBCOLOR(30, 30, 30);
    titleLb.text = @"综合评分";

    for (int i=0; i<5; i++) {
        UIButton *starBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectXW(titleLb)+i*(__kWidth/10), 15, __kWidth/50*4, 25)];
        [self addSubview:starBtn];
        starBtn.tag = i+1;
        starBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [starBtn setImage:[UIImage imageNamed:@"redLineStar"] forState:BtnNormal];
        [starBtn addTarget:self  action:@selector(evaluate:) forControlEvents:BtnTouchUpInside];
        [_starArr addObject:starBtn];
    }
}

- (void)evaluate:(UIButton *)sender{
    for (UIButton *btn in _starArr) {
        if (btn.tag<=sender.tag) {
            [btn setImage:[UIImage imageNamed:@"redStar"] forState:BtnNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"redLineStar"] forState:BtnNormal];
        }
    }
    _star = [NSString stringWithFormat:@"%ld",(long)sender.tag];
}


@end
