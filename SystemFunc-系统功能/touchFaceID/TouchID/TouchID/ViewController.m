//
//  ViewController.m
//  TouchID
//
//  Created by admin on 17/5/9.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MainViewController.h"

@interface ViewController ()
{
    LAContext *context;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

        // 实例化本地身份验证上下文
        [self creatUI];
    
        context= [[LAContext alloc] init];
    
        [self initIT];


}

- (void)creatUI{
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x-60, 50, 120, 120)];
    [self.view addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"image1"];
    imageV.layer.masksToBounds = YES;
    // 其實就是設定圓角，只是圓角的弧度剛好就是圖片尺寸的一半
    imageV.layer.cornerRadius = 60;

    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.center.x-25, CGRectGetMaxY(imageV.frame)+120 , 50, 70)];
    [self.view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"touchID1"] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn setShowsTouchWhenHighlighted:NO];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(self.view.center.x-100, CGRectGetMaxY(btn.frame)+20, 200, 50)];
    [self.view addSubview:lab];
    lab.text = @"请扫描指纹!";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor greenColor];

}

- (void)btnClick:(UIButton *)btn{
    
    [self initIT];
}

- (void)initIT{
    
    // 判断用户手机系统是否是 iOS 8.0 以上版本
    if ([UIDevice currentDevice].systemVersion.floatValue < 8.0) {
        return;
    }
    
    // 判断是否支持指纹识别
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:NULL]) {
        return;
    }
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication
            localizedReason:@"请验证已有指纹"
                      reply:^(BOOL success, NSError * _Nullable error) {
                          
                          // 输入指纹开始验证，异步执行
                          if (success) {
                              
                              [self refreshUI:[NSString stringWithFormat:@"指纹验证成功"] message:nil];
//                               [self pushVC];
                          }else{
                              
                              [self refreshUI:[NSString stringWithFormat:@"指纹验证失败"] message:error.userInfo[NSLocalizedDescriptionKey]];
                          }
                      }];
}
    // 主线程刷新 UI
- (void)refreshUI:(NSString *)str message:(NSString *)msg {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:str
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [self presentViewController:alert animated:YES completion:^{
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    if ([str isEqualToString:@"指纹验证成功"]) {
                        [self pushVC];
                    }
                });
            }];
        });
}

- (void)pushVC{
    
    MainViewController *vc = [MainViewController new];
    [self presentViewController:vc animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
