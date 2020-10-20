//
//  ViewController.m
//  douyin
//
//  Created by liyongjie on 2018/2/6.
//  Copyright © 2018年 world. All rights reserved.
//

#import "ViewController.h"
#import "HeartAnimation.h"



@interface ViewController ()

@end

static NSInteger count = 0;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];

}


-(void)handleTap:(UITapGestureRecognizer *)tap{
    
    NSLog(@"触发了%ld次",++count);
    
    [[HeartAnimation sharedManager] createHeartWithTap:tap];
    
    
}


@end
