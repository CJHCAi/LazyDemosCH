//
//  DLWelcomeViewController.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/23.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLWelcomeViewController.h"
#import "Masonry.h"

@interface DLWelcomeViewController ()

@end

@implementation DLWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *welcomeImageView = [[UIImageView alloc] init];
    welcomeImageView.userInteractionEnabled = YES;
    welcomeImageView.image = [UIImage imageNamed:@"1-教师社区平台"];
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)] ;
    [welcomeImageView addGestureRecognizer:tapGesture];
    [self.view addSubview:welcomeImageView];
    
    [welcomeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - Actions
- (void)tapGesture
{
    if (_launchBlock) {
        _launchBlock();
    }
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
