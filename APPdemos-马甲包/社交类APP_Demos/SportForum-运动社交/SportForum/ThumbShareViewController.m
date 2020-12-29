//
//  ThumbShareViewController.m
//  SportForum
//
//  Created by liyuan on 7/14/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "ThumbShareViewController.h"
#import "UIViewController+SportFormu.h"
#import "UIScrollView+TwitterCover.h"
#import "UIImageView+WebCache.h"
#import "AlertManager.h"
#import "MWPhotoBrowser.h"
#import "TFHpple.h"
#import "AccountPreViewController.h"
#import "RegexKitLite.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ThumbShareViewController ()<MWPhotoBrowserDelegate, UIWebViewDelegate>

@end

@implementation ThumbShareViewController
{
    UIScrollView *_scrollView;
    
    UIView *_viewPhotoBoard;
    UIImageView *_imgPrivatePicture[5];
    CSButton *_btnPrivate[5];
    
    UIView *_viewRecord;
    UIWebView *_webView;
    CSButton *_btnThumb;

    UserInfo *_userInfoSender;
    ArticlesObject *_articlesObject;
    
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _photos;
    
    NSMutableArray * _imgUrlArrayWeb;
    
    BOOL _isVideo;
    BOOL _isLoadingFinished;
    NSString *_strHtmlContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _photos = [[NSMutableArray alloc]init];
    _imgUrlArray = [[NSMutableArray alloc]init];
    
    __weak typeof (self) thisPoint = self;
    
    [self generateCommonViewInParent:self.view Title:@"Ta发表了1篇文章，想让你赞一下" IsNeedBackBtn:YES ActionBlock:^(void){
        typeof(self) thisStrongPoint = thisPoint;
        
        if(thisStrongPoint->_viewPhotoBoard.alpha != 0)
        {
            [[SportForumAPI sharedInstance]tasksSharedByType:e_accept_literature SenderId:thisStrongPoint->_strSendId ArticleId:thisStrongPoint->_strArticleId AddDesc:@"" ImgUrl:@"" RunBeginTime:0 IsAccept:NO FinishedBlock:^(int errorCode, ExpEffect* expEffect)
             {
                 
             }];
        }

        [thisStrongPoint.navigationController popViewControllerAnimated:YES];
    }];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    [viewBody addSubview:_scrollView];
    _scrollView.scrollEnabled = YES;
    
    [self loadThumbShareData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ThumbShareViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"ThumbShareViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ThumbShareViewController"];
}

-(void)dealloc
{
    NSLog(@"ThumbShareViewController dealloc called!");
    [_scrollView removeTwitterCoverView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Generate DetailView

-(NSString*)reGenerateLocPosiStr
{
    float dMyLon = [[ApplicationContext sharedInstance] accountInfo].longitude;
    float dMyLat = [[ApplicationContext sharedInstance] accountInfo].latitude;
    float dOtherLon =  _userInfoSender.longitude;
    float dOtherLat = _userInfoSender.latitude;
    double dDistance = [[CommonUtility sharedInstance] getDistanceBySelfLon:dMyLon SelfLantitude:dMyLat OtherLon:dOtherLon OtherLat:dOtherLat];
    
    NSString * strDate = @"";
    
    if (_userInfoSender.last_login_time > 0) {
        NSDate * dateLastLogin = [NSDate dateWithTimeIntervalSince1970:_userInfoSender.last_login_time];
        NSDate * today = [NSDate date];
        long long llInterval = [today timeIntervalSinceDate:dateLastLogin];
        long long llMinute = llInterval / 60;
        long long llHour = llInterval / 3600;
        
        if (llMinute == 0) {
            strDate = @"刚刚登录";
        }
        
        if(llMinute > 0)
        {
            strDate = [NSString stringWithFormat:@"%lld分钟前", llMinute];
        }
        
        if(llMinute >= 60)
        {
            strDate = [NSString stringWithFormat:@"%lld小时前", llHour];
        }
        
        if(llHour >= 24)
        {
            strDate = [NSString stringWithFormat:@"%lld天前", llHour / 24];
        }
    }
    
    if (dDistance < 1000 && dDistance >= 0) {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@,距离%.f米", strDate, dDistance];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.f米", dDistance];
        }
    }
    else if(dDistance >= 1000)
    {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@,距离%.f公里", strDate, dDistance / 1000];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.f公里", dDistance / 1000];
        }
    }
    
    return strDate;
}

