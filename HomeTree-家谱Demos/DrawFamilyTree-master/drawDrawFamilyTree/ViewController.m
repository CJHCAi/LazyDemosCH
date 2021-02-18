//
//  ViewController.m
//  drawDrawFamilyTree
//
//  Created by Nicole on 2018/3/16.
//  Copyright © 2018年 Nicole. All rights reserved.
//

#import "ViewController.h"
#import "FamilyModel.h"
#import "FamilyTreeView.h"
#import "ExampleDataTool.h"

@interface ViewController () <FamilyTreeViewDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) FamilyTreeView *familyTreeView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"家族树绘制";
    
    self.familyTreeView = [[FamilyTreeView alloc] initWithFrame:self.view.frame];
    
    FamilyModel *model = [ExampleDataTool getFamilyModelFromLocalExampleData];
    self.familyTreeView.model = model;
    self.familyTreeView.delegate = self;
    [self.view addSubview:self.familyTreeView];
}

-(void)familyTreeButtonDidClickedItemAtIndex:(FamilyModel *)model{
    NSString *titleStr = [NSString stringWithFormat:@"点击了 '%@' 按钮", model.appellation];
    NSString *messageStr = [NSString stringWithFormat:@"节点ID：%@ && 姓名：%@", model.personId, model.name];
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:titleStr message:messageStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
