//
//  ViewController.m
//  75AG驾校助手
//
//  Created by again on 16/3/23.
//  Copyright © 2016年 again. All rights reserved.
//

#import "ViewController.h"
#import "selectView.h"
#import "FirstViewController.h"
#import "SubjectTwoViewController.h"
#import "WebViewController.h"
#import "WebViewController2.h"

@interface ViewController ()

@property (strong,nonatomic)  selectView *selectView;
@property (weak, nonatomic) IBOutlet UIButton *selctBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectView = [[selectView alloc] initWithFrame:self.view.frame andBtn:self.selctBtn];
    self.selectView.alpha = 0;
    [self.view addSubview:self.selectView];
    
}

//选择车型
- (IBAction)click:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.selectView.alpha = 1;
    }];
}

//跳转科目一
- (IBAction)ClassOne:(id)sender {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:[[FirstViewController alloc] init] animated:YES];
}
- (IBAction)ClassTwo:(id)sender {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:[[SubjectTwoViewController alloc] init] animated:YES];
}
- (IBAction)ClassThree:(id)sender {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"返回";
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:[[SubjectTwoViewController alloc] init] animated:YES];
}
- (IBAction)ClassFour:(id)sender {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
    item.title = @"";
    self.navigationItem.backBarButtonItem = item;
    [self.navigationController pushViewController:[[FirstViewController alloc] init] animated:YES];
}

- (IBAction)BaomingXuzhi:(id)sender {
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
//    item.title = @"返回";
//    self.navigationItem.backBarButtonItem = item;
    WebViewController2 *web2 = [[WebViewController2 alloc] init];
//    [self showViewController:web2 sender:nil];
    [self.navigationController pushViewController:web2 animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
