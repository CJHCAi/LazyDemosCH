//
//  SettingViewController.m
//  TouchID
//
//  Created by admin on 17/5/9.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self creatUI];
}

- (void)creatUI{
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 100, 50)];
    [self.view addSubview:lab];
    lab.text = @"TouchID:";
    lab.textColor = [UIColor redColor];
    
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(150, 100, 20, 10)];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchButton];
    
    NSString *str= [[NSUserDefaults standardUserDefaults] valueForKey:@"TouchID"];
    if ([str isEqualToString:@"yes"]) {
        
        [switchButton setOn:YES];
        
    }

    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, 50, 50)];
    [self.view addSubview:btn];
    [btn setTitle:@"back" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (isButtonOn) {
        switchButton.selected = YES;
        [defaults setObject:@"yes" forKey:@"TouchID"];
    }else {
        switchButton.selected = NO;
        [defaults removeObjectForKey:@"TouchID"];
//        [defaults setObject:@"no" forKey:@"TouchID"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)btnClick:(UIButton *)btn{
    
    [self dismissViewControllerAnimated:YES completion:nil];
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
