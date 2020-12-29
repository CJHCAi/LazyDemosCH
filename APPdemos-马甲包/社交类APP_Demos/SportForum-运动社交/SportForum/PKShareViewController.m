//
//  PKShareViewController.m
//  SportForum
//
//  Created by liyuan on 7/14/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "PKShareViewController.h"
#import "UIViewController+SportFormu.h"
#import "UIImageView+WebCache.h"
#import "AlertManager.h"
#import "PhotoStackView.h"
#import "MWPhotoBrowser.h"
#import "PKAnimationViewController.h"
#import "AccountPreViewController.h"

@interface PKShareViewController ()<PhotoStackViewDataSource, PhotoStackViewDelegate, MWPhotoBrowserDelegate>

@end

@implementation PKShareViewController
{
    UIView *_viewDetail;
    UIPageControl *_pageControl;
    
    UserInfo *_userInfoSender;
    SportRecordInfo *_sportRecordInfo;
    
    NSString *_strPkResultUrl;
    NSMutableArray *_imageData;//图片数据
    NSMutableArray * _photos;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _photos = [[NSMutableArray alloc]init];
    
    __weak typeof (self) thisPoint = self;
    
    [self generateCommonViewInParent:self.view Title:@"Ta自觉强大，想PK你得意一下" IsNeedBackBtn:YES ActionBlock:^(void){
        typeof(self) thisStrongPoint = thisPoint;
        
        if (thisStrongPoint->_viewDetail.alpha != 0) {
            [[SportForumAPI sharedInstance]tasksSharedByType:e_accept_pk SenderId:thisStrongPoint->_strSendId ArticleId:@"" AddDesc:@"" ImgUrl:@"" RunBeginTime:0 IsAccept:NO FinishedBlock:^(int errorCode, ExpEffect* expEffect)
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
    
    [self loadPKShareData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PKShareViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"PKShareViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PKShareViewController"];
}

-(void)dealloc
{
    NSLog(@"PKShareViewController dealloc called!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    _viewDetail = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height)];
    _viewDetail.backgroundColor = [UIColor clearColor];
    [viewBody addSubview:_viewDetail];
    
    PhotoStackView *photoStack = [[PhotoStackView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(_viewDetail.frame) - 20, 230)];
    photoStack.dataSource = self;
    photoStack.delegate = self;
    [_viewDetail addSubview:photoStack];
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(photoStack.frame) + 30, CGRectGetWidth(_viewDetail.frame) - 40, 15)];
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    [_viewDetail addSubview:_pageControl];
    
    UIView *viewBg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_viewDetail.frame), 230 + 35 + 60)];
    viewBg.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.3];
    [_viewDetail addSubview:viewBg];
    [_viewDetail sendSubviewToBack:viewBg];
    
    UIImageView *imgViewProfile = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(photoStack.frame) + 20, 50, 50)];
    [imgViewProfile sd_setImageWithURL:[NSURL URLWithString:_userInfoSender.profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
    [_viewDetail addSubview:imgViewProfile];
    
    UIImageView *sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70, CGRectGetMinY(imgViewProfile.frame), 45, 20)];
    sexTypeImageView.backgroundColor = [UIColor clearColor];
    [sexTypeImageView setImage:[UIImage imageNamed:([CommonFunction ConvertStringToSexType:_userInfoSender.sex_type] == e_sex_male ? @"gender-male" : @"gender-female")]];
    [_viewDetail addSubview:sexTypeImageView];
    
    UILabel *lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, CGRectGetMinY(imgViewProfile.frame) + 2, 20, 15)];
    lbAge.backgroundColor = [UIColor clearColor];
    lbAge.textColor = [UIColor whiteColor];
    lbAge.font = [UIFont systemFontOfSize:12];
    lbAge.textAlignment = NSTextAlignmentRight;
    lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:_userInfoSender.birthday];
    [_viewDetail addSubview:lbAge];
    
    UIImageView * imgLoc = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgLoc.image = [UIImage imageNamed:@"location-icon"];
    imgLoc.hidden = YES;
    [_viewDetail addSubview:imgLoc];
    
    UILabel *lbLoc = [[UILabel alloc] initWithFrame:CGRectZero];
    lbLoc.backgroundColor = [UIColor clearColor];
    lbLoc.font = [UIFont boldSystemFontOfSize:14];
    lbLoc.textColor = [UIColor darkGrayColor];
    lbLoc.hidden = YES;
    [_viewDetail addSubview:lbLoc];
    
    UILabel *lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(sexTypeImageView.frame) + 5, CGRectGetWidth(_viewDetail.frame) - 90, 25)];
    lbDesc.backgroundColor = [UIColor clearColor];
    lbDesc.font = [UIFont boldSystemFontOfSize:15];
    lbDesc.textColor = [UIColor darkGrayColor];
    lbDesc.textAlignment = NSTextAlignmentLeft;
    lbDesc.text = @"Ta很懒，邀请Ta互动一下吧！";
    [_viewDetail addSubview:lbDesc];
    
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
        
        if (CGRectGetWidth(_viewDetail.frame) - lbSize.width - 10 - 20 - 5 < CGRectGetMaxX(sexTypeImageView.frame)) {
            strDate = [self reGenerateLocPosiStr];
            lbLoc.text = strDate;
            lbSize = [lbLoc.text boundingRectWithSize:CGSizeMake(FLT_MAX, 20)
                                              options:options
                                           attributes:@{NSFontAttributeName:lbLoc.font} context:nil].size;
        }
        
        lbLoc.frame = CGRectMake(CGRectGetWidth(_viewDetail.frame) - lbSize.width - 10, CGRectGetMinY(sexTypeImageView.frame), lbSize.width, 20);
        imgLoc.frame = CGRectMake(CGRectGetMinX(lbLoc.frame) - 20, CGRectGetMinY(sexTypeImageView.frame), 17, 17);
    }
    
    if (_sportRecordInfo != nil && [_sportRecordInfo.type isEqualToString:@"run"]) {
        NSDate * beginDay = [NSDate dateWithTimeIntervalSince1970:_sportRecordInfo.begin_time];
        NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginDay];
        NSString *strDate = [NSString stringWithFormat:@"%02ld/%02ld/%04ld %.2ld:%.2ld", [comps month], [comps day], [comps year], [comps hour], [comps minute]];
        
        NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 跑步", strDate] attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
        NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f", _sportRecordInfo.distance / 1000.0] attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:@"公里" attributes:attribs];
        
        NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
        [strPer appendAttributedString:strPart2Value];
        [strPer appendAttributedString:strPart3Value];
        lbDesc.attributedText = strPer;
    }
    else
    {
        lbDesc.text = @"Ta很懒，邀请Ta互动一下吧！";
    }
    
    if (_userInfoSender.user_images.data.count > 0) {
        _imageData = [NSMutableArray arrayWithArray:_userInfoSender.user_images.data];
    }
    else
    {
        _imageData = [NSMutableArray arrayWithObject:_userInfoSender.profile_image];
    }
    
    [photoStack reloadData];
    
    CGSize size= [_pageControl sizeForNumberOfPages:[_imageData count]];
    _pageControl.bounds=CGRectMake(0, 0, size.width, size.height);
    _pageControl.center = CGPointMake(CGRectGetWidth(_viewDetail.frame) / 2, CGRectGetMaxY(photoStack.frame) + 10);
    _pageControl.numberOfPages=[_imageData count];
    _pageControl.hidden = _imageData.count > 1 ? NO : YES;
    
    __weak __typeof(self) weakSelf = self;
    
    CSButton *btnPK = [CSButton buttonWithType:UIButtonTypeCustom];
    btnPK.backgroundColor = [UIColor clearColor];
    [btnPK setImage:[UIImage imageNamed:@"home-challenge-accept"] forState:UIControlStateNormal];
    //[btnPK setTitle:@"接受PK" forState:UIControlStateNormal];
    //[btnPK setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btnPK.frame = CGRectMake(CGRectGetWidth(_viewDetail.frame) / 2 - 30, CGRectGetMaxY(viewBg.frame) + 40, 60, 60);
    //btnPK.titleLabel.font = [UIFont boldSystemFontOfSize:14];//title字体大小
    //btnPK.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_viewDetail addSubview:btnPK];
    
    btnPK.actionBlock = ^()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf showPKAnimation];
    };
    
    UILabel *lbPkDesc = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(btnPK.frame) + 15, CGRectGetWidth(_viewDetail.frame) - 20, 20)];
    lbPkDesc.backgroundColor = [UIColor clearColor];
    lbPkDesc.textColor = [UIColor darkGrayColor];
    lbPkDesc.font = [UIFont boldSystemFontOfSize:14];//title字体大小
    lbPkDesc.textAlignment = NSTextAlignmentCenter;
    lbPkDesc.text = @"接受PK, 给Ta好看";
    [_viewDetail addSubview:lbPkDesc];
}

