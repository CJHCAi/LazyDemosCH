//
//  HKResumeBasicInfoViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKResumeBasicInfoViewController.h"
#import "ActionSheetDatePicker.h"
#import "HK_MyApplyTool.h"
@interface HKResumeBasicInfoViewController ()

@end

@implementation HKResumeBasicInfoViewController

//导航右侧按钮点击
- (BOOL)nextStep {
    BOOL success = [super nextStep];
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
    [HK_MyApplyTool UpdateBaseInfoWithDic:self.dataDict SuccessBlock:^(id res) {
        if (self.uploadSuccessBlock) {
            self.uploadSuccessBlock();
        }
        //成功
        [self.navigationController popViewControllerAnimated:YES];
    } andFial:^(NSString *msg) {
        [SVProgressHUD showInfoWithStatus:msg];
    }];
}
#pragma mark UI数据封装

//第0区数据
- (void)section0 {
    //姓名
    HK_TextFieldFormModel *form0 = [HK_TextFieldFormModel
                                       formModelWithCellTitle:@"姓名"
                                       value:self.infoData.name
                                       postKey:@"name"
                                    placeHolder:PlaceHolder1];
    
    //性别
    HK_SeclectFormModel *form1 = [HK_SeclectFormModel
                                       formModelWithCellTitle:@"性别"
                                       value:self.infoData.sex
                                       postKey:@"sex"
                                  placeHolder:self.infoData.sexName ? self.infoData.sexName : PlaceHolder2];
    
    //出生日期
    HK_SeclectFormModel *form2 = [HK_SeclectFormModel
                                       formModelWithCellTitle:@"出生日期"
                                       value:self.infoData.birthday
                                       postKey:@"birthday"
                                  placeHolder:self.infoData.birthday ? self.infoData.birthday : PlaceHolder2];
    
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1,form2]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}

//第1区数据
- (void)section1 {
    //最高学历
    HK_SeclectFormModel *form1 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"最高学历"
                                  value:self.infoData.education
                                  postKey:@"education"
                                  placeHolder:self.infoData.educationName ? self.infoData.educationName : PlaceHolder2];
    
    //工作年限
    HK_SeclectFormModel *form2 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"工作年限"
                                  value:self.infoData.workingLife
                                  postKey:@"workingLife"
                                  placeHolder:self.infoData.workingLifeName == nil ? self.infoData.workingLifeName : PlaceHolder2];
    //电话号码
    HK_TextFieldFormModel *form3 = [HK_TextFieldFormModel
                                    formModelWithCellTitle:@"电话号码"
                                    value:self.infoData.mobile
                                    postKey:@"mobile"
                                    placeHolder:PlaceHolder1];
    //邮箱
    HK_TextFieldFormModel *form4 = [HK_TextFieldFormModel
                                    formModelWithCellTitle:@"邮箱"
                                    value:self.infoData.email
                                    postKey:@"email"
                                    placeHolder:PlaceHolder1];
    
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form1,form2,form3,form4]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}


//第1区数据
- (void)section2 {
    //所在城市
    HK_SeclectFormModel *form1 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"所在城市"
                                  value:self.infoData.located
                                  postKey:@"located"
                                  placeHolder:self.infoData.locatedName ? self.infoData.locatedName : PlaceHolder2];
    
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form1]];
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
    self.title = @"基本信息";
    self.rightItemTitle = @"保存";
    [super viewDidLoad];
}

//重写 cell 点击处理
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
