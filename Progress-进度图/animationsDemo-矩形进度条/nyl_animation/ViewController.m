//
//  ViewController.m
//  nyl_animation
//
//  Created by 聂银龙 on 2017/12/18.
//  Copyright © 2017年 Hangzhou Jinlian Network Technology Co., LTD. All rights reserved.
//

#import "ViewController.h"
#import "AnimationViewController.h"
#import <CoreMotion/CoreMotion.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)  NSArray *methodsArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (NSArray *)methodsArray {
    return @[@"渐变",  @"圆环进度(带渐变的)" , @"扇形", @"矩形线条闭合动画", @"画二次贝塞尔曲线"];
}

- (UITableView *)tableView {
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.methodsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"AAA_AAA";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:iden];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.methodsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AnimationViewController *VC = [[AnimationViewController alloc] init];
    VC.index = indexPath.row;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
