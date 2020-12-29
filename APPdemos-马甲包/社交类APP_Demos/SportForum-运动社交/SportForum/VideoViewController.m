//
//  VideoViewController.m
//  SportForum
//
//  Created by liyuan on 5/31/16.
//  Copyright © 2016 zhengying. All rights reserved.
//

#import "VideoViewController.h"
#import "UIViewController+SportFormu.h"
#import "EGORefreshTableHeaderView.h"
#import "UIImageView+WebCache.h"
#import "CSButton.h"
#import "MWPhotoBrowser.h"
#import "AlertManager.h"
#import "VideoInfoController.h"

@interface VideoViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@end

@implementation VideoViewController
{
    NSMutableArray * _arrayVideos;
    
    UITableView * _tableVideo;
    
    EGORefreshTableHeaderView* _egoRefreshTableHeaderView;
    UIActivityIndicatorView *_tableFooterActivityIndicator;
    UIActivityIndicatorView *m_activityIndicatorMain;
    BOOL _bDownHandleLoading;
    BOOL _bUpHandleLoading;
    long long _lLastPageId;
    
    id _processWin;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _arrayVideos = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)bShowFooterViewController {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _lLastPageId = 0;
    _bUpHandleLoading = NO;
    _bDownHandleLoading = NO;
    
    [self generateCommonViewInParent:self.view Title:@"运动视频" IsNeedBackBtn:NO];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    
    CGRect rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    _tableVideo = [[UITableView alloc] initWithFrame:rect];
    [viewBody addSubview:_tableVideo];
    _tableVideo.dataSource = self;
    _tableVideo.delegate = self;
    _tableVideo.backgroundColor = [UIColor clearColor];
    _tableVideo.separatorColor = [UIColor clearColor];
    
    //Create BottomView For Table
    _tableVideo.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableVideo.frame.size.width, 30.0f)];
    _tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    [_tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_tableFooterActivityIndicator setCenter:[_tableVideo.tableFooterView center]];
    [_tableVideo.tableFooterView addSubview:_tableFooterActivityIndicator];
    
    //Create TopView For Table
    _egoRefreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _tableVideo.frame.size.height, _tableVideo.frame.size.width, _tableVideo.frame.size.height)];
    _egoRefreshTableHeaderView.delegate = (id<EGORefreshTableHeaderDelegate>)self;
    _egoRefreshTableHeaderView.backgroundColor = [UIColor clearColor];
    [_tableVideo addSubview:_egoRefreshTableHeaderView];
    
    //  update the last update date
    [_egoRefreshTableHeaderView refreshLastUpdatedDate];
    
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 20.0f, 20.0f)];
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 48) / 2, (CGRectGetHeight(viewBody.frame) - 48) / 2, 48, 48)];
    m_activityIndicatorMain.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    m_activityIndicatorMain.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    m_activityIndicatorMain.hidden = NO;
    m_activityIndicatorMain.hidesWhenStopped = YES;
    [viewBody addSubview:m_activityIndicatorMain];
    
    [m_activityIndicatorMain startAnimating];
    
    //Load Video List
    [self reloadVideoListData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"运动视频 - VideoViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"运动视频 - VideoViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"运动视频 - VideoViewController"];
    [self hideCommonProcess];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlLeaderBoardVideoList, nil]];
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
    NSLog(@"VideoViewController dealloc called!");
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
    return _arrayVideos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"videoListIdentifier";
    
    VideoSearchInfo * videoItem = _arrayVideos[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: CellTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView * imgPreView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 120, 90)];
        imgPreView.tag = 66;
        [cell.contentView addSubview:imgPreView];
        

        UILabel * lbTimeDuration = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgPreView.frame) - 42, CGRectGetMaxY(imgPreView.frame) - 12, 40, 10)];
        lbTimeDuration.tag = 67;
        lbTimeDuration.backgroundColor = [UIColor blackColor];
        lbTimeDuration.alpha = 0.7;
        lbTimeDuration.textColor = [UIColor whiteColor];
        lbTimeDuration.font = [UIFont boldSystemFontOfSize:10];
        lbTimeDuration.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:lbTimeDuration];
        
        UILabel * lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgPreView.frame) + 5, CGRectGetMinY(imgPreView.frame) + 5, cell.contentView.frame.size.width - (CGRectGetMaxX(imgPreView.frame) + 5) - 10, 40)];
        lbTitle.tag = 68;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = [UIColor blackColor];
        lbTitle.font = [UIFont systemFontOfSize:12];
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.numberOfLines = 3;
        [cell.contentView addSubview:lbTitle];
        
        UILabel * lbAuthor = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgPreView.frame) + 5, CGRectGetMaxY(imgPreView.frame) - 30, cell.contentView.frame.size.width - (CGRectGetMaxX(imgPreView.frame) + 5) - 10, 10)];
        lbAuthor.tag = 69;
        lbAuthor.backgroundColor = [UIColor clearColor];
        lbAuthor.textColor = [UIColor grayColor];
        lbAuthor.font = [UIFont systemFontOfSize:10];
        lbAuthor.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbAuthor];
        
        
        UILabel * lbPublishTime = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgPreView.frame) + 5, CGRectGetMaxY(lbAuthor.frame) + 5, cell.contentView.frame.size.width - (CGRectGetMaxX(imgPreView.frame) + 5) - 10, 10)];
        lbPublishTime.tag = 70;
        lbPublishTime.backgroundColor = [UIColor clearColor];
        lbPublishTime.textColor = [UIColor grayColor];
        lbPublishTime.font = [UIFont systemFontOfSize:10];
        lbPublishTime.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:lbPublishTime];
    }
    
    UIImageView * imgPreView = (UIImageView *)[cell.contentView viewWithTag: 66];
    UILabel * lbTimeDuration = (UILabel *)[cell.contentView viewWithTag: 67];
    UILabel * lbTitle = (UILabel *)[cell.contentView viewWithTag: 68];
    UILabel * lbAuthor = (UILabel *)[cell.contentView viewWithTag: 69];
    UILabel * lbPublishTime = (UILabel *)[cell.contentView viewWithTag: 70];
    
    
    [imgPreView sd_setImageWithURL:[NSURL URLWithString:videoItem.preview_url]
                  placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    
    int nHour = (int)(videoItem.duration / 3600);
    int nMinute = (int)(videoItem.duration / 60);
    int nSecond = (int)(videoItem.duration % 60);
    
    if (nHour > 0) {
        lbTimeDuration.text = [NSString stringWithFormat:@"%02d:%02d:%02d", nHour, nMinute, nSecond];
    } else {
        lbTimeDuration.text = [NSString stringWithFormat:@"%02d:%02d", nMinute, nSecond];
    }
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize lbSize = [lbTimeDuration.text boundingRectWithSize:CGSizeMake(FLT_MAX, CGRectGetHeight(lbTitle.frame))
                                               options:options
                                            attributes:@{NSFontAttributeName:lbTimeDuration.font} context:nil].size;
    lbTimeDuration.frame = CGRectMake(CGRectGetMaxX(imgPreView.frame) - lbSize.width - 2, CGRectGetMinY(lbTimeDuration.frame), lbSize.width, CGRectGetHeight(lbTimeDuration.frame));
    
    lbTitle.text = videoItem.title;
    lbSize = [lbTitle.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(lbTitle.frame), FLT_MAX)
                                                  options:options
                                               attributes:@{NSFontAttributeName:lbTitle.font} context:nil].size;
    lbTitle.frame = CGRectMake(CGRectGetMinX(lbTitle.frame), CGRectGetMinY(lbTitle.frame), CGRectGetWidth(lbTitle.frame), MIN(lbSize.height, 50));
    
    lbAuthor.text = videoItem.author;
    NSDate * dataPub = [NSDate dateWithTimeIntervalSince1970:videoItem.datepublished];
    lbPublishTime.text = [[CommonUtility sharedInstance]compareCurrentTime:dataPub];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoSearchInfo * videoItem = _arrayVideos[indexPath.row];
    
    if (videoItem.videoid.length > 0 ) {
        VideoInfoController *videoInfoController = [[VideoInfoController alloc]init];
        videoInfoController.strVideoID = videoItem.videoid;
        [self.navigationController pushViewController:videoInfoController animated:YES];
    }
}

