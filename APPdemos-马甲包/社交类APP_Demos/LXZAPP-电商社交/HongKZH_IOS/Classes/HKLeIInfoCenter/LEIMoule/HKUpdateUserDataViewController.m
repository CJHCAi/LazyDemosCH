//
//  HKUpdateUserDataViewController.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateUserDataViewController.h"
#import "HK_LoginRegesterTool.h"
@interface HKUpdateUserDataViewController ()

@end

@implementation HKUpdateUserDataViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

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
    [self.dataDict setObject:HKUSERLOGINID forKey:@"loginUid"];
    
    [HK_LoginRegesterTool updateUserInfoWithDic:self.dataDict successBlock:^{
        
        if (self.uploadSuccessBlock) {
            self.uploadSuccessBlock();
        }
        //成功
        [self.navigationController popViewControllerAnimated:YES];
    } fail:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}
#pragma mark UI数据封装

//第0区数据
- (void)section0 {
    
    //nickname
    HK_TextFieldFormModel *form0 = [HK_TextFieldFormModel
                                    formModelWithCellTitle:@"昵称"
                                    value:self.infoData.nickname
                                    postKey:@"nickname"
                                    placeHolder:PlaceHolder1];
    //性别
    HK_SeclectFormModel *form1 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"性别"
                                  value:self.infoData.sex
                                  postKey:@"sex"
                                  placeHolder:self.infoData.sexName ? self.infoData.sexName : PlaceHolder2];
    
    //出生日期
    HK_SeclectFormModel *form2 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"年龄"
                                  value:[NSString stringWithFormat:@"%zd",self.infoData.age]
                                  postKey:@"age"
                                  placeHolder:self.infoData.ageName ? [NSString stringWithFormat:@"%@",self.infoData.ageName] : PlaceHolder2];
    
    //身高
    HK_SeclectFormModel *form3 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"身高"
                                  value:self.infoData.height
                                  postKey:@"height"
                                  placeHolder:self.infoData.height ? self.infoData.height : PlaceHolder2];
    
    //学历
    HK_SeclectFormModel *form4 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"学历"
                                  value:self.infoData.education
                                  postKey:@"education"
                                  placeHolder:self.infoData.educationName ? self.infoData.educationName : PlaceHolder2];
    
    //月收入
    HK_SeclectFormModel *form5 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"月收入"
                                  value:self.infoData.monthlyIncome
                                  postKey:@"monthlyIncome"
                                  placeHolder:self.infoData.monthlyIncomeName ? self.infoData.monthlyIncomeName : PlaceHolder2];
    
    //居住地
    HK_SeclectFormModel *form6 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"居住地"
                                  value:self.infoData.located
                                  postKey:@"located"
                                  placeHolder:self.infoData.locatedName ? self.infoData.locatedName : PlaceHolder2];

    //婚姻状况
    HK_SeclectFormModel *form7 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"婚姻状况"
                                  value:self.infoData.marital
                                  postKey:@"marital"
                                  placeHolder:self.infoData.maritalName ? self.infoData.maritalName : PlaceHolder2];
    //生日
    HK_SeclectFormModel *form8 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"生日"
                                  value:self.infoData.birthday
                                  postKey:@"birthday"
                                  placeHolder:self.infoData.birthday ? self.infoData.birthday : PlaceHolder2];
    //星座
    HK_SeclectFormModel *form9 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"星座"
                                  value:self.infoData.constellation
                                  postKey:@"constellation"
                                  placeHolder:self.infoData.constellationName ? self.infoData.constellationName : PlaceHolder2];
    //体重
    HK_SeclectFormModel *form10 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"体重"
                                  value:self.infoData.weight
                                  postKey:@"weight"
                                  placeHolder:self.infoData.weight ? self.infoData.weight : PlaceHolder2];
    //兴趣爱好
    HK_TextFieldFormModel *form11 = [HK_TextFieldFormModel
                                    formModelWithCellTitle:@"兴趣爱好"
                                    value:self.infoData.hobby
                                    postKey:@"hobby"
                                    placeHolder:PlaceHolder1];
    
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1,form2,form3,form4,form5,form6,form7,form8,form9,form10,form11]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}

//初始化数据
- (void)initData {
    [self section0];
}

- (void)viewDidLoad {
    self.title = @"编辑个人资料";
    self.rightItemTitle = @"保存";
    [super viewDidLoad];
}

//重写 cell 点击处理
- (void)handleTableClick:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [super handleTableClick:tableView indexPath:indexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
