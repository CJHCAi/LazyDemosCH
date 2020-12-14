//
//  BaseNaviViewController.m
//  Rotation-Navigation
//
//  Created by Artron_LQQ on 16/4/6.
//  Copyright © 2016年 Artup. All rights reserved.
//

#import "BaseNaviViewController.h"
#import "SecondViewController.h"
@interface BaseNaviViewController ()

@end

@implementation BaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate
{
    //方式二 判断是不是自己想要设置自动选择的视图,使用这种方式,需要设置的VC不需要重写这个方法
    if ([[self.viewControllers lastObject]isKindOfClass:[SecondViewController class]]) {
        return YES;
    }
    
    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    
    //方式二 判断是不是自己想要设置自动选择的视图,使用这种方式,需要设置的VC不需要重写这个方法
    if ([[self.viewControllers lastObject]isKindOfClass:[SecondViewController class]]) {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait;
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
