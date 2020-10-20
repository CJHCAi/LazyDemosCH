//
//  SHJBaseViewController.m
//  TestASDK
//
//  Created by shj on 2018/2/14.
//  Copyright © 2018年 shj. All rights reserved.
//

#import "SSBaseViewController.h"

@interface SSBaseViewController ()

@end

@implementation SSBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (UIButton *)createButtonWithTitle:(NSString *)title color:(UIColor *)color target:(id)target selector:(SEL)selector {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor lightGrayColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)alert:(NSString *)content {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:content preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
