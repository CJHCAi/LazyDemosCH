//
//  RecordReceiveHeartViewController.m
//  SportForum
//
//  Created by liyuan on 5/29/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "RecordReceiveHeartViewController.h"
#import "UIViewController+SportFormu.h"
#import "UIScrollView+TwitterCover.h"
#import "ZCSHoldProgress.h"
#import "AlertManager.h"
#import "LiveMonitorVC.h"
#import "MWPhotoBrowser.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"
#import "AccountPreViewController.h"

@interface RecordReceiveHeartViewController ()<ZCSHoldProgressDelegate, MWPhotoBrowserDelegate>
{
    CALayer *_layer;
    UIView *_viewTouch;
    
    UIView *_viewPhotoBoard;
    UIImageView *_imgPrivatePicture[5];
    CSButton *_btnPrivate[5];
    
    UIView *_viewHeartRate;
    UILabel * _lbTips;
    UIScrollView *_scrollView;
    
    int _index;
    NSMutableArray *_images;
    NSArray *_imagesTime;
    
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _photos;
    
    NSTimer *_myAnimatedTimer;
    
    AVAudioPlayer *_avAudioPlayer;
    BOOL _bHandlePress;

    UserInfo *_senderInfo;
    SportRecordInfo *_sportRecordInfo;
}

@end

@implementation RecordReceiveHeartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _photos = [[NSMutableArray alloc]init];
    _imgUrlArray = [[NSMutableArray alloc]init];
    
    __weak typeof (self) thisPoint = self;
    
    [self generateCommonViewInParent:self.view Title:@"接收心跳" IsNeedBackBtn:YES ActionBlock:^(void){
        typeof(self) thisStrongPoint = thisPoint;

        if(thisStrongPoint->_viewTouch.alpha != 0)
        {
            [[SportForumAPI sharedInstance]userReceiveHeartBySendId:thisStrongPoint->_strSendId IsAccept:NO FinishedBlock:^(int errorCode)
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
    
    _images = [NSMutableArray array];
    for (int i=0; i<7; ++i) {
        NSString *imageName=[NSString stringWithFormat:@"heart-beat-%i",i + 1];
        UIImage *image=[UIImage imageNamedWithWebP:imageName];
        [_images addObject:image];
    }
    
    _imagesTime = @[@(0.2), @(0.1), @(0.1), @(0.2), @(0.1), @(0.1), @(0.2)];
    
    _layer=[[CALayer alloc]init];
    _layer.bounds=CGRectMake(85, 30, 140, 140);
    _layer.position=CGPointMake(155, 220);
    _layer.hidden = YES;
    [_scrollView.layer addSublayer:_layer];
    
    _viewTouch = [[UIView alloc]initWithFrame:CGRectMake(85, 150, 140, 140)];
    _viewTouch.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_viewTouch];
    
    _lbTips = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewTouch.frame) + 50, CGRectGetWidth(viewBody.frame), 50)];
    _lbTips.backgroundColor = [UIColor clearColor];
    _lbTips.font = [UIFont boldSystemFontOfSize:16];
    _lbTips.textColor = [UIColor blackColor];
    _lbTips.textAlignment = NSTextAlignmentCenter;
    _lbTips.numberOfLines = 0;
    _lbTips.text = @"长按红心，感知Ta的运动韵律！";
    _lbTips.hidden = YES;
    [_scrollView addSubview:_lbTips];
    
    ZCSHoldProgress *holdProgress = [[ZCSHoldProgress alloc] initWithTarget:self action:@selector(gestureRecogizerTarget:)];
    holdProgress.displayDelay = 0;
    holdProgress.rectView = CGRectMake(0, 0, 140, 140);
    holdProgress.minimumPressDuration = 1.0;
    holdProgress.allowableMovement = 10.0; // Move as much as you want
    holdProgress.delegateProcess = self;
    [_viewTouch addGestureRecognizer:holdProgress];
    
    [self getSenderDetailInfo];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MobClick beginLogPageView:@"接收心跳 - RecordReceiveHeartViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"接收心跳 - RecordReceiveHeartViewController"];
    
    if (_myAnimatedTimer == nil && _viewTouch.alpha != 0) {
        [self startChangePngAnimated];
        [self prepAudio];
    }
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetHeight(viewBody.frame) + 5);
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"接收心跳 - RecordReceiveHeartViewController"];
    
    if (_senderInfo.userid.length > 0 && _layer.hidden == NO) {
        [_myAnimatedTimer invalidate];
        _myAnimatedTimer = nil;
        [_avAudioPlayer stop];
    }
}

