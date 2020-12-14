//
//  ARSearchViewController.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARSearchViewController.h"
#import "Masonry.h"
#import "ARSearchFooter.h"
//#import "ARNetCommand.h"
#import "ARSearchKeyWords.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import "ARParamLoop.h"
#import "ARSearchResultItem.h"
#import "ARResultCellWithbkey.h"
#import "ARResultCellNobkey.h"
#import "ARSectionHeaderView.h"
#import "ARResultGroup.h"
#import "ARRotateRefreshIcon.h"
#import "ARSearchAllResult.h"
#import "ARDetailViewController.h"
#import "ARDetailNobkeyViewController.h"
#import "ARSearchBar.h"
#import "MBProgressHUD.h"


#import "UIBarButtonItem+Extension.h"
#import "AFNetworking.h"
#import "ARSearchAllResult.h"

@interface ARSearchViewController ()
{
    __block BOOL sectionHeaderFlag;
    __weak ARSearchFooter *weakfooter;
    NSUInteger pageInt;
    __block NSString *globalSearchKeyword;
    __block NSUInteger pagetotal;                           //请求的总页数，一旦达到了，那么下拉刷新无效
}

@property (nonatomic, strong) ARSearchBar *searchBar;
@property (nonatomic, copy) NSString *searchContent;        // 搜索内容
@property (nonatomic, strong) ARSearchFooter *footer;       // 推荐搜索
@property (nonatomic, strong) NSArray *hotSearchWords;      // 推荐搜索关键词
@property (nonatomic,strong) NSMutableArray *resultArr;     //搜索结果数组(存2个group对象)

@end

@implementation ARSearchViewController

//1 懒加载
- (NSMutableArray *)resultArr
{
    if (_resultArr ==nil) {
        _resultArr = [NSMutableArray array];
    }
    return _resultArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    sectionHeaderFlag = NO;
    pageInt = 1;
    _hotSearchWords = @[@"完美世界",@"大主宰",@"雪鹰领主",@"龙王传说",@"校花的贴身高手",@"武炼巅峰",@"帝霸",@"超品相师",@"武逆",@"换一换" ];
    
    self.tableView.bounces = NO;
    
    [self setupNavBar];
    [self setupFooter];
    [self setupTableView];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.resultArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ARResultGroup *group = self.resultArr[section];
    return group.resultsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ARResultCellWithbkey *cell = [ARResultCellWithbkey resultCellWithbkeyWithTableView:tableView];
        ARResultGroup *groupWithbkey = self.resultArr[0];
        ARSearchResultItem *searchResultItem = groupWithbkey.resultsArr[indexPath.row];
        [cell setResultCellWithbkey:searchResultItem];
        return cell;
    } else {
        ARResultCellNobkey *cell = [ARResultCellNobkey resultCellNobkeyWithTableView:tableView];
        ARResultGroup *groupNobkey = self.resultArr[1];
        ARSearchResultItem *searchResultItem = groupNobkey.resultsArr[indexPath.row];
        [cell setResultCellNobkey:searchResultItem];
        return cell;
    }
}

#pragma mark - 点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ARDetailViewController *detailVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"detailVC"];
    ARDetailNobkeyViewController *detailNobkeyVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"detailNobkeyVC"];
    
    if (indexPath.section == 0) {
        ARResultGroup *groupWithbkey = _resultArr[0];
        ARSearchResultItem *searchResultItem = groupWithbkey.resultsArr[indexPath.row];
        detailVC.bkey = searchResultItem.bkey;
        detailVC.bookName = searchResultItem.book;
        detailVC.imageUrlStr = searchResultItem.picurl;
        detailVC.bookid = searchResultItem.id;
        //  DetailVC.md = searchResultItem.md;   //有bkey的实际上没id
        detailVC.loc = searchResultItem.loc;
        detailVC.author = searchResultItem.author;
        
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        ARResultGroup *groupNobkey = _resultArr[1];
        ARSearchResultItem *searchResultItem = groupNobkey.resultsArr[indexPath.row];
        detailNobkeyVC.md = searchResultItem.md;
        detailNobkeyVC.bookName = searchResultItem.book;
        detailNobkeyVC.imageUrlStr = searchResultItem.picurl;
        detailNobkeyVC.bookid = searchResultItem.id;
        detailNobkeyVC.md = searchResultItem.md;
        detailNobkeyVC.loc = searchResultItem.loc;
        detailNobkeyVC.author =searchResultItem.author;
        
        [self.navigationController pushViewController:detailNobkeyVC animated:YES];
    }
}


