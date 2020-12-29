//
//  ChatTableViewController.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/20.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "ChatTableViewController.h"
#import "FriendsViewController.h"
#import "TRChattingViewController.h"

@interface ChatTableViewController ()
@property (nonatomic, strong) NSMutableArray *userNameArray;
@property (nonatomic, strong) NSMutableArray *nickArray;
@property (nonatomic, strong) NSMutableArray *headPathArray;
@property (nonatomic, strong) NSMutableArray *bmobObjects;

@end

@implementation ChatTableViewController
#pragma mark - 生命周期 Life Cilcle

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    [leftButton setImage:[UIImage imageNamed:@"message_chat_icon_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"message_chat_icon_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(friend) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 20, 20);
    [rightButton setImage:[UIImage imageNamed:@"mini_paly_btn_normal"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"mini_play_btn_press"] forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.title = @"聊天";
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.userNameArray = [NSMutableArray array];
    self.nickArray = [NSMutableArray array];
    self.headPathArray = [NSMutableArray array];
    self.bmobObjects = [NSMutableArray array];
    //获取好友列表
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        if (!error) {
//            NSLog(@"获取成功 -------------- %@",buddyList);
            for (EMBuddy *buddy in buddyList) {
                [self getBmobUser:buddy.username];
            }
//            NSLog(@"%ld",self.userNameArray.count);
        }else{
            NSLog(@"%@",error);
        }
    } onQueue:nil];
    self.tabBarController.tabBar.hidden = NO;
}
- (void)getBmobUser:(NSString *)username{
    BmobQuery *bquery = [BmobUser query]; //用户表
    [bquery whereKey:@"username" equalTo:username];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            //打印playerName
//            NSLog(@"username = %@", [obj objectForKey:@"username"]);
//            NSLog(@"nick = %@", [obj objectForKey:@"nick"]);
//            NSLog(@"headpath = %@", [obj objectForKey:@"headPath"]);
            [self.bmobObjects addObject:obj];
            [self.userNameArray addObject:[obj objectForKey:@"username"]];
            [self.nickArray addObject:[obj objectForKey:@"nick"]];
            [self.headPathArray addObject:[obj objectForKey:@"headPath"]];
        }
        [self.tableView reloadData];
    }];

}
- (void)friend{
    FriendsViewController *friendsVC = [[FriendsViewController alloc] init];
    [self.navigationController pushViewController:friendsVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    NSString *username = self.userNameArray[indexPath.row];
    NSString *nick = self.nickArray[indexPath.row];
    NSString *headPath = self.headPathArray[indexPath.row];
    cell.textLabel.text = username;
    cell.detailTextLabel.text = nick;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"cat"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TRChattingViewController *chatVC = [[TRChattingViewController alloc] init];
    chatVC.toUsername = self.userNameArray[indexPath.row];
    chatVC.toUser = self.bmobObjects[indexPath.row];
    [self.navigationController pushViewController:chatVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
