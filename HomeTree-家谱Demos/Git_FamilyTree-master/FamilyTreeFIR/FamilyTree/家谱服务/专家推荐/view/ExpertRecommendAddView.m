//
//  ExpertRecommendAddView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/8/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ExpertRecommendAddView.h"

@implementation ExpertRecommendAddView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i = 0; i < 5; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((Screen_width-30)/5*i, 0, (Screen_width-30)/5, 35)];
            [button setTitle:@"请输入" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.titleLabel.font = MFont(11);
            button.layer.borderColor = LH_RGBCOLOR(215, 216, 217).CGColor;
            button.layer.borderWidth = 0.5;
            if (i == 1) {
                [button setImage:MImage(@"wdhz_jiantou") forState:UIControlStateNormal];
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
                button.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            }
            if (i == 2) {
                button.titleLabel.font = MFont(9);
            }
            
            [button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = 111+i;
            [self addSubview:button];
        }
    }
    return self;
}

-(void)clickBtn:(UIButton *)sender{
    [self.delegate expertRecommendAddView:self clickBtn:sender];
}

@end
