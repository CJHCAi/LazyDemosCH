//
//  ViewController.m
//  TestBasicProjectOC
//
//  Created by shj on 2018/2/19.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "SHJMenuViewController.h"

@interface SHJMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *datas;

@end

@implementation SHJMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initView];
    [self initLayout];
}

- (void)initData {
    self.datas = @[
                   @{@"title": @"1.播放音频按钮", @"class": @"SSFirstViewController"}
                   ];
}

- (void)initView {
    self.title = @"Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)initLayout {
    self.tableView.frame = self.view.bounds;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    NSDictionary *dict = self.datas[indexPath.row];
    cell.textLabel.text = dict[@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.datas[indexPath.row];
    NSString *className = dict[@"class"];
    NSLog(@"%@", className);
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Object

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
