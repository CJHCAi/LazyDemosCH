//
//  FriendsListTVC.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/19.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "FriendsListTVC.h"
#import "XMPPManager.h"
#import "ChatVC.h"
#import "FirendListCell.h"

@interface FriendsListTVC () <XMPPRosterDelegate>
@property (nonatomic, retain) NSMutableArray *array;
@end

@implementation FriendsListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initN];
    
//    //  初始化数组
//    self.array = [NSMutableArray array];
//    //  获取好友列表
//    XMPPManager *xmpp = [XMPPManager shareXmppManager];
//    //  添加代理
//    [xmpp.roster addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.tableView.rowHeight = 70;
}

- (void)initN{
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.945 green:0.263 blue:0.255 alpha:1.000]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
}

//  准备获取好友列表
-(void)xmppRosterDidBeginPopulating:(XMPPRoster *)sender {
    //  清空数组
    [self.array removeAllObjects];
}

//  获取好友列表
-(void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(DDXMLElement *)item {
    //  每个好友都是JID类,需要将item进行转换
    NSString *jidStr = [[item attributeForName:@"jid"]stringValue];
    XMPPJID *jid = [XMPPJID jidWithString:jidStr];
    [self.array addObject:jid];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

//  获取列表完毕
-(void)xmppRosterDidEndPopulating:(XMPPRoster *)sender {
    //  刷新data
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friend" forIndexPath:indexPath];
//    XMPPJID *jid = self.array[indexPath.row];
//    cell.textLabel.text = jid.user;
    
    FirendListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell" forIndexPath:indexPath];
    XMPPJID *jid = self.array[indexPath.row];
    cell.nameLable.text = jid.user;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    MessagesTVC *message = [storyboard instantiateViewControllerWithIdentifier:@"Message"];
//    //  传递jid
//    message.jid = self.array[indexPath.row];
//    [self.navigationController pushViewController:message animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ChatVC *message = [storyboard instantiateViewControllerWithIdentifier:@"chatVC"];
    //  传递jid
    message.jid = self.array[indexPath.row];
    [self.navigationController pushViewController:message animated:YES];
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
