//
//  ViewController.m
//  JXVideoCoveEditor
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "ViewController.h"
#import "JXVideoImagePickerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"视频封面编辑";
}

- (IBAction)edit:(UIButton *)sender {
    
    NSString *videoPath = [[NSBundle mainBundle]pathForResource:@"trip.mp4" ofType:nil];
    
    
    JXVideoImagePickerViewController *vc = [[JXVideoImagePickerViewController alloc]init];
    
    vc.videoPath = videoPath;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
