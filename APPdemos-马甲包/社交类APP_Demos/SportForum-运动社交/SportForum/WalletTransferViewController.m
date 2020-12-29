//
//  WalletTransferViewController.m
//  SportForum
//
//  Created by zyshi on 14-9-17.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "WalletTransferViewController.h"
#import "UIViewController+SportFormu.h"
#import "CSButton.h"
#import "MBProgressHUD.h"
#import "AlertManager.h"

@interface WalletTransferViewController () <MBProgressHUDDelegate, UITextFieldDelegate>

@end

@implementation WalletTransferViewController
{
    NSString * _strAddress;
    NSString * _strTargetAddress;
    UITextField * _leAddress;
    UITextField * _leCoin;
    MBProgressHUD * _HUD;
    NSString * _strArticleId;
    WalletBalanceItem *_walletBalanceItem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _strAddress = @"";
        _strTargetAddress = @"";
        _strArticleId = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generateCommonViewInParent:self.view Title:@"转账" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
	[self.navigationController.view addSubview:_HUD];
    _HUD.labelText = @"请稍后...";
	_HUD.delegate = self;
    
    UIImageView * imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(27, 10, 246, 95)];
    imgHead.image = [UIImage imageNamed:@"transaction-bg"];
    [viewBody addSubview:imgHead];
    
    UILabel * lbTargetAddress = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, 90, 20)];
    lbTargetAddress.backgroundColor = [UIColor clearColor];
    lbTargetAddress.text = @"对方钱包地址：";
    lbTargetAddress.font = [UIFont boldSystemFontOfSize:12];
    lbTargetAddress.textAlignment = NSTextAlignmentLeft;
    [viewBody addSubview:lbTargetAddress];
    
    UILabel * lbTargetCoin = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, 90, 20)];
    lbTargetCoin.backgroundColor = [UIColor clearColor];
    lbTargetCoin.text = @"转账金额：";
    lbTargetCoin.font = [UIFont boldSystemFontOfSize:12];
    lbTargetCoin.textAlignment = NSTextAlignmentLeft;
    [viewBody addSubview:lbTargetCoin];
    
    _leAddress = [[UITextField alloc] initWithFrame:CGRectMake(100, 125, viewBody.bounds.size.width - 110, 30)];
    _leAddress.backgroundColor = [UIColor whiteColor];
    _leAddress.layer.borderColor = [UIColor colorWithRed:245 / 255.0 green:192 / 255.0 blue:72 / 255.0 alpha:1.0].CGColor;
    _leAddress.layer.borderWidth = 2.0;
    _leAddress.keyboardType = UIKeyboardTypeASCIICapable;
    _leAddress.delegate = self;
    _leAddress.font = [UIFont systemFontOfSize:12];
    _leAddress.textColor = [UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0];
    _leAddress.leftView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _leAddress.leftViewMode = UITextFieldViewModeAlways;
    [viewBody addSubview:_leAddress];
    
    _leCoin = [[UITextField alloc] initWithFrame:CGRectMake(100, 170, viewBody.bounds.size.width - 110, 30)];
    _leCoin.backgroundColor = [UIColor whiteColor];
    _leCoin.layer.borderColor = [UIColor colorWithRed:245 / 255.0 green:192 / 255.0 blue:72 / 255.0 alpha:1.0].CGColor;
    _leCoin.layer.borderWidth = 2.0;
    _leCoin.delegate = self;
    _leCoin.leftView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _leCoin.leftViewMode = UITextFieldViewModeAlways;
    _leCoin.keyboardType = UIKeyboardTypeNumberPad;
    [viewBody addSubview:_leCoin];

    CSButton * btnPay = [[CSButton alloc] initNormalButtonTitle:@"支付" Rect:CGRectMake((viewBody.bounds.size.width - 123) / 2, 225, 123, 38)];
    [btnPay setBackgroundImage:[UIImage imageNamed:@"btn-3-yellow"] forState:UIControlStateNormal];
    [btnPay setTitleColor:[UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnPay setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [viewBody addSubview:btnPay];

    __weak __typeof(self) weakSelf = self;

    btnPay.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        [strongSelf->_leAddress resignFirstResponder];
        [strongSelf->_leCoin resignFirstResponder];
        
        UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
        
        if (userInfo != nil) {
            if (userInfo.ban_time > 0) {
                [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:strongSelf.view hiddenAfter:2];
                return;
            }
            else if(userInfo.ban_time < 0)
            {
                [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:strongSelf.view hiddenAfter:2];
                return;
            }
        }
        
        if (strongSelf->_leCoin.text.length == 0 || strongSelf->_leAddress.text.length == 0) {
            [AlertManager showAlertText:@"转账地址和金额不能为空。"InView:strongSelf.view hiddenAfter:2];
            return;
        }
        
        long long lConfirmed = userInfo.proper_info.coin_value;
        
        if (strongSelf->_walletBalanceItem != nil) {
            lConfirmed = strongSelf->_walletBalanceItem.confirmed;
            strongSelf->_strAddress = strongSelf->_walletBalanceItem.address;
        }
        
        if ([strongSelf->_leCoin.text intValue] == 0)
        {
            [AlertManager showAlertText:@"建议金额不能为0，请重新输入金额。"InView:strongSelf.view hiddenAfter:2];
        }
        else if ([strongSelf->_leCoin.text intValue] > (lConfirmed / 100000000)) {
            [AlertManager showAlertText:@"您当前账户余额不足本次交易, 请检查账户余额。"InView:strongSelf.view hiddenAfter:2];
        }
        else
        {
            [strongSelf walletTrade];
        }
    };
}

