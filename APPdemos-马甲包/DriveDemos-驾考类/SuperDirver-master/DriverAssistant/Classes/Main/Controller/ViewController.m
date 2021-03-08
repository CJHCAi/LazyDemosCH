//
//  ViewController.m
//  DriverAssistant
//
//  Created by C on 16/3/28.
//  Copyright © 2016年 C. All rights reserved.
//

#import "ViewController.h"
#import "SelectView.h"
#import "SubjectOneViewController.h"
#import "SubjectTwoViewController.h"
#import "WebViewController.h"

#import "baomingViewController.h"
#import "xinshouViewController.h"
#define BAOMINGXVZHI  @"http://mnks.jxedt.com/ckm4/"
#define XINSHOUSHANGLU  @"http://mnks.jxedt.com/ckm4/"


#import "loginViewController.h"
@interface ViewController ()
{
    SelectView *_selectView;
    __weak IBOutlet UIButton *selectBtn;
}
@end

@implementation ViewController

- (IBAction)click:(UIButton *)sender {
    switch (sender.tag) {
        case 100:
        {
            [UIView animateWithDuration:0.3 animations:^{
                _selectView.alpha = 1;
            }];
        }
            break;
        case 101://科目一
        {
            SubjectOneViewController *ctl = [[SubjectOneViewController alloc] init];
            ctl.myTitle = @"科目一 理论考试";
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 102://科目二
        {
            SubjectTwoViewController *ctl = [[SubjectTwoViewController alloc] init];
            ctl.myTitle = @"科目二 小路考";
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 103://科目三
        {
            SubjectTwoViewController *ctl = [[SubjectTwoViewController alloc] init];
            ctl.myTitle = @"科目三 大路考";
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 104://科目四
        {
            SubjectOneViewController *ctl = [[SubjectOneViewController alloc] init];
            ctl.myTitle = @"科目四 安全文明";
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 105://报名须知
        {
            baomingViewController *baomingVC = [[baomingViewController alloc] init];
            [self.navigationController pushViewController:baomingVC animated:YES];
        }
            break;
        case 106://新手上路
        {
            xinshouViewController *xinshouVC = [[xinshouViewController alloc] init];
            [self.navigationController pushViewController:xinshouVC animated:YES];
            
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    _selectView = [[SelectView alloc] initWithFrame:self.view.frame andBtn:selectBtn];
    _selectView.alpha = 0;
    [self.view addSubview:_selectView];
    [self login];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)login
{
    loginViewController *loginvc = [[loginViewController alloc] init];
    [self presentViewController:loginvc animated:YES completion:^{
        
    }];
}

@end
