//
//  HomeViewController.m
//  启动屏加启动广告页
//
//  Created by WOSHIPM on 16/8/9.
//  Copyright © 2016年 WOSHIPM. All rights reserved.
//

#import "HomeViewController.h"
#import "ADDetailViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //    启动页中的广告页的监听事件，当点击了广告页时，跳转到相应的页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAdVC:) name:@"tapAction" object:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame= CGRectMake((self.view.frame.size.width - 100)/2, 100, 100, 40);
    [button setTitle:@"清除缓存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}
-(void)buttonAction{
    
    //获取完整路径
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    path = [path stringByAppendingPathComponent:@"Caches"];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSArray *fileNameAray = [manager subpathsAtPath:path];
        for (NSString *fileName in fileNameAray) {
            //拼接绝对路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            
            //通过文件管理者删除文件
            [manager removeItemAtPath:absolutePath error:nil];
            
            
        }
        NSLog(@"清除成功");
    }
    
    
}
- (void)pushToAdVC:(NSNotification *)notification {
    
    ADDetailViewController *adVc = [[ADDetailViewController alloc] init];
    adVc.URLString = notification.object;
    [adVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:adVc animated:YES];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tapAction" object:nil];
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
