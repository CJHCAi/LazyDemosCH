//
//  RegisterInfoViewController.m
//  SportForum
//
//  Created by liyuan on 4/9/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "RegisterInfoViewController.h"
#import "UIViewController+SportFormu.h"
#import "UIImageView+WebCache.h"
#import "IQKeyboardManager.h"
#import "ImageEditViewController.h"
#import "CustomMenuViewController.h"
#import "AlertManager.h"
#import "ApplicationContext.h"
#import "BindPhoneViewController.h"
#import "RecommendViewController.h"
#import "PrivateContentViewController.h"

@interface RegisterInfoViewController ()<UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation RegisterInfoViewController
{
    UITextField * _leContent;
    CSButton * _btnFinish;
    
    //Sex PickView
    UIView *m_viewSex;
    UIView * m_pickerView0;
    UIPickerView * m_pickerSelect0;
    NSArray *_arrayStore0;

    //Birthday PickView
    UIView *m_viewBirthday;
    UIView *m_pickerView1;
    UIDatePicker *m_pickerDate;
    
    NSString * _strProfileImageID;
    ImageEditViewController* _imageEditViewController;
    CustomMenuViewController* _customMenuViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generateCommonViewInParent:self.view Title:_nRegisterType == REGISTER_NIKENAME_PAGE ? @"填写昵称" : @"个人信息" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    //Create But Right Nav Btn
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    UIImageView *imgViewFinish = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [self.view addSubview:imgViewFinish];

