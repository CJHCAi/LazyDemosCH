//
//  ViewController.m
//  SignDemo
//
//  Created by yunlong on 2017/6/28.
//  Copyright © 2017年 yunlong. All rights reserved.
//

#import "ViewController.h"
#import "BJTSignView.h"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
@interface ViewController ()
@property(nonatomic,strong) BJTSignView *signView;
@property(nonatomic,strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //画布
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 200)];
    backView.layer.borderWidth = 2;
    backView.layer.borderColor = [[UIColor redColor] CGColor];
    [self.view addSubview:backView];
    self.signView = [[BJTSignView alloc] initWithFrame:backView.bounds];
    [backView addSubview:self.signView];
    
    
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 260, kScreenWidth, 30)];
    [clearBtn setTitle:@"清除签名" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:clearBtn];
    [clearBtn addTarget:self action:@selector(clearBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 300, kScreenWidth, 30)];
    [imageBtn setTitle:@"生成图片" forState:UIControlStateNormal];
    [imageBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:imageBtn];
    [imageBtn addTarget:self action:@selector(imageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth - kScreenWidth/2)/2,380 , kScreenWidth/2, 200/2)];
    self.imageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.imageView];
    
}
#pragma mark - 清楚图片
- (void)clearBtnClick{
    [self.signView clearSignature];
}

#pragma mark - 生成图片
- (void)imageBtnClick{
    UIImage *image  =  [self.signView getSignatureImage];
    self.imageView.image = image;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

