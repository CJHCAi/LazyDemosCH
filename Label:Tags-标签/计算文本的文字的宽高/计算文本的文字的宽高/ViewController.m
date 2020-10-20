//
//  ViewController.m
//  计算文本的文字的宽高
//
//  Created by AS150701001 on 16/4/20.
//  Copyright © 2016年 lele. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+stringFrame.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel* label=[[UILabel alloc] init];
    label.font=[UIFont systemFontOfSize:16];
    [self.view addSubview:label];
    label.backgroundColor=[UIColor blueColor];
    label.text=@"kjdhvkjs msnd 经销商 ";
    CGFloat labelX=50;
    CGFloat labelY=50;
    CGFloat labelW=100;
    CGFloat labelH=50;

    CGSize size=[label boundingRectWithSize:CGSizeMake(0, labelH)];
    //labelH=size.height;
    labelW=size.width;
    label.frame=CGRectMake(labelX, labelY, labelW, labelH);
}


@end
