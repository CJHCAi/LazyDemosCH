//
//  SavedSucceedViewController.m
//  SpeedFreezingVideo
//
//  Created by zhiyi on 16/11/9.
//  Copyright © 2016年 lzy. All rights reserved.
//

#import "SavedSucceedViewController.h"

NSString * const NOTIFICATION_NAME_FULLSCREEN_DISPLAY_NEEDS_DISMISS = @"NOTIFICATION_NAME_FULLSCREEN_DISPLAY_NEEDS_DISMISS";

@interface SavedSucceedViewController ()
@end

@implementation SavedSucceedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationController];
}

- (void)configureNavigationController {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftTopButton:)];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)clickLeftTopButton:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_NAME_FULLSCREEN_DISPLAY_NEEDS_DISMISS object:nil];
}

- (IBAction)clickReloadButton:(id)sender {
    NSLog(@"reload");
}

- (IBAction)clickShootingButton:(id)sender {
    NSLog(@"shooting");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
