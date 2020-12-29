//
//  SettingMainViewController.m
//  SportForum
//
//  Created by zyshi on 14-10-11.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "SettingMainViewController.h"
#import "SettingsViewController.h"
#import "UIViewController+SportFormu.h"
#import "AlertManager.h"
#import "BindPhoneViewController.h"
#import "HelpUsedViewController.h"

@interface SettingMainViewController () <UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation SettingMainViewController
{
    NSMutableArray * _SettingsItems;
    UITableView *_tableSetting;
    
    id m_processWindow;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
    
    [self generateCommonViewInParent:self.view Title:@"设置" IsNeedBackBtn:YES];
    
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

    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    _tableSetting = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableSetting.delegate = self;
    _tableSetting.dataSource = self;
    [viewBody addSubview:_tableSetting];
    
    [_tableSetting reloadData];
    _tableSetting.backgroundColor = [UIColor clearColor];
    _tableSetting.separatorColor = [UIColor clearColor];
    
    if ([_tableSetting respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableSetting setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"SettingMainViewController dealloc called!");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hidenCommonProgress];
}

-(void)showCommonProgress{
    if (m_processWindow) {
        [self hidenCommonProgress];
    }
    
    m_processWindow = [AlertManager showCommonProgress];
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:m_processWindow];
    m_processWindow = nil;
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

