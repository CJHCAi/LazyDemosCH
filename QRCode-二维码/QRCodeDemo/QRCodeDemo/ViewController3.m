//
//  ViewController3.m
//  QRCodeDemo
//
//  Created by King on 2017/8/15.
//  Copyright © 2017年 King. All rights reserved.
//

#import "ViewController3.h"
#import "QRCodeGenerator.h"

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

@interface ViewController3 ()

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * qrCodeImageView = [[UIImageView alloc]init];
    qrCodeImageView.frame  = CGRectMake(0, 0, 200, 200);
    qrCodeImageView.center = self.view.center;
    [self.view addSubview:qrCodeImageView];
    
    qrCodeImageView.image = [QRCodeGenerator qrImageForString:@"https://app.chaoaicai.com/static/app/app_gift_bag.html?inviteCode=5fryqk9" imageSize:1024 Topimg:nil withPointType:0 withPositionType:0 withPositionColor:RGB(245, 147, 50) withCenterColor:RGB(235, 100, 50)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
