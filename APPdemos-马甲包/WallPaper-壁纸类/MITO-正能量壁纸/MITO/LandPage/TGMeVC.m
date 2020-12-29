//
//  TGMeVC.m
//  baisibudejie
//
//  Created by targetcloud on 2017/3/5.
//  Copyright © 2017年 targetcloud. All rights reserved.
//

#import "TGMeVC.h"
#import <SDImageCache.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "TGFileTool.h"

static NSString * const ID = @"cell";
@interface TGMeVC ()
@property (nonatomic, assign) NSInteger totalSize;
@end

@implementation TGMeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    [SVProgressHUD showWithStatus:@"正在计算缓存大小..."];
    [TGFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        _totalSize = totalSize;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.textLabel.text = [self sizeStr];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [TGFileTool removeDirectoryPath:CachePath];
    _totalSize = 0;
    [self.tableView reloadData];
}

- (NSString *)sizeStr{
    NSInteger totalSize = _totalSize;
    NSString *sizeStr = @"清除缓存";
    if (totalSize > 1000 * 1000) {
        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)",sizeStr,totalSize / 1000.0 / 1000.0];
    } else if (totalSize > 1000) {
        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)",sizeStr,totalSize / 1000.0];
    } else if (totalSize > 0) {
        sizeStr = [NSString stringWithFormat:@"%@(%ldB)",sizeStr,(long)totalSize];
    }
    return sizeStr;
}


@end
