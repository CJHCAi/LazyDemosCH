//
//  DLFinishDownloadTableViewController.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/24.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLFinishDownloadTableViewController.h"
#import "DLFinshTableViewCell.h"
#import "DLDownloadUrlModel.h"
#import "NSString+Hash.h"
#import "DLTaskTableViewController.h"

NSString *const DLFinishDownloadTaskNotification = @"kDLFinishDownloadTaskNotification";

@interface DLFinishDownloadTableViewController ()<SWTableViewCellDelegate>

@property (nonatomic ,strong) NSMutableArray *finishArray;

@end

@implementation DLFinishDownloadTableViewController

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotifications];
    self.finishArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.finishArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DLFinshTableViewCell";
    DLFinshTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DLFinshTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        cell.rightUtilityButtons = [self rightButtons];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *downloadName = ((DLDownloadUrlModel *)[self.finishArray objectAtIndex:indexPath.row]).name;
    [cell configViewWithDownloadName:downloadName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

#pragma mark - Private
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

- (void)registerNotifications
{
    [self removeNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(DLFinishDownloadTask:)
                                                 name:DLFinishDownloadTaskNotification
                                               object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            DLDownloadUrlModel *urlModel = [self.finishArray objectAtIndex:cellIndexPath.row];
            NSString *fileNameByMD5 = [urlModel.url md5String];
            NSString *destinationPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"] stringByAppendingPathComponent:fileNameByMD5];
           // NSURL *fileURL = [NSURL fileURLWithPath:destinationPath];
            [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];
            [self.finishArray removeObjectAtIndex:cellIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [[NSNotificationCenter defaultCenter] postNotificationName:DLDeleteDownloadTaskNotification object:urlModel];
            break;
        }
        default:
            break;
    }
}

#pragma mark - NSNotificationActions
- (void)DLFinishDownloadTask:(NSNotification *)notification {
    DLDownloadUrlModel *urlModel = [[DLDownloadUrlModel alloc] init];
    urlModel= [notification object];
    [self.finishArray addObject:urlModel];
    NSInteger arrayIndex = [self.finishArray indexOfObject:urlModel];
    //dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:arrayIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    //});
}
@end
