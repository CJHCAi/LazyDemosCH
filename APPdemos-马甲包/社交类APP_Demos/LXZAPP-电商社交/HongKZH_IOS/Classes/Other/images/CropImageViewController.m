//
//  CropImageViewController.m
//  WHCropImage
//
//  Created by 魏辉 on 16/9/5.
//  Copyright © 2016年 Weihui. All rights reserved.
//

#import "CropImageViewController.h"
#import "TKImageView.h"

@interface CropImageViewController ()
@property (nonatomic,strong)TKImageView *tkImageView;
@property (nonatomic,strong)UIImage *cropImg;
@end

@implementation CropImageViewController

- (instancetype)initWithCropImage:(UIImage *)cropImage{
    
    if (self = [super init]) {
        self.cropImg = cropImage;
        [self viewConfig];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewConfig{
    
    
    self.tkImageView = [[TKImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_tkImageView];
    self.view.backgroundColor = [UIColor blackColor];
    
    _tkImageView.toCropImage = self.cropImg;
    _tkImageView.showMidLines = YES;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = YES;
    _tkImageView.cropAreaCornerWidth = 3;
    _tkImageView.cropAreaCornerHeight = 3;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor lightGrayColor];
    _tkImageView.cropAreaBorderLineColor = [UIColor grayColor];
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaBorderLineWidth = 6;
    _tkImageView.cropAreaMidLineWidth = 30;
    _tkImageView.cropAreaMidLineHeight = 8;
    _tkImageView.cropAreaMidLineColor = [UIColor grayColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 1;
    
    UIButton *cancleBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    cancleBtn.frame = CGRectMake(0, kScreenHeight-80, [UIScreen mainScreen].bounds.size.width/2, 50);
    [cancleBtn setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancleBtn addTarget:self action:@selector(cancleBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:cancleBtn];
    
    UIButton *okBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    okBtn.frame = CGRectMake(CGRectGetMaxX(cancleBtn.frame), CGRectGetMinY(cancleBtn.frame), CGRectGetWidth(cancleBtn.frame), CGRectGetHeight(cancleBtn.frame));
    [okBtn setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.view addSubview:okBtn];
}

- (void)viewDidAppear:(BOOL)animated{
    _tkImageView.cropAspectRatio = 0;
}

#pragma mark buttonAction
- (void)cancleBtnAction{
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)okBtnAction{
    HKReleaseVideoParam *releaseParm = [HKReleaseVideoParam shareInstance];
    releaseParm.coverImgSrc = [_tkImageView currentCroppedImage];
   
    
}



@end