    _btnFinish = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnFinish.frame = CGRectMake(CGRectGetMinX(imgViewFinish.frame) - 10, CGRectGetMinY(imgViewFinish.frame) - 5, 50, 45);
    _btnFinish.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_btnFinish];
    [self.view bringSubviewToFront:_btnFinish];
    
    __weak typeof (self) thisPoint = self;
    
    _btnFinish.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        [strongSelf actionNavRight];
    };
    
    if (_nRegisterType == REGISTER_NIKENAME_PAGE) {
        [imgViewFinish setImage:[UIImage imageNamed:@"nav-next-btn"]];
        [self generateNickNameView];
    }
    else
    {
        [imgViewFinish setImage:[UIImage imageNamed:_userWeiboInfo != nil ? @"nav-finish-btn" : @"nav-next-btn"]];
        [self generateUserInfoView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    
    [_leContent addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [_leContent removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"RegisterInfoViewController dealloc called!");
}

#pragma mark - Nav Control Logic

-(void)actionNavRight
{
    if(_nRegisterType == REGISTER_NIKENAME_PAGE)
    {
        if (_leContent.text.length == 0) {
            [JDStatusBarNotification showWithStatus:@"昵称不能为空！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
        
        [_leContent resignFirstResponder];
        _btnFinish.enabled = NO;
        
        [[SportForumAPI sharedInstance]accountCheckExistById:_leContent.text AccountType:login_type_nickname FinishedBlock:^(int errorCode, NSString* userId)
         {
             _btnFinish.enabled = YES;
             
             if (errorCode == 0) {
                 if (userId.length > 0) {
                     [JDStatusBarNotification showWithStatus:@"该昵称已被使用，请使用其他昵称" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                 }
                 else
                 {
                     NSMutableDictionary *regProfileDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_leContent.text, @"NickName", nil];
                     [[ApplicationContext sharedInstance] saveObject:regProfileDict byKey:@"RegProfile"];
                     
                     RegisterInfoViewController *registerInfoViewController = [[RegisterInfoViewController alloc]init];
                     registerInfoViewController.nRegisterType = REGISTER_USERINFO_PAGE;
                     registerInfoViewController.userWeiboInfo = _userWeiboInfo;
                     [self.navigationController pushViewController:registerInfoViewController animated:YES];
                 }
             }
             else
             {
                 [JDStatusBarNotification showWithStatus:@"检查数据异常" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
             }
         }];
    }
    else
    {
        UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
        UILabel *lbSexValue = (UILabel*)[viewBody viewWithTag:7000];
        UILabel *lbBirthdayValue = (UILabel*)[viewBody viewWithTag:7001];
        
        if (_strProfileImageID.length == 0) {
            [JDStatusBarNotification showWithStatus:@"头像不能为空" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        }
        else if(lbSexValue.text.length == 0)
        {
            [JDStatusBarNotification showWithStatus:@"性别不能为空" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        }
        else if(lbBirthdayValue.text.length == 0)
        {
            [JDStatusBarNotification showWithStatus:@"出生日期不能为空" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat : @"yyyy年MM月dd日"];
            
            NSDate *dateTime = [formatter dateFromString:lbBirthdayValue.text];
            
            NSMutableDictionary *regProfileDict = [[ApplicationContext sharedInstance] getObjectByKey:@"RegProfile"];
            NSMutableDictionary * regDict = [NSMutableDictionary dictionaryWithDictionary:regProfileDict];
            [regDict setObject:_strProfileImageID forKey:@"ProfileUrl"];
            [regDict setObject:lbSexValue.text forKey:@"SexType"];
            [regDict setObject:@([dateTime timeIntervalSince1970]) forKey:@"Birthday"];
            [[ApplicationContext sharedInstance] saveObject:regDict byKey:@"RegProfile"];
            
            if(_userWeiboInfo != nil)
            {
                NSString *strNickName = [regProfileDict objectForKey:@"NickName"];
                id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];    //传入获取授权信息的类型
                id process = [AlertManager showCommonProgress];
                
                [[ApplicationContext sharedInstance]createAccountWithId:_userWeiboInfo.uid password:[credential token] Type: login_type_weibo nikeName:strNickName ProfileUrl:_strProfileImageID Gender:[lbSexValue.text isEqualToString:@"男"] ? @"male" : @"female"  Birthday:[dateTime timeIntervalSince1970] FinishedBlock:^(int errorCode, NSString* strErr, NSString* strUserId)
                {
                    [AlertManager dissmiss:process];
                    
                    if (errorCode == 0) {
                        RecommendViewController *recommendViewController = [[RecommendViewController alloc]init];
                        [self.navigationController pushViewController:recommendViewController animated:NO];
                    }
                    else
                    {
                        [JDStatusBarNotification showWithStatus:strErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                    }
                }];
            }
            else
            {
                BindPhoneViewController *bindPhoneViewController = [[BindPhoneViewController alloc]init];
                bindPhoneViewController.bRegisterPhone = YES;
                bindPhoneViewController.bForgetPwd = NO;
                [self.navigationController pushViewController:bindPhoneViewController animated:YES];
            }
        }
    }
}

#pragma mark - Generate User View

-(void)generateNickNameView
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    
    UILabel *lbNickName = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 60, 30)];
    lbNickName.font = [UIFont boldSystemFontOfSize:14.0];
    lbNickName.textAlignment = NSTextAlignmentLeft;
    lbNickName.backgroundColor = [UIColor clearColor];
    lbNickName.textColor = [UIColor darkGrayColor];
    lbNickName.text = @"昵称：";
    [viewBody addSubview:lbNickName];
    
    _leContent = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxY(lbNickName.frame), 20, CGRectGetWidth(viewBody.frame) - CGRectGetMaxY(lbNickName.frame) - 10, 30)];
    _leContent.backgroundColor = [UIColor whiteColor];
    _leContent.font = [UIFont boldSystemFontOfSize:14];
    _leContent.textColor = [UIColor darkGrayColor];
    
    if (IOS7_OR_LATER) {
        _leContent.tintColor = [UIColor blueColor];
    }
    
    _leContent.clearButtonMode = UITextFieldViewModeWhileEditing;
    _leContent.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _leContent.enablesReturnKeyAutomatically = YES;
    _leContent.textAlignment = NSTextAlignmentLeft;
    _leContent.multipleTouchEnabled = YES;
    _leContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _leContent.layer.borderWidth = 1.0;
    _leContent.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _leContent.leftViewMode = UITextFieldViewModeAlways;
    [viewBody addSubview:_leContent];
    
    if (_userWeiboInfo != nil && _userWeiboInfo.nickname.length > 0) {
        _leContent.text = _userWeiboInfo.nickname;
    }
    
    UILabel *lbTips = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_leContent.frame) + 10, CGRectGetWidth(viewBody.frame) - 20, 50)];
    lbTips.font = [UIFont systemFontOfSize:14.0];
    lbTips.textAlignment = NSTextAlignmentLeft;
    lbTips.backgroundColor = [UIColor clearColor];
    lbTips.numberOfLines = 0;
    [viewBody addSubview:lbTips];
    
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"使用能够反映你形象的昵称，让更多的人能联系到你，注册即表示同意 " attributes:attribs];
    attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0], NSForegroundColorAttributeName:[UIColor colorWithRed:98.0 / 255.0 green:197.0 / 255.0 blue:255.0 / 255.0 alpha:1]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:@"<<悦动力用户协议>>" attributes:attribs];
    
    NSMutableAttributedString * strValue = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strValue appendAttributedString:strPart2Value];
    lbTips.attributedText = strValue;
    
    CSButton *btnAction = [CSButton buttonWithType:UIButtonTypeCustom];
    btnAction.backgroundColor = [UIColor clearColor];
    btnAction.frame = lbTips.frame;
    [viewBody addSubview:btnAction];
    [viewBody bringSubviewToFront:btnAction];
    
    __weak typeof (self) thisPoint = self;
    
    btnAction.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        PrivateContentViewController *privateContentViewController = [[PrivateContentViewController alloc]init];
        [strongSelf.navigationController pushViewController:privateContentViewController animated:YES];
    };
}

