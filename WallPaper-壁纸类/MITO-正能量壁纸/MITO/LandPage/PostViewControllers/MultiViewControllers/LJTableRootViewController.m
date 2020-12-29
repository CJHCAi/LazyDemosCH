//
//  LJTableRootViewController.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJTableRootViewController.h"
#import "AFNetworking.h"
#import <Ono.h>
#import "LJTableViewModel.h"
#import <MJRefresh.h>
//#import "LJCoverPictrueViewController.h"

@interface LJTableRootViewController (){
    
    NSInteger _page;
    AFHTTPRequestOperationManager *manager;
}


@end

@implementation LJTableRootViewController

- (MBProgressHUDManager *)hudManager {
    if (!_hudManager) {
        _hudManager = [[MBProgressHUDManager alloc] initWithView:self.view];
    }
    return _hudManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 界面相关
- (void) setupUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 104) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 150;
    [_tableView registerNib:[UINib nibWithNibName:@"LJTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TABLEVIEWCELL"];
    [self.view addSubview:_tableView];
    [self refreshView];
    
}
- (void) refreshView {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page ++;
        [self requestDataWithPage:_page];
    }];
    footer.automaticallyRefresh = NO;
    _tableView.tableFooterView = footer;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 0;
        [_dataArray removeAllObjects];
        [self requestDataWithPage:_page];
    }];
    _tableView.tableHeaderView = header;
}

#pragma mark 数据相关
- (void)loadData {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    _page = 0;
    manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self requestDataWithPage:_page];
}

- (void) requestDataWithPage:(NSInteger)page {
    NSString *newUrl = [NSString stringWithFormat:self.urlStr,self.viewControllerType,_page];
    [self.hudManager showMessage:@"正在加载数据"];
    [manager GET:newUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithData:responseObject error:nil];
        NSArray *array = [document.rootElement childrenWithTag:@"album"];
        for (ONOXMLElement *element in array) {
            NSString *str = [element stringValue];
            NSDictionary *dict = element.attributes;
//            NSLog(@"%@",dict);
            LJTableViewModel *model = [[LJTableViewModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            model.desc = str;
            model.baseurl = document.rootElement.attributes[@"baseurl"];
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [self.hudManager showSuccessWithMessage:@"加载成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_tableView.mj_footer.state == MJRefreshStateRefreshing) {
            _page --;
            if (_page < 0) {
                _page = 0;
            }
            [_tableView.mj_footer endRefreshing];
        }
        [_tableView.mj_header endRefreshing];
        [self.hudManager showErrorWithMessage:[NSString stringWithFormat:@"%@",error.localizedDescription]];
    }];
}


#pragma mark UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LJTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TABLEVIEWCELL" forIndexPath:indexPath];
    if (_dataArray.count > 0) {
        cell.model = _dataArray[indexPath.row];
    }
    return cell;
}

#pragma mark UITabelViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    LJCoverPictrueViewController *coverVC = [[LJCoverPictrueViewController alloc] init];
//    LJTableViewModel *model = _dataArray[indexPath.row];
//    coverVC.urlStr = [NSString stringWithFormat:@"http://360web.shoujiduoduo.com/wallpaper/wplist.php?user=868637010417434&prod=WallpaperDuoduo2.3.6.0&isrc=WallpaperDuoduo2.3.6.0_360ch.apk&type=getlist&listid=80000%@&st=no&pg=0&pc=20&mac=802275a25111&dev=K-Touch%%253ET6%%253EK-Touch%%2BT6&vc=2360",model.ID];
//    coverVC.desc = model.desc;
//    [self.navigationController pushViewController:coverVC animated:YES];
}



@end
