//
//  ViewController.m
//  tableViewDelete
//
//  Created by zhou on 16/5/8.
//  Copyright © 2016年 zhou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *deleteData;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.deleteData = [[NSMutableArray alloc]initWithObjects:@[@"王菲",@"周迅",@"李冰冰",@"白冰",@"紫薇",@"马苏",@"刘诗诗",@"赵薇",@"angelbaby",@"熊黛林"], nil];
    NSArray *arr = @[@"王菲",@"周迅",@"李冰冰",@"白冰",@"紫薇",@"马苏",@"刘诗诗",@"赵薇",@"angelbaby",@"熊黛林"];
    for (int i = 0; i < arr.count; i++) {
        [self.deleteData addObject:arr[i]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deleteData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellid = @"deleteId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = self.deleteData[indexPath.row];
    return cell;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.deleteData removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self.deleteData exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
        
        
        
    }];
    
    topRowAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *moreRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"更多" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        
    }];
//    moreRowAction.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    return @[deleteRowAction,topRowAction,moreRowAction];
}
- (NSMutableArray *)deleteData
{
    if (_deleteData == nil) {
        _deleteData = [NSMutableArray array];
    }
    return _deleteData;
}
@end
