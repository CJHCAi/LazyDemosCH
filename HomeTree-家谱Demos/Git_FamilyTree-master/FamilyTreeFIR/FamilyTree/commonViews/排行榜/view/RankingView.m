
//
//  RankingView.m
//  ListV
//
//  Created by imac on 16/7/20.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "RankingView.h"

@implementation RankingView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.bounds];
        backImage.image = MImage(@"ph_bg");
        
        [self addSubview:backImage];
        [self initView];
    }
    return self;
}

-(void)initView{
    CGFloat w = self.frame.size.width;
    _secondIV = [[UIImageView alloc]initWithFrame:CGRectMake((w-230)/4, 65, 70, 70)];
    [self addSubview:_secondIV];
    _secondIV.backgroundColor = [UIColor blackColor];

    UIImageView *secondIV = [[UIImageView alloc]initWithFrame:CGRectMake((w-230)/4+20, 124, 30, 35)];
    [self addSubview:secondIV];
    secondIV.image = MImage(@"silver");
    secondIV.contentMode = UIViewContentModeScaleAspectFit;

    _secondNameLb = [[UILabel alloc]initWithFrame:CGRectMake((w-230)/4, CGRectYH(_secondIV)+30, 70, 20)];
    [self addSubview:_secondNameLb];
    _secondNameLb.font = MFont(14);
    _secondNameLb.textAlignment = NSTextAlignmentCenter;

    _secondScoreLb = [[UILabel alloc]initWithFrame:CGRectMake((w-230)/4, CGRectYH(_secondNameLb)+5, 70, 20)];
    [self addSubview:_secondScoreLb];
    _secondScoreLb.font = MFont(15);
    _secondScoreLb.textAlignment = NSTextAlignmentCenter;

    _topIV = [[UIImageView alloc]initWithFrame:CGRectMake(w/2-45, 45, 90, 90)];
    [self addSubview:_topIV];
    _topIV.backgroundColor = LH_RGBCOLOR(220, 220, 150);

    UIImageView *firstIV = [[UIImageView alloc]initWithFrame:CGRectMake(w/2-16, 119, 34, 43)];
    [self addSubview:firstIV];
    firstIV.image = MImage(@"gold");
    firstIV.contentMode = UIViewContentModeScaleAspectFit;

    _topNameLb = [[UILabel alloc]initWithFrame:CGRectMake(w/2-45, CGRectYH(_topIV)+30, 90, 20)];
    [self addSubview:_topNameLb];
    _topNameLb.font = MFont(14);
    _topNameLb.textAlignment = NSTextAlignmentCenter;

    _topScoreLb = [[UILabel alloc]initWithFrame:CGRectMake(w/2-45, CGRectYH(_topNameLb)+5, 90, 20)];
    [self addSubview:_topScoreLb];
    _topScoreLb.font = MFont(15);
    _topScoreLb.textAlignment = NSTextAlignmentCenter;

    _thirdIV = [[UIImageView alloc]initWithFrame:CGRectMake(w-70-(w-230)/4, 65, 70, 70)];
    [self addSubview:_thirdIV];
    _thirdIV.backgroundColor =[UIColor lightGrayColor];

    UIImageView *thirdIV = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectXW(_thirdIV)-50, 124, 30, 35)];
    [self addSubview:thirdIV];
    thirdIV.image = MImage(@"copper");
    thirdIV.contentMode = UIViewContentModeScaleAspectFit;

    _thirdNameLb = [[UILabel alloc]initWithFrame:CGRectMake(w-70-(w-230)/4, CGRectYH(_thirdIV)+30, 70, 20)];
    [self addSubview:_thirdNameLb];
    _thirdNameLb.font = MFont(14);
    _thirdNameLb.textAlignment = NSTextAlignmentCenter;

    _thirdScoreLb = [[UILabel alloc]initWithFrame:CGRectMake(w-70-(w-230)/4, CGRectYH(_thirdNameLb)+5, 70, 20)];
    [self addSubview:_thirdScoreLb];
    _thirdScoreLb.font = MFont(15);
    _thirdScoreLb.textAlignment = NSTextAlignmentCenter;
    
}

@end
