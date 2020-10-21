//
//  ViewController.m
//  DMPIP
//
//  Created by Rick on 16/4/25.
//  Copyright © 2016年 Rick. All rights reserved.
//

#import "ViewController.h"
#import "ImageProcessViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)pip:(id)sender {
    ImageProcessViewController *imageVC = [[ImageProcessViewController alloc]init];
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    imageVC.originalImage = image;
    [self.navigationController pushViewController:imageVC animated:YES];
}

@end
