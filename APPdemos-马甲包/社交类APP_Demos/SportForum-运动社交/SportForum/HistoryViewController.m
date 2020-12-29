//
//  HistoryViewController.m
//  SportForum
//
//  Created by zyshi on 14-9-17.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "HistoryViewController.h"
#import "UIViewController+SportFormu.h"
#import "EGORefreshTableHeaderView.h"
#import "UIImageView+WebCache.h"
#import "CSButton.h"
#import "MWPhotoBrowser.h"
#import "AlertManager.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MWPhotoBrowserDelegate>

@end

@implementation HistoryViewController
{
    NSMutableArray * _arrayHistory;
    NSMutableArray *_photos;
    
    UIView *_viewMenu;
    UITableView * _tableHistory;

    EGORefreshTableHeaderView* _egoRefreshTableHeaderView;
    UIActivityIndicatorView *_tableFooterActivityIndicator;
    UIActivityIndicatorView *m_activityIndicatorMain;
    BOOL _bDownHandleLoading;
    BOOL _bUpHandleLoading;
    NSString *_strFirstPageId;
    NSString *_strLastPageId;
    NSString *_strType;
    int _nHistoryType;
    
    id _processWin;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _arrayHistory = [[NSMutableArray alloc] init];
        _nHistoryType = HISTORY_TYPE_SPORT;
        //Test
        /*SportRecordInfo * sportItem = [[SportRecordInfo alloc] init];
        sportItem.type = @"run";
        sportItem.sport_pics = @[@"TESTPIC"];
        sportItem.action_time = 447897600000;
        sportItem.duration = 3600;
        sportItem.distance = 8000;
        sportItem.game_name = @"bug";
        sportItem.game_score = 1234567;
        [_arrayHistory addObject:sportItem];
        
        sportItem = [[SportRecordInfo alloc] init];
        sportItem.type = @"game";
        sportItem.sport_pics = @[];
        sportItem.action_time = 856444;
        sportItem.duration = 7545;
        sportItem.distance = 1000;
        sportItem.game_name = @"bug";
        sportItem.game_score = 1234567;
        [_arrayHistory addObject:sportItem];
        
        sportItem = [[SportRecordInfo alloc] init];
        sportItem.type = @"run";
        sportItem.sport_pics = @[@"X_btn_normal"];
        sportItem.action_time = 1234567890;
        sportItem.duration = 455;
        sportItem.distance = 1000;
        sportItem.game_name = @"bug";
        sportItem.game_score = 1234567;
        [_arrayHistory addObject:sportItem];*/
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _strFirstPageId = @"";
    _strLastPageId = @"";
    _strType = @"";
    _bUpHandleLoading = NO;
    _bDownHandleLoading = NO;
    _photos = [[NSMutableArray alloc]init];

    [self generateCommonViewInParent:self.view Title:@"江湖史" IsNeedBackBtn:YES];
    
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
    
    _tableHistory = [[UITableView alloc] initWithFrame:viewBody.bounds];
    [viewBody addSubview:_tableHistory];
    _tableHistory.dataSource = self;
    _tableHistory.delegate = self;
    _tableHistory.backgroundColor = [UIColor clearColor];
    _tableHistory.separatorColor = [UIColor clearColor];

    //Create BottomView For Table
    _tableHistory.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableHistory.frame.size.width, 10.0f)];
    _tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    [_tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_tableFooterActivityIndicator setCenter:[_tableHistory.tableFooterView center]];
    [_tableHistory.tableFooterView addSubview:_tableFooterActivityIndicator];
    
    //Create TopView For Table
    _egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableHistory.frame.size.height, _tableHistory.frame.size.width, _tableHistory.frame.size.height)];
    _egoRefreshTableHeaderView.delegate = (id<EGORefreshTableHeaderDelegate>)self;
    _egoRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
    [_tableHistory addSubview:_egoRefreshTableHeaderView];
    
    //  update the last update date
    [_egoRefreshTableHeaderView refreshLastUpdatedDate];
    
    [self createFilterMenu];
    
    //Create But Right Nav Btn
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    UIImageView *imgViewNew = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [imgViewNew setImage:[UIImage imageNamed:@"nav-filter-btn"]];
    [self.view addSubview:imgViewNew];
    
    CSButton *btnFilter = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFilter.frame = CGRectMake(CGRectGetMinX(imgViewNew.frame) - 5, CGRectGetMinY(imgViewNew.frame) - 5, 45, 45);
    btnFilter.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnFilter];
    [self.view bringSubviewToFront:btnFilter];
    
    __weak __typeof(self) weakSelf = self;
    
    btnFilter.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf showFiterView];
    };
    
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 20.0f, 20.0f)];
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 48) / 2, (CGRectGetHeight(viewBody.frame) - 48) / 2, 48, 48)];
    m_activityIndicatorMain.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    m_activityIndicatorMain.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    m_activityIndicatorMain.hidden = NO;
    m_activityIndicatorMain.hidesWhenStopped = YES;
    [viewBody addSubview:m_activityIndicatorMain];
    
    [m_activityIndicatorMain startAnimating];
    
    if (_userInfo.userid.length > 0)
    {
        //Load Friend LeadBoard
        [self reloadLeadBoardData];
    }
}

