//
//  DLCurrentDownloadViewController.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/24.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLCurrentDownloadViewController.h"
#import "DLCurrentTableViewCell.h"
#import "DLDownloadUrlModel.h"
#import "DLDownloadModel.h"
#import "DLDownloadMagager.h"
#import "DLURLSessionOperation.h"
#import "DLSharedToastManager.h"
#import "Masonry.h"
#import "DLDownloadButton.h"
#import "DLSharedToastManager.h"
#import "DLFinishDownloadTableViewController.h"
#import "AppDelegate.h"

NSString *const DLAddDownloadTaskNotification = @"kDLAddDownloadTaskNotification";
NSString *const DLSuspendTaskNotification = @"kDLSuspendTaskNotification";
NSString *const DLSuspendAndRestartTaskNotification = @"kDLSuspendAndRestartTaskNotification";
NSString *const DLAutoStartTaskNotification = @"DLAutoStartTaskNotification";

@interface DLCurrentDownloadViewController ()<YDLDownloadMagagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray *downloadModelArray;
@property (nonatomic ,strong) UITableView *downloadTabelView;
@property (nonatomic ,strong) DLDownloadButton *allSelectedButton;

@end

@implementation DLCurrentDownloadViewController

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self registerNotifications];
    self.downloadModelArray = [[NSMutableArray alloc] init];
    
    self.downloadTabelView = [[UITableView alloc] init];
    self.downloadTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.downloadTabelView.delegate = self;
    self.downloadTabelView.dataSource = self;
    [self.view addSubview:self.downloadTabelView];
    self.allSelectedButton = [[DLDownloadButton alloc] init];
    self.allSelectedButton.isAllSelected = NO;
    [self.allSelectedButton setTitle:@"全部暂停" forState:UIControlStateNormal];
    [self.allSelectedButton setTitleColor:[UIColor colorWithRed:135/255.0 green:206/255.0 blue:235/255.0 alpha:1] forState:UIControlStateNormal];
    [self.allSelectedButton addTarget:self action:@selector(downloadButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.allSelectedButton];
    
    [self.allSelectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view.mas_leading);
        make.trailing.equalTo(self.view.mas_trailing);
        make.height.equalTo(@30);
        make.bottom.equalTo(self.view.mas_bottom).offset(-48);
    }];
    [self.downloadTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.bottom.equalTo(self.allSelectedButton.mas_top);
    }];
    
    [DLDownloadMagager sharedManager].delegate = self;
    
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
    return self.downloadModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DLCurrentTableViewCell";
    DLCurrentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DLCurrentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.failDowloadBlock = ^(NSString *string){
        [[DLSharedToastManager sharedManager] showToast:string controller:self];
    };
    DLDownloadModel *downloadModel = [self.downloadModelArray objectAtIndex:indexPath.row];
    [cell configUIWithDownloadModel:downloadModel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72;
}

#pragma mark - Private
- (void)registerNotifications
{
    [self removeNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addDownloadTask:)
                                                 name:DLAddDownloadTaskNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autoSuspendTask)
                                                 name:DLSuspendTaskNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(suspendAndRestartTask)
                                                 name:DLSuspendAndRestartTaskNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autoStartTask)
                                                 name:DLAutoStartTaskNotification
                                               object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)autoStartTask {
    NSUserDefaults * defaults =  [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"suspendStatus"]) {
        NSMutableArray *statusArray = [defaults objectForKey:@"suspendStatus"];
        [defaults removeObjectForKey:@"suspendStatus"];
        for (NSMutableDictionary *dic in statusArray) {
            if (!(((NSNumber *)[dic objectForKey:@"isResume"]).boolValue || ((NSNumber *)[dic objectForKey:@"isSuspend"]).boolValue)) {
                for (DLDownloadModel *model in self.downloadModelArray) {
                    if ([model.urlModel.url isEqualToString:[dic objectForKey:@"url"]]) {
                        NSInteger index = [self.downloadModelArray indexOfObject:model];
                        model.statusTask = DLButtonStatusStart;
                        DLCurrentTableViewCell *cell = [self.downloadTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                        //[cell configUIWithButtonStatus:1 statusTask:1];
                        //[cell startTask];
                        double delayInSeconds = 0.1 * index;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [cell startTask];
                            [cell configUIWithButtonStatus:DLButtonStatusStart statusTask:DLButtonStatusStart];
                        });
                        break;
                    }
                }
            }
        }
    } else {
        //dic = [DLDownloadMagager sharedManager].operationDictionary;
        [self autoSuspendTask];
    }
}

- (void)allStartTask {
    for (DLURLSessionOperation *operation in [[DLDownloadMagager sharedManager].operationDictionary allValues] ) {
        if (!(operation.isResume && operation.isSuspend)) {
            for (DLDownloadModel *model in self.downloadModelArray) {
                if ([model.urlModel.url isEqualToString:operation.urlString]) {
                    NSInteger index = [self.downloadModelArray indexOfObject:model];
                    model.statusTask = DLButtonStatusStart;
                    DLCurrentTableViewCell *cell = [self.downloadTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                    double delayInSeconds = 0.01 * index;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [cell startTask];
                        [cell configUIWithButtonStatus:DLButtonStatusStart statusTask:DLButtonStatusStart];
                    });
                    break;
                }
            }
        }
    }
}

