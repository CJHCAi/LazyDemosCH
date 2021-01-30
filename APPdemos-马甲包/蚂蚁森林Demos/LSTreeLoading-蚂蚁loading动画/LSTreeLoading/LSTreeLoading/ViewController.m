//
//  ViewController.m
//  LSTreeLoading
//
//  Created by liusong on 2017/10/27.
//  Copyright © 2017年 liusong. All rights reserved.
//

#import "ViewController.h"

#import "LSTreeLoading.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)show:(id)sender {

    [LSTreeLoading show];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [LSTreeLoading hide];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
