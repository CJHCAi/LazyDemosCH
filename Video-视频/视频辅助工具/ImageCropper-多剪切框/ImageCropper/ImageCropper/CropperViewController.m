//
//  CropperViewController.m
//  ImageCropper
//
//  Created by Zhuochenming on 16/1/8.
//  Copyright © 2016年 Zhuochenming. All rights reserved.
//

#import "CropperViewController.h"
#import "CropperView.h"

static CGFloat const BottomViewHeight = 50.0;

@interface CropperViewController ()

@property (nonatomic, strong) CropperView *imageCropperView;

@property (nonatomic, copy) void(^doneBlock)(NSArray *imageArray);

@property (nonatomic, assign) BOOL flag;

@property (nonatomic, assign) CGRect rect;

@end

@implementation CropperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"裁减";

    if (_image == nil) {
        NSAssert(_image = nil, @"图片参数必须有值，不能为空");
    }
    
    [self configuationView];
    
    // Do any additional setup after loading the view.
}

- (void)configuationView {
    self.flag = YES;
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat left = 50;
    
    CGFloat cropWidth = screenWidth - left * 2.0;
    CGRect rect = CGRectMake(left, (screenHeight - BottomViewHeight) / 2.0 - 100, cropWidth, 100);
    self.rect = rect;
    
    self.imageCropperView = [[CropperView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - BottomViewHeight) image:_image rectArray:@[NSStringFromCGRect(rect)]];
    [self.view addSubview:_imageCropperView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - BottomViewHeight, screenWidth, BottomViewHeight)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.userInteractionEnabled = YES;
    
    CGFloat buttonTop = 10;
    CGFloat buttonHeight = BottomViewHeight - buttonTop * 2;
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, buttonTop, 50, buttonHeight);
    [cancleButton addTarget:self action:@selector(cancle) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.backgroundColor = [UIColor clearColor];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:[UIColor colorWithRed:63 / 255.0 green:187 / 255.0 blue:155 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [bottomView addSubview:cancleButton];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake((screenWidth - 50) / 2.0, buttonTop, 50, buttonHeight);
    [addButton addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    addButton.backgroundColor = [UIColor clearColor];
    [addButton setImage:[UIImage imageNamed:@"chapter_plus_green"] forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:addButton];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(screenWidth - 50, buttonTop, 50, buttonHeight);
    [photoButton addTarget:self action:@selector(photo) forControlEvents:UIControlEventTouchUpInside];
    photoButton.backgroundColor = [UIColor clearColor];
    [photoButton setImage:[UIImage imageNamed:@"cut"] forState:UIControlStateNormal];
    [photoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomView addSubview:photoButton];
    
    [self.view addSubview:bottomView];
}

- (void)addBottomViewWithFrame:(CGRect)frame {
    
}

- (void)cancle {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)add:(UIButton *)button {
    if (_flag) {
        [button setImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
        [_imageCropperView addCropRect:CGRectMake(CGRectGetMinX(_rect), CGRectGetMaxY(_rect) + 10, CGRectGetWidth(_rect), CGRectGetHeight(_rect))];
    } else {
        [button setImage:[UIImage imageNamed:@"chapter_plus_green"] forState:UIControlStateNormal];
        [_imageCropperView removeCropRectByIndex:1];
    }
    _flag = !_flag;
}

- (void)photo {
    if (self.doneBlock) {
        NSArray * array=[self.imageCropperView cropedImageArray];
        NSLog(@"%@",array);
        self.doneBlock(array);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)done:(void(^)(NSArray *imageArray))done {
    self.doneBlock = done;
}


@end
