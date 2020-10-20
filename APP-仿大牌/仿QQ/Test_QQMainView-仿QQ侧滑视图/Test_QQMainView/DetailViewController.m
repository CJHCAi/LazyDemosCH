//
//  DetailViewController.m
//  Text_QQMainView
//
//  Created by jaybin on 15/4/18.
//  Copyright (c) 2015年 jaybin. All rights reserved.
//

#import "DetailViewController.h"
#import "CommonTools.h"

@interface DetailViewController (){
    UILabel *textLbl;;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    textLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, SCREEM_WIDTH, 100)];
    textLbl.text = _text;
    [textLbl setFont:[UIFont boldSystemFontOfSize:60]];
    [textLbl setTextAlignment:NSTextAlignmentCenter];
    [textLbl setTextColor:[UIColor yellowColor]];
    [self.view addSubview:textLbl];
    self.title = _text;
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
