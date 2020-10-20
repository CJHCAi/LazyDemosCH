//
//  SXTTimeViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/17.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//
//SDCycleScrollView
#import "SXTTimeViewController.h"
#import "SDCycleScrollView.h"//第三方轮播图
#import "SXTSingleListModel.h"//新品列表数据model
#import "MJExtension.h"//mj数据转模型
#import "SXTGroupListModel.h"//团购列表model
#import "SXTSingleTableView.h"//展示列表
#import "SXTTimeTwoBtnView.h"//两个button的view
#import "SXTDetailsViewController.h"//商品详情页面
#import "SXTSearchViewController.h"//搜索页面

@interface SXTTimeViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic)   UIScrollView *mainScroll;/** 最底层滑动视图 */
@property (strong, nonatomic)   SDCycleScrollView *headImageView;              /** 轮播图 */
@property (strong, nonatomic)   SXTTimeTwoBtnView *twoButtonView;              /** 中间切换列表的按钮 */
@property (strong, nonatomic)   SXTSingleTableView *singleTable;              /** 单品团购 */
@property (strong, nonatomic)   SXTSingleTableView *groupTable;            /** 品牌团购 */
@property (strong, nonatomic)   NSArray *singleModelArray;              /** 存放新品数据模型的数组 */
@property (strong, nonatomic)   NSArray *groupModelArray;/**存放团购数据模型的数组*/

@end

@implementation SXTTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = 0;
    self.view.backgroundColor = MainColor;
    [self.view addSubview:self.mainScroll];
    [self.mainScroll addSubview:self.headImageView];
    [self.mainScroll addSubview:self.singleTable];
    [self.mainScroll addSubview:self.groupTable];
    [self.mainScroll addSubview:self.twoButtonView];
    [self addSearchBtn];
    [self requestHeadImage];
    [self requestNew];
    [self requestGroupData];
}

- (void)addSearchBtn{
    UIButton *searchBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [searchBtn setImage:[UIImage imageNamed:@"限时特卖界面搜索按钮"] forState:(UIControlStateNormal)];
    searchBtn.frame = CGRectMake(0, 0, 35, 35);
    [searchBtn addTarget:self action:@selector(pushSearchViewController) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *navItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = navItem;
}

- (void)pushSearchViewController{
    SXTSearchViewController *search = [[SXTSearchViewController alloc]init];
    [self.navigationController pushViewController:search animated:YES];
}

- (UIScrollView *)mainScroll{
    if (!_mainScroll) {
        _mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, VIEW_HEIGHT - 64 - 49)];
        _mainScroll.contentSize = CGSizeMake(0, 1980);
        _mainScroll.delegate = self;
    }
    return _mainScroll;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 230){
        CGRect rect = _twoButtonView.frame;
        rect.origin.y = scrollView.contentOffset.y;
        _twoButtonView.frame = rect;
    }else{
        CGRect rect = _twoButtonView.frame;
        rect.origin.y = 230;
        _twoButtonView.frame = rect;
    }
}

