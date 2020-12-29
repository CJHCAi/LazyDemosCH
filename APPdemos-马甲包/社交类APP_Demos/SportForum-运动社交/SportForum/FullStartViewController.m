//
//  FullStartViewController.m
//  SportForum
//
//  Created by liyuan on 1/13/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "FullStartViewController.h"

@interface FullStartViewController ()

@end

@implementation FullStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backgroundImage1 = [[UIImageView alloc] initWithFrame:self.view.frame];
    [backgroundImage1 setContentMode:UIViewContentModeScaleAspectFill];
    [backgroundImage1 setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [backgroundImage1 setImage:[UIImage imageNamed:@"Default-568h"]];
    [self.view addSubview:backgroundImage1];
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
