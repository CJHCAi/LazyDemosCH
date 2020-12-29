//
//  HKUpdateUserExperienceViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateUserExperienceViewController.h"
#import "HK_MyApplyTool.h"
@interface HKUpdateUserExperienceViewController ()

@end

@implementation HKUpdateUserExperienceViewController

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
    [HK_MyApplyTool UpdateUserEXWithDic:self.dataDict withInfoData:self.infoData SuccessBlock:^(id res) {
        if (self.uploadSuccessBlock) {
            self.uploadSuccessBlock();
        }
        //成功
        [self.navigationController popViewControllerAnimated:YES];
    } andFial:^(NSString *msg) {
         [SVProgressHUD showInfoWithStatus:msg];
    }];
}
//删除
- (void)delButtonClick {
    [HK_MyApplyTool DeleteEXWithId:self.infoData.experienceId SuccessBlock:^(id res) {
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
    // 公司名称
    HK_TextFieldFormModel *form0 = [HK_TextFieldFormModel
                                    formModelWithCellTitle:@"公司名称"
                                    value:self.infoData.corporateName
                                    postKey:@"corporateName"
                                    placeHolder:PlaceHolder2];
    
    //职位
    HK_TextFieldFormModel *form1 = [HK_TextFieldFormModel
                                    formModelWithCellTitle:@"职位"
                                    value:self.infoData.job
                                    postKey:@"job"
                                    placeHolder:PlaceHolder2];
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}

//第1区数据
- (void)section1 {
    //入职时间
    HK_SeclectFormModel *form0 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"入职时间"
                                  value:self.infoData.entryDate
                                  postKey:@"entryDate"
                                  placeHolder:self.infoData.entryDate ? self.infoData.entryDate : PlaceHolder2];
    
    //离职时间
    HK_SeclectFormModel *form1 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"离职时间"
                                  value:self.infoData.outDate
                                  postKey:@"outDate"
                                  placeHolder:self.infoData.outDate ? self.infoData.outDate : PlaceHolder2];
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}

//第1区数据
- (void)section2 {
    //工作描述
    HK_TextViewFormModel *form0 = [HK_TextViewFormModel
                                  formModelWithCellTitle:@"工作描述"
                                  value:self.infoData.workContent
                                  postKey:@"workContent"
                                  placeHolder:@"请描述您的工作内容"];

    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0]];
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
}

- (void)viewDidLoad {
    self.title = @"工作经历";
    self.rightItemTitle = @"保存";
    [super viewDidLoad];
    if (self.infoData) {
        [self addUI];
    }
}

- (void)addUI {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    UIButton *delButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                       frame:CGRectMake(15, 26, kScreenWidth-15*2, 49)
                                                       taget:self
                                                      action:@selector(delButtonClick)
                                                  supperView:footerView];
    [delButton setTitle:@"删除" forState:UIControlStateNormal];
    delButton.backgroundColor = UICOLOR_HEX(0xc5594e);
    delButton.titleLabel.font = PingFangSCRegular16;
    self.tableView.tableFooterView = footerView;
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


@end
