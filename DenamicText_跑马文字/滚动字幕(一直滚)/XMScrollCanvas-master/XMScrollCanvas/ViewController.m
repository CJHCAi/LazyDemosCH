//
//  ViewController.m
//  XMScrollCanvas
//
//  Created by 万晓 on 16/8/6.
//  Copyright © 2016年 wxm. All rights reserved.
//

#import "ViewController.h"
#import "XMAutoScrollTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    XMAutoScrollTextView *autoScrollView=[[XMAutoScrollTextView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 50) textArray:@[@"ndqfnlqkfwnqkwfnkqfnklqwnfkqewnfkqenfkqenfkqfnlqknqlk",@"tencent",] colorArray:@[[UIColor redColor],[UIColor greenColor]]];
    
    [self.view addSubview:autoScrollView];
    
    
}

@end
