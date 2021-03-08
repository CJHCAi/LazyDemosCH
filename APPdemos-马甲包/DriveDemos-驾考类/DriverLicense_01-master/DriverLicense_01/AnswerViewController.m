//
//  AnswerViewController.m
//  DriverLicense_01
//
//  Created by 付小宁 on 16/2/11.
//  Copyright © 2016年 Maizi. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerScrollView.h"

@interface AnswerViewController ()

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout =UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *arr = @[@"5",@"4",@"3",@"2",@"1"];
    AnswerScrollView *view = [[AnswerScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) withDataArray:arr];
    [self.view addSubview:view];
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
