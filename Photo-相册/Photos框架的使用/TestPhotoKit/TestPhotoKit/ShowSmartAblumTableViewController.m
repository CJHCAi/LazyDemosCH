//
//  ShowSmartAblumTableViewController.m
//  TestPhotoKit
//
//  Created by admin on 17/6/12.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ShowSmartAblumTableViewController.h"
#import <Photos/Photos.h>
#import "ShowAlbumViewController.h"

#define CELLID @"cellID"

@interface ShowSmartAblumTableViewController ()

@end

@implementation ShowSmartAblumTableViewController

#pragma mark - Initialize

- (instancetype)initWithAlbumCount:(NSInteger)albumCount {
    if (self =[super initWithStyle:UITableViewStylePlain]) {
        self.albumCount = albumCount;
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
}

#pragma mark - - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.self.albumNameArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELLID];
    cell.textLabel.text = self.albumNameArr[indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld张",((PHFetchResult *)self.albumAssetsArr[indexPath.row]).count];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.albumAssetsArr[indexPath.row] && ((PHFetchResult *)self.albumAssetsArr[indexPath.row]).count >0) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        ShowAlbumViewController *SAVC = [[ShowAlbumViewController alloc] initWithCollectionViewLayout:layout];
        SAVC.assets = self.albumAssetsArr[indexPath.row];
        [self.navigationController pushViewController:SAVC animated:YES];
    }
}

@end
