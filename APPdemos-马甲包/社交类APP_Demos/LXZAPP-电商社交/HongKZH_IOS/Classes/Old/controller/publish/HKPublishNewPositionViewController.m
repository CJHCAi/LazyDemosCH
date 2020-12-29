//
//  HKPublishNewPositionViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/18.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKPublishNewPositionViewController.h"
#import "HKEnterpriseIntroduceViewController.h"

@interface HKPublishNewPositionViewController ()

@end

@implementation HKPublishNewPositionViewController

- (void)dealloc {
    DLog(@"%s",__func__);
}

//导航右侧按钮点击
- (BOOL)nextStep {
    BOOL success = [super nextStep];
    DLog(@"保存");
    if (success) {
        [self uploadData];
        return YES;
    } else {
        return NO;
    }
}

//上传接口组装数据
- (void)uploadData {
    [self.dataDict setObject:HKUSERLOGINID forKey:@"loginUid"];
    if (self.postionData) {
        [self.dataDict setObject:self.postionData.enterpriseId forKey:@"enterpriseId"];
        [self.dataDict setObject:self.postionData.recruitId forKey:@"recruitId"];
    } else {
        [self.dataDict setObject:self.enterpriseId forKey:@"enterpriseId"];
    }
//    [self Business_Request:BusinessRequestType_get_updateRecruitPositionDetailInfo dic:self.dataDict cache:NO];
}



//第0区数据
- (void)section0 {
    //公司全称
    HK_FormModel *form0;
    HK_FormModel *form1;
    if (self.postionData != nil) {  //如果是修改
        form0 = [HK_UnableModifyFormModel
           formModelWithCellTitle:@"职位名称"
           value:self.postionData.title
           postKey:@"title"
           placeHolder:self.postionData.title];
        form1 = [HK_UnableModifyFormModel
                 formModelWithCellTitle:@"职位类别"
                 value:self.postionData.category
                 postKey:@"category"
                 placeHolder:self.postionData.categoryName];
        form0.required = YES;
        form1.required = YES;
    } else {        //如果是新建
        form0 = [HK_TextFieldFormModel
                 formModelWithCellTitle:@"职位名称"
                 value:nil
                 postKey:@"title"
                 placeHolder:PlaceHolder1];
        form1 = [HK_SeclectFormModel
                 formModelWithCellTitle:@"职位类别"
                 value:nil
                 postKey:@"category"
                 placeHolder:PlaceHolder2];
        form0.required = YES;
        form1.required = YES;
    }
    
    
    //工作地点
    HK_FormModel *form2 = [HK_SeclectFormModel
                           formModelWithCellTitle:@"工作地点"
                           value:self.postionData.areaId
                           postKey:@"areaId"
                           placeHolder:self.postionData.areaName == nil ? PlaceHolder2 : self.postionData.areaName];

    
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1,form2]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}

//第1区数据
- (void)section1 {
    //职位描述
    HK_SeclectFormModel *form0 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"职位描述"
                                  value: self.postionData.introduce
                                  postKey:@"introduce"
                                  placeHolder:self.postionData.introduce == nil ? PlaceHolder1 : self.postionData.introduce];
    
  
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}

//第2区数据
- (void)section2 {
    //工作性质
    HK_SeclectFormModel *form0 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"工作性质"
                                  value: self.postionData.nature
                                  postKey:@"nature"
                                  placeHolder:self.postionData.natureName == nil ? PlaceHolder2 : self.postionData.natureName];
    
    //工作经验
    HK_SeclectFormModel *form1 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"工作经验"
                                  value: self.postionData.experience
                                  postKey:@"experience"
                                  placeHolder:self.postionData.experienceName == nil ? PlaceHolder2 : self.postionData.experienceName];
    
    //学历要求
    HK_SeclectFormModel *form2 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"学历要求"
                                  value: self.postionData.education
                                  postKey:@"education"
                                  placeHolder:self.postionData.educationName == nil ? PlaceHolder2 : self.postionData.educationName];
    
    //月薪范围
    HK_SeclectFormModel *form3 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"月薪范围"
                                  value: self.postionData.salary
                                  postKey:@"salary"
                                  placeHolder:self.postionData.salaryName == nil ? PlaceHolder2 : self.postionData.salaryName];
    
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1,form2,form3]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}


//初始化数据
- (void)initData {
    [self section0];
    [self section1];
    [self section2];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    self.title = @"发布新职位";
    self.rightItemTitle = @"发布";
    [super viewDidLoad];
}

//重写 cell 点击处理,主要处理公司介绍跳转
- (void)handleTableClick:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [super handleTableClick:tableView indexPath:indexPath];
    
    HK_SectionModel *sectionModel = self.groups[indexPath.section];
    HK_FormModel *formModel = sectionModel.formItems[indexPath.row];
   // BaseModel *model = [ViewModelLocator sharedModelLocator].baseData.data.rootDict;
    //--------.如果是带箭头的 cell 有下步操作的 cell--------
    if ([formModel isKindOfClass:[HK_SeclectFormModel class]])
    {
        HK_SeclectFormModel *seclectFormModel = (HK_SeclectFormModel *)formModel;
        if ([formModel.cellTitle isEqualToString:@"职位描述"]) {
            HKEnterpriseIntroduceViewController *vc = [[HKEnterpriseIntroduceViewController alloc] init];
            vc.formModel = seclectFormModel;
            vc.source = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