-(void)generateUserInfoView
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    CGRect rectPhoto = CGRectZero;
    
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(viewBody.frame) / 2 - 35, 10, 70, 70)];
    imgHead.layer.cornerRadius = 8.0;
    imgHead.clipsToBounds = YES;
    imgHead.tag = 7002;
    [viewBody addSubview:imgHead];
    
    UIImageView * imgCamera = [[UIImageView alloc] initWithFrame:CGRectMake(imgHead.frame.origin.x + 50, 50, 33, 33)];
    imgCamera.image = [UIImage imageNamed:@"camera"];
    imgCamera.tag = 7003;
    [viewBody addSubview:imgCamera];
    
    UIImageView *imgViewNoPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(viewBody.frame) / 2 - 35, 10, 70, 70)];
    [imgViewNoPhoto setImage:[UIImage imageNamed:@"register-upload-profile"]];
    imgViewNoPhoto.tag = 7004;
    [viewBody addSubview:imgViewNoPhoto];
    
    rectPhoto = imgViewNoPhoto.frame;

    NSDictionary * dictUserInfo = [_userWeiboInfo sourceData];
    NSString *strUrl = [dictUserInfo objectForKey:@"avatar_hd"];
    
    if (_userWeiboInfo != nil && strUrl.length > 0) {
        [imgHead sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        imgHead.hidden = NO;
        imgCamera.hidden = NO;
        imgViewNoPhoto.hidden = YES;
        _strProfileImageID = strUrl;
    }
    else
    {
        imgHead.hidden = YES;
        imgCamera.hidden = YES;
        imgViewNoPhoto.hidden = NO;
    }
    
    UILabel *lbPhotoName = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMidY(rectPhoto) - 15, 60, 30)];
    lbPhotoName.font = [UIFont boldSystemFontOfSize:14.0];
    lbPhotoName.textAlignment = NSTextAlignmentLeft;
    lbPhotoName.backgroundColor = [UIColor clearColor];
    lbPhotoName.textColor = [UIColor darkGrayColor];
    lbPhotoName.text = @"头像：";
    [viewBody addSubview:lbPhotoName];
    
    CSButton * btnCamera = [CSButton buttonWithType:UIButtonTypeCustom];
    btnCamera.frame = CGRectMake(rectPhoto.origin.x, rectPhoto.origin.y, 90, 90);
    [viewBody addSubview:btnCamera];
    
    __weak typeof (self) weakSelf = self;
    
    btnCamera.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf showPicSelect];
    };

    UILabel * lbSeparate1 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rectPhoto) + 20, CGRectGetWidth(viewBody.frame), 1)];
    lbSeparate1.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewBody addSubview:lbSeparate1];
    
    UILabel * lbSex = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lbSeparate1.frame) + 10, 80, 25)];
    lbSex.backgroundColor = [UIColor clearColor];
    lbSex.text = @"性别：";
    lbSex.textColor = [UIColor darkGrayColor];
    lbSex.font = [UIFont boldSystemFontOfSize:14];
    lbSex.textAlignment = NSTextAlignmentLeft;
    [viewBody addSubview:lbSex];
    
    UILabel *lbSexValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(rectPhoto), CGRectGetMinY(lbSex.frame), 120, 25)];
    lbSexValue.backgroundColor = [UIColor clearColor];
    lbSexValue.textColor = [UIColor blackColor];
    lbSexValue.font = [UIFont boldSystemFontOfSize:14];
    lbSexValue.textAlignment = NSTextAlignmentLeft;
    lbSexValue.tag = 7000;
    [viewBody addSubview:lbSexValue];
    
    if (_userWeiboInfo != nil) {
        if (_userWeiboInfo.gender == 0) {
            lbSexValue.text = @"男";
        }
        else if(_userWeiboInfo.gender == 1) {
            lbSexValue.text = @"女";
        }
    }
    
    UIImageView *arrImgView1 = [[UIImageView alloc]initWithFrame:CGRectMake(310 - 18, CGRectGetMinY(lbSeparate1.frame) + 45 / 2 - 8, 8, 16)];
    [arrImgView1 setImage:[UIImage imageNamed:@"arrow-1"]];
    [viewBody addSubview:arrImgView1];

    CSButton *btnSelectSex = [CSButton buttonWithType:UIButtonTypeCustom];
    btnSelectSex.frame = CGRectMake(0, CGRectGetMaxY(lbSeparate1.frame), viewBody.frame.size.width, 45);
    [viewBody addSubview:btnSelectSex];

    btnSelectSex.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf popPickView:strongSelf->m_viewSex PickView:strongSelf->m_pickerView0 SelectView:strongSelf->m_pickerSelect0 TagId:7000 ArrStore:strongSelf->_arrayStore0];
    };
    
    UILabel * lbSeparate2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lbSexValue.frame) + 10, CGRectGetWidth(viewBody.frame), 1)];
    lbSeparate2.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewBody addSubview:lbSeparate2];
    
    UILabel * lbBirthday = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lbSeparate2.frame) + 10, 80, 25)];
    lbBirthday.backgroundColor = [UIColor clearColor];
    lbBirthday.textColor = [UIColor darkGrayColor];
    lbBirthday.text = @"出生日期：";
    lbBirthday.font = [UIFont boldSystemFontOfSize:14];
    lbBirthday.textAlignment = NSTextAlignmentLeft;
    [viewBody addSubview:lbBirthday];
    
    UILabel *lbBirthdayValue = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbSexValue.frame), CGRectGetMinY(lbBirthday.frame), 120, 25)];
    lbBirthdayValue.backgroundColor = [UIColor clearColor];
    lbBirthdayValue.textColor = [UIColor blackColor];
    lbBirthdayValue.font = [UIFont boldSystemFontOfSize:14];
    lbBirthdayValue.textAlignment = NSTextAlignmentLeft;
    lbBirthdayValue.tag = 7001;
    [viewBody addSubview:lbBirthdayValue];
    
    if (_userWeiboInfo != nil && _userWeiboInfo.birthday.length > 0) {
        long long lBirthday = [_userWeiboInfo.birthday longLongValue];
        lbBirthdayValue.text = [[CommonUtility sharedInstance]convertBirthdayToString:lBirthday];
    }
    
    UIImageView *arrImgView2 = [[UIImageView alloc]initWithFrame:CGRectMake(310 - 18, CGRectGetMinY(lbSeparate2.frame) + 45 / 2 - 8, 8, 16)];
    [arrImgView2 setImage:[UIImage imageNamed:@"arrow-1"]];
    [viewBody addSubview:arrImgView2];
    
    CSButton *btnSelectBirthday = [CSButton buttonWithType:UIButtonTypeCustom];
    btnSelectBirthday.frame = CGRectMake(0, CGRectGetMaxY(lbSeparate2.frame), viewBody.frame.size.width, 45);
    [viewBody addSubview:btnSelectBirthday];
    
    btnSelectBirthday.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf popPickView:strongSelf->m_viewBirthday PickView:strongSelf->m_pickerView1 SelectView:nil TagId:7001 ArrStore:nil];
    };

    UILabel * lbSeparate3 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lbBirthdayValue.frame) + 10, CGRectGetWidth(viewBody.frame), 1)];
    lbSeparate3.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewBody addSubview:lbSeparate3];
    
    UILabel *lbTipsValue = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lbSeparate3.frame) + 10, 290, 40)];
    lbTipsValue.backgroundColor = [UIColor clearColor];
    lbTipsValue.textColor = [UIColor lightGrayColor];
    lbTipsValue.font = [UIFont systemFontOfSize:13];
    lbTipsValue.textAlignment = NSTextAlignmentLeft;
    lbTipsValue.text = @"为了保证用户资料真实，性别设置后不允许再次修改，请准确设置。";
    lbTipsValue.numberOfLines = 0;
    [viewBody addSubview:lbTipsValue];
    
    [self createSexPick];
    [self createBirthdayView];
}

