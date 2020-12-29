//
//  NavigationController.m
//  IStone
//
//  Created by 胡传业 on 14-7-20.
//  Copyright (c) 2014年 NewThread. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void) panGestureRecognized:(UIPanGestureRecognizer *)sender {
    
    [self.frostedViewController panGestureRecognized:sender];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
