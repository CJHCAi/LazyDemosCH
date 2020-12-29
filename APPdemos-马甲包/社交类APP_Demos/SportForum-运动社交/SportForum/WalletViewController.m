//
//  WalletViewController.m
//  SportForum
//
//  Created by zyshi on 14-9-11.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "WalletViewController.h"
#import "UIViewController+SportFormu.h"
#import "CSButton.h"
#import "WalletBillViewController.h"
#import "WalletTransferViewController.h"
#import "MBProgressHUD.h"
#import "PayCoinViewController.h"

@interface WalletViewController () <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@end

@implementation WalletViewController
{
    NSMutableArray * _arrayWallet;
    
    UITableView * _tableWallet;

    MBProgressHUD * _HUD;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _arrayWallet = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWallet) name:NOTIFY_MESSAGE_WALLET_UPDATE object:nil];

    [self generateCommonViewInParent:self.view Title:@"管理钱包" IsNeedBackBtn:YES];
    
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
    
    _tableWallet = [[UITableView alloc] initWithFrame:viewBody.bounds];
    [viewBody addSubview:_tableWallet];
    _tableWallet.dataSource = self;
    _tableWallet.delegate = self;
    _tableWallet.backgroundColor = [UIColor clearColor];
    _tableWallet.separatorColor = [UIColor clearColor];
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [viewBody addSubview:_HUD];
    _HUD.labelText = @"请稍后...";
    _HUD.delegate = self;
    [viewBody bringSubviewToFront:_HUD];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateWallet];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlWalletBalance, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"WalletViewController dealloc called!");
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
    NSInteger nSection = 3;
    
    if(_arrayWallet)
    {
        nSection = _arrayWallet.count + 3;
    }
    
    return nSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _arrayWallet.count)
    {
        return 190;
    }
    else if(indexPath.row == _arrayWallet.count)
    {
        return 110;
    }
    else
    {
        return 70;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"walletListIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIView * viewNewWallet = [[UIView alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width - 10, 100)];
        viewNewWallet.tag = 20;
        viewNewWallet.backgroundColor = [UIColor whiteColor];
        viewNewWallet.layer.borderColor = [UIColor colorWithRed:237.0 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0].CGColor;
        viewNewWallet.layer.borderWidth = 1.0;
        viewNewWallet.layer.cornerRadius = 5.0;
        [cell.contentView addSubview:viewNewWallet];
        
        UIView * viewCurrentWallet = [[UIView alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width - 10, 180)];
        viewCurrentWallet.tag = 21;
        viewCurrentWallet.backgroundColor = [UIColor whiteColor];
        viewCurrentWallet.layer.borderColor = [UIColor colorWithRed:237.0 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0].CGColor;
        viewCurrentWallet.layer.borderWidth = 1.0;
        viewCurrentWallet.layer.cornerRadius = 5.0;
        [cell.contentView addSubview:viewCurrentWallet];
        
        UIView * viewCoinWeb = [[UIView alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width - 10, 60)];
        viewCoinWeb.tag = 22;
        viewCoinWeb.backgroundColor = [UIColor whiteColor];
        viewCoinWeb.layer.borderColor = [UIColor colorWithRed:237.0 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0].CGColor;
        viewCoinWeb.layer.borderWidth = 1.0;
        viewCoinWeb.layer.cornerRadius = 5.0;
        [cell.contentView addSubview:viewCoinWeb];
        
        UIView * viewBuyCoin = [[UIView alloc] initWithFrame:CGRectMake(5, 5, tableView.frame.size.width - 10, 60)];
        viewBuyCoin.tag = 19;
        viewBuyCoin.backgroundColor = [UIColor whiteColor];
        viewBuyCoin.layer.borderColor = [UIColor colorWithRed:237.0 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1.0].CGColor;
        viewBuyCoin.layer.borderWidth = 1.0;
        viewBuyCoin.layer.cornerRadius = 5.0;
        [cell.contentView addSubview:viewBuyCoin];
        
        UILabel * lbAddWalletDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, viewNewWallet.frame.size.width - 20, 40)];
        lbAddWalletDescription.backgroundColor = [UIColor clearColor];
        lbAddWalletDescription.textColor = [UIColor grayColor];
        lbAddWalletDescription.text = @"新的钱包地址可以加强交易的隐匿性，让他人无法追踪，增强交易的安全性。";
        lbAddWalletDescription.font = [UIFont systemFontOfSize:10];
        lbAddWalletDescription.textAlignment = NSTextAlignmentLeft;
        lbAddWalletDescription.numberOfLines = 2;
        [viewNewWallet addSubview:lbAddWalletDescription];
        
        UILabel * lbSeparateAddWallet = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, viewNewWallet.frame.size.width - 20, 2)];
        lbSeparateAddWallet.backgroundColor = [UIColor colorWithRed:217 / 255.0 green:217 / 255.0 blue:217 / 255.0 alpha:1.0];
        [viewNewWallet addSubview:lbSeparateAddWallet];
        
        UILabel * lbSeparateCurrentWallet1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 85, viewCurrentWallet.frame.size.width - 20, 2)];
        lbSeparateCurrentWallet1.backgroundColor = [UIColor colorWithRed:217 / 255.0 green:217 / 255.0 blue:217 / 255.0 alpha:1.0];
        [viewCurrentWallet addSubview:lbSeparateCurrentWallet1];
        
        UILabel * lbSeparateCurrentWallet2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 120, viewCurrentWallet.frame.size.width - 20, 2)];
        lbSeparateCurrentWallet2.backgroundColor = [UIColor colorWithRed:217 / 255.0 green:217 / 255.0 blue:217 / 255.0 alpha:1.0];
        [viewCurrentWallet addSubview:lbSeparateCurrentWallet2];
        
        UIImage * imgButton = [UIImage imageNamed:@"btn-3-yellow"];
        CSButton * btnAddWallet = [[CSButton alloc] initNormalButtonTitle:@"新增钱包地址" Rect:CGRectMake(10, 50, 123, 38)];
        [btnAddWallet setBackgroundImage:imgButton forState:UIControlStateNormal];
        [btnAddWallet setTitleColor:[UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [btnAddWallet setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        btnAddWallet.tag = 23;
        [viewNewWallet addSubview:btnAddWallet];
        __weak typeof (self) thisPoint = self;
        btnAddWallet.actionBlock = ^void()
        {
            typeof(self) thisStrongPoint = thisPoint;
            
            if(thisStrongPoint->_arrayWallet.count >= 10)
            {
                UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"提示"
                                           message:@"您最多可以拥有十个钱包！"
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil];
                
                [alertView show];
                return;
            }
            
            [thisStrongPoint->_HUD show:YES];
            [[SportForumAPI sharedInstance] walletNewAddress:^void(int errorCode, WalletAddressItem* walletAddressItem)
             {
                 if(errorCode == 0)
                 {
                     [thisStrongPoint updateWallet];
                 }
                 else
                 {
                     [thisStrongPoint->_HUD hide:YES];
                 }
             }];
        };
        
        UIImageView *imgViewCoin = [[UIImageView alloc]initWithFrame:CGRectMake(10, (CGRectGetHeight(viewCoinWeb.frame) - 49) / 2, 55, 49)];
        [imgViewCoin setImage:[UIImage imageNamed:@"beibit"]];
        [viewCoinWeb addSubview:imgViewCoin];
        
        UILabel * lbCoinDescription = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgViewCoin.frame) + 10, 15, viewCoinWeb.frame.size.width - 30 - (CGRectGetMaxX(imgViewCoin.frame) + 10), 30)];
        lbCoinDescription.backgroundColor = [UIColor clearColor];
        lbCoinDescription.textColor = [UIColor blackColor];
        lbCoinDescription.text = @"想更多地了解贝币？访问贝币官网";
        lbCoinDescription.font = [UIFont boldSystemFontOfSize:12];
        lbCoinDescription.textAlignment = NSTextAlignmentLeft;
        [viewCoinWeb addSubview:lbCoinDescription];
        
        UIImageView *imgArrowCoin = [[UIImageView alloc] initWithFrame:CGRectMake(viewCoinWeb.frame.size.width - 20, (CGRectGetHeight(viewCoinWeb.frame) - 16) / 2, 8, 16)];
        imgArrowCoin.image = [UIImage imageNamed:@"arrow-1"];
        [viewCoinWeb addSubview:imgArrowCoin];
        
        CSButton * btnCoin = [CSButton buttonWithType:UIButtonTypeCustom];
        btnCoin.frame = CGRectMake(0, 0, CGRectGetWidth(viewCoinWeb.frame), CGRectGetHeight(viewCoinWeb.frame));
        [viewCoinWeb addSubview:btnCoin];
        
        btnCoin.actionBlock = ^void()
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://beibitcoin.com"]];
        };

        UIImageView *imgViewBuyCoin = [[UIImageView alloc]initWithFrame:CGRectMake(10, (CGRectGetHeight(viewBuyCoin.frame) - 49) / 2, 55, 49)];
        [imgViewBuyCoin setImage:[UIImage imageNamed:@"beibitcoin-buy"]];
        [viewBuyCoin addSubview:imgViewBuyCoin];
        
        UILabel * lbCoinBuy = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgViewBuyCoin.frame) + 10, 15, viewBuyCoin.frame.size.width - 30 - (CGRectGetMaxX(imgViewBuyCoin.frame) + 10), 30)];
        lbCoinBuy.backgroundColor = [UIColor clearColor];
        lbCoinBuy.textColor = [UIColor blackColor];
        lbCoinBuy.text = @"购买贝币";
        lbCoinBuy.font = [UIFont boldSystemFontOfSize:12];
        lbCoinBuy.textAlignment = NSTextAlignmentLeft;
        [viewBuyCoin addSubview:lbCoinBuy];
        
        UIImageView *imgArrowBuyCoin = [[UIImageView alloc] initWithFrame:CGRectMake(viewBuyCoin.frame.size.width - 20, (CGRectGetHeight(viewBuyCoin.frame) - 16) / 2, 8, 16)];
        imgArrowBuyCoin.image = [UIImage imageNamed:@"arrow-1"];
        [viewBuyCoin addSubview:imgArrowBuyCoin];
        
        CSButton * btnBuyCoin = [CSButton buttonWithType:UIButtonTypeCustom];
        btnBuyCoin.frame = CGRectMake(0, 0, CGRectGetWidth(viewBuyCoin.frame), CGRectGetHeight(viewBuyCoin.frame));
        [viewBuyCoin addSubview:btnBuyCoin];
        
        btnBuyCoin.actionBlock = ^void()
        {
            typeof(self) thisStrongPoint = thisPoint;
            
            PayCoinViewController *payCoinViewController = [[PayCoinViewController alloc]init];
            [thisStrongPoint.navigationController pushViewController:payCoinViewController animated:YES];
        };
        
        UILabel * lbAddressTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 45, 20)];
        lbAddressTitle.tag = 24;
        lbAddressTitle.backgroundColor = [UIColor clearColor];
        lbAddressTitle.font = [UIFont systemFontOfSize:12];
        lbAddressTitle.textAlignment = NSTextAlignmentLeft;
        [viewCurrentWallet addSubview:lbAddressTitle];
        
        UILabel * lbAddress = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, viewCurrentWallet.frame.size.width - 70, 30)];
        lbAddress.tag = 25;
        lbAddress.backgroundColor = [UIColor clearColor];
        lbAddress.font = [UIFont systemFontOfSize:12];
        lbAddress.textAlignment = NSTextAlignmentLeft;
        lbAddress.numberOfLines = 2;
        [viewCurrentWallet addSubview:lbAddress];
        
        CSButton * btnCopyAddress = [CSButton buttonWithType:UIButtonTypeCustom];
        btnCopyAddress.tag = 26;
        btnCopyAddress.frame = CGRectMake(55, 45, viewCurrentWallet.frame.size.width - 70, 20);
        btnCopyAddress.backgroundColor = [UIColor clearColor];
        btnCopyAddress.titleLabel.font = [UIFont boldSystemFontOfSize: 12];
        [btnCopyAddress setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btnCopyAddress.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [viewCurrentWallet addSubview:btnCopyAddress];
        
        UILabel * lbCoinTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 45, 20)];
        lbCoinTitle.backgroundColor = [UIColor clearColor];
        lbCoinTitle.textColor = [UIColor colorWithRed:180 / 255.0 green:160 / 255.0 blue:60 / 255.0 alpha:1.0];
        lbCoinTitle.font = [UIFont systemFontOfSize:12];
        lbCoinTitle.text = @"余额：";
        lbCoinTitle.textAlignment = NSTextAlignmentLeft;
        lbCoinTitle.numberOfLines = 2;
        [viewCurrentWallet addSubview:lbCoinTitle];
        
        UILabel * lbCoin = [[UILabel alloc] initWithFrame:CGRectMake(55, 65, viewCurrentWallet.frame.size.width - 70, 20)];
        lbCoin.tag = 27;
        lbCoin.backgroundColor = [UIColor clearColor];
        lbCoin.textColor = [UIColor colorWithRed:140 / 255.0 green:120 / 255.0 blue:20 / 255.0 alpha:1.0];
        lbCoin.font = [UIFont systemFontOfSize:12];
        lbCoin.textAlignment = NSTextAlignmentLeft;
        [viewCurrentWallet addSubview:lbCoin];
        
        CSButton * btnBill = [CSButton buttonWithType:UIButtonTypeCustom];
        btnBill.tag = 28;
        btnBill.frame = CGRectMake(10, 90, viewCurrentWallet.frame.size.width - 20, 30);
        btnBill.backgroundColor = [UIColor clearColor];
        btnBill.titleLabel.font = [UIFont boldSystemFontOfSize: 12];
        [btnBill setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnBill.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [viewCurrentWallet addSubview:btnBill];
        
        UIImageView *imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(viewCurrentWallet.frame.size.width - 20, 95, 8, 16)];
        imgArrow.image = [UIImage imageNamed:@"arrow-1"];
        [viewCurrentWallet addSubview:imgArrow];
        
        CSButton * btnTransfer = [[CSButton alloc] initNormalButtonTitle:@"转账" Rect:CGRectMake(10, 130, 123, 38)];
        btnTransfer.tag = 29;
        [btnTransfer setTitleColor:[UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [btnTransfer setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [btnTransfer setBackgroundImage:imgButton forState:UIControlStateNormal];
        [viewCurrentWallet addSubview:btnTransfer];
    }
    
    UIView * viewNewWallet = (UIView *)[cell.contentView viewWithTag: 20];
    UIView * viewCurrentWallet = (UIView *)[cell.contentView viewWithTag: 21];
    UIView * viewCoinWeb = (UIView *)[cell.contentView viewWithTag: 22];
    UIView * viewBuyCoin = (UIView *)[cell.contentView viewWithTag: 19];
    
    if(indexPath.row < _arrayWallet.count)
    {
        viewCurrentWallet.hidden = NO;
        viewNewWallet.hidden = YES;
        viewCoinWeb.hidden = YES;
        viewBuyCoin.hidden = YES;
    }
    else if(indexPath.row == _arrayWallet.count)
    {
        viewCurrentWallet.hidden = YES;
        viewNewWallet.hidden = NO;
        viewCoinWeb.hidden = YES;
        viewBuyCoin.hidden = YES;
    }
    else if(indexPath.row == _arrayWallet.count + 1)
    {
        viewCurrentWallet.hidden = YES;
        viewNewWallet.hidden = YES;
        viewCoinWeb.hidden = YES;
        viewBuyCoin.hidden = NO;
    }
    else
    {
        viewCurrentWallet.hidden = YES;
        viewNewWallet.hidden = YES;
        viewCoinWeb.hidden = NO;
        viewBuyCoin.hidden = YES;
    }
    
    if(indexPath.row >= _arrayWallet.count)
    {
        return cell;
    }
    
    WalletBalanceItem * item = nil;
    if(indexPath.row >= 0 && indexPath.row < _arrayWallet.count)
    {
        item = _arrayWallet[indexPath.row];
    }
    if(!item)
    {
        return cell;
    }
    
    UILabel * lbAddressTitle = (UILabel *)[viewCurrentWallet viewWithTag: 24];
    lbAddressTitle.text = [NSString stringWithFormat:@"地址%ld：", indexPath.row + 1];
    [lbAddressTitle sizeToFit];
    
    UILabel * lbAddress = (UILabel *)[viewCurrentWallet viewWithTag: 25];
    lbAddress.text = item.address;
    [lbAddress sizeToFit];

    CSButton * btnCopyAddress = (CSButton *)[viewCurrentWallet viewWithTag: 26];
    [btnCopyAddress setTitle:[NSString stringWithFormat:@"[点击复制地址%ld]", indexPath.row + 1] forState:UIControlStateNormal];
    
    __weak __typeof(self) weakSelf = self;
    btnCopyAddress.actionBlock = ^void()
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = item.address;
        UIAlertView * alertView =[[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"复制地址成功！"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
        
        [alertView show];
    };
    
    UILabel * lbCoin = (UILabel *)[viewCurrentWallet viewWithTag: 27];
    lbCoin.text = [NSString stringWithFormat:@"%lld贝币（已确认），%lld贝币（未确认）", item.confirmed / 100000000, item.unconfirmed / 100000000];
    
    CSButton * btnBill = (CSButton *)[viewCurrentWallet viewWithTag: 28];
    [btnBill setTitle:[NSString stringWithFormat:@"地址%ld交易账单", indexPath.row + 1] forState:UIControlStateNormal];
    
    btnBill.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        WalletBillViewController *walletBillViewController = [[WalletBillViewController alloc]init];
        [walletBillViewController setTitle:[NSString stringWithFormat:@"地址%ld交易账单", indexPath.row + 1]];
        [walletBillViewController setSelfAddress:item.address];
        [strongSelf.navigationController pushViewController:walletBillViewController animated:YES];
    };
    
    CSButton * btnTransfer = (CSButton *)[viewCurrentWallet viewWithTag: 29];
    
    btnTransfer.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        WalletTransferViewController *walletTransferViewController = [[WalletTransferViewController alloc]init];
        [walletTransferViewController setWalletBalanceItem:item];
        [strongSelf.navigationController pushViewController:walletTransferViewController animated:YES];
    };
    
    return cell;
}

-(void)updateWallet
{
    __weak typeof (self) thisPoint = self;
    [_HUD show:YES];
    [[SportForumAPI sharedInstance] walletGetBalanceInfo:^void(int errorCode, WalletBalanceInfo* walletBalanceInfo)
     {
         typeof(self) thisStrongPoint = thisPoint;
         
         if (thisStrongPoint == nil) {
             return;
         }
         
         [thisStrongPoint->_HUD hide:YES];
         if(errorCode == 0)
         {
             [thisStrongPoint->_arrayWallet removeAllObjects];
             
             for(int i = 0; i < walletBalanceInfo.addresses.data.count; i++)
             {
                 WalletBalanceItem * item = walletBalanceInfo.addresses.data[i];
                 [thisStrongPoint->_arrayWallet addObject:item];
             }
             
             [thisStrongPoint->_tableWallet reloadData];
         }
     }];
}

@end
