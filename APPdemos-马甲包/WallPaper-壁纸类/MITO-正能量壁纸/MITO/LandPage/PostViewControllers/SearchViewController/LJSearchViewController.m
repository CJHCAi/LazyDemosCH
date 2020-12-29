//
//  LJSearchViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJSearchViewController.h"
#import "AFNetworking.h"
#import <Ono.h>
#import "LJSearchCell.h"
#import "LJObjectsViewController.h"

@interface LJSearchViewController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,searchBarProtocol>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    AFHTTPRequestOperationManager *_manager;
    UISearchBar *_searchBar;
}

@end

@implementation LJSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBase];
    [self loadData];
    [self setupUI];
}

- (void)setupBase{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"搜索";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithColor:[UIColor whiteColor] highColor:[UIColor redColor] target:self action:@selector(cancel) title:@"取消"];
    [self.navigationController.navigationBar layoutIfNeeded];
}

- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark 界面相关
- (void) setupUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"LJSearchCell" bundle:nil] forCellReuseIdentifier:@"SEARCHCELL"];
    [self.view addSubview:_tableView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 80)];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder = @"请输入搜索内容";
    _searchBar.delegate = self;
    [view addSubview:_searchBar];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 100, 30)];
    label.text = @"今日热词榜";
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    [_tableView setTableHeaderView:view];
    
    
}

#pragma mark 数据相关
- (void) loadData {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self requestData];
}

- (void) requestData {
    [_manager GET:@"http://360web.shoujiduoduo.com/wallpaper/wplist.php?user=868637010417434&prod=WallpaperDuoduo2.3.6.0&isrc=WallpaperDuoduo2.3.6.0_360ch.apk&type=gethotkeyword&mac=802275a25111&dev=K-Touch%253ET6%253EK-Touch%2BT6&vc=2360" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:responseObject error:nil];
        NSArray *array = [document.rootElement childrenWithTag:@"key"];
        int count = 0;
        NSMutableArray *array1;
        for (ONOXMLElement *element in array) {
            if (!array1) {
                array1 = [NSMutableArray array];
                count = 0;
            }
            NSString *str = element.attributes[@"txt"];
            [array1 addObject:str];
            if (count == 1) {
                [_dataArray addObject:array1];
                array1 = nil;
            }
            count ++;
        }
        
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];
}

#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SEARCHCELL" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    [cell configData:_dataArray[indexPath.row] addIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
    return 0.01;
}

#pragma mark UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *str = searchBar.text;
    [self startSearchWithText:str];
    [_searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_searchBar resignFirstResponder];
}

- (void) startSearchWithText:(NSString *)str {
    
    LJObjectsViewController *objVC = [[LJObjectsViewController alloc] init];
    objVC.isFromClassify = YES;
    objVC.isFromSearch = YES;
    objVC.titleN = str;
    NSString * urlStr = [NSString stringWithFormat:@"http://360web.shoujiduoduo.com/wallpaper/wplist.php?user=868637010417434&prod=WallpaperDuoduo2.3.6.0&isrc=WallpaperDuoduo2.3.6.0_360ch.apk&type=search&keyword=%@&src=user_input&pg=0&pc=20&mac=802275a25111&dev=K-Touch%%253ET6%%253EK-Touch%%2BT6&vc=2360",str];
    objVC.urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.navigationController pushViewController:objVC animated:YES];
}

- (void)searchBarTextFromButtonTitle:(NSString *)buttonTitle {
    _searchBar.text = buttonTitle;
    [self startSearchWithText:buttonTitle];
}


@end