-(void)generateDetailView
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    
    //Generate Photo Board Control
    _viewPhotoBoard = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), 75)];
    _viewPhotoBoard.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_viewPhotoBoard];
    
    CGFloat fStartYPoint = 10;
    NSUInteger nImageCount = _userInfoSender.user_images.data.count;
    
    if (nImageCount > 0) {
        [_scrollView addTwitterCoverWithImage:[UIImage imageNamed:@"cover-5.jpg"]];
        [_scrollView sendSubviewToBack:_scrollView.twitterCoverView];

        [_imgUrlArray removeAllObjects];
        [_imgUrlArray addObjectsFromArray:_userInfoSender.user_images.data];
        
        for(int i = 0; i < MIN(nImageCount, 5); i++)
        {
            int nRectWidth = 52;
            _imgPrivatePicture[i] = [[UIImageView alloc] initWithFrame:CGRectMake(5 + (nRectWidth + 10) * i, 12, nRectWidth, nRectWidth)];
            _imgPrivatePicture[i].contentMode = UIViewContentModeScaleAspectFill;
            _imgPrivatePicture[i].layer.cornerRadius = 5.0;
            _imgPrivatePicture[i].layer.masksToBounds = YES;
            
            [_viewPhotoBoard addSubview:_imgPrivatePicture[i]];
            [_viewPhotoBoard bringSubviewToFront:_imgPrivatePicture[i]];
            
            [_imgPrivatePicture[i] sd_setImageWithURL:[NSURL URLWithString:_userInfoSender.user_images.data[i]]
                                     placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
            
            _btnPrivate[i] = [CSButton buttonWithType:UIButtonTypeCustom];
            _btnPrivate[i].frame = _imgPrivatePicture[i].frame;
            _btnPrivate[i].backgroundColor = [UIColor clearColor];
            
            __weak __typeof(self) weakSelf = self;
            
            _btnPrivate[i].actionBlock = ^void()
            {
                __typeof(self) strongSelf = weakSelf;
                [strongSelf onClickImageViewByIndex:i IsPhotoBoard:YES];
            };
            
            [_viewPhotoBoard addSubview:_btnPrivate[i]];
            [_viewPhotoBoard bringSubviewToFront:_btnPrivate[i]];
        }
        
        fStartYPoint = CGRectGetHeight(_scrollView.twitterCoverView.frame) + 10;
    }

    UIImageView *imgViewProfile = [[UIImageView alloc]initWithFrame:CGRectMake(10, fStartYPoint, 50, 50)];
    [imgViewProfile sd_setImageWithURL:[NSURL URLWithString:_userInfoSender.profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
    [_viewPhotoBoard addSubview:imgViewProfile];
    
    UIImageView *sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70, CGRectGetMinY(imgViewProfile.frame), 45, 20)];
    sexTypeImageView.backgroundColor = [UIColor clearColor];
    [sexTypeImageView setImage:[UIImage imageNamed:([CommonFunction ConvertStringToSexType:_userInfoSender.sex_type] == e_sex_male ? @"gender-male" : @"gender-female")]];
    [_viewPhotoBoard addSubview:sexTypeImageView];
    
    UILabel *lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, CGRectGetMinY(imgViewProfile.frame) + 2, 20, 15)];
    lbAge.backgroundColor = [UIColor clearColor];
    lbAge.textColor = [UIColor whiteColor];
    lbAge.font = [UIFont systemFontOfSize:12];
    lbAge.textAlignment = NSTextAlignmentRight;
    lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:_userInfoSender.birthday];
    [_viewPhotoBoard addSubview:lbAge];
    
    UIImageView * imgLoc = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgLoc.image = [UIImage imageNamed:@"location-icon"];
    imgLoc.hidden = YES;
    [_viewPhotoBoard addSubview:imgLoc];
    
    UILabel *lbLoc = [[UILabel alloc] initWithFrame:CGRectZero];
    lbLoc.backgroundColor = [UIColor clearColor];
    lbLoc.font = [UIFont boldSystemFontOfSize:14];
    lbLoc.textColor = [UIColor darkGrayColor];
    lbLoc.hidden = YES;
    [_viewPhotoBoard addSubview:lbLoc];
    
    UILabel *lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(sexTypeImageView.frame) + 5, CGRectGetWidth(_viewPhotoBoard.frame) - 90, 25)];
    lbDesc.backgroundColor = [UIColor clearColor];
    lbDesc.font = [UIFont boldSystemFontOfSize:14];
    lbDesc.textColor = [UIColor darkGrayColor];
    lbDesc.textAlignment = NSTextAlignmentLeft;
    [_viewPhotoBoard addSubview:lbDesc];
    
    float dMyLon = [[ApplicationContext sharedInstance] accountInfo].longitude;
    float dMyLat = [[ApplicationContext sharedInstance] accountInfo].latitude;
    float dOtherLon =  _userInfoSender.longitude;
    float dOtherLat = _userInfoSender.latitude;
    double dDistance = [[CommonUtility sharedInstance] getDistanceBySelfLon:dMyLon SelfLantitude:dMyLat OtherLon:dOtherLon OtherLat:dOtherLat];
    
    NSString * strDate = @"";
    
    if (_userInfoSender.last_login_time > 0) {
        NSDate * dateLastLogin = [NSDate dateWithTimeIntervalSince1970:_userInfoSender.last_login_time];
        NSDate * today = [NSDate date];
        long long llInterval = [today timeIntervalSinceDate:dateLastLogin];
        long long llMinute = llInterval / 60;
        long long llHour = llInterval / 3600;
        
        if (llMinute == 0) {
            strDate = @"刚刚登录";
        }
        
        if(llMinute > 0)
        {
            strDate = [NSString stringWithFormat:@"%lld分钟前登录", llMinute];
        }
        
        if(llMinute >= 60)
        {
            strDate = [NSString stringWithFormat:@"%lld小时前登录", llHour];
        }
        
        if(llHour >= 24)
        {
            strDate = [NSString stringWithFormat:@"%lld天前登录", llHour / 24];
        }
    }
    
    if (dDistance < 1000 && dDistance >= 0) {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@, 距离%.2f米", strDate, dDistance];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.2f米", dDistance];
        }
    }
    else if(dDistance >= 1000)
    {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@, 距离%.2f公里", strDate, dDistance / 1000];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.2f公里", dDistance / 1000];
        }
    }
    
    if (strDate.length > 0) {
        imgLoc.image = [UIImage imageNamed:@"location-icon"];
        imgLoc.hidden = NO;
        
        lbLoc.hidden = NO;
        lbLoc.text = strDate;
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize lbSize = [lbLoc.text boundingRectWithSize:CGSizeMake(FLT_MAX, 20)
                                                 options:options
                                              attributes:@{NSFontAttributeName:lbLoc.font} context:nil].size;
        
        if (CGRectGetWidth(_viewPhotoBoard.frame) - lbSize.width - 10 - 20 - 5 < CGRectGetMaxX(sexTypeImageView.frame)) {
            strDate = [self reGenerateLocPosiStr];
            lbLoc.text = strDate;
            lbSize = [lbLoc.text boundingRectWithSize:CGSizeMake(FLT_MAX, 20)
                                              options:options
                                           attributes:@{NSFontAttributeName:lbLoc.font} context:nil].size;
        }
        
        lbLoc.frame = CGRectMake(CGRectGetWidth(_viewPhotoBoard.frame) - lbSize.width - 10, CGRectGetMinY(sexTypeImageView.frame), lbSize.width, 20);
        imgLoc.frame = CGRectMake(CGRectGetMinX(lbLoc.frame) - 20, CGRectGetMinY(sexTypeImageView.frame), 17, 17);
    }
    
    if (_articlesObject != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_articlesObject.time];
        NSString *strDate = [dateFormatter stringFromDate:date];
        lbDesc.text = [NSString stringWithFormat:@"%@发布博文", strDate];
    }
    
    _viewPhotoBoard.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(lbDesc.frame) + 10);
    
    //Generate WebView Control
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewPhotoBoard.frame), CGRectGetWidth(_scrollView.frame), 1)];
    _webView.scrollView.scrollEnabled = NO;
    [_webView setScalesPageToFit:NO];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    _webView.opaque = NO;
    [_scrollView addSubview:_webView];
    
    //Load Html Content
    _imgUrlArrayWeb = [[NSMutableArray alloc]init];
    _isLoadingFinished = NO;
    _strHtmlContent = [self convertSegmentsToHtml];
    [self getAllUrlImgUrlsFromHtml];
    [_webView loadHTMLString:_strHtmlContent baseURL:nil];
    
    //Record View Control Create
    if ([_articlesObject.type isEqualToString:@"record"]) {
        _viewRecord = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_webView.frame), CGRectGetWidth(_scrollView.frame), 50)];
        _viewRecord.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
        [_scrollView addSubview:_viewRecord];
        
        [self generateRecordView];
    }
    
    //Thumb Control Create
    _btnThumb = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnThumb.backgroundColor = [UIColor clearColor];
    [_btnThumb setImage:[UIImage imageNamed:@"home-praise-accept"] forState:UIControlStateNormal];
    [_btnThumb setTitle:@"赞" forState:UIControlStateNormal];
    [_btnThumb setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _btnThumb.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) / 2 - 25, CGRectGetHeight(_scrollView.frame) - 85, 50, 80);
    _btnThumb.titleLabel.font = [UIFont boldSystemFontOfSize:14];//title字体大小
    _btnThumb.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnThumb setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 30, 0)];
    [_btnThumb setTitleEdgeInsets:UIEdgeInsetsMake(60, -_btnThumb.titleLabel.bounds.size.width - 65, 0, 0)];
    [_scrollView addSubview:_btnThumb];
    
    __weak __typeof(self) weakSelf = self;
    
    _btnThumb.actionBlock = ^()
    {
        __typeof(self) strongSelf = weakSelf;
        //[strongSelf updateControlAfterReceived];
        //return;
        
        [[CommonUtility sharedInstance]playAudioFromName:@"hot_like_large.mp3"];
        
        id processWin = [AlertManager showCommonProgressInView:viewBody];
        
        [[SportForumAPI sharedInstance]tasksSharedByType:e_accept_literature SenderId:strongSelf->_strSendId ArticleId:strongSelf->_strArticleId AddDesc:@"" ImgUrl:@"" RunBeginTime:0 IsAccept:YES FinishedBlock:^(int errorCode, ExpEffect* expEffect)
         {
             [AlertManager dissmiss:processWin];
             
             if (errorCode == 0) {
                 [strongSelf updateControlAfterReceived];
                 
                 UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                 
                 [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                  {
                      [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                  }];
             }
             else
             {
                 [JDStatusBarNotification showWithStatus:@"网络不给力哦~" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
             }
         }];
    };
}

-(void)generateRecordView
{
    UILabel *lbSportTitle = [[UILabel alloc]init];
    lbSportTitle.backgroundColor = [UIColor clearColor];
    lbSportTitle.textColor = [UIColor blackColor];
    lbSportTitle.font = [UIFont boldSystemFontOfSize:16];
    lbSportTitle.textAlignment = NSTextAlignmentLeft;
    lbSportTitle.frame = CGRectMake(5, 10, 290, 30);
    lbSportTitle.text = @"运动数据：";
    [_viewRecord addSubview:lbSportTitle];
    
    UILabel *lbSportDistance = [[UILabel alloc]init];
    lbSportDistance.backgroundColor = [UIColor clearColor];
    lbSportDistance.textColor = [UIColor blackColor];
    lbSportDistance.font = [UIFont boldSystemFontOfSize:14];
    lbSportDistance.textAlignment = NSTextAlignmentLeft;
    lbSportDistance.frame = CGRectMake(5, CGRectGetMaxY(lbSportTitle.frame), 130, 30);
    lbSportDistance.text = [NSString stringWithFormat:@"距离：%.2f km", _articlesObject.record.distance / 1000.00];
    [_viewRecord addSubview:lbSportDistance];
    
    UILabel *lbSportDuration = [[UILabel alloc]init];
    lbSportDuration.backgroundColor = [UIColor clearColor];
    lbSportDuration.textColor = [UIColor blackColor];
    lbSportDuration.font = [UIFont boldSystemFontOfSize:14];
    lbSportDuration.textAlignment = NSTextAlignmentRight;
    lbSportDuration.frame = CGRectMake(CGRectGetMaxX(lbSportDistance.frame), CGRectGetMinY(lbSportDistance.frame), 310 - 5 - CGRectGetMaxX(lbSportDistance.frame), 30);
    lbSportDuration.text = [NSString stringWithFormat:@"持续时间：%ld分钟", _articlesObject.record.duration / 60];
    [_viewRecord addSubview:lbSportDuration];
    
    UIImageView *imgViewDate = [[UIImageView alloc]init];
    [imgViewDate setImage:[UIImage imageNamed:@"data-record-startTime"]];
    imgViewDate.frame = CGRectMake(CGRectGetMinX(lbSportDistance.frame), CGRectGetMaxY(lbSportDistance.frame) + 5, 20, 20);
    [_viewRecord addSubview:imgViewDate];
    
    UILabel *lbSportDate = [[UILabel alloc]init];
    lbSportDate.backgroundColor = [UIColor clearColor];
    lbSportDate.textColor = [UIColor darkGrayColor];
    lbSportDate.font = [UIFont boldSystemFontOfSize:14];
    lbSportDate.textAlignment = NSTextAlignmentLeft;
    lbSportDate.frame = CGRectMake(CGRectGetMaxX(imgViewDate.frame) + 5, CGRectGetMinY(imgViewDate.frame), 140, 20);
    [_viewRecord addSubview:lbSportDate];
    
    UIImageView *imgViewSpeedSet = [[UIImageView alloc]init];
    [imgViewSpeedSet setImage:[UIImage imageNamed:@"data-record-pace"]];
    imgViewSpeedSet.frame = CGRectMake(CGRectGetMaxX(lbSportDate.frame) + 10, CGRectGetMinY(imgViewDate.frame), 20, 20);
    [_viewRecord addSubview:imgViewSpeedSet];
    
    UILabel *lbSportSpeedSet = [[UILabel alloc]init];
    lbSportSpeedSet.backgroundColor = [UIColor clearColor];
    lbSportSpeedSet.textColor = [UIColor darkGrayColor];
    lbSportSpeedSet.font = [UIFont boldSystemFontOfSize:12];
    lbSportSpeedSet.textAlignment = NSTextAlignmentLeft;
    lbSportSpeedSet.frame = CGRectMake(CGRectGetMaxX(imgViewSpeedSet.frame) + 5, CGRectGetMinY(imgViewSpeedSet.frame), 310 - 5 - CGRectGetMaxX(imgViewSpeedSet.frame) - 5, 20);
    [_viewRecord addSubview:lbSportSpeedSet];
    
    NSInteger nSpeedSet = _articlesObject.record.duration / (_articlesObject.record.distance / 1000.00);
    lbSportSpeedSet.text = [NSString stringWithFormat:@"%ld' %ld'' km", nSpeedSet / 60,   nSpeedSet % 60];
    
    UIImageView *imgViewSpeed = [[UIImageView alloc]init];
    [imgViewSpeed setImage:[UIImage imageNamed:@"data-record-speed"]];
    imgViewSpeed.frame = CGRectMake(CGRectGetMinX(lbSportDistance.frame), CGRectGetMaxY(lbSportDate.frame) + 5, 20, 20);
    [_viewRecord addSubview:imgViewSpeed];
    
    UILabel *lbSportSpeed = [[UILabel alloc]init];
    lbSportSpeed.backgroundColor = [UIColor clearColor];
    lbSportSpeed.textColor = [UIColor darkGrayColor];
    lbSportSpeed.font = [UIFont boldSystemFontOfSize:14];
    lbSportSpeed.textAlignment = NSTextAlignmentLeft;
    lbSportSpeed.frame = CGRectMake(CGRectGetMaxX(imgViewSpeed.frame) + 5, CGRectGetMinY(imgViewSpeed.frame), 140, 20);
    [_viewRecord addSubview:lbSportSpeed];
    
    UIImageView *imgViewCal = [[UIImageView alloc]init];
    [imgViewCal setImage:[UIImage imageNamed:@"data-record-cal"]];
    imgViewCal.frame = CGRectMake(CGRectGetMaxX(lbSportSpeed.frame) + 10, CGRectGetMaxY(imgViewDate.frame) + 5, 20, 20);
    [_viewRecord addSubview:imgViewCal];
    
    UILabel *lbSportCal = [[UILabel alloc]init];
    lbSportCal.backgroundColor = [UIColor clearColor];
    lbSportCal.textColor = [UIColor darkGrayColor];
    lbSportCal.font = [UIFont boldSystemFontOfSize:14];
    lbSportCal.textAlignment = NSTextAlignmentLeft;
    lbSportCal.frame = CGRectMake(CGRectGetMaxX(imgViewCal.frame) + 5, CGRectGetMinY(imgViewCal.frame), 310 - 5 - CGRectGetMaxX(imgViewCal.frame) - 5, 20);
    [_viewRecord addSubview:lbSportCal];
    
    UIImageView *imgViewHeatRate = [[UIImageView alloc]init];
    [imgViewHeatRate setImage:[UIImage imageNamed:@"data-record-heartRate"]];
    imgViewHeatRate.frame = CGRectMake(CGRectGetMinX(lbSportDistance.frame), CGRectGetMaxY(imgViewSpeed.frame) + 5, 20, 20);
    [_viewRecord addSubview:imgViewHeatRate];
    
    UILabel *lbSportHeatRate = [[UILabel alloc]init];
    lbSportHeatRate.backgroundColor = [UIColor clearColor];
    lbSportHeatRate.textColor = [UIColor darkGrayColor];
    lbSportHeatRate.font = [UIFont boldSystemFontOfSize:14];
    lbSportHeatRate.textAlignment = NSTextAlignmentLeft;
    lbSportHeatRate.frame = CGRectMake(CGRectGetMaxX(imgViewHeatRate.frame) + 5, CGRectGetMinY(imgViewHeatRate.frame), 310 - 5 - CGRectGetMaxX(imgViewHeatRate.frame) - 5, 20);
    [_viewRecord addSubview:lbSportHeatRate];
    
    UILabel *lbSportSource = [[UILabel alloc]init];
    lbSportSource.backgroundColor = [UIColor clearColor];
    lbSportSource.textColor = [UIColor darkGrayColor];
    lbSportSource.font = [UIFont boldSystemFontOfSize:14];
    lbSportSource.textAlignment = NSTextAlignmentLeft;
    lbSportSource.frame = CGRectMake(CGRectGetMinX(imgViewHeatRate.frame), CGRectGetMaxY(imgViewHeatRate.frame) + 5, 310 - 5 - CGRectGetMinX(imgViewHeatRate.frame), 20);
    [_viewRecord addSubview:lbSportSource];
    
    NSDate * beginDay = [NSDate dateWithTimeIntervalSince1970:_articlesObject.record.begin_time];
    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginDay];
    lbSportDate.text = [NSString stringWithFormat:@"%02ld/%02ld/%04ld %.2ld:%.2ld", [comps month], [comps day], [comps year], [comps hour], [comps minute]];
    lbSportSpeed.text = [NSString stringWithFormat:@"%.2f km/h", (_articlesObject.record.distance / 1000.00) / (_articlesObject.record.duration / 3600.00)];
    lbSportCal.text = [NSString stringWithFormat:@"%.0f cal", _articlesObject.record.weight * _articlesObject.record.distance / 800.0]; //跑步热量（kcal）＝体重（kg）×运动时间（小时）×指数K(指数K＝30÷速度（分钟/400米)
    
    CGRect rectPosition = lbSportCal.frame;
    imgViewHeatRate.hidden = YES;
    lbSportHeatRate.hidden = YES;
    
    if (_articlesObject.record.heart_rate > 0) {
        imgViewHeatRate.hidden = NO;
        lbSportHeatRate.hidden = NO;
        lbSportHeatRate.text = [NSString stringWithFormat:@"%ld 次/分", _articlesObject.record.heart_rate];
        rectPosition = imgViewHeatRate.frame;
    }
    
    lbSportSource.hidden = YES;
    
    if (_articlesObject.record.source.length > 0) {
        lbSportSource.text = [NSString stringWithFormat:@"数据来源：%@", _articlesObject.record.source];
        lbSportSource.hidden = NO;
        lbSportSource.frame = CGRectMake(CGRectGetMinX(lbSportSource.frame), CGRectGetMaxY(rectPosition) + 5, 310 - 5 - CGRectGetMinX(lbSportSource.frame), 20);
        rectPosition = lbSportSource.frame;
    }
    
    CGRect frame = _viewRecord.frame;
    frame.size.height = CGRectGetMaxY(rectPosition) + 10;
    _viewRecord.frame = frame;
}

