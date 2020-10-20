//
//  ViewController.m
//  01-微博动画
//
//  Created by xiaomage on 15/6/26.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "ViewController.h"

#import "MenuItem.h"

#import "ComposeItemViewController.h"

@interface ViewController ()

@end

@implementation ViewController
// 点击加号按钮
- (IBAction)btnClick:(id)sender {
    
    // 创建模型对象
    MenuItem *item = [MenuItem itemWithTitle:@"点评" image:[UIImage imageNamed:@"tabbar_compose_review"]];
    MenuItem *item1 = [MenuItem itemWithTitle:@"更多" image:[UIImage imageNamed:@"tabbar_compose_more"]];
    MenuItem *item2 = [MenuItem itemWithTitle:@"拍摄" image:[UIImage imageNamed:@"tabbar_compose_camera"]];
    MenuItem *item3 = [MenuItem itemWithTitle:@"相册" image:[UIImage imageNamed:@"tabbar_compose_photo"]];
    MenuItem *item4 = [MenuItem itemWithTitle:@"文字" image:[UIImage imageNamed:@"tabbar_compose_idea"]];
    MenuItem *item5 = [MenuItem itemWithTitle:@"签到" image:[UIImage imageNamed:@"tabbar_compose_review"]];
    
    ComposeItemViewController *vc = [[ComposeItemViewController alloc] init];
    vc.items = @[item,item1,item2,item3,item4,item5];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
