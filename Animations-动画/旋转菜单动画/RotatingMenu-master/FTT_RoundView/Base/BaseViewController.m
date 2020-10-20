//
//  BaseViewController.m
//  图片浏览器
//
//  Created by cmcc on 16/8/16.
//  Copyright © 2016年 cmcc. All rights reserved.
//

#import "BaseViewController.h"
#define KColo_lineblue   [UIColor colorWithRed:100/255.f green:152/255.f blue:251/255.f alpha:1.0 ]
@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:KColo_lineblue}];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if (self.navigationController.viewControllers.count > 1) {
        UIImage *image = [UIImage imageNamed:@"back"];
        image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *imageItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        self.navigationItem.leftBarButtonItem = imageItem;
    }
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}


@end
