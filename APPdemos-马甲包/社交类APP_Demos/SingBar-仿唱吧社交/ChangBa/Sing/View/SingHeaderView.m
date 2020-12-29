//
//  SingHeaderView.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "SingHeaderView.h"
#import "Utils.h"
#import "RecommendBannersModel.h"

@implementation SingHeaderView

+(SingHeaderView *)instanceSingHeaderView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SingHeaderView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSMutableArray *images = [NSMutableArray array];
        [Utils requestRecommendBannersWithCallback:^(id obj) {
            for (RecommendBannersModel *recommendBanner in obj) {
                [images addObject:recommendBanner.headPhoto];
            }
            //轮播图
            self.singLoopView = [[LoopView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 150)];
            self.singLoopView.images = images;
            [self addSubview:self.singLoopView];
        }];
        
    }
    return self;
}
@end
