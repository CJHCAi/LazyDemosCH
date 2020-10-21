//
//  HJVideoPlayerViewController.m
//  HJVideoPlayer
//
//  Created by 黄静静 on 2017/7/24.
//  Copyright © 2017年 HJing. All rights reserved.
//

#import "HJVideoPlayerViewController.h"
#import "HJPlayView.h"

@interface HJVideoPlayerViewController ()<HJPlayViewDelegate>
@property (nonatomic, strong) HJPlayView *playView;
@end

@implementation HJVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _playView = [HJPlayView playerViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 211) withPlayType:HJPlayViewTypeForPlay];
    _playView.videoUrl = [NSURL URLWithString:@"https://gslb.miaopai.com/stream/0QWLs7QKFw3xp86Ch~k~7V-TMtyO4Yc4.mp4?yx=&refer=weibo_app&Expires=1499936190&ssig=CRPRhpNL2L&KID=unistore,video"];
    _playView.delegate = self;
    [self.view addSubview:_playView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [super viewWillDisappear:animated];
}

#pragma mark - HJPlayViewDelegate
- (void)closeVideo {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        return [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
