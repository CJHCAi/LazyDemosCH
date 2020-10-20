//
//  ViewController.m
//  GoodsDetail
//
//  Created by apple on 2017/8/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "ViewController1.h"
#import "ViewController2.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *edetailBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    edetailBtn.frame = CGRectMake(0, 100, self.view.bounds.size.width, 100);
    [edetailBtn setTitle:@"详情页1" forState:UIControlStateNormal];
    [edetailBtn addTarget:self action:@selector(detailBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:edetailBtn];
    
    
    UIButton *edetailBtn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    edetailBtn2.frame = CGRectMake(0, 300, self.view.bounds.size.width, 100);
    [edetailBtn2 setTitle:@"详情页2" forState:UIControlStateNormal];
    [edetailBtn2 addTarget:self action:@selector(detailBtn1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:edetailBtn2];
    
}

#pragma mark - detailBtnAction
- (void)detailBtnAction
{
    ViewController1 *view1VC = [[ViewController1 alloc]init];
    [self.navigationController pushViewController:view1VC animated:YES];
}

#pragma mark - detailBtn1Action
- (void)detailBtn1Action
{
    ViewController2 *view2VC = [[ViewController2 alloc]init];
    [self.navigationController pushViewController:view2VC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
