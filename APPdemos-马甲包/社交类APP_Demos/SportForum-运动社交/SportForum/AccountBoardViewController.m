//
//  AccountBoardViewController.m
//  SportForum
//
//  Created by liyuan on 4/20/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "AccountBoardViewController.h"
#import "UIViewController+SportFormu.h"
#import "EGORefreshTableHeaderView.h"
#import "UIImageView+WebCache.h"
#import "AccountBoardTableViewCell.h"
#import "AccountPreViewController.h"

@interface AccountBoardViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

@end

@implementation AccountBoardViewController
{
    UITableView *m_tableReleated;
    
    NSMutableArray * _arrReleated;
    NSString *_strFirstPageId;
    NSString *_strLastPageId;
    BOOL _blDownHandleLoading;
    UIActivityIndicatorView *_tableFooterActivityIndicator;
    
    EGORefreshTableHeaderView* _egoRefreshTableHeaderView;
    BOOL _bUpHandleLoading;

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

-(NSString*)generateTitle
{
    NSString *strTitle = @"体魄排行榜";
    
    if ([_strBoardType isEqualToString:@"physique"]) {
        strTitle = @"体魄排行榜";
    }
    else if([_strBoardType isEqualToString:@"literature"]) {
        strTitle = @"文学排行榜";
    }
    else if([_strBoardType isEqualToString:@"magic"]) {
        strTitle = @"魔法排行榜";
    }
    
    return strTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _arrReleated = [[NSMutableArray alloc]init];
    [self generateCommonViewInParent:self.view Title:[self generateTitle] IsNeedBackBtn:YES];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"排行榜 - AccountBoardViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"排行榜 - AccountBoardViewController"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _strFirstPageId = @"";
    [self reloadLeadBoardData];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"排行榜 - AccountBoardViewController"];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlLeaderBoardGameList, nil]];
}

-(void)dealloc
{
    NSLog(@"AccountBoardViewController dealloc called!");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrReleated count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeaderBoardItem *leaderBoardItem = _arrReleated[indexPath.row];
    AccountBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountBoardTableViewCell"];
    
    if (cell == nil) {
        cell = [[AccountBoardTableViewCell alloc]initWithReuseIdentifier:@"AccountBoardTableViewCell"];
    }
    
    cell.strBoardType = _strBoardType;
    cell.leaderBoardItem = leaderBoardItem;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AccountBoardTableViewCell heightOfCell];
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

-(void)reloadLeadBoardData
{
    [self loadServerData:_strFirstPageId LastPageId:@""];
}

-(void)loadServerData:(NSString*)strFirstrPageId LastPageId:(NSString*)strLastPageId
{
    __weak __typeof(self) weakself = self;

    [[SportForumAPI sharedInstance]userLeaderBoardByFirPagId:strFirstrPageId LastPageId:strLastPageId BoardType:_strBoardType PageItemCount:20 FinishedBlock:^void(int errorCode, LeaderBoardItemList *leaderBoardItemList){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            [self stopRefresh];
            
            if (errorCode == 0 && [leaderBoardItemList.members_list.data count] > 0)
            {
                if (strFirstrPageId.length == 0 && strLastPageId.length == 0)
                {
                    [strongself->_arrReleated removeAllObjects];
                    
                    strongself->_strFirstPageId = leaderBoardItemList.page_frist_id;
                    strongself->_strLastPageId = leaderBoardItemList.page_last_id;
                }
                else if (strFirstrPageId.length == 0 && strLastPageId.length > 0)
                {
                    strongself->_strLastPageId = leaderBoardItemList.page_last_id;
                }
                else if(strFirstrPageId.length > 0 && strLastPageId.length == 0)
                {
                    strongself->_strFirstPageId = leaderBoardItemList.page_frist_id;
                }
                
                [strongself->_arrReleated addObjectsFromArray:leaderBoardItemList.members_list.data];
                
                [strongself->m_tableReleated reloadData];
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
    [self performSelector:@selector(reloadLeadBoardData) withObject:nil afterDelay:0.2];
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