- (SDCycleScrollView *)headImageView{
    if (!_headImageView) {
        _headImageView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, VIEW_WIDTH, 230) delegate:nil placeholderImage:[UIImage imageNamed:@"图标"]];
        _headImageView.backgroundColor = [UIColor orangeColor];
        _headImageView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        _headImageView.currentPageDotColor = [UIColor whiteColor]; // 自
    }
    return _headImageView;
}
//请求轮播数据
- (void)requestHeadImage{
    [self getData:@"appHome/appHome.do" param:nil success:^(id responseObject) {
        
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in responseObject) {
            NSString *imageUrl = dic[@"ImgView"];
            [imageArray addObject:imageUrl];
        }
        _headImageView.imageURLStringsGroup = imageArray;
        
        
    } error:^(NSError *error) {
        SXTLog(@"error : %@",error);
    }];
}
//请求新品数据
- (void)requestNew{
    
    [self getData:@"appActivity/appHomeGoodsList.do" param:nil success:^(id responseObject) {
        self.singleModelArray = [SXTSingleListModel mj_objectArrayWithKeyValuesArray:responseObject];
        self.singleTable.singleModelArray = self.singleModelArray;
        CGRect tableViewRect = _singleTable.frame;
        tableViewRect.size.height = _singleModelArray.count * 170;
        _singleTable.frame = tableViewRect;
        if (_twoButtonView.button1.selected) {
            _mainScroll.contentSize = CGSizeMake(0, _singleModelArray.count * 170 + 280);
        }
        [_singleTable reloadData];
    } error:^(NSError *error) {
        
    }];
}
//请求团购数据
- (void)requestGroupData{
    [self getData:@"appActivity/appActivityList.do" param:nil success:^(id responseObject) {
        self.groupModelArray = [SXTGroupListModel mj_objectArrayWithKeyValuesArray:responseObject];
        _groupTable.groupModelArray = self.groupModelArray;
        CGRect tableViewRect = _groupTable.frame;
        tableViewRect.size.height = _groupModelArray.count * 200;
        _groupTable.frame = tableViewRect;
        if (_twoButtonView.button2.selected) {
            _mainScroll.contentSize = CGSizeMake(0, _singleModelArray.count * 200 + 280);
        }
        [_groupTable reloadData];
    } error:^(NSError *error) {
        
    }];
}

- (SXTTimeTwoBtnView *)twoButtonView{
    if (!_twoButtonView) {
        _twoButtonView = [[SXTTimeTwoBtnView alloc]initWithFrame:CGRectMake(0, 230, VIEW_WIDTH, 50)];
        _twoButtonView.backgroundColor = [UIColor whiteColor];
        [_twoButtonView.button2 addTarget:self action:@selector(changeTableFrame:) forControlEvents:(UIControlEventTouchUpInside)];
        [_twoButtonView.button1 addTarget:self action:@selector(changeTableFrame:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _twoButtonView;
}

- (void)changeTableFrame:(UIButton *)button{
    
    if (button == _twoButtonView.button1) {
        button.selected = YES;
        _twoButtonView.button2.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect tableRect1 = _singleTable.frame;
            tableRect1.origin.x = 0;
            _singleTable.frame = tableRect1;
            
            CGRect tableRect2 = _groupTable.frame;
            tableRect2.origin.x = VIEW_WIDTH;
            _groupTable.frame = tableRect2;
            _mainScroll.contentSize = CGSizeMake(0, _singleModelArray.count * 170 + 280);
        }];
    }else {
        button.selected = YES;
        _twoButtonView.button1.selected = NO;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect tableRect1 = _singleTable.frame;
            tableRect1.origin.x = -VIEW_WIDTH;
            _singleTable.frame = tableRect1;
            
            CGRect tableRect2 = _groupTable.frame;
            tableRect2.origin.x = 0;
            _groupTable.frame = tableRect2;
            _mainScroll.contentSize = CGSizeMake(0, _singleModelArray.count * 200 + 280);
        }];
    }
}

- (SXTSingleTableView *)singleTable{
    if (!_singleTable) {
        _singleTable = [[SXTSingleTableView alloc]initWithFrame:CGRectMake(0, 280, VIEW_WIDTH, 1700) style:(UITableViewStylePlain)];
        _singleTable.bounces = NO;
        _singleTable.isSingle = YES;
        __weak typeof (self) weakSelf = self;
        _singleTable.goodsIDBlock = ^(NSString *goodsID){
            SXTDetailsViewController *details = [[SXTDetailsViewController alloc]init];
            details.DetailsGoodsId = goodsID;
            [weakSelf.navigationController pushViewController:details animated:YES];
        };
    }
    return _singleTable;
}

- (SXTSingleTableView *)groupTable{
    if (!_groupTable) {
        _groupTable = [[SXTSingleTableView alloc]initWithFrame:CGRectMake(VIEW_WIDTH, 280, VIEW_WIDTH, 1700) style:(UITableViewStylePlain)];
        _groupTable.bounces = NO;
        _groupTable.isSingle = NO;
    }
    return _groupTable;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
