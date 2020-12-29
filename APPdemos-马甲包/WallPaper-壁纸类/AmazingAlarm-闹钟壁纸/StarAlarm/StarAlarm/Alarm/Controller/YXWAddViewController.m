//
//  YXWAddViewController.m
//  StarAlarm
//
//  Created by dllo on 16/3/31.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWAddViewController.h"
#import "YXWAlarmSetViewController.h"

@interface YXWAddViewController ()
/**
 *  添加图片
 */

@end

@implementation YXWAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self changeTitleImageView];
}

//- (void)changeTitleImageView {
//    [self.addImageView.layer setCornerRadius:CGRectGetHeight([self.addImageView bounds]) / 2];
//    self.addImageView.layer.masksToBounds = YES;
//
//}
- (IBAction)pushToSetVC:(id)sender {
    YXWAlarmSetViewController *alarmSetVC = [[YXWAlarmSetViewController alloc] init];
    [self presentViewController:alarmSetVC animated:YES completion:^{
        
    }];
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
