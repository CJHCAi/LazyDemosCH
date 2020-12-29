//
//  SearchTVC.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/21.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "SearchTVC.h"
#import "CoreDataManager.h"
#import "ShakeViewController.h"
#import "ZYRScanVC.h"
#define KScreenWidth [[UIScreen mainScreen]bounds].size.width
#define KScreenHeight [[UIScreen mainScreen]bounds].size.height
#define KSearchHeight 50
#define KNavBarHeight 64

@interface SearchTVC () <UISearchBarDelegate>
@property(nonatomic, strong)UISearchBar *searchBar;
@property(nonatomic, strong)NSMutableArray *modelArray;
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *imageArray;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UITableView *listTable;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;

@end


@implementation SearchTVC
{
    float lastContentOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent=NO;
    [self initUI];

    self.modelArray=[[CoreDataManager shareInstance]selectAllTitleModel].mutableCopy;
    [self.tableView reloadData];

//    [self creatImage];
}

- (void)initUI {
    [self.navigationItem setTitle:@"Search"];
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 50)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"Search";
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.backgroundColor = [UIColor clearColor];
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"navigation"]];
    [self.view addSubview:_searchBar];
    
    self.modelArray=[[CoreDataManager shareInstance]selectAllTitleModel].mutableCopy;
    
    //tableView
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, KSearchHeight + KNavBarHeight, KScreenWidth, KScreenHeight-64 - KSearchHeight) style:UITableViewStyleGrouped];
    self.tableView.frame=CGRectMake(0, KSearchHeight + KNavBarHeight, KScreenWidth, 0);
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.separatorStyle=NO;
    [self.view addSubview:self.tableView];
    
    _listTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, KScreenWidth, KScreenHeight - 50) style:UITableViewStylePlain];
    
    
    self.button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button1 setImage:[UIImage imageNamed:@"sha"] forState:UIControlStateNormal];
    self.button1.frame = CGRectMake(0, 0, 100, 100);
    self.button1.center = CGPointMake(KScreenWidth / 3, KScreenHeight + 50);
    [self.button1 addTarget:self action:@selector(button1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button1];
    
    self.button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button2 setImage:[UIImage imageNamed:@"cam"] forState:UIControlStateNormal];
    self.button2.frame = CGRectMake(0, 0, 100, 100);
    self.button2.center = CGPointMake(KScreenWidth / 3 * 2, KScreenHeight + 50);
    [self.button2 addTarget:self action:@selector(button2Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button2];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.button1.center = CGPointMake(KScreenWidth / 3, KScreenHeight + 50);
    self.button2.center = CGPointMake(KScreenWidth / 3 * 2, KScreenHeight + 50);
    [self buttonsUp];
}

- (void)button1Action:(UIButton *)button
{
    ShakeViewController *shake = [[ShakeViewController alloc]init];
    [self.navigationController pushViewController:shake animated:YES];
}
- (void)button2Action:(UIButton *)button2
{
    ZYRScanVC *scan = [[ZYRScanVC alloc]init];
    [self.navigationController pushViewController:scan animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, KScreenWidth, 40)];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.textColor = [UIColor grayColor];
    label.text=@"    历史记录";
    UIButton *button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=CGRectMake(KScreenWidth-100, 0, 100, 30);
    [button setTitle:@"清空历史  " forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:label];
    [headerView addSubview:button];
    return headerView;
    
}
- (void)buttonAction:(UIButton *)button
{
    //清除历史搜索
    [[CoreDataManager shareInstance]deleteAllSearchModel];
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"cell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    Search *search=self.modelArray[self.modelArray.count-1-indexPath.row];
    cell.textLabel.text = search.title;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //跳转详情界面
    DetailListController *detail=[[DetailListController alloc]init];
    detail.search=[self.modelArray[self.modelArray.count-1-indexPath.row] title];
    detail.isPushed=YES;
    NSLog(@"%@",detail.search);
    [self.navigationController pushViewController:detail animated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//每个分区下的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.modelArray=[[CoreDataManager shareInstance]selectAllTitleModel].mutableCopy;
    return self.modelArray.count;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
    if (lastContentOffset < scrollView.contentOffset.y) {
        NSLog(@"向上滚动");
    }else{
        //上下轻扫tableView 取消键盘
        [self.searchBar resignFirstResponder];
        self.searchBar.showsCancelButton = NO;
        //隐藏tableView
        [UIView animateWithDuration:0.1 animations:^{
            self.tableView.frame=CGRectMake(0, KSearchHeight+10 + KNavBarHeight, KScreenWidth, 0);
            NSLog(@"上下拉");
        } completion:nil];
        NSLog(@"向下滚动");
        [self buttonsUp];
    }
}

//  button消失效果
- (void)buttonsUp {
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _button1.center = CGPointMake(_button1.center.x, KScreenHeight / 2);
    } completion:nil];
    [UIView animateWithDuration:0.6 delay:0.05 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _button2.center = CGPointMake(_button2.center.x, KScreenHeight / 2);
    } completion:nil];
}

//  button消失效果
- (void)buttonsDown {
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionLayoutSubviews animations:^{
        _button1.center = CGPointMake(_button1.center.x, KScreenHeight + 50);
        _button2.center = CGPointMake(_button2.center.x, KScreenHeight + 50);
    } completion:nil];
}

#pragma mark --- 开始搜索 点击搜索框时调用 ---
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.searchBar.showsCancelButton = YES;
    // 点击出现历史搜索
    [UITableView animateWithDuration:0.1 animations:^{
        self.tableView.frame=CGRectMake(0, KSearchHeight + KNavBarHeight, KScreenWidth, KScreenHeight-KNavBarHeight-KSearchHeight);
    } completion:nil];
    
    [self buttonsDown];
}

#pragma mark --- 点击取消按钮时调用 ---
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    // 隐藏tableView
    [UITableView animateWithDuration:0.1 animations:^{
        self.tableView.frame=CGRectMake(0, KSearchHeight + KNavBarHeight, KScreenWidth, 0);
    } completion:nil];
    [self buttonsUp];
    self.searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

#pragma mark --- 点击搜索按钮时调用 ---
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
    //添加本地数据 title
    //避免重复搜索
    BOOL isHave = NO;
    NSMutableArray *array=[[CoreDataManager shareInstance]selectAllTitleModel].mutableCopy;
    for(Search *search in array)
    {
        if([self.searchBar.text isEqualToString:search.title])
        {
            isHave=YES;
        }
    }
    //如果没有就添加
    if(isHave == NO && searchBar.text != nil && searchBar.text.length > 0)
    {
        [[CoreDataManager shareInstance]addNewTitleWithSearch:self.searchBar.text];
    }
    self.modelArray = [[CoreDataManager shareInstance]selectAllTitleModel].mutableCopy;
    DetailListController *detail=[[DetailListController alloc]init];
    detail.search=self.searchBar.text;
    
    detail.isPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
    [self.tableView reloadData];
}

@end