-(void)getSenderDetailInfo
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
             _senderInfo = userInfo;
             
             [[SportForumAPI sharedInstance]recordGetById:_strRecordId FinishedBlock:^(int errorCode, SportRecordInfo *sportRecordInfo){
                 [AlertManager dissmiss:processWin];
                 
                 if (errorCode == 0) {
                     _sportRecordInfo = sportRecordInfo;
                     [self updateSenderInfoBeforeReceived];
                     
                     if (_myAnimatedTimer == nil) {
                         [self startChangePngAnimated];
                         [self prepAudio];
                     }
                 }
                 else
                 {
                     [JDStatusBarNotification showWithStatus:@"获取运动记录失败，请重试！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                 }
             }];
         }
         else
         {
             [AlertManager dissmiss:processWin];
             [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
         }
     }];
}

#pragma mark - ZCSHoldProcessDelegage

- (void)videoStopTimeEventWhenTouch:(ZCSHoldProgress *)progress
{
    [_myAnimatedTimer invalidate];
    _myAnimatedTimer = nil;
    _layer.hidden = YES;
}

- (void)videoBeginTimeEventWhenLeave:(ZCSHoldProgress *)progress
{
    if (!_bHandlePress) {
        _index = 0;
        [self startChangePngAnimated];
    }
}

-(void)startChangePngAnimated
{
    if (_index > 6) {
        _index = 0;
    }
    
    UIImage *image=_images[_index];
    _layer.contents=(id)image.CGImage;//更新图片
    _layer.hidden = NO;
    
    NSTimeInterval fTime = [_imagesTime[_index++] floatValue];
    _myAnimatedTimer = [NSTimer scheduledTimerWithTimeInterval:fTime target:self selector:@selector(startChangePngAnimated) userInfo:nil repeats:NO];
}

- (void)prepAudio
{
    NSError *error;
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/Audios/%@", @"Heartbeat4.wav"]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        return;
    }
    
    if (_avAudioPlayer == nil) {
        _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]error:&error];
    }
    
    if (!_avAudioPlayer)
    {
        NSLog(@"Error: %@", [error localizedDescription]);
        return;
    }
    
    _avAudioPlayer.numberOfLoops = -1;
    [_avAudioPlayer setVolume:5];
    [_avAudioPlayer play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"RecordReceiveHeartViewController dealloc called!");
    [_scrollView removeTwitterCoverView];
}

- (void)gestureRecogizerTarget:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _bHandlePress = YES;
        [self updateControlAfterReceived];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}

