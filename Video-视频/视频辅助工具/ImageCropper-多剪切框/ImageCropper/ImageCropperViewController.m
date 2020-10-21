//
//  ImageCropperViewController.m
//  ImageCropper
//
//  Created by Zhuochenming on 2017/1/3.
//  Copyright © 2017年 Zhuochenming. All rights reserved.
//

#import "ImageCropperViewController.h"
#import "CropperViewController.h"

@interface ImageCropperViewController ()

@end

@implementation ImageCropperViewController

- (void)viewDidLoad {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"多裁切框裁剪图片";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"Demo" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 100, 30);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor orangeColor];
    [button addTarget:self action:@selector(buttonTocuh) forControlEvents:UIControlEventTouchUpInside];
    button.center = self.view.center;
    
    [self.view addSubview:button];

}

- (void)buttonTocuh {
    
    CropperViewController * crop = [CropperViewController new];
    crop.image = [UIImage imageNamed:@"a.jpg"];
        [crop done:^(NSArray *imageArray) {
        NSLog(@"%ld", imageArray.count);
    }];
    [self.navigationController pushViewController:crop animated:YES];
}

- (void)removeView:(UIView *)view {
    [view removeFromSuperview];
}



@end
