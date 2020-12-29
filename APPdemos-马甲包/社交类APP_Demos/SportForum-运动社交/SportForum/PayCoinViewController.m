//
//  PayCoinViewController.m
//  SportForum
//
//  Created by liyuan on 15/3/6.
//  Copyright (c) 2015年 zhengying. All rights reserved.
//

#import "PayCoinViewController.h"
#import "UIViewController+SportFormu.h"
#import "PayCoinTableViewCell.h"
#import "IAPManager.h"
#import "AlertManager.h"
#import "PayHistoryViewController.h"

@interface PayCoinViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PayCoinViewController
{
    NSMutableArray* m_arrPayItems;
    UITableView *m_tablePay;
    
    id m_processWindow;
}

-(void)loadTestData
{
    m_arrPayItems = [[NSMutableArray alloc]init];
    
    PayCoinItem *payCoinItem = [[PayCoinItem alloc]init];
    payCoinItem.payId = @"com.ice139.SportForum.1";
    payCoinItem.payImage = @"beibit";
    payCoinItem.payDesc = @"x 60";
    payCoinItem.payValue = 6;
    payCoinItem.coin_value = 6000000000;
    [m_arrPayItems addObject:payCoinItem];
    
    payCoinItem = [[PayCoinItem alloc]init];
    payCoinItem.payId = @"com.ice139.SportForum.2";
    payCoinItem.payImage = @"beibit";
    payCoinItem.payDesc = @"x 120";
    payCoinItem.payValue = 12;
    payCoinItem.coin_value = 12000000000;
    [m_arrPayItems addObject:payCoinItem];
    
    payCoinItem = [[PayCoinItem alloc]init];
    payCoinItem.payId = @"com.ice139.SportForum.3";
    payCoinItem.payImage = @"beibit";
    payCoinItem.payDesc = @"x 180";
    payCoinItem.payValue = 18;
    payCoinItem.coin_value = 18000000000;
    [m_arrPayItems addObject:payCoinItem];
    
    payCoinItem = [[PayCoinItem alloc]init];
    payCoinItem.payId = @"com.ice139.SportForum.4";
    payCoinItem.payImage = @"beibit";
    payCoinItem.payDesc = @"x 240";
    payCoinItem.payValue = 24;
    payCoinItem.coin_value = 24000000000;
    [m_arrPayItems addObject:payCoinItem];
    
    payCoinItem = [[PayCoinItem alloc]init];
    payCoinItem.payId = @"com.ice139.SportForum.5";
    payCoinItem.payImage = @"beibit";
    payCoinItem.payDesc = @"x 300";
    payCoinItem.payValue = 30;
    payCoinItem.coin_value = 30000000000;
    [m_arrPayItems addObject:payCoinItem];
    
    payCoinItem = [[PayCoinItem alloc]init];
    payCoinItem.payId = @"com.ice139.SportForum.6";
    payCoinItem.payImage = @"beibit";
    payCoinItem.payDesc = @"x 600";
    payCoinItem.payValue = 60;
    payCoinItem.coin_value = 60000000000;
    [m_arrPayItems addObject:payCoinItem];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"购买金币" IsNeedBackBtn:YES];
    
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
    
    [self loadTestData];
    
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height - 10);
    m_tablePay = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    m_tablePay.delegate = self;
    m_tablePay.dataSource = self;
    m_tablePay.allowsSelection = NO;
    [viewBody addSubview:m_tablePay];
    
    [m_tablePay reloadData];
    m_tablePay.backgroundColor = [UIColor clearColor];
    m_tablePay.separatorColor = [UIColor clearColor];
    
    if ([m_tablePay respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tablePay setSeparatorInset:UIEdgeInsetsZero];
    }
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"购买金币 - PayCoinViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"购买金币 - PayCoinViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"购买金币 - PayCoinViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"PayCoinViewController dealloc called!");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [m_arrPayItems count];
    }
    else
    {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        PayCoinItem *payCoinItem = m_arrPayItems[indexPath.row];
        PayCoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PayCoinTableViewCell"];
        
        if (cell == nil) {
            cell = [[PayCoinTableViewCell alloc]initWithReuseIdentifier:@"PayCoinTableViewCell"];
        }
        
        __weak __typeof(self) weakSelf = self;
        
        cell.payClickBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            
            [strongSelf showCommonProgress];
            
            [[IAPManager sharedIAPManager] purchaseProductForId:payCoinItem.payId
                                                     completion:^(SKPaymentTransaction *transaction) {
                                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                         
                                                         [[SportForumAPI sharedInstance]userPurchaseSuccessFromCoin:payCoinItem.coin_value BuyTime:[[NSDate date]timeIntervalSince1970] BuyValue:payCoinItem.payValue FinishedBlock:^(int errorCode, ExpEffect *expEffect) {
                                                             if (errorCode == 0) {
                                                                 UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                                                                 
                                                                 [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                                                                  {
                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                                                                  }];
                                                             }
                                                         }];
                                                         
                                                         [strongSelf hidenCommonProgress];
                                                         [[IAPManager sharedIAPManager] removePurchasesArray];
                                                     } error:^(NSError *err) {
                                                         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                         NSLog(@"An error occured while purchasing: %@", err.localizedDescription);
                                                         // show an error alert to the user.
                                                         
                                                         [JDStatusBarNotification showWithStatus:@"交易失败，未能完成支付！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                                                         
                                                         [strongSelf hidenCommonProgress];
                                                         [[IAPManager sharedIAPManager] removePurchasesArray];
                                                     }];
        };
        
        cell.payCoinItem = payCoinItem;

        return cell;
    }
    else
    {
        static NSString *CellTableIdentifier = @"BuyHistoryIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIView * viewContent = [[UIView alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width - 10, 60)];
            viewContent.tag = 104;
            viewContent.backgroundColor = [UIColor whiteColor];
            viewContent.layer.borderColor = [UIColor colorWithRed:237.0 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0].CGColor;
            viewContent.layer.borderWidth = 1.0;
            viewContent.layer.cornerRadius = 5.0;
            [cell.contentView addSubview:viewContent];
            
            UIImageView * imgImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 40, 40)];
            imgImage.tag = 105;
            [viewContent addSubview:imgImage];
            
            UILabel * lbSettingItemTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 18, 150, 24)];
            lbSettingItemTitle.font = [UIFont boldSystemFontOfSize:14.0];
            lbSettingItemTitle.textAlignment = NSTextAlignmentLeft;
            lbSettingItemTitle.backgroundColor = [UIColor clearColor];
            lbSettingItemTitle.textColor = [UIColor blackColor];
            lbSettingItemTitle.tag = 106;
            [viewContent addSubview:lbSettingItemTitle];
            
            UIImageView * imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 22, 8, 16)];
            imgArrow.image = [UIImage imageNamed:@"arrow-1"];
            [viewContent addSubview:imgArrow];
            
            CSButton * btnHistory = [CSButton buttonWithType:UIButtonTypeCustom];
            btnHistory.frame = CGRectMake(0, 0, CGRectGetWidth(viewContent.frame), CGRectGetHeight(viewContent.frame));
            [viewContent addSubview:btnHistory];
            
            __weak __typeof(self) weakSelf = self;
                
            btnHistory.actionBlock = ^void()
            {
                __typeof(self) strongSelf = weakSelf;
                PayHistoryViewController *payHistoryViewController = [[PayHistoryViewController alloc]init];
                [strongSelf.navigationController pushViewController:payHistoryViewController animated:YES];
            };
        }
        
        UIImageView *viewContent = (UIImageView*)[cell.contentView viewWithTag:104];
        
        UIImage * image = [UIImage imageNamed:@"beibi-buy-history"];
        NSString * strTitle = @"购买历史";
        
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(image.size.height / 2) - 2, floorf(image.size.width / 2) - 2, floorf(image.size.height / 2) + 2, floorf(image.size.width / 2) + 2)];
        
        UIImageView *imgDescImage = (UIImageView*)[viewContent viewWithTag:105];
        [imgDescImage setImage:image];
        
        UILabel * lbSettingItemTitle = (UILabel*)[viewContent viewWithTag:106];
        lbSettingItemTitle.text = strTitle;
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [PayCoinTableViewCell heightOfCell];
    }
    else
    {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 40;
    }
    else
    {
        return 20;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    
    if (section == 0) {
        view.frame = CGRectMake(0, 0, CGRectGetWidth(m_tablePay.frame), 40);
        view.backgroundColor = [UIColor colorWithRed:205.0 / 255.0 green:205.0 / 255.0 blue:205.0 / 255.0 alpha:1.0];
        
        UILabel * lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
        lbTitle.font = [UIFont boldSystemFontOfSize:14.0];
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.text = @"选择购买金额";
        lbTitle.textColor = [UIColor whiteColor];
        [view addSubview:lbTitle];
    }
    else
    {
        view.frame = CGRectMake(0, 0, CGRectGetWidth(m_tablePay.frame), 25);
        view.backgroundColor = [UIColor clearColor];
    }
    
    return view;
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
