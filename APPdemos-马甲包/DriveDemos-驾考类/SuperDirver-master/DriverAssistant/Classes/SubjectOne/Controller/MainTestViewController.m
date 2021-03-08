//
//  MainTestViewController.m
//  DriverAssistant
//
//  Created by C on 16/4/2.
//  Copyright © 2016年 C. All rights reserved.
//

#import "MainTestViewController.h"
#import "AnswerViewController.h"

@interface MainTestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end

@implementation MainTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"仿真模拟考试";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onClickBtn:(UIButton *)sender {
    if (sender.tag == 201) {
        AnswerViewController *answerCtl = [[AnswerViewController alloc] init];
        answerCtl.type = 5;
        [self.navigationController pushViewController:answerCtl animated:YES];
    }else if(sender.tag == 202){
        AnswerViewController *answerCtl = [[AnswerViewController alloc] init];
        answerCtl.type = 5;
        [self.navigationController pushViewController:answerCtl animated:YES];
    }
}

@end
