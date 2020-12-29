//
//  EquipmentEditViewController.m
//  SportForum
//
//  Created by liyuan on 4/3/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "EquipmentEditViewController.h"
#import "UIViewController+SportFormu.h"
#import "IQKeyboardManager.h"
#import "AlertManager.h"
#import "EquipmentInfoViewController.h"

@interface EquipmentEditViewController ()

@end

@implementation EquipmentEditViewController
{
    UITextField * _leContent;
    UITextField * _leContent1;
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
        [strongSelf setEquipmentInfo];
    };
    
    if ([_strTitle isEqualToString:@"填写型号"]) {
        
        UILabel * lbModel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        lbModel.backgroundColor = [UIColor clearColor];
        lbModel.textColor = [UIColor darkGrayColor];
        lbModel.text = [NSString stringWithFormat:(_nEquipType == EQUIP_TYPE_EDIT_SHOES ? @"%@跑鞋型号" : @"%@可穿戴设备型号"), _strEquipName];
        lbModel.font = [UIFont boldSystemFontOfSize:14];
        lbModel.textAlignment = NSTextAlignmentLeft;
        [viewBody addSubview:lbModel];
        
        _leContent = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lbModel.frame) + 5, CGRectGetWidth(viewBody.frame) - 20, 30)];
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
        
        [_leContent becomeFirstResponder];
    }
    else
    {
        UILabel * lbName = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        lbName.backgroundColor = [UIColor clearColor];
        lbName.textColor = [UIColor darkGrayColor];
        
        lbName.font = [UIFont boldSystemFontOfSize:14];
        lbName.textAlignment = NSTextAlignmentLeft;
        [viewBody addSubview:lbName];
        
        if (_nEquipType == EQUIP_TYPE_EDIT_SHOES) {
            lbName.text = @"跑鞋品牌";
        }
        else if(_nEquipType == EQUIP_TYPE_EDIT_DEVICE)
        {
            lbName.text = @"可穿戴设备品牌";
        }
        else if(_nEquipType == EQUIP_TYPE_EDIT_APP)
        {
            lbName.text = @"轨迹记录App";
        }
            
        _leContent = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lbName.frame) + 5, CGRectGetWidth(viewBody.frame) - 20, 30)];
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
        
        [_leContent becomeFirstResponder];
        
        if(_nEquipType != EQUIP_TYPE_EDIT_APP)
        {
            UILabel * lbModel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_leContent.frame) + 20, 300, 20)];
            lbModel.backgroundColor = [UIColor clearColor];
            lbModel.textColor = [UIColor darkGrayColor];
            lbModel.text = @"品牌型号";
            lbModel.font = [UIFont boldSystemFontOfSize:14];
            lbModel.textAlignment = NSTextAlignmentLeft;
            [viewBody addSubview:lbModel];
            
            _leContent1 = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lbModel.frame) + 5, CGRectGetWidth(viewBody.frame) - 20, 30)];
            _leContent1.backgroundColor = [UIColor whiteColor];
            _leContent1.font = [UIFont boldSystemFontOfSize:14];
            _leContent1.textColor = [UIColor darkGrayColor];
            
            if (IOS7_OR_LATER) {
                _leContent1.tintColor = [UIColor blueColor];
            }
            
            _leContent1.clearButtonMode = UITextFieldViewModeWhileEditing;
            _leContent1.autocapitalizationType = UITextAutocapitalizationTypeNone;
            _leContent1.enablesReturnKeyAutomatically = YES;
            _leContent1.textAlignment = NSTextAlignmentLeft;
            _leContent1.multipleTouchEnabled = YES;
            _leContent1.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _leContent1.layer.borderWidth = 1.0;
            _leContent1.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
            _leContent1.leftViewMode = UITextFieldViewModeAlways;
            [viewBody addSubview:_leContent1];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    [MobClick beginLogPageView:@"装备编辑 - EquipmentInfoViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"装备编辑 - EquipmentInfoViewController"];
    
    [_leContent addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_leContent1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"装备编辑 - EquipmentInfoViewController"];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [_leContent removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_leContent1 removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    if (textField.markedTextRange == nil && textField.text.length > 10) {
        textField.text = [textField.text substringToIndex:10];
    }
    else
    {
        NSString * strFixedContent = [[CommonUtility sharedInstance]disable_emoji:textField.text];
        
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
    
    if ([newtxt length] > 10)
    {
        bAllowWord = NO;
    }
    else
    {
        NSString * strFixedContent = [[CommonUtility sharedInstance]disable_emoji:strFinalContent];
        
        if(![strFinalContent isEqualToString:strFixedContent])
        {
            bAllowWord = NO;
        }
    }
    
    return bAllowWord;
}

-(void)setEquipmentInfo
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    EquipmentInfo *equipmentInfo = userInfo.user_equipInfo;
    
    NSString *strName = _strEquipName;
    NSString *strModel = @"";
    
    [_leContent resignFirstResponder];
    [_leContent1 resignFirstResponder];
    
    if([_strTitle isEqualToString:@"自定义品牌"])
    {
        strName = _leContent.text;
        strModel = _leContent1.text;
    }
    else
    {
        strModel = _leContent.text;
    }
    
    if (strName.length == 0) {
        [JDStatusBarNotification showWithStatus:@"品牌名称不能为空" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }
    
    if (_nEquipType == EQUIP_TYPE_EDIT_SHOES) {
        [equipmentInfo.run_shoe.data removeAllObjects];
        [equipmentInfo.run_shoe.data addObject:[NSString stringWithFormat:@"%@###%@", strName, strModel]];
    }
    else if(_nEquipType == EQUIP_TYPE_EDIT_DEVICE) {
        [equipmentInfo.ele_product.data removeAllObjects];
        [equipmentInfo.ele_product.data addObject:[NSString stringWithFormat:@"%@###%@", strName, strModel]];
    }
    else if(_nEquipType == EQUIP_TYPE_EDIT_APP){
        [equipmentInfo.step_tool.data removeAllObjects];
        [equipmentInfo.step_tool.data addObject:[NSString stringWithFormat:@"%@", strName]];
    }
    
    id _processId = [AlertManager showCommonProgress];
    
    [[SportForumAPI sharedInstance]userUpdateEquipment:equipmentInfo FinishedBlock:^(int errorCode, ExpEffect* expEffect) {
        [AlertManager dissmiss:_processId];

        if (errorCode == 0) {
            [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
             {
                 if (errorCode == 0)
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
                     
                     NSMutableArray *viewControllers = [[self.navigationController viewControllers] mutableCopy];
                     
                     for (UIViewController*viewController in viewControllers) {
                         if ([viewController isKindOfClass:[EquipmentInfoViewController class]]) {
                             [self.navigationController popToViewController:viewController animated:YES];
                             break;
                         }
                     }
                 }
             }];
        }
        else
        {
            [JDStatusBarNotification showWithStatus:@"设置失败" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
        }
    }];
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
