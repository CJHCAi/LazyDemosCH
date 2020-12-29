//
//  RelatedPeoplesViewController.m
//  SportForum
//
//  Created by liyuan on 14-9-15.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "RelatedPeoplesViewController.h"
#import "UIViewController+SportFormu.h"
#import "EGORefreshTableHeaderView.h"
#import "UIImageView+WebCache.h"
#import "RelatedPeopleCell.h"
#import "AlertManager.h"
#import "AccountPreViewController.h"

@interface RelatedPeoplesViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation RelatedPeoplesViewController
{
    UITableView *m_tableReleated;
    
    NSMutableArray * _arrReleated;
    NSString *_strFirstPageId;
    NSString *_strLastPageId;
    BOOL _blDownHandleLoading;
    UIActivityIndicatorView *_tableFooterActivityIndicator;
    UIActivityIndicatorView *m_activityIndicatorMain;
    
    EGORefreshTableHeaderView* _egoRefreshTableHeaderView;
    BOOL _bUpHandleLoading;
    int _nPageIndex;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initRelatedTestData {
    [_arrReleated removeAllObjects];
}

-(void)createBoardTable:(CGRect)rectTable
{
    m_tableReleated = [[UITableView alloc] initWithFrame:rectTable style:UITableViewStylePlain];
    m_tableReleated.delegate = self;
    m_tableReleated.dataSource = self;
    m_tableReleated.scrollEnabled = YES;
    m_tableReleated.backgroundColor = [UIColor clearColor];
    m_tableReleated.separatorColor = [UIColor clearColor];
    
    if ([m_tableReleated respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableReleated setSeparatorInset:UIEdgeInsetsZero];
    }
    
    //Create BottomView For Table
    m_tableReleated.tableFooterView = nil;
    m_tableReleated.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, m_tableReleated.frame.size.width, 40.0f)];
    _tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 20.0f, 20.0f)];
    [_tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [_tableFooterActivityIndicator setCenter:[m_tableReleated.tableFooterView center]];
    [m_tableReleated.tableFooterView addSubview:_tableFooterActivityIndicator];
    
    //Create TopView For Table
    _egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - m_tableReleated.frame.size.height, m_tableReleated.frame.size.width, m_tableReleated.frame.size.height)];
    _egoRefreshTableHeaderView.delegate = (id<EGORefreshTableHeaderDelegate>)self;
    _egoRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
    [m_tableReleated addSubview:_egoRefreshTableHeaderView];
    
    //  update the last update date
    [_egoRefreshTableHeaderView refreshLastUpdatedDate];
}

-(void)viewDidLoadGui
{
    NSString *strTitle = @"附近的人";
    
    if (_eRelatedType == e_related_people_nearby) {
        strTitle = @"附近的人";
    }
    else if (_eRelatedType == e_related_people_friend) {
        strTitle = @"朋友";
    }
    else if(_eRelatedType == e_related_people_attention)
    {
        strTitle = @"关注";
    }
    else if(_eRelatedType == e_related_people_fans)
    {
        strTitle = @"粉丝";
    }
    else if(_eRelatedType == e_related_people_defriend)
    {
        strTitle = @"黑名单";
    }
    else if(_eRelatedType == e_related_weibo)
    {
        strTitle = @"微博好友";
    }
    else if(_eRelatedType == e_related_people_thumb)
    {
        strTitle = @"赞过的人";
    }
    else if(_eRelatedType == e_related_people_reward)
    {
        strTitle = @"打赏过的人";
    }

    [self generateCommonViewInParent:self.view Title:strTitle IsNeedBackBtn:YES];
    
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
    
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    [self createBoardTable:rect];
    [viewBody addSubview:m_tableReleated];
    
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 20.0f, 20.0f)];
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 48) / 2, (CGRectGetHeight(viewBody.frame) - 48) / 2, 48, 48)];
    m_activityIndicatorMain.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    m_activityIndicatorMain.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    m_activityIndicatorMain.hidden = NO;
    m_activityIndicatorMain.hidesWhenStopped = YES;
    [viewBody addSubview:m_activityIndicatorMain];
    
    [m_activityIndicatorMain startAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _arrReleated = [[NSMutableArray alloc]init];
    
    [self viewDidLoadGui];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _strFirstPageId = @"";
    _nPageIndex = 0;
    [self reloadLeadBoardData];
    [MobClick beginLogPageView:@"RelatedPeoplesViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"RelatedPeoplesViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"RelatedPeoplesViewController"];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlUserSearch, urlUserGetRelatedMembersList, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"RelatedPeoplesViewController dealloc called!");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrReleated count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderBoardItem *leaderBoardItem = _arrReleated[indexPath.row];
    RelatedPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RelatedPeopleCell"];
    
    if (cell == nil) {
        cell = [[RelatedPeopleCell alloc]initWithReuseIdentifier:@"RelatedPeopleCell"];
    }
    
    cell.bRewardList = (_eRelatedType == e_related_people_reward);
    cell.leaderBoardItem = leaderBoardItem;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [RelatedPeopleCell heightOfCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];

    view.frame = CGRectMake(0, 0, 310, 5);
    view.backgroundColor = [UIColor clearColor];

    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Current Row is %ld!", indexPath.row);
    
    if ([_arrReleated count] > 0) {
        LeaderBoardItem *leaderBoardItem = _arrReleated[indexPath.row];

        AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
        accountPreViewController.strUserId = leaderBoardItem.userid;
        [self.navigationController pushViewController:accountPreViewController animated:YES];
    }
}

