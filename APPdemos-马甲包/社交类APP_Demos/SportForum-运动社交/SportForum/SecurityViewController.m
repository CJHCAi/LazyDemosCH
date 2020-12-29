//
//  SecurityViewController.m
//  SportForum
//
//  Created by liyuan on 4/2/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "SecurityViewController.h"
#import "UIViewController+SportFormu.h"
#import "SecurityPasswordViewController.h"
#import "BindPhoneViewController.h"
#import "AlertManager.h"

@interface SecurityItem : NSObject

@property(nonatomic, copy) NSString* itemImg;
@property(nonatomic, copy) NSString* itemTitle;
@property(nonatomic, copy) NSString* itemValue;

@end

@implementation SecurityItem

@end

@interface SecurityViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SecurityViewController
{
    NSMutableArray* m_accountItems;
    UITableView *m_tableSecurity;
}

-(void)loadSecurityItems
{
    [m_accountItems removeAllObjects];
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if([CommonFunction ConvertStringToLoginType:userInfo.account_type] != login_type_weibo)
    {
        SecurityItem *securityItem = [[SecurityItem alloc]init];
        securityItem.itemTitle = @"重设密码";
        securityItem.itemImg = @"me-security-key";
        [m_accountItems addObject:securityItem];
    }
    
    SecurityItem *securityItem = [[SecurityItem alloc]init];
    securityItem.itemTitle = @"手机认证";
    
    if (userInfo.phone_number.length > 0) {
        securityItem.itemImg = @"me-security-phone-v";
        NSString *strNum = [userInfo.phone_number substringToIndex:(userInfo.phone_number.length - 4)];
        securityItem.itemValue = [NSString stringWithFormat:@"%@****", strNum];
    }
    else
    {
        securityItem.itemImg = @"me-security-phone-unverified";
        securityItem.itemValue = @"未绑定";
    }
    
    [m_accountItems addObject:securityItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo:) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
    
    [self generateCommonViewInParent:self.view Title:@"安全" IsNeedBackBtn:YES];
    
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
    
    m_accountItems = [[NSMutableArray alloc]init];
    [self loadSecurityItems];
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    m_tableSecurity = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    m_tableSecurity.delegate = self;
    m_tableSecurity.dataSource = self;
    [viewBody addSubview:m_tableSecurity];
    
    [m_tableSecurity reloadData];
    m_tableSecurity.backgroundColor = [UIColor clearColor];
    m_tableSecurity.separatorColor = [UIColor clearColor];
    
    if ([m_tableSecurity respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableSecurity setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"安全 - SecurityViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"安全 - SecurityViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"安全 - SecurityViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"SecurityViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleUpdateProfileInfo:(NSNotification*) notification
{
    [self loadSecurityItems];
    [m_tableSecurity reloadData];
}

#pragma mark - Table Logic

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_accountItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"SecurityIdentifier";
    SecurityItem *securityItem = m_accountItems[[indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imgView = [[UIImageView alloc]init];
        imgView.tag = 9;
        [cell.contentView addSubview:imgView];
        
        UILabel *lbTitle = [[UILabel alloc]init];
        lbTitle.font = [UIFont boldSystemFontOfSize:14.0];
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = [UIColor darkGrayColor];
        lbTitle.tag = 10;
        [cell.contentView addSubview:lbTitle];
        
        UILabel *lbValue = [[UILabel alloc]init];
        lbValue.font = [UIFont boldSystemFontOfSize:14.0];
        lbValue.textAlignment = NSTextAlignmentRight;
        lbValue.backgroundColor = [UIColor clearColor];
        lbValue.textColor = [UIColor darkGrayColor];
        lbValue.tag = 11;
        [cell.contentView addSubview:lbValue];
        
        UILabel *lbSep = [[UILabel alloc]init];
        lbSep.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
        lbSep.tag = 12;
        [cell.contentView addSubview:lbSep];
        
        UIImageView *arrImgView = [[UIImageView alloc]init];
        [arrImgView setImage:[UIImage imageNamed:@"arrow-1"]];
        arrImgView.tag = 13;
        [cell.contentView addSubview:arrImgView];
    }
    
    UIImageView *imgView = (UIImageView*)[cell.contentView viewWithTag:9];
    UILabel *lbTitle = (UILabel*)[cell.contentView viewWithTag:10];
    UILabel *lbValue = (UILabel*)[cell.contentView viewWithTag:11];
    UILabel *lbSep = (UILabel*)[cell.contentView viewWithTag:12];
    UIImageView *arrImgView = (UIImageView*)[cell.contentView viewWithTag:13];
    
    if ([securityItem.itemTitle isEqualToString:@"重设密码"])
    {
        lbValue.hidden = YES;
        
        cell.frame = CGRectMake(0, 0, 310, 52);
        
        [imgView setImage:[UIImage imageNamed:securityItem.itemImg]];
        imgView.frame = CGRectMake(10, 6, 40, 40);
        
        lbTitle.text = securityItem.itemTitle;
        lbTitle.frame = CGRectMake(60, 10, 150, 32);
        
        lbSep.frame = CGRectMake(60, CGRectGetMaxY(cell.frame) - 1, 250, 1);
        arrImgView.frame = CGRectMake(310 - 18, CGRectGetMidY(cell.frame) - 8, 8, 16);
    }
    else if([securityItem.itemTitle isEqualToString:@"手机认证"])
    {
        lbValue.hidden = NO;

        cell.frame = CGRectMake(0, 0, 310, 52);
        
        [imgView setImage:[UIImage imageNamed:securityItem.itemImg]];
        imgView.frame = CGRectMake(10, 6, 40, 40);
        
        lbTitle.text = securityItem.itemTitle;
        lbTitle.frame = CGRectMake(60, 10, 100, 32);
    
        lbSep.frame = CGRectMake(60, CGRectGetMaxY(cell.frame) - 1, 250, 1);
        arrImgView.frame = CGRectMake(310 - 18, CGRectGetMidY(cell.frame) - 8, 8, 16);
        
        lbValue.text = securityItem.itemValue;
        lbValue.frame = CGRectMake(310 - 28 - 100, 10, 100, 32);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecurityItem *securityItem = m_accountItems[[indexPath row]];
    
    if ([securityItem.itemTitle isEqualToString:@"重设密码"])
    {
        SecurityPasswordViewController *securityPasswordViewController = [[SecurityPasswordViewController alloc]init];
        [self.navigationController pushViewController:securityPasswordViewController animated:YES];
    }
    else if([securityItem.itemTitle isEqualToString:@"手机认证"])
    {
        UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;

        if (userInfo.phone_number.length == 0) {
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
            
            BindPhoneViewController *bindPhoneViewController = [[BindPhoneViewController alloc]init];
            [self.navigationController pushViewController:bindPhoneViewController animated:YES];
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
