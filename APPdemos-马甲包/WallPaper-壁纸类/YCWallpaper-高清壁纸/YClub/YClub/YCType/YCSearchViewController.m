//
//  YCSearchViewController.m
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/8.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import "YCSearchViewController.h"
#import "YCSearchTableViewCell.h"
#import "YCNewViewController.h"

@interface YCSearchViewController ()<UITableViewDelegate, UITableViewDataSource, YCSearchTableViewCellDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *hotKeys;
@end

@implementation YCSearchViewController

- (UITableView *)myTable
{
    if (!_myTable) {
        
        _myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _myTable.delegate = self;
        _myTable.dataSource = self;
        [_myTable registerClass:[YCSearchTableViewCell  class] forCellReuseIdentifier:@"cellID"];
        _myTable.tableFooterView = [[UIView alloc] init];
        if ([_myTable respondsToSelector:@selector(setSeparatorInset:)]) {
            [_myTable setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_myTable respondsToSelector:@selector(setLayoutMargins:)]) {
            [_myTable setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _myTable;
}
- (NSMutableArray *)hotKeys
{
    if (!_hotKeys) {
        _hotKeys = [[NSMutableArray alloc] init];
    }
    return _hotKeys;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackNavItem];
    [self setRightCanleBackItem];
    [self setUpTitleView];
    [self requestData];
    [self setUpTableView];
}
#pragma mark - setLeftBackNavItem
- (void)setLeftBackNavItem
{
    self.navigationItem.hidesBackButton = YES;
}
#pragma mark - rightCanleNavItem
- (void)setRightCanleBackItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 44);
    btn.titleLabel.font = YC_Nav_TitleFont;
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:YC_Base_TitleColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightCanleBackAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
#pragma mark - rightCanleBackAction
- (void)rightCanleBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - setUpTitleView
- (void)setUpTitleView
{
    UITextField *titleView = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH-60, 30)];
    titleView.delegate = self;
    titleView.layer.cornerRadius = 5;
    titleView.layer.masksToBounds = YES;
    titleView.font = YC_Base_TitleFont;
    titleView.placeholder = @"输入关键字";
    titleView.textColor = YC_Base_TitleColor;
    titleView.backgroundColor = YC_Base_BgGrayColor;
    titleView.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIImageView *searchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yc_nav_search"]];
    titleView.leftViewMode = UITextFieldViewModeAlways;
    titleView.leftView = searchView;
    self.navigationItem.titleView = titleView;
}
#pragma mark - setUpTableView
- (void)setUpTableView
{
    [self.view addSubview:self.myTable];
}
#pragma mark - requestData
- (void)requestData
{
    [YCNetManager getHotSearchKeyWordsWithCallBack:^(NSError *error, NSArray *pics) {
        if (!kArrayIsEmpty(pics)) {
            [self.hotKeys removeAllObjects];
            [self.hotKeys addObjectsFromArray:pics];
            [self.myTable reloadData];
        }
    }];
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_hotKeys.count > 0) {
        return 1;
    } else {
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [YCSearchTableViewCell calculateCellHeightWithTitles:_hotKeys];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YCSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    cell.delegate = self;
    [cell configHotTitle:_hotKeys];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - TextFeild Delegate Action
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self doSearch:textField.text];
    return YES;
}
#pragma mark - RDOBookStoreSearchCellDelegate
- (void)doSearchWithHotKey:(NSString *)hotKey
{
    [self doSearch:hotKey];
}
#pragma mark - doSearch
- (void)doSearch:(NSString *)key
{
    if (kStringIsEmpty(key)) {
        return;
    }
    YCNewViewController *searchListVC = [[YCNewViewController alloc] init];
    searchListVC.navTitle = key;
    searchListVC.searchKey = key;
    [self.navigationController pushViewController:searchListVC animated:YES];
}
#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication].keyWindow endEditing:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
