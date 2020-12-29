//
//  HKEnterpriseInfoViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/17.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEnterpriseInfoViewController.h"
#import "HKEnterpriseIntroduceViewController.h"

@interface HKEnterpriseInfoViewController ()

@end

@implementation HKEnterpriseInfoViewController

//导航右侧按钮点击
- (BOOL)nextStep {
    BOOL success = [super nextStep];
    DLog(@"保存企业信息");
    if (success) {
        [self uploadData];
        return YES;
    } else {
        return NO;
    }
}

#pragma mark 网络请求

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //设置不透明导航栏
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:0];
    [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark 接口
//上传接口
- (void)uploadData {
    
    [self.dataDict setObject:self.enterpriseId forKey:@"enterpriseId"];
    [self.dataDict setObject:HKUSERLOGINID forKey:@"loginUid"];
//    [self Business_Request:BusinessRequestType_get_updateAuthenticationEnterpriseInfo dic:self.dataDict cache:NO];

}


//-(void)Business_Request_State:(BusinessRequestType)type statusCode:(NSInteger)statusCode responseJsonObject:(id)jsonObj{
//    
//    if (jsonObj) {
//        NSString *code = [jsonObj objectForKey:@"code"];
//        if (code && [code integerValue] == 1) {
//            //失败
//            [SVProgressHUD showInfoWithStatus:[jsonObj objectForKey:@"msg"]];
//        } else {
//            //成功
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    } else {
//        [SVProgressHUD showInfoWithStatus:@"网络错误"];
//    }
//}

#pragma mark UI数据封装

//第0区数据
- (void)section0 {
    //公司全称
    HK_UnableModifyFormModel *form0 = [HK_UnableModifyFormModel
                                       formModelWithCellTitle:@"公司全称"
                                       value:self.enterpriseInfoData.name
                                       postKey:nil
                                       placeHolder:self.enterpriseInfoData.name];
    form0.required = NO;
    
    //公司简称
    HK_UnableModifyFormModel *form1 = [HK_UnableModifyFormModel
                                       formModelWithCellTitle:@"公司简称"
                                       value:self.enterpriseInfoData.abbreviation
                                       postKey:nil
                                       placeHolder:self.enterpriseInfoData.abbreviation];
    form1.required = NO;
    
    //行业领域
    HK_UnableModifyFormModel *form2 = [HK_UnableModifyFormModel
                                       formModelWithCellTitle:@"行业领域"
                                       value:self.enterpriseInfoData.industry
                                       postKey:nil
                                       placeHolder:self.enterpriseInfoData.industryName];
    form2.required = NO;
 
    //公司规模
    HK_SeclectFormModel *form3 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"公司规模"
                                  value:self.enterpriseInfoData.scale
                                  postKey:@"scale" placeHolder:self.enterpriseInfoData.scaleName == nil ? PlaceHolder2 : self.enterpriseInfoData.scaleName];
    
    //发展阶段
    HK_SeclectFormModel *form4 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"发展阶段"
                                  value:self.enterpriseInfoData.stage
                                  postKey:@"stage"
                                  placeHolder:self.enterpriseInfoData.stageName == nil ? PlaceHolder2 : self.enterpriseInfoData.stageName];
    
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1,form2,form3,form4]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}

//第1区数据
- (void)section1 {
    //先去sd读取图片保存到 self.images 中
    __block UIImage *logoImg = nil;
    SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
    [manager loadImageWithURL:[NSURL URLWithString:self.enterpriseInfoData.headImg] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        logoImg = image;
    }];
    
    NSData * value = [[HK_Tool GetTimeStamp] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",[NSString stringWithFormat:@"%@",[value MD5String]]];
    
    HK_UploadImagesModel *model = [[HK_UploadImagesModel alloc] init];
    model.image = logoImg;
    model.fileName = imageName;
    model.uploadKey = @"headImg";
    [self.images setObject:model forKey:model.uploadKey];
  
    
    HK_LogoFormModel *form0 = [HK_LogoFormModel
                               formModelWithCellTitle:@"公司Logo"
                               value:model
                               postKey:@"headImg"];
    form0.cellHeight = 70.f;
    self.logoModel = form0;
    
    //公司介绍
    HK_SeclectFormModel *form1 = [HK_SeclectFormModel
                                  formModelWithCellTitle:@"公司介绍"
                                  value:self.enterpriseInfoData.introduce
                                  postKey:@"introduce"
                                  placeHolder:self.enterpriseInfoData.introduce == nil ? PlaceHolder1 : self.enterpriseInfoData.introduce];
    
    //所在地区
    HK_SeclectFormModel *form2 = [HK_SeclectFormModel
                                    formModelWithCellTitle:@"所在地区"
                                    value:self.enterpriseInfoData.areaId
                                    postKey:@"areaId"
                                    placeHolder:self.enterpriseInfoData.areaName == nil ? PlaceHolder2 : self.enterpriseInfoData.areaName];
    //详细地址
    HK_TextFieldFormModel *form3 = [HK_TextFieldFormModel
                                    formModelWithCellTitle:@"详细地址"
                                    value:self.enterpriseInfoData.address
                                    postKey:@"address"
                                    placeHolder:self.enterpriseInfoData.address == nil ? PlaceHolder1 : self.enterpriseInfoData.address];
    //公司网址
    HK_TextFieldFormModel *form4 = [HK_TextFieldFormModel
                                    formModelWithCellTitle:@"公司网址"
                                    value:self.enterpriseInfoData.website
                                    postKey:@"website"
                                    placeHolder:self.enterpriseInfoData.website == nil ? PlaceHolder1 : self.enterpriseInfoData.website];
    
    //企业邮箱
    HK_TextFieldFormModel *form5 = [HK_TextFieldFormModel
                                    formModelWithCellTitle:@"企业邮箱"
                                    value:self.enterpriseInfoData.mailbox
                                    postKey:@"mailbox"
                                    placeHolder:self.enterpriseInfoData.mailbox == nil ? PlaceHolder1 : self.enterpriseInfoData.mailbox];

    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1,form2,form3,form4,form5]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}


//初始化数据
- (void)initData {
    [self section0];
    [self section1];
}

- (void)viewDidLoad {
    self.title = @"公司信息";
    self.rightItemTitle = @"保存";
    [super viewDidLoad];
}

//重写 cell 点击处理,主要处理公司介绍跳转
- (void)handleTableClick:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    [super handleTableClick:tableView indexPath:indexPath];
    
    HK_SectionModel *sectionModel = self.groups[indexPath.section];
    HK_FormModel *formModel = sectionModel.formItems[indexPath.row];
    //--------.如果是带箭头的 cell 有下步操作的 cell--------
    if ([formModel isKindOfClass:[HK_SeclectFormModel class]] )
    {
        HK_SeclectFormModel *seclectFormModel = (HK_SeclectFormModel *)formModel;
        if ([formModel.cellTitle isEqualToString:@"公司介绍"]) {
            HKEnterpriseIntroduceViewController *vc = [[HKEnterpriseIntroduceViewController alloc] init];
            vc. formModel = seclectFormModel;
            vc.source = 1;
            [self.navigationController pushViewController:vc animated:YES];
        } 
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
