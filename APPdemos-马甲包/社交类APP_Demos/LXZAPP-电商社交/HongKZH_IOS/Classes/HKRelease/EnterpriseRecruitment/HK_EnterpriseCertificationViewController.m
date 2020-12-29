//
//  HK_EnterpriseCertificationViewController.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HK_EnterpriseCertificationViewController.h"

@interface HK_EnterpriseCertificationViewController ()

@end

@implementation HK_EnterpriseCertificationViewController

- (void)dealloc {
    DLog(@"%s",__func__);
}

//第0区数据
- (void)section0 {
    HK_TextFieldFormModel *form0 = [HK_TextFieldFormModel formModelWithCellTitle:@"您的姓名" value:nil postKey:@"userName" placeHolder:PlaceHolder1];
    HK_TextFieldFormModel *form1 = [HK_TextFieldFormModel formModelWithCellTitle:@"您的职务" value:nil postKey:@"duties" placeHolder:PlaceHolder1];
    HK_TextFieldFormModel *form2 = [HK_TextFieldFormModel formModelWithCellTitle:@"接收简历邮箱" value:nil postKey:@"hrEmail" placeHolder:PlaceHolder1];
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1,form2]];
    
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:@"1/2企业基本资料填写" footer:nil formItems:formItems];
    [self.groups addObject:section];
}
//第1区数据
- (void)section1 {
    HK_TextFieldFormModel *form0 = [HK_TextFieldFormModel formModelWithCellTitle:@"公司全称" value:nil postKey:@"name" placeHolder:PlaceHolder1];
    HK_TextFieldFormModel *form1 = [HK_TextFieldFormModel formModelWithCellTitle:@"公司简称" value:nil postKey:@"abbreviation" placeHolder:PlaceHolder1];
    HK_SeclectFormModel *form2 = [HK_SeclectFormModel formModelWithCellTitle:@"行业领域" value:nil postKey:@"industry" placeHolder:PlaceHolder2];
    HK_SeclectFormModel *form3 = [HK_SeclectFormModel formModelWithCellTitle:@"公司规模" value:nil postKey:@"scale" placeHolder:PlaceHolder2];
    
    HK_SeclectFormModel *form4 = [HK_SeclectFormModel formModelWithCellTitle:@"发展阶段" value:nil postKey:@"stage" placeHolder:PlaceHolder2];
    
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0,form1,form2,form3,form4]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}
//第2区数据
- (void)section2 {
    HK_LogoFormModel *form0 = [HK_LogoFormModel formModelWithCellTitle:@"公司Logo" value:nil postKey:@"headImg"];
    form0.cellHeight = 70.f;
    NSMutableArray *formItems = [NSMutableArray arrayWithArray:@[form0]];
    HK_SectionModel *section = [HK_SectionModel modelWithHeader:nil footer:nil formItems:formItems];
    [self.groups addObject:section];
}

//导航右侧按钮点击
- (void)nextStep {
    [super nextStep];
    //通过所有验证,跳转到第二步验证
    HK_CardsCertificationViewController *vc = [HK_CardsCertificationViewController new];
    vc.dataDict = self.dataDict;
    vc.images = self.images;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewDidLoad {
    self.title = @"企业认证";
    self.rightItemTitle = @"下一步";
    [super viewDidLoad];
}

//初始化数据
- (void)initData {
    [self section0];    //第0区数据
    [self section1];    //第1区数据
    [self section2];    //第2区数据
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
