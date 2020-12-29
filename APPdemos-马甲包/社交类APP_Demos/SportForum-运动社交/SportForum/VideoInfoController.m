//
//  VideoInfoController.m
//  SportForum
//
//  Created by liyuan on 6/2/16.
//  Copyright © 2016 zhengying. All rights reserved.
//

#import "VideoInfoController.h"
#import "UIViewController+SportFormu.h"
#import "UIImageView+WebCache.h"
#import "CSButton.h"
#import "AlertManager.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoInfoController ()<UIWebViewDelegate, UIAlertViewDelegate>

@end

@implementation VideoInfoController
{
    UIView *_viewBody;
    UIScrollView *m_scrollView;
    UIWebView *m_descWebView;
    VideoInfo *m_videoInfo;
    UIAlertView* _alertView;
    id m_processWindow;
    UIActivityIndicatorView *m_activityIndicatorMain;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"运动视频" IsNeedBackBtn:YES];
    
    _viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    _viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = _viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    _viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    _viewBody.layer.mask = maskLayer;
    
    //Create Share View
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    UIImageView *imgViewNew = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [imgViewNew setImage:[UIImage imageNamed:@"nav-share-btn"]];
    [self.view addSubview:imgViewNew];
    
    CSButton *btnShare = [CSButton buttonWithType:UIButtonTypeCustom];
    btnShare.frame = CGRectMake(CGRectGetMinX(imgViewNew.frame) - 5, CGRectGetMinY(imgViewNew.frame) - 5, 45, 45);
    btnShare.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnShare];
    [self.view bringSubviewToFront:btnShare];
    
    __weak __typeof(self) weakSelf = self;
    
    btnShare.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf actionShareToAttention];
    };

    m_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_viewBody.frame), CGRectGetHeight(_viewBody.frame))];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.scrollEnabled = YES;
    [_viewBody addSubview:m_scrollView];
    
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 20.0f, 20.0f)];
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((CGRectGetWidth(m_scrollView.frame) - 48) / 2, (CGRectGetHeight(m_scrollView.frame) - 48) / 2, 48, 48)];
    m_activityIndicatorMain.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    m_activityIndicatorMain.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    m_activityIndicatorMain.hidden = NO;
    m_activityIndicatorMain.hidesWhenStopped = YES;
    [m_scrollView addSubview:m_activityIndicatorMain];
    
    [m_activityIndicatorMain startAnimating];
    [self loadVideoInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"VideoInfoController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"VideoInfoController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self hidenCommonProgress];
    [MobClick endLogPageView:@"VideoInfoController"];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlLeaderBoardVideoInfo, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"VideoInfoController dealloc called!");
}

-(void)actionShareToAttention {
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
    

    NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"ShareAttentionInfo"];
    NSMutableDictionary * shareDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if (shareDict == nil) {
        shareDict = [[NSMutableDictionary alloc]init];
    }
    
    if ([[shareDict objectForKey:_strVideoID]boolValue]) {
        [JDStatusBarNotification showWithStatus:@"亲，该视频您已经分享到关注动态了，不可以重复分享哦！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleDefault];
    }
    else
    {
        _alertView = [[UIAlertView alloc] initWithTitle:@"分享" message:@"是否分享到关注圈？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        _alertView.tag = 10;
        [_alertView show];
    }
}

-(void)dismissAlertView {
    if (_alertView) {
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView.delegate = nil;
        _alertView = nil;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex == 1)
        {
            [self dismissAlertView];
            [self shareToAttention];
        }
    }
}

-(void)showCommonProgress{
    m_processWindow = [AlertManager showCommonProgress];
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:m_processWindow];
}

