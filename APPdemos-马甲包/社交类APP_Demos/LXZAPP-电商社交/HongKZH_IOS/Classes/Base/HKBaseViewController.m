//
//  HKBaseViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKBaseViewController.h"

@interface HKBaseViewController ()

@end

@implementation HKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setShowCustomerLeftItem:YES];
    
    // Do any additional setup after loading the view.
}
-(void)setSearchUI{
    UIButton *bbt = [HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectMake(-10, 0, 30, 30) taget:self action:@selector(searchGoods) supperView:nil];
    [bbt setBackgroundImage:[UIImage imageNamed:@"class_search"] forState:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bbt];
}
-(void)rightBarButtonItemClick{}
-(void)setrightBarButtonItemWithImageName:(NSString*)imageStr{
    UIButton *bbt = [HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectMake(-10, 0, 40, 40) taget:self action:@selector(rightBarButtonItemClick) supperView:nil];
   // [bbt setBackgroundImage:[UIImage imageNamed:imageStr] forState:0];
    [bbt setImage:[UIImage imageNamed:imageStr] forState:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bbt];
}
-(void)setrightBarButtonItemWithTitle:(NSString*)title{
    UIButton *bbt = [HKComponentFactory buttonWithType:UIButtonTypeCustom frame:CGRectMake(-10, 0, 50, 30) taget:self action:@selector(rightBarButtonItemClick) supperView:nil];
    [bbt setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1] forState:0];
    [bbt setTitle:title forState:0];
    bbt.titleLabel.font = [UIFont systemFontOfSize:15];
    _rightBtn = bbt;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bbt];
}
-(void)searchGoods{}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = NO;
//}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = YES;
//}
#pragma mark Nav 设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
      [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    if (animated) {
//        [self.navigationController setNavigationBarHidden:NO animated:NO];
//      
//    }
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
+(void)showPreWithsuperVc:(HKBaseViewController *)supVc subVc:(HKBaseViewController *)subVc{
    supVc.navigationController.definesPresentationContext = YES;
    subVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    subVc.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.3];
    [supVc.navigationController presentViewController:subVc animated:YES completion:nil];
}
+(void)showPreWithsuperVc:(HKBaseViewController *)supVc subVc:(HKBaseViewController *)subVc color:(UIColor*)color{
    supVc.navigationController.definesPresentationContext = YES;
    subVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    subVc.view.backgroundColor = color;
    [supVc.navigationController presentViewController:subVc animated:YES completion:nil];
}
@end
