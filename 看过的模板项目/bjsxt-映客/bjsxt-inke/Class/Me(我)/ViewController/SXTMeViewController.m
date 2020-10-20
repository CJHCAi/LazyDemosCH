//
//  SXTMeViewController.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/7.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTMeViewController.h"
#import "SXTMeInfoView.h"
#import "SXTSetting.h"

@interface SXTMeViewController ()

@property (nonatomic, strong) NSArray * datalist;

@property (nonatomic, strong) SXTMeInfoView * infoView;

@end

@implementation SXTMeViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (SXTMeInfoView *)infoView {
    
    if (!_infoView) {
        _infoView = [SXTMeInfoView loadInfoView];
    }
    return _infoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.rowHeight = 60;
    self.tableView.sectionFooterHeight = 0;
    
    [self loadData];
    
}

- (void)loadData {
    
    SXTSetting * set1 = [[SXTSetting alloc] init];
    set1.title = @"映客贡献榜";
    set1.subTitle = @"";
    set1.vcName = @"SXTGongViewController";
    
    SXTSetting * set2 = [[SXTSetting alloc] init];
    set2.title = @"收益";
    set2.subTitle = @"0 映票";
    set2.vcName = @"SXTShouViewController";
    
    SXTSetting * set3 = [[SXTSetting alloc] init];
    set3.title = @"账户";
    set3.subTitle = @"0 钻石";
    set3.vcName = @"SXTZhangViewController";
    
    SXTSetting * set4 = [[SXTSetting alloc] init];
    set4.title = @"等级";
    set4.subTitle = @"3 级";
    set4.vcName = @"SXTDengViewController";
    
    SXTSetting * set5 = [[SXTSetting alloc] init];
    set5.title = @"设置";
    set5.subTitle = @"";
    set5.vcName = @"SXTSettingViewController";
    
    NSArray * arr1 = @[set1,set2,set3];
    NSArray * arr2 = @[set4];
    NSArray * arr3 = @[set5];
    
    self.datalist = @[arr1,arr2,arr3];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datalist.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   NSArray * arr = self.datalist[section];
    
   return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    SXTSetting * set = self.datalist[indexPath.section][indexPath.row];
    
    cell.textLabel.text = set.title;
    
    cell.detailTextLabel.text = set.subTitle;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.infoView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return SCREEN_HEIGHT * 0.4;
    }
    return 12;
}

@end
