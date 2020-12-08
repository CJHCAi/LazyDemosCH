//
//  YTSearchViewController.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/3.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTSearchViewController.h"
#import "Masonry.h"
#import "YTSearchFooter.h"
#import "YTNetCommand.h"
#import "YTsearchKeyWords.h"
#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import "YTparamLoop.h"
#import "YTsearchResultItem.h"
#import "YTResultCellWithbkey.h"
#import "YTResultCellNobkey.h"
#import "YTSectionHeaderView.h"
#import "YTresultGroup.h"
#import "YTRotateRefreshIcon.h"
#import "YTsearchAllResult.h"
#import "YTDetailViewController.h"
#import "YTDetailNobkeyViewController.h"
//#import "YTkeywordsRequest.h"
@interface YTSearchViewController ()
{
    __block BOOL sectionHeaderFlag;
    __weak YTSearchFooter *weakfooter;
    NSUInteger pageInt;
    __block NSString *globalSearchKeyword;
    __block NSUInteger pagetotal;                           //请求的总页数，一旦达到了，那么下拉刷新无效

}
@property (nonatomic, strong) YTSearchBar *searchBar;
@property (nonatomic, copy) NSString *searchContent;        // 搜索内容
@property (nonatomic, strong) YTSearchFooter *footer;       // 推荐搜索
@property (nonatomic, strong) NSArray *hotSearchWords;      // 推荐搜索关键词
@property (nonatomic,strong) NSMutableArray *resultArr;     //搜索结果数组(存2个group对象)
@end

@implementation YTSearchViewController

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
    //一开始不显示sectionHeader,点击搜索时，根据搜索结果，来显示
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
#warning Incomplete implementation, return the number of sections
    return self.resultArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    YTresultGroup *group = _resultArr[section];
    return group.resultsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YTResultCellWithbkey *cell = [YTResultCellWithbkey resultCellWithbkeyWithTableView:tableView];
        YTresultGroup *groupWithbkey = _resultArr[0];
        YTsearchResultItem *searchResultItem = groupWithbkey.resultsArr[indexPath.row];
        [cell setResultCellWithbkey:searchResultItem];
        return cell;
    }else{
        YTResultCellNobkey *cell = [YTResultCellNobkey resultCellNobkeyWithTableView:tableView];
        YTresultGroup *groupNobkey = _resultArr[1];
        YTsearchResultItem *searchResultItem = groupNobkey.resultsArr[indexPath.row];
        [cell setResultCellNobkey:searchResultItem];
        return cell;
    }
    

}

#pragma mark -  点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YTDetailViewController *DetailVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"DetailVC"];
    YTDetailNobkeyViewController *DetailNobkeyVC = [[self storyboard]instantiateViewControllerWithIdentifier:@"DetailNobkeyVC"];

    
    if (indexPath.section == 0) {
        YTresultGroup *groupWithbkey = _resultArr[0];
        YTsearchResultItem *searchResultItem = groupWithbkey.resultsArr[indexPath.row];
        DetailVC.bkey = searchResultItem.bkey;
        DetailVC.bookName = searchResultItem.book;
        DetailVC.imageUrlStr = searchResultItem.picurl;
        DetailVC.bookid = searchResultItem.id;
      //  DetailVC.md = searchResultItem.md;   //有bkey的实际上没id
        DetailVC.loc = searchResultItem.loc;
        DetailVC.author = searchResultItem.author;
 
        [self.navigationController pushViewController:DetailVC animated:YES];
    }else{
        YTresultGroup *groupNobkey = _resultArr[1];
        YTsearchResultItem *searchResultItem = groupNobkey.resultsArr[indexPath.row];
        DetailNobkeyVC.md = searchResultItem.md;
        DetailNobkeyVC.bookName = searchResultItem.book;
        DetailNobkeyVC.imageUrlStr = searchResultItem.picurl;
        DetailNobkeyVC.bookid = searchResultItem.id;
        DetailNobkeyVC.md = searchResultItem.md;
        DetailNobkeyVC.loc = searchResultItem.loc;
        DetailNobkeyVC.author =searchResultItem.author;
     
        [self.navigationController pushViewController:DetailNobkeyVC animated:YES];
    }

}