#pragma mark - UITextField Event Logic

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.markedTextRange == nil && textField.text.length > 14) {
        textField.text = [textField.text substringToIndex:14];
    }
    else
    {
        NSString * strFixedContent = [[CommonUtility sharedInstance]disable_emoji:textField.text];
        strFixedContent = [strFixedContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if(![textField.text isEqualToString:strFixedContent])
        {
            textField.text = strFixedContent;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL bAllowWord = YES;
    
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    [newtxt replaceCharactersInRange:range withString:string];
    NSString * strFinalContent = [NSString stringWithString:newtxt];
    
    if ([newtxt length] > 14)
    {
        bAllowWord = NO;
    }
    else
    {
        NSString * strFixedContent = [[CommonUtility sharedInstance]disable_emoji:strFinalContent];
        strFixedContent = [strFixedContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if(![strFinalContent isEqualToString:strFixedContent])
        {
            bAllowWord = NO;
        }
    }
    
    return bAllowWord;
}


#pragma mark - PickView Create

-(void)createSelectPick:(UIView*)viewMain PickView:(UIView*)viewPick SelectView:(UIPickerView*)pickerView Title:(NSString*)strTitle DoneAction:(void(^)(void))doneBlock CancelAction:(void(^)(void))cancelBlock TitleAction:(void(^)(void))titleBlock
{
    viewMain.frame = [UIScreen mainScreen].bounds;
    viewMain.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    UIView *viewTapPickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewMain.frame.size.width, CGRectGetHeight(viewMain.frame) - 260)];
    viewTapPickView.backgroundColor = [UIColor clearColor];
    [viewMain addSubview:viewTapPickView];
    [viewMain bringSubviewToFront:viewTapPickView];
    
    UITapGestureRecognizer* tapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
    [viewTapPickView addGestureRecognizer:tapRecogniser];
    
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height - 260, viewMain.frame.size.width, 260);
    viewPick.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:viewPick];
    [viewMain bringSubviewToFront:viewPick];
    
    CSButton *doneButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.frame = CGRectMake(250.0f, 10.0f, 60.0f, 30.0f);
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    doneButton.actionBlock = doneBlock;
    
    CSButton *cancelButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.frame = CGRectMake(10.0f, 10.0f, 60.0f, 30.0f);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.actionBlock = cancelBlock;
    
    CSButton *titleButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [titleButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    titleButton.backgroundColor = [UIColor clearColor];
    titleButton.frame = CGRectMake((CGRectGetWidth(viewPick.frame) - 80) / 2, 10.0f, 80.0f, 30.0f);
    [titleButton setTitle:strTitle forState:UIControlStateNormal];
    titleButton.actionBlock = titleBlock;
    
    [viewPick addSubview:doneButton];
    [viewPick addSubview:cancelButton];
    [viewPick addSubview:titleButton];
    
    pickerView.frame = CGRectMake(0, 44, [UIScreen screenWidth], 216);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    pickerView.backgroundColor = [UIColor clearColor];
    [viewPick addSubview:pickerView];
}