-(void)handleUpdateProfileInfo
{
    [_tableSetting reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 5;
    }
    else if(section == 1)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *CellTableIdentifier = @"SettingsIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView* viewContent = [[UIImageView alloc]init];
            UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
            imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
            viewContent.frame = CGRectMake(5, 1, 300, 50);
            [viewContent setImage:imgBk];
            viewContent.tag = 100;
            [cell.contentView addSubview:viewContent];
            
            UIImageView * imgImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 40, 40)];
            imgImage.tag = 101;
            [viewContent addSubview:imgImage];
            
            UILabel * lbSettingItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 13, 150, 24)];
            lbSettingItemTitle.font = [UIFont boldSystemFontOfSize:14.0];
            lbSettingItemTitle.textAlignment = NSTextAlignmentLeft;
            lbSettingItemTitle.backgroundColor = [UIColor clearColor];
            lbSettingItemTitle.textColor = [UIColor blackColor];
            lbSettingItemTitle.tag = 102;
            [viewContent addSubview:lbSettingItemTitle];
            
            UILabel * lbSettingItemValue = [[UILabel alloc] initWithFrame:CGRectMake(150, 13, 120, 24)];
            lbSettingItemValue.font = [UIFont systemFontOfSize:14.0];
            lbSettingItemValue.textAlignment = NSTextAlignmentRight;
            lbSettingItemValue.backgroundColor = [UIColor clearColor];
            lbSettingItemValue.textColor = [UIColor grayColor];
            lbSettingItemValue.tag = 103;
            [viewContent addSubview:lbSettingItemValue];
            
            UIImageView * imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 17, 8, 16)];
            imgArrow.image = [UIImage imageNamed:@"arrow-1"];
            imgArrow.tag = 99;
            [viewContent addSubview:imgArrow];
        }
        
        UIImageView *viewContent = (UIImageView*)[cell.contentView viewWithTag:100];
        
        UIImage * image = [UIImage imageNamed:@"settings-info"];
        NSString * strTitle = @"编辑个人信息";
        NSString * strValue = @"";
        UserInfo *userInfo = [[ApplicationContext sharedInstance] accountInfo];
        if(indexPath.row == 1)
        {
            image = [UIImage imageNamed:@"settings-weight"];
            strTitle = @"体重";
            strValue = [NSString stringWithFormat:@"%lu公斤", (unsigned long)userInfo.weight];
        }
        else if(indexPath.row == 2)
        {
            image = [UIImage imageNamed:@"settings-height"];
            strTitle = @"身高";
            strValue = [NSString stringWithFormat:@"%lu厘米", (unsigned long)userInfo.height];
        }
        else if(indexPath.row == 3)
        {
            image = [UIImage imageNamed:@"settings-year"];
            strTitle = @"出生年份";
            NSDate * dateBirthday = [NSDate dateWithTimeIntervalSince1970:userInfo.birthday];
            NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dateBirthday];
            NSInteger birthdayYear = [comps year];
            strValue = [NSString stringWithFormat:@"%ld年", (long)birthdayYear];
        }
        else if(indexPath.row == 4)
        {
            image = [UIImage imageNamed:@"settings-phone-binding"];
            strTitle = @"绑定手机";
            strValue = userInfo.phone_number.length > 0 ? userInfo.phone_number : @"未绑定";
            
            UIImageView *imgDescImage = (UIImageView*)[viewContent viewWithTag:99];
            imgDescImage.hidden = userInfo.phone_number.length > 0 ? YES : NO;
        }
        
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height / 2) - 2, floorf(image.size.width / 2) - 2, floorf(image.size.height / 2) + 2, floorf(image.size.width / 2) + 2)];
        
        UIImageView *imgDescImage = (UIImageView*)[viewContent viewWithTag:101];
        [imgDescImage setImage:image];
        
        UILabel * lbSettingItemTitle = (UILabel*)[viewContent viewWithTag:102];
        lbSettingItemTitle.text = strTitle;
        
        UILabel * lbSettingItemValue = (UILabel*)[cell.contentView viewWithTag:103];
        lbSettingItemValue.text = strValue;
        
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *CellTableIdentifier = @"HelpIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView* viewContent = [[UIImageView alloc]init];
            UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
            imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
            viewContent.frame = CGRectMake(5, 1, 300, 50);
            [viewContent setImage:imgBk];
            viewContent.tag = 104;
            [cell.contentView addSubview:viewContent];
            
            UIImageView * imgImage = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 40, 40)];
            imgImage.tag = 105;
            [viewContent addSubview:imgImage];
            
            UILabel * lbSettingItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 13, 150, 24)];
            lbSettingItemTitle.font = [UIFont boldSystemFontOfSize:14.0];
            lbSettingItemTitle.textAlignment = NSTextAlignmentLeft;
            lbSettingItemTitle.backgroundColor = [UIColor clearColor];
            lbSettingItemTitle.textColor = [UIColor blackColor];
            lbSettingItemTitle.tag = 106;
            [viewContent addSubview:lbSettingItemTitle];
            
            UILabel * lbSettingItemValue = [[UILabel alloc] initWithFrame:CGRectMake(200, 13, 70, 24)];
            lbSettingItemValue.font = [UIFont systemFontOfSize:14.0];
            lbSettingItemValue.textAlignment = NSTextAlignmentRight;
            lbSettingItemValue.backgroundColor = [UIColor clearColor];
            lbSettingItemValue.textColor = [UIColor grayColor];
            lbSettingItemValue.tag = 107;
            [viewContent addSubview:lbSettingItemValue];
            
            UIImageView * imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 17, 8, 16)];
            imgArrow.image = [UIImage imageNamed:@"arrow-1"];
            [viewContent addSubview:imgArrow];
        }
        
        UIImageView *viewContent = (UIImageView*)[cell.contentView viewWithTag:104];
        
        UIImage * image = [UIImage imageNamed:@"settings-tutorial"];
        NSString * strTitle = @"任务系统新手指南";
        NSString * strValue = @"";
        
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height / 2) - 2, floorf(image.size.width / 2) - 2, floorf(image.size.height / 2) + 2, floorf(image.size.width / 2) + 2)];
        
        UIImageView *imgDescImage = (UIImageView*)[viewContent viewWithTag:105];
        [imgDescImage setImage:image];
        
        UILabel * lbSettingItemTitle = (UILabel*)[viewContent viewWithTag:106];
        lbSettingItemTitle.text = strTitle;
        
        UILabel * lbSettingItemValue = (UILabel*)[cell.contentView viewWithTag:107];
        lbSettingItemValue.text = strValue;
        
        return cell;
    }
    else
    {
        static NSString *CellTableIdentifier = @"logoutIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            CSButton * btnLogout = [CSButton buttonWithType:UIButtonTypeCustom];
            btnLogout.frame = CGRectMake(5, 8, 299, 38);
            UIImage * imgButton = [UIImage imageNamed:@"btn-1-red"];
            UIEdgeInsets insets = UIEdgeInsetsMake(5, 10, 10, 10);
            imgButton = [imgButton resizableImageWithCapInsets:insets];
            [btnLogout setBackgroundImage:imgButton forState:UIControlStateNormal];
            [btnLogout setTitle:@"退出登录" forState:UIControlStateNormal];
            [btnLogout setTitleColor:[UIColor colorWithRed:138.0 / 255.0 green:22.0 / 255.0 blue:0 alpha:1.0] forState:UIControlStateNormal];
            [btnLogout setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [btnLogout.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [cell.contentView addSubview:btnLogout];
            
            __weak __typeof(self) weakSelf = self;

            btnLogout.actionBlock = ^void()
            {
                __typeof(self) strongSelf = weakSelf;
                [strongSelf showCommonProgress];
                
                [[ApplicationContext sharedInstance] logout:^void(int errorCode)
                 {
                     [strongSelf hidenCommonProgress];
                     
                     if(errorCode == 0)
                     {
                         [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_MESSAGE_SWITCH_VIEW object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:VIEW_LOGIN_PAGE, @"PageName", nil]];
                     }
                     else
                     {
                         [AlertManager showAlertText:@"登出失败" InView:strongSelf.view hiddenAfter:2];
                     }
                 }];
            };
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat fHeight = 5;
    
    if(section != 0)
    {
        fHeight = 20;
    }
    
    return fHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        SettingsViewController *settingsViewController = [[SettingsViewController alloc]init];
        if ([indexPath row] == 0)
        {
            [settingsViewController setType:SETTING_TYPE_IMAGE];
        }
        else if([indexPath row] == 1)
        {
            [settingsViewController setType:SETTING_TYPE_WEIGHT];
        }
        else if([indexPath row] == 2)
        {
            [settingsViewController setType:SETTING_TYPE_HEIGHT];
        }
        else if([indexPath row] == 3)
        {
            [settingsViewController setType:SETTING_TYPE_AGE];
        }
        else
        {
            UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
            
            if (userInfo != nil) {
                if (userInfo.ban_time > 0) {
                    [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:self.view hiddenAfter:2];
                    return;
                }
                else if(userInfo.ban_time < 0)
                {
                    [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:self.view hiddenAfter:2];
                    return;
                }
            }
            
            if (userInfo.phone_number.length == 0) {
                BindPhoneViewController *bindPhoneViewController = [[BindPhoneViewController alloc]init];
                [self.navigationController pushViewController:bindPhoneViewController animated:YES];
            }

            return;
        }
        
        [self.navigationController pushViewController:settingsViewController animated:YES];
    }
    else if(indexPath.section == 1)
    {
        HelpUsedViewController *helpUsedViewController = [[HelpUsedViewController alloc]init];
        [self.navigationController pushViewController:helpUsedViewController animated:YES];
    }
}

@end
