//
//  ViewController.m
//  SuspendView
//
//  Created by 李文强 on 2019/6/6.
//  Copyright © 2019年 WenqiangLI. All rights reserved.
//

#import "ViewController.h"
#import "WQSuspendView.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *pushButton;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_type) {
//        [WQSuspendView show];
//        [WQSuspendView showWithType:WQSuspendViewTypeLeft];
        [WQSuspendView showWithType:WQSuspendViewTypeNone tapBlock:^{
            NSLog(@"点击了");
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
   
}

//不隐藏
- (IBAction)pushClick:(id)sender {
    ViewController *vc = [[ViewController alloc] init];
    vc.type = YES;
    vc.viewHidden = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

//隐藏
- (IBAction)pushHiddenClick:(id)sender {
    ViewController *vc = [[ViewController alloc] init];
    vc.type = YES;
    vc.viewHidden = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)setViewHidden:(BOOL)viewHidden{
    if (viewHidden) {
        [WQSuspendView remove];
    }
}

@end
