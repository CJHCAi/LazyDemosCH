//
//  ContentWebViewController.m
//  SportForum
//
//  Created by liyuan on 3/19/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "ContentWebViewController.h"
#import "UIViewController+SportFormu.h"
#import "TFHpple.h"
#import "MWPhotoBrowser.h"
#import "AlertManager.h"
#import "UIImageView+WebCache.h"
#import "ChatMessageTableViewController.h"
#import "AccountPreViewController.h"
#import "RegexKitLite.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SGActionView.h"

@interface ContentWebViewController ()<MWPhotoBrowserDelegate, UIAlertViewDelegate>

@end

@implementation ContentWebViewController
{
    UILabel *_lbUserViewSep;
    UIWebView * _contentWebView;
    UIView *_viewRecord;
    UIScrollView* _scrollView;
    
    NSMutableArray *_imgConArray;
    NSMutableArray *_photos;
    
    BOOL _isVideo;
    BOOL _isLoadingFinished;
    BOOL _bShareCircle;
    NSString *_strHtmlContent;
    
    UIAlertView* _alertView;
    id _processWin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
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
        [strongSelf customShareMenuItemsHandler];
    };
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    [viewBody addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setAlwaysBounceHorizontal:NO];
    [_scrollView setAlwaysBounceVertical:YES];

    [self generateUserInfoControls];
    
    _contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_lbUserViewSep.frame), CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    _contentWebView.scrollView.scrollEnabled = NO;
    [_contentWebView setScalesPageToFit:NO];
    _contentWebView.delegate = self;
    _contentWebView.backgroundColor = APP_MAIN_BG_COLOR;
    _contentWebView.opaque = NO;
    [_scrollView addSubview:_contentWebView];
    
    if ([_articlesObject.type isEqualToString:@"record"]) {
        _viewRecord = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentWebView.frame), CGRectGetWidth(viewBody.frame), 50)];
        _viewRecord.backgroundColor = [UIColor clearColor];
        _viewRecord.hidden = YES;
        [_scrollView addSubview:_viewRecord];
        
        [self generateRecordView];
        _contentWebView.frame = CGRectMake(0, CGRectGetMaxY(_lbUserViewSep.frame), CGRectGetWidth(viewBody.frame), 1);
    }
    
    _bShareCircle = NO;
    [self loadWebView];
}

