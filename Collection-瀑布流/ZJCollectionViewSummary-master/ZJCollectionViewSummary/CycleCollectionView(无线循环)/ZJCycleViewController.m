//
//  ZJCycleViewController.m
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/9.
//  Copyright © 2018年 James. All rights reserved.
//

/**
 项目地址：https://github.com/zhijiaxin/ZJCollectionViewSummary.git
 
 也可以到博客下看看相关介绍
 博客地址：https://www.jianshu.com/p/ff7089782d6c
 
 有什么错误或使用不便的地方可以留言或加我QQ
 
 QQ：1224740397
 */

#import "ZJCycleViewController.h"
#import "ZJCycleView.h"

@interface ZJCycleViewController ()<ZJCycleViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ZJCycleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"循环轮播";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.scrollView];
    
    NSMutableArray *arrayD = [NSMutableArray array];
    for (int i = 6; i < 20; i++) {
        NSString *imageStr = [NSString stringWithFormat:@"%d.jpg", i];
        NSString *titelStr = [NSString stringWithFormat:@"浏览到第%d个标题",i - 6];
        NSDictionary *dict = @{@"imageUrl":imageStr,@"title":titelStr};
        [arrayD addObject:dict];
    }
    UIImage *placeholderImage = [UIImage imageNamed:@"placeholder"];
    ZJCycleView *cyleView = [[ZJCycleView alloc] initWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 200) arrayDict:arrayD placeholderImage:placeholderImage];
    cyleView.delegate = self;
    [self.scrollView addSubview:cyleView];
    
    NSMutableArray *images = [NSMutableArray array];
    NSMutableArray *tites = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        NSString *imageStr = [NSString stringWithFormat:@"%d.jpg", i + 2];
        [images addObject:imageStr];
        
        NSString *titelStr = [NSString stringWithFormat:@"浏览到第%d个标题",i];
        [tites addObject:titelStr];
        
    }
    ZJCycleView *cyleView1 = [[ZJCycleView alloc] initWithFrame:CGRectMake(0, 280, SCREEN_WIDTH, 200) imageUrls:images placeholderImage:placeholderImage];
    [self.scrollView addSubview:cyleView1];

    ZJCycleView *cyleView2 = [[ZJCycleView alloc] initWithFrame:CGRectMake(0, 490, SCREEN_WIDTH, 200) imageUrls:images titles:tites placeholderImage:placeholderImage];
    cyleView2.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:cyleView2];
    
    NSArray *imageUrlS3 = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640909&di=f81a4b35665c0bb2f8d6b2c1fbd712dc&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Ffaedab64034f78f0bea90c0773310a55b2191ca7.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640913&di=5d4b3b455a73ba3df969d7f61d018372&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01d66a579c1d0e0000018c1b7dd7cf.jpg%401280w_1l_2o_100sh.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640915&di=46869e9b7c3dab45789eb8f842928ee9&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Faa18972bd40735fa55cd5e4c94510fb30f240801.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640915&di=0e6e3a367c7febc423f7bab33bd7ecd1&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F908fa0ec08fa513de3613b2a376d55fbb3fbd97f.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640915&di=a7010e48ee497c10d4ae1a7fa5d46f32&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D4852c481093b5bb5aada28bd5ebabf4c%2Fc8ea15ce36d3d539d666cae93087e950352ab045.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640914&di=61c0944a325c24ebe57b03cbc53d8982&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F0b7b02087bf40ad1e03c6a165d2c11dfa8ecce6f.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640914&di=a85ac3057c300685f0f258b313c39438&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01a47b557153910000009fcb7250bc.jpg%402o.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640913&di=5d4b3b455a73ba3df969d7f61d018372&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01d66a579c1d0e0000018c1b7dd7cf.jpg%401280w_1l_2o_100sh.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640913&di=a7ba3a11ecf9d07ead50f02e0693c72f&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Fcaef76094b36acafe1da3e0876d98d1001e99c08.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640913&di=da41c922693934e2fa2ccefc7c588054&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F060828381f30e92400c7f0c546086e061c95f7e7.jpg"];
        NSArray *imageUrlS4 = @[@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640916&di=762598ef418741893907a64fd047ea75&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Fb219ebc4b74543a9ed384a3814178a82b9011426.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640915&di=46869e9b7c3dab45789eb8f842928ee9&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Faa18972bd40735fa55cd5e4c94510fb30f240801.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640915&di=0e6e3a367c7febc423f7bab33bd7ecd1&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F908fa0ec08fa513de3613b2a376d55fbb3fbd97f.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640915&di=a7010e48ee497c10d4ae1a7fa5d46f32&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimage%2Fc0%253Dshijue1%252C0%252C0%252C294%252C40%2Fsign%3D4852c481093b5bb5aada28bd5ebabf4c%2Fc8ea15ce36d3d539d666cae93087e950352ab045.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640914&di=61c0944a325c24ebe57b03cbc53d8982&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F0b7b02087bf40ad1e03c6a165d2c11dfa8ecce6f.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640914&di=a85ac3057c300685f0f258b313c39438&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01a47b557153910000009fcb7250bc.jpg%402o.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640913&di=5d4b3b455a73ba3df969d7f61d018372&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01d66a579c1d0e0000018c1b7dd7cf.jpg%401280w_1l_2o_100sh.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640913&di=a7ba3a11ecf9d07ead50f02e0693c72f&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2Fcaef76094b36acafe1da3e0876d98d1001e99c08.jpg",@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1528897640913&di=da41c922693934e2fa2ccefc7c588054&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fimgad%2Fpic%2Fitem%2F060828381f30e92400c7f0c546086e061c95f7e7.jpg"];
    
    ZJCycleView *cyleView3 = [ZJCycleView cycleViewWithFrame:CGRectMake(0, 700, SCREEN_WIDTH, 200) imageUrls:imageUrlS3 placeholderImage:placeholderImage];
    cyleView3.pageContolStyle = ZJCyclePageContolStyleRectangle;
    [self.scrollView addSubview:cyleView3];
    NSArray *cyleView4Titles = @[@"岁月的美在于流逝，花开花落间",@"光阴沉淀了年少轻狂，也懂得了冷暖自知",@"人生，没有人能陪你到最后",@"一路风雨前行的只有自己",@"每一天走在熟悉的路上",@"既便偶尔会有忧伤",@"也能生出淡淡的幸福",@"做一朵小花，静静的开在时光中",@"即便不美丽，也要有修养",@"生命心态丽，也要有内涵"];
    ZJCycleView *cyleView4 = [ZJCycleView cycleViewWithFrame:CGRectMake(0, 910, SCREEN_WIDTH, 200) imageUrls:imageUrlS4 titles:cyleView4Titles placeholderImage:placeholderImage];
    [self.scrollView addSubview:cyleView4];
    
    ZJCycleView *cyleView5 = [[ZJCycleView alloc] initWithFrame:CGRectMake(0, 1120, SCREEN_WIDTH, 200)];
    cyleView5.backgroundColor = [UIColor blueColor];
    cyleView5.cycleViewType = CycleViewImage;
    cyleView5.pageContolStyle = ZJCyclePageContolStyleImage;
    cyleView5.images = imageUrlS3;
    [self.scrollView addSubview:cyleView5];
    
    ZJCycleView *cyleView6 = [[ZJCycleView alloc] initWithFrame:CGRectMake(0, 1330, SCREEN_WIDTH, 200)];
    cyleView6.backgroundColor = [UIColor blueColor];
    cyleView6.cycleViewType = CycleViewSeparateTitleAndImage;
    cyleView6.pageContolStyle = ZJCyclePageContolStyleNone;
    cyleView6.titles = cyleView4Titles;
    cyleView6.images = imageUrlS4;
    [self.scrollView addSubview:cyleView6];
    
}

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT * 2.2);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

@end