#pragma mark - Actions
- (void)downloadButtonClicked:(DLDownloadButton *)sender {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (![delegate.reachability isReachable] || ([delegate.reachability isReachableViaWWAN] && ![DLDownloadMagager sharedManager].isWWANDownload)) {
        [[DLSharedToastManager sharedManager] showToast:@"不允许下载" controller:self];
        return;
    }
    if (sender.isAllSelected) {
        [self.allSelectedButton setTitle:@"全部暂停" forState:UIControlStateNormal];
        sender.isAllSelected = NO;
        [self allStartTask];
    } else {
        [self.allSelectedButton setTitle:@"全部开始" forState:UIControlStateNormal];
        sender.isAllSelected = YES;
        [self autoSuspendTask];
    }
}

#pragma mark - YDLDownloadMagagerDelegate
- (void)didReceiveDataWithSpeed:(NSString *)speed progress:(float)progress taskUrlString:(NSString *)taskUrlString{
    for (DLDownloadModel *model in self.downloadModelArray) {
        if ([model.urlModel.url isEqualToString:taskUrlString]) {
            NSInteger index = [self.downloadModelArray indexOfObject:model];
            model.progress = progress;
            model.speed = speed;
            dispatch_async(dispatch_get_main_queue(), ^{
                DLCurrentTableViewCell *cell = [self.downloadTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                [cell configUIWithDownloadModel:model];
            });
            break;
        }
    }
}

- (void)didFinishDownloadTaskWithOperation:(NSString *)taskUrlString {
    for (DLDownloadModel *model in self.downloadModelArray) {
        if ([model.urlModel.url isEqualToString:taskUrlString]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSInteger index = [self.downloadModelArray indexOfObject:model];
                [self.downloadModelArray removeObject:model];
                //dispatch_async(dispatch_get_main_queue(), ^{
                    [self.downloadTabelView beginUpdates];
                    [self.downloadTabelView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                    [self.downloadTabelView endUpdates];
               // });
                [[NSNotificationCenter defaultCenter] postNotificationName:DLFinishDownloadTaskNotification object:model.urlModel];
            });
            break;
        }
    }
}

- (void)downloadError:(NSString *)taskUrlString error:(NSError *)error
{
    for (DLDownloadModel *model in self.downloadModelArray) {
        if ([model.urlModel.url isEqualToString:taskUrlString]) {
            NSInteger index = [self.downloadModelArray indexOfObject:model];
            model.statusTask = DLButtonStatusFail;
            dispatch_async(dispatch_get_main_queue(), ^{
                DLCurrentTableViewCell *cell = [self.downloadTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                double delayInSeconds = 0.1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [cell configUIWithButtonStatus:DLButtonStatusFail statusTask:DLButtonStatusFail];
                    //[cell taskFail];
                });
            });
            break;
        }
    }
}

#pragma mark - NSNotificationActions
- (void)addDownloadTask:(NSNotification *)notification {
    DLDownloadUrlModel *urlModel = [notification object];
    DLDownloadModel *downloadModel = [[DLDownloadModel alloc] init];
    downloadModel.urlModel = urlModel;
    downloadModel.statusTask = DLButtonStatusStart;
    downloadModel.buttonStatus = DLButtonStatusStart;
    [self.downloadModelArray addObject:downloadModel];
    NSInteger arrayIndex = [self.downloadModelArray indexOfObject:downloadModel];
    //添加任务
    DLURLSessionOperation *operation = [[DLURLSessionOperation alloc] initWithSession:[DLDownloadMagager sharedManager].session URLString:downloadModel.urlModel.url];
    //operation.startOperationDate = [NSDate date];
    [[DLDownloadMagager sharedManager].queue addOperation:operation];
    [[DLDownloadMagager sharedManager].operationDictionary setObject:operation forKey:downloadModel.urlModel.url];
    
    [self.downloadTabelView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:arrayIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)autoSuspendTask {
    for (DLURLSessionOperation *operation in [[DLDownloadMagager sharedManager].operationDictionary allValues] ) {
        if (!(operation.isResume || operation.isSuspend)) {
            for (DLDownloadModel *model in self.downloadModelArray) {
                if ([model.urlModel.url isEqualToString:operation.urlString]) {
                    NSInteger index = [self.downloadModelArray indexOfObject:model];
                    model.statusTask = DLButtonStatusSuspend;
                    model.buttonStatus = DLButtonStatusSuspend;
                    DLCurrentTableViewCell *cell = [self.downloadTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                    //[cell autoSuspendTask];
                    double delayInSeconds = 0.001 * index;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [cell autoSuspendTask];
                        [cell configUIWithButtonStatus:DLButtonStatusSuspend statusTask:DLButtonStatusSuspend];
                    });
                    break;
                }
            }
        }
    }
}

- (void)suspendAndRestartTask {
    NSInteger count = 0;
    for (DLURLSessionOperation *operation in [DLDownloadMagager sharedManager].queue.operations) {
        if (!(operation.isResume || operation.isSuspend)) {
            for (DLDownloadModel *model in self.downloadModelArray) {
                if ([model.urlModel.url isEqualToString:operation.urlString]) {
                    count ++;
                    NSInteger index = [self.downloadModelArray indexOfObject:model];
                    model.statusTask = DLButtonStatusStart;
                    DLCurrentTableViewCell *cell = [self.downloadTabelView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                    double delayInSeconds = 0.0005 * count;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [cell autoSuspendTask];
                        double delayInSeconds2 =  1;
                        dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds2 * NSEC_PER_SEC));
                        dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
                            [cell startTask];
                            [cell configUIWithButtonStatus:DLButtonStatusStart statusTask:DLButtonStatusStart];
                        });
                    });
                }
            }
        }
    };
}
@end
