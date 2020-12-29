//
//  CoinCardViewController.m
//  SportForum
//
//  Created by liyuan on 4/1/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "CoinCardViewController.h"
#import "UIViewController+SportFormu.h"
#import "WalletBillViewController.h"
#import "PayCoinViewController.h"

@interface CoinCardViewController ()

@end

@implementation CoinCardViewController
{
    UIScrollView *m_scrollView;
    UILabel *m_lbTotalValue;
    UILabel *m_lbUnCheckValue;
    UIImageView *m_imgViewNew;
    
    UIActivityIndicatorView* _activityIndicatorView;
}

-(void)viewDidLoadGui
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    UILabel *lbCardTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 20)];
    lbCardTitle.backgroundColor = [UIColor clearColor];
    lbCardTitle.textColor = [UIColor darkGrayColor];
    lbCardTitle.text = @"卡名";
    lbCardTitle.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbCardTitle];
    
    UILabel *lbCardName = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 220, 20)];
    lbCardName.backgroundColor = [UIColor clearColor];
    lbCardName.textColor = [UIColor blackColor];
    lbCardName.text = [NSString stringWithFormat:@"%@的金币卡", userInfo.nikename];
    lbCardName.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbCardName];
    
    UILabel *lbTotalTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 50, 20)];
    lbTotalTitle.backgroundColor = [UIColor clearColor];
    lbTotalTitle.textColor = [UIColor darkGrayColor];
    lbTotalTitle.text = @"资产";
    lbTotalTitle.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbTotalTitle];
    
    m_lbTotalValue = [[UILabel alloc]initWithFrame:CGRectMake(80, 40, 220, 20)];
    m_lbTotalValue.backgroundColor = [UIColor clearColor];
    m_lbTotalValue.textColor = [UIColor blackColor];
    m_lbTotalValue.text = @"";
    m_lbTotalValue.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:m_lbTotalValue];
    
    UILabel *lbUnCheckTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 50, 20)];
    lbUnCheckTitle.backgroundColor = [UIColor clearColor];
    lbUnCheckTitle.textColor = [UIColor darkGrayColor];
    lbUnCheckTitle.text = @"债权";
    lbUnCheckTitle.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbUnCheckTitle];
    
    m_lbUnCheckValue = [[UILabel alloc]initWithFrame:CGRectMake(80, 70, 220, 20)];
    m_lbUnCheckValue.backgroundColor = [UIColor clearColor];
    m_lbUnCheckValue.textColor = [UIColor blackColor];
    m_lbUnCheckValue.text = @"";
    m_lbUnCheckValue.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:m_lbUnCheckValue];
    
    UILabel *lbCardNum = [[UILabel alloc]initWithFrame:CGRectMake(10, 100, 50, 20)];
    lbCardNum.backgroundColor = [UIColor clearColor];
    lbCardNum.textColor = [UIColor darkGrayColor];
    lbCardNum.text = @"卡号";
    lbCardNum.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbCardNum];
    
    UILabel *lbCardNumValue = [[UILabel alloc]initWithFrame:CGRectMake(80, 100, 220, 45)];
    lbCardNumValue.backgroundColor = [UIColor clearColor];
    lbCardNumValue.textColor = [UIColor blackColor];
    lbCardNumValue.text = userInfo.wallet;
    lbCardNumValue.numberOfLines = 0;
    lbCardNumValue.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbCardNumValue];
    
    UILabel *lbSep0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, 310, 1)];
    lbSep0.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    [m_scrollView addSubview:lbSep0];
    
    UILabel *lbTransfer = [[UILabel alloc]initWithFrame:CGRectMake(10, 175, 80, 20)];
    lbTransfer.backgroundColor = [UIColor clearColor];
    lbTransfer.textColor = [UIColor darkGrayColor];
    lbTransfer.text = @"账单";
    lbTransfer.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbTransfer];
    
    UIImageView *arrImgView = [[UIImageView alloc]initWithFrame:CGRectMake(310 - 18, 177, 8, 16)];
    [arrImgView setImage:[UIImage imageNamed:@"arrow-1"]];
    [m_scrollView addSubview:arrImgView];
    
    CSButton * btnTransfer = [CSButton buttonWithType:UIButtonTypeCustom];
    btnTransfer.frame = CGRectMake(0, 155, 310, 50);
    btnTransfer.backgroundColor = [UIColor clearColor];
    [m_scrollView addSubview:btnTransfer];
    [m_scrollView bringSubviewToFront:btnTransfer];
    
    __weak __typeof(self) weakSelf = self;
    
    btnTransfer.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        WalletBillViewController *walletBillViewController = [[WalletBillViewController alloc]init];
        [walletBillViewController setSelfAddress:userInfo.wallet];
        [strongSelf.navigationController pushViewController:walletBillViewController animated:YES];
    };
    
    UILabel *lbSep1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 215, 310, 1)];
    lbSep1.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    [m_scrollView addSubview:lbSep1];
    
    UILabel *lbTips = [[UILabel alloc]initWithFrame:CGRectMake(10, 230, 290, 40)];
    lbTips.backgroundColor = [UIColor clearColor];
    lbTips.textColor = [UIColor darkGrayColor];
    lbTips.text = @"资产是金币卡中已经确认的数字，债权是正在系统中确认的数字。";
    lbTips.numberOfLines = 0;
    lbTips.font = [UIFont boldSystemFontOfSize:12];
    [m_scrollView addSubview:lbTips];
    
    if ([[ApplicationContext sharedInstance]IsPreSportForm]) {
        UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
        imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
        
        UIImageView *imgBkViewd = [[UIImageView alloc]initWithFrame:CGRectMake(5, 285, 300, 60)];
        [imgBkViewd setImage:imgBk];
        [m_scrollView addSubview:imgBkViewd];
        
        UIImageView *imgViewCoin = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(imgBkViewd.frame) + 30 - 49 / 2, 55, 49)];
        [imgViewCoin setImage:[UIImage imageNamed:@"beibit"]];
        [m_scrollView addSubview:imgViewCoin];
        
        UILabel * lbCoinDescription = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgViewCoin.frame) + 10, CGRectGetMinY(imgBkViewd.frame) + 30 - 15, imgBkViewd.frame.size.width - 30 - (CGRectGetMaxX(imgViewCoin.frame) + 10), 30)];
        lbCoinDescription.backgroundColor = [UIColor clearColor];
        lbCoinDescription.textColor = [UIColor darkGrayColor];
        lbCoinDescription.text = @"想更多地了解金币？访问金币官网";
        lbCoinDescription.font = [UIFont boldSystemFontOfSize:12];
        lbCoinDescription.textAlignment = NSTextAlignmentLeft;
        [m_scrollView addSubview:lbCoinDescription];
        
        UIImageView *imgArrowCoin = [[UIImageView alloc] initWithFrame:CGRectMake(310 - 18, CGRectGetMinY(imgBkViewd.frame) + 30 - 8, 8, 16)];
        imgArrowCoin.image = [UIImage imageNamed:@"arrow-1"];
        [m_scrollView addSubview:imgArrowCoin];
        
        CSButton * btnCoin = [CSButton buttonWithType:UIButtonTypeCustom];
        btnCoin.frame = CGRectMake(5, 285, 290, 60);
        [m_scrollView addSubview:btnCoin];
        
        btnCoin.actionBlock = ^void()
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://beibitcoin.com"]];
        };
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self generateCommonViewInParent:self.view Title:@"金币卡" IsNeedBackBtn:YES];
    
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
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    [viewBody addSubview:m_scrollView];
    m_scrollView.contentSize = CGSizeMake(m_scrollView.frame.size.width, CGRectGetHeight(viewBody.frame));
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicatorView.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    _activityIndicatorView.center = viewBody.center;
    _activityIndicatorView.hidden = NO;
    _activityIndicatorView.hidesWhenStopped = YES;
    [viewBody addSubview:_activityIndicatorView];
    
    [self viewDidLoadGui];
    
    //Create But Right Nav Btn
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    m_imgViewNew = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [self.view addSubview:m_imgViewNew];
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:16];
    for (NSInteger i = 0; i < 15; i ++) {
        UIImage *image = [UIImage imageNamedWithWebP:[NSString stringWithFormat:@"beibitCard-buy-btn-%ld", i + 1]];
        if (image)
            [images addObject:image];
    }
    
    m_imgViewNew.animationImages = images;
    m_imgViewNew.animationDuration = 1.0;
    
    CSButton *btnBuy = [CSButton buttonWithType:UIButtonTypeCustom];
    btnBuy.frame = CGRectMake(CGRectGetMinX(m_imgViewNew.frame) - 5, CGRectGetMinY(m_imgViewNew.frame) - 5, 45, 45);
    btnBuy.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnBuy];
    [self.view bringSubviewToFront:btnBuy];
    
    __weak __typeof(self) weakSelf = self;
    
    btnBuy.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        PayCoinViewController *payCoinViewController = [[PayCoinViewController alloc]init];
        [strongSelf.navigationController pushViewController:payCoinViewController animated:YES];
    };
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateWallet];
    [m_imgViewNew startAnimating];
    [MobClick beginLogPageView:@"金币卡 - CoinCardViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"金币卡 - CoinCardViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [m_imgViewNew stopAnimating];
    [MobClick endLogPageView:@"金币卡 - CoinCardViewController"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"CoinCardViewController dealloc");
}

-(void)updateWallet
{
    __weak typeof (self) thisPoint = self;
    [_activityIndicatorView startAnimating];
    
    [[SportForumAPI sharedInstance] walletGetBalanceInfo:^void(int errorCode, WalletBalanceInfo* walletBalanceInfo)
     {
         typeof(self) thisStrongPoint = thisPoint;
         
         if (thisStrongPoint == nil) {
             return;
         }
         
         [_activityIndicatorView stopAnimating];
         
         if(errorCode == 0 && [walletBalanceInfo.addresses.data count] > 0)
         {
             WalletBalanceItem * item = walletBalanceInfo.addresses.data[0];
             m_lbTotalValue.text = [NSString stringWithFormat:@"%lld", item.confirmed / 100000000];
             m_lbUnCheckValue.text = [NSString stringWithFormat:@"%lld", item.unconfirmed / 100000000];
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
