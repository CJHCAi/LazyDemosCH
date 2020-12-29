//
//  DetailListController.m
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "DetailListController.h"
#import "DetailListCell.h"
#import "DetailController.h"
#import "PrefixHeader.pch"
#import "UIView+UIView_Frame.h"
#import "netErrorPage.h"
#import <MJRefresh.h>

#define KFrameShow CGRectMake(KScreenWidth * 65 / 100, 0, KScreenWidth * 35 / 100, KScreenHeight - 48)

#define kFrameHidden CGRectMake(-KScreenWidth * 35 / 100, 64, KScreenWidth, KScreenHeight - 64 - 49)
#define kFrameShow CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64 - 49)

@interface DetailListController () <UITableViewDataSource, UITableViewDelegate>

/**网络请求的model*/
@property(nonatomic, strong)NSMutableArray *modelArray;
/**主界面的tableView*/
@property(nonatomic, strong)UITableView *tableView;
/**菜单界面的tableView*/
@property(nonatomic, strong)UITableView *listTableView;
/**记录当前界面的菜单*/
@property(nonatomic, copy)noteListID listIDblock;
/**记录当前的url*/
@property(nonatomic, copy)NSString *urlString;
/**当前加载的条数*/
@property(nonatomic, assign)int count;

@end

@implementation DetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.count = 0;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.tableView registerClass:[DetailListCell class] forCellReuseIdentifier:@"detailListCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    NSString *urlString = nil;
    if (_isPushed) {
        self.navigationItem.title = [NSString stringWithFormat:@"%@", _search];
        urlString = [NSString stringWithFormat:@"http://apis.juhe.cn/cook/query?key=%@&menu=%@&rn=15&pn=0", MyKey,[_search stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }else{
        
        self.listTableView = [[UITableView alloc]initWithFrame:KFrameShow style:UITableViewStylePlain];
        self.listTableView.backgroundColor = [UIColor colorWithRed:0.141 green:0.153 blue:0.161 alpha:1.000];
        
        self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"listCell"];
        self.listTableView.backgroundColor = [UIColor colorWithRed:0.189 green:0.205 blue:0.218 alpha:1.000];
        self.listTableView.dataSource = self;
        self.listTableView.delegate = self;
        [self.view addSubview:_listTableView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 20, 20);
        [button setImage:[UIImage imageNamed:@"List"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(listAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = barButton;
        
        self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", _name, [_listArray[_listID] name]];
        
        urlString = [NSString stringWithFormat:@"http://apis.juhe.cn/cook/index?key=%@&cid=%@&rn=15&pn=0", MyKey, self.model.listId];
    }
    // 让主tableView后显示 遮住listTableView
    [self.view addSubview:_tableView];
    
    [self getRequestWithUrl:urlString];
    // 记录当前的url
    self.urlString = urlString;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getRequestWithUrl:urlString];
    }];
    // 上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)footerRefresh
{
    NSString *oldString = [NSString stringWithFormat:@"&pn=%d", self.count];
    self.count += 15;
    NSString *newString = [NSString stringWithFormat:@"&pn=%d", self.count];
    self.urlString = [self.urlString stringByReplacingOccurrencesOfString:oldString withString:newString];
    [self getRequestWithUrl:self.urlString];
    
}

#pragma mark --- 点击菜系方法 ---
- (void)listAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (self.tableView.frame.origin.x == kFrameHidden.origin.x) {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = kFrameShow;
        }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = kFrameHidden;
        }];
    }
}

#pragma mark --- 请求网络 ---
- (void)getRequestWithUrl:(NSString *)urlString
{
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        // 判断网络是否有误
        if (error) {
            NSLog(@"%@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showtipsWithString:@"网络错误"];
            });
        }else{
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSDictionary *resultDic = dic[@"result"];
            
            if ([resultDic isKindOfClass:[NSNull class]]) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *string = dic[@"reason"];
                    [self showtipsWithString:string];
                });
            }
            else
            {
                NSArray *dataArray = resultDic[@"data"];
                
                for (NSDictionary *dic in dataArray) {
                    
                    DetailListModel *model = [[DetailListModel alloc]init];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [self.modelArray addObject:model];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView.mj_footer endRefreshing];
                    [self.tableView.mj_header endRefreshing];
                });
            }
        }
    }] resume];
}

#pragma mark --- 搜索出错 ---
- (void)showtipsWithString:(NSString *)string
{
    /*
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *backAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:backAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    */
    netErrorPage *error = [[netErrorPage alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    error.warn.text = string;
    [self.view addSubview:error];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView]) {
        if (self.modelArray != nil) {
            return self.modelArray.count;
        }else{
            return 0;
        }
    }
    else
    {
        return self.listArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tableView]) {
        DetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailListCell" forIndexPath:indexPath];
        
        DetailListModel *model = _modelArray[indexPath.row];
        
        // 给cell 赋值
        cell.model = model;
        
        return cell;
    }
    // 返回列表界面的cell
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.141 green:0.153 blue:0.161 alpha:1.000];
        cell.backgroundColor = [UIColor colorWithRed:0.141 green:0.153 blue:0.161 alpha:1.000];;
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [self.listArray[indexPath.row] name]];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tableView]) {
        DetailController *detail = [[DetailController alloc]init];
        // 传值
        detail.model = _modelArray[indexPath.row];
        
        // 点击隐藏listTableView
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = kFrameShow;
        }];
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if ([tableView isEqual:_listTableView])
    {
        UITableViewCell *cell = (UITableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;
        // 把当前点击的菜系传到上一界面
        if (self.listIDblock != nil) {
            self.listIDblock(indexPath.row);
        }
        self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", _name, [_listArray[indexPath.row] name]];
        // 隐藏菜单的tableView
        [UIView animateWithDuration:0.3 animations:^{
            self.tableView.frame = kFrameShow;
        }];
        
        NSString *urlString = [NSString stringWithFormat:@"http://apis.juhe.cn/cook/index?key=%@&cid=%@&rn=15&pn=0", MyKey, [self.listArray[indexPath.row] listId]];
        // 由于是懒加载 需要先把数组置空
        self.modelArray = nil;
        // 给当前的urlString赋值
        self.urlString = urlString;
        // 回到顶部
        self.tableView.contentOffset = CGPointMake(0, 0);
        // 重新请求数据
        [self getRequestWithUrl:urlString];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tableView]) {
        return [DetailListCell rowHeight:_modelArray[indexPath.row]];
    }else{
        return 30;
    }
}

// 记录用户当前点击的ID 返回到上一界面
- (void)takeNoteListID:(noteListID)block
{
    self.listIDblock = block;
}

- (NSMutableArray *)modelArray
{
    if (_modelArray == nil) {
        _modelArray = [[NSMutableArray alloc]init];
    }
    return _modelArray;
}

@end
