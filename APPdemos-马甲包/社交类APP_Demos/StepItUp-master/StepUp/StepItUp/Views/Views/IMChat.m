//
//  IMChatViewController.m
//  StepUp
//
//  Created by chenLong on 15/4/28.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "IMChat.h"

@interface IMChat ()

@end

@implementation IMChat

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 66, 44)];
    back.backgroundColor = [UIColor redColor];
    [self.view addSubview:back];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)back:(UIButton*)sender{
    NSLog(@"back!!");
    [self dismissModalViewControllerAnimated:YES];
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