-(void)reloadLeadBoardData
{
    [self loadServerData:_strFirstPageId LastPageId:@""];
}

-(void)handleDataResultByList:(LeaderBoardItemList*)leaderBoardItemList FirPageId:(NSString*)strFirstrPageId LastPageId:(NSString*)strLastPageId
{
    if ([leaderBoardItemList.members_list.data count] > 0) {
        
        if (strFirstrPageId.length == 0 && strLastPageId.length == 0) {
            [_arrReleated removeAllObjects];
            
            _strFirstPageId = leaderBoardItemList.page_frist_id;
            _strLastPageId = leaderBoardItemList.page_last_id;
        }
        else if (strFirstrPageId.length == 0 && strLastPageId.length > 0)
        {
            _strLastPageId = leaderBoardItemList.page_last_id;
        }
        else if(strFirstrPageId.length > 0 && strLastPageId.length == 0)
        {
            _strFirstPageId = leaderBoardItemList.page_frist_id;
        }
        
        [_arrReleated addObjectsFromArray:leaderBoardItemList.members_list.data];
        [m_tableReleated reloadData];
    }
}

-(void)loadServerData:(NSString*)strFirstrPageId LastPageId:(NSString*)strLastPageId
{
    if (0) {
        [self initRelatedTestData];
        [self stopRefresh];
        [m_activityIndicatorMain stopAnimating];
        [m_tableReleated reloadData];
    }
    else
    {
        __weak __typeof(self) weakself = self;
        
        if (_eRelatedType == e_related_people_nearby) {
            
            [[SportForumAPI sharedInstance]userSearchByPageId:strFirstrPageId LastPageId:strLastPageId PageItemNum:30 IsNearBy:YES NickName:@""FinishedBlock:^void(int errorCode, LeaderBoardItemList *leaderBoardItemList){
                __typeof(self) strongself = weakself;
                
                if (strongself != nil) {
                    [m_activityIndicatorMain stopAnimating];
                    [self stopRefresh];
                    
                    if (errorCode == 0 && [leaderBoardItemList.members_list.data count] > 0) {
                        [self handleDataResultByList:leaderBoardItemList FirPageId:@"" LastPageId:@""];
                    }
                }
            }];
        }
        else if (_eRelatedType == e_related_people_thumb) {
            [[SportForumAPI sharedInstance]articleThumbsByArticleId:_strArticleId PageIndex:_nPageIndex FinishedBlock:^void(int errorCode, LeaderBoardItemList *leaderBoardItemList){
                __typeof(self) strongself = weakself;
                
                if (strongself != nil) {
                    [m_activityIndicatorMain stopAnimating];
                    [self stopRefresh];
                    
                    if (errorCode == 0 && [leaderBoardItemList.members_list.data count] > 0) {
                        if (_nPageIndex == 0) {
                            [_arrReleated removeAllObjects];
                        }
                        
                        [_arrReleated addObjectsFromArray:leaderBoardItemList.members_list.data];
                        [m_tableReleated reloadData];
                    }
                }
            }];
        }
        else if(_eRelatedType == e_related_people_reward) {
            [[SportForumAPI sharedInstance]articleRewardsByArticleId:_strArticleId PageIndex:_nPageIndex FinishedBlock:^void(int errorCode, LeaderBoardItemList *leaderBoardItemList){
                __typeof(self) strongself = weakself;
                
                if (strongself != nil) {
                    [m_activityIndicatorMain stopAnimating];
                    [self stopRefresh];
                    
                    if (errorCode == 0 && [leaderBoardItemList.members_list.data count] > 0) {
                        if (_nPageIndex == 0) {
                            [_arrReleated removeAllObjects];
                        }
                        
                        [_arrReleated addObjectsFromArray:leaderBoardItemList.members_list.data];
                        [m_tableReleated reloadData];
                    }
                }
            }];
        }
        else
        {
            e_related_type eRelatedType = e_related_friend;
            
            if (_eRelatedType == e_related_people_friend) {
                eRelatedType = e_related_friend;
            }
            else if(_eRelatedType == e_related_people_attention)
            {
                eRelatedType = e_related_attention;
            }
            else if(_eRelatedType == e_related_people_fans)
            {
                eRelatedType = e_related_fans;
            }
            else if(_eRelatedType == e_related_people_defriend)
            {
                eRelatedType = e_related_defriend;
            }
            else if(_eRelatedType == e_related_people_weibo)
            {
                eRelatedType = e_related_weibo;
            }

            [[SportForumAPI sharedInstance]userGetRelaterdByType:eRelatedType UserId:_strUserId FirstPageId:strFirstrPageId LastPageId:strLastPageId PageItemNum:20 FinishedBlock:^void(int errorCode, LeaderBoardItemList *leaderBoardItemList){
                __typeof(self) strongself = weakself;
                
                if (strongself != nil) {
                    [m_activityIndicatorMain stopAnimating];
                    [self stopRefresh];
                    
                    if (errorCode == 0){
                        if(strFirstrPageId.length == 0 && strLastPageId.length == 0 && [leaderBoardItemList.members_list.data count] == 0)
                        {
                            [_arrReleated removeAllObjects];
                            [m_tableReleated reloadData];
                        }
                        else
                        {
                            [self handleDataResultByList:leaderBoardItemList FirPageId:strFirstrPageId LastPageId:strLastPageId];
                        }
                    }
                }
            }];
        }
    }
}