-(void)generateUserInfoControls
{
    UIImageView *imageViewProfile = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 60, 60)];
    imageViewProfile.layer.cornerRadius = 10.0;
    imageViewProfile.layer.masksToBounds = YES;
    [imageViewProfile sd_setImageWithURL:[NSURL URLWithString:_articlesObject.authorInfo.profile_image] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    [_scrollView addSubview:imageViewProfile];
    
    CSButton* btnUserInfo = [CSButton buttonWithType:UIButtonTypeCustom];
    btnUserInfo.frame = CGRectMake(5, 10, 120, 60);
    btnUserInfo.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:btnUserInfo];
    [_scrollView bringSubviewToFront:btnUserInfo];
    
    __weak __typeof(self) weakself = self;
    
    btnUserInfo.actionBlock = ^(void){
        __typeof(self) strongself = weakself;
        AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
        accountPreViewController.strUserId = strongself.articlesObject.authorInfo.userid;
        [strongself.navigationController pushViewController:accountPreViewController animated:YES];
    };
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageViewProfile.frame) + 10, CGRectGetMinY(imageViewProfile.frame), 200, 20)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont boldSystemFontOfSize:12];
    lblTitle.textColor = [UIColor blackColor];
    lblTitle.text = _articlesObject.authorInfo.nikename;
    [_scrollView addSubview:lblTitle];
    
    UIImageView *sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(lblTitle.frame), CGRectGetMaxY(lblTitle.frame) + 5, 40, 18)];
    sexTypeImageView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:sexTypeImageView];
    
    UILabel *lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, CGRectGetMinY(sexTypeImageView.frame) + 2, 20, 10)];
    lbAge.backgroundColor = [UIColor clearColor];
    lbAge.textColor = [UIColor whiteColor];
    lbAge.font = [UIFont systemFontOfSize:10];
    lbAge.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:lbAge];
    
    [sexTypeImageView setImage:[UIImage imageNamed:[_articlesObject.authorInfo.sex_type isEqualToString:sex_male] ? @"gender-male" : @"gender-female"]];
    lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:_articlesObject.authorInfo.birthday];
    
    CGFloat fStartPoint = CGRectGetMaxX(sexTypeImageView.frame) + 4;
    
    if (_articlesObject.authorInfo.phone_number.length > 0) {
        UIImageView *imgViePhone = [[UIImageView alloc]init];
        [imgViePhone setImage:[UIImage imageNamed:@"phone-verified-small"]];
        imgViePhone.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:imgViePhone];
        
        imgViePhone.frame = CGRectMake(fStartPoint, CGRectGetMinY(sexTypeImageView.frame) + 2, 8, 14);
        fStartPoint = CGRectGetMaxX(imgViePhone.frame) + 2;
    }
    
    if ([_articlesObject.authorInfo.actor isEqualToString:@"coach"]) {
        UIImageView *imgVieCoach = [[UIImageView alloc]init];
        [imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
        imgVieCoach.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:imgVieCoach];
        imgVieCoach.frame = CGRectMake(fStartPoint, CGRectGetMinY(sexTypeImageView.frame) - 1, 20, 20);
    }
    
    UILabel *lbPublishTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(lblTitle.frame), CGRectGetMaxY(sexTypeImageView.frame) + 5, 200, 20)];
    lbPublishTime.backgroundColor = [UIColor clearColor];
    lbPublishTime.font = [UIFont systemFontOfSize:10];
    lbPublishTime.textColor = [UIColor darkGrayColor];
    [_scrollView addSubview:lbPublishTime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_articlesObject.time];
    NSString *strDate = [dateFormatter stringFromDate:date];
    lbPublishTime.text = [NSString stringWithFormat:@"%@发布", strDate];
    
    if (_articlesObject.coach_review_count > 0) {
        CSButton* btnTutor = [CSButton buttonWithType:UIButtonTypeCustom];
        btnTutor.frame = CGRectMake(310 - 32, CGRectGetMinY(lbPublishTime.frame), 27, 17);
        btnTutor.backgroundColor = [UIColor clearColor];
        [btnTutor setImage:[UIImage imageNamed:@"blog-tutor"] forState:UIControlStateNormal];
        [_scrollView addSubview:btnTutor];
        [_scrollView bringSubviewToFront:btnTutor];
        
        __weak __typeof(self) weakself = self;
        
        btnTutor.actionBlock = ^(void){
            __typeof(self) strongself = weakself;
            
            UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
            
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
            
            ChatMessageTableViewController *chatMessageTableViewController = [[ChatMessageTableViewController alloc]init];
            chatMessageTableViewController.bTutorChat = YES;
            chatMessageTableViewController.bNoSendAction = ([userInfo.actor isEqualToString:@"coach"] || [userInfo.userid isEqualToString:strongself->_articlesObject.authorInfo.userid]) ? NO : YES;
            chatMessageTableViewController.strArticleId = strongself->_articlesObject.article_id;
            [strongself.navigationController pushViewController:chatMessageTableViewController animated:YES];
        };
    }

    
    _lbUserViewSep = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageViewProfile.frame) + 10, CGRectGetWidth(_scrollView.frame), 0.5)];
    _lbUserViewSep.backgroundColor = [UIColor lightGrayColor];
    [_scrollView addSubview:_lbUserViewSep];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AlertView Logic

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
            [self shareToWeibo];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"文章预览 - ContentWebViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"文章预览 - ContentWebViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"文章预览 - ContentWebViewController"];
    [self hideCommonProcess];
}

