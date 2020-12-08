//
//  RJVideoRecordVC.m
//  录屏和截屏监听
//
//  Created by XinHuiOS on 2019/8/8.
//  Copyright © 2019 XinHuiOS. All rights reserved.
//

#import "RJVideoRecordVC.h"

@implementation RJVideoRecordVC


-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    [self setSubView];
    
}
-(void)setSubView {
    UIImageView * imageV  =[[UIImageView alloc] initWithFrame:self.view.bounds];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.image =[UIImage imageNamed:@"videoRecord.jpg"];
    [self.view addSubview:imageV];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //监测当前设备是否处于录屏状态
    UIScreen * sc = [UIScreen mainScreen];
    if (@available(iOS 11.0,*)) {
        if (sc.isCaptured) {
            NSLog(@"正在录制-----%d",sc.isCaptured);
            [self tipsVideoRecord];
        }
    }else {
       //ios 11之前处理 未知
    }
    
    //ios11之后才可以录屏
    if (@available(iOS 11.0,*)) {
      //检测设备
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tipsVideoRecord) name:UIScreenCapturedDidChangeNotification  object:nil];
    }
}

-(void)dealloc {
    
    if (@available(iOS 11.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
    } else {
        // Fallback on earlier versions
    }
}
//当用户录屏 怎么办 目前来说 只能进行提示。
-(void)tipsVideoRecord {
    UIAlertController * alertVc =[UIAlertController alertControllerWithTitle:@"信息提示" message:@"为保证用户名,密码安全,请不要截屏或录屏!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * knowAction =[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
    [alertVc addAction:knowAction];
    [self presentViewController:alertVc animated:YES completion:nil];
    
}
@end
