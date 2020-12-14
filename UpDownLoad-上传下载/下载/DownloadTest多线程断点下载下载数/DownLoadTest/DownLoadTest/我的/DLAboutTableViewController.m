//
//  DLAboutTableViewController.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/25.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLAboutTableViewController.h"
#import "DLLimitMaxTaskTableViewCell.h"
#import "DLSharedToastManager.h"
#import "IQKeyboardManager.h"
#import "DLSwitchTableViewCell.h"
#import "DLDownloadMagager.h"
#import "DLCurrentDownloadViewController.h"

@interface DLAboutTableViewController ()

@end

@implementation DLAboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"DLLimitMaxTaskTableViewCell";
        DLLimitMaxTaskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[DLLimitMaxTaskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.limitTextField.linkNumberBlock = ^(NSUInteger number ,BOOL bToast){
            NSLog(@"%@",@(number));
            if (number >= [DLDownloadMagager sharedManager].queue.maxConcurrentOperationCount) {
                [[DLDownloadMagager sharedManager].queue setSuspended:YES];
                [DLDownloadMagager sharedManager].queue.maxConcurrentOperationCount = number;
                [[DLDownloadMagager sharedManager].queue setSuspended:NO];
            } else {
                [DLDownloadMagager sharedManager].queue.maxConcurrentOperationCount = number;
                [[NSNotificationCenter defaultCenter] postNotificationName:DLSuspendAndRestartTaskNotification object:nil];
            }
            if (bToast) {
                [[DLSharedToastManager sharedManager] showToast:[NSString stringWithFormat:@"请输入正确的数值%@",@(number)] controller:self];
            }
        };
        return cell;
    } else if (indexPath.row == 1) {
        static NSString *cellIdentifier = @"DLSwitchTableViewCell";
        DLSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[DLSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
}
@end
