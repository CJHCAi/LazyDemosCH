//
//  MobileInfoViewController.m
//  SportForum
//
//  Created by liyuan on 1/7/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "MobileInfoViewController.h"
#import "UIViewController+SportFormu.h"
#import "SMS_SDK/SMS_SDK.h"

@interface MobileInfoViewController ()

@end

@implementation MobileInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"邀请好友" IsNeedBackBtn:YES];
    
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
    
    UILabel *lbName = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 200, 25)];
    lbName.backgroundColor = [UIColor clearColor];
    lbName.text = _userInfo.nikename;
    lbName.textColor = [UIColor blackColor];
    lbName.font = [UIFont boldSystemFontOfSize:14];
    lbName.textAlignment = NSTextAlignmentLeft;
    [viewBody addSubview:lbName];
    
    UILabel *lbPhone = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 200, 25)];
    lbPhone.backgroundColor = [UIColor clearColor];
    lbPhone.text = [NSString stringWithFormat:@"手机号: %@", _userInfo.phone_number];
    lbPhone.textColor = [UIColor blackColor];
    lbPhone.font = [UIFont boldSystemFontOfSize:12];
    lbPhone.textAlignment = NSTextAlignmentLeft;
    [viewBody addSubview:lbPhone];
    
    UILabel *lbSep = [[UILabel alloc]initWithFrame:CGRectMake(10, 85, CGRectGetWidth(viewBody.frame) - 20, 1)];
    lbSep.backgroundColor = [UIColor darkGrayColor];
    [viewBody addSubview:lbSep];

    UILabel *lbTips = [[UILabel alloc]initWithFrame:CGRectMake(10, 105, CGRectGetWidth(viewBody.frame) - 20, 25)];
    lbTips.backgroundColor = [UIColor clearColor];
    lbTips.text = [NSString stringWithFormat:@"%@还未加入", _userInfo.nikename];
    lbTips.textColor = [UIColor blackColor];
    lbTips.font = [UIFont boldSystemFontOfSize:12];
    lbTips.textAlignment = NSTextAlignmentCenter;
    [viewBody addSubview:lbTips];
    
    UIImage * imgButton = [UIImage imageNamed:@"btn-2-blue"];
    CSButton * btnInvite = [[CSButton alloc] initNormalButtonTitle:@"发送邀请" Rect:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, CGRectGetMaxY(lbTips.frame) + 15, 266, 38)];
    [btnInvite setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnInvite setBackgroundImage:imgButton forState:UIControlStateNormal];
    btnInvite.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btnInvite setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    [viewBody addSubview:btnInvite];
    
    __weak typeof (self) thisPoint = self;
    
    btnInvite.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        [SMS_SDK sendSMS:strongSelf.userInfo.phone_number AndMessage:SMS_INVITE];
    };
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"邀请好友 - MobileInfoViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"邀请好友 - MobileInfoViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"邀请好友 - MobileInfoViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