- (UIImage*) renderScrollViewToImage
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen screenWidth], _scrollView.contentSize.height),NO,0.0f);
    {
        CGPoint savedContentOffset = _scrollView.contentOffset;
        CGRect savedFrame = _scrollView.frame;
        
        _scrollView.contentOffset = CGPointZero;
        _scrollView.frame = CGRectMake(0, 0, 310, _scrollView.contentSize.height);
        
        [_scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        _scrollView.contentOffset = savedContentOffset;
        _scrollView.frame = savedFrame;
    }
    
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)shareToWeibo {
    UIImage* image = [self renderScrollViewToImage];
    
    id processWin = [AlertManager showCommonProgress];
    
    __weak __typeof(self) weakself = self;
    
    [[CommonUtility sharedInstance]sinaWeiBoShare:image Content:@"分享了悦动力圈子博文。" FinishBlock:^void(int errorCode)
     {
         __typeof(self) strongself = weakself;
         
         if (strongself == nil) {
             return;
         }
         
         [AlertManager dissmiss:processWin];
         
         if (errorCode == 0) {
             NSString *strArtId = _articlesObject.refer_article.length > 0 ? _articlesObject.refer_article : _articlesObject.article_id;
             NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"ArticleShareWeiBoInfo"];
             NSMutableDictionary * shareDict = [NSMutableDictionary dictionaryWithDictionary:dict];
             
             if (shareDict == nil) {
                 shareDict = [[NSMutableDictionary alloc]init];
             }
             
             [shareDict setObject:@(YES) forKey:strArtId];
             [[ApplicationContext sharedInstance] saveObject:shareDict byKey:@"ArticleShareWeiBoInfo"];
             
             UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
             
             if(![_articlesObject.authorInfo.userid isEqualToString:userInfo.userid])
             {
                 [[SportForumAPI sharedInstance]userShareToFriends:^void(int errorCode, ExpEffect* expEffect){
                     if (errorCode == 0) {
                         UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                         
                         [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                          {
                              [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                          }];
                     }
                 }];
             }
         }
     }];
}

