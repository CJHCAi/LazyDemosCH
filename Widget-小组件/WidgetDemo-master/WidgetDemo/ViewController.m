//
//  ViewController.m
//  WidgetDemo
//
//  Created by 汪继峰 on 2016/11/3.
//  Copyright © 2016年 汪继峰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)clearButtonPressed:(id)sender
{
    [self.textField resignFirstResponder];
    
    self.textField.text = @"";
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.japho.widgetDemo"];
    [userDefaults setObject:@"" forKey:@"widget"];
    [userDefaults synchronize];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据已清除！" delegate:nil cancelButtonTitle:@"好的👌" otherButtonTitles:nil, nil];
    [alert show];
}

- (IBAction)ensureButtonPressed:(id)sender
{
    if (self.textField.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拜托，稍微写两个字好不好" delegate:nil cancelButtonTitle:@"好的👌" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.japho.widgetDemo"];
    [userDefaults setObject:self.textField.text forKey:@"widget"];
    [userDefaults synchronize];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据已更新！" delegate:nil cancelButtonTitle:@"好的👌" otherButtonTitles:nil, nil];
    [alert show];
    
    [self.textField resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
