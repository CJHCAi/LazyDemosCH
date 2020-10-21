//
//  ViewController.m
//  VideoEditDemo
//
//  Created by hejiangshan on 17/2/6.
//  Copyright © 2017年 飞兽科技. All rights reserved.
//

#import "ViewController.h"
#import "WaterViewController.h"
#import "AddBackgroundMusicViewController.h"
#import "MergeVideoViewController.h"
#import "VideoCutViewController.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_dataSources;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _dataSources = @[@"视频裁剪",@"视频合成",@"背景音乐合成",@"添加水印"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSources.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = _dataSources[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *secondStoryboard = [UIStoryboard storyboardWithName:@"Second" bundle:nil];
    if (indexPath.row == 3) {
        WaterViewController *water = [secondStoryboard instantiateViewControllerWithIdentifier:@"water"];
        [self.navigationController pushViewController:water animated:YES];
    } else if (indexPath.row == 2) {
        AddBackgroundMusicViewController *addBackground = [secondStoryboard instantiateViewControllerWithIdentifier:@"backgroundMusic"];
        [self.navigationController pushViewController:addBackground animated:YES];
    } else if (indexPath.row == 1) {
        MergeVideoViewController *merge = [secondStoryboard instantiateViewControllerWithIdentifier:@"merge"];
        [self.navigationController pushViewController:merge animated:YES];
    } else if (indexPath.row == 0) {
        VideoCutViewController *videoCut = [secondStoryboard instantiateViewControllerWithIdentifier:@"videoCut"];
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:videoCut];
        [self presentViewController:navigation animated:YES completion:NULL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