-(void)createDatePick:(UIView*)viewMain PickView:(UIView*)viewPick DatePick:(UIDatePicker*)datePicker Title:(NSString*)strTitle DoneAction:(void(^)(void))doneBlock CancelAction:(void(^)(void))cancelBlock TitleAction:(void(^)(void))titleBlock
{
    viewMain.frame = [UIScreen mainScreen].bounds;
    viewMain.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    UIView *viewTapPickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewMain.frame.size.width, CGRectGetHeight(viewMain.frame) - 260)];
    viewTapPickView.backgroundColor = [UIColor clearColor];
    [viewMain addSubview:viewTapPickView];
    [viewMain bringSubviewToFront:viewTapPickView];
    
    UITapGestureRecognizer* tapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
    [viewTapPickView addGestureRecognizer:tapRecogniser];
    
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height - 260, viewMain.frame.size.width, 260);
    viewPick.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:viewPick];
    [viewMain bringSubviewToFront:viewPick];
    
    CSButton *doneButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.frame = CGRectMake(250.0f, 10.0f, 60.0f, 30.0f);
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    doneButton.actionBlock = doneBlock;
    
    CSButton *cancelButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.frame = CGRectMake(10.0f, 10.0f, 60.0f, 30.0f);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.actionBlock = cancelBlock;
    
    CSButton *titleButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [titleButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    titleButton.backgroundColor = [UIColor clearColor];
    titleButton.frame = CGRectMake((CGRectGetWidth(viewPick.frame) - 120) / 2, 10.0f, 120.0f, 30.0f);
    [titleButton setTitle:strTitle forState:UIControlStateNormal];
    titleButton.actionBlock = titleBlock;
    
    [viewPick addSubview:doneButton];
    [viewPick addSubview:cancelButton];
    [viewPick addSubview:titleButton];
    
    datePicker.frame = CGRectMake(0, 44, [UIScreen screenWidth], 216);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *_comps = [calendar components:units fromDate:[NSDate date]];
    NSInteger month = [_comps month];
    NSInteger year = [_comps year];
    NSInteger day = [_comps day];
    
    NSDateComponents *comps = [[NSDateComponents alloc]init];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setYear:year - 100];
    
    NSDate *dateMin = [calendar dateFromComponents:comps];
    datePicker.minimumDate = dateMin;
    datePicker.backgroundColor = [UIColor clearColor];
    [viewPick addSubview:datePicker];
}

