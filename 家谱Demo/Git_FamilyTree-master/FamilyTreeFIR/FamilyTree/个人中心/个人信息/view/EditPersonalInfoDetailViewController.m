//
//  EditPersonalInfoDetailViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/16.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "EditPersonalInfoDetailViewController.h"
#import "CommonNavigationViews.h"
#import "NSString+valiMobile.h"
#import "NSString+valiEmail.h"
#import "NSString+valiIdentityCard.h"

@interface EditPersonalInfoDetailViewController()
/** 白色背景视图*/
@property (nonatomic, strong) UIView *bgView;
/** 修改文本框*/
@property (nonatomic, strong) UITextField *detailTF;
@end

@implementation EditPersonalInfoDetailViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    CommonNavigationViews *navi = [[CommonNavigationViews alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64) title:[NSString stringWithFormat:@"更改%@", self.detailStr] image:MImage(@"chec")];
    [self.view addSubview:navi];
    UIImageView *bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
    bgIV.image = MImage(@"bg");
    bgIV.userInteractionEnabled = YES;
    [self.view addSubview:bgIV];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0.04375*CGRectW(bgIV),0.022*CGRectH(bgIV),0.91875*CGRectW(bgIV), 0.3143*CGRectH(bgIV))];
    self.bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    [bgIV addSubview:self.bgView];
    [self initmainView];
}

-(void)initmainView{
    self.detailTF = [[UITextField alloc]initWithFrame:CGRectMake(0.0561*CGRectW(self.bgView), 0.1154*CGRectH(self.bgView), 0.8878*CGRectW(self.bgView), 0.2308*CGRectH(self.bgView))];
    self.detailTF.text = self.TFStr;
    self.detailTF.layer.borderColor = LH_RGBCOLOR(219, 219, 219).CGColor;
    self.detailTF.layer.borderWidth = 1;
    [self.bgView addSubview:self.detailTF];
    
    UILabel *tipLB = [[UILabel alloc]initWithFrame:CGRectMake(CGRectX(self.detailTF), CGRectYH(self.detailTF)+8, CGRectW(self.detailTF), 0.1049*CGRectH(self.bgView))];
    tipLB.text = [NSString stringWithFormat:@"请输入您的%@",[self returnTipStr:self.detailStr]];
    tipLB.textColor = LH_RGBCOLOR(219, 219, 219);
    [self.bgView addSubview:tipLB];
    
    UIButton *sureEditBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectX(self.detailTF), 0.6294*CGRectH(self.bgView), CGRectW(self.detailTF), CGRectH(self.detailTF))];
    [sureEditBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    sureEditBtn.backgroundColor = LH_RGBCOLOR(75, 88, 91);
    [sureEditBtn addTarget:self action:@selector(clickSureEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:sureEditBtn];
    
}

-(void)clickSureEditBtn:(UIButton *)sender{
    MYLog(@"确认修改");
    if ([self.detailStr isEqualToString:@"昵称"]) {
        [USERDEFAULT setObject:self.detailTF.text forKey:MeNickName];
        [self.delegate EditPersonalInfoDetailViewController:self withTitle:self.detailStr withDetail:self.detailTF.text];
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.detailStr isEqualToString:@"手机"]) {
        if ([[NSString valiMobile:self.detailTF.text] isEqualToString:@""]) {
            MYLog(@"号码正确");
            [self.delegate EditPersonalInfoDetailViewController:self withTitle:self.detailStr withDetail:self.detailTF.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SXLoadingView showAlertHUD:[NSString valiMobile:self.detailTF.text] duration:1];
        }
    }else if ([self.detailStr isEqualToString:@"邮箱"]){
        if ([NSString validateEmail:self.detailTF.text]) {
            [self.delegate EditPersonalInfoDetailViewController:self withTitle:self.detailStr withDetail:self.detailTF.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SXLoadingView showAlertHUD:@"请输入正确的邮箱" duration:1];
        }
    }else if ([self.detailStr isEqualToString:@"证件末6位"]){
        if ([NSString validateIdentityCard:self.detailTF.text]) {
            [self.delegate EditPersonalInfoDetailViewController:self withTitle:self.detailStr withDetail:self.detailTF.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [SXLoadingView showAlertHUD:@"请输入正确的身份证号" duration:1];
        }
    }else{
        [self.delegate EditPersonalInfoDetailViewController:self withTitle:self.detailStr withDetail:self.detailTF.text];
        [self.navigationController popViewControllerAnimated:YES];
    }

    
    
//    //上传数据
//    NSDictionary *logDic = @{
//                             @"meaccount":[USERDEFAULT valueForKey:UserAccount],
//                             [self returnRequestData:self.detailStr]:self.detailTF.text
//    };
//    [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeEditProfile success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
//        MYLog(@"%@",jsonDic[@"message"]);
//        if (succe) {
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            
//        }
//    } failure:^(NSError *error) {
//        MYLog(@"失败---%@",error.description);
//    }];

    
    
    
}

-(NSString *)returnTipStr:(NSString *)str{
    if ([str isEqualToString:@"手机"]) {
        return @"手机号";
    }
    if ([str isEqualToString:@"邮箱"]) {
        return @"邮箱地址";
    }
    if ([str isEqualToString:@"姓名"]) {
        return @"真实姓名";
    }
    if ([str isEqualToString:@"证件末6位"]) {
        return @"证件号";
    }
    return str;
}
//
//-(NSString *)returnRequestData:(NSString *)str{
//    if ([str isEqualToString:@"手机"]) {
//        return @"mobile";
//    }
//    if ([str isEqualToString:@"邮箱"]) {
//        return @"email";
//    }
//    if ([str isEqualToString:@"姓名"]) {
//        return @"mename";
//    }
//    if ([self.detailStr isEqualToString:@"昵称"]) {
//        return @"menickname";
//    }
//    if ([self.detailStr isEqualToString:@"证件末6位"]) {
//        return @"mecardnum";
//    }
//    return @"";
//}

@end
