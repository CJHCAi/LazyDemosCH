//
//  ViewController.m
//  压缩视频
//
//  Created by 施永辉 on 16/7/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "CustomCamera.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
//录像
- (IBAction)playVideo:(id)sender {
    //判断是否有拍照功能
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
    CustomCamera * viewVC = [[CustomCamera alloc]init];
    [self presentViewController:viewVC animated:YES completion:nil];
    }else{
        NSLog(@"请用真机测试录像");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