-(void)createSexPick
{
    _arrayStore0 = [NSArray arrayWithObjects:@"男", @"女", nil];
    m_viewSex = [[UIView alloc]init];
    m_pickerView0 = [[UIView alloc] init];
    m_pickerSelect0 = [[UIPickerView alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    
    [self createSelectPick:m_viewSex PickView:m_pickerView0 SelectView:m_pickerSelect0 Title:@"设置性别"
                DoneAction:^void(){
                    __typeof(self) strongSelf = weakSelf;
                    UIView *viewBody = [strongSelf.view viewWithTag:GENERATE_VIEW_BODY];
                    NSInteger nRow = [strongSelf->m_pickerSelect0 selectedRowInComponent:0];
                    UILabel *lbSexValue = (UILabel*)[viewBody viewWithTag:7000];
                    lbSexValue.text = strongSelf->_arrayStore0[nRow];
                    [strongSelf hidePickView:strongSelf->m_viewSex PickView:strongSelf->m_pickerView0];
                    
                    //[AlertManager showAlertText:@"选择性别，提交完成后将无法修改！"];
                } CancelAction:^void(){
                    __typeof(self) strongSelf = weakSelf;
                    [strongSelf hidePickView:strongSelf->m_viewSex PickView:strongSelf->m_pickerView0];
                } TitleAction:nil];
}

-(void)createBirthdayView
{
    m_viewBirthday = [[UIView alloc]init];
    m_pickerView1 = [[UIView alloc] init];
    m_pickerDate = [[UIDatePicker alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    
    [self createDatePick:m_viewBirthday PickView:m_pickerView1 DatePick:m_pickerDate Title:@"设置出生日期"
              DoneAction:^void(){
                  __typeof(self) strongSelf = weakSelf;
                  NSInteger unitflag =   kCFCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay;
                  NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
                  NSDateComponents* dateComponent = [chineseClendar components:unitflag fromDate:strongSelf->m_pickerDate.date];
                  
                  UIView *viewBody = [strongSelf.view viewWithTag:GENERATE_VIEW_BODY];
                  UILabel *lbBirthdayValue = (UILabel*)[viewBody viewWithTag:7001];
                  lbBirthdayValue.text = [NSString stringWithFormat:@"%04ld年%02ld月%02ld日", dateComponent.year, dateComponent.month, dateComponent.day];
                  [strongSelf hidePickView:strongSelf->m_viewBirthday PickView:strongSelf->m_pickerView1];
              } CancelAction:^void(){
                  __typeof(self) strongSelf = weakSelf;
                  [strongSelf hidePickView:strongSelf->m_viewBirthday PickView:strongSelf->m_pickerView1];
              } TitleAction:nil];
}

#pragma mark - PivkView Logic
- (void)popPickView:(UIView*)viewMain PickView:(UIView*)viewPick SelectView:(UIPickerView*)pickerView TagId:(NSInteger)nTagId ArrStore:(NSArray*)arrStore
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    UILabel *lbValue = (UILabel*)[viewBody viewWithTag:nTagId];
    
    if (viewMain == m_viewSex) {
        NSUInteger nIndex = [arrStore indexOfObject:lbValue.text];
        [pickerView selectRow:(nIndex == NSNotFound ? 0 : nIndex) inComponent:0 animated:NO];
    }
    else if(viewMain == m_viewBirthday)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy年MM月dd日"];
        
        NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
        NSDateComponents *_comps = [calendar components:units fromDate:[NSDate date]];
        NSInteger month = [_comps month];
        NSInteger year = [_comps year];
        NSInteger day = [_comps day];
        
        NSDateComponents *comps = [[NSDateComponents alloc]init];
        [comps setMonth:month];
        [comps setDay:day];
        [comps setYear:year - 18];
        
        NSDate *dateDefault = [calendar dateFromComponents:comps];
        NSDate *dateTime = [formatter dateFromString:lbValue.text];
        [m_pickerDate setDate:lbValue.text.length > 0 ? dateTime : dateDefault];
    }

    [self.navigationController.view addSubview:viewMain];
    [viewMain bringSubviewToFront:viewPick];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height - 260, [UIScreen screenWidth], 260);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)hidePickView:(UIView*)viewMain PickView:(UIView*)viewPick{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height, [UIScreen screenWidth], 260);
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

-(void)actionTap:(UITapGestureRecognizer*)gr {
    [self hidePickView:m_viewSex PickView:m_pickerView0];
    [self hidePickView:m_viewBirthday PickView:m_pickerView1];
}

-(void)animationFinished{
    [m_viewSex removeFromSuperview];
    [m_viewBirthday removeFromSuperview];
}

#pragma mark Statistics PickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger nCount = 0;
    
    if (pickerView == m_pickerSelect0) {
        nCount = [_arrayStore0 count];
    }

    return nCount;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *retval = (id)view;
    
    if(!retval)
    {
        retval = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 0.0f, [pickerView rowSizeForComponent:component].width-12, [pickerView rowSizeForComponent:component].height)];
    }
    
    retval.font = [UIFont boldSystemFontOfSize:18.0f];
    retval.backgroundColor = [UIColor clearColor];
    retval.textColor = [UIColor blackColor];
    retval.textAlignment = NSTextAlignmentCenter;
    
    if (pickerView == m_pickerSelect0) {
        retval.text = _arrayStore0[row];
    }
    
    return retval;
}

