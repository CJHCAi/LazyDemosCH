//
//  AccountInfoViewController.m
//  SportForum
//
//  Created by liyuan on 3/30/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "UIViewController+SportFormu.h"
#import "UIImageView+WebCache.h"
#import "AccountEditViewController.h"
#import "LevelViewController.h"
#import "HistoryViewController.h"
#import "AccountStatisticsViewController.h"
#import "ArticleCircleViewController.h"
#import "CoinCardViewController.h"
#import "SecurityViewController.h"
#import "EquipmentInfoViewController.h"
#import "HelpUsedViewController.h"
#import "CoachAuthViewController.h"
#import "AlertManager.h"

#define ACCOUNT_CONTENT_VIEW 9
#define ACCOUNT_DESC_LABEL_TAG 10
#define ACCOUNT_DESC_IMAGE_TAG 11
#define ACCOUNT_ARROW_IMAGE_TAG 12

@interface AccountItem : NSObject

@property(nonatomic, copy) NSString* itemDesc;
@property(nonatomic, copy) NSString* itemImg;

@end

@implementation AccountItem

@end

@interface AccountInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation AccountInfoViewController
{
    NSArray * _arrTableStruct;
    NSMutableArray* m_accountItems0;
    NSMutableArray* m_accountItems1;
    NSMutableArray* m_accountItems2;
    NSMutableArray* m_accountItems3;
    NSMutableArray* m_accountItems4;
    UITableView *m_tableAccount;
}

-(void)loadTestData
{
    m_accountItems0 = [[NSMutableArray alloc]init];
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];

    AccountItem *accountItem = [[AccountItem alloc]init];
    accountItem.itemDesc = userInfo.nikename;
    accountItem.itemImg = userInfo.profile_image;
    [m_accountItems0 addObject:accountItem];
    
    m_accountItems1 = [[NSMutableArray alloc]init];
    
    accountItem = [[AccountItem alloc]init];
    accountItem.itemDesc = @"装备";
    accountItem.itemImg = @"me-equipment";
    [m_accountItems1 addObject:accountItem];
    
    accountItem = [[AccountItem alloc]init];
    accountItem.itemDesc = @"统计";
    accountItem.itemImg = @"me-data-analysis";
    [m_accountItems1 addObject:accountItem];
    
    accountItem = [[AccountItem alloc]init];
    accountItem.itemDesc = @"教练认证";
    accountItem.itemImg = @"me-coach-applying";
    [m_accountItems1 addObject:accountItem];

    m_accountItems2 = [[NSMutableArray alloc]init];
    
    if ([[ApplicationContext sharedInstance]IsPreSportForm])
    {
        accountItem = [[AccountItem alloc]init];
        accountItem.itemDesc = @"金币卡";
        accountItem.itemImg = @"me-beibit-card";
        [m_accountItems2 addObject:accountItem];
    }

    accountItem = [[AccountItem alloc]init];
    accountItem.itemDesc = @"江湖史";
    accountItem.itemImg = @"me-history";
    [m_accountItems2 addObject:accountItem];
    
    m_accountItems3 = [[NSMutableArray alloc]init];
    
    accountItem = [[AccountItem alloc]init];
    accountItem.itemDesc = @"我的博文";
    accountItem.itemImg = @"me-blog";
    [m_accountItems3 addObject:accountItem];
    
    accountItem = [[AccountItem alloc]init];
    accountItem.itemDesc = @"我的回复";
    accountItem.itemImg = @"me-reply-icon";
    [m_accountItems3 addObject:accountItem];
    
    m_accountItems4 = [[NSMutableArray alloc]init];
    
    accountItem = [[AccountItem alloc]init];
    accountItem.itemDesc = @"等级";
    accountItem.itemImg = @"me-level";
    [m_accountItems4 addObject:accountItem];
    
    if([CommonFunction ConvertStringToLoginType:userInfo.account_type] != login_type_weibo)
    {
        accountItem = [[AccountItem alloc]init];
        accountItem.itemDesc = @"安全";
        accountItem.itemImg = @"me-security";
        [m_accountItems4 addObject:accountItem];
    }

    /*accountItem = [[AccountItem alloc]init];
    accountItem.itemDesc = @"帮助";
    accountItem.itemImg = @"me-task-help";
    [m_accountItems3 addObject:accountItem];*/
    

    
    _arrTableStruct = [NSArray arrayWithObjects:
                       [NSNumber numberWithInt:(int)m_accountItems0.count],
                       [NSNumber numberWithInt:(int)m_accountItems1.count],
                       [NSNumber numberWithInt:(int)m_accountItems2.count],
                       [NSNumber numberWithInt:(int)m_accountItems3.count],
                       [NSNumber numberWithInt:(int)m_accountItems4.count],
                       [NSNumber numberWithInt:1],
                       nil];
}

