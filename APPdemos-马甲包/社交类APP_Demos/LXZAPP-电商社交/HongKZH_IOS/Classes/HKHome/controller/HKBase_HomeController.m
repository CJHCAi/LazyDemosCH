//
//  HKBase_HomeController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/9.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBase_HomeController.h"
#import "CBSegmentView.h"
#import "HK_segmentViews.h"
#import "HKRecomedController.h"
#import "HKAdverTiseController.h"
#import "HKCityController.h"
#import "HKMediaController.h"
#import "HKhisToryController.h"
#import "UIButton+LXMImagePosition.h"
//企业广告
#import "HKCorporateAdvertisingViewController.h"
//城市
#import "HKCityViewController.h"
//自媒体
#import "HKSelfMediaPageViewController.h"

#import "HKReleasesViewController.h"

#import "HKSelfMediaSearchsViewController.h"
//红包
#import "HKPublishCommonModuleViewController.h"
#import "UIView+Frame.h"
@interface HKBase_HomeController ()<segMentClickDelegete,UIScrollViewDelegate>
{
    NSInteger requestN;
}

@property (nonatomic, strong)HK_segmentViews *segView;
@property (nonatomic, strong)UIScrollView * rootScollView;
@property (nonatomic, strong)UIView *topView;
@property (nonatomic, strong)UIButton * publishBtn;
@property (nonatomic, strong)UIButton *searchBtn;
@property (nonatomic, strong)HKCorporateAdvertisingViewController *advVc;
@property (nonatomic, weak) UIImageView *lineView;
@property (nonatomic, strong)UIButton *historyBtn;
@end

