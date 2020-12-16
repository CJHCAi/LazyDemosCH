//
//  ViewController.m
//  转盘01
//
//  Created by WEIWEI on 15-12-10.
//  Copyright (c) 2015年 WEIWEI. All rights reserved.
//

#import "ViewController.h"
#import "wheelView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor grayColor];

    CGFloat cx=0;
    CGFloat cy=self.view.frame.size.height/2-self.view.frame.size.width/2;
    CGFloat cw=self.view.frame.size.width;
    CGFloat ch=self.view.frame.size.width;
    wheelView * wheel=[[wheelView alloc] initWithFrame:CGRectMake(cx, cy, cw, ch)];
    [self.view addSubview:wheel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

}
@end
