//
//  ZHBGoodDetailViewController.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/14.
//  Copyright © 2016年 zhbservice. All rights reserved.
//
#import "ZHBGoodDetailViewController.h"
#import "APXStandardsView.h" // 属性
#import "APXSemiModelView.h" // 弹出窗载体
#import "ZHBGoodDetailWebView.h"
#import "ZHBGoodDetailViewModel.h"
#import "ZHBGoodDetailChildDetailViewController.h"
#import "ZHBGoodDetailChildProductViewController.h"
#import "APXStandardChooseModel.h"
#import "ZHBProdictDetailInfoModel.h"
#import "ZHBBuyBottomView.h" // 底部View
#import "ZHBGoodDetailDataController.h"
#import "APXProductModel.h"


@interface ZHBGoodDetailViewController ()<APXStandardsViewDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate,ZHBTitleViewPagerControllerDataSource,ZHBGoodDetailChildProductViewControllerDelegate,ZHBBuyBottomViewDeleagte>


@property (nonatomic, strong) ZHBGoodDetailViewModel *goodDetailViewModel;
@property (nonatomic, strong) ZHBBuyBottomView *buyBottomView; // 底部购物车,立即购买
@property (nonatomic, strong) ZHBGoodDetailWebView *gooDetailWebView;
@property (nonatomic, strong) APXSemiModelView *semiModelView;
@property (nonatomic, strong) APXStandardsView *standardsView;

@property (nonatomic, strong) ZHBGoodDetailDataController *goodDetailDataController;

@property (nonatomic, strong) ZHBGoodDetailChildDetailViewController *childDetailViewController; // 详情
@property (nonatomic, strong) ZHBGoodDetailChildProductViewController *childProductViewController; // 商品
@property (nonatomic, strong) UIViewController *childCommentViewController; // 评价

@end

@implementation ZHBGoodDetailViewController

- (void)dealData:(NSDictionary *)dict
{


    
    self.buyBottomView.hidden = NO;
    
    // 如果商品详情成功,可以滑动
    self.contentView.scrollEnabled = YES;
    self.childProductViewController.productTableView.scrollEnabled = YES;
    
    // 网址确认
    
    self.goodDetailViewModel.isExistCanSale = YES;
    self.goodDetailViewModel.status = @"5";
    
    self.goodDetailViewModel.productDesURL = @"https://www.baidu.com";
    self.goodDetailViewModel.productNormURL = @"https://www.baidu.com";
    
    [self.gooDetailWebView configureDescURL:self.goodDetailViewModel.productDesURL andStandardURL:self.goodDetailViewModel.productNormURL];
    // 赋值webView
    [self.childDetailViewController configureWebview:self.gooDetailWebView];
    [self.childProductViewController configureWebview:self.gooDetailWebView];
    
    // 下架状态
    if ([self.goodDetailViewModel.status isEqualToString:@"6"]) {
        [self.buyBottomView bottomInteractionDisable];
    }
    // 不存在可售
    if (!self.goodDetailViewModel.isExistCanSale) {
        [self.buyBottomView bottomInteractionDisable];
    }
    // 刷新商品页
//    [self.childProductViewController reloadProductDataWithDetailViewModel:self.goodDetailViewModel];

    // 赋值刷新
    self.standardsView.standardArr = self.goodDetailViewModel.productAttrsInfoArray;

}



#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNavBar];
    self.delegate = self;
    self.dataSource = self;
    self.titleViewDelegate = self;
    self.contentView.bounces = NO;
    self.view.backgroundColor = ColorWithHex(0xf5f5f5);
    self.buyBottomView.hidden = YES;

    
    [self configureBottomBar];

    self.navTitleBar.alpha = 0.f;
    [self setNavBarButtonItemsAlpha:0.f];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self dealData:nil];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#ifdef APPANALYTICS
    [[APXAnalytics sharedInstance] logEvent:kAnalyticsPage_PRODE
                                 parameters:nil
                                      timed:YES];
#endif
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
#ifdef APPANALYTICS
    [[APXAnalytics sharedInstance] endTimedEvent:kAnalyticsPage_PRODE];
#endif
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    [self configureBottomBar];
}

#pragma mark - Notification Methods & Private Methods
- (void)updateBadgeViewText
{

}

#pragma mark - Event Response
- (void)didTappedShortcutMenuButton:(id)sender
{

}

