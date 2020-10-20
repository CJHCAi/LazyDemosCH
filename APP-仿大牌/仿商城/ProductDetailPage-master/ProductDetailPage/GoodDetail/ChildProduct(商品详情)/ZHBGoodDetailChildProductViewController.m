
//
//  ZHBGoodDetailChildProductViewController.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/14.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "ZHBGoodDetailChildProductViewController.h"
#import "ZHBGoodDetailViewModel.h"
#import "ZHBGoodDetailWebView.h"

#import "APXProductModel.h"
#import "ZHBProdictDetailInfoModel.h"

static NSString *const KZHBGoodDetailBasicInfoTableViewCell = @"ZHBGoodDetailBasicInfoTableViewCell";



static CGFloat const kEndDragHeight             = 60.f; // 结束拖拽最大值时的显示
static CGFloat const kBottomButtonViewHeight    = 50.f; // 底部视图高度（加入购物车＼立即购买）


@interface ZHBGoodDetailChildProductViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,ZHBGoodDetailBasicInfoTableViewCellDelegate>

@property (nonatomic, strong) ZHBGoodDetailViewModel *viewModel;

@property (nonatomic, strong) UIScrollView *bannerScroll; // 装轮播图的scroll, 双倍缩进用
@property (nonatomic, strong) UIView *powerfulBannerView;
@property (nonatomic, strong) NSMutableArray *browseItemArray; // 图片浏览器

@property (assign, nonatomic) CGFloat pageHeight;
@property (assign, nonatomic) CGFloat bannerOffset; // 缩进距离,banner双倍缩进记录


@end

@implementation ZHBGoodDetailChildProductViewController

#pragma - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    self.pageHeight = kScreenHeight  - kBottomButtonViewHeight - [UIScreen safeBottomMargin];

    
    [self.view addSubview:self.allContentView];
    [self.allContentView addSubview:self.productTableView];
    [self.bannerScroll addSubview:self.powerfulBannerView];

    // 没数据加个提示吧..
    if (IsNilOrNull(self.viewModel.productInfo)) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"没有数据, 就试试左右滑动吧";
        [self.view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.mas_equalTo(self.view);
        }];
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 恢复缩进
    self.bannerScroll.contentOffset = CGPointMake(self.bannerScroll.contentOffset.x, self.bannerOffset);
}




#pragma mark - header&footer
// 增加轮播图
- (void)addTableViewHeaderFooter
{
#pragma mark header
    UIView * headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    headView.backgroundColor = ColorWithHex(0xf1f2f6);
    [headView addSubview:self.bannerScroll];
    self.productTableView.tableHeaderView = headView;
    
#pragma mark footer
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 48)];
    footer.backgroundColor = ColorWithHex(0xF5F5F5);
    
    UIButton *dragBtn = [[UIButton alloc] init];
    dragBtn.backgroundColor = [UIColor clearColor];
    [dragBtn setTitleColor:ColorWithHex(0xA3A3A3) forState:UIControlStateNormal];
    dragBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [dragBtn setTitle:@"上滑查看图文详情" forState:UIControlStateNormal];
    [dragBtn addTarget:self action:@selector(dragBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:dragBtn];
    [dragBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(footer);
        make.height.mas_equalTo(footer.mas_height);
    }];
    
    UIView *lineLeft = [[UIView alloc] init];
    [footer addSubview:lineLeft];
    lineLeft.backgroundColor = ColorWithHex(0XE2E1E1);
    [lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(dragBtn.mas_centerY);
        make.width.mas_equalTo(60);
        make.trailing.mas_equalTo(dragBtn.mas_leading).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    UIView *lineRight = [[UIView alloc] init];
    [footer addSubview:lineRight];
    lineRight.backgroundColor = ColorWithHex(0XE2E1E1);
    [lineRight mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerY.mas_equalTo(dragBtn.mas_centerY);
        make.width.mas_equalTo(60);
        make.leading.mas_equalTo(dragBtn.mas_trailing).offset(10);
        make.height.mas_equalTo(1);
    }];
    self.productTableView.tableFooterView = footer;
}
// 上拉查看图文详情点击
- (void)dragBtnClick:(id)sender
{
    [self scrollToWebTransform];
}

