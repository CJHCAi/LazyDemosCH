//
//  TestViewController.m
//  TMSwipeCell
//
//  Created by cocomanber on 2018/7/3.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TestViewController.h"
#import "TestTableViewCell.h"
#import "TMExpandViewController.h"

@interface TestViewController ()
<TMSwipeCellDelegate>

@property (nonatomic, strong)NSMutableArray *datas;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _datas = [NSMutableArray arrayWithArray:[TestModel getAllDatas]];
    [self.tableView reloadData];
}

/**
 选中了侧滑按钮
 
 @param swipeCell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @param index 选中的是第几个action
 */
- (void)swipeCell:(TMSwipeCell *)swipeCell atIndexPath:(NSIndexPath *)indexPath didSelectedAtIndex:(NSInteger)index
{
    
}

/**
 告知当前位置的cell是否需要侧滑按钮
 
 @param swipeCell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @return YES 表示当前cell可以侧滑, NO 不可以
 */
- (BOOL)swipeCell:(TMSwipeCell *)swipeCell canSwipeRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2 == 0) {
        return YES;
    }
    return NO;
}

/**
 返回侧滑事件
 
 @param swipeCell 当前响应的cell
 @param indexPath cell在tableView中的位置
 @return 数组为空, 则没有侧滑事件
 */
- (nullable NSArray<TMSwipeCellAction *> *)swipeCell:(TMSwipeCell *)swipeCell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestModel *model = [_datas objectAtIndex:indexPath.row];
    __weak __typeof(&*self)weakSelf = self;
    if ([model.message_id isEqualToString:TMSWIPE_FRIEND]) {
        
        TMSwipeCellAction *action3 = [TMSwipeCellAction rowActionWithStyle:TMSwipeCellActionStyleNormal title:@"备注" handler:^(TMSwipeCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"备注");
        }];
        TMSwipeCellAction *action2 = [TMSwipeCellAction rowActionWithStyle:TMSwipeCellActionStyleDestructive title:@"删除" handler:^(TMSwipeCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"删除");
            [weakSelf.datas removeObject:model];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }];
        return @[action3, action2];
        
    }else if ([model.message_id isEqualToString:TMSWIPE_OTHERS]){
        
        TMSwipeCellAction *tagAction = [TMSwipeCellAction rowActionWithStyle:TMSwipeCellActionStyleNormal title:nil handler:^(TMSwipeCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"点击的打标签按钮");
        }];
        tagAction.backgroundColor = [UIColor lightGrayColor];
        tagAction.image = [UIImage imageNamed:@"Tag"];
        
        TMSwipeCellAction *deleteAction = [TMSwipeCellAction rowActionWithStyle:TMSwipeCellActionStyleNormal title:nil handler:^(TMSwipeCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"点击的删除按钮");
            [weakSelf.datas removeObject:model];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }];
        deleteAction.backgroundColor = [UIColor lightGrayColor];
        deleteAction.image = [UIImage imageNamed:@"Delete"];
        return @[tagAction, deleteAction];
        
    }else if ([model.message_id isEqualToString:TMSWIPE_PUBLIC]){
        
        TMSwipeCellAction *action1 = [TMSwipeCellAction rowActionWithStyle:TMSwipeCellActionStyleNormal title:@"取消关注" handler:^(TMSwipeCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"取消关注");
        }];
        TMSwipeCellAction *action2 = [TMSwipeCellAction rowActionWithStyle:TMSwipeCellActionStyleDestructive title:@"删除" handler:^(TMSwipeCellAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            NSLog(@"删除");
            [weakSelf.datas removeObject:model];
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }];
        return @[action1, action2];
        
    }else{
        return @[];
    }
}

#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [TestTableViewCell rowHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TestModel *model = [_datas objectAtIndex:indexPath.row];
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestTableViewCell"];
    cell.imageV.image = [UIImage imageNamed:model.headUrl];
    cell.nameL.text = model.name;
    cell.contentL.text = model.content;
    cell.timeL.text = model.time;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TMExpandViewController *vc = [TMExpandViewController new];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
