//
//  ViewController.m
//  SuspendView
//
//  Created by care on 17/5/10.
//  Copyright © 2017年 luochuan. All rights reserved.
//

#import "ViewController.h"
#import "LCSuspendCustomBaseViewController.h"
@interface ViewController ()

@end

@implementation ViewController

/**悬浮视图的类型
 BUTTON    =0,//按钮
 IMAGEVIEW =1,//图片
 GIF       =2,//gif图
 MUSIC     =3,//音乐界面
 VIDEO     =4,//视频界面
 SCROLLVIEW =5,//滚动多图
 OTHERVIEW =6//自定义view
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    LCSuspendCustomBaseViewController *suspendVC=[[LCSuspendCustomBaseViewController alloc]init];
    suspendVC.suspendType=GIF;
    [self addChildViewController:suspendVC];
    [self.view addSubview:suspendVC.view];
    
    
}
@end
