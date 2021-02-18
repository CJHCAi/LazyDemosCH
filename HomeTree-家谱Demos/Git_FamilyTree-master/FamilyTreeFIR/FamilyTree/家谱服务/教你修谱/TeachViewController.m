//
//  TeachViewController.m
//  FamilyTree
//
//  Created by 王子豪 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "TeachViewController.h"
#import "NSString+valiMobile.h"
@interface TeachViewController ()<UITextFieldDelegate>
/**姓名*/
@property (nonatomic,strong) UITextField *nameTF;

/**电话*/
@property (nonatomic,strong) UITextField *phoneNumTF;

@property (nonatomic,strong) UIScrollView *scrollView; /*背景滚动*/


@end

@implementation TeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self initData];
    [self initUI];
}
#pragma mark *** 初始化数据 ***
-(void)initData{
    
}
#pragma mark *** 初始化界面 ***
-(void)initUI{
    
    self.view.backgroundColor = LH_RGBCOLOR(236, 236, 236);
    //流程图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, 818*AdaptationWidth())];
    imageView.image = MImage(@"jnxp_bg");
    imageView.userInteractionEnabled = true;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondtTap)];
    [imageView addGestureRecognizer:tap];
    
    //更多信息
    UIView *moreInfo = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectYH(imageView)+10*AdaptationWidth(), Screen_width, 220*AdaptationWidth())];
    moreInfo.backgroundColor = [UIColor whiteColor];
    
    UILabel *moreLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(46, 30, 500, 21)];
    moreLabel.text = @"了解更多修谱信息，请留下您的：";
    moreLabel.font = MFont(13);
    moreLabel.textAlignment = 0;
    [moreInfo addSubview:moreLabel];
    
    NSArray *arr = @[@"姓名:",@"电话:"];
    for (int idx = 0; idx<2; idx++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(86*AdaptationWidth(), CGRectYH(moreLabel)+15*AdaptationWidth()+idx*40*AdaptationWidth(), 60*AdaptationWidth(), 40*AdaptationWidth())];
        label.text = arr[idx];
        label.font = MFont(25*AdaptationWidth());
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectXW(label), CGRectY(label), 250*AdaptationWidth(), 40*AdaptationWidth())];
        textField.delegate = self;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectXW(label), CGRectY(label)+textField.bounds.size.height-1, textField.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor blackColor];
        
        textField.font = label.font;
        [moreInfo addSubview:label];
        [moreInfo addSubview:textField];
        [moreInfo addSubview:lineView];
        if (idx==0) {
            self.nameTF = textField;
        }else{
            self.phoneNumTF = textField;
        }
    }
    
    //提交按钮
    UIButton *commitBtn = [[UIButton alloc] initWithFrame:AdaptationFrame(415, 88, 70, 60)];
    commitBtn.layer.cornerRadius = 5;
    commitBtn.backgroundColor = LH_RGBCOLOR(75, 88, 91);
    [commitBtn setTitle:@"提交" forState:0];
    commitBtn.titleLabel.font = WFont(27);
    [commitBtn addTarget:self action:@selector(respondsToCMTBtn) forControlEvents:UIControlEventTouchUpInside];
    [moreInfo addSubview:commitBtn];
    
    UILabel *GMLabel = [[UILabel alloc ]initWithFrame:AdaptationFrame(86, CGRectYH(moreLabel)/AdaptationWidth()+103, 500, 20)];
    GMLabel.font = MFont(11);
    GMLabel.text = @"我们的客服MM会在半个小时内联系您。";
    GMLabel.textAlignment = 0;
    [moreInfo addSubview:GMLabel];
    
    UIScrollView *bacScreView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Screen_width, Screen_height-64-self.tabBarController.tabBar.bounds.size.height)];
    bacScreView.contentSize = CGSizeMake(Screen_width, CGRectGetMaxY(moreInfo.frame));
    bacScreView.bounces = false;
    
    [self.view addSubview:bacScreView];
    [bacScreView addSubview:imageView];
    [bacScreView addSubview:moreInfo];
    self.scrollView = bacScreView;
    [self.view bringSubviewToFront:self.comNavi];
    
}
#pragma mark *** UITextfieldDelegate ***
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2f animations:^{
        
        self.scrollView.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y-216);
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.2f animations:^{
        self.scrollView.center = CGPointMake(self.scrollView.center.x, self.scrollView.center.y+216);

    }];
}
#pragma mark *** events ***
-(void)respondsToCMTBtn{
    NSLog(@"name-%@,phonen-%@", self.nameTF.text,self.phoneNumTF.text);
    if (!IsNilString([NSString valiMobile:self.phoneNumTF.text])) {
        [SXLoadingView showAlertHUD:[NSString valiMobile:self.phoneNumTF.text] duration:0.5];
        return;
    }
    
    [TCJPHTTPRequestManager POSTWithParameters:@{@"ZqMemberid":GetUserId,
                                                @"ZqGeid":@"",
                                                @"ZqGemeid":@"",
                                                @"ZqType":@"JNXP",
                                                @"ZqTitle":@"",
                                                @"ZqBrief":@"",
                                                @"ZqSignificance":@"",
                                                @"ZqMoney":@"",
                                                @"Sx":@"0",
                                                @"ZqContacts":self.nameTF.text,
                                                @"ZqTel":self.phoneNumTF.text} requestID:GetUserId requestcode:kRequestCodeCreateZqhz success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                    if (succe) {
                                                        [SXLoadingView showAlertHUD:@"已提交信息，请耐心等待" duration:0.5];
                                                    }
                                                } failure:^(NSError *error) {
                                                    
                                                }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)respondtTap{
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
[self.view endEditing:YES];}
@end
