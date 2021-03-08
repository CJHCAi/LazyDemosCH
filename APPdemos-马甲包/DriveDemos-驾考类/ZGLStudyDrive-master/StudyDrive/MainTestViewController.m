//
//  MainTestViewController.m
//  StudyDrive
//
//  Created by zgl on 16/2/26.
//  Copyright © 2016年 sj. All rights reserved.
//

#import "MainTestViewController.h"
#import "AnswerViewController.h"

@interface MainTestViewController ()
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;

@end

@implementation MainTestViewController
- (IBAction)clickBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 201:
        {
            AnswerViewController *con = [[AnswerViewController alloc]init];
            con.type = 5;
            [self.navigationController pushViewController:con animated:YES];
        }
            break;
        case 202:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"模拟仿真考试";
    
    _button1.layer.masksToBounds = YES;
    _button1.layer.cornerRadius = 8;
    
    _button2.layer.masksToBounds = YES;
    _button2.layer.cornerRadius = 8;
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