#pragma mark - Web View Logic

- (NSString *)createJavaScript
{
    NSString *js = @"function setImage(){ var imgs = document.getElementsByTagName('img');for (var i=0;i<imgs.length;i++){var src = imgs[i].src;imgs[i].setAttribute('onClick','imageClick(src)');}document.location = imageurls;}function imageClick(imagesrc){var url='imageClick:'+imagesrc;document.location = url;}function gotoAtUserPre(atStr){var url='gotoAtUserpre:'+atStr;document.location = url;}";
    return js;
}

-(void)getAllUrlImgUrlsFromHtml
{
    NSData* ceResponse=[_strHtmlContent dataUsingEncoding:NSUTF8StringEncoding];
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:ceResponse];
    
    NSArray *images = [doc searchWithXPathQuery:@"//img"];
    
    for (int i = 0; i < [images count]; i ++) {
        
        TFHppleElement *dic = [images objectAtIndex:i];
        NSString *imgUrl = [dic objectForKey:@"src"];
        
        [_imgUrlArrayWeb addObject:imgUrl];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ( navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    
    NSString *strUrlPre = @"imageclick";
    NSString *strAtPre = @"gotoatuserpre";
    NSString *requestString = [[request URL] absoluteString];
    requestString = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] >= 1) {
        //判断是不是图片点击
        if ([(NSString *)[components objectAtIndex:0]isEqualToString:strUrlPre]) {
            NSString *strUrl = [requestString substringFromIndex:strUrlPre.length + 1];
            
            if (strUrl.length > 0) {
                NSUInteger nIndex = [_imgUrlArrayWeb indexOfObject:strUrl];
                [self onClickImageViewByIndex:nIndex IsPhotoBoard:NO];
            }
            return NO;
        }
        //判断是不是At链接点击
        else if([(NSString *)[components objectAtIndex:0]isEqualToString:strAtPre]) {
            NSString *strAt = [requestString substringFromIndex:strAtPre.length + 1];
            
            if (strAt.length > 0) {
                if ([strAt hasPrefix:@"@"]) {
                    strAt = [strAt substringFromIndex:1];
                }
                
                id processWin = [AlertManager showCommonProgress];
                
                [[SportForumAPI sharedInstance]userGetInfoByUserId:@"" NickName:strAt FinishedBlock:^(int errorCode, NSString* strDescErr, UserInfo *userInfo)
                 {
                     [AlertManager dissmiss:processWin];
                     
                     if (errorCode != 0) {
                         [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                     }
                     else
                     {
                         AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
                         accountPreViewController.strUserId = userInfo.userid;
                         [self.navigationController pushViewController:accountPreViewController animated:YES];
                     }
                 }];
            }
            
            return NO;
        }
        
        return YES;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    if (_articlesObject.content.length > 0) {
        if(_isLoadingFinished)
        {
            CGRect frame = aWebView.frame;
            frame.size.height = 1;
            CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
            frame.size = fittingSize;
            frame.size.height = [[aWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
            frame.size.width = CGRectGetWidth(_scrollView.frame) - 10;
            aWebView.frame = frame;
            
            [_webView stringByEvaluatingJavaScriptFromString:[self createJavaScript]];
            [_webView stringByEvaluatingJavaScriptFromString:@"setImage()"];
            NSLog(@"size: %f, %f", frame.size.width, frame.size.height);
            
            _btnThumb.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) / 2 - 25, CGRectGetMaxY(aWebView.frame) + 15, 50, 80);
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(_btnThumb.frame) + 20);
            return;
        }
        
        //js获取body宽度
        NSString *bodyWidth= [_webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth "];
        
        int widthOfBody = [bodyWidth intValue];
        
        //获取实际要显示的html
        NSString *html = [self htmlAdjustWithPageWidth:widthOfBody
                                                  html:_strHtmlContent
                                               webView:_webView];
        _isLoadingFinished = YES;
        [_webView loadHTMLString:html baseURL:nil];
    }
    else
    {
        CGRect frame = aWebView.frame;
        frame.size.height = 1;
        aWebView.frame = frame;
        CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        aWebView.frame = frame;
        [_webView stringByEvaluatingJavaScriptFromString:[self createJavaScript]];
        [_webView stringByEvaluatingJavaScriptFromString:@"setImage()"];
        NSLog(@"size: %f, %f", frame.size.width, frame.size.height);
        _isLoadingFinished = YES;
        
        if([_articlesObject.type isEqualToString:@"record"])
        {
            _viewRecord.frame = CGRectMake(0, CGRectGetMaxY(aWebView.frame), _viewRecord.frame.size.width, _viewRecord.frame.size.height);
            _btnThumb.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) / 2 - 25, CGRectGetMaxY(_viewRecord.frame) + 15, 50, 80);
        }
        else
        {
            _btnThumb.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) / 2 - 25, CGRectGetMaxY(aWebView.frame) + 15, 50, 80);
        }
        
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(_btnThumb.frame) + 20);
    }
}

