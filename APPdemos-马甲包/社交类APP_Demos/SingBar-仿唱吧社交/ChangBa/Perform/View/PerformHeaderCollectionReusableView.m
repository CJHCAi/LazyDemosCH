//
//  PerformHeaderViewController.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/17.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "PerformHeaderCollectionReusableView.h"
#import "LoopView.h"
#import "PerformHeaderView.h"
#import "PerformBaseClass.h"

@interface PerformHeaderCollectionReusableView ()

@end

@implementation PerformHeaderCollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableArray *images = [NSMutableArray array];
        [Utils requestPerformsWithCallback:^(id obj) {
            PerformBaseClass *perform = obj;
            for (PerformResult *PerformResult in perform.result) {
                [images addObject:PerformResult.bannerurl];
            }
            if (images.count > 0) {
                //轮播图
                LoopView *loopView = [[LoopView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
                loopView.images = images;
                [self addSubview:loopView];
            }else{
                //轮播图
                LoopView *loopView = [[LoopView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
                loopView.images = @[[UIImage imageNamed:@"lunbotu"]];
                [self addSubview:loopView];
            }
        }];

        
        //导航栏
        PerformHeaderView *headerView = [PerformHeaderView instancePerformHeaderView];
        headerView.frame = CGRectMake(0, 60, kScreenW, 160);
        [self addSubview:headerView];
    }
    return self;
}



@end