-(void)reloadVideoListData
{
    [self reloadDataWithLastPageID:_lLastPageId];
}

-(void)reloadDataWithLastPageID:(long long)lLastPageId

{
    __weak __typeof(self) weakSelf = self;
    [[SportForumAPI sharedInstance] videoGetListByPageToken:lLastPageId PageCount:5
                                             FinishedBlock:^void(int errorCode, VideoSearchInfoList *videoSearchInfoList)
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
             if ([videoSearchInfoList.videolist.data count] > 0) {
                 if (lLastPageId == 0)
                 {
                     [strongSelf->_arrayVideos removeAllObjects];
                 }
                 
                 strongSelf->_lLastPageId = videoSearchInfoList.pagetoken;
                 [strongSelf->_arrayVideos addObjectsFromArray:videoSearchInfoList.videolist.data];
             }
             
             [strongSelf->_tableVideo reloadData];
         }
     }];
}

-(void)stopRefresh {
    [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableVideo];
    if (_bUpHandleLoading) {
        _bUpHandleLoading = NO;
        [_egoRefreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_tableVideo];
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
        [self reloadDataWithLastPageID:_lLastPageId];
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
    _lLastPageId = 0;
    [self performSelector:@selector(reloadVideoListData) withObject:nil afterDelay:0.2];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    
    return _bUpHandleLoading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    
    return [NSDate date]; // should return date data source was last changed
}

@end