//获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
                                 html:(NSString *)html
                              webView:(UIWebView *)webView
{
    NSMutableString *str = [NSMutableString stringWithString:html];
    //计算要缩放的比例
    CGFloat initialScale = webView.frame.size.width/pageWidth;
    //将</head>替换为meta+head
    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes\"></head>",initialScale];
    
    NSRange range =  NSMakeRange(0, str.length);
    //替换
    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    return str;
}

-(NSString*)replaceAtString:(NSString*)strSource
{
    NSString *strReturn = strSource;
    //NSArray *matchArray = [strSource componentsMatchedByRegex:@"@[^\\s]+\\s?"];
    
    //NSArray *matchArray = [_tvLiterator.text componentsMatchedByRegex:@"(?<=@)[^\\s]+\\s?"];
    NSArray *matchArray = [strSource componentsMatchedByRegex:@"((@)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)_]+))|(@)([\u4e00-\u9fa5]+)"];
    
    for (NSString *str in matchArray) {
        NSString *strFormat = [NSString stringWithFormat:@"<span style=\"color:#29ADF0;\" onclick='gotoAtUserPre(this.innerText)'>%@</span>", str];
        strReturn = [strReturn stringByReplacingOccurrencesOfString:str withString:strFormat];
    }
    
    return strReturn;
}

