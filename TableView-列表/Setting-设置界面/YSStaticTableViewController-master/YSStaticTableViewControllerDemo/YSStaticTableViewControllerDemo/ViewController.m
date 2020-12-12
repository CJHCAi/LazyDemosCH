//
//  ViewController.m
//  YSStaticTableViewControllerDemo
//
//  Created by MOLBASE on 2018/7/18.
//  Copyright © 2018年 YangShen. All rights reserved.
//

#import "ViewController.h"
#import "WXDiscoverViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"YSStaticTableViewControllerDemo";
    
    [self prepareData];
}

- (void)prepareData {
    __weak typeof(self) weakSelf = self;
    YSStaticDefaultModel *model1 = [[YSStaticDefaultModel alloc] init];
    model1.title = @"微信";
    model1.didSelectCellBlock = ^(YSStaticCellModel *cellModel, NSIndexPath *indexPath) {
        __strong typeof(self) strongSelf = weakSelf;
        WXDiscoverViewController *wx = [[WXDiscoverViewController alloc] init];
        [strongSelf.navigationController pushViewController:wx animated:YES];
    };
    
    YSStaticSectionModel *sm0 = [YSStaticSectionModel sectionWithItemArray:@[model1]];
    
    YSStaticDefaultModel *model2 = [[YSStaticDefaultModel alloc] init];
    model2.title = @"今日头条";
    
    YSStaticSectionModel *sm1 = [YSStaticSectionModel sectionWithItemArray:@[model2]];
    
    self.sectionModelArray = @[sm0, sm1];

}


@end
