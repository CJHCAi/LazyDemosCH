//
//  GameBoardViewController.m
//  SportForum
//
//  Created by liyuan on 2/3/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "GameBoardViewController.h"
#import "UIViewController+SportFormu.h"
#import "EGORefreshTableHeaderView.h"
#import "UIImageView+WebCache.h"
#import "GameBoardCell.h"
#import "AccountPreViewController.h"
#import "GameViewController.h"
#import "AlertManager.h"

@interface GameBoardViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation GameBoardViewController
{
    UITableView *m_tableReleated;
    
    NSMutableArray * _arrReleated;
    BOOL _blDownHandleLoading;
    UIActivityIndicatorView *_tableFooterActivityIndicator;
    
    EGORefreshTableHeaderView* _egoRefreshTableHeaderView;
    BOOL _bUpHandleLoading;
    int _nPageIndex;
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
    NSString *strTitle = @"";
    
    if (_eGameType == e_game_mishi) {
        strTitle = @"古墓历险";
    }
    else if (_eGameType == e_game_qixi) {
        strTitle = @"爱之跳跳";
    }
    else if(_eGameType == e_game_spiderman)
    {
        strTitle = @"蜘蛛侠";
    }
    else if(_eGameType == e_game_xiongchumo)
    {
        strTitle = @"熊出没";
    }
    else if(_eGameType == e_game_znm)
    {
        strTitle = @"幸运转盘";
    }

    if(_eQueryType == board_query_type_top)
    {
        strTitle = [NSString stringWithFormat:@"%@总排行", strTitle];
    }
    else
    {
        strTitle = [NSString stringWithFormat:@"%@好友排行", strTitle];
    }
    
    [self generateCommonViewInParent:self.view Title:strTitle IsNeedBackBtn:NO];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 27, 37, 37)];
    [imgView setImage:[UIImage imageNamed:@"nav-back-btn"]];
    [self.view addSubview:imgView];
    
    CSButton *btnBack = [CSButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(5, 20, 55, 45);
    btnBack.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnBack];
    [self.view bringSubviewToFront:btnBack];
    
    __weak __typeof(self) weakSelf = self;
    
    btnBack.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;

        if (strongSelf.isTask) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_SWITCH_VIEW object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:VIEW_MAIN_PAGE, @"PageName", nil]];
            
            if(strongSelf->_nCurScore < 100)
            {
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showFailAnimationWhenExecuteTask) userInfo:nil repeats:NO];
            }
            else
            {
                [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showSuccessAnimationWhenExecuteTask) userInfo:nil repeats:NO];
            }
        }
        else
        {
            NSMutableArray *viewControllers = [[strongSelf.navigationController viewControllers] mutableCopy];
            
            for (UIViewController*viewController in viewControllers) {
                if ([viewController isKindOfClass:[GameViewController class]]) {
                    [strongSelf.navigationController popToViewController:viewController animated:YES];
                    break;
                }
            }
        }
    };
    
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrReleated = [[NSMutableArray alloc]init];
    
    [self viewDidLoadGui];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _nPageIndex = 0;
    [self loadServerData];
    [MobClick beginLogPageView:@"游戏排行 - GameBoardViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"游戏排行 - GameBoardViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"游戏排行 - GameBoardViewController"];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlLeaderBoardGameList, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"GameBoardViewController dealloc called!");
}

-(void)showFailAnimationWhenExecuteTask
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_ANIMATION_STATE object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TaskFail", @"AnimationState", nil]];
}

-(void)showSuccessAnimationWhenExecuteTask
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_ANIMATION_STATE object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TaskSuccess", @"AnimationState", nil]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrReleated count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderBoardItem *leaderBoardItem = _arrReleated[indexPath.row];
    GameBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GameBoardCell"];
    
    if (cell == nil) {
        cell = [[GameBoardCell alloc]initWithReuseIdentifier:@"GameBoardCell"];
    }
    
    cell.leaderBoardItem = leaderBoardItem;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GameBoardCell heightOfCell];
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

-(void)loadServerData
{
    __weak __typeof(self) weakSelf = self;
        
    [[SportForumAPI sharedInstance]leaderBoardGameListByQueryType:_eQueryType GameType:_eGameType GameScore:_nCurScore PageIndex:_nPageIndex FinishedBlock:^void(int errorCode, LeaderBoardItemList *leaderBoardItemList){
        __typeof(self) strongSelf = weakSelf;
        
        if (strongSelf != nil) {
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
        [self loadServerData];
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
    _nPageIndex = 0;
    [self performSelector:@selector(loadServerData) withObject:nil afterDelay:0.2];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _bUpHandleLoading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
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