-(NSString*)convertSegmentsToHtml {
    NSMutableString *contents = [[NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"]                        encoding:NSUTF8StringEncoding error:nil] mutableCopy];
    NSMutableString *strBody = [[NSMutableString alloc]init];
    
    if ([_articlesObject.type isEqualToString:@"record"]) {
        if (_articlesObject.record.mood.length > 0) {
            NSArray *firstSplit = [_articlesObject.record.mood componentsSeparatedByString:@"\n"];
            
            for (NSString *strSplit in firstSplit) {
                if (strSplit.length > 0) {
                    [strBody appendString:[NSString stringWithFormat:@"<p>%@</p>", [self replaceAtString:strSplit]]];
                }
            }
        }
        
        for (NSUInteger nIndex = 0; nIndex < _articlesObject.record.sport_pics.data.count; nIndex++) {
            [strBody appendString:[NSString stringWithFormat:@"<div class=\"divimg\"><img src=\"%@\" /></div>", _articlesObject.record.sport_pics.data[nIndex]]];
        }
    }
    else
    {
        if (_articlesObject.content > 0) {
            [strBody appendString:_articlesObject.content];
        }
        else
        {
            for (int index = 0; index < _articlesObject.article_segments.data.count; index++) {
                ArticleSegmentObject* segobj = _articlesObject.article_segments.data[index];
                
                if ([segobj.seg_type isEqualToString:@"IMAGE"]) {
                    [strBody appendString:[NSString stringWithFormat:@"<div class=\"divimg\"><img src=\"%@\" /></div>", segobj.seg_content]];
                }
                else if([segobj.seg_type isEqualToString:@"VIDEO"] && segobj.seg_content.length > 0) {
                    _isVideo = YES;
                    NSArray *list = [segobj.seg_content componentsSeparatedByString:@"###"];
                    [strBody appendString:[NSString stringWithFormat:@"<div class=\"divimg\"><img src=\"%@\" /></div>", list.firstObject]];
                }
                else if([segobj.seg_type isEqualToString:@"TEXT"]) {
                    NSArray *firstSplit = [segobj.seg_content componentsSeparatedByString:@"\n"];
                    
                    for (NSString *strSplit in firstSplit) {
                        if (strSplit.length > 0) {
                            [strBody appendString:[NSString stringWithFormat:@"<p>%@</p>", [self replaceAtString:strSplit]]];
                        }
                    }
                }
            }
        }
    }
    
    // TODO get details
    [contents replaceOccurrencesOfString:@"___content___" withString:strBody options:0 range:NSMakeRange(0, contents.length)];
    return contents;
}

#pragma mark 动画 + 运动数据
-(void)updateControlAfterReceived
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
    //General Sender Control
    UIView *viewSender = [[UIView alloc]initWithFrame:CGRectMake(0, -90, CGRectGetWidth(viewBody.frame), 90)];
    viewSender.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:viewSender];
    
    UIImageView *imgSenderView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    [imgSenderView sd_setImageWithURL:[NSURL URLWithString:_userInfoSender.profile_image]
                     placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    [viewSender addSubview:imgSenderView];
    
    CSButton *btnUser = [CSButton buttonWithType:UIButtonTypeCustom];
    btnUser.frame = imgSenderView.frame;
    btnUser.backgroundColor = [UIColor clearColor];
    [viewSender addSubview:btnUser];
    
    __weak __typeof(self) weakSelf = self;
    
    btnUser.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
        accountPreViewController.strUserId = strongSelf->_userInfoSender.userid;
        [strongSelf.navigationController pushViewController:accountPreViewController animated:YES];
    };
    
    UIImageView *sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(90, 10, 45, 20)];
    [sexTypeImageView setImage:[UIImage imageNamed:([CommonFunction ConvertStringToSexType:_userInfoSender.sex_type] == e_sex_male ? @"gender-male" : @"gender-female")]];
    sexTypeImageView.backgroundColor = [UIColor clearColor];
    [viewSender addSubview:sexTypeImageView];
    
    UILabel *lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, 12, 20, 15)];
    lbAge.backgroundColor = [UIColor clearColor];
    lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:_userInfoSender.birthday];
    lbAge.textColor = [UIColor whiteColor];
    lbAge.font = [UIFont systemFontOfSize:12];
    lbAge.textAlignment = NSTextAlignmentRight;
    [viewSender addSubview:lbAge];
    
    CGFloat fStartPoint = CGRectGetMaxX(sexTypeImageView.frame) + 4;
    
    if (_userInfoSender.phone_number.length > 0) {
        UIImageView *imgViePhone = [[UIImageView alloc]initWithFrame:CGRectMake(fStartPoint, 10, 8, 14)];
        [imgViePhone setImage:[UIImage imageNamed:@"phone-verified-small"]];
        imgViePhone.backgroundColor = [UIColor clearColor];
        [viewSender addSubview:imgViePhone];
        fStartPoint = CGRectGetMaxX(imgViePhone.frame) + 2;
    }
    
    if ([_userInfoSender.actor isEqualToString:@"coach"]) {
        UIImageView *imgVieCoach = [[UIImageView alloc]initWithFrame:CGRectMake(fStartPoint, 10, 20, 20)];
        [imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
        imgVieCoach.backgroundColor = [UIColor clearColor];
        [viewSender addSubview:imgVieCoach];
        fStartPoint = CGRectGetMaxX(imgVieCoach.frame) + 2;
    }
    
    UILabel *lbNickName = [[UILabel alloc]initWithFrame:CGRectMake(fStartPoint + 5, 10, 310 - fStartPoint - 15, 20)];
    lbNickName.backgroundColor = [UIColor clearColor];
    lbNickName.text = _userInfoSender.nikename;
    lbNickName.textColor = [UIColor blackColor];
    lbNickName.font = [UIFont boldSystemFontOfSize:14];
    lbNickName.textAlignment = NSTextAlignmentLeft;
    [viewSender addSubview:lbNickName];
    
    UILabel *lbLevel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(sexTypeImageView.frame), CGRectGetMaxY(sexTypeImageView.frame) + 5, 40, 20)];
    lbLevel.backgroundColor = [UIColor clearColor];
    lbLevel.text = [NSString stringWithFormat:@"LV.%ld", _userInfoSender.proper_info.rankLevel];
    lbLevel.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    lbLevel.font = [UIFont italicSystemFontOfSize:14];
    lbLevel.textAlignment = NSTextAlignmentLeft;
    [viewSender addSubview:lbLevel];
    
    UILabel *lbScore = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbLevel.frame) + 5, CGRectGetMinY(lbLevel.frame), 150, 20)];
    lbScore.backgroundColor = [UIColor clearColor];
    lbScore.text = [NSString stringWithFormat:@"总分数：%lu", (unsigned long)_userInfoSender.proper_info.rankscore];
    lbScore.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    lbScore.font = [UIFont boldSystemFontOfSize:14];
    lbScore.textAlignment = NSTextAlignmentLeft;
    [viewSender addSubview:lbScore];
    
    float dMyLon = [[ApplicationContext sharedInstance] accountInfo].longitude;
    float dMyLat = [[ApplicationContext sharedInstance] accountInfo].latitude;
    float dOtherLon =  _userInfoSender.longitude;
    float dOtherLat = _userInfoSender.latitude;
    double dDistance = [[CommonUtility sharedInstance] getDistanceBySelfLon:dMyLon SelfLantitude:dMyLat OtherLon:dOtherLon OtherLat:dOtherLat];
    
    NSString * strDate = @"";
    
    if (_userInfoSender.last_login_time > 0) {
        NSDate * dateLastLogin = [NSDate dateWithTimeIntervalSince1970:_userInfoSender.last_login_time];
        NSDate * today = [NSDate date];
        long long llInterval = [today timeIntervalSinceDate:dateLastLogin];
        long long llMinute = llInterval / 60;
        long long llHour = llInterval / 3600;
        
        if (llMinute == 0) {
            strDate = @"刚刚登录";
        }
        
        if(llMinute > 0)
        {
            strDate = [NSString stringWithFormat:@"%lld分钟前登录", llMinute];
        }
        
        if(llMinute >= 60)
        {
            strDate = [NSString stringWithFormat:@"%lld小时前登录", llHour];
        }
        
        if(llHour >= 24)
        {
            strDate = [NSString stringWithFormat:@"%lld天前登录", llHour / 24];
        }
    }
    
    if (dDistance < 1000 && dDistance >= 0) {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@, 距离%.2f米", strDate, dDistance];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.2f米", dDistance];
        }
    }
    else if(dDistance >= 1000)
    {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@, 距离%.2f公里", strDate, dDistance / 1000];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.2f公里", dDistance / 1000];
        }
    }
    
    if (strDate.length > 0) {
        UIImageView * imgLoc = [[UIImageView alloc] initWithFrame:CGRectZero];
        imgLoc.image = [UIImage imageNamed:@"location-icon"];
        [viewSender addSubview:imgLoc];
        
        UILabel *lbLoc = [[UILabel alloc] initWithFrame:CGRectZero];
        lbLoc.backgroundColor = [UIColor clearColor];
        lbLoc.font = [UIFont boldSystemFontOfSize:14];
        lbLoc.textColor = [UIColor darkGrayColor];
        [viewSender addSubview:lbLoc];
        lbLoc.text = strDate;
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize lbSize = [lbLoc.text boundingRectWithSize:CGSizeMake(FLT_MAX, 20)
                                                 options:options
                                              attributes:@{NSFontAttributeName:lbLoc.font} context:nil].size;
        
        imgLoc.frame = CGRectMake(CGRectGetMinX(sexTypeImageView.frame), CGRectGetMaxY(lbLevel.frame) + 5, 17, 17);
        lbLoc.frame = CGRectMake(CGRectGetMaxX(imgLoc.frame) + 5, CGRectGetMaxY(lbLevel.frame) + 5, lbSize.width, 20);
    }
    
    //General Result Control
    UIView *viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 50, CGRectGetWidth(self.view.frame), 50)];
    UIImage *image = [UIImage imageNamed:@"tool-bg-1"];
    viewBottom.layer.contents = (id) image.CGImage;
    viewBottom.alpha = 0;
    [self.view addSubview:viewBottom];
    [self.view bringSubviewToFront:viewBottom];
    
    UIImageView *imgFriends = [[UIImageView alloc]initWithFrame:CGRectMake(155 - 35, 190, 70, 70)];
    [imgFriends setImage:[UIImage imageNamed:@"contact-friends"]];
    imgFriends.alpha = 0;
    [self.view addSubview:imgFriends];
    [self.view bringSubviewToFront:imgFriends];
    
    UILabel *lbFriends = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(imgFriends.frame) + 20, CGRectGetWidth(viewBody.frame) - 20, 40)];
    lbFriends.backgroundColor = [UIColor clearColor];
    lbFriends.text = [NSString stringWithFormat:@"你已经和\"%@\"成为好友了，一起去运动吧！", _userInfoSender.nikename];
    lbFriends.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    lbFriends.font = [UIFont boldSystemFontOfSize:14];
    lbFriends.textAlignment = NSTextAlignmentCenter;
    lbFriends.numberOfLines = 0;
    lbFriends.alpha = 0;
    [self.view addSubview:lbFriends];
    [self.view bringSubviewToFront:lbFriends];
    
    UILabel *lbFriends1 = [[UILabel alloc]initWithFrame:CGRectMake(60, CGRectGetMinY(imgFriends.frame), CGRectGetWidth(viewBody.frame) - 70, 40)];
    lbFriends1.backgroundColor = [UIColor clearColor];
    lbFriends1.text = @"约赞成功，你们已经是朋友了，可以相互聊天交流，讨论如何运动的最好。";
    lbFriends1.textColor = [UIColor blackColor];
    lbFriends1.font = [UIFont boldSystemFontOfSize:14];
    lbFriends1.textAlignment = NSTextAlignmentLeft;
    lbFriends1.numberOfLines = 0;
    lbFriends1.alpha = 0;
    [self.view addSubview:lbFriends1];
    [self.view bringSubviewToFront:lbFriends1];
    
    __block CGRect rectView = viewSender.frame;
    
    [UIView animateWithDuration:0.6 animations:^{
        rectView = CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), 90);
        viewSender.frame = rectView;
        _webView.frame = CGRectMake(0, CGRectGetMaxY(viewSender.frame), CGRectGetWidth(_scrollView.frame), _webView.frame.size.height);
        
        if([_articlesObject.type isEqualToString:@"record"])
        {
            _viewRecord.frame = CGRectMake(0, CGRectGetMaxY(_webView.frame), _viewRecord.frame.size.width, _viewRecord.frame.size.height);
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(_viewRecord.frame) + 60);
        }
        else
        {
            _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(_webView.frame) + 60);
        }
        
        imgFriends.alpha = 1;
        lbFriends.alpha = 1;
        [_scrollView removeTwitterCoverView];
        _viewPhotoBoard.alpha = 0;
        _btnThumb.alpha = 0;
        _webView.alpha = 0;
        _viewRecord.alpha = 0;
        
        UIImageView *imageViewTop = (UIImageView*)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
        UILabel *lbTitle = (UILabel*)[imageViewTop viewWithTag:GENERATE_VIEW_TITLE];
        [lbTitle setText:@"约赞成功"];
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.6 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                imgFriends.frame = CGRectMake(10, CGRectGetHeight(self.view.frame) - 45, 40, 40);
                lbFriends1.frame = CGRectMake(60, CGRectGetMinY(imgFriends.frame), CGRectGetWidth(viewBody.frame) - 70, 40);
                lbFriends.alpha = 0;
                lbFriends1.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.6 animations:^{
                        viewBottom.alpha = 1;
                        _webView.alpha = 1;
                        _viewRecord.alpha = 1;
                    }];
                }
            }];
        }
    }];
}

