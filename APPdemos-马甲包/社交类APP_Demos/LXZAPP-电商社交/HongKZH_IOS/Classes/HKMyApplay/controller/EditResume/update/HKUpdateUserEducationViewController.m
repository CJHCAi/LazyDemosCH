//
//  HKUpdateUserEducationViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/24.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKUpdateUserEducationViewController.h"
#import "HK_MyApplyTool.h"
@interface HKUpdateUserEducationViewController ()

@end

@implementation HKUpdateUserEducationViewController

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
    [HK_MyApplyTool UpdateEDuWithDic:self.dataDict withInfoData:self.infoData SuccessBlock:^(id res) {
        if (self.uploadSuccessBlock) {
            self.uploadSuccessBlock();
        }
        //成功
        [self.navigationController popViewControllerAnimated:YES];
        
    } andFial:^(NSString *msg) {
        [EasyShowTextView showText:msg];
    }];
}
//删除
- (void)delButtonClick {
    [HK_MyApplyTool DeleteEduWithId:self.infoData.educatioId SuccessBlock:^(id res) {
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
    //学校名称
    HK_TextFieldFormModel *form0 = [HK_TextFieldFormModel
                                  formModelWithCellTitle:@"学校名称"
                                  value:self.infoData.graduate
                                  postKey:@"graduate"
                                  placeHolder:PlaceHolder2];
    
    //所学专业
    HK_TextFieldFormModel *form1 = [HK_TextFieldFormModel
                                  formModelWithCellTitle:@"所学专业"
                                  value:self.infoData.major
                                  postKey:@"major"
                                  placeHolder:PlaceHolder2];
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}

//第1区数据
- (void)section1 {
    //毕业年份
    HK_SeclectFormModel *form0 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"毕业年份"
                                  value:self.infoData.graduationTime
                                  postKey:@"graduationTime"
                                  placeHolder:self.infoData.graduationTime ? self.infoData.graduationTime : PlaceHolder2];
    
    //学历
    HK_SeclectFormModel *form1 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"学历"
                                  value:self.infoData.education
                                  postKey:@"education"
                                  placeHolder:self.infoData.educationName ? self.infoData.educationName : PlaceHolder2];
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}

//初始化数据
- (void)initData {
    [self section0];
    [self section1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    self.title = @"教育经历";
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
