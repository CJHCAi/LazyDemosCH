//
//  MYZNavigationBaseController.m
//  MYZWebHybrid
//
//  Created by MA806P on 2019/2/23.
//  Copyright © 2019 myz. All rights reserved.
//

#import "MYZNavigationBaseController.h"

@interface MYZNavigationBaseController ()

@end

@implementation MYZNavigationBaseController

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
