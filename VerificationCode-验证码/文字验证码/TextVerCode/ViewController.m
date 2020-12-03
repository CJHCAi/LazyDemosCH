//
//  ViewController.m
//  TextVerCode
//
//  Created by zhuyuelong on 2017/4/26.
//  Copyright © 2017年 zhuyuelong. All rights reserved.
//

#import "ViewController.h"

#import "CLTextVerCodeView.h"

@interface ViewController ()

@property (nonatomic, strong) CLTextVerCodeView *tv;

@property (nonatomic, strong) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tv = [[CLTextVerCodeView alloc] initWithFrame:CGRectMake(30, 100, 200, 50)];
    
    self.tv.lineNum = 100;
    
    // 如果 设置 textNum 和 textTotal 属性 请执行 change 方法
    self.tv.textNum = 4;
    
    self.tv.textTotal = 6;
    
    self.tv.viewColor = [UIColor redColor];
    
    [self.view addSubview:self.tv];
    
    [self.tv change];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, 200, 30)];
    
    [self.view addSubview:self.label];
    
    self.label.adjustsFontSizeToFitWidth = YES;
    
    self.label.text = [NSString stringWithFormat:@"按 %@ 顺序点击",self.tv.textString];
    
    __weak typeof(self) weakSelf = self;
    
    self.tv.successBlock = ^(BOOL is) {
        
        if (is) {
            
            weakSelf.label.text = @"验证成功";
            
        }else{
            
            weakSelf.label.text = @"验证失败";
            
        }
        
    };
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(30, 260, 100, 30)];
    
    [button setTitle:@"刷新" forState:UIControlStateNormal];
    
    [self.view addSubview:button];
    
    button.backgroundColor = [UIColor darkGrayColor];
    
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)buttonClick{
    
    [self.tv change];
    
    self.label.text = [NSString stringWithFormat:@"按 %@ 顺序点击",self.tv.textString];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
