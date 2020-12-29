//
//  HKDetailsPageViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDetailsPageViewController.h"
#import "CommodityDetailsViewController.h"
#import "HKDetailsNavView.h"
#import "CommodityDetailsViewModel.h"
#import "CommodityDetailsRespone.h"
#import "HKDetailDescViewController.h"
#import "HKLeShopingInfoNavView.h"
#import "HKBaseCartListViewController.h"
@interface HKDetailsPageViewController ()<CommodityDetailsViewControllerDelegate,HJTabViewControllerDataSource,HKDetailsNavViewDelagate,HKLeShopingInfoNavViewDelegate>
@property (nonatomic, strong)HKDetailsNavView *navView1;
@property (nonatomic, strong)HKLeShopingInfoNavView *navView2;
@property (nonatomic, strong)CommodityDetailsRespone *responde;
@property (nonatomic, strong)CommodityDetailsViewController *vc1;
@property (nonatomic, strong)HKDetailDescViewController *vc2;
@property (nonatomic, strong)NSMutableArray *questionArray;
@end

@implementation HKDetailsPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabDataSource = self;
    [self setUI];
    [self loadData];
    self.isNOTScrollEnabled = NO;
}
-(void)backToVc{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)toCart{
    HKBaseCartListViewController*vc = [[HKBaseCartListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)toMore{
    
}
-(void)setUI{
    [self.view addSubview:self.navView1];
    [self.view addSubview:self.navView2];
    [self reloadData];
}
-(void)loadData{
    if (self.provinceId.length>0) {
        [CommodityDetailsViewModel getUserCommodityDetails:@{@"loginUid":HKUSERLOGINID,@"productId":self.productM.productId>0?self.productM.productId:@"",@"provinceId":self.provinceId.length>0?self.provinceId:@""} success:^(CommodityDetailsRespone *responde) {
            if (responde.responeSuc) {
                if (responde.data.images.count == 0) {
                    CommodityDetailsesImages*modelImage = [[CommodityDetailsesImages alloc]init];
                    modelImage.imgSrc = self.productM.imgSrc;
                    modelImage.productId = self.productM.productId;
                    responde.data.images = @[modelImage];
                }
                self.responde = responde;
                self.vc1.responde = responde;
                self.vc2.htmlStr = responde.data.descript;
            }
        }];
    }else{
    [CommodityDetailsViewModel getCommodityDetails:@{@"loginUid":HKUSERLOGINID,@"productId":self.productId.length>0?self.productId:@""} success:^(CommodityDetailsRespone *responde) {
        if (responde.responeSuc) {
            self.responde = responde;
            self.vc1.responde = responde;
            self.vc2.htmlStr = responde.data.descript;
        }
    }];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)vcScrollViewDidScroll:(CGFloat)y isDown:(BOOL)isDown{
    if (isDown) {
        
    }else{
    if (y>=0) {
        
        if (y<374) {
            self.navView1.hidden = NO;
            self.navView2.hidden = YES;
            self.navView1.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:y/374];
        }else{
            self.navView1.hidden = YES;
            self.navView2.hidden = NO;
        }
        
        
    }else{
        self.navView1.hidden = YES;
        self.navView2.hidden = NO;
    }
    }
}
#pragma mark - HJTabViewControllerDataSource

- (NSInteger)numberOfViewControllerForTabViewController:(HJTabViewController *)tabViewController {
    return self.questionArray.count;
}

- (UIViewController *)tabViewController:(HJTabViewController *)tabViewController viewControllerForIndex:(NSInteger)index {
    HKBaseViewController*vc = self.questionArray[index];
    vc.index = index;
    return vc;
}

- (UIEdgeInsets)containerInsetsForTabViewController:(HJTabViewController *)tabViewController {
    return UIEdgeInsetsMake(-20, 0, 0, 0);
}
-(void)setProvinceId:(NSString *)provinceId{
    _provinceId =provinceId;
    if (provinceId.length>0) {
        self.navView1.isHideCart = YES;
        self.navView2.isHideCart = YES;
    }else{
        self.navView1.isHideCart = NO;
        self.navView2.isHideCart = NO;
    }
}
-(HKDetailsNavView *)navView1{
    if (!_navView1) {
        _navView1 = [[HKDetailsNavView alloc]initWithFrame:CGRectMake(0, -20, kScreenWidth, 64)];
        _navView1.delegate = self;
    }
    return _navView1;
}
-(HKLeShopingInfoNavView *)navView2{
    if (!_navView2) {
        _navView2 = [[HKLeShopingInfoNavView alloc]initWithFrame:CGRectMake(0, -0, kScreenWidth, 44)];
        _navView2.delegate = self;
        _navView2.hidden = YES;
    }
    return _navView2;
}
-(CommodityDetailsViewController *)vc1{
    if (!_vc1) {
        _vc1 = [[CommodityDetailsViewController alloc]init];
        _vc1.delegate = self;
    }
    return _vc1;
}
-(HKDetailDescViewController *)vc2{
    if (!_vc2) {
        _vc2 = [[HKDetailDescViewController alloc]init];
//        _vc1.delegate = self;
    }
    return _vc2;
}
- (NSMutableArray *)questionArray
{
    if(_questionArray == nil)
    {
        _questionArray = [NSMutableArray arrayWithArray:@[self.vc1]] ;
    }
    return _questionArray;
}
@end
