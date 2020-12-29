//
//  ArticlePagesViewController.m
//  SportForum
//
//  Created by liyuan on 3/26/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "ArticlePagesViewController.h"
#import "UIViewController+SportFormu.h"
#import "AlertManager.h"
#import "IQKeyboardManager.h"
#import "ArticleViewController.h"

#import "ContentWebViewController.h"

@interface ArticlePagesViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIAlertViewDelegate>

@end

@implementation ArticlePagesViewController
{
    UIPageViewController* _pageViewController;
    __weak ArticleViewController* _currentArticleViewController;
    
    UIAlertView* _alertView;
    
    id m_processWindow;
    UIActivityIndicatorView* _activityIndicatorView;
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
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicatorView.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    _activityIndicatorView.center = viewBody.center;
    _activityIndicatorView.hidden = NO;
    _activityIndicatorView.hidesWhenStopped = YES;
    [viewBody addSubview:_activityIndicatorView];
    
    _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                         navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                       options:nil];
    [_pageViewController setDataSource:self];
    [_pageViewController setDelegate:self];
    
    ArticleViewController* articleViewController = [self generateArticleView];
    
    if (_arrayArticleInfos.count > _currentIndex) {
        [_pageViewController setViewControllers:@[articleViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [viewBody addSubview:_pageViewController.view];
        _currentArticleViewController = articleViewController;
    }

    articleViewController = _currentArticleViewController;
    ArticlesObject *articlesObject = _arrayArticleInfos[_currentIndex];
    
    [self loadProcessShow:YES];
    
    __weak __typeof(self) weakself = self;
    
    [[SportForumAPI sharedInstance]articleGetByArticleId:articlesObject.article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            [self loadProcessShow:NO];
            
            if (errorCode == 0) {
                articleViewController.articleObject = articlesObject;
                [_arrayArticleInfos replaceObjectAtIndex:_currentIndex withObject:articlesObject];
                [[ApplicationContext sharedInstance]checkNewEvent:nil];
            }
            else
            {
                [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [MobClick beginLogPageView:@"ArticlePagesViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"ArticlePagesViewController"];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    [MobClick endLogPageView:@"ArticlePagesViewController"];
}

-(void)loadProcessShow:(BOOL)blShow {
    if (blShow) {
        [_activityIndicatorView startAnimating];
    } else {
        [_activityIndicatorView stopAnimating];
    }
}

-(void)showCommonProgress{
    if (m_processWindow) {
        [self hidenCommonProgress];
    }
    
    m_processWindow = [AlertManager showCommonProgress];
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:m_processWindow];
    m_processWindow = nil;
}

-(NSUInteger)indexOfAttentionObject:(ArticlesObject *)articleObject
{
    NSUInteger nIndex = [_arrayArticleInfos indexOfObject:articleObject];
    
    if (nIndex == NSNotFound) {
        for (ArticlesObject *object in _arrayArticleInfos) {
            if ([object.article_id isEqualToString:articleObject.article_id]) {
                nIndex = [_arrayArticleInfos indexOfObject:object];
                break;
            }
        }
    }
    
    return nIndex;
}

-(void)updateCurrentViewController:(UIViewController*)viewController
{
    ArticleViewController* articleViewController = (ArticleViewController*)viewController;
    
    NSUInteger nIndex = [self indexOfAttentionObject:articleViewController.articleObject];
    
    if (nIndex == NSNotFound) {
        return;
    }
    
    [self loadProcessShow:YES];
    
    __weak __typeof(self) weakself = self;
    
    [[SportForumAPI sharedInstance]articleGetByArticleId:articleViewController.articleObject.article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            [self loadProcessShow:NO];
            
            if (errorCode == 0) {
                articleViewController.articleObject = articlesObject;
                [_arrayArticleInfos replaceObjectAtIndex:nIndex withObject:articlesObject];
            }
            else
            {
                [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
            }
        }
    }];
}

- (ArticleViewController *)viewControllerByIndex:(NSUInteger)index {
    if (([self.arrayArticleInfos count] == 0) || (index >= [self.arrayArticleInfos count])) {
        return nil;
    }
    
    ArticleViewController* articleViewController = [self generateArticleView];
    ArticlesObject *articleObject = _arrayArticleInfos[index];
    articleViewController.articleObject = articleObject;

    /*[self loadProcessShow:YES];
    
    __weak __typeof(self) weakself = self;
    
    [[SportForumAPI sharedInstance]articleGetByArticleId:articleObject.article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            [self loadProcessShow:NO];
            
            if (errorCode == 0) {
                articleViewController.articleObject = articlesObject;
                [_arrayArticleInfos replaceObjectAtIndex:index withObject:articlesObject];
                
                NSLog(@"Current Index is %ld, index is %ld!", _currentIndex, index);
            }
        }
    }];*/
    
    return articleViewController;
}

-(NSUInteger)pageIndexByViewController:(UIViewController*)viewController {
    ArticleViewController*  articleViewController = (ArticleViewController*)viewController;
    return [_arrayArticleInfos indexOfObject:articleViewController.articleObject];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self pageIndexByViewController:viewController];
    
    if (_currentIndex != index) {
        [self updateCurrentViewController:viewController];
    }
    
    _currentIndex = index;
    
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    
    _currentArticleViewController = (ArticleViewController*)viewController;
    
    return [self viewControllerByIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self pageIndexByViewController:viewController];
    
    if (_currentIndex != index) {
        [self updateCurrentViewController:viewController];
    }
    
    _currentIndex = index;
    
    if (index == NSNotFound || index == [self.arrayArticleInfos count] - 1) {
        return nil;
    }
    
    _currentArticleViewController = (ArticleViewController*)viewController;
    
    return [self viewControllerByIndex:index + 1];
}

-(ArticleViewController*)generateArticleView
{
    ArticleViewController* articleViewController = [[ArticleViewController alloc]init];
    
    __weak __typeof(self) weakself = self;
    
    articleViewController.thumbBlock = ^(void)
    {
        __typeof(self) strongself = weakself;
        [strongself actionThumb];
    };
    
    articleViewController.shareBlock = ^(void)
    {
        __typeof(self) strongself = weakself;
        [strongself actionShare];
    };
    
    return articleViewController;
}

#pragma mark - Article operation

-(void)actionThumb {
    ArticlesObject* articlesObj = _arrayArticleInfos[_currentIndex];
    
    BOOL bIsThumbed = NO;
    
    if (articlesObj.isThumbed) {
        bIsThumbed = YES;
    }
    
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
        else if([userInfo.userid isEqualToString:articlesObj.authorInfo.userid])
        {
            [JDStatusBarNotification showWithStatus:@"你发表的文章，自己不可以点赞哦~" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
    }
    
    if ([articlesObj.relation isEqualToString:@"DEFRIEND"])
    {
        [JDStatusBarNotification showWithStatus:@"你已被拉黑，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }

    __weak __typeof(self) weakself = self;

    [[CommonUtility sharedInstance]playAudioFromName:(!bIsThumbed ? @"hot_like_large.mp3" : @"hot_like_timeout.mp3")];
    
    [self showCommonProgress];
    
    [[SportForumAPI sharedInstance]articleThumbByArticleId:articlesObj.article_id
                                               ThumbStatus:!bIsThumbed
                                             FinishedBlock:^(int errorCode, NSString* strDescErr, ExpEffect* expEffect){
                                                 if (errorCode == 0) {
                                                     
                                                     __typeof(self) strongself = weakself;
                                                     if (strongself == nil) {
                                                         return;
                                                     }
                                                     
                                                     [self hidenCommonProgress];
                                                     
                                                     UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                                                     
                                                     [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                                                      {
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect",nil]];
                                                      }];

                                                     if (bIsThumbed) {
                                                         articlesObj.thumb_count--;
                                                     }
                                                     else
                                                     {
                                                         articlesObj.thumb_count++;
                                                     }
                                                     
                            
                                                     if ([_currentArticleViewController.articleObject.article_id isEqualToString:articlesObj.article_id]) {
                                                         _currentArticleViewController.bRewardAction = !bIsThumbed;
                                                         [self updateCurrentViewController:_currentArticleViewController];
                                                     }
                                                 }
                                                 else
                                                 {
                                                     [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                 }
                                             }
     ];
}

-(void)shareToWeibo {
    ArticleViewController* currentArticleViewController =  (ArticleViewController*)_pageViewController.viewControllers[0];
    UIImage* image = [currentArticleViewController renderScrollViewToImage];
    
    [self showCommonProgress];
    
    __weak __typeof(self) weakself = self;
    
    [[CommonUtility sharedInstance]sinaWeiBoShare:image Content:@"分享了悦动力圈子博文。" FinishBlock:^void(int errorCode)
     {
         __typeof(self) strongself = weakself;
         
         if (strongself == nil) {
             return;
         }
         
         [self hidenCommonProgress];
         
         if (errorCode == 0) {
             NSString *strArtId = ((ArticlesObject*)_arrayArticleInfos[_currentIndex]).article_id;
             NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"ShareWeiBoInfo"];
             NSMutableDictionary * shareDict = [NSMutableDictionary dictionaryWithDictionary:dict];
             
             if (shareDict == nil) {
                 shareDict = [[NSMutableDictionary alloc]init];
             }
             
             [shareDict setObject:@(YES) forKey:strArtId];
             [[ApplicationContext sharedInstance] saveObject:shareDict byKey:@"ShareWeiBoInfo"];
             
             UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
             
             if(![((ArticlesObject*)_arrayArticleInfos[_currentIndex]).authorInfo.userid isEqualToString:userInfo.userid])
             {
                 [[SportForumAPI sharedInstance]userShareToFriends:^void(int errorCode, ExpEffect* expEffect){
                     if (errorCode == 0) {
                         UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                         
                         [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                          {
                              [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect",nil]];
                          }];
                     }
                 }];
             }
         }
     }];
}

-(void)actionShare {
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
    
    if ([((ArticlesObject*)_arrayArticleInfos[_currentIndex]).relation isEqualToString:@"DEFRIEND"])
    {
        [JDStatusBarNotification showWithStatus:@"你已被拉黑，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }
    
    NSString *strArtId = ((ArticlesObject*)_arrayArticleInfos[_currentIndex]).article_id;
    NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"ShareWeiBoInfo"];
    NSMutableDictionary * shareDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if (shareDict == nil) {
        shareDict = [[NSMutableDictionary alloc]init];
    }
    
    if ([[shareDict objectForKey:strArtId]boolValue]) {
        [JDStatusBarNotification showWithStatus:@"亲，该博文您已经分享过了，不可以重复分享哦！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleDefault];
    }
    else
    {
        _alertView = [[UIAlertView alloc] initWithTitle:@"分享" message:@"是否分享到微博？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
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
            [self shareToWeibo];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