#pragma mark 个人运动数据
-(NSString*)reGenerateLocPosiStr
{
    float dMyLon = [[ApplicationContext sharedInstance] accountInfo].longitude;
    float dMyLat = [[ApplicationContext sharedInstance] accountInfo].latitude;
    float dOtherLon =  _senderInfo.longitude;
    float dOtherLat = _senderInfo.latitude;
    double dDistance = [[CommonUtility sharedInstance] getDistanceBySelfLon:dMyLon SelfLantitude:dMyLat OtherLon:dOtherLon OtherLat:dOtherLat];
    
    NSString * strDate = @"";
    
    if (_senderInfo.last_login_time > 0) {
        NSDate * dateLastLogin = [NSDate dateWithTimeIntervalSince1970:_senderInfo.last_login_time];
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

-(void)updateSenderInfoBeforeReceived
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    
    NSMutableAttributedString * strPer = nil;
    
    if (_sportRecordInfo != nil) {
        NSDate * beginDay = [NSDate dateWithTimeIntervalSince1970:_sportRecordInfo.begin_time];
        NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginDay];
        NSString *strDate = [NSString stringWithFormat:@"%02ld/%02ld/%04ld %.2ld:%.2ld", [comps month], [comps day], [comps year], [comps hour], [comps minute]];
        
        NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 跑步", strDate] attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:22], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
        NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", _sportRecordInfo.distance / 1000.0] attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:@"公里" attributes:attribs];
        
        strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
        [strPer appendAttributedString:strPart2Value];
        [strPer appendAttributedString:strPart3Value];
    }

    NSString * strDate = @"";
    float dMyLon = [[ApplicationContext sharedInstance] accountInfo].longitude;
    float dMyLat = [[ApplicationContext sharedInstance] accountInfo].latitude;
    float dOtherLon =  _senderInfo.longitude;
    float dOtherLat = _senderInfo.latitude;
    double dDistance = [[CommonUtility sharedInstance] getDistanceBySelfLon:dMyLon SelfLantitude:dMyLat OtherLon:dOtherLon OtherLat:dOtherLat];
    
    if (_senderInfo.last_login_time > 0) {
        NSDate * dateLastLogin = [NSDate dateWithTimeIntervalSince1970:_senderInfo.last_login_time];
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

    //Generate Photo Board Control
    _viewPhotoBoard = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), 75)];
    _viewPhotoBoard.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_viewPhotoBoard];
    
    CGFloat fStartYPoint = 10;
    NSUInteger nImageCount = _senderInfo.user_images.data.count;
    
    if (nImageCount > 0) {
        [_scrollView addTwitterCoverWithImage:[UIImage imageNamed:@"cover-5.jpg"]];
        [_scrollView sendSubviewToBack:_scrollView.twitterCoverView];
        
        [_imgUrlArray removeAllObjects];
        [_imgUrlArray addObjectsFromArray:_senderInfo.user_images.data];
        
        for(int i = 0; i < MIN(nImageCount, 5); i++)
        {
            int nRectWidth = 52;
            _imgPrivatePicture[i] = [[UIImageView alloc] initWithFrame:CGRectMake(5 + (nRectWidth + 10) * i, 12, nRectWidth, nRectWidth)];
            _imgPrivatePicture[i].contentMode = UIViewContentModeScaleAspectFill;
            _imgPrivatePicture[i].layer.cornerRadius = 5.0;
            _imgPrivatePicture[i].layer.masksToBounds = YES;
            
            [_viewPhotoBoard addSubview:_imgPrivatePicture[i]];
            [_viewPhotoBoard bringSubviewToFront:_imgPrivatePicture[i]];
            
            [_imgPrivatePicture[i] sd_setImageWithURL:[NSURL URLWithString:_senderInfo.user_images.data[i]]
                                     placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
            
            _btnPrivate[i] = [CSButton buttonWithType:UIButtonTypeCustom];
            _btnPrivate[i].frame = _imgPrivatePicture[i].frame;
            _btnPrivate[i].backgroundColor = [UIColor clearColor];
            
            __weak __typeof(self) weakSelf = self;
            
            _btnPrivate[i].actionBlock = ^void()
            {
                __typeof(self) strongSelf = weakSelf;
                [strongSelf onClickImageViewByIndex:i];
            };
            
            [_viewPhotoBoard addSubview:_btnPrivate[i]];
            [_viewPhotoBoard bringSubviewToFront:_btnPrivate[i]];
        }
        
        fStartYPoint = CGRectGetHeight(_scrollView.twitterCoverView.frame) + 10;
        
        UIImageView *imgViewProfile = [[UIImageView alloc]initWithFrame:CGRectMake(10, fStartYPoint, 50, 50)];
        [imgViewProfile sd_setImageWithURL:[NSURL URLWithString:_senderInfo.profile_image]
                          placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
        [_viewPhotoBoard addSubview:imgViewProfile];
        
        UIImageView *sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70, CGRectGetMinY(imgViewProfile.frame), 45, 20)];
        sexTypeImageView.backgroundColor = [UIColor clearColor];
        [sexTypeImageView setImage:[UIImage imageNamed:([CommonFunction ConvertStringToSexType:_senderInfo.sex_type] == e_sex_male ? @"gender-male" : @"gender-female")]];
        [_viewPhotoBoard addSubview:sexTypeImageView];
        
        UILabel *lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, CGRectGetMinY(imgViewProfile.frame) + 2, 20, 15)];
        lbAge.backgroundColor = [UIColor clearColor];
        lbAge.textColor = [UIColor whiteColor];
        lbAge.font = [UIFont systemFontOfSize:12];
        lbAge.textAlignment = NSTextAlignmentRight;
        lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:_senderInfo.birthday];
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
        
        if(strPer != nil)
        {
            UILabel *lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(sexTypeImageView.frame) + 5, CGRectGetWidth(_viewPhotoBoard.frame) - 70, 25)];
            lbDesc.backgroundColor = [UIColor clearColor];
            lbDesc.font = [UIFont boldSystemFontOfSize:14];
            lbDesc.textColor = [UIColor darkGrayColor];
            lbDesc.textAlignment = NSTextAlignmentLeft;
            lbDesc.attributedText = strPer;
            [_viewPhotoBoard addSubview:lbDesc];
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
        
        _viewPhotoBoard.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(imgViewProfile.frame) + 10);
    }
    else
    {
        UIImageView *imgViewProfile = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_viewPhotoBoard.frame) / 2 - 40, 10, 80, 80)];
        [imgViewProfile sd_setImageWithURL:[NSURL URLWithString:_senderInfo.profile_image]
                          placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        imgViewProfile.layer.cornerRadius = 5.0;
        imgViewProfile.layer.masksToBounds = YES;
        [_viewPhotoBoard addSubview:imgViewProfile];
        
        UIImageView *sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_viewPhotoBoard.frame) / 2 - 45 / 2, CGRectGetMaxY(imgViewProfile.frame) + 10, 45, 20)];
        sexTypeImageView.backgroundColor = [UIColor clearColor];
        [sexTypeImageView setImage:[UIImage imageNamed:([CommonFunction ConvertStringToSexType:_senderInfo.sex_type] == e_sex_male ? @"gender-male" : @"gender-female")]];
        [_viewPhotoBoard addSubview:sexTypeImageView];
        
        UILabel *lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, CGRectGetMinY(sexTypeImageView.frame) + 2, 20, 15)];
        lbAge.backgroundColor = [UIColor clearColor];
        lbAge.textColor = [UIColor whiteColor];
        lbAge.font = [UIFont systemFontOfSize:12];
        lbAge.textAlignment = NSTextAlignmentRight;
        lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:_senderInfo.birthday];
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
        
        if (strDate.length > 0) {
            imgLoc.image = [UIImage imageNamed:@"location-icon"];
            imgLoc.hidden = NO;
            
            lbLoc.hidden = NO;
            lbLoc.text = strDate;
            
            NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            CGSize lbSize = [lbLoc.text boundingRectWithSize:CGSizeMake(FLT_MAX, 20)
                                                     options:options
                                                  attributes:@{NSFontAttributeName:lbLoc.font} context:nil].size;
            CGRect rect = sexTypeImageView.frame;
            rect.origin = CGPointMake(CGRectGetWidth(_viewPhotoBoard.frame) / 2 - (45 + 5 + 17 + 5 + lbSize.width + 5) / 2, rect.origin.y);
            sexTypeImageView.frame = rect;
            
            rect = lbAge.frame;
            rect.origin = CGPointMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, rect.origin.y);
            lbAge.frame = rect;
            
            imgLoc.frame = CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) + 5, CGRectGetMinY(sexTypeImageView.frame), 17, 17);
            lbLoc.frame = CGRectMake(CGRectGetMaxX(imgLoc.frame) + 5, CGRectGetMinY(sexTypeImageView.frame), lbSize.width, 20);
        }

        if(strPer != nil)
        {
            UILabel *lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sexTypeImageView.frame) + 5, CGRectGetWidth(_viewPhotoBoard.frame), 25)];
            lbDesc.backgroundColor = [UIColor clearColor];
            lbDesc.font = [UIFont boldSystemFontOfSize:14];
            lbDesc.textColor = [UIColor darkGrayColor];
            lbDesc.textAlignment = NSTextAlignmentCenter;
            lbDesc.attributedText = strPer;
            [_viewPhotoBoard addSubview:lbDesc];
        }

        _viewPhotoBoard.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetMaxY(sexTypeImageView.frame) + 30);
    }
    
    [UIView animateWithDuration:1.0 animations:^(void)
     {
         _layer.position=CGPointMake(155, CGRectGetMaxY(_viewPhotoBoard.frame) + 75);
         _viewTouch.frame = CGRectMake(85, CGRectGetMaxY(_viewPhotoBoard.frame) + 5, 140, 140);
     }];

    //Heart Rate
    _viewHeartRate = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewTouch.frame) + 5, 310, 80)];
    _viewHeartRate.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_viewHeartRate];
    
    LiveMonitorVC* liveMonitorVC = [[LiveMonitorVC alloc]initWithFrame:CGRectMake(0, 0, 310, 80)];
    liveMonitorVC.backgroundColor = [UIColor clearColor];
    [_viewHeartRate addSubview:liveMonitorVC];
    
    if (_sportRecordInfo.heart_rate > 0) {
        UILabel * lbRate = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(liveMonitorVC.frame), 290, 30)];
        lbRate.backgroundColor = [UIColor clearColor];
        lbRate.font = [UIFont boldSystemFontOfSize:16];
        lbRate.textColor = [UIColor darkGrayColor];
        lbRate.textAlignment = NSTextAlignmentCenter;
        lbRate.text = [NSString stringWithFormat:@"心率：%ld 次/分", _sportRecordInfo.heart_rate];
        [_viewHeartRate addSubview:lbRate];
        _viewHeartRate.frame = CGRectMake(0, CGRectGetMaxY(_viewTouch.frame) + 5, 310, 110);
    }

    _lbTips.hidden = NO;
    _lbTips.frame = CGRectMake(0, CGRectGetMaxY(_viewHeartRate.frame) + 30, CGRectGetWidth(viewBody.frame), 50);
}

