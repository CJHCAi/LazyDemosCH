//
//  InfoEditViewController.m
//  SportForum
//
//  Created by liyuan on 3/30/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "InfoEditViewController.h"
#import "UIViewController+SportFormu.h"
#import "IQKeyboardManager.h"
#import "AlertManager.h"

@interface InfoEditViewController ()

@end

@implementation InfoEditViewController
{
    UITextField * _leContent;
    UITextView * _tvContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generateCommonViewInParent:self.view Title:_strTitle IsNeedBackBtn:YES];
    
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
    [imgViewFinish setImage:[UIImage imageNamed:@"nav-finish-btn"]];
    [self.view addSubview:imgViewFinish];
    
    CSButton *btnFinish = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFinish.frame = CGRectMake(CGRectGetMinX(imgViewFinish.frame) - 5, CGRectGetMinY(imgViewFinish.frame) - 5, 45, 45);
    btnFinish.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnFinish];
    [self.view bringSubviewToFront:btnFinish];
    
    __weak typeof (self) thisPoint = self;
    
    btnFinish.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        [strongSelf setUserSettings];
    };
    
    CGFloat fHeight = 0;
    
    if ([_strTitle isEqualToString:@"昵称"] || [_strTitle isEqualToString:@"职业"]
        || [_strTitle isEqualToString:@"兴趣爱好"] || [_strTitle isEqualToString:@"常出没地"]) {
        _leContent = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(viewBody.frame), 40)];
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
        _leContent.borderStyle = UITextBorderStyleNone;
        _leContent.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
        _leContent.leftViewMode = UITextFieldViewModeAlways;
        [viewBody addSubview:_leContent];
        
        _leContent.text = _strContent;
        [_leContent becomeFirstResponder];
        fHeight = 60;
    }
    else
    {
        _tvContent = [[UITextView alloc]initWithFrame:CGRectMake(0, 20, CGRectGetWidth(viewBody.frame), 90)];
        _tvContent.backgroundColor = [UIColor whiteColor];
        _tvContent.font = [UIFont boldSystemFontOfSize:14];
        _tvContent.textColor = [UIColor darkGrayColor];
        _tvContent.textAlignment = NSTextAlignmentLeft; //水平左对齐
        _tvContent.returnKeyType = UIReturnKeyDefault;
        _tvContent.multipleTouchEnabled = YES;
        [viewBody addSubview:_tvContent];
        
        _tvContent.text = _strContent;
        [_tvContent becomeFirstResponder];
        fHeight = 110;
    }
    
    UILabel *lbTips = [[UILabel alloc]init];
    lbTips.font = [UIFont systemFontOfSize:14.0];
    lbTips.textAlignment = NSTextAlignmentLeft;
    lbTips.backgroundColor = [UIColor clearColor];
    lbTips.textColor = [UIColor lightGrayColor];
    lbTips.frame = CGRectMake(5, fHeight + 5, CGRectGetWidth(viewBody.frame) - 10, 30);
    lbTips.text = _strPlaceHold;
    [viewBody addSubview:lbTips];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    [MobClick beginLogPageView:@"个人编辑内容设置 - InfoEditViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"个人编辑内容设置 - InfoEditViewController"];
    [_leContent addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人编辑内容设置 - InfoEditViewController"];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [_leContent removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        
        if ([_strTitle isEqualToString:@"昵称"]) {
            strFixedContent = [strFixedContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
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
        
        if ([_strTitle isEqualToString:@"昵称"]) {
            strFixedContent = [strFixedContent stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
        
        if(![strFinalContent isEqualToString:strFixedContent])
        {
            bAllowWord = NO;
        }
    }
    
    return bAllowWord;
}

-(void)setUserSettings
{
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    [_leContent resignFirstResponder];
    [_tvContent resignFirstResponder];
    
    if (userInfo != nil) {
        if (userInfo.ban_time > 0) {
            [JDStatusBarNotification showWithStatus:@"用户已被禁言，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
        else if(userInfo.ban_time < 0)
        {
            [JDStatusBarNotification showWithStatus:@"用户已进入黑名单，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
    }
    
    if ([_strTitle isEqualToString:@"昵称"]) {
        NSString *strContent = [_leContent.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(strContent.length == 0)
        {
            [JDStatusBarNotification showWithStatus:@"昵称不能为空" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        }
        else
        {
            id process = [AlertManager showCommonProgress];
            
            [[SportForumAPI sharedInstance] userIsNikeNameUsed:strContent FinishedBlock:^void(int errorCode, BOOL bUsed){
                if (bUsed) {
                    [AlertManager dissmiss:process];
                    [JDStatusBarNotification showWithStatus:@"该昵称已被使用" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                }
                else
                {
                    UserUpdateInfo *userUpdateInfo = [[UserUpdateInfo alloc]init];
                    userUpdateInfo.nikename = strContent;
                    
                    [[SportForumAPI sharedInstance] userSetInfoByUpdateInfo:userUpdateInfo FinishedBlock:^void(int errorCode, NSString* strDescErr, ExpEffect* expEffect)
                     {
                         [AlertManager dissmiss:process];
                         
                         if (errorCode != 0) {
                             [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                         }
                         
                         UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                         
                         [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                          {
                              if (errorCode == 0)
                              {
                                  [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect",nil]];
                                  [self.navigationController popViewControllerAnimated:YES];
                              }
                          }];
                     }];
                }
            }];
        }
    }
    else
    {
        NSString *strContent = @"";
        
        if([_strTitle isEqualToString:@"职业"] || [_strTitle isEqualToString:@"兴趣爱好"]
           || [_strTitle isEqualToString:@"常出没地"]) {
            strContent = [_leContent.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        else if([_strTitle isEqualToString:@"签名"]) {
            strContent = [_tvContent.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }

        if(strContent.length == 0)
        {
            [JDStatusBarNotification showWithStatus:@"提交内容不能为空" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        }
        else
        {
            UserUpdateInfo *userUpdateInfo = [[UserUpdateInfo alloc]init];
            
            if([_strTitle isEqualToString:@"签名"]) {
                userUpdateInfo.sign = strContent;
            }
            else if([_strTitle isEqualToString:@"职业"]) {
                userUpdateInfo.profession = strContent;
            }
            else if([_strTitle isEqualToString:@"兴趣爱好"]) {
                userUpdateInfo.fond = strContent;
            }
            else if([_strTitle isEqualToString:@"常出没地"]) {
                userUpdateInfo.oftenAppear = strContent;
            }
            
            id process = [AlertManager showCommonProgress];
            
            [[SportForumAPI sharedInstance] userSetInfoByUpdateInfo:userUpdateInfo FinishedBlock:^void(int errorCode, NSString* strDescErr, ExpEffect* expEffect)
             {
                 [AlertManager dissmiss:process];
                 
                 if (errorCode != 0) {
                     [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                 }
                 
                 UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                 
                 [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                  {
                      if (errorCode == 0)
                      {
                          [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                          [self.navigationController popViewControllerAnimated:YES];
                      }
                  }];
             }];
        }
    }
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
