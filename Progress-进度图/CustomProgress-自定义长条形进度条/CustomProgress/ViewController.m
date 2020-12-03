//
//  ViewController.m
//  CustomProgress
//
//  Created by 主用户 on 16/4/11.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import "ViewController.h"
#import "CustomProgress.h"
@interface ViewController ()
{
    CustomProgress *custompro;
    NSTimer *timer;
    int present;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    custompro = [[CustomProgress alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width-20, 50)];
    
    custompro.maxValue = 100;
    //设置背景色
    custompro.bgimg.backgroundColor =[UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:1];
    custompro.leftimg.backgroundColor =[UIColor greenColor];
    //也可以设置图片
    custompro.leftimg.image = [UIImage imageNamed:@"leftimg"];
    custompro.bgimg.image = [UIImage imageNamed:@"bgimg"];
    //可以更改lab字体颜色
    custompro.presentlab.textColor = [UIColor redColor];
    [self.view addSubview:custompro];
    
    timer =[NSTimer scheduledTimerWithTimeInterval:0.1
                                             target:self
                                           selector:@selector(timer)
                                           userInfo:nil
                                            repeats:YES];
}
-(void)timer
{
    present++;
    if (present<=100)
    {
      
        [custompro setPresent:present];
  
    }
    else
    {

        [timer invalidate];
        timer = nil;
        present = 0;
        custompro.presentlab.text = @"完成";
//        [self addcontrol];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
