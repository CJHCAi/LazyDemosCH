//
//  CoachAuthViewController.m
//  SportForum
//
//  Created by liyuan on 4/27/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "CoachAuthViewController.h"
#import "UIViewController+SportFormu.h"
#import "AlertManager.h"
#import "CoachAuthDetailViewController.h"

@interface CoachAuthViewController ()

@end

@implementation CoachAuthViewController
{
    UIScrollView *_scrollView;
    
    UILabel *_lbIdCard;
    UILabel *_lbCert;
    UILabel *_lbRecord;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"教练认证" IsNeedBackBtn:YES];
    
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
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    _scrollView.scrollEnabled = YES;
    [viewBody addSubview:_scrollView];
    
    [self generateAuthView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"教练认证 - CoachAuthViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"教练认证 - CoachAuthViewController"];
    [self loadAuthStatus];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"教练认证 - CoachAuthViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"CoachAuthViewController dealloc called!");
}

-(NSString*)convertStatusToString:(e_auth_status_type)eAuthStatus
{
    NSString *strStatus = @"未认证";
    
    switch (eAuthStatus) {
        case e_auth_unverified:
            strStatus = @"未认证";
            break;
        case e_auth_verifying:
            strStatus = @"认证中";
            break;
        case e_auth_verified:
            strStatus = @"已认证";
            break;
        case e_auth_refused:
            strStatus = @"认证被拒";
            break;
        default:
            break;
    }
    
    return strStatus;
}

-(void)loadAuthStatus
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    id processWin = [AlertManager showCommonProgressInView:viewBody];
    
    [[SportForumAPI sharedInstance] userAuthStatusByUserId:userInfo.userid FinishedBlock:^void(int errorCode, e_auth_status_type eIdcardStatus, e_auth_status_type eCertStatus, e_auth_status_type eRecordStatus)
     {
         [AlertManager dissmiss:processWin];
         
         if (errorCode == 0)
         {
             _lbIdCard.text = [self convertStatusToString:eIdcardStatus];
             _lbCert.text = [self convertStatusToString:eCertStatus];
             _lbRecord.text = [self convertStatusToString:eRecordStatus];
         }
     }];
}

-(void)generateAuthItemView:(NSString*)strItem ItemPng:(NSString*)strPng StartPoint:(CGFloat)fStartPoint AuthLabel:(UILabel*)lbAuth
{
    UIView *viewItem = [[UIView alloc]initWithFrame:CGRectMake(0, fStartPoint, CGRectGetWidth(_scrollView.frame), 52)];
    viewItem.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:viewItem];

    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 6, 40, 40)];
    [imgView setImage:[UIImage imageNamed:strPng]];
    imgView.frame = CGRectMake(10, 6, 40, 40);
    [viewItem addSubview:imgView];
    
    UILabel *lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 150, 32)];
    lbTitle.font = [UIFont boldSystemFontOfSize:14.0];
    lbTitle.textAlignment = NSTextAlignmentLeft;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textColor = [UIColor darkGrayColor];
    lbTitle.text = strItem;
    [viewItem addSubview:lbTitle];
    
    lbAuth.frame = CGRectMake(310 - 28 - 100, 10, 100, 32);
    lbAuth.font = [UIFont boldSystemFontOfSize:14.0];
    lbAuth.textAlignment = NSTextAlignmentRight;
    lbAuth.backgroundColor = [UIColor clearColor];
    lbAuth.textColor = [UIColor darkGrayColor];
    lbAuth.text = @"未认证";
    [viewItem addSubview:lbAuth];
    
    UILabel *lbSep = [[UILabel alloc]initWithFrame:CGRectMake(60, 51, 250, 1)];
    lbSep.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    [viewItem addSubview:lbSep];
    
    UIImageView *arrImgView = [[UIImageView alloc]initWithFrame:CGRectMake(310 - 18, 16, 8, 16)];
    [arrImgView setImage:[UIImage imageNamed:@"arrow-1"]];
    [viewItem addSubview:arrImgView];
    
    CSButton * btnItem = [CSButton buttonWithType:UIButtonTypeCustom];
    btnItem.frame = CGRectMake(1, 1, CGRectGetWidth(viewItem.frame) - 2, CGRectGetHeight(viewItem.frame) - 2);
    [viewItem addSubview:btnItem];
    
    __weak __typeof(self) weakSelf = self;
    
    btnItem.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        CoachAuthDetailViewController *coachAuthDetailViewController = [[CoachAuthDetailViewController alloc]init];
        coachAuthDetailViewController.strTitle = strItem;
        
        if ([strItem isEqualToString:@"身份证认证"]) {
            coachAuthDetailViewController.eAuthType = e_auth_idcard;
        }
        else if([strItem isEqualToString:@"资格证书认证"]) {
            coachAuthDetailViewController.eAuthType = e_auth_cert;
        }
        else if([strItem isEqualToString:@"运动成绩认证"])
        {
            coachAuthDetailViewController.eAuthType = e_auth_record;
        }
        
        [strongSelf.navigationController pushViewController:coachAuthDetailViewController animated:YES];
    };
}

-(void)generateAuthView
{
    _lbIdCard = [[UILabel alloc]init];
    _lbCert = [[UILabel alloc]init];
    _lbRecord = [[UILabel alloc]init];
    
    [self generateAuthItemView:@"身份证认证" ItemPng:@"coach-id" StartPoint:0 AuthLabel:_lbIdCard];
    [self generateAuthItemView:@"资格证书认证" ItemPng:@"coach-honour" StartPoint:52 AuthLabel:_lbCert];
    [self generateAuthItemView:@"运动成绩认证" ItemPng:@"coach-score" StartPoint:104 AuthLabel:_lbRecord];
    
    UILabel *lbTips = [[UILabel alloc]initWithFrame:CGRectMake(10, 190, 50, 20)];
    lbTips.font = [UIFont boldSystemFontOfSize:13.0];
    lbTips.textAlignment = NSTextAlignmentLeft;
    lbTips.backgroundColor = [UIColor clearColor];
    lbTips.textColor = [UIColor darkGrayColor];
    lbTips.text = @"提示：";
    [_scrollView addSubview:lbTips];
    
    UILabel *lbTipsValue = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lbTips.frame), CGRectGetWidth(_scrollView.frame) - 20, 120)];
    lbTipsValue.font = [UIFont boldSystemFontOfSize:13.0];
    lbTipsValue.textAlignment = NSTextAlignmentLeft;
    lbTipsValue.backgroundColor = [UIColor clearColor];
    lbTipsValue.textColor = [UIColor darkGrayColor];
    lbTipsValue.numberOfLines = 0;
    lbTipsValue.text = @"1.  教练认证必须通过身份证认证。资格证书认证和运动成绩认证可以二选一。\n"
                       @"2.  教练认证通过后，会被授予教练标志，显示给所有用户。\n"
                       @"3.  教练认证用户可以在运动记录中进行专家点评，未来还可以接受运动咨询任务，收取指导费用。";
    [_scrollView addSubview:lbTipsValue];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(lbTipsValue.frame) + 20);
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