@implementation HKBase_HomeController
-(void)viewWillAppear:(BOOL)animated {
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}
-(UIScrollView *)rootScollView {
    if (!_rootScollView) {
        _rootScollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.topView.frame),kScreenWidth,kScreenHeight-NavBarHeight-StatusBarHeight -SafeAreaBottomHeight)];
        _rootScollView.backgroundColor =[UIColor greenColor];
        _rootScollView.pagingEnabled = YES;
        _rootScollView.bounces = NO;
        [_rootScollView setContentSize:CGSizeMake(kScreenWidth*4,CGRectGetHeight(_rootScollView.frame))];
        _rootScollView.delegate = self;
    }
    return _rootScollView;
}
//发布..
-(void)publish {
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
//    HKPublishCommonModuleViewController *pb =[[HKPublishCommonModuleViewController alloc] init];
//    [self.navigationController pushViewController:pb animated:YES];
//
    HKReleasesViewController *vc = [[HKReleasesViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//观看历史
-(void)lookhistory {
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKhisToryController *vc = [[HKhisToryController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goHistory
{
    if (![LoginUserDataModel isHasSessionId]) {
        [AppUtils presentLoadControllerWithCurrentViewController:self];
        return;
    }
    HKhisToryController *vc = [[HKhisToryController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(UIView *)topView {
    if (!_topView) {
        _topView =[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.segView.frame),kScreenWidth,0)];
        _topView.backgroundColor  = [UIColor whiteColor];
//        self.publishBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//        self.publishBtn.frame =CGRectMake(kScreenWidth-10-30,8,0,0);
//        [self.publishBtn setImage:[UIImage imageNamed:@"lk_fbsp"] forState:UIControlStateNormal];
//        [_topView addSubview:self.publishBtn];
        [self.publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
        
        self.searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.searchBtn addTarget:self action:@selector(searchVideo) forControlEvents:UIControlEventTouchUpInside];
        
        self.searchBtn.frame = CGRectMake(7.5,8,kScreenWidth-20,0);
        self.searchBtn.backgroundColor= RGB(238,238,238);
        self.searchBtn.layer.cornerRadius = 15;
        self.searchBtn.layer.masksToBounds =YES;
        [self.searchBtn setImage:[UIImage imageNamed:@"searchicon"] forState:UIControlStateNormal];
        self.searchBtn.titleLabel.font  =PingFangSCRegular14;
        [self.searchBtn setTitleColor:RGB(153,153,153) forState:UIControlStateNormal];
        [self.searchBtn setTitle:@"搜索您感兴趣的视频" forState:UIControlStateNormal];
        [self.searchBtn setImagePosition:0 spacing:3];
        
//        [_topView addSubview:self.searchBtn];
    
    }
    return _topView;
    
}
-(HK_segmentViews *)segView {
    if (!_segView) {
        if (iPhone5) {
            _segView =[[HK_segmentViews alloc] initWithFrame:CGRectMake(kScreenWidth/2-230/2,StatusBarHeight,230,44)];
        }else {
            _segView =[[HK_segmentViews alloc] initWithFrame:CGRectMake(kScreenWidth/2-280/2,StatusBarHeight,280,44)];
        }
        _segView.delegete =self;
    }
    return _segView;
}
-(UIButton *)publishBtn{
    if (!_publishBtn) {
        _publishBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage*image = [UIImage imageNamed:@"shipin"];
        _publishBtn.frame =CGRectMake(kScreenWidth-15-image.size.width,CGRectGetMinY(self.segView.frame)+7,image.size.width,image.size.height);
        _publishBtn.centerY = self.segView.centerY;
        [_publishBtn setImage:image forState:UIControlStateNormal];
        [_publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}
-(UIButton *)historyBtn {
    if (!_historyBtn) {
        _historyBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _historyBtn.frame= CGRectMake(15,CGRectGetMinY(self.segView.frame)+7,30,30);
         [_historyBtn addTarget:self action:@selector(lookhistory) forControlEvents:UIControlEventTouchUpInside];
        [_historyBtn setImage:[UIImage imageNamed:@"look_time"] forState:UIControlStateNormal];
    }
    return _historyBtn;
}
-(void)initNav {
    if (iPhone5) {
        _segView =[[HK_segmentViews alloc] initWithFrame:CGRectMake(0,StatusBarHeight,230,44)];
    }else {
        _segView =[[HK_segmentViews alloc] initWithFrame:CGRectMake(0,StatusBarHeight,280,44)];
    }
    self.segView.delegete = self;
    self.navigationItem.titleView = self.segView;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame= CGRectMake(0,0,30,30);
    [btn addTarget:self action:@selector(lookhistory) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"look_time"] forState:UIControlStateNormal];
   // [btn setImage:[UIImage imageNamed:@"look_time"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:btn];
}
-(void)clickSegIndex:(NSInteger)index {
    //修改发布按钮 和搜索框布局..
    if (index==0 || index == 1 ||index ==2) {
        [UIView animateWithDuration:0.3 animations:^{
            self.searchBtn.frame = CGRectMake(self.searchBtn.frame.origin.x,self.searchBtn.frame.origin.y,kScreenWidth-20,self.searchBtn.frame.size.height);
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            
            self.searchBtn.frame = CGRectMake(self.searchBtn.origin.x,self.searchBtn.origin.y,kScreenWidth-60,self.searchBtn.frame.size.height);
        }];
    }
    self.rootScollView.contentOffset = CGPointMake(index *kScreenWidth,0);
//    if (index == 1) {
//        [self.advVc InitializationData];
//    }
}
//滑动结束..
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index  = self.rootScollView.contentOffset.x /kScreenWidth;
    [self.segView setSegCongigueWithIndex:index];
    
}
//视图将要消失时取消隐藏
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
        //设置不透明导航栏
        self.navigationController.navigationBar.translucent = NO;
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
        [self.navigationController.navigationBar setShadowImage:nil];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
//找到导航栏最下面黑线视图
- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    //获取导航栏下面黑线
//    _lineView = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
    //[self initNav];
    [self setSubViews];
    [self addNotification];
    
}
-(void)cancelNewUser {
    [super cancelNewUser];
}
-(void)addChildVc {
   //推荐..
    HKRecomedController *rec =[[HKRecomedController alloc] init];
    rec.view.frame = CGRectMake(0,0,kScreenWidth,CGRectGetHeight(self.rootScollView.frame));
    rec.view.backgroundColor =[UIColor redColor];
    [self addChildViewController:rec];
    
    [self.rootScollView addSubview:rec.view];
   //广告
    HKCorporateAdvertisingViewController *adVc =[[HKCorporateAdvertisingViewController alloc] init];
    adVc.view.frame = CGRectMake(kScreenWidth,0,kScreenWidth,CGRectGetHeight(self.rootScollView.frame));
    _advVc = adVc;
    adVc.view.backgroundColor = keyColor;
    [self addChildViewController:adVc];
    [self.rootScollView addSubview:adVc.view];
   //城市
    HKCityViewController * cityVc =[[HKCityViewController alloc] init];
    cityVc.view.frame = CGRectMake(2*kScreenWidth,0,kScreenWidth,CGRectGetHeight(self.rootScollView.frame));
    cityVc.view.backgroundColor =[UIColor cyanColor];
    [self addChildViewController:cityVc];
    [self.rootScollView addSubview:cityVc.view];
  //自媒体
    HKSelfMediaPageViewController *mediaVc =[[HKSelfMediaPageViewController alloc] init];
    mediaVc.view.frame = CGRectMake(3*kScreenWidth,0,kScreenWidth,CGRectGetHeight(self.rootScollView.frame));
    mediaVc.view.backgroundColor =[UIColor blueColor];
    [self addChildViewController:mediaVc];
    [self.rootScollView addSubview:mediaVc.view];
}
-(void)setSubViews {
    [self.view addSubview:self.segView];
    [self.view addSubview:self.historyBtn];
    [self.view addSubview:self.publishBtn];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.rootScollView];
    [self addChildVc];
}
-(void)searchVideo{
    HKSelfMediaSearchsViewController*vc = [[HKSelfMediaSearchsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
