//
//  DrawStarsView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "DrawStarsView.h"

@implementation DrawStarsView
-(instancetype)initWithFrame:(CGRect)frame SetRedNumber:(int)redNumber SetRedImage:(UIImage *)redImage SetNormalImage:(UIImage *)normalImage{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //画星星
        CGFloat redIVWidth = (CGRectW(self)-4*3)/5;
        for (int i = 0; i < redNumber; i++) {
            UIImageView *RedIV = [[UIImageView alloc]initWithFrame:CGRectMake((redIVWidth+3)*i, 0, redIVWidth,CGRectH(self))];
            RedIV.contentMode = UIViewContentModeScaleAspectFit;
            RedIV.image = redImage;
            [self addSubview:RedIV];
        }
        for (int i = redNumber ; i < 5; i++) {
            UIImageView *normalIV = [[UIImageView alloc]initWithFrame:CGRectMake((redIVWidth+3)*redNumber+(redIVWidth+3)*(i-redNumber), 0, redIVWidth, CGRectH(self))];
            normalIV.image = normalImage;
            normalIV.contentMode = UIViewContentModeScaleAspectFit;
            [self addSubview:normalIV];
        }
    }
    return  self;
}
@end