#pragma mark - private transform
- (void)scrollToWebTransform
{
    if ([self.delegate respondsToSelector:@selector(childProductViewController:ScrollToType:)]) {
        [self.delegate childProductViewController:self ScrollToType:ChildProductViewScrollTypeScrollToWebView];
    }

    [UIView animateWithDuration:0.4 animations:^{
//        self.allContentView.transform = CGAffineTransformTranslate(self.allContentView.transform, 0, - self.pageHeight);
        self.allContentView.contentOffset = CGPointMake(0, self.pageHeight + kEndDragHeight);
        
    } completion:^(BOOL finished) {

    }];
}
- (void)scrollToTabTransform
{
    if ([self.delegate respondsToSelector:@selector(childProductViewController:ScrollToType:)]) {
        [self.delegate childProductViewController:self ScrollToType:ChildProductViewScrollTypeScrollToTableView];
    }
    [UIView animateWithDuration:0.4 animations:^{
//        self.allContentView.transform = CGAffineTransformIdentity;
        self.allContentView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
       
    }];
}

#pragma mark - public
- (void)configureWebview:(ZHBGoodDetailWebView *)goodDetailWebView
{
    self.goodDetailWebView = goodDetailWebView;
    self.goodDetailWebView.frame = CGRectMake(0, self.productTableView.y + self.productTableView.height + kEndDragHeight + UIScreen.navigationBarHeight, kScreenWidth, self.pageHeight - UIScreen.navigationBarHeight);
    self.goodDetailWebView.infoWebView.scrollView.delegate = self;
    [self.goodDetailWebView setHeaderHidden:NO];
    [self.allContentView addSubview:self.goodDetailWebView];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.viewModel.productInfo) {
        
        return self.viewModel.sectionItem.count;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    GoodDetailSectionType sectionType = [[self.viewModel.sectionItem objectAtIndex:section] integerValue];
    if (sectionType == GoodDetailSectionTypeBasicInfo) {

        return 1;
        
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodDetailSectionType sectionType = [[self.viewModel.sectionItem objectAtIndex:indexPath.section] integerValue];
    if (sectionType == GoodDetailSectionTypeBasicInfo) {
        

            // 基本信息
            ZHBGoodDetailBasicInfoTableViewCell *basicInfoCell = [tableView dequeueReusableCellWithIdentifier:KZHBGoodDetailBasicInfoTableViewCell];
            basicInfoCell.detailViewModel = self.viewModel;
            basicInfoCell.delegate = self;
            
            return basicInfoCell;
        
    }else{
        
        NSAssert(NO, @" 不该有别的type ");
        return nil;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 已用block
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodDetailSectionType sectionType = [[self.viewModel.sectionItem objectAtIndex:indexPath.section] integerValue];
    if (sectionType == GoodDetailSectionTypeBasicInfo) {
        

            return 400.f;
        
    }else{
        
        NSLog(@" 不该有别的type ");
        return 200.f;
    }

}




#pragma mark - APXRecommendCellDelegate

#pragma mark - ZHBGoodDetailBasicInfoTableViewCellDelegate
- (void)goodDetailBasicInfoTableViewCell:(ZHBGoodDetailBasicInfoTableViewCell *)goodBasicInfoCell
didClickWithBasicInfoTableViewCellClickType:(BasicInfoTableViewCellClickType)basicInfoCellClickType
{
    switch (basicInfoCellClickType) {
            
            // 领券点击
        case BasicInfoTableViewCellClickTypeGetCoupon:

          
            break;
            
            // 优惠点击
        case BasicInfoTableViewCellClickTypeDiscount:
            
            
            break;
            
            // 已选点击
        case BasicInfoTableViewCellClickTypeSelected:
            
            

            
            break;
            // 服务说明
        case BasicInfoTableViewCellClickTypeServiceDescription:
            
          
            break;
            
            // 配置
        case BasicInfoTableViewCellClickTypeConfig:
            
          
            
            break;
            
            // 降价
        case BasicInfoTableViewCellClickTypeReduction:

            break;
            
            // 购买须知
        case BasicInfoTableViewCellClickTypeBuyTip:
            
          
        default:
            break;
    }

}


#pragma mark - APXProductCommentTotalTableHeaderViewDelegate

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    
    if (scrollView == self.productTableView) {
        self.bannerScroll.contentOffset = CGPointMake(self.bannerScroll.contentOffset.x, 0);
        // 双倍缩进轮播图
        if (self.productTableView.contentOffset.y >= 0 && self.productTableView.contentOffset.y <= kScreenWidth) {

            self.bannerOffset = -offset / 2.0f;
            self.bannerScroll.contentOffset = CGPointMake(self.bannerScroll.contentOffset.x, self.bannerOffset);
        }
        
        // 代理处理控制器navbar透明度
        if ([self.delegate respondsToSelector:@selector(childProductViewControllerScrollViewDidScroll:)])
        {
            [self.delegate childProductViewControllerScrollViewDidScroll:offset];
        }

     
    }else{
//         隐藏文字
        self.goodDetailWebView.webViewHeaderMsg.alpha = (-scrollView.contentOffset.y) / kEndDragHeight;
        if (self.goodDetailWebView.webViewHeaderMsg.alpha >= 1) {
            self.goodDetailWebView.webViewHeaderMsg.text = @"释放回到“商品详情”";
        }else{
            self.goodDetailWebView.webViewHeaderMsg.text = @"下拉回到“商品详情”";
        }
        
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"%lf,%lf",scrollView.contentOffset.y,self.productTableView.contentSize.height - self.pageHeight + kEndDragHeight);
    if (decelerate) {
        CGFloat offset = scrollView.contentOffset.y;
        if (scrollView == self.productTableView) {
            // 滚到下部
            // 加载webview的view
            if (self.goodDetailWebView) {
                [self configureWebview:self.goodDetailWebView];
            }
            
//            self.productTableView.contentSize.height - kScreenHeight + kEndDragHeight + kBottomButtonViewHeight
            if (offset >= self.productTableView.contentSize.height - self.pageHeight + kEndDragHeight) {
                self.goodDetailWebView.webViewHeaderMsg.alpha = 0;
                [self scrollToWebTransform];
            }
        }else{
            // 滚到上部
            if (offset <= -kEndDragHeight) {
                [self scrollToTabTransform];
            }
        }
    }
}

#pragma mark - lazy load
- (UIScrollView *)allContentView
{
    if (!_allContentView) {
        _allContentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.pageHeight)];
        _allContentView.contentSize = CGSizeMake(kScreenWidth, self.pageHeight * 2 + kEndDragHeight);
        _allContentView.scrollEnabled = NO;
    }
    return _allContentView;
}
- (UITableView *)productTableView
{
    if (!_productTableView) {
        _productTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.pageHeight) style:UITableViewStyleGrouped];
        _productTableView.delegate = self;
        _productTableView.dataSource = self;
//        _productTableView.backgroundColor = UIColorHex(0xf5f5f5);
        _productTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _productTableView.showsVerticalScrollIndicator = NO;
        // registerCell
        [_productTableView registerNib:[UINib nibWithNibName:KZHBGoodDetailBasicInfoTableViewCell bundle:nil]
                    forCellReuseIdentifier:KZHBGoodDetailBasicInfoTableViewCell];

    }
    return _productTableView;
}
- (NSMutableArray *)browseItemArray
{
    if (!_browseItemArray) {
        _browseItemArray = [NSMutableArray array];
    }
    return _browseItemArray;
}
- (ZHBGoodDetailViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[ZHBGoodDetailViewModel alloc] init];
    }
    return _viewModel;
}

- (UIView *)powerfulBannerView
{
    if (!_powerfulBannerView) {
        _powerfulBannerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
    }
    return _powerfulBannerView;
}
// 装轮播图容器, 双倍缩进轮播图用
- (UIScrollView *)bannerScroll
{
    if (!_bannerScroll) {
        _bannerScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth)];
        _bannerScroll.contentSize = CGSizeMake(kScreenWidth, kScreenWidth);
    }
    return _bannerScroll;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    NSLog(@"---%s---",__func__);
}
@end