-(void)actionShare {
    NSString *strArtId = _articlesObject.refer_article.length > 0 ? _articlesObject.refer_article : _articlesObject.article_id;
    NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"ArticleShareWeiBoInfo"];
    NSMutableDictionary * shareDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if (shareDict != nil && [[shareDict objectForKey:strArtId]boolValue]) {
        [JDStatusBarNotification showWithStatus:@"亲，该博文您已经分享过了，不可以重复分享哦！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleDefault];
    }
    else
    {
        _alertView = [[UIAlertView alloc] initWithTitle:@"分享" message:@"是否分享到微博？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        _alertView.tag = 10;
        [_alertView show];
    }
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

- (void)customShareMenuItemsHandler
{
    __weak __typeof(self) weakSelf = self;

    if ([_articlesObject.type isEqualToString:@"record"]) {
        [SGActionView showGridMenuWithTitle:@"博文分享"
                                 itemTitles:@[ @"微博分享"]
                                     images:@[ [UIImage imageNamed:@"weibo"]]
                             selectedHandle:^(NSInteger index){
                                 __typeof(self) strongSelf = weakSelf;
                                 
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
                                 
                                 if ([strongSelf->_articlesObject.relation isEqualToString:@"DEFRIEND"])
                                 {
                                     [JDStatusBarNotification showWithStatus:@"你已被拉黑，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                                     return;
                                 }
                                 
                                 if (index == 1) {
                                     [strongSelf actionShare];
                                 }
                                 else if(index == 2)
                                 {
                                     NSString *strArticleId = strongSelf->_articlesObject.refer_article.length > 0 ? strongSelf->_articlesObject.refer_article : strongSelf->_articlesObject.article_id;
                                     NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"ArticleShareAttention"];
                                     NSMutableDictionary * shareDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                                     
                                     if (shareDict != nil && [[shareDict objectForKey:strArticleId]boolValue]) {
                                         [JDStatusBarNotification showWithStatus:@"亲，您已经分享过了，不可以重复分享哦！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                                     }
                                 }
                             }];
    }
    else
    {
        [SGActionView showGridMenuWithTitle:@"博文分享"
                                 itemTitles:@[ @"微博分享", @"关注动态"]
                                     images:@[ [UIImage imageNamed:@"weibo"],
                                               [UIImage imageNamed:@"discover-status"]]
                             selectedHandle:^(NSInteger index){
                                 __typeof(self) strongSelf = weakSelf;
                                 
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
                                 
                                 if ([strongSelf->_articlesObject.relation isEqualToString:@"DEFRIEND"])
                                 {
                                     [JDStatusBarNotification showWithStatus:@"你已被拉黑，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                                     return;
                                 }
                                 
                                 if (index == 1) {
                                     [strongSelf actionShare];
                                 }
                                 else if(index == 2)
                                 {
                                     NSString *strArticleId = strongSelf->_articlesObject.refer_article.length > 0 ? strongSelf->_articlesObject.refer_article : strongSelf->_articlesObject.article_id;
                                     NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"ArticleShareAttention"];
                                     NSMutableDictionary * shareDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                                     
                                     if (shareDict != nil && [[shareDict objectForKey:strArticleId]boolValue]) {
                                         [JDStatusBarNotification showWithStatus:@"亲，您已经分享过了，不可以重复分享哦！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                                     }
                                     else
                                     {
                                         [strongSelf showCommonProcess];
                                         
                                         [[SportForumAPI sharedInstance]articleRepostByArticleId:strArticleId Latitude:userInfo.latitude Longitude:userInfo.longitude FinishedBlock:^void(int errorCode)
                                          {
                                              [strongSelf hideCommonProcess];
                                              
                                              if (errorCode == 0) {
                                                  NSString *strArtId = strArticleId;
                                                  NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"ArticleShareAttention"];
                                                  NSMutableDictionary * shareDict = [NSMutableDictionary dictionaryWithDictionary:dict];
                                                  
                                                  if (shareDict == nil) {
                                                      shareDict = [[NSMutableDictionary alloc]init];
                                                  }
                                                  
                                                  [shareDict setObject:@(YES) forKey:strArtId];
                                                  [[ApplicationContext sharedInstance] saveObject:shareDict byKey:@"ArticleShareAttention"];
                                                  [JDStatusBarNotification showWithStatus:@"分享成功。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleSuccess];
                                              }
                                              else
                                              {
                                                  [JDStatusBarNotification showWithStatus:@"分享失败。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                              }
                                          }];
                                     }
                                 }
                             }];
    }
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
    lbSportDistance.tag = 20000;
    [_viewRecord addSubview:lbSportDistance];
    
    UILabel *lbSportDuration = [[UILabel alloc]init];
    lbSportDuration.backgroundColor = [UIColor clearColor];
    lbSportDuration.textColor = [UIColor blackColor];
    lbSportDuration.font = [UIFont boldSystemFontOfSize:14];
    lbSportDuration.textAlignment = NSTextAlignmentRight;
    lbSportDuration.frame = CGRectMake(CGRectGetMaxX(lbSportDistance.frame), CGRectGetMinY(lbSportDistance.frame), 310 - 5 - CGRectGetMaxX(lbSportDistance.frame), 30);
    lbSportDuration.tag = 20001;
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
    lbSportDate.tag = 20002;
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
    lbSportSpeedSet.tag = 20010;
    [_viewRecord addSubview:lbSportSpeedSet];
    
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
    lbSportSpeed.tag = 20003;
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
    lbSportCal.tag = 20004;
    [_viewRecord addSubview:lbSportCal];
    
    UIImageView *imgViewHeatRate = [[UIImageView alloc]init];
    [imgViewHeatRate setImage:[UIImage imageNamed:@"data-record-heartRate"]];
    imgViewHeatRate.frame = CGRectMake(CGRectGetMinX(lbSportDistance.frame), CGRectGetMaxY(imgViewSpeed.frame) + 5, 20, 20);
    imgViewHeatRate.tag = 20011;
    [_viewRecord addSubview:imgViewHeatRate];
    
    UILabel *lbSportHeatRate = [[UILabel alloc]init];
    lbSportHeatRate.backgroundColor = [UIColor clearColor];
    lbSportHeatRate.textColor = [UIColor darkGrayColor];
    lbSportHeatRate.font = [UIFont boldSystemFontOfSize:14];
    lbSportHeatRate.textAlignment = NSTextAlignmentLeft;
    lbSportHeatRate.frame = CGRectMake(CGRectGetMaxX(imgViewHeatRate.frame) + 5, CGRectGetMinY(imgViewHeatRate.frame), 310 - 5 - CGRectGetMaxX(imgViewHeatRate.frame) - 5, 20);
    lbSportHeatRate.tag = 20012;
    [_viewRecord addSubview:lbSportHeatRate];

    UILabel *lbSportSource = [[UILabel alloc]init];
    lbSportSource.backgroundColor = [UIColor clearColor];
    lbSportSource.textColor = [UIColor darkGrayColor];
    lbSportSource.font = [UIFont boldSystemFontOfSize:14];
    lbSportSource.textAlignment = NSTextAlignmentLeft;
    lbSportSource.frame = CGRectMake(CGRectGetMinX(imgViewHeatRate.frame), CGRectGetMaxY(imgViewHeatRate.frame) + 5, 310 - 5 - CGRectGetMinX(imgViewHeatRate.frame), 20);
    lbSportSource.tag = 20005;
    [_viewRecord addSubview:lbSportSource];
    
    UIImageView *imgViewAuth = [[UIImageView alloc]init];
    imgViewAuth.tag = 20006;
    [_viewRecord addSubview:imgViewAuth];
    
    UILabel *lbSportAuth = [[UILabel alloc]init];
    lbSportAuth.backgroundColor = [UIColor clearColor];
    lbSportAuth.textColor = [UIColor darkGrayColor];
    lbSportAuth.font = [UIFont boldSystemFontOfSize:14];
    lbSportAuth.textAlignment = NSTextAlignmentLeft;
    lbSportAuth.tag = 20007;
    [_viewRecord addSubview:lbSportAuth];
    
    UILabel *lbSportLock = [[UILabel alloc]init];
    lbSportLock.backgroundColor = [UIColor clearColor];
    lbSportLock.textColor = [UIColor darkGrayColor];
    lbSportLock.font = [UIFont boldSystemFontOfSize:14];
    lbSportLock.textAlignment = NSTextAlignmentRight;
    lbSportLock.tag = 20008;
    [_viewRecord addSubview:lbSportLock];
    
    UIImageView *imgViewLock = [[UIImageView alloc]init];
    imgViewLock.tag = 20009;
    [_viewRecord addSubview:imgViewLock];
    
    UILabel *lbRefused = [[UILabel alloc]init];
    lbRefused.backgroundColor = [UIColor clearColor];
    lbRefused.textColor = [UIColor darkGrayColor];
    lbRefused.font = [UIFont boldSystemFontOfSize:14];
    lbRefused.textAlignment = NSTextAlignmentLeft;
    lbRefused.numberOfLines = 0;
    lbRefused.tag = 20013;
    lbRefused.hidden = YES;
    [_viewRecord addSubview:lbRefused];
}

-(void)updateRecordView
{
    UILabel *lbSportDistance = (UILabel*)[_viewRecord viewWithTag:20000];
    UILabel *lbSportDuration = (UILabel*)[_viewRecord viewWithTag:20001];
    UILabel *lbSportDate = (UILabel*)[_viewRecord viewWithTag:20002];
    UILabel *lbSportSpeedSet = (UILabel*)[_viewRecord viewWithTag:20010];
    UILabel *lbSportSpeed = (UILabel*)[_viewRecord viewWithTag:20003];
    UILabel *lbSportCal = (UILabel*)[_viewRecord viewWithTag:20004];
    UILabel *lbSportSource = (UILabel*)[_viewRecord viewWithTag:20005];
    UIImageView *imgViewAuth = (UIImageView*)[_viewRecord viewWithTag:20006];
    UILabel *lbSportAuth = (UILabel*)[_viewRecord viewWithTag:20007];
    UILabel *lbSportLock = (UILabel*)[_viewRecord viewWithTag:20008];
    UIImageView *imgViewLock = (UIImageView*)[_viewRecord viewWithTag:20009];
    UIImageView *imgViewHeatRate = (UIImageView*)[_viewRecord viewWithTag:20011];
    UILabel *lbSportHeatRate = (UILabel*)[_viewRecord viewWithTag:20012];
    UILabel *lbRefused = (UILabel*)[_viewRecord viewWithTag:20013];
    
    lbSportDistance.text = [NSString stringWithFormat:@"距离：%.2f km", _articlesObject.record.distance / 1000.00];
    lbSportDuration.text = [NSString stringWithFormat:@"持续时间：%ld分钟", _articlesObject.record.duration / 60];
    
    NSInteger nSpeedSet = _articlesObject.record.duration / (_articlesObject.record.distance / 1000.00);
    lbSportSpeedSet.text = [NSString stringWithFormat:@"%ld' %ld'' km", nSpeedSet / 60,   nSpeedSet % 60];
    
    NSDate * beginDay = [NSDate dateWithTimeIntervalSince1970:_articlesObject.record.begin_time];
    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginDay];
    lbSportDate.text = [NSString stringWithFormat:@"%02ld/%02ld/%04ld %.2ld:%.2ld", [comps month], [comps day], [comps year], [comps hour], [comps minute]];
    lbSportSpeed.text = [NSString stringWithFormat:@"%.2f km/h", (_articlesObject.record.distance / 1000.00) / (_articlesObject.record.duration / 3600.00)];
    lbSportCal.text = [NSString stringWithFormat:@"%.0f cal", _articlesObject.record.weight * _articlesObject.record.distance / 800.0]; //跑步热量（kcal）＝体重（kg）×运动时间（小时）×指数K(指数K＝30÷速度（分钟/400米)
    
    CGRect rectPosition = lbSportCal.frame;
    imgViewHeatRate.hidden = YES;
    lbSportHeatRate.hidden = YES;
    lbRefused.hidden = YES;
    
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
    
    if ([_articlesObject.authorInfo.userid isEqualToString:[[ApplicationContext sharedInstance] accountInfo].userid] && [_articlesObject.type isEqualToString:@"record"])
    {
        imgViewAuth.hidden = NO;
        lbSportAuth.hidden = NO;
        lbSportLock.hidden = NO;
        imgViewLock.hidden = NO;
        
        NSString *strStatus;
        UIImage *img = nil;
        
        switch ([CommonFunction ConvertStringToTaskStatusType:_articlesObject.record.status]) {
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
        
        lbSportLock.text = _articlesObject.isPublic ? @"所有人可见" : @"仅自己可见";
        lbSportLock.frame = CGRectMake(310 - 75, CGRectGetMinY(imgViewAuth.frame), 70, 20);
        
        [imgViewLock setImage:[UIImage imageNamed:_articlesObject.isPublic ? @"blog-public" : @"blog-private"]];
        imgViewLock.frame = CGRectMake(310 - 75 - 23, CGRectGetMinY(imgViewAuth.frame) + 2, 17, 17);
        rectPosition = imgViewAuth.frame;
        
        if ([CommonFunction ConvertStringToTaskStatusType:_articlesObject.record.status] == e_task_unfinish) {
            lbRefused.hidden = NO;
            lbRefused.text = [NSString stringWithFormat:@"审核未通过原因：%@", _articlesObject.record.result.length > 0 ? _articlesObject.record.result : @"非常抱歉，您的任务审核未通过。"];
            
            NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            CGSize lbSize = [lbRefused.text boundingRectWithSize:CGSizeMake(300, FLT_MAX)
                                               options:options
                                            attributes:@{NSFontAttributeName:lbRefused.font} context:nil].size;
            lbRefused.frame = CGRectMake(CGRectGetMinX(lbSportSource.frame), CGRectGetMaxY(imgViewLock.frame) + 10, 300, lbSize.height + 5);
            
            rectPosition = lbRefused.frame;
        }
    }
    else
    {
        imgViewAuth.hidden = YES;
        lbSportAuth.hidden = YES;
        lbSportLock.hidden = YES;
        imgViewLock.hidden = YES;
    }

    CGRect frame = _viewRecord.frame;
    frame.size.height = CGRectGetMaxY(rectPosition) + 10;
    frame.origin.y = CGRectGetMaxY(_contentWebView.frame);
    
    _viewRecord.frame = frame;
    _viewRecord.hidden = NO;
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, CGRectGetMaxY(_viewRecord.frame));
}

-(NSString*)replaceAtString:(NSString*)strSource
{
    NSString *strReturn = strSource;
    //NSArray *matchArray = [strSource componentsMatchedByRegex:@"@([0-9a-zA-Z\u4e00-\u9fa5_-]+)"];
    
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
                    //NSString *path = [[NSBundle mainBundle] pathForResource:@"video_icon" ofType:@"png"];
                    //path = [NSString stringWithFormat:@"file://%@", path];
                    
                    //[strBody appendString:[NSString stringWithFormat:@"<video src=\"%@\" controls=\"controls\">您的浏览器不支持 video 标签。</video>", list.lastObject]];
                    //[strBody appendString:[NSString stringWithFormat:@"<img class=\"divimg\" src=\"%@\"><img style=\"position:absolute; top:0px; left:0px;\" src=\"%@\" /></img>", list.firstObject, path]];
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

-(void)loadWebView{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc]init];
    }
    
    if (_imgConArray == nil) {
        _imgConArray = [[NSMutableArray alloc]init];
    }
    
    [_photos removeAllObjects];
    [_imgConArray removeAllObjects];
    
    //html是否加载完成
    _isLoadingFinished = NO;
    _strHtmlContent = [self convertSegmentsToHtml];
    [self getAllUrlImgUrlsFromHtml];
    [_contentWebView loadHTMLString:_strHtmlContent baseURL:nil];
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

-(void)onClickVideoPreView:(NSString*)strUrl
{
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    //CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
    //[moviePlayerViewController.view setTransform:transform];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}

-(void)onClickImageViewByIndex:(NSUInteger)index
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
    
    if ([_imgConArray count] == 0) {
        return;
    }
    
    [_photos removeAllObjects];
    
    for (NSString *strUrl in _imgConArray) {
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:strUrl]]];
    }
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
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
        
        [_imgConArray addObject:imgUrl];
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
    //requestString=[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    requestString = [requestString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *components = [requestString componentsSeparatedByString:@":"];
    
    if ([components count] >= 1) {
        //判断是不是图片点击
        if ([(NSString *)[components objectAtIndex:0]isEqualToString:strUrlPre]) {
            NSString *strUrl = [requestString substringFromIndex:strUrlPre.length + 1];
            
            if (strUrl.length > 0) {
                NSUInteger nIndex = [_imgConArray indexOfObject:strUrl];
                [self onClickImageViewByIndex:nIndex];
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
            frame.size.width = 310;
            aWebView.frame = frame;
            
            [_contentWebView stringByEvaluatingJavaScriptFromString:[self createJavaScript]];
            [_contentWebView stringByEvaluatingJavaScriptFromString:@"setImage()"];
            
            NSLog(@"size: %f, %f", frame.size.width, frame.size.height);
            _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, CGRectGetMaxY(_contentWebView.frame) + 20);
            return;
        }
        
        //js获取body宽度
        NSString *bodyWidth= [_contentWebView stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth "];
        
        int widthOfBody = [bodyWidth intValue];
        
        //获取实际要显示的html
        NSString *html = [self htmlAdjustWithPageWidth:widthOfBody
                                                  html:_strHtmlContent
                                               webView:_contentWebView];
        _isLoadingFinished = YES;
        [_contentWebView loadHTMLString:html baseURL:nil];
    }
    else
    {
        CGRect frame = aWebView.frame;
        frame.size.height = 1;
        aWebView.frame = frame;
        CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        aWebView.frame = frame;
        [_contentWebView stringByEvaluatingJavaScriptFromString:[self createJavaScript]];
        [_contentWebView stringByEvaluatingJavaScriptFromString:@"setImage()"];
        NSLog(@"size: %f, %f", frame.size.width, frame.size.height);
        _isLoadingFinished = YES;
        
        if([_articlesObject.type isEqualToString:@"record"])
        {
            [self updateRecordView];
        }
        else
        {
            _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, CGRectGetMaxY(_contentWebView.frame) + 20);
        }
    }

    
    /*if([_articlesObject.type isEqualToString:@"record"])
    {
        CGRect frame = aWebView.frame;
        frame.size.height = 1;
        aWebView.frame = frame;
        CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        aWebView.frame = frame;
        [_contentWebView stringByEvaluatingJavaScriptFromString:[self createJavaScript]];
        [_contentWebView stringByEvaluatingJavaScriptFromString:@"setImage()"];
        NSLog(@"size: %f, %f", frame.size.width, frame.size.height);
        _isLoadingFinished = YES;
        
        [self updateRecordView];
    }
    else
    {
        [aWebView stringByEvaluatingJavaScriptFromString:[self createJavaScript]];
        [aWebView stringByEvaluatingJavaScriptFromString:@"setImage()"];
    }*/
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
    NSString *stringForReplace = [NSString stringWithFormat:@"<meta charset=\"UTF-8\" name=\"viewport\" content=\" initial-scale=%f, minimum-scale=1.0, maximum-scale=1.0, user-scalable=yes\"></head>",initialScale];
    
    NSRange range =  NSMakeRange(0, str.length);
    //替换
    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    return str;
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
