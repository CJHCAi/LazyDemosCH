//
//  ViewController.m
//  FriendList
//
//  Created by 甘萌 on 17/4/20.
//  Copyright © 2017年 com.esdlumen. All rights reserved.
//

#import "ViewController.h"
#import "SPContractsViewController.h"

@interface ViewController ()

@property (nonatomic, copy) NSArray *datasource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)select:(UIButton *)sender {
    
    SPContractsViewController *vc = [[SPContractsViewController alloc] init];
//    
//    __weak typeof(self)weakSelf = self;
//    vc.callback = ^(NSArray *arr){
//        weakSelf.datasource = arr;
//    };
//    
//    if (self.datasource.count) {
//        vc.datasource = self.datasource;
//    }
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)selectWithSource:(UIButton *)sender {
    
    //会回传数据，下次进入会展示上次选择的
    SPContractsViewController *vc = [[SPContractsViewController alloc] init];
    
    __weak typeof(self)weakSelf = self;
    vc.callback = ^(NSArray *arr){
        weakSelf.datasource = arr;
    };
    
    if (self.datasource.count) {
        vc.datasource = self.datasource;
    }
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
