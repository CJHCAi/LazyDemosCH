//
//  EditPasswordViewController.m
//  FamilyTree
//
//  Created by 姚珉 on 16/6/23.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "EditPasswordViewController.h"

@interface EditPasswordViewController()
/** 白色背景视图*/
@property (nonatomic, strong) UIView *bgView;
/** 原密码文本*/
@property (nonatomic, strong) UITextField *oldPasswordTX;
/** 新密码文本*/
@property (nonatomic, strong) UITextField *nPasswordTX;
/** 确认密码文本*/
@property (nonatomic, strong) UITextField *surePasswordTX;
@end

@implementation EditPasswordViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    CommonNavigationViews *navi = [[CommonNavigationViews alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 64) title:[NSString stringWithFormat:@"更改%@", self.detailStr] image:MImage(@"chec")];
    [self.view addSubview:navi];
    UIImageView *bgIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-49)];
    bgIV.image = MImage(@"bg");
    bgIV.userInteractionEnabled = YES;
    [self.view addSubview:bgIV];
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0.04375*CGRectW(bgIV),0.022*CGRectH(bgIV),0.91875*CGRectW(bgIV), 0.5*CGRectH(bgIV))];
    self.bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    [bgIV addSubview:self.bgView];
    [self initmainView];
}

-(void)initmainView{
    NSArray *tipArr = @[@"原密码",@"新密码",@"确认密码"];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0.0561*CGRectW(self.bgView), 0.05*CGRectH(self.bgView)+0.2*CGRectH(self.bgView)*i, 0.2*CGRectW(self.bgView), 0.15*CGRectH(self.bgView))];
        label.text = tipArr[i];
        label.font = MFont(14);
        [self.bgView addSubview:label];
    }
    
    self.oldPasswordTX = [[UITextField alloc]initWithFrame:CGRectMake(0.3*CGRectW(self.bgView), 0.05*CGRectH(self.bgView), 0.6*CGRectW(self.bgView), 0.15*CGRectH(self.bgView))];
    self.oldPasswordTX.text = self.TFStr;
    self.oldPasswordTX.layer.borderColor = LH_RGBCOLOR(219, 219, 219).CGColor;
    self.oldPasswordTX.layer.borderWidth = 1;
    self.oldPasswordTX.secureTextEntry = YES;
    [self.bgView addSubview:self.oldPasswordTX];
    
    self.nPasswordTX = [[UITextField alloc]initWithFrame:CGRectMake(0.3*CGRectW(self.bgView), 0.05*CGRectH(self.bgView)+0.2*CGRectH(self.bgView), 0.6*CGRectW(self.bgView), 0.15*CGRectH(self.bgView))];
    self.nPasswordTX.layer.borderColor = LH_RGBCOLOR(219, 219, 219).CGColor;
    self.nPasswordTX.layer.borderWidth = 1;
    self.nPasswordTX.secureTextEntry = YES;
    [self.bgView addSubview:self.nPasswordTX];
    
    self.surePasswordTX= [[UITextField alloc]initWithFrame:CGRectMake(0.3*CGRectW(self.bgView), 0.05*CGRectH(self.bgView)+0.4*CGRectH(self.bgView), 0.6*CGRectW(self.bgView), 0.15*CGRectH(self.bgView))];
    self.surePasswordTX.layer.borderColor = LH_RGBCOLOR(219, 219, 219).CGColor;
    self.surePasswordTX.layer.borderWidth = 1;
    self.surePasswordTX.secureTextEntry = YES;
    [self.bgView addSubview:self.surePasswordTX];

    
    
    
    UIButton *sureEditBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.0561*CGRectW(self.bgView), 0.65*CGRectH(self.bgView), 0.8878*CGRectW(self.bgView), 0.18*CGRectH(self.bgView))];
    [sureEditBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    sureEditBtn.backgroundColor = LH_RGBCOLOR(75, 88, 91);
    [sureEditBtn addTarget:self action:@selector(clickSureEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:sureEditBtn];
    
}

-(void)clickSureEditBtn:(UIButton *)sender{
    MYLog(@"确认修改");
    if (![self.oldPasswordTX.text isEqualToString:[USERDEFAULT valueForKey:UserPassword]]) {
        [SXLoadingView showAlertHUD:@"旧密码输入错误" duration:1];
    }else if(![self.nPasswordTX.text isEqualToString:self.surePasswordTX.text]) {
        [SXLoadingView showAlertHUD:@"两次输入密码不一致" duration:1];
    }else{
        //上传数据
        NSDictionary *logDic = @{
                                 @"user":[USERDEFAULT valueForKey:UserAccount],
                                 @"password":[USERDEFAULT valueForKey:UserPassword],
                                 @"newpass":self.nPasswordTX.text
                                 };
        WK(weakSelf);
        [TCJPHTTPRequestManager POSTWithParameters:logDic requestID:GetUserId requestcode:kRequestCodeUpdatepswd success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
            if (succe) {
                //[SXLoadingView showAlertHUD:@"更改成功" duration:0.5];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }else{
                
            }
        } failure:^(NSError *error) {
            MYLog(@"失败---%@",error.description);
        }];
    }
    
    
    
    
    
    
    
}
@end

