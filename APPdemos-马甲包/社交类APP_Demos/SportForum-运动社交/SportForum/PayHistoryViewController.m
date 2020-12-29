//
//  PayHistoryViewController.m
//  SportForum
//
//  Created by liyuan on 3/9/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "PayHistoryViewController.h"
#import "UIViewController+SportFormu.h"
#import "CommonUtility.h"

@interface PayHistoryViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation PayHistoryViewController
{
    NSMutableArray* m_arrPayItems;
    UITableView *m_tablePay;
    UILabel *m_lbNoResult;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"购买历史" IsNeedBackBtn:YES];
    
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
    
    m_lbNoResult = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, viewBody.frame.size.width - 20, 40)];
    m_lbNoResult.font = [UIFont boldSystemFontOfSize:16.0];
    m_lbNoResult.textAlignment = NSTextAlignmentLeft;
    m_lbNoResult.backgroundColor = [UIColor clearColor];
    m_lbNoResult.textColor = [UIColor darkGrayColor];
    m_lbNoResult.text = @"您还没有购买任何金币哦！";
    m_lbNoResult.hidden = YES;
    [viewBody addSubview:m_lbNoResult];
    
    m_arrPayItems = [[NSMutableArray alloc]init];
    [self loadDataFromServer];
}

-(void)loadDataFromServer
{
    [[SportForumAPI sharedInstance]userGetPayCoinListByFirPagId:nil LastPageId:nil PageItemCount:30 FinishedBlock:^(int errorCode, PayHistory *payHistory)
    {
        if (errorCode == 0) {
            if ([payHistory.payCoinList.data count] > 0) {
                m_lbNoResult.hidden = YES;
                m_tablePay.hidden = NO;
                [m_arrPayItems removeAllObjects];
                [m_arrPayItems addObjectsFromArray:payHistory.payCoinList.data];
                [m_tablePay reloadData];
            }
            else
            {
                m_lbNoResult.hidden = NO;
                m_tablePay.hidden = YES;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"PayHistoryViewController dealloc called!");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [m_arrPayItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"historyListIdentifier";
    
    PayCoinInfo *payCoinInfo = m_arrPayItems[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel * lbItem = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 290, 40)];
        lbItem.font = [UIFont boldSystemFontOfSize:14.0];
        lbItem.textAlignment = NSTextAlignmentLeft;
        lbItem.backgroundColor = [UIColor clearColor];
        lbItem.textColor = [UIColor darkGrayColor];
        lbItem.numberOfLines = 0;
        lbItem.tag = 106;
        [cell.contentView addSubview:lbItem];
        
        UILabel * lbSep = [[UILabel alloc] initWithFrame:CGRectMake(0, 59, 310, 1)];
        lbSep.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
        [cell.contentView addSubview:lbSep];
    }
    
    NSString *strTime = [[CommonUtility sharedInstance]compareLastLoginTime:[NSDate dateWithTimeIntervalSince1970:payCoinInfo.time]];
    UILabel * lbSettingItemTitle = (UILabel*)[cell.contentView viewWithTag:106];
    lbSettingItemTitle.text = [NSString stringWithFormat:@"%@ 购买%lld个金币，消费%ld元", strTime, payCoinInfo.coin_value / 100000000, payCoinInfo.value];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
