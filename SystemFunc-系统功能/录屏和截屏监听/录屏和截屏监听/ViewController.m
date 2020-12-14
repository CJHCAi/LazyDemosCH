//
//  ViewController.m
//  录屏和截屏监听
//
//  Created by XinHuiOS on 2019/8/8.
//  Copyright © 2019 XinHuiOS. All rights reserved.
//

#import "ViewController.h"
#import "RJVideoRecordVC.h"
#import "RJScreenShotVc.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"监听屏幕录制和截屏";
    self.view.backgroundColor =[UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight =50;
        _tableView.showsVerticalScrollIndicator =NO;
        _tableView.showsHorizontalScrollIndicator =NO;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView.tableFooterView =[[UIView alloc] init];
    }
    return _tableView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row) {
        cell.textLabel.text = @"进入截屏界面";
    }else {
        cell.textLabel.text =@"进入录制界面";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row) {
        RJScreenShotVc * screenVc =[[RJScreenShotVc alloc] init];
        [self.navigationController pushViewController:screenVc animated:YES];
    }else {

        RJVideoRecordVC * videoVc =[[RJVideoRecordVC alloc] init];
        [self.navigationController pushViewController:videoVc animated:YES];
    }
}
@end
