//
//  LYMessageListViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/10.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRChattingViewController.h"
#import "LYMessageListViewController.h"
#import "LYUserCell.h"
#import "EaseMob.h"
#import <BmobSDK/Bmob.h>

@interface LYMessageListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *conversations;
@end

@implementation LYMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tableView= [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
 
    
    [tableView registerNib:[UINib nibWithNibName:@"LYUserCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //从本地获取聊天记录
    self.conversations = [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
  
    
    return self.conversations.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LYUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
  
    
    cell.conversation =  self.conversations[indexPath.row];
        
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EMConversation *c = self.conversations[indexPath.row];
    //全部已读
    [c markAllMessagesAsRead:YES];
    
    
    
    //查询对方用户的详情
    BmobQuery *query = [BmobQuery queryForUser];
    
    [query whereKey:@"username" equalTo:c.chatter];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count>0) {
            BmobUser *toUser = [array firstObject];
            
            TRChattingViewController *vc = [TRChattingViewController new];
            vc.toUser = toUser;
            vc.toUsername = toUser.username;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];

    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        EMConversation *c = self.conversations[indexPath.row];
        
        //删除
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:c.chatter deleteMessages:YES append2Chat:YES];
       
        //界面
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        
    }
    
    
    
}


@end
