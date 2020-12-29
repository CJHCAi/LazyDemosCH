//
//  FriendsViewController.m
//  ITSNS
//
//  Created by V.Valentino on 16/8/23.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "FriendsViewController.h"
#import <BmobSDK/Bmob.h>
#import "RequetsTableViewController.h"
#import "LYUserCell.h"
#import "EasemobManager.h"
#import "TRChattingViewController.h"


@interface FriendsViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchResultsUpdating>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *friends;
@property (nonatomic, strong)UISearchController *searchController;
@property (nonatomic, strong)NSArray *results;

@end

@implementation FriendsViewController
#pragma mark - 生命周期 Life Cilcle

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    //    搜索栏相关
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //    是否隐藏原来的tableView的内容  因为结果就是显示到当前页面 所以不能隐藏
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //设置结果过滤器
    self.searchController.searchResultsUpdater = self;
    //把搜索栏添加到表头
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [tableView registerNib:[UINib nibWithNibName:@"LYUserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    //添加好友状态改变的监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(statusChange) name:@"好友状态改变" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadFriends];
}
-(void)statusChange{
    [self loadFriends];
}
#pragma mark - 方法 Methods
//重新加载好友
-(void)loadFriends{
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
            [self.tableView reloadData];
            NSLog(@"获取成功 -- %@",buddyList);
            NSMutableArray *usernames = [NSMutableArray array];
            for (EMBuddy *buddy in buddyList) {
                NSString *username = buddy.username;
                
                [usernames addObject:username];
            }
            //通过用户名的数组去查询 BmobUser对象
            BmobQuery *query = [BmobQuery queryForUser];
            //查询多个好友 条件为数组里面的用户名
            [query whereKey:@"username" containedIn:usernames];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                self.friends = [array mutableCopy];
                [self.tableView reloadData];
            }];
        }
    } onQueue:nil];
}
#pragma mark UISearchController Delegate
//搜索结果协议方法
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *text = searchController.searchBar.text;
    BmobQuery *query = [BmobQuery queryForUser];
    //模糊查找
    [query whereKey:@"nick" matchesWithRegex:text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        self.results = array;
        [self.tableView reloadData];
    }];
}
#pragma mark UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.searchController.isActive) {
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.isActive) {
        return self.results.count;
    }
    if (section==0) {
        return 1;
    }
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LYUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.searchController.isActive) {
        BmobUser *user = self.results[indexPath.row];
        cell.user = user;
    }else{//显示自己的好友
        if (indexPath.section == 0) {
            cell.nameLabel.text = @"好友请求";
            cell.headIV.image = [UIImage imageNamed:@"icon"];
            cell.detailLabel.text = [NSString stringWithFormat:@"%ld",[EasemobManager shareManager].requets.count];
        }else{
            cell.user = self.friends[indexPath.row];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchController.isActive) {
        [self dismissViewControllerAnimated:NO completion:nil];
        BmobUser *user = self.results[indexPath.row];
//        TRChattingViewController *vc = [TRChattingViewController new];
//        vc.toUsername = user.username;
//        vc.toUser = user;
        
        NSString *m = [NSString stringWithFormat:@"是否添加%@为好友？",[user objectForKey:@"nick"]];
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:m preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[EasemobManager shareManager]addFriendWithName:user.username];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:action1];
        [ac addAction:action2];
        [self presentViewController:ac animated:YES completion:nil];
    }else{
        if (indexPath.section == 0) {
            RequetsTableViewController *vc = [RequetsTableViewController new];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            BmobUser *user = self.friends[indexPath.row];
//            TRChattingViewController *vc = [TRChattingViewController new];
//            vc.toUsername = user.username;
//            vc.toUser = user;
            NSString *m = [NSString stringWithFormat:@"是否添加%@为好友？",[user objectForKey:@"nick"]];
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:m preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[EasemobManager shareManager]addFriendWithName:user.username];
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [ac addAction:action1];
            [ac addAction:action2];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
