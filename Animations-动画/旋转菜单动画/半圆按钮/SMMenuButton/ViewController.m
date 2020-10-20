//
//  ViewController.m
//  SMMenuButton
//
//  Created by 朱思明 on 16/7/5.
//  Copyright © 2016年 朱思明. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 创建按钮
    NSArray *imageNames = @[@"icon-star.png",@"icon-star.png",@"icon-star.png",@"icon-star.png",@"icon-star.png"];
    CGRect frame = CGRectMake(150, 150, 52, 52);
    SMMenuButton *smButton = [[SMMenuButton alloc] initWithBackgroudImageName:@"bg-addbutton.png"
                                                             imageName:@"icon-plus.png"
                                           subButtonBackgroudImageName:@"bg-menuitem.png"
                                                   subButtonImageNames:imageNames
                                                                 Frame:frame];
    smButton.subButton_size = CGSizeMake(52, 52);
    // 设置代理事件
    smButton.delegate = self;
    // 设置按钮位置和弧度
    smButton.start_pi = 180;
    smButton.center_pi = M_PI/2;
    
    [self.view addSubview:smButton];
}


#pragma mark - SMMenuButtonDelegate
/*
 *  点击菜单子按钮协议事件
 */
- (void)menuButton:(SMMenuButton *)menuButton clickedMenuButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex：%ld",buttonIndex);
    [menuButton closeMenuButton];
}

/*
 *  将要打开菜单按钮事件
 */
- (void)menuButtonWillOpen:(SMMenuButton *)menuButton
{
    NSLog(@"将要打开按钮");

}

/*
 *  将要关闭菜单按钮事件
 */
- (void)menuButtonWillClose:(SMMenuButton *)menuButton
{
    NSLog(@"将要关闭按钮");
}

@end
