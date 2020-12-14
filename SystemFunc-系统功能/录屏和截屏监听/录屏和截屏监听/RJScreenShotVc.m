//
//  RJScreenShotVc.m
//  录屏和截屏监听
//
//  Created by XinHuiOS on 2019/8/8.
//  Copyright © 2019 XinHuiOS. All rights reserved.
//

#import "RJScreenShotVc.h"

@interface RJScreenShotVc ()

@end

@implementation RJScreenShotVc

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self setSubView];
    
    //增加监听->监听截图事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSceenShot) name:UIApplicationUserDidTakeScreenshotNotification object:nil];

}
-(void)setSubView {
    UIImageView * imageV  =[[UIImageView alloc] initWithFrame:self.view.bounds];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image =[UIImage imageNamed:@"screenPic.jpg"];
    [self.view addSubview:imageV];
}


//当用户截屏了 怎么办 目前来说 只能进行提示。
-(void)handleSceenShot {
    UIAlertController * alertVc =[UIAlertController alertControllerWithTitle:@"信息提示" message:@"为保证用户名,密码安全,请不要截屏或录屏!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * knowAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:knowAction];
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)dealloc {
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

@end