-(void)walletTrade
{
    [_HUD show:YES];
    
    [[SportForumAPI sharedInstance] walletTradeBySelfAddress:_strAddress
                                                     TradeTo:_leAddress.text
                                                   TradeType:[_strArticleId isEqualToString:@""] ? e_trade : e_reward
                                                   ArticleId:_strArticleId
                                                  TradeValue:[_leCoin.text longLongValue] * (long long)100000000
                                               FinishedBlock:^void(int errorCode, NSString* strDescErr, NSString* strTxid)
     {
         [_HUD hide:YES];
         
         if(errorCode != 0)
         {
             [AlertManager showAlertText:strDescErr];
         }
         else
         {
             [AlertManager showAlertText:@"交易成功！" InView:self.view hiddenAfter:1];
             
             [NSTimer scheduledTimerWithTimeInterval: 1
                                              target: self
                                            selector: @selector(actionTradeSuccess)
                                            userInfo: nil
                                             repeats: NO];
         }
     }];
}

-(void)actionTradeSuccess
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
     {
         if (errorCode == 0)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
         }
     }];
    
    if(_strArticleId.length > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_ARTICLE_AFTER_EVENT object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _leAddress.text = _strTargetAddress;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (textField == _leCoin) {
        if (string.length == 0) {
            return YES;
        }
        
        //第一个参数，被替换字符串的range，第二个参数，即将键入或者粘贴的string，返回的是改变过后的新str，即textfield的新的文本内容
        NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //正则表达式
        
         NSString *regex = @"";
        
        if (textField == _leCoin) {
            regex = @"^\\-?([1-9]\\d{0,9})?$";
        }
        else
        {
            
        }
        return [self isValid:checkStr withRegex:regex];
    }
    else
    {
        NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        [newtxt replaceCharactersInRange:range withString:string];
        return [[CommonUtility sharedInstance]isAllowChar:newtxt AlowedChars:ALLOW_CHARS];
    }
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"WalletTransferViewController dealloc called!");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setWalletBalanceItem:(WalletBalanceItem*)item
{
    _walletBalanceItem = item;
}

-(void)setSelfAddress:(NSString *)strAddress
{
    _strAddress = strAddress;
}

-(void)settargetAddress:(NSString *)strAddress withArticleID:(NSString *)strID
{
    _strTargetAddress = strAddress;
    _strArticleId = strID;
}

@end
