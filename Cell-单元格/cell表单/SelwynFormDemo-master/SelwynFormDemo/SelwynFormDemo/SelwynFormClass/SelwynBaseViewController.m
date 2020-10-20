//
//  SelwynBaseViewController.m
//  SelwynFormDemo
//
//  Created by Selwyn Bi on 2017/6/24.
//  Copyright © 2017年 selwyn. All rights reserved.
//

#import "SelwynBaseViewController.h"
#import "SelwynFormItem.h"
#import "SelwynFormSectionItem.h"
#import "SelwynFormHandle.h"
#import "SelwynFormViewController.h"
#import "SelwynFormDetailViewController.h"

@interface SelwynBaseViewController ()

@end

@implementation SelwynBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"SelwynBaseViewController";
    
    [self dataSource];
}

- (void)dataSource{
    
    NSMutableArray *datas = [NSMutableArray array];
    
    SelwynFormItem *inputType = SelwynDetailItemMake(@"输入表单", @"", SelwynFormCellTypeNone);
    inputType.selectHandle = ^(SelwynFormItem *item) {
      
        SelwynFormViewController *formVC = [[SelwynFormViewController alloc]initWithStyle:UITableViewStyleGrouped];
        formVC.title = @"SelwynFormViewController";
        [self.navigationController pushViewController:formVC animated:YES];
    };
    [datas addObject:inputType];
    
    SelwynFormItem *detailType = SelwynDetailItemMake(@"详情表单", @"", SelwynFormCellTypeNone);
    detailType.selectHandle = ^(SelwynFormItem *item) {
        
        SelwynFormDetailViewController *formVC = [[SelwynFormDetailViewController alloc]initWithStyle:UITableViewStylePlain];
        formVC.title = @"SelwynFormDetailViewController";
        [self.navigationController pushViewController:formVC animated:YES];
    };
    //[datas addObject:detailType];
    
    SelwynFormSectionItem *sectionItem = [[SelwynFormSectionItem alloc]init];
    sectionItem.cellItems = datas;
    
    [self.mutableArray addObject:sectionItem];
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