-(void)loadThumbShareData
{
    __weak typeof (self) thisPoint = self;
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    id processWin = [AlertManager showCommonProgressInView:viewBody];
    
    [[SportForumAPI sharedInstance] userGetInfoByUserId:_strSendId NickName:@""
                                          FinishedBlock:^void(int errorCode, NSString* strDescErr, UserInfo* userInfo)
     {
         typeof(self) thisStrongPoint = thisPoint;
         
         if (thisStrongPoint == nil) {
             return;
         }
         
         if(errorCode == 0)
         {
             _userInfoSender = userInfo;
             
             if (_strArticleId.length > 0) {
                 [[SportForumAPI sharedInstance]articleGetByArticleId:_strArticleId FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
                     [AlertManager dissmiss:processWin];
                     
                     if (errorCode == 0) {
                         _articlesObject = articlesObject;
                         [self generateDetailView];
                     }
                     else
                     {
                         [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                     }
                 }];
             }
         }
         else
         {
             [AlertManager dissmiss:processWin];
             [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
         }
     }];
}

#pragma mark - MWPhotoBrowserDelegate

-(void)onClickVideoPreView:(NSString*)strUrl
{
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    //CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
    //[moviePlayerViewController.view setTransform:transform];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}

-(void)onClickImageViewByIndex:(NSUInteger)index IsPhotoBoard:(BOOL)bIsBoard
{
    if(_isVideo)
    {
        for (int index = 0; index < _articlesObject.article_segments.data.count; index++) {
            ArticleSegmentObject* segobj = _articlesObject.article_segments.data[index];
            
            if([segobj.seg_type isEqualToString:@"VIDEO"] && segobj.seg_content.length > 0) {
                NSArray *list = [segobj.seg_content componentsSeparatedByString:@"###"];
                [self onClickVideoPreView:list.lastObject];
                return;
            }
        }
    }

    [_photos removeAllObjects];

    for (NSString *strUrl in (bIsBoard ? _imgUrlArray : _imgUrlArrayWeb)) {
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
    [browser setCurrentPhotoIndex:index];
    
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
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
