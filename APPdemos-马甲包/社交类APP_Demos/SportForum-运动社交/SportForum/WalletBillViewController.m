//
//  WalletBillViewController.m
//  SportForum
//
//  Created by zyshi on 14-9-12.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "WalletBillViewController.h"
#import "UIViewController+SportFormu.h"
#import "MBProgressHUD.h"

@interface WalletBillViewController () <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@end

@implementation WalletBillViewController
{
    NSString * _strAddress;
    NSMutableArray * _arrayBill;
    UITableView * _tableBill;
    MBProgressHUD * _HUD;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _strAddress = @"";
        _arrayBill = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generateCommonViewInParent:self.view Title:@"账单" IsNeedBackBtn:YES];
    
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
    
    _tableBill = [[UITableView alloc] initWithFrame:viewBody.bounds];
    [viewBody addSubview:_tableBill];
    _tableBill.dataSource = self;
    _tableBill.delegate = self;
    _tableBill.backgroundColor = [UIColor clearColor];
    _tableBill.separatorColor = [UIColor clearColor];
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [viewBody addSubview:_HUD];
    _HUD.labelText = @"请稍后...";
    _HUD.delegate = self;
    [viewBody bringSubviewToFront:_HUD];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateBill:nil];
    
    [MobClick beginLogPageView:@"账单 - WalletBillViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"账单 - WalletBillViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlWalletTxs, nil]];
    [MobClick endLogPageView:@"账单 - WalletBillViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"WalletBillViewController dealloc called!");
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_arrayBill)
    {
        return _arrayBill.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"billListIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIView * viewBillUnit = [[UIView alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width - 10, 110)];
        viewBillUnit.tag = 40;
        viewBillUnit.backgroundColor = [UIColor whiteColor];
        viewBillUnit.layer.borderColor = [UIColor colorWithRed:237.0 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0].CGColor;
        viewBillUnit.layer.borderWidth = 1.0;
        viewBillUnit.layer.cornerRadius = 5.0;
        /*viewBackground.layer.shadowOffset = CGSizeMake(0, 2);
        viewBackground.layer.shadowRadius = 2.0;
        viewBackground.layer.shadowColor = [UIColor grayColor].CGColor;
        viewBackground.layer.shadowOpacity = 0.8;
        [viewBillUnit addSubview:viewBackground];*/
        [cell.contentView addSubview:viewBillUnit];
        
        UILabel * lbTimeTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
        lbTimeTitle.backgroundColor = [UIColor clearColor];
        lbTimeTitle.font = [UIFont boldSystemFontOfSize:12];
        lbTimeTitle.textAlignment = NSTextAlignmentLeft;
        lbTimeTitle.text = @"时间：";
        [viewBillUnit addSubview:lbTimeTitle];
        
        UILabel * lbTime = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, viewBillUnit.frame.size.width - 80, 20)];
        lbTime.tag = 41;
        lbTime.backgroundColor = [UIColor clearColor];
        lbTime.font = [UIFont boldSystemFontOfSize:12];
        lbTime.textAlignment = NSTextAlignmentLeft;
        [viewBillUnit addSubview:lbTime];
        
        UILabel * lbCountTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 60, 20)];
        lbCountTitle.tag = 42;
        lbCountTitle.backgroundColor = [UIColor clearColor];
        lbCountTitle.font = [UIFont boldSystemFontOfSize:12];
        lbCountTitle.textAlignment = NSTextAlignmentLeft;
        [viewBillUnit addSubview:lbCountTitle];
        
        UILabel * lbCount = [[UILabel alloc] initWithFrame:CGRectMake(70, 30, viewBillUnit.frame.size.width - 80, 20)];
        lbCount.tag = 43;
        lbCount.backgroundColor = [UIColor clearColor];
        lbCount.font = [UIFont boldSystemFontOfSize:12];
        lbCount.textAlignment = NSTextAlignmentLeft;
        [viewBillUnit addSubview:lbCount];
        
        UILabel * lbAddressTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 60, 20)];
        lbAddressTitle.backgroundColor = [UIColor clearColor];
        lbAddressTitle.font = [UIFont boldSystemFontOfSize:12];
        lbAddressTitle.textAlignment = NSTextAlignmentLeft;
        lbAddressTitle.text = @"对方地址：";
        [viewBillUnit addSubview:lbAddressTitle];
        
        UILabel * lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(70, 53, viewBillUnit.frame.size.width - 80, 30)];
        lbAddress.tag = 44;
        lbAddress.backgroundColor = [UIColor clearColor];
        lbAddress.font = [UIFont boldSystemFontOfSize:12];
        lbAddress.textAlignment = NSTextAlignmentLeft;
        lbAddress.numberOfLines = 2;
        [viewBillUnit addSubview:lbAddress];
        
        CSButton * btnCopyAddress = [CSButton buttonWithType:UIButtonTypeCustom];
        btnCopyAddress.tag = 45;
        btnCopyAddress.frame = CGRectMake(10, 85, viewBillUnit.frame.size.width - 70, 20);
        btnCopyAddress.backgroundColor = [UIColor clearColor];
        btnCopyAddress.titleLabel.font = [UIFont boldSystemFontOfSize: 12];
        [btnCopyAddress setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btnCopyAddress.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [viewBillUnit addSubview:btnCopyAddress];
    }

    WalletTradeDetailItem * item = _arrayBill[indexPath.row];
    UIView * viewBillUnit = (UIView *)[cell.contentView viewWithTag: 40];

    NSDate * actionDay = [NSDate dateWithTimeIntervalSince1970:item.time];
    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:actionDay];
    UILabel * lbTime = (UILabel *)[viewBillUnit viewWithTag: 41];
    lbTime.text = [NSString stringWithFormat:@"%04ld年%02ld月%02ld日 %.2ld:%.2ld", (long)[comps year], [comps month], [comps day], (long)[comps hour], (long)[comps minute]];
    
    long long nCoinCount = item.amount;
    UILabel * lbCountTitle = (UILabel *)[viewBillUnit viewWithTag: 42];
    lbCountTitle.text = nCoinCount >= 0 ? @"收入：" : @"支出：";
    
    UILabel * lbCount = (UILabel *)[viewBillUnit viewWithTag: 43];
    lbCount.text = [NSString stringWithFormat:@"%d", abs((int)(nCoinCount / 100000000))];
    lbCount.textColor = nCoinCount >= 0 ? [UIColor greenColor] : [UIColor redColor];
    
    WalletTradeInputItem * tradeInputItem = item.inputs.data[0];
    WalletTradeItem * tradeItem = tradeInputItem.prev_out;
    if(nCoinCount < 0)
    {
        for(int i = 0; i < item.outputs.data.count; i++)
        {
            WalletTradeItem * outItem = item.outputs.data[i];
            BOOL bIsCorrectAddress = YES;
            for(int j = 0; j < item.inputs.data.count; j++)
            {
                WalletTradeInputItem * tradeInputItem = item.inputs.data[j];
                WalletTradeItem * inItem = tradeInputItem.prev_out;
                if([outItem.addr isEqualToString:inItem.addr])
                {
                    bIsCorrectAddress = NO;
                    break;
                }
            }
            if(bIsCorrectAddress)
            {
                tradeItem = outItem;
                break;
            }
        }
    }
    
    UILabel * lbAddress = (UILabel *)[viewBillUnit viewWithTag: 44];
    lbAddress.text = tradeItem.addr;
    [lbAddress sizeToFit];
    
    CSButton * btnCopyAddress = (CSButton *)[viewBillUnit viewWithTag: 45];
    [btnCopyAddress setTitle:[NSString stringWithFormat:@"[点击复制地址%ld]", indexPath.row + 1] forState:UIControlStateNormal];
    btnCopyAddress.hidden = YES;
    
    btnCopyAddress.actionBlock = ^void()
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = tradeItem.addr;
        UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"复制地址成功！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        
        [alertView show];
    };

    return cell;
}

