//
//  ViewController.m
//  HJVideoPlayer
//
//  Created by 黄静静 on 2017/7/18.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import "ViewController.h"
#import "HJVideoPlayerViewController.h"

#define HJScreenWidth [UIScreen mainScreen].bounds.size.width
#define HJScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tabelView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tabelView];
}

#pragma mark - UITabelView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"视频播放";
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 跳转到视频播放页面
    HJVideoPlayerViewController *playerViewController = [[HJVideoPlayerViewController alloc] init];
    [self.navigationController pushViewController:playerViewController animated:YES];
}

#pragma mark - Get
- (UITableView *)tabelView{
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, HJScreenWidth, HJScreenHeight) style:UITableViewStylePlain];
        _tabelView.backgroundColor = [UIColor whiteColor];
        [_tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
//        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
    }
    return _tabelView;
}


@end
