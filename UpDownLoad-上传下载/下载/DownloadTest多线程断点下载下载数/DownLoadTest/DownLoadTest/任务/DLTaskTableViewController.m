//
//  DLTaskTableViewController.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/23.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLTaskTableViewController.h"
#import "DLDownloadUrlModel.h"
#import "DLTaskTableViewCell.h"
#import "DLDownloadViewController.h"
#import "DLCurrentDownloadViewController.h"
#import "AppDelegate.h"
#import "DLDownloadMagager.h"
#import "DLSharedToastManager.h"

NSString *const DLDeleteDownloadTaskNotification = @"kDLDeleteDownloadTaskNotification";

@interface DLTaskTableViewController ()

@property (nonatomic,strong) NSMutableArray *urlArray;

@end

@implementation DLTaskTableViewController

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerNotifications];
    self.navigationItem.title = @"任务";
    self.urlArray = [[NSMutableArray alloc] init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"urlConfig" ofType:@"plist"];
    NSArray *taskUrls = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary *dic in taskUrls) {
        DLDownloadUrlModel *urlModel = [[DLDownloadUrlModel alloc] initWithDictionary:dic error:nil];
        [self.urlArray addObject:urlModel];
    }
    //[self.tableView reloadData];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    return self.urlArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DLDownloadUrlModel *urlModel = [self.urlArray objectAtIndex:indexPath.row];
    static NSString *cellIdentifier = @"DLTaskTableViewCell";
    DLTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DLTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.startDownloadBlock = ^{
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if (![delegate.reachability isReachable] || ([delegate.reachability isReachableViaWWAN] && ![DLDownloadMagager sharedManager].isWWANDownload)) {
            [[DLSharedToastManager sharedManager] showToast:@"不允许下载" controller:self];
            return;
        }
        NSInteger index = [self.urlArray indexOfObject:urlModel];
        [self.urlArray removeObject:urlModel];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [[NSNotificationCenter defaultCenter] postNotificationName:DLAddDownloadTaskNotification object:urlModel];
    };
    [cell configUIWithModel:urlModel];
    
    return cell;
}

#pragma mark - Private
- (void)registerNotifications
{
    [self removeNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteTask:)
                                                 name:DLDeleteDownloadTaskNotification
                                               object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotificationActions
- (void)deleteTask:(NSNotification *)notification {
    DLDownloadUrlModel *urlModel = [notification object];
    [self.urlArray addObject:urlModel];
    NSInteger arrayIndex = [self.urlArray indexOfObject:urlModel];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:arrayIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
@end
