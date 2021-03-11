//
//  MainTestViewController.m
//  75AG驾校助手
//
//  Created by again on 16/4/29.
//  Copyright © 2016年 again. All rights reserved.
//

#import "MainTestViewController.h"
#import "AnswerViewController.h"

@interface MainTestViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end

@implementation MainTestViewController

- (IBAction)clickBtn:(UIButton *)sender{
    switch (sender.tag) {
        case 201:
        {
            AnswerViewController *con = [[AnswerViewController alloc] init];
            con.type = 5;
            [self.navigationController pushViewController:con animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"模拟仿真考试";
    self.button1.layer.cornerRadius = 8;
    self.button1.layer.masksToBounds = YES;
    self.button2.layer.cornerRadius = 8;
    self.button2.layer.masksToBounds = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