-(void)showPKAnimation
{
    [[CommonUtility sharedInstance]playAudioFromName:@"answerpk.wav"];
    
    __weak __typeof(self) weakSelf = self;
    
    PKAnimationViewController *pkAnimationViewController = [[PKAnimationViewController alloc]init];
    pkAnimationViewController.senderInfo = _userInfoSender;
    pkAnimationViewController.pkCompletedBlock = ^(NSString *strResultUrl){
        __typeof(self) strongSelf = weakSelf;
        strongSelf->_strPkResultUrl = [strResultUrl copy];
        [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(handlePkShateAction) userInfo:nil repeats:NO];
    };
    
    [self presentViewController:pkAnimationViewController animated:YES completion:nil];
}

-(void)handlePkShateAction
{
    //[self updateControlAfterReceived];
    //return;
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    
    id processWin = [AlertManager showCommonProgressInView:viewBody];
    
    [[SportForumAPI sharedInstance]tasksSharedByType:e_accept_pk SenderId:_strSendId ArticleId:@"" AddDesc:@"" ImgUrl:_strPkResultUrl RunBeginTime:0 IsAccept:YES FinishedBlock:^(int errorCode, ExpEffect* expEffect)
     {
         [AlertManager dissmiss:processWin];
         
         if (errorCode == 0) {
             [self updateControlAfterReceived];
             
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
}

#pragma mark 动画 + 运动数据
-(void)updateControlAfterReceived
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    
    //General Update ScrollView
    UIScrollView *scrollViewUpdate = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    scrollViewUpdate.backgroundColor = [UIColor clearColor];
    scrollViewUpdate.scrollEnabled = YES;
    [viewBody addSubview:scrollViewUpdate];
    
    //General Sender Control
    UIView *viewSender = [[UIView alloc]initWithFrame:CGRectMake(0, -90, CGRectGetWidth(viewBody.frame), 90)];
    viewSender.backgroundColor = [UIColor clearColor];
    [scrollViewUpdate addSubview:viewSender];
    
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
    
    //General PK Result Control
    UIView *viewPKResult = [[UIView alloc]init];
    viewPKResult.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    [scrollViewUpdate addSubview:viewPKResult];
    
    UILabel *lbContent = [[UILabel alloc]init];
    lbContent.backgroundColor = [UIColor clearColor];
    lbContent.textColor = [UIColor blackColor];
    lbContent.font = [UIFont boldSystemFontOfSize:14];
    lbContent.textAlignment = NSTextAlignmentLeft;
    lbContent.frame = CGRectMake(10, 10, CGRectGetWidth(viewBody.frame) - 20, 40);
    
    lbContent.numberOfLines = 0;
    [viewPKResult addSubview:lbContent];
    
    UserInfo * userInfo = [[ApplicationContext sharedInstance] accountInfo];
    
    if (_userInfoSender.proper_info.rankscore >= userInfo.proper_info.rankscore) {
        lbContent.text = [NSString stringWithFormat:@"%@ 主动 PK %@, 大获全胜。", _userInfoSender.nikename, userInfo.nikename];
    }
    else
    {
        lbContent.text = [NSString stringWithFormat:@"%@ 主动 PK %@, 大败亏输。", _userInfoSender.nikename, userInfo.nikename];
    }

    UIImageView *imgPk = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbContent.frame), CGRectGetWidth(viewBody.frame), CGRectGetWidth(viewBody.frame) * 1.5)];
    [imgPk sd_setImageWithURL:[NSURL URLWithString:_strPkResultUrl]
               placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    imgPk.contentMode = UIViewContentModeScaleAspectFit;
    imgPk.layer.masksToBounds = YES;
    [viewPKResult addSubview:imgPk];
    
    viewPKResult.frame = CGRectMake(0, 90, CGRectGetWidth(viewBody.frame), CGRectGetMaxY(imgPk.frame) + 10);
    viewPKResult.alpha = 0;
    
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
    lbFriends1.text = @"PK成功，你们已经是朋友了，可以相互聊天交流。";
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
        
        imgFriends.alpha = 1;
        lbFriends.alpha = 1;
        _viewDetail.alpha = 0;
        scrollViewUpdate.contentSize = CGSizeMake(scrollViewUpdate.frame.size.width, CGRectGetMaxY(viewPKResult.frame) + 60);
        
        UIImageView *imageViewTop = (UIImageView*)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
        UILabel *lbTitle = (UILabel*)[imageViewTop viewWithTag:GENERATE_VIEW_TITLE];
        [lbTitle setText:@"PK成功"];
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
                        viewPKResult.alpha = 1;
                        viewBottom.alpha = 1;
                    }];
                }
            }];
        }
    }];
}

