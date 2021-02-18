//
//  FindPassViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/5/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "FindPassViewController.h"
#import "FindPassView.h"
@interface FindPassViewController ()

@property (nonatomic,strong) CommonNavigationViews *naviView; /*头部导航栏*/

@property (nonatomic,strong) FindPassView *phoneNum; /*手机号*/

@property (nonatomic,strong) UIView *whiteBackView; /*白色半透明背景*/

@property (nonatomic,strong) FindPassView *verificationCode; /*验证码*/

@property (nonatomic,strong) FindPassView *nPass; /*新密码*/

@property (nonatomic,strong) FindPassView *nSurePass; /*确认密码*/

/** 验证码*/
@property (nonatomic, assign) NSInteger verification;

@end

@implementation FindPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.view addSubview:self.naviView];
    
    [self initBackImage];
    
    [self initWiteBack];
    
    [self initInputTextView];
    
    //布局
    self.whiteBackView.sd_layout.heightIs(300).topSpaceToView(self.naviView,15).leftSpaceToView(self.view,20).rightSpaceToView(self.view,20);
        
}


#pragma mark *** 初始化方法 ***

//背景图
-(void)initBackImage{
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, StatusBar_Height+NavigationBar_Height, Screen_width, Screen_height-StatusBar_Height-NavigationBar_Height)];
    backImage.image = [UIImage imageNamed:@"loginbg"];
    [self.view addSubview:backImage];
    
}
//白色半透明背景
-(void)initWiteBack{
    UIView *view = [[UIView alloc] init];
    
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    [self.view addSubview:view];
    self.whiteBackView = view;
    
    
}
//手机号到确认密码控件
-(void)initInputTextView{
    NSArray *titles = @[@"手机号",@"验证码",@"新密码",@"确认密码"];
    NSArray *imageNames = @[@"tel",@"yanzheng",@"suo",@"suo"];
//    NSArray *findViews = @[self.phoneNum,self.verificationCode,self.nPass,self.nSurePass];
    NSArray *isSafe = @[@(true),@(true),@(false),@(false)];
    for (int i = 0; i<titles.count; i++) {
        FindPassView *theView = [[FindPassView alloc] initWithFrame:CGRectMake(15, 13+(40+13)*i, 0.8*Screen_width, 40) headImage:MImage(imageNames[i]) isSafe:isSafe[i] hasArrows:NO withplaceholderStr:titles[i]];
        [self.whiteBackView addSubview:theView];
        
        theView.sd_layout.leftSpaceToView(self.whiteBackView,15).rightSpaceToView(self.whiteBackView,15);
        
        switch (i) {
            case 0:
                self.phoneNum = theView;
                break;
            case 1:
            {
                self.verificationCode = theView;
                
                //获取验证码按钮
                UIButton *findVer = [[UIButton alloc] init];
                [findVer setTitle:@"获取验证码"forState:0];
                findVer.backgroundColor = LH_RGBCOLOR(74, 88, 91);
                findVer.titleLabel.font = MFont(13);
                [findVer addTarget:self action:@selector(respondsToFindVerBtn) forControlEvents:UIControlEventTouchUpInside];
                
                [self.verificationCode addSubview:findVer];
                
                findVer.sd_layout.widthIs(80).topSpaceToView(self.verificationCode,5).bottomSpaceToView(self.verificationCode,5).rightSpaceToView(self.verificationCode,5);
            }
                break;
            case 2:
                self.nPass = theView;
                break;
            case 3:
                self.nSurePass = theView;
                break;
            default:
                break;
        }
    }

    //确认修改按钮
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setTitle:@"确认修改" forState:0];
    sureBtn.backgroundColor = LH_RGBCOLOR(74, 88, 91);
    sureBtn.titleLabel.font = MFont(17);
    [sureBtn addTarget:self action:@selector(respondsToSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.whiteBackView addSubview:sureBtn];
    
    sureBtn.sd_layout.leftSpaceToView(self.whiteBackView,15).rightSpaceToView(self.whiteBackView,15).bottomSpaceToView(self.whiteBackView,20).heightIs(40);
    
}

#pragma mark *** Events ***

-(void)respondsToFindVerBtn{
    self.verification =  arc4random() % 10000 + (arc4random()%9+1)*100000;
    MYLog(@"验证码%ld",self.verification);
    [TCJPHTTPRequestManager POSTWithParameters:@{@"mobile":self.phoneNum.inputTextView.text,@"content":[NSString stringWithFormat:@"%ld",(long)self.verification]} requestID:@0 requestcode:@"sendsms" success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
        if (succe) {
            NSLog(@"%@", responseObject);
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
 
}

-(void)respondsToSureBtn{
    
    MYLog(@"确认修改");
    
    NSString *phoneNum = self.phoneNum.inputTextView.text;
    NSString *password = self.nPass.inputTextView.text;
    NSString *surePs = self.nSurePass.inputTextView.text;
    if (![self.verificationCode.inputTextView.text isEqualToString:[NSString stringWithFormat:@"%ld",(long)self.verification]]) {
        [SXLoadingView showAlertHUD:@"验证码不正确" duration:0.5];
    }else{
        if ([password isEqualToString:surePs]) {
            [TCJPHTTPRequestManager POSTWithParameters:@{@"user":phoneNum,@"newpass":password} requestID:@0 requestcode:kRequestCodeBackPassword success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                if (succe) {
                    [Tools showAlertViewControllerAutoDissmissWithTarGet:self Message:@"修改成功" delay:1 complete:^(BOOL complete) {
                        if (complete) {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }
            } failure:^(NSError *error) {
                
            }];
        }else{
            [Tools showAlertViewControllerAutoDissmissWithTarGet:self Message:@"两次输入密码不正确" delay:1 complete:nil];
        }

    }
    
    
}

#pragma mark *** getters ***
-(CommonNavigationViews *)naviView{
    if (!_naviView) {
        _naviView = [[CommonNavigationViews alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 44+StatusBar_Height) title:@"找回密码" image:nil];
        
    }
    return _naviView;
}



@end
