//
//  ViewController.m
//  CYImageCrop
//
//  Created by Cyrus on 16/6/9.
//  Copyright © 2016年 Cyrus. All rights reserved.
//

#import "ViewController.h"
#import "CYCropView.h"
#import "UIImageView+CYCrop.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CYCropView *crop;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    // 设置缩放边长的最小值，默认为100
    self.imageView.cy_cropView.minLenghOfSide = 80;
    // 设置裁剪框边框，默认为 2.0
    self.imageView.cy_cropView.borderWidth = 2.5;
    // 设置遮罩层颜色，默认为 [UIColor colorWithWhite:0 alpha:0.5]
    self.imageView.cy_cropView.maskColor = [UIColor colorWithWhite:0 alpha:0.6];
    // 设置每次拖拽后的回调，默认为空
    [self.imageView cy_setComplectionHandler:^{
        NSLog(@"实际裁剪区域: %@", NSStringFromCGRect(self.imageView.cy_cropFrame));
        NSLog(@"比例裁剪区域: %@", NSStringFromCGRect(self.imageView.cy_cropFrameRatio));
    }];
    
}

- (IBAction)hide:(id)sender {
    [self.imageView cy_hideCropView];
}

- (IBAction)showCustom:(id)sender {
    [self.imageView cy_showCropViewWithType:CYCropScaleTypeCustom];
}
- (IBAction)show1To1:(id)sender {
    [self.imageView cy_showCropViewWithType:CYCropScaleType1To1];
}
- (IBAction)show3To2:(id)sender {
    [self.imageView cy_showCropViewWithType:CYCropScaleType3To2];
}
- (IBAction)show4To3:(id)sender {
    [self.imageView cy_showCropViewWithType:CYCropScaleType4To3];
}
- (IBAction)show16To9:(id)sender {
    [self.imageView cy_showCropViewWithType:CYCropScaleType16To9];
}

@end
