//
//  HKLeSeeManagerViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLeSeeManagerViewController.h"
#import "HKLeSeeViewModel.h"
#import "HKUserCategoryListRespone.h"
#import "HKCategoryBarView.h"
#import "HKLeSeeRecommendViewController.h"
#import "HKCorporateAdvertisingViewController.h"
#import "HKRecruitPageViewController.h"
#import "HKCityViewController.h"
#import "HKSelfMediaPageViewController.h"
#import "HKLeSeeNavigation.h"
#import "HK_GladlyLookChannelView.h"
#import "HKReleasesViewController.h"
#import "HKhisToryController.h"
//#import "HJTabViewControllerPlugin_HeaderScroll.h"
@interface HKLeSeeManagerViewController ()<HKLeSeeNavigationDelegate,HJTabViewControllerDataSource,HJTabViewControllerDelagate>
@property (nonatomic, strong)HKUserCategoryListRespone *respone;
@property (nonatomic, strong)HKLeSeeNavigation *leSeeNav;

@property (nonatomic, strong)NSMutableArray *leSeeVcArray;

@property (nonatomic, strong)HKLeSeeNavigation *leSeeNavigation;
@property (nonatomic, strong)NSMutableArray *array_VC;

@end

@implementation HKLeSeeManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabDataSource = self;
    self.tabDelegate = self;
    self.isNOTScrollEnabled = YES;
//     [self enablePlugin:[HJTabViewControllerPlugin_HeaderScroll new]];
    [self setUI];
    
    UISwipeGestureRecognizer* swipeGestureRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeRightFrom:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    UISwipeGestureRecognizer* left=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFromLeft:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:left];
    [self loadData];
//    [self setLeftANdRight];[self scrollToIndex:self.curIndex+1 animated:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData) name:kNotificationNavLoadData object:nil];
}
-(void)handleSwipeFromLeft:(id)sender{
    if (self.curIndex>0) {
       
        self.leSeeNav.index  = self.curIndex-1;
    }
    
}
-(void)handleSwipeRightFrom:(id)sender{
    if (self.curIndex<self.array_VC.count-1) {
         self.leSeeNav.index  = self.curIndex+1;
       
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)setUI{
    [self.view addSubview:self.leSeeNav];
    
}
-(void)gotoVcRelease{
    HKReleasesViewController*vc = [[HKReleasesViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)gotoWatchingHistory{
    HKhisToryController*vc = [[HKhisToryController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)loadData{
    [HKLeSeeViewModel getUserCategoryList:@{@"loginUid":HKUSERLOGINID,@"isFirst":@"2"} success:^(HKUserCategoryListRespone *responde) {
        if (responde.responeSuc) {
            self.respone = responde;
             [NSKeyedArchiver archiveRootObject:responde toFile:KHKUserCategoryListRespone];
            [self setVcArray];
        }else{
            self.respone = [NSKeyedUnarchiver unarchiveObjectWithFile:KHKUserCategoryListRespone];
            [self setVcArray];
        }
        
    }];
}
-(void)setVcArray{
    NSMutableArray*array = [NSMutableArray array];
    [array addObject:@"推荐"];
    [array addObject:@"广告"];
    NSMutableArray *vcArray = [NSMutableArray array];
    [self addMainVcWithArray:vcArray];
    for (HKUserCategoryListModel*cateM in self.respone.data) {
         [array addObject:cateM.name];
        if (cateM.type.intValue == 1) {
            if ([cateM.name isEqualToString:@"招聘"]) {
                HKRecruitPageViewController*vc3 = [[HKRecruitPageViewController alloc]init];
                vc3.categoryId = cateM.categoryId;
                [vcArray addObject:vc3];
            }else{
                HKSelfMediaPageViewController*vc5 = [[HKSelfMediaPageViewController alloc]init];
                vc5.categoryId = cateM.categoryId;
                [vcArray addObject:vc5];
            }
        }else{
            HKCityViewController*vc4 = [[HKCityViewController alloc]init];
            [vcArray addObject:vc4];
        }
    }
    
    self.array_VC = vcArray;
    
    self.leSeeNav.category = array;
//    [self btnClicks:0];
}
-(void)selectedWithIndex:(int)index{
    [self scrollToIndex:index animated:YES];
}
-(void)gotoNavigation{
    HK_GladlyLookChannelView*vc = [[HK_GladlyLookChannelView alloc]init];
    vc.selectArray = self.respone.data;
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSMutableArray *)leSeeVcArray{
    if (!_leSeeVcArray) {
        _leSeeVcArray = [NSMutableArray array];
        [self addMainVcWithArray:_leSeeVcArray];
    }
    return _leSeeVcArray;
}
-(void)addMainVcWithArray:(NSMutableArray*)array{
    HKLeSeeRecommendViewController*vc = [[HKLeSeeRecommendViewController alloc]init];
    [array addObject:vc];
    HKCorporateAdvertisingViewController*vc2 = [[HKCorporateAdvertisingViewController alloc]init];
    [array addObject:vc2];
}
-(HKLeSeeNavigation *)leSeeNav{
    if (!_leSeeNav) {
        _leSeeNav = [[HKLeSeeNavigation alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 80)];
        _leSeeNav.category = [NSMutableArray arrayWithArray: @[@"推荐",@"广告"]];
        _leSeeNav.delegate = self;
    }
    return _leSeeNav;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)tabViewController:(HJTabViewController *)tabViewController scrollViewDidScrollToIndex:(NSInteger)index{
    
}
- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return self.array_VC.count;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    return self.array_VC[index];
}
- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
    return UIEdgeInsetsMake(80, 0, 0, 0);
}
@synthesize array_VC = _array_VC;
-(void)setArray_VC:(NSMutableArray *)array_VC{
    _array_VC = array_VC;;
    [self reloadData];
}
-(NSMutableArray *)array_VC{
    if (!_array_VC) {
        _array_VC = [NSMutableArray array];
    }
    return _array_VC;
}
@end