-(void)setTitle:(NSString *)strtitle
{
    UILabel * lbTitle = (UILabel *)[self.view viewWithTag:GENERATE_VIEW_TITLE];
    lbTitle.text = strtitle;
}

-(void)setSelfAddress:(NSString *)strAddress
{
    _strAddress = strAddress;
}

-(void)updateBill:(NSNotification*) notification
{
    __weak typeof (self) thisPoint = self;
    [_HUD show:YES];
    [[SportForumAPI sharedInstance] walletGetTradeListByAddress:_strAddress
                                                  FinishedBlock:^void(int errorCode, WalletTradeDetailInfo* walletTradeDetailInfo)
     {
         typeof(self) thisStrongPoint = thisPoint;
         
         if (thisStrongPoint == nil) {
             return;
         }
         
         [thisStrongPoint->_HUD hide:YES];
         if(errorCode == 0)
         {
             [thisStrongPoint->_arrayBill removeAllObjects];
             
             for(int i = 0; i < walletTradeDetailInfo.txs.data.count; i++)
             {
                 WalletTradeDetailItem * item = walletTradeDetailInfo.txs.data[i];
                 [thisStrongPoint->_arrayBill addObject:item];
             }
             
             [thisStrongPoint->_tableBill reloadData];
         }
     }];
}

@end