#pragma mark - Head Image Logic

-(void)showPicSelect {
    __weak __typeof(self) thisPointer = self;
    
    _customMenuViewController = [[CustomMenuViewController alloc]init];
    
    [_customMenuViewController addButtonFromBackTitle:@"取消" ActionBlock:^(id sender) {
    }];
    
    [_customMenuViewController addButtonFromBackTitle:@"从本地选取" ActionBlock:^(id sender) {
        [thisPointer actionSelectPhoto:sender];
    }];
    
    [_customMenuViewController addButtonFromBackTitle:@"立即拍照" Hightlight:YES ActionBlock:^(id sender) {
        [thisPointer actionTakePhoto:sender];
    }];
    
    [_customMenuViewController showInView:self.navigationController.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imageEditViewController = [[ImageEditViewController alloc]initWithNibName:@"ImageEditViewController" bundle:nil];
    _imageEditViewController.checkBounds = YES;
    
    [[ApplicationContext sharedInstance] saveObject:@(1) byKey:@"ProfileUpload"];
    
    __weak __typeof(self) thisPointer = self;
    
    _imageEditViewController.doneCallback = [_imageEditViewController commonDoneCallbackWithUserDoneCallBack:^(UIImage *doneImage,
                                                                                                               NSString *doneImageID,
                                                                                                               BOOL isOK) {
        __typeof(self) strongThis = thisPointer;
        
        if (isOK)
        {
            if (doneImageID != nil && [doneImageID isEqualToString:@""] == NO)
            {
                UIView *viewBody = [strongThis.view viewWithTag:GENERATE_VIEW_BODY];
                UIImageView *imgHead = (UIImageView*)[viewBody viewWithTag:7002];
                UIImageView * imgCamera = (UIImageView*)[viewBody viewWithTag:7003];
                UIImageView *imgViewNoPhoto = (UIImageView*)[viewBody viewWithTag:7004];

                imgCamera.hidden = NO;
                imgHead.hidden = NO;
                imgViewNoPhoto.hidden = YES;
                [imgHead sd_setImageWithURL:[NSURL URLWithString:doneImageID] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
                
                _strProfileImageID = doneImageID;
            }
        }
    }];
    
    _imageEditViewController.sourceImage = image;
    [_imageEditViewController reset:NO];
    
    [self.navigationController pushViewController:_imageEditViewController animated:YES];
    _imageEditViewController.cropSize = CGSizeMake([UIScreen screenWidth], 320);
}

-(IBAction)actionTakePhoto:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    [imagePicker setDelegate:self];
}

-(IBAction)actionSelectPhoto:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSLog(@"支持相机");
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSLog(@"支持图库");
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        NSLog(@"支持相片库");
    }
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    [imagePicker setDelegate:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
