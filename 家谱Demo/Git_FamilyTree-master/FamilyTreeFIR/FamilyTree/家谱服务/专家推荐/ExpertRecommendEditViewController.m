//
//  ExpertRecommendEditViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/8/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "ExpertRecommendEditViewController.h"

@interface ExpertRecommendEditViewController ()
/** 信息文本*/
@property (nonatomic, strong) UITextField *infoTF;
@end

@implementation ExpertRecommendEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = LH_RGBCOLOR(236, 236, 236);
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 74, Screen_width, 45)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteView];
    self.infoTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, Screen_width, 45)];
    self.infoTF.placeholder = self.comNavi.titleLabel.text;
    [whiteView addSubview:self.infoTF];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(12, CGRectYH(whiteView)+20, Screen_width-24, 45)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.backgroundColor = LH_RGBCOLOR(75, 88, 91);
    [button addTarget:self action:@selector(sureEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

-(void)sureEdit{
    [self.delegate sureToEdit:self.infoTF.text withTitle:self.comNavi.titleLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
