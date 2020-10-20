//
//  MainViewController.m
//  集成GPUImage2
//
//  Created by 七啸网络 on 2017/8/23.
//  Copyright © 2017年 youbei. All rights reserved.
//

#import "MainViewController.h"
#import "CameraViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor whiteColor];
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(80, 80, 60, 60);
    [btn addTarget:self action:@selector(pushToCameraVC) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
}
-(void)pushToCameraVC{

    CameraViewController * cameraVC=[[CameraViewController alloc]init];
    
    [self.navigationController pushViewController:cameraVC animated:YES];
}
@end