-(void)loadPKShareData
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
             
             if (_strRecordId.length > 0) {
                 [[SportForumAPI sharedInstance]recordGetById:_strRecordId FinishedBlock:^(int errorCode, SportRecordInfo *sportRecordInfo){
                     [AlertManager dissmiss:processWin];
                     
                     if (errorCode == 0) {
                         _sportRecordInfo = sportRecordInfo;
                         [self generateDetailView];
                     }
                     else
                     {
                        [JDStatusBarNotification showWithStatus:@"网络不给力哦~" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                     }
                 }];
             }
             else
             {
                 [AlertManager dissmiss:processWin];
                 [self generateDetailView];
             }
         }
         else
         {
             [AlertManager dissmiss:processWin];
             [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
         }
     }];
}

#pragma mark Deck DataSource Protocol Methods

-(NSUInteger)numberOfPhotosInPhotoStackView:(PhotoStackView *)photoStack {
    return [_imageData count];
}

-(NSString *)photoStackView:(PhotoStackView *)photoStack photoForIndex:(NSUInteger)index {
    return [_imageData objectAtIndex:index];
}

#pragma mark Deck Delegate Protocol Methods

-(void)photoStackView:(PhotoStackView *)photoStackView willStartMovingPhotoAtIndex:(NSUInteger)index {
    // User started moving a photo
}

-(void)photoStackView:(PhotoStackView *)photoStackView willFlickAwayPhotoAtIndex:(NSUInteger)index {
    // User flicked the photo away, revealing the next one in the stack
}

-(void)photoStackView:(PhotoStackView *)photoStackView didRevealPhotoAtIndex:(NSUInteger)index {
    _pageControl.currentPage = index;
}

-(void)photoStackView:(PhotoStackView *)photoStackView didSelectPhotoAtIndex:(NSUInteger)index {
    [self onClickImageViewByIndex:index];
}

#pragma mark - MWPhotoBrowserDelegate

-(void)onClickImageViewByIndex:(NSUInteger)index
{
    [_photos removeAllObjects];
    
    for (NSString *strUrl in _imageData) {
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