#pragma mark 动画 + 运动数据
-(void)updateControlAfterReceived
{
    _lbTips.hidden = YES;
    _viewTouch.alpha = 0;
    [_myAnimatedTimer invalidate];
    _myAnimatedTimer = nil;
    [_avAudioPlayer stop];
    _layer.hidden = YES;
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    
    UIView *viewSender = [[UIView alloc]initWithFrame:CGRectMake(0, -90, CGRectGetWidth(viewBody.frame), 90)];
    viewSender.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:viewSender];
    
    UIImageView *imgSenderView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    [imgSenderView sd_setImageWithURL:[NSURL URLWithString:_senderInfo.profile_image]
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
        accountPreViewController.strUserId = strongSelf->_senderInfo.userid;
        [strongSelf.navigationController pushViewController:accountPreViewController animated:YES];
    };
    
    UIImageView *sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(90, 10, 45, 20)];
    [sexTypeImageView setImage:[UIImage imageNamed:([CommonFunction ConvertStringToSexType:_senderInfo.sex_type] == e_sex_male ? @"gender-male" : @"gender-female")]];
    sexTypeImageView.backgroundColor = [UIColor clearColor];
    [viewSender addSubview:sexTypeImageView];
    
    UILabel *lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, 12, 20, 15)];
    lbAge.backgroundColor = [UIColor clearColor];
    lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:_senderInfo.birthday];
    lbAge.textColor = [UIColor whiteColor];
    lbAge.font = [UIFont systemFontOfSize:12];
    lbAge.textAlignment = NSTextAlignmentRight;
    [viewSender addSubview:lbAge];
    
    CGFloat fStartPoint = CGRectGetMaxX(sexTypeImageView.frame) + 4;
    
    if (_senderInfo.phone_number.length > 0) {
        UIImageView *imgViePhone = [[UIImageView alloc]initWithFrame:CGRectMake(fStartPoint, 10, 8, 14)];
        [imgViePhone setImage:[UIImage imageNamed:@"phone-verified-small"]];
        imgViePhone.backgroundColor = [UIColor clearColor];
        [viewSender addSubview:imgViePhone];
        fStartPoint = CGRectGetMaxX(imgViePhone.frame) + 2;
    }
    
    if ([_senderInfo.actor isEqualToString:@"coach"]) {
        UIImageView *imgVieCoach = [[UIImageView alloc]initWithFrame:CGRectMake(fStartPoint, 10, 20, 20)];
        [imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
        imgVieCoach.backgroundColor = [UIColor clearColor];
        [viewSender addSubview:imgVieCoach];
        fStartPoint = CGRectGetMaxX(imgVieCoach.frame) + 2;
    }
    
    UILabel *lbNickName = [[UILabel alloc]initWithFrame:CGRectMake(fStartPoint + 5, 10, 310 - fStartPoint - 15, 20)];
    lbNickName.backgroundColor = [UIColor clearColor];
    lbNickName.text = _senderInfo.nikename;
    lbNickName.textColor = [UIColor blackColor];
    lbNickName.font = [UIFont boldSystemFontOfSize:14];
    lbNickName.textAlignment = NSTextAlignmentLeft;
    [viewSender addSubview:lbNickName];
    
    UILabel *lbLevel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(sexTypeImageView.frame), CGRectGetMaxY(sexTypeImageView.frame) + 5, 40, 20)];
    lbLevel.backgroundColor = [UIColor clearColor];
    lbLevel.text = [NSString stringWithFormat:@"LV.%ld", _senderInfo.proper_info.rankLevel];
    lbLevel.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    lbLevel.font = [UIFont italicSystemFontOfSize:14];
    lbLevel.textAlignment = NSTextAlignmentLeft;
    [viewSender addSubview:lbLevel];
    
    UILabel *lbScore = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbLevel.frame) + 5, CGRectGetMinY(lbLevel.frame), 150, 20)];
    lbScore.backgroundColor = [UIColor clearColor];
    lbScore.text = [NSString stringWithFormat:@"总分数：%lu", (unsigned long)_senderInfo.proper_info.rankscore];
    lbScore.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    lbScore.font = [UIFont boldSystemFontOfSize:14];
    lbScore.textAlignment = NSTextAlignmentLeft;
    [viewSender addSubview:lbScore];
    
    float dMyLon = [[ApplicationContext sharedInstance] accountInfo].longitude;
    float dMyLat = [[ApplicationContext sharedInstance] accountInfo].latitude;
    float dOtherLon =  _senderInfo.longitude;
    float dOtherLat = _senderInfo.latitude;
    double dDistance = [[CommonUtility sharedInstance] getDistanceBySelfLon:dMyLon SelfLantitude:dMyLat OtherLon:dOtherLon OtherLat:dOtherLat];
    
    NSString * strDate = @"";
    
    if (_senderInfo.last_login_time > 0) {
        NSDate * dateLastLogin = [NSDate dateWithTimeIntervalSince1970:_senderInfo.last_login_time];
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
    
    //General Record Control
    UIView *viewRecord = [[UIView alloc]init];
    viewRecord.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    [_scrollView addSubview:viewRecord];
    
    UILabel *lbContent = [[UILabel alloc]init];
    lbContent.backgroundColor = [UIColor clearColor];
    lbContent.textColor = [UIColor blackColor];
    lbContent.font = [UIFont boldSystemFontOfSize:14];
    lbContent.textAlignment = NSTextAlignmentLeft;
    lbContent.frame = CGRectMake(10, 10, CGRectGetWidth(_scrollView.frame) - 20, 40);
    lbContent.text = _sportRecordInfo.mood.length > 0 ? _sportRecordInfo.mood : @"运动数据:";
    lbContent.numberOfLines = 0;
    [viewRecord addSubview:lbContent];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize lbSize = [lbContent.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(_scrollView.frame) - 20, FLT_MAX)
                                             options:options
                                          attributes:@{NSFontAttributeName:lbContent.font} context:nil].size;
    lbContent.frame = CGRectMake(10, 10, CGRectGetWidth(_scrollView.frame) - 20, lbSize.height);
    
    float fBeginY = CGRectGetMaxY(lbContent.frame);
    
    if (_sportRecordInfo.sport_pics.data.count > 0) {
        UIImageView *imgAddr = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbContent.frame) + 10, CGRectGetWidth(viewBody.frame), CGRectGetWidth(viewBody.frame) - 50)];
        [imgAddr sd_setImageWithURL:[NSURL URLWithString:_sportRecordInfo.sport_pics.data.firstObject]
                   placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        imgAddr.contentMode = UIViewContentModeScaleAspectFit;
        imgAddr.layer.masksToBounds = YES;
        [viewRecord addSubview:imgAddr];
        
        fBeginY = CGRectGetMaxY(imgAddr.frame);
    }
    
    UILabel *lbSportDistance = [[UILabel alloc]init];
    lbSportDistance.backgroundColor = [UIColor clearColor];
    lbSportDistance.textColor = [UIColor blackColor];
    lbSportDistance.font = [UIFont boldSystemFontOfSize:14];
    lbSportDistance.textAlignment = NSTextAlignmentLeft;
    lbSportDistance.frame = CGRectMake(10, fBeginY + 10, 130, 30);
    [viewRecord addSubview:lbSportDistance];
    
    UILabel *lbSportDuration = [[UILabel alloc]init];
    lbSportDuration.backgroundColor = [UIColor clearColor];
    lbSportDuration.textColor = [UIColor blackColor];
    lbSportDuration.font = [UIFont boldSystemFontOfSize:14];
    lbSportDuration.textAlignment = NSTextAlignmentRight;
    lbSportDuration.frame = CGRectMake(CGRectGetMaxX(lbSportDistance.frame), CGRectGetMinY(lbSportDistance.frame), 310 - 5 - CGRectGetMaxX(lbSportDistance.frame), 30);
    [viewRecord addSubview:lbSportDuration];
    
    UIImageView *imgViewDate = [[UIImageView alloc]init];
    [imgViewDate setImage:[UIImage imageNamed:@"data-record-startTime"]];
    imgViewDate.frame = CGRectMake(CGRectGetMinX(lbSportDistance.frame), CGRectGetMaxY(lbSportDistance.frame) + 5, 20, 20);
    [viewRecord addSubview:imgViewDate];
    
    UILabel *lbSportDate = [[UILabel alloc]init];
    lbSportDate.backgroundColor = [UIColor clearColor];
    lbSportDate.textColor = [UIColor darkGrayColor];
    lbSportDate.font = [UIFont boldSystemFontOfSize:14];
    lbSportDate.textAlignment = NSTextAlignmentLeft;
    lbSportDate.frame = CGRectMake(CGRectGetMaxX(imgViewDate.frame) + 5, CGRectGetMinY(imgViewDate.frame), 140, 20);
    [viewRecord addSubview:lbSportDate];
    
    UIImageView *imgViewSpeedSet = [[UIImageView alloc]init];
    [imgViewSpeedSet setImage:[UIImage imageNamed:@"data-record-pace"]];
    imgViewSpeedSet.frame = CGRectMake(CGRectGetMaxX(lbSportDate.frame) + 10, CGRectGetMinY(imgViewDate.frame), 20, 20);
    [viewRecord addSubview:imgViewSpeedSet];
    
    UILabel *lbSportSpeedSet = [[UILabel alloc]init];
    lbSportSpeedSet.backgroundColor = [UIColor clearColor];
    lbSportSpeedSet.textColor = [UIColor darkGrayColor];
    lbSportSpeedSet.font = [UIFont boldSystemFontOfSize:12];
    lbSportSpeedSet.textAlignment = NSTextAlignmentLeft;
    lbSportSpeedSet.frame = CGRectMake(CGRectGetMaxX(imgViewSpeedSet.frame) + 5, CGRectGetMinY(imgViewSpeedSet.frame), 310 - 5 - CGRectGetMaxX(imgViewSpeedSet.frame) - 5, 20);
    [viewRecord addSubview:lbSportSpeedSet];
    
    UIImageView *imgViewSpeed = [[UIImageView alloc]init];
    [imgViewSpeed setImage:[UIImage imageNamed:@"data-record-speed"]];
    imgViewSpeed.frame = CGRectMake(CGRectGetMinX(lbSportDistance.frame), CGRectGetMaxY(lbSportDate.frame) + 5, 20, 20);
    [viewRecord addSubview:imgViewSpeed];
    
    UILabel *lbSportSpeed = [[UILabel alloc]init];
    lbSportSpeed.backgroundColor = [UIColor clearColor];
    lbSportSpeed.textColor = [UIColor darkGrayColor];
    lbSportSpeed.font = [UIFont boldSystemFontOfSize:14];
    lbSportSpeed.textAlignment = NSTextAlignmentLeft;
    lbSportSpeed.frame = CGRectMake(CGRectGetMaxX(imgViewSpeed.frame) + 5, CGRectGetMinY(imgViewSpeed.frame), 140, 20);
    [viewRecord addSubview:lbSportSpeed];
    
    UIImageView *imgViewCal = [[UIImageView alloc]init];
    [imgViewCal setImage:[UIImage imageNamed:@"data-record-cal"]];
    imgViewCal.frame = CGRectMake(CGRectGetMaxX(lbSportSpeed.frame) + 10, CGRectGetMaxY(imgViewDate.frame) + 5, 20, 20);
    [viewRecord addSubview:imgViewCal];
    
    UILabel *lbSportCal = [[UILabel alloc]init];
    lbSportCal.backgroundColor = [UIColor clearColor];
    lbSportCal.textColor = [UIColor darkGrayColor];
    lbSportCal.font = [UIFont boldSystemFontOfSize:14];
    lbSportCal.textAlignment = NSTextAlignmentLeft;
    lbSportCal.frame = CGRectMake(CGRectGetMaxX(imgViewCal.frame) + 5, CGRectGetMinY(imgViewCal.frame), 310 - 5 - CGRectGetMaxX(imgViewCal.frame) - 5, 20);
    [viewRecord addSubview:lbSportCal];
    
    UIImageView *imgViewHeatRate = [[UIImageView alloc]init];
    [imgViewHeatRate setImage:[UIImage imageNamed:@"data-record-heartRate"]];
    imgViewHeatRate.frame = CGRectMake(CGRectGetMinX(lbSportDistance.frame), CGRectGetMaxY(imgViewSpeed.frame) + 5, 20, 20);
    [viewRecord addSubview:imgViewHeatRate];
    
    UILabel *lbSportHeatRate = [[UILabel alloc]init];
    lbSportHeatRate.backgroundColor = [UIColor clearColor];
    lbSportHeatRate.textColor = [UIColor darkGrayColor];
    lbSportHeatRate.font = [UIFont boldSystemFontOfSize:14];
    lbSportHeatRate.textAlignment = NSTextAlignmentLeft;
    lbSportHeatRate.frame = CGRectMake(CGRectGetMaxX(imgViewHeatRate.frame) + 5, CGRectGetMinY(imgViewHeatRate.frame), 310 - 5 - CGRectGetMaxX(imgViewHeatRate.frame) - 5, 20);
    [viewRecord addSubview:lbSportHeatRate];
    
    UILabel *lbSportSource = [[UILabel alloc]init];
    lbSportSource.backgroundColor = [UIColor clearColor];
    lbSportSource.textColor = [UIColor darkGrayColor];
    lbSportSource.font = [UIFont boldSystemFontOfSize:14];
    lbSportSource.textAlignment = NSTextAlignmentLeft;
    lbSportSource.frame = CGRectMake(CGRectGetMinX(imgViewHeatRate.frame), CGRectGetMaxY(imgViewHeatRate.frame) + 5, 310 - 5 - CGRectGetMinX(imgViewHeatRate.frame), 20);
    [viewRecord addSubview:lbSportSource];
    
    UIImageView *imgViewAuth = [[UIImageView alloc]init];
    [viewRecord addSubview:imgViewAuth];
    
    UILabel *lbSportAuth = [[UILabel alloc]init];
    lbSportAuth.backgroundColor = [UIColor clearColor];
    lbSportAuth.textColor = [UIColor darkGrayColor];
    lbSportAuth.font = [UIFont boldSystemFontOfSize:14];
    lbSportAuth.textAlignment = NSTextAlignmentLeft;
    [viewRecord addSubview:lbSportAuth];
    
    lbSportDistance.text = [NSString stringWithFormat:@"距离：%.2f km", _sportRecordInfo.distance / 1000.00];
    lbSportDuration.text = [NSString stringWithFormat:@"持续时间：%ld分钟", _sportRecordInfo.duration / 60];
    
    NSInteger nSpeedSet = _sportRecordInfo.duration / (_sportRecordInfo.distance / 1000.00);
    lbSportSpeedSet.text = [NSString stringWithFormat:@"%ld' %ld'' km", nSpeedSet / 60,   nSpeedSet % 60];
    
    NSDate * beginDay = [NSDate dateWithTimeIntervalSince1970:_sportRecordInfo.begin_time];
    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginDay];
    lbSportDate.text = [NSString stringWithFormat:@"%02ld/%02ld/%04ld %.2ld:%.2ld", [comps month], [comps day], [comps year], [comps hour], [comps minute]];
    lbSportSpeed.text = [NSString stringWithFormat:@"%.2f km/h", (_sportRecordInfo.distance / 1000.00) / (_sportRecordInfo.duration / 3600.00)];
    lbSportCal.text = [NSString stringWithFormat:@"%.0f cal", _sportRecordInfo.weight * _sportRecordInfo.distance / 800.0]; //跑步热量（kcal）＝体重（kg）×运动时间（小时）×指数K(指数K＝30÷速度（分钟/400米)
    
    CGRect rectPosition = lbSportCal.frame;
    imgViewHeatRate.hidden = YES;
    lbSportHeatRate.hidden = YES;
    
    if (_sportRecordInfo.heart_rate > 0) {
        imgViewHeatRate.hidden = NO;
        lbSportHeatRate.hidden = NO;
        lbSportHeatRate.text = [NSString stringWithFormat:@"%ld 次/分", _sportRecordInfo.heart_rate];
        rectPosition = imgViewHeatRate.frame;
    }
    
    lbSportSource.hidden = YES;
    
    if (_sportRecordInfo.source.length > 0) {
        lbSportSource.text = [NSString stringWithFormat:@"数据来源：%@", _sportRecordInfo.source];
        lbSportSource.hidden = NO;
        lbSportSource.frame = CGRectMake(CGRectGetMinX(lbSportSource.frame), CGRectGetMaxY(rectPosition) + 5, 310 - 5 - CGRectGetMinX(lbSportSource.frame), 20);
        rectPosition = lbSportSource.frame;
    }
    
    NSString *strStatus;
    UIImage *img = nil;
    
    switch ([CommonFunction ConvertStringToTaskStatusType:_sportRecordInfo.status]) {
        case e_task_finish:
            strStatus = @"审核已通过";
            img = [UIImage imageNamed:@"task-finished"];
            break;
        case e_task_unfinish:
            strStatus = @"审核未通过";
            img = [UIImage imageNamed:@"task-fail"];
            break;
        case e_task_authentication:
            strStatus = @"审核中";
            img = [UIImage imageNamed:@"task-pendding"];
            break;
        default:
            break;
    }
    
    [imgViewAuth setImage:img];
    imgViewAuth.frame = CGRectMake(CGRectGetMinX(lbSportDistance.frame), CGRectGetMaxY(rectPosition) + 10, img.size.width, img.size.height);
    
    lbSportAuth.text = strStatus;
    lbSportAuth.frame = CGRectMake(CGRectGetMaxX(imgViewAuth.frame) + 5, CGRectGetMinY(imgViewAuth.frame), 120, 20);
    
    rectPosition = imgViewAuth.frame;
    viewRecord.frame = CGRectMake(0, 130, 310, CGRectGetMaxY(rectPosition) + 10);
    viewRecord.alpha = 0;

    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(viewRecord.frame) + 60);
    
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
    lbFriends.text = [NSString stringWithFormat:@"你已经和\"%@\"成为好友了，一起去运动吧！", _senderInfo.nikename];
    lbFriends.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
    lbFriends.font = [UIFont boldSystemFontOfSize:14];
    lbFriends.textAlignment = NSTextAlignmentCenter;
    lbFriends.numberOfLines = 0;
    lbFriends.alpha = 0;
    [self.view addSubview:lbFriends];
    [self.view bringSubviewToFront:lbFriends];
    
    UILabel *lbFriends1 = [[UILabel alloc]initWithFrame:CGRectMake(60, CGRectGetMinY(imgFriends.frame), CGRectGetWidth(viewBody.frame) - 70, 40)];
    lbFriends1.backgroundColor = [UIColor clearColor];
    lbFriends1.text = [NSString stringWithFormat:@"你已经和\"%@\"成为好友了，一起去运动吧！", _senderInfo.nikename];
    lbFriends1.textColor = [UIColor blackColor];
    lbFriends1.font = [UIFont boldSystemFontOfSize:14];
    lbFriends1.textAlignment = NSTextAlignmentLeft;
    lbFriends1.numberOfLines = 0;
    lbFriends1.alpha = 0;
    [self.view addSubview:lbFriends1];
    [self.view bringSubviewToFront:lbFriends1];

    __block CGRect rectView = viewSender.frame;
    
    [UIView animateWithDuration:0.6 animations:^{
        rectView = CGRectMake(0, 0, 310, 90);
        viewSender.frame = rectView;
        
        imgFriends.alpha = 1;
        lbFriends.alpha = 1;
        [_scrollView removeTwitterCoverView];
        _viewPhotoBoard.alpha = 0;
        _viewHeartRate.alpha = 0;
    } completion:^(BOOL finished){
        if (finished) {
            [UIView animateWithDuration:0.6 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
                imgFriends.frame = CGRectMake(10, CGRectGetHeight(self.view.frame) - 45, 40, 40);
                lbFriends1.frame = CGRectMake(60, CGRectGetMinY(imgFriends.frame), 310 - 70, 40);
                lbFriends.alpha = 0;
                lbFriends1.alpha = 1;
                viewRecord.alpha = 1;
            } completion:^(BOOL finished) {
                if (finished) {
                    [UIView animateWithDuration:0.6 animations:^{
                        viewBottom.alpha = 1;
                    }];
                }
            }];
        }
    }];
    
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    [[SportForumAPI sharedInstance]userReceiveHeartBySendId:_strSendId IsAccept:YES FinishedBlock:^(int errorCode)
     {
         
     }];
}

#pragma mark - MWPhotoBrowserDelegate

-(void)onClickImageViewByIndex:(NSUInteger)index
{
    [_photos removeAllObjects];
    
    for (NSString *strUrl in _imgUrlArray) {
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
