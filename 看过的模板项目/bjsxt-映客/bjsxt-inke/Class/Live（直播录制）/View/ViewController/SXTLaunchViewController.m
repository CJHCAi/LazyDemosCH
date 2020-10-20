//
//  SXTLaunchViewController.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/1.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTLaunchViewController.h"
#import "LFLivePreview.h"

@interface SXTLaunchViewController ()

@end

@implementation SXTLaunchViewController


/**关闭界面*/
- (IBAction)closeLaunch:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**开始直播*/
- (IBAction)startLive:(id)sender {
    
    UIView * backview = [[UIView alloc] initWithFrame:self.view.bounds];
    backview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backview];
    
    LFLivePreview * preView = [[LFLivePreview alloc] initWithFrame:self.view.bounds];
    preView.vc = self;
    [self.view addSubview:preView];
    //开启直播
    [preView startLive];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


@end