-(BOOL)bShowFooterViewController {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo:) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
    
    [self generateCommonViewInParent:self.view Title:@"我" IsNeedBackBtn:NO];
    [self loadTestData];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    
    CGRect rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    m_tableAccount = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    m_tableAccount.delegate = self;
    m_tableAccount.dataSource = self;
    [viewBody addSubview:m_tableAccount];
    [m_tableAccount reloadData];
    
    m_tableAccount.backgroundColor = [UIColor clearColor];
    m_tableAccount.separatorColor = [UIColor clearColor];
    
    if ([m_tableAccount respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableAccount setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我 - AccountInfoViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"我 - AccountInfoViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我 - AccountInfoViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"AccountInfoViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleUpdateProfileInfo:(NSNotification*) notification
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if (userInfo.userid.length > 0) {
        
        AccountItem *accountItem = m_accountItems0[0];
        accountItem.itemDesc = userInfo.nikename;
        accountItem.itemImg = userInfo.profile_image;
        
        [m_tableAccount beginUpdates];
        [m_tableAccount reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [m_tableAccount endUpdates];
    }
}

-(void)checkFirstFillItem:(NSInteger)nFillItem
{
    BOOL bFirst80 = [[[ApplicationContext sharedInstance] getObjectByKey:@"80Percent"]boolValue];
    float fPercent = nFillItem * 1.0 / 13.0;
    
    if (!bFirst80 && (fPercent >= 0.8 && fPercent < 1)) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"80Percent"];
        [[ApplicationContext sharedInstance] saveObject:@(YES) byKey:@"80Percent"];
        [JDStatusBarNotification showWithStatus:@"恭喜已完善资料80%，奖励30个金币~" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleSuccess];
    }
    
    BOOL bFirst100 = [[[ApplicationContext sharedInstance] getObjectByKey:@"100Percent"]boolValue];
    
    if (!bFirst100 && nFillItem == 13) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"100Percent"];
        [[ApplicationContext sharedInstance] saveObject:@(YES) byKey:@"100Percent"];
        [JDStatusBarNotification showWithStatus:@"恭喜已完善所有资料，奖励50个金币~" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleSuccess];
    }
}

-(NSInteger)getUnFillItemCount
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    NSInteger nUnFillItem = 0;
    
    if (userInfo.nikename.length == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.profile_image.length == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.user_images.data.count == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.sign.length == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.emotion.length == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.profession.length == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.fond.length == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.hometown.length == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.oftenAppear.length == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.height == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.sex_type.length == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.birthday == 0) {
        nUnFillItem++;
    }
    
    if (userInfo.weight == 0) {
        nUnFillItem++;
    }
    
    [self checkFirstFillItem:(13 - nUnFillItem)];
    return nUnFillItem;
}

