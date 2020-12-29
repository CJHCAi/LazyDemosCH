//
//  HKCareerIntentionsViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCareerIntentionsViewController.h"

#import "HK_MyApplyTool.h"

@interface HKCareerIntentionsViewController ()

@end

@implementation HKCareerIntentionsViewController


//导航右侧按钮点击
- (BOOL)nextStep {
    BOOL success = [super nextStep];
    DLog(@"用户求职意向");
    if (success) {
        [self uploadData];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark 网络请求

//上传接口
- (void)uploadData {
    
    [HK_MyApplyTool UpdateCareerWithDic:self.dataDict SuccessBlock:^(id res) {
        if (self.uploadSuccessBlock) {
            self.uploadSuccessBlock();
        }
        //成功
        [self.navigationController popViewControllerAnimated:YES];
        
    } andFial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];

}
#pragma mark UI数据封装

//第0区数据
- (void)section0 {
    //期望职位
    HK_SeclectFormModel *form0 = [HK_SeclectFormModel
                                    formModelWithCellTitle:@"期望职位"
                                    value:self.infoData.functions
                                    postKey:@"functions"
                                    placeHolder:self.infoData.functionsName ? self.infoData.functionsName : PlaceHolder2];
    
    //工作性质
    HK_SeclectFormModel *form1 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"工作性质"
                                  value:self.infoData.workNature
                                  postKey:@"workNature"
                                  placeHolder:self.infoData.workNatureName ? self.infoData.workNatureName : PlaceHolder2];
    
    //期望月薪
    HK_SeclectFormModel *form2 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"期望月薪"
                                  value:self.infoData.salary
                                  postKey:@"salary"
                                  placeHolder:self.infoData.salaryName ? self.infoData.salaryName : PlaceHolder2];
    
    //期望城市
    HK_SeclectFormModel *form3 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"期望城市"
                                  value:self.infoData.place
                                  postKey:@"place"
                                  placeHolder:self.infoData.placeName ? self.infoData.placeName : PlaceHolder2];
    
    //当前状态
    HK_SeclectFormModel *form4 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"当前状态"
                                  value:self.infoData.state
                                  postKey:@"state"
                                  placeHolder:self.infoData.stateName ? self.infoData.stateName : PlaceHolder2];
    
    //到岗时间
    HK_SeclectFormModel *form5 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"到岗时间"
                                  value:self.infoData.timeToPost
                                  postKey:@"timeToPost"
                                  placeHolder:self.infoData.timeToPostName ? self.infoData.timeToPostName : PlaceHolder2];
    
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1,form2,form3,form4,form5]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}



//初始化数据
- (void)initData {
    [self section0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    self.title = @"职业意向";
    self.rightItemTitle = @"保存";
    [super viewDidLoad];
}


- (void)handleTableClick:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [super handleTableClick:tableView indexPath:indexPath];
    
//    HK_SectionModel *sectionModel = self.groups[indexPath.section];
//    HK_FormModel *formModel = sectionModel.formItems[indexPath.row];
//    BaseModel *model = [ViewModelLocator sharedModelLocator].baseData.data.rootDict;
//    //--------.如果是带箭头的 cell 有下步操作的 cell--------
//    if ([formModel isKindOfClass:[HK_SeclectFormModel class]] )
//    {
//
//    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
