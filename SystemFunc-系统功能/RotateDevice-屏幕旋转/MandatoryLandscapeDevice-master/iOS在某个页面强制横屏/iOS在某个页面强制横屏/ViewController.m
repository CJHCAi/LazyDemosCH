//
//  ViewController.m
//  iOS在某个页面强制横屏
//
//  Created by Mac on 2020/5/11.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"
#import "NewViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton * clickButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.clickButton];
    self.clickButton.frame = CGRectMake(100, 200, 150, 40);
}

- (void)clickButtonAction {
    
    [self.navigationController pushViewController:[NewViewController new] animated:YES];
}

- (UIButton *)clickButton {
    if (!_clickButton) {
        _clickButton = [[UIButton alloc] init];
        [_clickButton setTitle:@"Click" forState:UIControlStateNormal];
        _clickButton.backgroundColor = [UIColor blueColor];
        _clickButton.layer.cornerRadius = 20;
        [_clickButton addTarget:self action:@selector(clickButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickButton;
}



@end
