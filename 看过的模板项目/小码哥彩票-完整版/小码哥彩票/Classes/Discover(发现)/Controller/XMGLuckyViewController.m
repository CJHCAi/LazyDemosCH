//
//  XMGLuckyViewController.m
//  小码哥彩票
//
//  Created by xiaomage on 15/6/28.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "XMGLuckyViewController.h"

@interface XMGLuckyViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *lightView;

@end

@implementation XMGLuckyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UIImage *image = [UIImage imageNamed:@"lucky_entry_light0"];
    UIImage *image1 = [UIImage imageNamed:@"lucky_entry_light1"];
    _lightView.animationImages = @[image,image1];
    _lightView.animationDuration = 1;
    [_lightView startAnimating];
}

@end