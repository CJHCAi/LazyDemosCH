//
//  ViewController.m
//  TJImageEditer
//
//  Created by TanJian on 16/8/1.
//  Copyright © 2016年 Joshpell. All rights reserved.
//

#import "MSMFaceClipperVC.h"
#import "MCPosterEditController.h"

#define  kDeviceWidth        [[UIScreen mainScreen] bounds].size.width
#define  kDeviceHeight       [[UIScreen mainScreen] bounds].size.height

@interface MSMFaceClipperVC ()

@end

@implementation MSMFaceClipperVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = [UIScreen mainScreen].bounds;
    self.imageClipping = [[CPJImageClipping alloc] init];
    [self addChildViewController:self.imageClipping];
    self.imageClipping.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 35);
    self.imageClipping.clippingPanel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.95];
    self.imageClipping.clippingRect = CGRectMake(kDeviceWidth*0.5-200*kDeviceWidth/(kDeviceHeight-60)*0.5, (kDeviceHeight)*0.5-100, 200*kDeviceWidth/(kDeviceHeight-60), 200);
    UIImageView *coverView = [[UIImageView alloc] initWithFrame:self.imageClipping.clippingRect];
    [self.imageClipping.view addSubview:coverView];
    [self.imageClipping.clippingPanel setNeedsDisplay];
    [self.view addSubview:self.imageClipping.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAcvtion:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clipAction:(id)sender {
    UIImage *image= [self.imageClipping clippImage];
//    [self dismissViewControllerAnimated:YES completion:nil];
    

    MCPosterEditController *posterVC = [[MCPosterEditController alloc]initWithNibName:@"MCPosterEditController" bundle:nil];
    posterVC.editImage = image;
    posterVC.delegate= self.superVC;
//    [self presentViewController:posterVC animated:YES completion:nil];
    [self.navigationController pushViewController:posterVC animated:YES];
    
}


@end