#pragma mark -header样式
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    // create the parent view that will hold header Label
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , YTScreenWidth, 25)];
    [YTSectionHeaderView addHeaderToView:customView];

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
    
    self.searchBar = [YTSearchBar searchBarWithPlaceholder:@"搜索书城图书"];
    WeakSelf;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(400 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [weakSelf.searchBar becomeFirstResponder];
        weakSelf.tableView.bounces = YES;
    });

    self.navigationItem.titleView = self.searchBar;
    
    __weak YTSearchBar *wSearchBar = self.searchBar;

    self.searchBar.searchBarTextDidChangedBlock = ^{ // 文本编辑回调
        weakSelf.searchContent = wSearchBar.text;
        [weakSelf.tableView reloadData]; // 时刻刷新界面
    };
    self.searchBar.searchBarDidSearchBlock = ^{ // 搜索回调
        [LBProgressHUD showHUDto:weakSelf.view animated:NO];
        
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
        [LBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
    };
}
#pragma mark - 设置按钮的词以及点击回调
- (void)setupFooter{
    YTSearchFooter *footer = [[YTSearchFooter alloc] initWithFrame:CGRectMake(0, 0, YTScreenWidth, 270)];
    footer.hidden = self.searchContent.length;
    footer.keywords = self.hotSearchWords;
    WeakSelf;
    weakfooter = footer;
  //  __weak YTSearchFooter *weakfooter = footer;
    
    // 点击回调 点击就搜索
    footer.searchCallBack = ^(NSUInteger index) {
        [LBProgressHUD showHUDto:weakSelf.view animated:NO];
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
        [LBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
    };
    //点击换一换，回调，改变数组
    footer.changeKeyWord = ^(NSUInteger index){
        [LBProgressHUD showHUDto:weakSelf.view animated:NO];
        NSString *startParm = [YTparamLoop paramLoop];
        NSDictionary *param = @{@"rank":@"resou",
                                @"start":startParm,
                                @"length":@"9",
                                @"json":@"1",
                                @"eid":@"1136"
                                };
        [weakSelf keywordsRequest:param];
        [LBProgressHUD hideAllHUDsForView:weakSelf.view animated:NO];
        
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

    [YTNavAnimation NavPopAnimation:self.navigationController.view];
    [[self navigationController] popViewControllerAnimated:NO];
}

#pragma mark - 点击“换一换”，修改关键词
-(void)keywordsRequest:(NSDictionary *)param{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
      [manager GET :keyWordsUrl
         parameters:param
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             NSArray *tempArr = [YTsearchKeyWords mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"list"]];

             NSMutableArray *tempStrArr = [NSMutableArray array];
             for (YTsearchKeyWords *k in tempArr) {
                 [tempStrArr addObject:k.book];
             }
             [tempStrArr addObject:@"换一换"];
             //修改数组
             _hotSearchWords = tempStrArr;
             //改变按钮内容
             [weakfooter setKeywords:self.hotSearchWords];
    
             }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   NSLog(@"%@",error);
                      
            }];

}

#pragma mark - 搜索的网络请求
-(void)searchRequest:(NSDictionary *)param{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET :searchUrl
       parameters:param
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              //取总体模型，可以得到 pagenum, pagesize ,pagetotal, totalnum 这4个有用的数据
              YTsearchAllResult *allresult = [YTsearchAllResult mj_objectWithKeyValues:responseObject];
              pagetotal = allresult.pagetotal;

              NSMutableArray *tempArr = [YTsearchResultItem mj_objectArrayWithKeyValuesArray:[responseObject valueForKey:@"list"]];
              YTresultGroup *groupWithbkey = [[YTresultGroup alloc]init];
              YTresultGroup *groupNobkey = [[YTresultGroup alloc]init];
              
              YTresultGroup *realGroupWithbkey = [[YTresultGroup alloc]init];
              YTresultGroup *realGroupNobkey = [[YTresultGroup alloc]init];
              //1.加载更多时，先取出 groupNobeky
              if (_resultArr.count > 1) {
                  realGroupWithbkey = _resultArr[0];
                  realGroupNobkey = _resultArr[1];
              }
              
              for (YTsearchResultItem *r in tempArr) {
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
              
          }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"%@",error);
              
          }];



}

#pragma mark - 上拉加载设置  ＋ 自定义文字 和图片
- (void)setupRefresh{
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    YTRotateRefreshIcon *footer = [YTRotateRefreshIcon footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    // 设置图片
    [footer prepare];
    // 设置footer
    self.tableView.mj_footer = footer;

}

#pragma mark - 加载更多数据
- (void)loadMoreData{
   
    pageInt += 1;
    if (pageInt <= pagetotal) {
         [LBProgressHUD showHUDto:self.view animated:NO];
         NSString *pageStr = [NSString stringWithFormat:@"%zd",pageInt];
         NSDictionary *param = @{@"keyword":globalSearchKeyword,
                                       @"json":@"1",
                                       @"p":pageStr,
                                       @"eid":@"1136"
                                       };
         [self searchRequest:param];
         // 拿到当前的上拉刷新控件，结束刷新状态
         [self.tableView.mj_footer endRefreshing];
         [LBProgressHUD hideAllHUDsForView:self.view animated:NO];
    }else{
        self.tableView.mj_footer = nil;
        NSLog(@"已经没有数据了,让它无法刷新");
        }
    
}
@end
