//
//  YHNavgationContrller.m
//  左侧菜单栏抽屉效果
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "YHNavgationContrller.h"

@interface YHNavgationContrller ()

@end

@implementation YHNavgationContrller

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    
//    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self.navigationBar setBarTintColor:[UIColor redColor]];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
