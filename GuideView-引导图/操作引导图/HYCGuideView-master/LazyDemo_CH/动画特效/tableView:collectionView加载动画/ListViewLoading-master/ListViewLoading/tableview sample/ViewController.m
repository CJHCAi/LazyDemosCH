//
//  ViewController.m
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/14.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Sunshine.h"
#import "UITableView+Loading.h"
#import "TableViewCell.h"
#import "TableSectionHeaderView.h"
#import "TableSectionFooterView.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UITableViewLoadingDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    // Do any additional setup after loading the view.
    
    self.tableView.loadingDelegate = self;
    [self.tableView startLoading];
    
    ///模仿网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //net-request
        [self.tableView stopLoading];
    });
    
}

#pragma mark - UITableViewLoadingDelegate
- (NSInteger)sectionsOfloadingTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)loadingTableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)loadingTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id" forIndexPath:indexPath];
    cell.sunshineViews = @[cell.avatar, cell.name, cell.job, cell.desc];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)loadingTableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableSectionHeaderView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TableSectionHeaderView class]) owner:nil options:nil].lastObject;
    view.sunshineViews = @[view.cover, view.logo, view.name, view.job];
    return view;
}

- (UIView *)loadingTableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
     TableSectionFooterView *footer = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TableSectionFooterView class]) owner:nil options:nil].lastObject;
    footer.sunshineViews = @[footer.tip];
    return footer;
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_id" forIndexPath:indexPath];

    //实际赋值操作
    cell.name.text = @"张三";
    cell.job.text = @"iOS开发工程师";
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    TableSectionHeaderView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TableSectionHeaderView class]) owner:nil options:nil].lastObject;

    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
   TableSectionFooterView *footer = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TableSectionFooterView class]) owner:nil options:nil].lastObject;

    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 220;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:[sb instantiateViewControllerWithIdentifier:@"avc"] animated:YES];
}
@end