-(void)createFilterMenu
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    _viewMenu = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(viewBody.frame) - 120, -120, 120, 120)];
    _viewMenu.backgroundColor = [UIColor whiteColor];
    _viewMenu.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    _viewMenu.layer.borderWidth = 0.65f;
    [viewBody addSubview:_viewMenu];
    
    UIImageView *imgSelect0 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 20, 17)];
    [imgSelect0 setImage:[UIImage imageNamed:@"me-history-filter-select"]];
    imgSelect0.hidden = NO;
    [_viewMenu addSubview:imgSelect0];
    
    UIImageView *imgSelect1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 51, 20, 17)];
    [imgSelect1 setImage:[UIImage imageNamed:@"me-history-filter-select"]];
    imgSelect1.hidden = YES;
    [_viewMenu addSubview:imgSelect1];
    
    UIImageView *imgSelect2 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 91, 20, 17)];
    [imgSelect2 setImage:[UIImage imageNamed:@"me-history-filter-select"]];
    imgSelect2.hidden = YES;
    [_viewMenu addSubview:imgSelect2];
    
    CSButton *btnAll = [CSButton buttonWithType:UIButtonTypeCustom];
    [btnAll setTitle:@"全部" forState:UIControlStateNormal];
    [btnAll.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    btnAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnAll.backgroundColor = [UIColor clearColor];
    btnAll.frame = CGRectMake(0, 0, 120, 37);
    [_viewMenu addSubview:btnAll];
    
    __weak __typeof(self) weakSelf = self;
    
    btnAll.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        imgSelect0.hidden = NO;
        imgSelect1.hidden = YES;
        imgSelect2.hidden = YES;
        [strongSelf showFiterView];
        [strongSelf actionAllHistory];
    };
    
    UILabel *lbSep0 = [[UILabel alloc]initWithFrame:CGRectMake(0, 38, 120, 1)];
    lbSep0.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    [_viewMenu addSubview:lbSep0];
    
    CSButton *btnSport = [CSButton buttonWithType:UIButtonTypeCustom];
    [btnSport setTitle:@"运动史" forState:UIControlStateNormal];
    [btnSport.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    btnSport.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnSport setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnSport.backgroundColor = [UIColor clearColor];
    btnSport.frame = CGRectMake(0, 40, 120, 37);
    [_viewMenu addSubview:btnSport];
    
    btnSport.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        imgSelect0.hidden = YES;
        imgSelect1.hidden = NO;
        imgSelect2.hidden = YES;
        [strongSelf showFiterView];
        [strongSelf actionSportHistory];
    };
    
    UILabel *lbSep1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 78, 120, 1)];
    lbSep1.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    [_viewMenu addSubview:lbSep1];
    
    CSButton *btnGame = [CSButton buttonWithType:UIButtonTypeCustom];
    [btnGame setTitle:@"游戏史" forState:UIControlStateNormal];
    [btnGame.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    btnGame.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [btnGame setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnGame.backgroundColor = [UIColor clearColor];
    btnGame.frame = CGRectMake(0, 80, 120, 38);
    [_viewMenu addSubview:btnGame];
    
    btnGame.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        imgSelect0.hidden = YES;
        imgSelect1.hidden = YES;
        imgSelect2.hidden = NO;
        [strongSelf showFiterView];
        [strongSelf actionGameHistory];
    };
    
    [_viewMenu bringSubviewToFront:imgSelect0];
    [_viewMenu bringSubviewToFront:imgSelect1];
    [_viewMenu bringSubviewToFront:imgSelect2];
    _viewMenu.hidden = YES;
}

-(void)actionAllHistory
{
    _nHistoryType = HISTORY_TYPE_ALL;
    
    if (![_strType isEqualToString:@""]) {
        _strType = @"";
        _strFirstPageId = @"";
        [self showCommonProcess];
        [self reloadLeadBoardData];
    }
}

-(void)actionSportHistory
{
    _nHistoryType = HISTORY_TYPE_SPORT;
    
    if (![_strType isEqualToString:@"run"]) {
        _strType = @"run";
        _strFirstPageId = @"";
        [self showCommonProcess];
        [self reloadLeadBoardData];
    }
}

-(void)actionGameHistory
{
    _nHistoryType = HISTORY_TYPE_GAME;
    
    if (![_strType isEqualToString:@"game"]) {
        _strType = @"game";
        _strFirstPageId = @"";
        [self showCommonProcess];
        [self reloadLeadBoardData];
    }
}

-(void)showFiterView
{
    if ([_viewMenu isHidden]) {
        _tableHistory.userInteractionEnabled = NO;
        
        [UIView animateWithDuration:0.2
                         animations:^(void) {
                             _viewMenu.alpha = 1.0f;
                             _viewMenu.frame = CGRectMake(310 - 120, 0, 120, 120);
                         } completion:^(BOOL completed) {
                             _viewMenu.hidden = NO;
                         }];
    }
    else
    {
        _tableHistory.userInteractionEnabled = YES;
        
        [UIView animateWithDuration:0.2
                         animations:^(void) {
                             _viewMenu.alpha = 0;
                             _viewMenu.frame = CGRectMake(310 - 120, -120, 120, 120);
                         } completion:^(BOOL finished) {
                             _viewMenu.hidden = YES;
                         }];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"江湖史 - HistoryViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"江湖史 - HistoryViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"江湖史 - HistoryViewController"];
    [self hideCommonProcess];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlRecordTimeline, nil]];
}

-(void)showCommonProcess
{
    if (_processWin) {
        [AlertManager dissmiss:_processWin];
        _processWin = nil;
    }
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    _processWin = [AlertManager showCommonProgressInView:viewBody];
}

-(void)hideCommonProcess
{
    [AlertManager dissmiss:_processWin];
    _processWin = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"HistoryViewController dealloc called!");
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

- (void)setHistoryType:(int)nType
{
    _nHistoryType = nType;
}

-(void)reloadLeadBoardData
{
    [self reloadDataWithFirstPageID:_strFirstPageId LastPageId:@""];
}