-(void)shareToAttention {
    NSMutableArray* articleSegments = [[NSMutableArray alloc]init];
    
    ArticleSegmentObject* segobj = [ArticleSegmentObject new];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = @"精彩视频分享，大家过来看看呗~~";
    [articleSegments addObject:segobj];

    segobj = [ArticleSegmentObject new];
    segobj.seg_type = @"VIDEO";
    segobj.seg_content = [NSString stringWithFormat:@"%@###%@", m_videoInfo.preview_url, m_videoInfo.download_url];
    [articleSegments addObject:segobj];
    

    [self showCommonProgress];
    
    [[SportForumAPI sharedInstance]articleNewByParArticleId:nil
                                             ArticleSegment:articleSegments
                                                 ArticleTag:[NSArray arrayWithObject:[CommonFunction ConvertArticleTagTypeToString:e_article_log]] Type:@"" AtNameList:nil
                                              FinishedBlock:^(int errorCode, NSString* strDescErr, ExpEffect* expEffect) {
                                                  if (errorCode == RSA_ERROR_NONE) {
                                                      UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                                                      
                                                      [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                                                       {
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", @(YES), @"UpdateArticle",nil]];
                                                       }];
                                                      
                                                      NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"ShareAttentionInfo"];
                                                      NSMutableDictionary * shareDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                                                      
                                                      if (shareDict == nil) {
                                                          shareDict = [[NSMutableDictionary alloc]init];
                                                      }
                                                      
                                                      [shareDict setObject:@(YES) forKey:_strVideoID];
                                                      [[ApplicationContext sharedInstance] saveObject:shareDict byKey:@"ShareAttentionInfo"];
                                                          
                                                      [self hidenCommonProgress];
                                                  } else {
                                                      [self hidenCommonProgress];
                                                      [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                  }
                                              }];
}

-(void)loadVideoInfo
{
    [[SportForumAPI sharedInstance]videoGetInfoByVideoID:_strVideoID FinishedBlock:^(int errorCode, VideoInfo *videoInfo) {
        [m_activityIndicatorMain stopAnimating];
        
        if (errorCode == 0) {
            m_videoInfo = videoInfo;
            [self setVideoDetail];
        }
    }];
}

-(void)onClickVideoPreView:(NSString*)strUrl
{
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
    [moviePlayerViewController.view setTransform:transform];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}