-(void)stopRefresh {
    if (_bUpHandleLoading) {
        _bUpHandleLoading = NO;
        [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tableReleated];
    }
    
    if (_blDownHandleLoading) {
        _blDownHandleLoading = NO;
        [self tableBootomShow:NO];
    }
}

-(void)tableBootomShow:(BOOL)blShow {
    if (blShow) {
        [_tableFooterActivityIndicator startAnimating];
    }
    else {
        [_tableFooterActivityIndicator stopAnimating];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat y = offset.y + bounds.size.height - inset.bottom;
    CGFloat h = size.height;
    
    NSLog(@"%.2f %.2f %d", y, h, _blDownHandleLoading);
    
    //if((y > (h + 50) && h > bounds.size.height) && _blDownHandleLoading == NO) {
    if((y > (h + 50)) && _blDownHandleLoading == NO){
        [self tableBootomShow:YES];
        _blDownHandleLoading = YES;
        _nPageIndex++;
        [self loadServerData:@"" LastPageId:_strLastPageId];
    }
    
    if (_bUpHandleLoading == NO) {
        [_egoRefreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	[_egoRefreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	_bUpHandleLoading = YES;
    _strFirstPageId = @"";
    _nPageIndex = 0;
    [self performSelector:@selector(reloadLeadBoardData) withObject:nil afterDelay:0.2];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _bUpHandleLoading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
}

@end
