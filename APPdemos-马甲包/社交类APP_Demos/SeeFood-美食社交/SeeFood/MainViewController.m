//
//  MainViewController.m
//  SeeFood
//
//  Created by 纪洪波 on 15/11/25.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "MainViewController.h"
#import "VideoVC.h"
#import "VideoCVC.h"

@interface MainViewController () <VideoVCDelegate, VideoCVCDelegate>
@property (nonatomic, strong) VideoVC *videoVC;
@property (nonatomic, strong) VideoCVC *videoCVC;
@property (nonatomic, assign) BOOL ViewType;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.videoCVC = [[VideoCVC alloc]init];
    self.videoCVC.delegate = self;
    [self addChildViewController:self.videoCVC];
    [self.view addSubview:self.videoCVC.view];
    
    self.videoVC = [[VideoVC alloc]init];
    self.videoVC.delegate = self;
    [self addChildViewController:self.videoVC];
    [self.view addSubview:self.videoVC.view];
}

- (void)changeView {
    if (!self.ViewType) {
        [UIView transitionFromView:self.videoVC.view toView:self.videoCVC.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
        self.ViewType = YES;
    }else {
        [UIView transitionFromView:self.videoCVC.view toView:self.videoVC.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
        self.ViewType = NO;
    }
}

// 接收videoCVC传过来的数组
- (void)updateModelArray:(NSMutableArray *)array
{
    self.videoVC.modelArray = array;
}

-(void)changeViewWithIndex:(NSInteger)index {
    self.videoVC.middleImageIndex = index;
    [UIView transitionFromView:self.videoCVC.view toView:self.videoVC.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:nil];
    self.ViewType = NO;
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
