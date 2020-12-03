//
//  ViewController.m
//  fuck_key
//
//  Created by 姬拉～ on 2016/12/22.
//  Copyright © 2016年 姬拉～. All rights reserved.
//

#import "ViewController.h"

//本地保存
#define XBSetUserDefaults(id,key) [[NSUserDefaults standardUserDefaults] setObject:id forKey:key]; [[NSUserDefaults standardUserDefaults] synchronize]
//本地获取
#define XBGetUserDefaults(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITextField*text1=[[UITextField alloc]initWithFrame:CGRectMake(10, 60, 300, 60)];
    text1.text=@"你看我打字快不快？你是他妈是不是傻";
    text1.placeholder=@"这里记录你要发送的内容";
    text1.layer.borderColor=[UIColor grayColor].CGColor;
    text1.layer.borderWidth=0.5;
    text1.delegate=self;
    [self.view addSubview:text1];
    [text1 addTarget:self action:@selector(change:) forControlEvents:UIControlEventEditingChanged];
    text1.text=XBGetUserDefaults(@"JILA");
    
}
-(void)change:(UITextField*)sender
{
    NSString*text=sender.text;
    XBSetUserDefaults(text,@"JILA");
    NSLog(XBGetUserDefaults(@"JILA"));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
