//
//  SXTSearchViewController.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/24.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTSearchViewController.h"
#import <MJExtension.h>
#import "SXTGoodsListModel.h"
#import "SXTGoodsListViewController.h"
@interface SXTSearchViewController()<UISearchBarDelegate>

@property (strong, nonatomic)   UISearchBar *search;/**搜索框*/

@end

@implementation SXTSearchViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self backItem];
    self.navigationItem.titleView = self.search;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_search becomeFirstResponder];
}

- (void)backItem{
    UIButton *back = [UIButton buttonWithType:(UIButtonTypeCustom)];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (UISearchBar *)search{
    if (!_search) {
        _search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, VIEW_WIDTH-40, 25)];
        _search.placeholder = @"商品名／功效／品牌";
        [_search becomeFirstResponder];
        _search.showsCancelButton = YES;
        _search.returnKeyType = UIReturnKeySearch;
        _search.delegate = self;
    }
    return _search;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self postData:@"appSearch/searchList.do" param:@{@"search":searchBar.text,@"OrderName":@"host",@"OrderType":@"ASC"} success:^(id responseObject) {
        SXTLog(@"responseObject:%@",responseObject);
        
        NSArray *listArray = [SXTGoodsListModel mj_objectArrayWithKeyValuesArray:responseObject];
        SXTGoodsListViewController *goodsList = [[SXTGoodsListViewController alloc]init];
        goodsList.searchList = listArray;
        goodsList.title = searchBar.text;
        //解决页面跳转时闪烁问题，如果键盘存在的话，页面跳转的动画会出现两次的push，但nav的子视图中并没有出现多余的viewcontroller
        [searchBar resignFirstResponder];
        [self.navigationController pushViewController:goodsList animated:YES];
    } error:^(NSError *error) {
        
    }];
}



@end