-(NSString*)convertToTaskStatus:(e_task_status) eTaskStatus
{
    NSString *strStatus = @"";
    
    switch (eTaskStatus) {
        case e_task_normal:
            strStatus = @"尚未执行";
            break;
        case e_task_finish:
            strStatus = @"审核已通过";
            break;
        case e_task_unfinish:
            strStatus = @"审核未通过";
            break;
        case e_task_authentication:
            strStatus = @"审核中";
            break;
        default:
            break;
    }
    
    return strStatus;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrayHistory.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SportRecordInfo *boardItem = _arrayHistory[indexPath.row];
    NSString * strType = boardItem.type;

    if (boardItem.status.length > 0) {
        if([strType isEqualToString:@"run"] && (_nHistoryType == HISTORY_TYPE_SPORT || _nHistoryType == HISTORY_TYPE_ALL))
        {
            return boardItem.source.length > 0 ? 150 : 140;
        }
        else if([strType isEqualToString:@"game"] && (_nHistoryType == HISTORY_TYPE_GAME || _nHistoryType == HISTORY_TYPE_ALL))
        {
            return 105;
        }
    }
    else if([strType isEqualToString:@"run"] && (_nHistoryType == HISTORY_TYPE_SPORT || _nHistoryType == HISTORY_TYPE_ALL))
    {
        return boardItem.source.length > 0 ? 135 : 125;
    }
    else if([strType isEqualToString:@"game"] && (_nHistoryType == HISTORY_TYPE_GAME || _nHistoryType == HISTORY_TYPE_ALL))
    {
        return 95;
    }

    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"billListIdentifier";
    
    SportRecordInfo * boardItem = _arrayHistory[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel * lbTimeBegin = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 15)];
        lbTimeBegin.tag = 30;
        lbTimeBegin.text = @"开始时间：";
        lbTimeBegin.backgroundColor = [UIColor clearColor];
        lbTimeBegin.textColor = [UIColor grayColor];
        lbTimeBegin.font = [UIFont boldSystemFontOfSize:12];
        lbTimeBegin.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbTimeBegin];
        
        UILabel * lbBeginDate = [[UILabel alloc] initWithFrame:CGRectMake(80, 5, cell.contentView.frame.size.width - 150, 15)];
        lbBeginDate.tag = 31;
        lbBeginDate.backgroundColor = [UIColor clearColor];
        lbBeginDate.textColor = [UIColor grayColor];
        lbBeginDate.font = [UIFont boldSystemFontOfSize:12];
        lbBeginDate.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbBeginDate];
        
        UILabel * lbTimeEnd = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 60, 15)];
        lbTimeEnd.tag = 32;
        lbTimeEnd.text = @"结束时间：";
        lbTimeEnd.backgroundColor = [UIColor clearColor];
        lbTimeEnd.textColor = [UIColor grayColor];
        lbTimeEnd.font = [UIFont boldSystemFontOfSize:12];
        lbTimeEnd.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbTimeEnd];
        
        UILabel * lbEndDate = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, cell.contentView.frame.size.width - 150, 15)];
        lbEndDate.tag = 33;
        lbEndDate.backgroundColor = [UIColor clearColor];
        lbEndDate.textColor = [UIColor grayColor];
        lbEndDate.font = [UIFont boldSystemFontOfSize:12];
        lbEndDate.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbEndDate];
        
        UILabel * lbDistanceTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 60, 15)];
        lbDistanceTitle.tag = 52;
        lbDistanceTitle.backgroundColor = [UIColor clearColor];
        lbDistanceTitle.textColor = [UIColor grayColor];
        lbDistanceTitle.font = [UIFont boldSystemFontOfSize:12];
        lbDistanceTitle.textAlignment = NSTextAlignmentLeft;
        lbDistanceTitle.text = @"距离：";
        [cell.contentView addSubview:lbDistanceTitle];
        
        UILabel * lbDistance = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, cell.contentView.frame.size.width - 150, 15)];
        lbDistance.tag = 53;
        lbDistance.backgroundColor = [UIColor clearColor];
        lbDistance.textColor = [UIColor grayColor];
        lbDistance.font = [UIFont boldSystemFontOfSize:12];
        lbDistance.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbDistance];
        
        UILabel * lbDurationTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 60, 15)];
        lbDurationTitle.tag = 54;
        lbDurationTitle.backgroundColor = [UIColor clearColor];
        lbDurationTitle.textColor = [UIColor grayColor];
        lbDurationTitle.font = [UIFont boldSystemFontOfSize:12];
        lbDurationTitle.textAlignment = NSTextAlignmentLeft;
        lbDurationTitle.text = @"运动时间：";
        [cell.contentView addSubview:lbDurationTitle];
        
        UILabel * lbDuration = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, cell.contentView.frame.size.width - 150, 15)];
        lbDuration.tag = 55;
        lbDuration.backgroundColor = [UIColor clearColor];
        lbDuration.textColor = [UIColor grayColor];
        lbDuration.font = [UIFont boldSystemFontOfSize:12];
        lbDuration.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbDuration];
        
        UILabel * lbSpeedTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 60, 15)];
        lbSpeedTitle.tag = 56;
        lbSpeedTitle.backgroundColor = [UIColor clearColor];
        lbSpeedTitle.textColor = [UIColor grayColor];
        lbSpeedTitle.font = [UIFont boldSystemFontOfSize:12];
        lbSpeedTitle.textAlignment = NSTextAlignmentLeft;
        lbSpeedTitle.text = @"速度：";
        [cell.contentView addSubview:lbSpeedTitle];
        
        UILabel * lbSpeed = [[UILabel alloc] initWithFrame:CGRectMake(80, 65, cell.contentView.frame.size.width - 150, 15)];
        lbSpeed.tag = 57;
        lbSpeed.backgroundColor = [UIColor clearColor];
        lbSpeed.textColor = [UIColor grayColor];
        lbSpeed.font = [UIFont boldSystemFontOfSize:12];
        lbSpeed.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbSpeed];
        
        UILabel * lbCalorieTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 60, 15)];
        lbCalorieTitle.tag = 58;
        lbCalorieTitle.backgroundColor = [UIColor clearColor];
        lbCalorieTitle.textColor = [UIColor grayColor];
        lbCalorieTitle.font = [UIFont boldSystemFontOfSize:12];
        lbCalorieTitle.textAlignment = NSTextAlignmentLeft;
        lbCalorieTitle.text = @"卡路里：";
        [cell.contentView addSubview:lbCalorieTitle];
        
        UILabel * lbCalorie = [[UILabel alloc] initWithFrame:CGRectMake(80, 80, cell.contentView.frame.size.width - 150, 15)];
        lbCalorie.tag = 59;
        lbCalorie.backgroundColor = [UIColor clearColor];
        lbCalorie.textColor = [UIColor grayColor];
        lbCalorie.font = [UIFont boldSystemFontOfSize:12];
        lbCalorie.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbCalorie];
        
        UILabel * lbRunCoinTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 95, 60, 15)];
        lbRunCoinTitle.tag = 82;
        lbRunCoinTitle.backgroundColor = [UIColor clearColor];
        lbRunCoinTitle.textColor = [UIColor grayColor];
        lbRunCoinTitle.font = [UIFont boldSystemFontOfSize:12];
        lbRunCoinTitle.textAlignment = NSTextAlignmentLeft;
        lbRunCoinTitle.text = @"金币值：";
        [cell.contentView addSubview:lbRunCoinTitle];
        
        UILabel * lbRunCoin = [[UILabel alloc] initWithFrame:CGRectMake(80, 95, cell.contentView.frame.size.width - 150, 15)];
        lbRunCoin.tag = 83;
        lbRunCoin.backgroundColor = [UIColor clearColor];
        lbRunCoin.textColor = [UIColor grayColor];
        lbRunCoin.font = [UIFont boldSystemFontOfSize:12];
        lbRunCoin.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbRunCoin];
        
        UILabel * lbSourceTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 60, 15)];
        lbSourceTitle.tag = 34;
        lbSourceTitle.backgroundColor = [UIColor clearColor];
        lbSourceTitle.textColor = [UIColor grayColor];
        lbSourceTitle.font = [UIFont boldSystemFontOfSize:12];
        lbSourceTitle.textAlignment = NSTextAlignmentLeft;
        lbSourceTitle.text = @"数据来源：";
        [cell.contentView addSubview:lbSourceTitle];
        
        UILabel * lbSourceData = [[UILabel alloc] initWithFrame:CGRectMake(80, 110, cell.contentView.frame.size.width - 150, 15)];
        lbSourceData.tag = 35;
        lbSourceData.backgroundColor = [UIColor clearColor];
        lbSourceData.textColor = [UIColor grayColor];
        lbSourceData.font = [UIFont boldSystemFontOfSize:12];
        lbSourceData.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbSourceData];
        
        UILabel * lbMPTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 60, 15)];
        lbMPTitle.tag = 62;
        lbMPTitle.backgroundColor = [UIColor clearColor];
        lbMPTitle.textColor = [UIColor grayColor];
        lbMPTitle.font = [UIFont boldSystemFontOfSize:12];
        lbMPTitle.textAlignment = NSTextAlignmentLeft;
        lbMPTitle.text = @"游戏名：";
        [cell.contentView addSubview:lbMPTitle];
        
        UILabel * lbMP = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, cell.contentView.frame.size.width - 150, 15)];
        lbMP.tag = 63;
        lbMP.backgroundColor = [UIColor clearColor];
        lbMP.textColor = [UIColor grayColor];
        lbMP.font = [UIFont boldSystemFontOfSize:12];
        lbMP.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbMP];
        
        UILabel * lbScoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 60, 15)];
        lbScoreTitle.tag = 60;
        lbScoreTitle.backgroundColor = [UIColor clearColor];
        lbScoreTitle.textColor = [UIColor grayColor];
        lbScoreTitle.font = [UIFont boldSystemFontOfSize:12];
        lbScoreTitle.textAlignment = NSTextAlignmentLeft;
        lbScoreTitle.text = @"游戏分数：";
        [cell.contentView addSubview:lbScoreTitle];
        
        UILabel * lbScore = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, cell.contentView.frame.size.width - 150, 15)];
        lbScore.tag = 61;
        lbScore.backgroundColor = [UIColor clearColor];
        lbScore.textColor = [UIColor grayColor];
        lbScore.font = [UIFont boldSystemFontOfSize:12];
        lbScore.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbScore];
        
        UILabel * lbScoreMagic = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 60, 15)];
        lbScoreMagic.tag = 72;
        lbScoreMagic.backgroundColor = [UIColor clearColor];
        lbScoreMagic.textColor = [UIColor grayColor];
        lbScoreMagic.font = [UIFont boldSystemFontOfSize:12];
        lbScoreMagic.textAlignment = NSTextAlignmentLeft;
        lbScoreMagic.text = @"魔法值：";
        [cell.contentView addSubview:lbScoreMagic];
        
        UILabel * lbTask = [[UILabel alloc] initWithFrame:CGRectZero];
        lbTask.tag = 49;
        lbTask.backgroundColor = [UIColor clearColor];
        lbTask.textColor = [UIColor grayColor];
        lbTask.font = [UIFont boldSystemFontOfSize:12];
        lbTask.textAlignment = NSTextAlignmentLeft;
        lbTask.text = @"任务状态：";
        [cell.contentView addSubview:lbTask];
        
        UILabel * lbTaskStatus = [[UILabel alloc] initWithFrame:CGRectZero];
        lbTaskStatus.tag = 50;
        lbTaskStatus.backgroundColor = [UIColor clearColor];
        lbTaskStatus.textColor = [UIColor grayColor];
        lbTaskStatus.font = [UIFont boldSystemFontOfSize:12];
        lbTaskStatus.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbTaskStatus];
        
        UILabel * lbMagicValue = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, cell.contentView.frame.size.width - 150, 15)];
        lbMagicValue.tag = 73;
        lbMagicValue.backgroundColor = [UIColor clearColor];
        lbMagicValue.textColor = [UIColor grayColor];
        lbMagicValue.font = [UIFont boldSystemFontOfSize:12];
        lbMagicValue.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbMagicValue];
        
        UILabel * lbMagicCoinTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 60, 15)];
        lbMagicCoinTitle.tag = 80;
        lbMagicCoinTitle.backgroundColor = [UIColor clearColor];
        lbMagicCoinTitle.textColor = [UIColor grayColor];
        lbMagicCoinTitle.font = [UIFont boldSystemFontOfSize:12];
        lbMagicCoinTitle.textAlignment = NSTextAlignmentLeft;
        lbMagicCoinTitle.text = @"金币值：";
        [cell.contentView addSubview:lbMagicCoinTitle];
        
        UILabel * lbMagicCoin = [[UILabel alloc] initWithFrame:CGRectMake(80, 65, cell.contentView.frame.size.width - 150, 15)];
        lbMagicCoin.tag = 81;
        lbMagicCoin.backgroundColor = [UIColor clearColor];
        lbMagicCoin.textColor = [UIColor grayColor];
        lbMagicCoin.font = [UIFont boldSystemFontOfSize:12];
        lbMagicCoin.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbMagicCoin];
        
        UILabel * lbSeparate1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 139, cell.contentView.frame.size.width, 1)];
        lbSeparate1.tag = 64;
        lbSeparate1.backgroundColor = [UIColor colorWithRed:213 / 255.0 green:213 / 255.0 blue:210 / 255.0 alpha:1.0];
        [cell.contentView addSubview:lbSeparate1];
        
        UILabel * lbSeparate2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 94, cell.contentView.frame.size.width, 1)];
        lbSeparate2.tag = 65;
        lbSeparate2.backgroundColor = [UIColor colorWithRed:213 / 255.0 green:213 / 255.0 blue:210 / 255.0 alpha:1.0];
        [cell.contentView addSubview:lbSeparate2];
        
        UILabel * lbSeparate3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 149, cell.contentView.frame.size.width, 1)];
        lbSeparate3.tag = 75;
        lbSeparate3.backgroundColor = [UIColor colorWithRed:213 / 255.0 green:213 / 255.0 blue:210 / 255.0 alpha:1.0];
        [cell.contentView addSubview:lbSeparate3];
        
        UILabel * lbSeparate4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 104, cell.contentView.frame.size.width, 1)];
        lbSeparate4.tag = 36;
        lbSeparate4.backgroundColor = [UIColor colorWithRed:213 / 255.0 green:213 / 255.0 blue:210 / 255.0 alpha:1.0];
        [cell.contentView addSubview:lbSeparate4];
        
        UILabel * lbSeparate5 = [[UILabel alloc] initWithFrame:CGRectMake(0, 134, cell.contentView.frame.size.width, 1)];
        lbSeparate5.tag = 37;
        lbSeparate5.backgroundColor = [UIColor colorWithRed:213 / 255.0 green:213 / 255.0 blue:210 / 255.0 alpha:1.0];
        [cell.contentView addSubview:lbSeparate5];
        
        UILabel * lbSeparate6 = [[UILabel alloc] initWithFrame:CGRectMake(0, 124, cell.contentView.frame.size.width, 1)];
        lbSeparate6.tag = 38;
        lbSeparate6.backgroundColor = [UIColor colorWithRed:213 / 255.0 green:213 / 255.0 blue:210 / 255.0 alpha:1.0];
        [cell.contentView addSubview:lbSeparate6];
        
        UIImageView * imgHistory = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 80, 20, 60, 60)];
        imgHistory.tag = 66;
        //imgHistory.contentMode = UIViewContentModeScaleAspectFill;
        imgHistory.clipsToBounds  = YES;
        imgHistory.layer.cornerRadius = 5.0;
        [cell.contentView addSubview:imgHistory];
        
        UIView * backframe = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imgHistory.frame) - 1, CGRectGetMinY(imgHistory.frame) - 1, CGRectGetWidth(imgHistory.frame) + 2, CGRectGetHeight(imgHistory.frame) + 2)];
        backframe.tag = 67;
        backframe.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
        backframe.layer.borderWidth = 1.0;
        backframe.layer.borderColor = [[UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1] CGColor];
        //[cell.contentView addSubview:backframe];
        
        CSButton *btnImage = [CSButton buttonWithType:UIButtonTypeCustom];
        btnImage.frame = imgHistory.frame;
        btnImage.backgroundColor = [UIColor clearColor];
        btnImage.tag = 68;
        [cell.contentView addSubview:btnImage];

        UIImageView * imgHistoryGame = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 80, 20, 60, 60)];
        imgHistoryGame.tag = 69;
        [cell.contentView addSubview:imgHistoryGame];

        UIImageView * imgHistoryRun = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width - 80, 20, 60, 60)];
        imgHistoryRun.tag = 29;
        [cell.contentView addSubview:imgHistoryRun];
        
        [cell.contentView bringSubviewToFront:imgHistory];
        [cell.contentView bringSubviewToFront:btnImage];
    }
    
    UILabel * lbSourceTitle = (UILabel *)[cell.contentView viewWithTag: 34];
    UILabel * lbSourceData = (UILabel *)[cell.contentView viewWithTag: 35];
    UILabel * lbBeginTime = (UILabel *)[cell.contentView viewWithTag: 30];
    UILabel * lbBeginDate = (UILabel *)[cell.contentView viewWithTag: 31];
    UILabel * lbEndTime = (UILabel *)[cell.contentView viewWithTag: 32];
    UILabel * lbEndDate = (UILabel *)[cell.contentView viewWithTag: 33];
    UILabel * lbDistanceTitle = (UILabel *)[cell.contentView viewWithTag: 52];
    UILabel * lbDistance = (UILabel *)[cell.contentView viewWithTag: 53];
    UILabel * lbDurationTitle = (UILabel *)[cell.contentView viewWithTag: 54];
    UILabel * lbDuration = (UILabel *)[cell.contentView viewWithTag: 55];
    UILabel * lbSpeedTitle = (UILabel *)[cell.contentView viewWithTag: 56];
    UILabel * lbSpeed = (UILabel *)[cell.contentView viewWithTag: 57];
    UILabel * lbCalorieTitle = (UILabel *)[cell.contentView viewWithTag: 58];
    UILabel * lbCalorie = (UILabel *)[cell.contentView viewWithTag: 59];
    UILabel * lbScoreTitle = (UILabel *)[cell.contentView viewWithTag: 60];
    UILabel * lbScore = (UILabel *)[cell.contentView viewWithTag: 61];
    UILabel * lbMPTitle = (UILabel *)[cell.contentView viewWithTag: 62];
    UILabel * lbMP = (UILabel *)[cell.contentView viewWithTag: 63];
    UILabel * lbSeparate1 = (UILabel *)[cell.contentView viewWithTag: 64];
    UILabel * lbSeparate2 = (UILabel *)[cell.contentView viewWithTag: 65];
    UILabel * lbSeparate3 = (UILabel *)[cell.contentView viewWithTag: 75];
    UILabel * lbSeparate4 = (UILabel *)[cell.contentView viewWithTag: 36];
    UILabel * lbSeparate5 = (UILabel *)[cell.contentView viewWithTag: 37];
    UILabel * lbSeparate6 = (UILabel *)[cell.contentView viewWithTag: 38];
    UIImageView * imgHistory = (UIImageView *)[cell.contentView viewWithTag: 66];
    UIImageView * imgHistoryRun = (UIImageView *)[cell.contentView viewWithTag: 29];
    //UIView *backframe = [cell.contentView viewWithTag: 67];
    CSButton *btnImage = (CSButton*)[cell.contentView viewWithTag: 68];
    UIImageView * imgHistoryGame = (UIImageView *)[cell.contentView viewWithTag: 69];
    UILabel * lbScoreMagic = (UILabel *)[cell.contentView viewWithTag: 72];
    UILabel * lbMagicValue = (UILabel *)[cell.contentView viewWithTag: 73];
    UILabel * lbTask = (UILabel *)[cell.contentView viewWithTag: 49];
    UILabel *lbTaskStatus = (UILabel *)[cell.contentView viewWithTag: 50];
    UILabel * lbMagicCoinTitle = (UILabel *)[cell.contentView viewWithTag: 80];
    UILabel * lbMagicCoin = (UILabel *)[cell.contentView viewWithTag: 81];
    UILabel * lbRunCoinTitle = (UILabel *)[cell.contentView viewWithTag: 82];
    UILabel * lbRunCoin = (UILabel *)[cell.contentView viewWithTag: 83];
    
    NSDate * beginDay = [NSDate dateWithTimeIntervalSince1970:boardItem.begin_time];
    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginDay];

    NSDate * endDay = [NSDate dateWithTimeIntervalSince1970:boardItem.end_time];
    NSDateComponents * compsEnd =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:endDay];
    
    lbSourceData.text = boardItem.source;
    lbBeginDate.text = [NSString stringWithFormat:@"%02ld/%02ld/%04ld %.2ld:%.2ld", [comps month], [comps day], [comps year], [comps hour], [comps minute]];
    lbEndDate.text = [NSString stringWithFormat:@"%02ld/%02ld/%04ld %.2ld:%.2ld", [compsEnd month], [compsEnd day], [compsEnd year], [compsEnd hour], [compsEnd minute]];
    lbDistance.text = [NSString stringWithFormat:@"%.2f公里", boardItem.distance / 1000.0];
    lbDuration.text = [NSString stringWithFormat:@"%ld分钟", boardItem.duration / 60];
    lbSpeed.text = [NSString stringWithFormat:@"%.2f公里/小时", (boardItem.distance / 1000.00) / (boardItem.duration / 3600.00)];
    lbCalorie.text = [NSString stringWithFormat:@"%.0f卡", _userInfo.weight * boardItem.distance / 800.0]; //跑步热量（kcal）＝体重（kg）×运动时间（小时）×指数K(指数K＝30÷速度（分钟/400米)
    /*lbCalorie.text = boardItem.duration > 0 ? [NSString stringWithFormat:@"%.0f大卡", _userInfo.weight * (boardItem.duration / 3600.0) * 30.0 / (60.0 / ((boardItem.distance) / (boardItem.duration / 3600.0) / 400.0)) ] : [NSString stringWithFormat:@"%.0f大卡", _userInfo.weight * boardItem.distance / 800.0]; //跑步热量（kcal）＝体重（kg）×运动时间（小时）×指数K(指数K＝30÷速度（分钟/400米)*/
    lbScore.text = [NSString stringWithFormat:@"%ld", boardItem.game_score];
    lbMP.text = boardItem.game_name;
    
    if ([boardItem.game_name isEqualToString:@"转你妹"]) {
        lbMP.text = @"幸运转盘";
        boardItem.game_name = @"幸运转盘";
    }
    
    lbMagicValue.text = [NSString stringWithFormat:@"%ld", boardItem.magic];
    lbTaskStatus.text = [self convertToTaskStatus:[CommonFunction ConvertStringToTaskStatusType:boardItem.status]];
    lbRunCoin.text = [NSString stringWithFormat:@"%lld", boardItem.coin_value / 100000000];
    lbMagicCoin.text = [NSString stringWithFormat:@"%lld", boardItem.coin_value / 100000000];
    [imgHistoryRun setImage:[UIImage imageNamed:@"details-healthAPP"]];
    imgHistoryRun.hidden = YES;
    
    if (boardItem.status.length > 0) {
        if([boardItem.type isEqualToString:@"run"]) {
            lbBeginTime.hidden = NO;
            lbBeginDate.hidden = NO;
            lbEndTime.hidden = NO;
            lbEndDate.hidden = NO;
            lbDistanceTitle.hidden = NO;
            lbDistance.hidden = NO;
            lbDurationTitle.hidden = NO;
            lbDuration.hidden = NO;
            lbSpeedTitle.hidden = NO;
            lbSpeed.hidden = NO;
            lbCalorieTitle.hidden = NO;
            lbCalorie.hidden = NO;
            lbTask.hidden = NO;
            lbTaskStatus.hidden = NO;
            lbRunCoinTitle.hidden = NO;
            lbRunCoin.hidden = NO;
            lbMagicCoinTitle.hidden = YES;
            lbMagicCoin.hidden = YES;
            lbScoreTitle.hidden = YES;
            lbScore.hidden = YES;
            lbMPTitle.hidden = YES;
            lbMP.hidden = YES;
            lbScoreMagic.hidden = YES;
            lbMagicValue.hidden = YES;
            lbSeparate2.hidden = YES;
            lbSeparate4.hidden = YES;
            lbSeparate5.hidden = YES;
            lbSeparate6.hidden = YES;
            
            cell.hidden = (_nHistoryType == HISTORY_TYPE_GAME);
            
            if (boardItem.source.length > 0) {
                lbSourceTitle.hidden = NO;
                lbSourceData.hidden = NO;
                lbSeparate1.hidden = YES;
                lbSeparate3.hidden = NO;
                lbTask.frame = CGRectMake(10, 125, 60, 15);
                lbTaskStatus.frame = CGRectMake(80, 125, cell.contentView.frame.size.width - 150, 15);
            }
            else
            {
                lbSourceTitle.hidden = YES;
                lbSourceData.hidden = YES;
                lbSeparate1.hidden = NO;
                lbSeparate3.hidden = YES;
                lbTask.frame = CGRectMake(10, 110, 60, 15);
                lbTaskStatus.frame = CGRectMake(80, 110, cell.contentView.frame.size.width - 150, 15);
            }
        }
        else
        {
            lbBeginTime.hidden = NO;
            lbBeginDate.hidden = NO;
            lbEndTime.hidden = YES;
            lbEndDate.hidden = YES;
            lbSourceTitle.hidden = YES;
            lbSourceData.hidden = YES;
            lbDistanceTitle.hidden = YES;
            lbDistance.hidden = YES;
            lbDurationTitle.hidden = YES;
            lbDuration.hidden = YES;
            lbSpeedTitle.hidden = YES;
            lbSpeed.hidden = YES;
            lbCalorieTitle.hidden = YES;
            lbCalorie.hidden = YES;
            lbRunCoinTitle.hidden = YES;
            lbRunCoin.hidden = YES;
            lbMagicCoinTitle.hidden = NO;
            lbMagicCoin.hidden = NO;
            lbScoreTitle.hidden = NO;
            lbScore.hidden = NO;
            lbMPTitle.hidden = NO;
            lbMP.hidden = NO;
            lbScoreMagic.hidden = NO;
            lbMagicValue.hidden = NO;
            lbTask.hidden = NO;
            lbTaskStatus.hidden = NO;
            lbSeparate1.hidden = YES;
            lbSeparate2.hidden = YES;
            lbSeparate3.hidden = YES;
            lbSeparate4.hidden = NO;
            lbSeparate5.hidden = YES;
            lbSeparate6.hidden = YES;
            cell.hidden = (_nHistoryType == HISTORY_TYPE_SPORT);
            lbTask.frame = CGRectMake(10, 80, 60, 15);
            lbTaskStatus.frame = CGRectMake(80, 80, cell.contentView.frame.size.width - 150, 15);
        }
    }
    else if([boardItem.type isEqualToString:@"run"])
    {
        lbBeginTime.hidden = NO;
        lbBeginDate.hidden = NO;
        lbEndTime.hidden = NO;
        lbEndDate.hidden = NO;
        lbDistanceTitle.hidden = NO;
        lbDistance.hidden = NO;
        lbDurationTitle.hidden = NO;
        lbDuration.hidden = NO;
        lbSpeedTitle.hidden = NO;
        lbSpeed.hidden = NO;
        lbCalorieTitle.hidden = NO;
        lbCalorie.hidden = NO;
        lbRunCoinTitle.hidden = NO;
        lbRunCoin.hidden = NO;
        lbMagicCoinTitle.hidden = YES;
        lbMagicCoin.hidden = YES;
        lbScoreTitle.hidden = YES;
        lbScore.hidden = YES;
        lbMPTitle.hidden = YES;
        lbMP.hidden = YES;
        lbScoreMagic.hidden = YES;
        lbMagicValue.hidden = YES;
        lbTask.hidden = YES;
        lbTaskStatus.hidden = YES;
        lbSeparate1.hidden = YES;
        lbSeparate2.hidden = YES;
        lbSeparate3.hidden = YES;
        lbSeparate4.hidden = YES;

        cell.hidden = (_nHistoryType == HISTORY_TYPE_GAME);

        if (boardItem.source.length > 0) {
            lbSourceTitle.hidden = NO;
            lbSourceData.hidden = NO;
            lbSeparate5.hidden = NO;
            lbSeparate6.hidden = YES;
        }
        else
        {
            lbSourceTitle.hidden = YES;
            lbSourceData.hidden = YES;
            lbSeparate5.hidden = YES;
            lbSeparate6.hidden = NO;
        }
    }
    else
    {
        lbBeginTime.hidden = NO;
        lbBeginDate.hidden = NO;
        lbEndTime.hidden = YES;
        lbEndDate.hidden = YES;
        lbSourceTitle.hidden = YES;
        lbSourceData.hidden = YES;
        lbDistanceTitle.hidden = YES;
        lbDistance.hidden = YES;
        lbDurationTitle.hidden = YES;
        lbDuration.hidden = YES;
        lbSpeedTitle.hidden = YES;
        lbSpeed.hidden = YES;
        lbCalorieTitle.hidden = YES;
        lbCalorie.hidden = YES;
        lbRunCoinTitle.hidden = YES;
        lbRunCoin.hidden = YES;
        lbMagicCoinTitle.hidden = NO;
        lbMagicCoin.hidden = NO;
        lbScoreTitle.hidden = NO;
        lbScore.hidden = NO;
        lbMPTitle.hidden = NO;
        lbMP.hidden = NO;
        lbScoreMagic.hidden = NO;
        lbMagicValue.hidden = NO;
        lbTask.hidden = YES;
        lbTaskStatus.hidden = YES;
        lbSeparate1.hidden = YES;
        lbSeparate2.hidden = NO;
        lbSeparate3.hidden = YES;
        lbSeparate4.hidden = YES;
        lbSeparate5.hidden = YES;
        lbSeparate6.hidden = YES;
        cell.hidden = (_nHistoryType == HISTORY_TYPE_SPORT);
    }
    
    if(boardItem.sport_pics.data.count > 0)
    {
        imgHistory.hidden = NO;
        //backframe.hidden = NO;
        btnImage.hidden = NO;
        imgHistoryGame.hidden = YES;
        [imgHistory sd_setImageWithURL:[NSURL URLWithString:boardItem.sport_pics.data[0]]
                              placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    }
    else if([boardItem.type isEqualToString:@"run"])
    {
        imgHistoryRun.hidden = NO;
        imgHistory.hidden = YES;
        //backframe.hidden = YES;
        btnImage.hidden = YES;
        imgHistoryGame.hidden = YES;
    }
    else if([boardItem.type isEqualToString:@"game"])
    {
        NSString *strImage = @"";
        
        if ([boardItem.game_name isEqualToString:@"熊出没"]) {
            strImage = @"game-bear";
        }
        else if([boardItem.game_name isEqualToString:@"爱之跳跳"])
        {
            strImage = @"game-qixi";
        }
        else if([boardItem.game_name isEqualToString:@"蜘蛛侠"])
        {
            strImage = @"game-lineLife";
        }
        else if([boardItem.game_name isEqualToString:@"古墓历险"])
        {
            strImage = @"game-escape";
        }
        else if([boardItem.game_name isEqualToString:@"幸运转盘"])
        {
            strImage = @"game-rotate";
        }

        if (strImage.length > 0) {
            imgHistoryGame.hidden = NO;
            [imgHistoryGame setImage:[UIImage imageNamed:strImage]];
        }
        else
        {
            imgHistoryGame.hidden = YES;
        }
        
        imgHistory.hidden = YES;
        //backframe.hidden = YES;
        btnImage.hidden = YES;
    }
    else
    {
        imgHistory.hidden = YES;
        //backframe.hidden = YES;
        btnImage.hidden = YES;
        imgHistoryGame.hidden = YES;
    }
    
    __weak __typeof(self) weakSelf = self;
    
    btnImage.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf onClickImageViewByIndex:boardItem.sport_pics.data];
    };
    
    return cell;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

