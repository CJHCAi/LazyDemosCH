//
//  RecommendPeoplesViewController.m
//  SportForum
//
//  Created by liyuan on 12/17/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "RecommendPeoplesViewController.h"
#import "UIViewController+SportFormu.h"
#import "EGORefreshTableHeaderView.h"
#import "UIImageView+WebCache.h"
#import "RecommendCellTableViewCell.h"
#import "AccountPreViewController.h"
#import "AlertManager.h"

@interface RecommendPeoplesViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation RecommendPeoplesViewController
{
    UITableView *m_tableRecommend;
    
    NSMutableArray * _arrRecommend;
    NSString *_strFirstPageId;
    NSString *_strLastPageId;
    
    EGORefreshTableHeaderView* _egoRefreshTableHeaderView;
    UIActivityIndicatorView* _activityIndicatorView;
    UIActivityIndicatorView* m_activityIndicatorMain;
    BOOL _bUpHandleLoading;
}

-(void)createBoardTable:(CGRect)rectTable
{
    m_tableRecommend = [[UITableView alloc] initWithFrame:rectTable style:UITableViewStylePlain];
    m_tableRecommend.delegate = self;
    m_tableRecommend.dataSource = self;
    m_tableRecommend.scrollEnabled = YES;
    m_tableRecommend.backgroundColor = [UIColor clearColor];
    m_tableRecommend.separatorColor = [UIColor clearColor];
    
    if ([m_tableRecommend respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableRecommend setSeparatorInset:UIEdgeInsetsZero];
    }
    
    //Create TopView For Table
    _egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - m_tableRecommend.frame.size.height, m_tableRecommend.frame.size.width, m_tableRecommend.frame.size.height)];
    _egoRefreshTableHeaderView.delegate = (id<EGORefreshTableHeaderDelegate>)self;
    _egoRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
    [m_tableRecommend addSubview:_egoRefreshTableHeaderView];
    
    //  update the last update date
    [_egoRefreshTableHeaderView refreshLastUpdatedDate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrRecommend = [[NSMutableArray alloc]init];
    [self generateCommonViewInParent:self.view Title:@"可能感兴趣的人" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_BORDER_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    [self createBoardTable:rect];
    [viewBody addSubview:m_tableRecommend];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicatorView.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    _activityIndicatorView.center = viewBody.center;
    _activityIndicatorView.hidden = NO;
    _activityIndicatorView.hidesWhenStopped = YES;
    [viewBody addSubview:_activityIndicatorView];
    
    _bUpHandleLoading = NO;
    
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 20.0f, 20.0f)];
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 48) / 2, (CGRectGetHeight(viewBody.frame) - 48) / 2, 48, 48)];
    m_activityIndicatorMain.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    m_activityIndicatorMain.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    m_activityIndicatorMain.hidden = NO;
    m_activityIndicatorMain.hidesWhenStopped = YES;
    [viewBody addSubview:m_activityIndicatorMain];
    
    [m_activityIndicatorMain startAnimating];
    
    [self reloadRecommendData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"可能感兴趣的人 - RecommendPeoplesViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"可能感兴趣的人 - RecommendPeoplesViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self loadProcessShow:NO];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlUserRecommend, nil]];
    [MobClick endLogPageView:@"可能感兴趣的人 - RecommendPeoplesViewController"];
    [super viewWillDisappear:animated];
}

-(void)loadProcessShow:(BOOL)blShow {
    if (blShow) {
        [_activityIndicatorView startAnimating];
    } else {
        [_activityIndicatorView stopAnimating];
    }
}

-(void)enableAttentionByUserId:(NSString*)strUserId Cell:(RecommendCellTableViewCell*)recommendCell IndexPath:(NSIndexPath *)indexPath
{
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    
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
    
    [self loadProcessShow:YES];
    
    __weak __typeof(self) weakself = self;
        
    [[SportForumAPI sharedInstance] userEnableAttentionByUserId:@[strUserId]
                                                      Attention:YES
                                                  FinishedBlock:^void(int errorCode, NSString* strDescErr, ExpEffect* expEffect)
     {
         __typeof(self) strongself = weakself;
         
         if (strongself != nil) {
             [self loadProcessShow:NO];
             
             if(errorCode == 0)
             {
                 [recommendCell.btnAttention setTitle:@"已关注" forState:UIControlStateNormal];
                 [_arrRecommend removeObjectAtIndex:indexPath.row];
                 [m_tableRecommend reloadData];
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_LEADBOARD object:nil];
             }
             else
             {
                [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
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
    NSLog(@"RecommendPeoplesViewController dealloc called!");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrRecommend count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderBoardItem *leaderBoardItem = _arrRecommend[indexPath.row];
    RecommendCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCellTableViewCell"];
    
    if (cell == nil) {
        cell = [[RecommendCellTableViewCell alloc]initWithReuseIdentifier:@"RecommendCellTableViewCell"];
    }
    
    __weak __typeof(self) weakSelf = self;
    
    cell.imgClickBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
        accountPreViewController.strUserId = leaderBoardItem.userid;
        [strongSelf.navigationController pushViewController:accountPreViewController animated:YES];
    };
    
    __weak __typeof(cell) thisCell = cell;
    
    cell.attentionClickBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf enableAttentionByUserId:leaderBoardItem.userid Cell:thisCell IndexPath:indexPath];
    };

    cell.leaderBoardItem = leaderBoardItem;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RecommendCellTableViewCell heightOfCell];
}

-(void)reloadRecommendData
{
    __weak __typeof(self) weakself = self;
        
    [[SportForumAPI sharedInstance]userGetRecommendsByPageId:@"" LastPageId:@"" FinishedBlock:^void(int errorCode, LeaderBoardItemList *recommendsList){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            [self stopRefresh];
            [self loadProcessShow:NO];
            [m_activityIndicatorMain stopAnimating];
            
            if (errorCode == 0) {
                [_arrRecommend removeAllObjects];
                [_arrRecommend addObjectsFromArray:recommendsList.members_list.data];
                [m_tableRecommend reloadData];
            }
        }
    }];
}

-(void)stopRefresh {
    if (_bUpHandleLoading) {
        _bUpHandleLoading = NO;
        [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tableRecommend];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    _bUpHandleLoading = YES;
    [self performSelector:@selector(reloadRecommendData) withObject:nil afterDelay:1];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _bUpHandleLoading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
}

@end
