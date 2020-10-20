//
//  ZSZPView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/11.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ZSZPView.h"

@implementation ZSZPView
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Text:(NSString *)text{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = LH_RGBCOLOR(184, 198, 197).CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 4.0f;
        self.backgroundColor = LH_RGBCOLOR(240, 253, 255);
        UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140*AdaptationWidth(), 50*AdaptationWidth())];
        titleLB.text = title;
        titleLB.font = WFont(25);
        [self addSubview:titleLB];
        self.textLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(titleLB), 5, 440*AdaptationWidth(), self.frame.size.height*AdaptationWidth())];
        self.textLB.text = text;
        self.textLB.font = WFont(25);
        self.textLB.numberOfLines = 0;
        self.textLB.textAlignment = NSTextAlignmentCenter;
        [self.textLB sizeToFit];
        [self addSubview:self.textLB];
    }
    return self;
}
@end