-(void)onClickImageViewByIndex:(NSMutableArray*)imgUrlArray
{
    if ([imgUrlArray count] == 0) {
        return;
    }
    
    [_photos removeAllObjects];
    
    for (NSString *strUrl in imgUrlArray) {
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:strUrl]]];
    }
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayDeleteButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;
#endif
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
}

-(void)reloadDataWithFirstPageID:(NSString*)strFirstrPageId LastPageId:(NSString*)strLastPageId

{
    __weak __typeof(self) weakSelf = self;
    [[SportForumAPI sharedInstance] recordTimeLineByUserId:_userInfo.userid
                                               FirstPageId:strFirstrPageId
                                                LastPageId:strLastPageId
                                               PageItemNum:10
                                                RecordType:_strType
                                             FinishedBlock:^void(int errorCode, SportRecordInfoList *sportRecordInfoList)
     {
         __typeof(self) strongSelf = weakSelf;
         
         if (strongSelf == nil) {
             return;
         }
         
         [m_activityIndicatorMain stopAnimating];
         [strongSelf hideCommonProcess];
        [strongSelf stopRefresh];
        
        if (errorCode == 0)
        {
            if ([sportRecordInfoList.record_list.data count] > 0) {
                if (strFirstrPageId.length == 0 && strLastPageId.length == 0)
                {
                    [strongSelf->_arrayHistory removeAllObjects];
                    
                    strongSelf->_strFirstPageId = sportRecordInfoList.page_frist_id;
                    strongSelf->_strLastPageId = sportRecordInfoList.page_last_id;
                }
                else if (strFirstrPageId.length == 0 && strLastPageId.length > 0)
                {
                    strongSelf->_strLastPageId = sportRecordInfoList.page_last_id;
                }
                else if(strFirstrPageId.length > 0 && strLastPageId.length == 0)
                {
                    strongSelf->_strFirstPageId = sportRecordInfoList.page_frist_id;
                }
                
                [strongSelf->_arrayHistory addObjectsFromArray:sportRecordInfoList.record_list.data];
            }
            
            [strongSelf->_tableHistory reloadData];
        }
    }];
}

-(void)stopRefresh {
    [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableHistory];
    if (_bUpHandleLoading) {
        _bUpHandleLoading = NO;
        [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableHistory];
    }
    
    if (_bDownHandleLoading) {
        _bDownHandleLoading = NO;
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.bounds;
    CGSize size = scrollView.contentSize;
    UIEdgeInsets inset = scrollView.contentInset;
    CGFloat y = offset.y + bounds.size.height - inset.bottom;
    CGFloat h = size.height;
    
    NSLog(@"%.2f %.2f %d", y, h, _bDownHandleLoading);
    
    //if((y > (h + 50) && h > bounds.size.height) && _blDownHandleLoading == NO) {
    if((y > (h + 50)) && _bDownHandleLoading == NO)
    {
        [self tableBootomShow:YES];
        _bDownHandleLoading = YES;
        [self reloadDataWithFirstPageID:@"" LastPageId:_strLastPageId];
    }
    
    if (_bUpHandleLoading == NO)
    {
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

@end