#pragma mark - Table Logic
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_arrTableStruct objectAtIndex:section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_arrTableStruct count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == _arrTableStruct.count - 1) {
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
            [btnLogout setBackgroundImage:imgButton forState:UIControlStateNormal];
            [btnLogout setTitle:@"退出登录" forState:UIControlStateNormal];
            [btnLogout setTitleColor:[UIColor colorWithRed:138.0 / 255.0 green:22.0 / 255.0 blue:0 alpha:1.0] forState:UIControlStateNormal];
            [btnLogout setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
            [btnLogout.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [btnLogout setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 3, 0)];
            [cell.contentView addSubview:btnLogout];
            
            btnLogout.actionBlock = ^void()
            {
                id _process = [AlertManager showCommonProgress];
                
                [[ApplicationContext sharedInstance] logout:^void(int errorCode)
                 {
                     [AlertManager dissmiss:_process];
                     
                     if(errorCode == 0)
                     {
                         [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_MESSAGE_SWITCH_VIEW object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:VIEW_LOGIN_PAGE, @"PageName", nil]];
                     }
                 }];
            };
        }
        
        return cell;
    }
    else if([indexPath section] == 0)
    {
        static NSString *CellTableIdentifier = @"ProfileInfoIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView* viewContent = [[UIImageView alloc]init];
            viewContent.tag = 70000;
            [cell.contentView addSubview:viewContent];
            
            UIImageView * imgDescImage = [[UIImageView alloc] init];
            imgDescImage.tag = 70001;
            imgDescImage.layer.cornerRadius = 5.0;
            imgDescImage.layer.masksToBounds = YES;
            [viewContent addSubview:imgDescImage];
            
            UILabel * lbAccountDesc = [[UILabel alloc]init];
            lbAccountDesc.font = [UIFont boldSystemFontOfSize:14.0];
            lbAccountDesc.textAlignment = NSTextAlignmentLeft;
            lbAccountDesc.backgroundColor = [UIColor clearColor];
            lbAccountDesc.textColor = [UIColor blackColor];
            lbAccountDesc.tag = 70002;
            [viewContent addSubview:lbAccountDesc];
            
            UILabel * lbAccountDesc1 = [[UILabel alloc]init];
            lbAccountDesc1.font = [UIFont systemFontOfSize:13.0];
            lbAccountDesc1.textAlignment = NSTextAlignmentLeft;
            lbAccountDesc1.backgroundColor = [UIColor clearColor];
            lbAccountDesc1.textColor = [UIColor darkGrayColor];
            lbAccountDesc1.tag = 70003;
            [viewContent addSubview:lbAccountDesc1];
            
            UILabel * lbAccountDesc2 = [[UILabel alloc]init];
            lbAccountDesc2.font = [UIFont systemFontOfSize:12.0];
            lbAccountDesc2.textAlignment = NSTextAlignmentLeft;
            lbAccountDesc2.backgroundColor = [UIColor clearColor];
            lbAccountDesc2.textColor = [UIColor lightGrayColor];
            lbAccountDesc2.tag = 70004;
            [viewContent addSubview:lbAccountDesc2];
            
            UIImageView * imgArrow = [[UIImageView alloc] init];
            imgArrow.tag = 70005;
            [viewContent addSubview:imgArrow];
        }
        
        
        AccountItem *accountItem = m_accountItems0[[indexPath row]];
        
        UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
        imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
        
        UIImageView *viewContent = (UIImageView*)[cell.contentView viewWithTag:70000];
        viewContent.frame = CGRectMake(5, 2, 300, 85);
        [viewContent setImage:imgBk];
        
        UIImageView *imgDescImage = (UIImageView*)[viewContent viewWithTag:70001];
        imgDescImage.frame = CGRectMake(8, 8, 65, 65);

        [imgDescImage sd_setImageWithURL:[NSURL URLWithString:accountItem.itemImg]
                            placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        
        UILabel * lbAccountDesc = (UILabel*)[viewContent viewWithTag:70002];
        lbAccountDesc.text = accountItem.itemDesc;
        lbAccountDesc.frame = CGRectMake(CGRectGetMaxX(imgDescImage.frame) + 10, 10, 200, 20);
        
        NSInteger nUserUnFillItem = [self getUnFillItemCount];
    
        UILabel * lbAccountDesc1 = (UILabel*)[viewContent viewWithTag:70003];
        lbAccountDesc1.text = nUserUnFillItem == 0 ? @"个人信息已基本完善" : [NSString stringWithFormat:@"个人信息有%.f%%未完善", nUserUnFillItem * 100.00 / 13.00];
        lbAccountDesc1.frame = CGRectMake(CGRectGetMaxX(imgDescImage.frame) + 10, CGRectGetMaxY(lbAccountDesc.frame), 200, 20);
        
        BOOL b100Percent = [[[ApplicationContext sharedInstance] getObjectByKey:@"100Percent"]boolValue];
        UILabel * lbAccountDesc2 = (UILabel*)[viewContent viewWithTag:70004];
        lbAccountDesc2.text = b100Percent ? @"完善资料,凸显真实自我" : @"完善资料,凸显真实自我,可获取50金币";
        lbAccountDesc2.frame = CGRectMake(CGRectGetMaxX(imgDescImage.frame) + 10, CGRectGetMaxY(lbAccountDesc1.frame), 225, 20);
        
        UIImageView * imgArrow = (UIImageView*)[cell.contentView viewWithTag:70005];
        UIImage *image = [UIImage imageNamed:@"arrow-1"];
        [imgArrow setImage:image];
        imgArrow.frame = CGRectMake(viewContent.frame.size.width - 15 - image.size.width, CGRectGetHeight(viewContent.frame) / 2 - image.size.height / 2, image.size.width, image.size.height);
        
        return cell;
    }
    else
    {
        static NSString *CellTableIdentifier = @"AccountInfoIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIImageView* viewContent = [[UIImageView alloc]init];
            viewContent.tag = ACCOUNT_CONTENT_VIEW;
            [cell.contentView addSubview:viewContent];
            
            UIImageView * imgDescImage = [[UIImageView alloc] init];
            imgDescImage.tag = ACCOUNT_DESC_IMAGE_TAG;
            imgDescImage.layer.cornerRadius = 5.0;
            imgDescImage.layer.masksToBounds = YES;
            [viewContent addSubview:imgDescImage];
            
            UIImageView * imgImage = [[UIImageView alloc] init];
            imgImage.tag = 13;
            [viewContent addSubview:imgImage];
            
            UILabel * lbAccountDesc = [[UILabel alloc]init];
            lbAccountDesc.font = [UIFont boldSystemFontOfSize:14.0];
            lbAccountDesc.textAlignment = NSTextAlignmentLeft;
            lbAccountDesc.backgroundColor = [UIColor clearColor];
            lbAccountDesc.textColor = [UIColor blackColor];
            lbAccountDesc.tag = ACCOUNT_DESC_LABEL_TAG;
            [viewContent addSubview:lbAccountDesc];
            
            UIImageView * imgArrow = [[UIImageView alloc] init];
            imgArrow.tag = ACCOUNT_ARROW_IMAGE_TAG;
            [viewContent addSubview:imgArrow];
        }
        
        AccountItem *accountItem = nil;
        
        if([indexPath section] == 1)
        {
            accountItem = m_accountItems1[[indexPath row]];
        }
        else if([indexPath section] == 2)
        {
            accountItem = m_accountItems2[[indexPath row]];
        }
        else if([indexPath section] == 3)
        {
            accountItem = m_accountItems3[[indexPath row]];
        }
        else if([indexPath section] == 4)
        {
            accountItem = m_accountItems4[[indexPath row]];
        }
        
        UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
        imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
        
        UIImageView *viewContent = (UIImageView*)[cell.contentView viewWithTag:ACCOUNT_CONTENT_VIEW];
        viewContent.frame = CGRectMake(5, 1, 300, 50);
        [viewContent setImage:imgBk];
        
        UIImageView *imgDescImage = (UIImageView*)[viewContent viewWithTag:ACCOUNT_DESC_IMAGE_TAG];
        imgDescImage.frame = CGRectMake(8, 3, 40, 40);
        
        UIImageView *imgImage = (UIImageView*)[viewContent viewWithTag:13];
        imgImage.frame = CGRectMake(8, 3, 40, 40);
        
        if ([indexPath section] == 0 && [indexPath row] == 0) {
            imgImage.hidden = YES;
            imgDescImage.hidden = NO;
            [imgDescImage sd_setImageWithURL:[NSURL URLWithString:accountItem.itemImg]
                            placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        }
        else
        {
            imgImage.hidden = NO;
            imgDescImage.hidden = YES;
            
            UIImage *image = [UIImage imageNamed:accountItem.itemImg];
            [imgImage setImage:image];
        }
        
        UILabel * lbAccountDesc = (UILabel*)[viewContent viewWithTag:ACCOUNT_DESC_LABEL_TAG];
        lbAccountDesc.text = accountItem.itemDesc;
        lbAccountDesc.frame = CGRectMake(15 + imgDescImage.frame.size.width, 15, 150, 20);
        
        UIImageView * imgArrow = (UIImageView*)[cell.contentView viewWithTag:ACCOUNT_ARROW_IMAGE_TAG];
        UIImage *image = [UIImage imageNamed:@"arrow-1"];
        [imgArrow setImage:image];
        imgArrow.frame = CGRectMake(viewContent.frame.size.width - 15 - image.size.width, 15, image.size.width, image.size.height);
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section > 0 ? 52 : 89;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat fHeight = 5;
    
    if(section > 0)
    {
        fHeight = 8;
    }
    
    return fHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AccountItem *accountItem = nil;
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if ([indexPath section] == 0) {
        accountItem = m_accountItems0[[indexPath row]];
    }
    else if([indexPath section] == 1)
    {
        accountItem = m_accountItems1[[indexPath row]];
    }
    else if([indexPath section] == 2)
    {
        accountItem = m_accountItems2[[indexPath row]];
    }
    else if([indexPath section] == 3)
    {
        accountItem = m_accountItems3[[indexPath row]];
    }
    else if([indexPath section] == 4)
    {
        accountItem = m_accountItems4[[indexPath row]];
    }
    
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0) {
            AccountEditViewController *accountEditViewController = [[AccountEditViewController alloc]init];
            [self.navigationController pushViewController:accountEditViewController animated:YES];
        }
    }
    else if([indexPath section] == 1) {
        if ([indexPath row] == 0) {
            EquipmentInfoViewController *equipmentInfoViewController = [[EquipmentInfoViewController alloc]init];
            [self.navigationController pushViewController:equipmentInfoViewController animated:YES];
        }
        else if([indexPath row] == 1)
        {
            AccountStatisticsViewController *accountStatisticsViewController = [[AccountStatisticsViewController alloc]init];
            [self.navigationController pushViewController:accountStatisticsViewController animated:YES];
        }
        else if([indexPath row] == 2)
        {
            CoachAuthViewController *coachAuthViewController = [[CoachAuthViewController alloc]init];
            [self.navigationController pushViewController:coachAuthViewController animated:YES];
        }
    }
    else if([indexPath section] == 2)
    {
        if ([[ApplicationContext sharedInstance]IsPreSportForm]){
            if ([indexPath row] == 0) {
                CoinCardViewController *coinCardViewController = [[CoinCardViewController alloc]init];
                [self.navigationController pushViewController:coinCardViewController animated:YES];
            }
            else if([indexPath row] == 1)
            {
                HistoryViewController *historyViewController = [[HistoryViewController alloc]init];
                historyViewController.userInfo = [[ApplicationContext sharedInstance]accountInfo];
                [historyViewController setHistoryType:HISTORY_TYPE_ALL];
                [self.navigationController pushViewController:historyViewController animated:YES];
            }
        }
        else
        {
            HistoryViewController *historyViewController = [[HistoryViewController alloc]init];
            historyViewController.userInfo = [[ApplicationContext sharedInstance]accountInfo];
            [historyViewController setHistoryType:HISTORY_TYPE_ALL];
            [self.navigationController pushViewController:historyViewController animated:YES];
        }
    }
    else if([indexPath section] == 3)
    {
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        ArticleCircleViewController * articleCircleViewController = [[ArticleCircleViewController alloc]init];
        articleCircleViewController.strAuthorId = userInfo.userid;
        
        if ([indexPath row] == 0) {
            articleCircleViewController.bComment = NO;
        }
        else if([indexPath row] == 1)
        {
            articleCircleViewController.bComment = YES;
        }
        
        [self.navigationController pushViewController:articleCircleViewController animated:YES];
    }
    else if([indexPath section] == 4)
    {
        if ([indexPath row] == 0) {
            LevelViewController *levelViewController = [[LevelViewController alloc]init];
            [self.navigationController pushViewController:levelViewController animated:YES];
        }
        else if([indexPath row] == 1)
        {
            if([CommonFunction ConvertStringToLoginType:userInfo.account_type] != login_type_weibo)
            {
                SecurityViewController *securityViewController = [[SecurityViewController alloc]init];
                [self.navigationController pushViewController:securityViewController animated:YES];
            }
            else
            {
                HelpUsedViewController *helpUsedViewController = [[HelpUsedViewController alloc]init];
                [self.navigationController pushViewController:helpUsedViewController animated:YES];
            }
        }
        else if([indexPath row] == 2)
        {
            HelpUsedViewController *helpUsedViewController = [[HelpUsedViewController alloc]init];
            [self.navigationController pushViewController:helpUsedViewController animated:YES];
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
