//
//  StarView.m
//  ListV
//
//  Created by imac on 16/7/29.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "StarView.h"

@interface StarView()

@property (strong,nonatomic) NSMutableArray *starArr;
@end

@implementation StarView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView{
    CGFloat w =self.frame.size.width;
    _starArr = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        UIImageView *starIV = [[UIImageView alloc]initWithFrame:CGRectMake(i*w/5, 0, w/5, w/5)];
        [self addSubview:starIV];
        starIV.tag = i+1;
        starIV.image = [UIImage imageNamed:@"redLineStar"];
        starIV.backgroundColor = [UIColor clearColor];
        [_starArr addObject:starIV];
    }
}

-(void)setStar:(NSInteger)sender{
    for (UIImageView *star in _starArr) {
        if (star.tag<=sender) {
            star.image = [UIImage imageNamed:@"redStar"];
        }else{
            star.image = [UIImage imageNamed:@"redLineStar"];
        }
    }
}


@end
