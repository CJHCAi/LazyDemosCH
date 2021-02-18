//
//  PublicWorshipView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "PublicWorshipView.h"

@implementation PublicWorshipView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initImageView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)initImageView{
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, (CGRectH(self)-5)/4*i+5, Screen_width, (CGRectH(self)-25)/4)];
        imageView.image = MImage(@"ggJiDian_tuc");
        [self addSubview:imageView];
    }
}

@end
