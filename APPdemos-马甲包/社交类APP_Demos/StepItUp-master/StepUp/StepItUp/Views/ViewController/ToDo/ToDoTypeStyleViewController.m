//
//  ToDoTypeStyleViewController.m
//  StepUp
//
//  Created by syfll on 15/4/28.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "ToDoTypeStyleViewController.h"
#import "SIUCreateScheduleViewController.h"
#import "SIUMacros.h"
#import "XHPopMenu.h"
#import "LKAlarmMamager.h"


#define FontSize 23.0f
@interface ToDoTypeStyleViewController ()
@property (nonatomic, strong) XHPopMenu *popMenu;
@end

@implementation ToDoTypeStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMyNaviItem];
    
    #pragma mark 解决preferredStatusBarStyle不执行问题
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - 初始化导航
-(void)initMyNaviItem{
    //add Button
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(showMenuOnView:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    //这是新版本
    UIButton * title = [UIButton buttonWithType:UIButtonTypeSystem];
    title.titleLabel.font = [UIFont systemFontOfSize:FontSize];
    [title setTitle:@"日程" forState:UIControlStateNormal];
    [title setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [title setTintColor:[UIColor whiteColor]];
    self.navigationItem.titleView = title;
    
    
}



- (void)showMenuOnView:(UIBarButtonItem *)buttonItem {
    [self.popMenu showMenuOnView:self.view atPoint:CGPointZero];
}


#pragma mark - Propertys
#pragma mark 添加按钮（popMenu）
- (XHPopMenu *)popMenu {
    if (!_popMenu) {
        NSMutableArray *popMenuItems = [[NSMutableArray alloc] initWithCapacity:3];
        for (int i = 0; i < 2; i ++) {
            NSString *imageName;
            NSString *title;
            switch (i) {
                case 0: {
                    imageName = @"contacts_add_newmessage";
                    title = @"添加日程";
                    break;
                }
                case 1: {
                    imageName = @"contacts_add_friend";
                    title = @"发表状态";
                    break;
                }
                default:
                    break;
            }
            XHPopMenuItem *popMenuItem = [[XHPopMenuItem alloc] initWithImage:[UIImage imageNamed:imageName] title:title];
            [popMenuItems addObject:popMenuItem];
        }
        
        WEAKSELF
        _popMenu = [[XHPopMenu alloc] initWithMenus:popMenuItems];
        _popMenu.popMenuDidSlectedCompled = ^(NSInteger index, XHPopMenuItem *popMenuItems) {
            if (index == 1) {
                printf("发表状态 index 1\n");
                //[weakSelf enterQRCodeController];
            }else if (index == 0 ) {
                printf("添加日程 index 0\n");
                [weakSelf enterCreateScheduleController];
            }
        };
    }
    return _popMenu;
}

- (void)enterCreateScheduleController {
    [self performSegueWithIdentifier:@"createSchedule" sender:self];
    printf("我要创建日程辣 ：）\n");
}

#pragma mark - 设置标题栏为白色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
