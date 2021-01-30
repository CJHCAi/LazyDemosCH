//
//  ViewController.m
//  CircleAnimationUserInteractionDemo
//
//  Created by Amale on 16/2/29.
//  Copyright © 2016年 Amale. All rights reserved.
//

#import "ViewController.h"
#import "WDCircleAnimationView.h"
#import "UIView+Extensions.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface ViewController ()

@property(strong,nonatomic) WDCircleAnimationView * circleView ;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.circleView = [[WDCircleAnimationView alloc] initWithFrame:CGRectMake(40, 100, SCREEN_WIDTH-80, SCREEN_WIDTH-80)];
    
    self.circleView.text = @"初始的文字";
    
    self.circleView.temperInter = 20.5 ;
    
    self.circleView.functionImage = FunctionTypeAuto;
    
    [self.view addSubview:self.circleView] ;
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


    //self.circleView.text = @"点击了的文字";
    
//    self.circleView.temperInter = 26 ;
//    
//    self.circleView.functionImage = FunctionTypeSun;
    NSLog(@"当前温度是 %ld",self.circleView.temperInter);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
