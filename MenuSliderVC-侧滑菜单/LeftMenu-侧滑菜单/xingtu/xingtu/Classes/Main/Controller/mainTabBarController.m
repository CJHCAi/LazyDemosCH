//
//  mainTabBarController.m
//  xingtu
//
//  Created by Wondergirl on 16/7/12.
//  Copyright © 2016年 Wondergirl. All rights reserved.
//

#import "mainTabBarController.h"
//#import "myNavigationController.h"
/**
 *  首页
 */
#import "JWTHomeViewController.h"
/**
 *  订票
 */
#import "JWTCJZCViewController.h"
/**
 *  我的
 */
#import "JWTCJZCViewController.h"

#define CLASSNAME @[@"JWTHomeViewController",@"JWTCJZCViewController",@"JWTCJZCViewController"]
//TABBAR显示的title
#define TITLEARR @[@"购票",@"活动",@"订单"]
//nav显示TITLE
#define NAVTITLEARR @[@"兴途",@"活动",@"订单"]
//tabbar默认图片
#define IMAGEARR @[@"bugTick_HomeViewController_barBtn_normal",@"bugTick_HomeViewController_barBtn_normal.png",@"bugTick_HomeViewController_barBtn_normal.png"]
//tabbar选中图片
#define SELIMGARR  @[@"bugTick_HomeViewController_barBtn_selected.png",@"bugTick_HomeViewController_barBtn_selected.png",@"bugTick_HomeViewController_barBtn_selected.png"]
@interface mainTabBarController ()

@end

@implementation mainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置tabBar
   self.view.backgroundColor = [UIColor whiteColor];
    NSArray *classNameArr = CLASSNAME;
    NSArray *titleArr = TITLEARR;
    NSArray *titleNavArr = NAVTITLEARR;
    NSArray *imageArr = IMAGEARR;
    NSArray *selectedImgArr = SELIMGARR;
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i<classNameArr.count; i++) {
        id nav = [self setUpViewControllerWithClassName:classNameArr[i] image:[[UIImage imageNamed:imageArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImgArr[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] title:titleArr[i] navTitle:titleNavArr[i]];
        [tempArr addObject:nav];
    }
    self.viewControllers = tempArr;
    [self.tabBar setTintColor:[UIColor redColor]];
   // self.tabBar.barTintColor = Rgb(38, 211, 255);
}
-(UINavigationController *)setUpViewControllerWithClassName:(NSString *)className image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title navTitle:(NSString *)navTitle{
    
    Class class = NSClassFromString(className);
    id controller = [[class alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
    [controller setTabBarItem:[[UITabBarItem alloc] initWithTitle:title image:image selectedImage:selectedImage]];
    [controller setTitle:title];
    return nav;
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