-(void)setVideoDetail
{
    UIImageView *imgViewPreView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(m_scrollView.frame), 180)];
    [imgViewPreView sd_setImageWithURL:[NSURL URLWithString:m_videoInfo.preview_url]
                  placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    [m_scrollView addSubview:imgViewPreView];
    
    CSButton *btnVideo = [CSButton buttonWithType:UIButtonTypeCustom];
    btnVideo.frame = imgViewPreView.frame;
    [btnVideo setImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
    [m_scrollView addSubview:btnVideo];
    
    __weak __typeof(self) weakSelf = self;
    
    btnVideo.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf onClickVideoPreView:strongSelf->m_videoInfo.download_url];
    };

    
    UILabel *lbVideoTitle = [[UILabel alloc]init];
    lbVideoTitle.backgroundColor = [UIColor clearColor];
    lbVideoTitle.text = m_videoInfo.title;
    lbVideoTitle.textColor = [UIColor blackColor];
    lbVideoTitle.font = [UIFont systemFontOfSize:16];
    lbVideoTitle.textAlignment = NSTextAlignmentLeft;
    lbVideoTitle.numberOfLines = 0;
    [m_scrollView addSubview:lbVideoTitle];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize lbSize = [lbVideoTitle.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(m_scrollView.frame) - 10, FLT_MAX)
                                                      options:options
                                                   attributes:@{NSFontAttributeName:lbVideoTitle.font} context:nil].size;
    lbVideoTitle.frame = CGRectMake(5, CGRectGetMaxY(imgViewPreView.frame) + 10, CGRectGetWidth(m_scrollView.frame) - 10, lbSize.height);

    UILabel *lbVideoAuthor = [[UILabel alloc]init];
    lbVideoAuthor.backgroundColor = [UIColor clearColor];
    lbVideoAuthor.text = [NSString stringWithFormat:@"作者：%@", m_videoInfo.author];;
    lbVideoAuthor.textColor = [UIColor darkGrayColor];
    lbVideoAuthor.font = [UIFont systemFontOfSize:13];
    lbVideoAuthor.textAlignment = NSTextAlignmentLeft;
    lbVideoAuthor.frame = CGRectMake(5, CGRectGetMaxY(lbVideoTitle.frame) + 10, CGRectGetWidth(m_scrollView.frame) - 10, 15);
    [m_scrollView addSubview:lbVideoAuthor];
    
    UILabel *lbVideoView = [[UILabel alloc]init];
    lbVideoView.backgroundColor = [UIColor clearColor];
    lbVideoView.text = [NSString stringWithFormat:@"%d次观看", m_videoInfo.viewcount];
    lbVideoView.textColor = [UIColor darkGrayColor];
    lbVideoView.font = [UIFont systemFontOfSize:13];
    lbVideoView.textAlignment = NSTextAlignmentLeft;
    lbVideoView.frame = CGRectMake(5, CGRectGetMaxY(lbVideoAuthor.frame) + 10, CGRectGetWidth(m_scrollView.frame) - 10, 15);
    [m_scrollView addSubview:lbVideoView];
    
    UILabel *lbVideoPublish = [[UILabel alloc]init];
    lbVideoPublish.backgroundColor = [UIColor clearColor];
    lbVideoPublish.textColor = [UIColor grayColor];
    lbVideoPublish.font = [UIFont systemFontOfSize:12];
    lbVideoPublish.textAlignment = NSTextAlignmentLeft;
    lbVideoPublish.frame = CGRectMake(5, CGRectGetMaxY(lbVideoView.frame) + 10, CGRectGetWidth(m_scrollView.frame) - 10, 15);
    [m_scrollView addSubview:lbVideoPublish];
    
    lbVideoPublish.text = [NSString stringWithFormat:@"于%@发布", [[CommonUtility sharedInstance]convertBirthdayToString:m_videoInfo.datepublished]];

    m_descWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbVideoPublish.frame), CGRectGetWidth(m_scrollView.frame), 1)];
    m_descWebView.scrollView.scrollEnabled = NO;
    [m_descWebView setScalesPageToFit:NO];
    m_descWebView.backgroundColor = APP_MAIN_BG_COLOR;
    m_descWebView.opaque = NO;
    m_descWebView.delegate = self;
    [m_scrollView addSubview:m_descWebView];
    
    [m_descWebView loadHTMLString:[NSString stringWithFormat:@"<div style='text-align:left; font-size:%@;font-family:Helvetica;color:#000000;'>%@",@"14px",m_videoInfo.desc] baseURL:nil];
    //[m_descWebView loadHTMLString:m_videoInfo.desc baseURL:nil];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSURL *requestURL = [request URL];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL:requestURL];
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    CGRect frame = aWebView.frame;
    frame.size.height = 1;
    aWebView.frame = frame;
    CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    aWebView.frame = frame;

    UIImageView *imgViewThumbUp = [[UIImageView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(aWebView.frame) + 10, 32, 32)];
    [imgViewThumbUp setImage:[UIImage imageNamed:@"thumbs_up"]];
    [m_scrollView addSubview:imgViewThumbUp];
    
    UILabel *lbVideoThumbUp = [[UILabel alloc]init];
    lbVideoThumbUp.backgroundColor = [UIColor clearColor];
    lbVideoThumbUp.text = [NSString stringWithFormat:@"%d", m_videoInfo.likecount];
    lbVideoThumbUp.textColor = [UIColor darkGrayColor];
    lbVideoThumbUp.font = [UIFont systemFontOfSize:13];
    lbVideoThumbUp.textAlignment = NSTextAlignmentLeft;
    [m_scrollView addSubview:lbVideoThumbUp];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize lbSize = [lbVideoThumbUp.text boundingRectWithSize:CGSizeMake(FLT_MAX, 10)
                                               options:options
                                            attributes:@{NSFontAttributeName:lbVideoThumbUp.font} context:nil].size;
    lbVideoThumbUp.frame = CGRectMake(CGRectGetMaxX(imgViewThumbUp.frame) + 5, CGRectGetMinY(imgViewThumbUp.frame) + 10, lbSize.width, 10);
    
    UIImageView *imgViewThumbDown = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbVideoThumbUp.frame) + 15, CGRectGetMaxY(aWebView.frame) + 10, 32, 32)];
    [imgViewThumbDown setImage:[UIImage imageNamed:@"thumbs_down"]];
    [m_scrollView addSubview:imgViewThumbDown];
    
    UILabel *lbVideoThumbDown = [[UILabel alloc]init];
    lbVideoThumbDown.backgroundColor = [UIColor clearColor];
    lbVideoThumbDown.text = [NSString stringWithFormat:@"%d", m_videoInfo.dislikecount];
    lbVideoThumbDown.textColor = [UIColor darkGrayColor];
    lbVideoThumbDown.font = [UIFont systemFontOfSize:13];
    lbVideoThumbDown.textAlignment = NSTextAlignmentLeft;
    [m_scrollView addSubview:lbVideoThumbDown];
    
    lbSize = [lbVideoThumbDown.text boundingRectWithSize:CGSizeMake(FLT_MAX, 10)
                                                 options:options
                                              attributes:@{NSFontAttributeName:lbVideoThumbDown.font} context:nil].size;
    lbVideoThumbDown.frame = CGRectMake(CGRectGetMaxX(imgViewThumbDown.frame) + 5, CGRectGetMinY(imgViewThumbDown.frame) + 10, lbSize.width, 10);
    m_scrollView.contentSize = CGSizeMake(m_scrollView.contentSize.width, CGRectGetMaxY(imgViewThumbDown.frame) + 20);
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
