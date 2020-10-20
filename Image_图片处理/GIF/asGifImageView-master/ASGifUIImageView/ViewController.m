//
//  ViewController.m
//  ASGifUIImageView
//
//  Created by ashen on 16/4/14.
//  Copyright © 2016年 Ashen<http://www.devashen.com>. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+ASGif.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *gifURL;
@property (weak, nonatomic) IBOutlet UIImageView *gifImgV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //显示本地gif图
        [self.gifImgV showGifImageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"abc" ofType:@"gif"]]];
    //显示网络gif图
        [self.gifURL showGifImageWithURL:[NSURL URLWithString:@"http://ww1.sinaimg.cn/large/85cccab3gw1etdi67ue4eg208q064n50.gif"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