#pragma mark -header样式
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // create the parent view that will hold header Label
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , ARScreenWidth, 25)];
    [ARSectionHeaderView addHeaderToView:customView];
    
    return customView;
}

#pragma mark - header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1){
        return 25;
    }else{
        return 0;
    }
}

#pragma mark - cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //两种cell的高度
    if (indexPath.section == 0) {
        return 238;
    }else{
        return 110;
    }
}

#pragma mark - 属性

#pragma mark - 设置导航栏 以及搜索点击回调
- (void)setupNavBar {
    //跳转到下一界面的返回按钮样式
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"取消"
                                                                              target:self
                                                                              action:@selector(cancel)];

    
    self.searchBar = [ARSearchBar searchBarWithPlaceholder:@"搜索书城图书"];
    WeakSelf;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(400 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [weakSelf.searchBar becomeFirstResponder];
        weakSelf.tableView.bounces = YES;
    });
    
    self.navigationItem.titleView = self.searchBar;
    
    __weak ARSearchBar *wSearchBar = self.searchBar;
    
    self.searchBar.searchBarTextDidChangedBlock = ^{ // 文本编辑回调
        weakSelf.searchContent = wSearchBar.text;
        [weakSelf.tableView reloadData]; // 时刻刷新界面
    };
    // 搜索回调，直接在搜索框中输入搜索
    self.searchBar.searchBarDidSearchBlock = ^{
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        
        weakSelf.tableView.tableHeaderView = nil;
        sectionHeaderFlag = YES;
        [weakSelf.resultArr removeAllObjects];
        [weakSelf.searchBar resignFirstResponder ];
        NSString *searchKeyword = weakSelf.searchBar.text;
        globalSearchKeyword = searchKeyword;
        NSString *pageStr = @"1";
        NSDictionary *param = @{@"keyword":searchKeyword,
                                @"json":@"1",
                                @"p":pageStr,
                                @"eid":@"1136"
                                };
        [weakSelf searchRequest:param];
        //使能刷新
        [weakSelf setupRefresh];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];

    };
}
#pragma mark - 设置热门词汇按钮的词以及点击回调
- (void)setupFooter{
    ARSearchFooter *footer = [[ARSearchFooter alloc] initWithFrame:CGRectMake(0, 0, ARScreenWidth, 270)];
    footer.hidden = self.searchContent.length;
    footer.keywords = self.hotSearchWords;
    WeakSelf;
    weakfooter = footer;
    //  __weak ARSearchFooter *weakfooter = footer;
    
    // 点击回调 点击就搜索
    footer.searchCallBack = ^(NSUInteger index) {
        [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        
        weakSelf.tableView.tableHeaderView = nil;
        sectionHeaderFlag = YES;
        [weakSelf.resultArr removeAllObjects];
        [weakSelf.searchBar resignFirstResponder ];
        NSString *searchKeyword = weakSelf.hotSearchWords[index];
        globalSearchKeyword = searchKeyword;
        [weakSelf.searchBar setText:searchKeyword];
        NSString *pageStr = @"1";
        NSDictionary *param = @{@"keyword":searchKeyword,
                                @"json":@"1",
                                @"p":pageStr,
                                @"eid":@"1136"
                                };
        [weakSelf searchRequest:param];
        //使能刷新
        [weakSelf setupRefresh];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    };
    //点击换一换，回调，改变数组
    footer.changeKeyWord = ^(NSUInteger index){
        [MBProgressHUD showHUDAddedTo: self.view animated: YES];
        NSString *startParm = [ARParamLoop paramLoop];
        NSDictionary *param = @{@"rank":@"resou",
                                @"start":startParm,
                                @"length":@"9",
                                @"json":@"1",
                                @"eid":@"1136"
                                };
        [weakSelf keywordsRequest:param];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    };
    
    //  self.tableView.tableFooterView = footer;
    self.tableView.tableHeaderView = footer;
    self.footer = footer;
    
    
}

# pragma mark - 设置header footer高度
- (void)setupTableView {
    self.tableView.sectionHeaderHeight = 0.1;
    self.tableView.sectionFooterHeight = 0.1;
}

#pragma mark - 点击取消，返回上一界面
-(void)cancel{
    
    [ARNavAnimation NavPopAnimation:self.navigationController.view];
    [[self navigationController] popViewControllerAnimated:NO];
}

#pragma mark - 点击“换一换”，修改关键词
-(void)keywordsRequest:(NSDictionary *)param{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:keyWordsUrl parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *tempArr = [ARSearchKeyWords mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"list"]];
        
        NSMutableArray *tempStrArr = [NSMutableArray array];
        for (ARSearchKeyWords *k in tempArr) {
            [tempStrArr addObject:k.book];
        }
        
        [tempStrArr addObject:@"换一换"];
        //修改数组
        _hotSearchWords = tempStrArr;
        //改变按钮内容
        [weakfooter setKeywords:self.hotSearchWords];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

#pragma mark - 搜索的网络请求
-(void)searchRequest:(NSDictionary *)param{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:searchUrl parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //取总体模型，可以得到 pagenum, pagesize ,pagetotal, totalnum 这4个有用的数据
        ARSearchAllResult *allresult = [ARSearchAllResult mj_objectWithKeyValues:responseObject];
        pagetotal = allresult.pagetotal;
        
        NSMutableArray *tempArr = [ARSearchResultItem mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"list"]];
        ARResultGroup *groupWithbkey = [[ARResultGroup alloc]init];
        ARResultGroup *groupNobkey = [[ARResultGroup alloc]init];
        
        ARResultGroup *realGroupWithbkey = [[ARResultGroup alloc]init];
        ARResultGroup *realGroupNobkey = [[ARResultGroup alloc]init];
        //1.加载更多时，先取出 groupNobeky
        if (_resultArr.count > 1) {
            realGroupWithbkey = _resultArr[0];
            realGroupNobkey = _resultArr[1];
        }
        
        for (ARSearchResultItem *r in tempArr) {
            if ([r.bkey isEqualToString:@"" ]) {
                [groupNobkey.resultsArr addObject:r];
            }else{
                [groupWithbkey.resultsArr addObject:r];
            }
        }
        [realGroupNobkey.resultsArr addObjectsFromArray:groupNobkey.resultsArr];
        [realGroupWithbkey.resultsArr addObjectsFromArray:groupWithbkey.resultsArr];
        //如果第一次，就直接装入数组
        if (_resultArr.count < 1) {
            [_resultArr addObject:groupWithbkey];
            [_resultArr addObject:groupNobkey];
        }else{  //如果是加载更多数据操作，就更新数组
            [_resultArr replaceObjectAtIndex:0 withObject:realGroupWithbkey];
            [_resultArr replaceObjectAtIndex:1 withObject:realGroupNobkey];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
}

#pragma mark - 上拉加载设置  ＋ 自定义文字 和图片
- (void)setupRefresh{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    ARRotateRefreshIcon *footer = [ARRotateRefreshIcon footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置图片
    [footer prepare];
    // 设置footer
    self.tableView.mj_footer = footer;
    
}

#pragma mark - 加载更多数据
- (void)loadMoreData{
    
    pageInt += 1;
    if (pageInt <= pagetotal) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *pageStr = [NSString stringWithFormat:@"%zd",pageInt];
        NSDictionary *param = @{@"keyword":globalSearchKeyword,
                                @"json":@"1",
                                @"p":pageStr,
                                @"eid":@"1136"
                                };
        [self searchRequest:param];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else{
        self.tableView.mj_footer = nil;
        NSLog(@"已经没有数据了,让它无法刷新");
    }
    
}

@end
