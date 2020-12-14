//
//  DLDownloadViewController.m
//  DownLoadTest
//
//  Created by 李五民 on 15/10/23.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import "DLDownloadViewController.h"
#import "DLCurrentDownloadViewController.h"
#import "DLFinishDownloadTableViewController.h"

@interface DLDownloadViewController ()

@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,strong) UIViewController *currentViewController;

@end

@implementation DLDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"正在下载",@"已完成"]];
    seg.frame = CGRectMake(0, 0, 160, 30);
    seg.selectedSegmentIndex = 0;
    [seg addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = seg;
    
    DLCurrentDownloadViewController *currentDownloadController = [[DLCurrentDownloadViewController alloc] init];
    currentDownloadController.view.frame = self.view.frame;
    [self addChildViewController:currentDownloadController];
    DLFinishDownloadTableViewController *finishDownloadController = [[DLFinishDownloadTableViewController alloc] init];
    finishDownloadController.view.frame = self.view.frame;
    [self addChildViewController:finishDownloadController];
    
    [self.view addSubview:currentDownloadController.view];
    [currentDownloadController didMoveToParentViewController:self];
    self.currentViewController = currentDownloadController;
}

#pragma mark - Actions
- (void)segmentedControlChanged:(UISegmentedControl *)seg{    
    UIViewController *viewController = self.childViewControllers[seg.selectedSegmentIndex];
    if (![viewController isKindOfClass:[self.currentViewController class]]) {
        [self.currentViewController willMoveToParentViewController:nil];
        [self transitionFromViewController:self.currentViewController toViewController:viewController duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
        }  completion:^(BOOL finished) {
            self.currentViewController=viewController;
            [viewController didMoveToParentViewController:self];
        }];
    }}

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
