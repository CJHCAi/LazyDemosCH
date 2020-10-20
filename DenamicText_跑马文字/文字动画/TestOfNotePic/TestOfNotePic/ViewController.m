//
//  ViewController.m
//  TestOfNotePic
//
//  Created by 阳兵青 on 16/1/16.
//  Copyright © 2016年 ouyang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIView *myView;
    BOOL isclick;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    label.text = @"我其实很喜欢你的,初音";
    [self.view addSubview:label];
    
    myView = [[UIView alloc] initWithFrame:CGRectMake(200, 100, 200, 50)];
    myView.backgroundColor = [UIColor whiteColor];
    myView.layer.anchorPoint = CGPointMake(1, 0.5);
    myView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:myView];
}
- (IBAction)buttonClick:(id)sender {
    if (!isclick) {
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            myView.bounds = CGRectMake(0, 0, 10, 50);
        } completion:^(BOOL finished) {
        }];
    } else {
        [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            myView.bounds = CGRectMake(0, 0, 200, 50);
        } completion:^(BOOL finished) {
        }];
    }
    isclick = !isclick;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