- (void)didTappedShareButton:(id)sender
{

}

#pragma mark - navBar
- (void)setupNavBar
{

}

#pragma mark - 子界面滑动代理 更改透明度
- (void)childProductViewControllerScrollViewDidScroll:(CGFloat)offset
{
    // 渐变
    CGFloat maxAlphaOffset = UIScreen.width;
    CGFloat alpha;
    if (offset >= 0.f) {
        alpha = MIN(1, offset/maxAlphaOffset);
    }else{
        alpha = 0.f;
    }

    [self setNavAlpha:alpha];
    
    // 突变
    if (offset + UIScreen.navigationBarHeight >= UIScreen.width) {
        [self setNavBarButtonItemsAlpha:1];
    }else{
        [self setNavBarButtonItemsAlpha:0];
    }
    
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置nav的alpha,因为移下去或者顶部滑动切换到别的,需要nav不透明 isOpaque 是 不透明 , 否 透明
- (void)setNavAlphaWithIsOpaque:(BOOL)isOpaque
{
    if (isOpaque) {
        
        [self setNavAlpha:1];
        [self setNavBarButtonItemsAlpha:1];
        
    }else{
        CGFloat maxAlphaOffset = UIScreen.width;
        CGFloat offset = self.childProductViewController.productTableView.contentOffset.y;
        CGFloat alpha = offset >= 0.f ? MIN(1, offset/maxAlphaOffset) : 0.f;
        [self setNavAlpha:alpha];
        // 突变
        if (offset +  UIScreen.navigationBarHeight >= UIScreen.width) {
            [self setNavBarButtonItemsAlpha:1];
        }else{
            [self setNavBarButtonItemsAlpha:0];
        }
    }

}


- (void)setNavAlpha:(CGFloat)alpha
{
//    [self.navigationController.navigationBar setOverlayBackgroundColor:[UIColor colorWithRGB:0xffffff] alpha:alpha];
//    self.navTitleBar.alpha = alpha;
}
// 要突变不要渐变..
- (void)setNavBarButtonItemsAlpha:(CGFloat)alpha
{

    
    // 左边按钮变图片
    if ([self.navigationItem.leftBarButtonItem.customView isKindOfClass:UIButton.class]) {
        
        UIButton *backButton = self.navigationItem.leftBarButtonItem.customView;
        if (alpha <= 0.f) {
            [backButton setImage:[UIImage imageNamed:@"navbar_product_back"] forState:UIControlStateNormal];
        }else{
            [backButton setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 网络请求回调


#pragma mark - private - 选择逻辑

#pragma mark - private - 一些其他逻辑
// 弹出选择属性view
- (void)showStandardModelWithType:(StandardBottomBtnType)standardBottomBtnType
{
    // dimisss时remove,需重新建立
    self.standardsView.standardBottomBtnType = standardBottomBtnType;
    self.semiModelView = [[APXSemiModelView alloc] initWithContentView:self.standardsView viewController:self.navigationController];
    [self.semiModelView show];
}

// 购买须知
- (void)showBuyTipView
{
 
}
// 降价通知
- (void)goReductionVC
{

}


// 底部
- (void) configureBottomBar
{
    [self.view addSubview:self.buyBottomView];
    [self.buyBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(@50);
        make.leading.trailing.mas_equalTo(self.view);
        
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
            make.bottom.mas_equalTo(self.view);
        }
    }];
    [self.view bringSubviewToFront:self.buyBottomView];
}
// 关注点击
- (void)attentionClick
{
    
}
// 关注状态UI改变
- (void)favoritedChange
{

}

#pragma mark - APXStandardsViewDelegate

#pragma mark - ZHBGoodDetailChildProductViewControllerDelegate
// 领券,优惠,已选,服务说明等type
- (void)childProductViewController:(ZHBGoodDetailChildProductViewController *)childProductViewController
                 BasicInfoDidClick:(BasicInfoTableViewCellClickType)basicInfoTableViewCellClickType
{
   
}
// 滚动到web和tab
- (void)childProductViewController:(ZHBGoodDetailChildProductViewController *)childProductViewController
                      ScrollToType:(ChildProductViewScrollType)childProductViewScrollType
{
    switch (childProductViewScrollType) {
            // 滑向网页
        case ChildProductViewScrollTypeScrollToWebView:
            
            self.contentView.scrollEnabled = NO;
            [self setNavAlphaWithIsOpaque:YES];
            [self upTransformWhenScorllToWeb];
            break;
            // 滑向tableView
        case ChildProductViewScrollTypeScrollToTableView:
            self.contentView.scrollEnabled = YES;
            [self setNavAlphaWithIsOpaque:NO];
            [self downTransformWhenScorllToTab];
            break;

        default:
            break;
    }
}


#pragma mark - ZHBBuyBottomViewDeleagte
- (void)buyBottomView:(ZHBBuyBottomView *)buyBottomView didClickBuyBottomClickType:(BuyBottomClickType)buyBottomClickType
{

    

}

#pragma mark - ZHBTitleViewPagerControllerDataSource
- (NSArray *)arrayInZHBTitleViewPagerController
{
    return @[@"商品",@"详情",@"评价"];
}
- (void)titleViewPagerController:(ZHBTitleViewPagerController *)pagerController didSelectAtIndex:(NSInteger)index
{
    NSLog(@"titleView didSelectAtIndex %zd",index);
}
- (void)titleViewPagerController:(ZHBTitleViewPagerController *)pagerController didScrollToTabPageIndex:(NSInteger)index
{
    NSLog(@"titleView didScrollToTabPageIndex %zd",index);
    
    switch (index) {
        case 0:

            [self setNavAlphaWithIsOpaque:NO];
//            [self clickPointStr:kAnalyticsEvent_PD_SELECTPRODUCT];
            break;
        case 1:
            
            [self setNavAlphaWithIsOpaque:YES];
//            [self clickPointStr:kAnalyticsEvent_PD_SELECTDETAIL];
            break;
        case 2:

            [self setNavAlphaWithIsOpaque:YES];
//            [self clickPointStr:kAnalyticsEvent_PD_SELECTCOMMENT];
            break;
            
        default:
            break;
    }
    

    
}
#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController
{
    return 3;
}
- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index
{
    if (index == 0) {
        return self.childProductViewController;
    }else if (index == 1){
        return self.childDetailViewController;
    }else{
        return self.childCommentViewController;
    }
}




#pragma mark - lazy load
- (ZHBGoodDetailDataController *)goodDetailDataController
{
    if (!_goodDetailDataController) {
        _goodDetailDataController = [[ZHBGoodDetailDataController alloc] init];

    }
    return _goodDetailDataController;
}
- (ZHBGoodDetailViewModel *)goodDetailViewModel
{
    if (!_goodDetailViewModel) {
        _goodDetailViewModel = [[ZHBGoodDetailViewModel alloc] init];
    }
    return _goodDetailViewModel;
}
- (ZHBBuyBottomView *)buyBottomView
{
    if (!_buyBottomView) {
        _buyBottomView = [ZHBBuyBottomView buyBottomView];
        _buyBottomView.delegate = self;
    }
    return _buyBottomView;
}
- (ZHBGoodDetailWebView *)gooDetailWebView
{
    if (!_gooDetailWebView) {
        _gooDetailWebView = [ZHBGoodDetailWebView GoodDetailWebView];
    }
    return _gooDetailWebView;
}
- (ZHBGoodDetailChildProductViewController *)childProductViewController
{
    if (!_childProductViewController) {
        
        _childProductViewController = [[ZHBGoodDetailChildProductViewController alloc] init];
        _childProductViewController.delegate = self;
        
        _childProductViewController.view.backgroundColor = [UIColor greenColor];
    }
    return _childProductViewController;
}
- (ZHBGoodDetailChildDetailViewController *)childDetailViewController
{
    if (!_childDetailViewController) {
        _childDetailViewController = [[ZHBGoodDetailChildDetailViewController alloc] init];
        
        _childProductViewController.view.backgroundColor = [UIColor blueColor];
    }
    return _childDetailViewController;
}
- (UIViewController *)childCommentViewController
{
    if (!_childCommentViewController) {
        _childCommentViewController = [[UIViewController alloc] init];
//        _childCommentViewController.goodId = self.goodId;
        _childCommentViewController.view.backgroundColor = [UIColor redColor];
    }
    return _childCommentViewController;
}
- (APXStandardsView *)standardsView
{
    if (!_standardsView) {

        _standardsView = [[APXStandardsView alloc] init];
        _standardsView.delegate = self;
        _standardsView.detailInfoModel = self.goodDetailViewModel.productInfo;
    }
    return _standardsView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"goodDetail dealloc");
}

@end
