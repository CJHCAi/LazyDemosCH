//
//  CSNavigationController.m
//  SportForum
//
//  Created by liyuan on 14-8-14.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "CSNavigationController.h"
#import "RKTabView.h"
#import "AlertManager.h"
#import "SRWebSocket.h"
#import "AppNotification.h"
#import "LBSLocationManager.h"
#import "MMLocationManager.h"
#import "UIImageView+WebCache.h"
#import "THLabel.h"

#import "StartLoginViewController.h"
#import "MainViewController.h"
#import "NearByViewController.h"
#import "ContactsViewController.h"
#import "AccountInfoViewController.h"
#import "VideoViewController.h"

#import "PublishSelectionView.h"
#import "ArticlePublicViewController.h"
#import "RecordSportViewController.h"
#import "GameViewController.h"

#import "LoginEmailViewController.h"
#import "RegisterEmailViewController.h"
#import "BindPhoneViewController.h"
#import "RegisterInfoViewController.h"
#import "RecommendViewController.h"
#import "UIAnimationFailView.h"
#import "UIAnimationSuccessView.h"
#import "UIViewAnimationLevel.h"

#import "ArticlePagesViewController.h"
#import "RecordReceiveHeartViewController.h"
#import "RunShareViewController.h"
#import "ThumbShareViewController.h"
#import "PKShareViewController.h"
#import "AccountPreViewController.h"
#import "AccountEditViewController.h"

#import <AudioToolbox/AudioToolbox.h>

#define BAR_HEIGHT 49.0
#define BAR_WIDTH [UIScreen mainScreen].bounds.size.width

typedef void (^TabBarBlock)();
typedef void (^TabBarCompletion)(BOOL finished);

@interface CSNavigationController ()<SRWebSocketDelegate, UIGestureRecognizerDelegate>

@end

@implementation CSNavigationController
{
    UIView *m_viewAnimation;
    UIAnimationFailView *m_viewAnimationFail;
    UIAnimationSuccessView *m_viewAnimationSuccess;
    UIViewAnimationLevel *m_viewAnimationLevel;
    RKTabView *m_titledTabsView;
    
    StartLoginViewController* _startLoginViewController;
    MainViewController* _mainViewController;
    NearByViewController *_nearByViewController;
    ContactsViewController *_contactsViewController;
    AccountInfoViewController *_accountInfoViewController;
    PublishSelectionView* _publishSelectionView;
    VideoViewController* _videoViewController;

    id m_processWindow;
    id m_proWinImport;
    long long m_lLastTime;
    BOOL m_bTokenVaild;
    BOOL m_bCheckAfterZero;
    BOOL m_bNetWorkTips;
    BOOL m_tabBarHidden;
    SRWebSocket *_webSocket;
    NSTimer * m_timeReconnect;
    NSTimer * m_timeCheckEvent;
    NSTimer * m_timeCheckNewAttention;
    NSTimer * m_timeSetDeviceToken;
    NSTimer * m_timeCheckAfterZero;
    NSTimer *m_timerReward;
    
    NSMutableArray *m_arrChatInfo;
    NSMutableArray *m_arrSystemNotifyInfo;
    
    TabBarBlock m_tabBarBlock;
    TabBarCompletion m_tabBarCompletion;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        __weak id delegate = self;
        self.delegate = delegate;
        m_timeReconnect = nil;
        m_timeCheckEvent = nil;
        m_timeCheckNewAttention = nil;
        m_timeCheckAfterZero = nil;
        m_arrChatInfo = [[NSMutableArray alloc]init];
        m_arrSystemNotifyInfo = [[NSMutableArray alloc]init];

        _startLoginViewController = [[StartLoginViewController alloc]init];
        _mainViewController = [[MainViewController alloc]init];
        _nearByViewController = [[NearByViewController alloc]init];
        _contactsViewController = [[ContactsViewController alloc]init];
        _accountInfoViewController = [[AccountInfoViewController alloc]init];
        _videoViewController = [[VideoViewController alloc]init];
    }
    return self;
}

-(void)initNotifyMsg
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAuthLoginSuccess:) name:NOTIFY_MESSAGE_AUTH_LOGIN_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogoutSuccess) name:NOTIFY_MESSAGE_LOGOUT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSwitchViewController:) name:NOTIFY_MESSAGE_SWITCH_VIEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateMsgStatus) name:NOTIFY_MESSAGE_MSG_LIST_UPDATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo:) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAnimationState:) name:NOTIFY_MESSAGE_ANIMATION_STATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWebSocketMsgComing:) name:NOTIFY_MESSAGE_WEBSOCKET_COMING object:nil];
}

-(void)initFootBarTabItem
{
    __typeof__(self) __weak thisPointer = self;
    
    m_tabBarBlock = ^(){
        __typeof__(self) thisPointerStrong = thisPointer;
        CGSize viewSize = thisPointerStrong.view.bounds.size;
        CGFloat tabBarStartingY = viewSize.height;
        CGFloat tabBarHeight = CGRectGetHeight([thisPointerStrong->m_titledTabsView frame]);
        
        if (!tabBarHeight) {
            tabBarHeight = BAR_HEIGHT;
        }
        
        if (!thisPointerStrong->m_tabBarHidden) {
            tabBarStartingY = viewSize.height - tabBarHeight;
            [thisPointerStrong->m_titledTabsView setHidden:NO];
        }
        
        [thisPointerStrong->m_titledTabsView setFrame:CGRectMake(0, tabBarStartingY, viewSize.width, tabBarHeight)];
        
        double fAvailMemory = [[CommonUtility sharedInstance]availableMemory];
        double fUsedMemory = [[CommonUtility sharedInstance]usedMemory];
        
        NSLog(@"Avail Memory is %f, Used Memory is %f!", fAvailMemory, fUsedMemory);
        
        if (fUsedMemory > 200.00) {
            [[SDImageCache sharedImageCache] clearMemory];
        }
    };
    
    m_tabBarCompletion = ^(BOOL finished){
        __typeof__(self) thisPointerStrong = thisPointer;
        
        if (thisPointerStrong->m_tabBarHidden) {
            [thisPointerStrong->m_titledTabsView setHidden:YES];
        }
    };
    
    RKTabItem *mastercardTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"bot-bar-home -pressed"] imageDisabled:[UIImage imageNamed:@"bot-bar-home"] Action:^(void){
        __typeof__(self) thisPointerStrong = thisPointer;
        [thisPointerStrong switchViewController:thisPointerStrong->_mainViewController];
    }];
    mastercardTabItem.titleString = @"主页";
    
    RKTabItem *paypalTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"bot-bar-discover-sel"] imageDisabled:[UIImage imageNamed:@"bot-bar-discover"] Action:^(void){
        __typeof__(self) thisPointerStrong = thisPointer;
        [thisPointerStrong switchViewController:thisPointerStrong->_nearByViewController];
    }];
    paypalTabItem.titleString = @"发现";
    
    //RKTabItem *newRecord = [RKTabItem createButtonItemWithImage:[UIImage imageNamed:@"bot-bar-plus"] target:self selector:@selector(openPublishMenu:)];
    
    RKTabItem *videoTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"bot-bar-video-sel"] imageDisabled:[UIImage imageNamed:@"bot-bar-video"] Action:^(void){
        __typeof__(self) thisPointerStrong = thisPointer;
        [thisPointerStrong switchViewController:thisPointerStrong->_videoViewController];
    }];
    videoTabItem.titleString = @"";
    
    RKTabItem *wuTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"bot-bar-contact-selected"] imageDisabled:[UIImage imageNamed:@"bot-bar-contact"] Action:^(void){
        __typeof__(self) thisPointerStrong = thisPointer;
        [thisPointerStrong switchViewController:thisPointerStrong->_contactsViewController];
    }];
    wuTabItem.titleString = @"联系人";
    
    RKTabItem *wireTabItem = [RKTabItem createUsualItemWithImageEnabled:[UIImage imageNamed:@"bot-bar-me-selected"] imageDisabled:[UIImage imageNamed:@"bot-bar-me"] Action:^(void){
        __typeof__(self) thisPointerStrong = thisPointer;
        [thisPointerStrong switchViewController:thisPointerStrong->_accountInfoViewController];
    }];
    wireTabItem.titleString = @"我";
    
    m_titledTabsView.tabItems = @[mastercardTabItem, paypalTabItem, videoTabItem, wuTabItem, wireTabItem];
}

-(BOOL)isNoNeedLeftSwipGesture
{
    return (self.topViewController == _mainViewController || self.topViewController == _nearByViewController || self.topViewController == _contactsViewController || self.topViewController == _accountInfoViewController || self.topViewController == _videoViewController || self.topViewController == _startLoginViewController ||[self.topViewController isKindOfClass:[RecommendViewController class]] || self.viewControllers.count == 1);
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([self isNoNeedLeftSwipGesture])//关闭主界面的右滑返回
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = APP_BG_COLOR;
    [self setNavigationBarHidden:YES animated:YES];
    
    m_titledTabsView = [[RKTabView alloc]init];
    m_titledTabsView.darkensBackgroundForEnabledTabs = YES;
    m_titledTabsView.horizontalInsets = HorizontalEdgeInsetsMake(0, 0);
    //m_titledTabsView.backgroundColor = [UIColor colorWithWhite:0.1f alpha:0.6f];
    m_titledTabsView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - BAR_HEIGHT, BAR_WIDTH, BAR_HEIGHT);
    [self.view addSubview:m_titledTabsView];
    
    //Init FootBar Item
    [self initFootBarTabItem];
    
    //Init SelectView
    [self initSelectView];
    
    [self initNotifyMsg];
    
    [self selectItemByTag:VIEW_MAIN_PAGE];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

-(void)initSelectView
{
    NSArray* arrayView = [[NSBundle  mainBundle] loadNibNamed:@"PublishSelectionView" owner:nil options:nil];
    _publishSelectionView = arrayView[0];
    
    __typeof(self) __weak weakSelf = self;
    
    _publishSelectionView.ActionBlockPicText = ^(id sender) {
        __typeof__(self) strongSelf = weakSelf;
        [strongSelf actionNewArticle:nil];
    };
    
    _publishSelectionView.ScroeActionBlockRecord = ^(id sender) {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf actionNewRecord:nil];
    };
    
    _publishSelectionView.GameActionBlockRecord = ^(id sender) {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf actionGame:nil];
    };
    
    _publishSelectionView.closeActionBlock = ^(id sender) {
        //__typeof(self) strongSelf = weakSelf;
        //[strongSelf->_blurView removeFromSuperview];
    };
}

-(THLabel*)generateRewardLabel:(NSString*)strText Rect:(CGRect)frame
{
    THLabel *lbReward = [[THLabel alloc]initWithFrame:frame];
    lbReward.backgroundColor = [UIColor clearColor];
    lbReward.text = strText;
    lbReward.textColor = [UIColor colorWithRed:241.0 / 255.0 green:204.0 / 255.0 blue:0 alpha:1.0];
    lbReward.textAlignment = NSTextAlignmentCenter;
    lbReward.font = [UIFont boldSystemFontOfSize:30];
    
    lbReward.strokeColor = [UIColor blackColor];
    lbReward.strokeSize = 1.0;
    return lbReward;
}

#pragma mark - Animation Effect Reward

-(void)startRewardAnimation:(ExpEffect*) expEffect
{
    if (m_viewAnimation) {
        [m_viewAnimation removeFromSuperview];
        m_viewAnimation = nil;
    }
    
    m_viewAnimation = [[UIView alloc]init];
    m_viewAnimation.backgroundColor = [UIColor clearColor];
    
    int nStartPoint = 0;
    int nRewardCount = 0;
    
    UIImageView *imgViewPhy = nil;
    UIImageView *imgViewLit = nil;
    UIImageView *imgViewMagic = nil;
    UIImageView *imgViewCoin = nil;
    
    THLabel *lbPhy = nil;
    THLabel *lbLit = nil;
    THLabel *lbMagic = nil;
    THLabel *lbCoin = nil;
    
    CGRect rectLabel = CGRectZero;
    UIImage *img = [UIImage imageNamed:@"gift-run"];
    
    if (expEffect.exp_physique > 0) {
        nRewardCount++;
        imgViewPhy = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gift-run"]];
        [m_viewAnimation addSubview:imgViewPhy];
        
        rectLabel = CGRectMake((APP_SCREEN_WIDTH - 150) / 2, img.size.height + 10, 150, 40);
        lbPhy = [self generateRewardLabel:[NSString stringWithFormat:@"体魄：+%ld", expEffect.exp_physique] Rect:rectLabel];
        [m_viewAnimation addSubview:lbPhy];
    }
    
    if (expEffect.exp_literature > 0) {
        nRewardCount++;
        imgViewLit = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gift-blog"]];
        [m_viewAnimation addSubview:imgViewLit];
        
        if (rectLabel.origin.y == 0)
        {
            rectLabel = CGRectMake((APP_SCREEN_WIDTH - 150) / 2, img.size.height + 10, 150, 40);
        }
        else
        {
            rectLabel = CGRectMake((APP_SCREEN_WIDTH - 150) / 2, CGRectGetMaxY(rectLabel) + 5, 150, 40);
        }
        
        lbLit = [self generateRewardLabel:[NSString stringWithFormat:@"文学：+%ld", expEffect.exp_literature] Rect:rectLabel];
        [m_viewAnimation addSubview:lbLit];
    }
    
    if (expEffect.exp_magic > 0) {
        nRewardCount++;
        imgViewMagic = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gift-magic"]];
        [m_viewAnimation addSubview:imgViewMagic];
        
        if (rectLabel.origin.y == 0)
        {
            rectLabel = CGRectMake((APP_SCREEN_WIDTH - 150) / 2, img.size.height + 10, 150, 40);
        }
        else
        {
            rectLabel = CGRectMake((APP_SCREEN_WIDTH - 150) / 2, CGRectGetMaxY(rectLabel) + 5, 150, 40);
        }
        
        lbMagic = [self generateRewardLabel:[NSString stringWithFormat:@"魔法：+%ld", expEffect.exp_magic] Rect:rectLabel];
        [m_viewAnimation addSubview:lbMagic];
    }
    
    if (expEffect.exp_coin > 0) {
        nRewardCount++;
        imgViewCoin = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gift-beibitcoin"]];
        [m_viewAnimation addSubview:imgViewCoin];
        
        if (rectLabel.origin.y == 0)
        {
            rectLabel = CGRectMake((APP_SCREEN_WIDTH - 150) / 2, img.size.height + 10, 150, 40);
        }
        else
        {
            rectLabel = CGRectMake((APP_SCREEN_WIDTH - 150) / 2, CGRectGetMaxY(rectLabel) + 5, 150, 40);
        }
        
        lbCoin = [self generateRewardLabel:[NSString stringWithFormat:@"金币：+%lld", expEffect.exp_coin / 100000000] Rect:rectLabel];
        [m_viewAnimation addSubview:lbCoin];
    }
    
    nStartPoint = (APP_SCREEN_WIDTH - nRewardCount * img.size.width - (nRewardCount - 1) * 10) / 2;
    CGRect rectImage = CGRectZero;
    
    if (imgViewPhy != nil) {
        rectImage = CGRectMake(nStartPoint, 10, img.size.width, img.size.height);
        imgViewPhy.frame = rectImage;
    }
    
    if (imgViewLit != nil) {
        if (rectImage.origin.x == 0) {
            rectImage = CGRectMake(nStartPoint, 10, img.size.width, img.size.height);
            imgViewLit.frame = rectImage;
        }
        else
        {
            rectImage = CGRectMake(CGRectGetMaxX(rectImage) + 10, 10, img.size.width, img.size.height);
            imgViewLit.frame = rectImage;
        }
    }
    
    if (imgViewMagic != nil) {
        if (rectImage.origin.x == 0) {
            rectImage = CGRectMake(nStartPoint, 10, img.size.width, img.size.height);
            imgViewMagic.frame = rectImage;
        }
        else
        {
            rectImage = CGRectMake(CGRectGetMaxX(rectImage) + 10, 10, img.size.width, img.size.height);
            imgViewMagic.frame = rectImage;
        }
    }
    
    if (imgViewCoin != nil) {
        if (rectImage.origin.x == 0) {
            rectImage = CGRectMake(nStartPoint, 10, img.size.width, img.size.height);
            imgViewCoin.frame = rectImage;
        }
        else
        {
            rectImage = CGRectMake(CGRectGetMaxX(rectImage) + 10, 10, img.size.width, img.size.height);
            imgViewCoin.frame = rectImage;
        }
    }
    
    m_viewAnimation.frame = CGRectMake(0, APP_SCREEN_HEIGHT - (CGRectGetMaxY(rectLabel) + 20), APP_SCREEN_WIDTH, CGRectGetMaxY(rectLabel) + 20);
    m_viewAnimation.alpha = 0;
    [self.view addSubview:m_viewAnimation];
    [self.view bringSubviewToFront:m_viewAnimation];
    
    __typeof(self) __weak weakSelf = self;
    
    [UIView animateWithDuration:0.1 animations:^{
        __typeof__(self) strongSelf = weakSelf;
        strongSelf->m_viewAnimation.alpha = 1.0f;
    }];
    
    [UIView animateWithDuration:0.9 animations:^{
        __typeof__(self) strongSelf = weakSelf;
        strongSelf->m_viewAnimation.alpha = 0.0f;
    }];
    
    [self moveRewardPath:m_viewAnimation];
}

- (void)moveRewardPath:(UIView *)view
{
    CGRect frame = view.frame;
    [self.view bringSubviewToFront:view];
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT / 2);
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT / 2);
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT/4);
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, frame.size.height/2);
    
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = 1.0f;
    shakeAnimation.removedOnCompletion = NO;
    shakeAnimation.fillMode = kCAFillModeForwards;
    
    [shakeAnimation setCalculationMode:kCAAnimationLinear];
    [shakeAnimation setKeyTimes:[NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.1],
                                 [NSNumber numberWithFloat:0.6], [NSNumber numberWithFloat:0.9],
                                 [NSNumber numberWithFloat:1.0], nil]];
    
    [view.layer addAnimation:shakeAnimation forKey:nil];
    CFRelease(shakePath);
    
    frame = view.frame;
    frame.origin = CGPointMake(frame.origin.x,  0);
    view.frame = frame;
    [[CommonUtility sharedInstance]playAudioFromName:@"getPresent-1.mp3"];
}

#pragma mark - Animation Effect Fail

-(void)animationWhenFail
{
    if (m_viewAnimationFail != nil) {
        [m_viewAnimationFail removeFromSuperview];
        m_viewAnimationFail = nil;
    }
    
    m_viewAnimationFail = [[UIAnimationFailView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:m_viewAnimationFail];
    [self.view bringSubviewToFront:m_viewAnimationFail];
    
    __weak __typeof(self) weakself = self;
    
    [m_viewAnimationFail animationStartWithCompleteBlock:^(void)
    {
        __typeof(self) strongself = weakself;
        
        [strongself->m_viewAnimationFail removeFromSuperview];
        strongself->m_viewAnimationFail = nil;
    }];
}

-(void)animationWhenSuccess
{
    if (m_viewAnimationSuccess != nil) {
        [m_viewAnimationSuccess removeFromSuperview];
        m_viewAnimationSuccess = nil;
    }
    
    m_viewAnimationSuccess = [[UIAnimationSuccessView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:m_viewAnimationSuccess];
    [self.view bringSubviewToFront:m_viewAnimationSuccess];
    
    __weak __typeof(self) weakself = self;
    
    [m_viewAnimationSuccess animationStartWithCompleteBlock:^(void)
     {
         __typeof(self) strongself = weakself;
         
         [strongself->m_viewAnimationSuccess removeFromSuperview];
         strongself->m_viewAnimationSuccess = nil;
     }];
}

-(void)animationWhenLevelSuccess
{
    if (m_viewAnimationLevel != nil) {
        [m_viewAnimationLevel removeFromSuperview];
        m_viewAnimationLevel = nil;
    }
    
    m_viewAnimationLevel = [[UIViewAnimationLevel alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:m_viewAnimationLevel];
    [self.view bringSubviewToFront:m_viewAnimationLevel];
    
    __weak __typeof(self) weakself = self;
    
    [m_viewAnimationLevel animationStartWithCompleteBlock:^(void)
     {
         __typeof(self) strongself = weakself;
         
         [strongself->m_viewAnimationLevel removeFromSuperview];
         strongself->m_viewAnimationLevel = nil;
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectItemByTag:(NSString*)tag
{
    for (RKTabItem *tblItem in m_titledTabsView.tabItems) {
        if ([tblItem.titleString isEqualToString:tag]) {
            [m_titledTabsView swtichTab:tblItem];
            break;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL bShowFooter = NO;
    NSLog(@"willShowViewController :%@", viewController);
    
    id alertView = [navigationController.view viewWithTag:ALERT_VIEW_ITEM_TAG_FULL_VIEW];
    
    if (alertView != nil) {
        [AlertManager dissmiss:alertView];
    }
    
    if ([viewController canPerformAction:@selector(bShowFooterViewController) withSender:nil]) {
        bShowFooter = (BOOL)[viewController performSelector:@selector(bShowFooterViewController) withObject:nil];
    }

    if (bShowFooter) {
        [self setTabBarHidden:NO animated:YES];
        //[self.view bringSubviewToFront:m_titledTabsView];
    } else {
        [self setTabBarHidden:YES animated:YES];
        //[self.view sendSubviewToBack:m_titledTabsView];
    }
    
    //m_titledTabsView.hidden = !bShowFooter;
}

-(void)actionNewRecord:(id)sender {
    RecordSportViewController *recordSportViewController = [[RecordSportViewController alloc]init];
    [self pushViewController:recordSportViewController animated:YES];
}

-(void)actionNewArticle:(id)sender {
    ArticlePublicViewController* articlePublicViewController = [[ArticlePublicViewController alloc]init];
    [self pushViewController:articlePublicViewController animated:YES];
}

-(void)actionGame:(id)sender {
    GameViewController *gameViewController = [[GameViewController alloc]init];
    [self pushViewController:gameViewController animated:YES];
}

-(void)openPublishMenu:(id)sender {
    //NSArray* arrayView = [[NSBundle  mainBundle] loadNibNamed:@"PublishSelectionView" owner:nil options:nil];
    //PublishSelectionView* menu = arrayView[0];
    [[CommonUtility sharedInstance]playAudioFromName:@"plusPopupBtn.mp3"];
    [_publishSelectionView showInView:self.view PublishMode:PUBLISH_MODE_NORMAL];
}

-(BOOL)switchViewController:(UIViewController*)viewController {
    // get current stack of viewControllers from navigation controller
    NSMutableArray *arrayViewControllers = [NSMutableArray arrayWithObject:viewController];
    [self setViewControllers:arrayViewControllers animated:NO];
    return YES;
}

-(void)autoLoginWhenStart
{
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"Profile"];
    
    NSString* strAuthId = [dict objectForKey:@"AuthUserId"];
    NSNumber* numType = [dict objectForKey:@"LoginType"];
    NSString* strAccessToken = [dict objectForKey:@"AccessToken"];
    
    int nloginType = login_type_email;
    
    if (numType != nil) {
        nloginType = [numType intValue];
    }
    
    [[ApplicationContext sharedInstance]getPreSportFormStatus];
    
    m_bCheckAfterZero = NO;
    m_bNetWorkTips = NO;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LoginInfo"];
    
    if (strAuthId.length > 0 && strAccessToken.length > 0) {
        if (nloginType == login_type_weibo) {
            NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"WeiBoInfo"];
            NSDate *dateExpired = [dict objectForKey:@"WeiBoExpird"];
            
            if ([dateExpired timeIntervalSinceNow] > 0) {
                NSLog(@"WeiBo Login is not expired, expired time is %@", [dateExpired description]);
            }
            else
            {
                NSLog(@"WeiBo Login is expired, relogin");
                [self switchViewController:_startLoginViewController];
                [[CommonUtility sharedInstance]sinaWeiBoLogin];
                return;
            }
        }
        
        //Get System Config Info
        [[ApplicationContext sharedInstance]getSysConfigInfo];
        
        [[ApplicationContext sharedInstance]getProfileInfo:strAuthId FinishedBlock:^void(int errorCode)
         {
             if (errorCode == 0) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_GET_MAIN_INFO object:nil];
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
             }
         }];
        
        //Create websocket
        [self connectWebSocket];
    }
    else
    {
        if(!(self.topViewController == _startLoginViewController || [self.topViewController isKindOfClass:[LoginEmailViewController class]] || [self.topViewController isKindOfClass:[RegisterEmailViewController class]] || [self.topViewController isKindOfClass:[BindPhoneViewController class]] || [self.topViewController isKindOfClass:[RegisterInfoViewController class]]))
        {
            [self switchViewController:_startLoginViewController];
        }
        
        /*BOOL bStartScreen = [[[ApplicationContext sharedInstance]getObjectByKey:@"WeiBoLogin"]boolValue];
        
        if (bStartScreen) {
            FullStartViewController *fullStartViewController = [[FullStartViewController alloc]init];
            [self switchViewController:fullStartViewController];
        }
        else
        {
            if(!(self.topViewController == _startLoginViewController || [self.topViewController isKindOfClass:[LoginEmailViewController class]] || [self.topViewController isKindOfClass:[RegisterEmailViewController class]] || [self.topViewController isKindOfClass:[BindPhoneViewController class]] || [self.topViewController isKindOfClass:[RegisterInfoViewController class]]))
            {
                [self switchViewController:_startLoginViewController];
            }
        }*/
    }
}

-(void)getLocationInfo
{
    NSLog(@"Get Current LocationInfo After Account Token is vaild!");
    
    __block NSString *string = @"";
    __typeof(self) __weak weakSelf = self;
    
    if (IOS8_OR_LATER)
    {
        [[LBSLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate, NSString* strDetail, NSString *streetString) {
            __typeof(self) strongSelf = weakSelf;
            string = [NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude, locationCorrrdinate.longitude];
            NSLog(@"%@", string);
            
            if (strongSelf->_webSocket.readyState == SR_OPEN) {
                NSString *strLocation = [NSString stringWithFormat:@"{\"type\":\"status\", \"push\":{\"type\":\"loc\", \"body\":[{\"type\":\"latlng\", \"content\":\"%6f,%6f\"}, {\"type\":\"locaddr\", \"content\":\"%@\"}, {\"type\":\"locadetail\", \"content\":\"%@\"}]}}", locationCorrrdinate.latitude, locationCorrrdinate.longitude, streetString.length > 0 ? streetString : @"", strDetail.length > 0 ? strDetail : @""];
                NSLog(@"WebSocket send location info: %@", strLocation);
                [strongSelf->_webSocket send:strLocation];
                //NSLog(@"%@", strLocation);
            }
        } withAddress:^(NSString *addressString) {
            string = [NSString stringWithFormat:@"%@\n%@", string, addressString];
            NSLog(@"%@", string);
        }];
    }
    else
    {
        [[MMLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate, NSString* strDetail, NSString *streetString) {
            __typeof(self) strongSelf = weakSelf;
            string = [NSString stringWithFormat:@"%f %f",locationCorrrdinate.latitude, locationCorrrdinate.longitude];
            NSLog(@"%@", string);
            
            if (strongSelf->_webSocket.readyState == SR_OPEN) {
                NSString *strLocation = [NSString stringWithFormat:@"{\"type\":\"status\", \"push\":{\"type\":\"loc\", \"body\":[{\"type\":\"latlng\", \"content\":\"%6f,%6f\"}, {\"type\":\"locaddr\", \"content\":\"%@\"}, {\"type\":\"locadetail\", \"content\":\"%@\"}]}}", locationCorrrdinate.latitude, locationCorrrdinate.longitude, streetString.length > 0 ? streetString : @"", strDetail.length > 0 ? strDetail : @""];
                NSLog(@"WebSocket send location info: %@", strLocation);
                [strongSelf->_webSocket send:strLocation];
                //NSLog(@"%@", strLocation);
            }
        } withAddress:^(NSString *addressString) {
            string = [NSString stringWithFormat:@"%@\n%@", string, addressString];
            NSLog(@"%@", string);
        }];
    }
}

-(void)setDeviceToken
{
    if ([m_timeSetDeviceToken isValid]) {
        [m_timeSetDeviceToken invalidate];
        m_timeSetDeviceToken = nil;
    }

    if (m_bTokenVaild) {
        NSLog(@"Set Device Token After Account Token is vaild!");
        
        NSString * strDeviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:kSTORE_DEVICE_TOKEN];
        
        if (strDeviceToken.length > 0 &&  _webSocket.readyState == SR_OPEN) {
            NSString *strRequest = [NSString stringWithFormat:@"{\"type\":\"status\", \"push\":{\"type\":\"device\", \"body\":[{\"type\":\"token\", \"content\":\"%@\"}]}}", strDeviceToken];
            NSLog(@"WebSocket send devicetoken info: %@", strRequest);
            [_webSocket send:strRequest];
        }
    }
    else
    {
        m_timeSetDeviceToken = [NSTimer scheduledTimerWithTimeInterval: 10
                                         target: self
                                       selector: @selector(setDeviceToken)
                                       userInfo: nil
                                        repeats: NO];
    }
}

-(long long)getLastLoginTime
{
    return m_lLastTime;
}

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    m_tabBarHidden = hidden;

    if (animated) {
        [UIView animateWithDuration:0.24 animations:m_tabBarBlock completion:m_tabBarCompletion];
    } else {
        m_tabBarBlock();
        m_tabBarCompletion(YES);
    }
}

- (void)updateTabBarItem {
    [m_titledTabsView setNeedsDisplay];
}

-(void)checkAfterZero
{
    m_bCheckAfterZero = YES;
    [m_timeCheckAfterZero invalidate];
    m_timeCheckAfterZero = nil;
    [self disconnectWebSocket];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSInteger unitFlags = NSHourCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:now];
    NSInteger nHour = [comps hour];

    if (nHour >= 0 && nHour <= 5 ) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"亲，夜也深，早点休息哦，明天还可以再玩呢~~" delegate:nil cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)connectWebSocket
{
    [m_arrChatInfo removeAllObjects];
    [m_arrSystemNotifyInfo removeAllObjects];
    [m_timeReconnect invalidate];
    [m_timeCheckAfterZero invalidate];
    m_timeReconnect = nil;
    _webSocket.delegate = nil;
    m_timeCheckAfterZero = nil;
    m_bTokenVaild = NO;
    m_lLastTime = 0;
    [_webSocket close];
    
    NSString *strWsUrl = API_CFG_HTTP_REQUEST_URL;
    strWsUrl = [strWsUrl stringByReplacingOccurrencesOfString:@"http" withString:@"ws"];
    strWsUrl = [strWsUrl stringByAppendingString:@"1/ws"];
    NSLog(@"Web Socket Url is %@!", strWsUrl);
    
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strWsUrl]]];
    _webSocket.delegate = self;
    [_webSocket open];
    
    //Check New Event Count
    [self checkNewEventCount];
    
    //Check New Attention Article
    [self checkNewAttention];
    
    //Check Event Notices
    [self checkNewNotices];
}

- (void)disconnectWebSocket
{
    [m_timeCheckAfterZero invalidate];
    m_timeCheckAfterZero = nil;
    _webSocket.delegate = nil;
    [_webSocket close];
    
    NSString *strPaths = [[ApplicationContext sharedInstance]getRegUserPaths];
    
    if(strPaths.length > 0)
    {
        [[SportForumAPI sharedInstance]userActionByPath:strPaths FinishedBlock:^(int errorCode)
         {
             
         }];
    }
}

-(void)checkNeedImportWeiboFriends
{
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"Profile"];
    
    NSString* stringUid = [dict objectForKey:@"SerUserId"];
    NSString* stringPassword = [dict objectForKey:@"Password"];
    NSNumber* numType = [dict objectForKey:@"LoginType"];
    
    if ([numType intValue] == login_type_weibo) {
        __typeof(self) __weak weakSelf = self;
                
        m_proWinImport = [AlertManager showConfirmAlertWithTitle:@"导入微博好友"
                                                             Text:@"确认将导入你的微博好友?"
                                               ConfirmButtonTitle:@"确认"
                                                     ConfirmBlock:^BOOL(id window){
                                                         __typeof(self) strongSelf = weakSelf;
                                                         id win = [AlertManager showCommonProgress];
                                                         
                                                         [[SportForumAPI sharedInstance]accountImportFriendsByUserName:stringUid Verfiycode:stringPassword AppKey:@"1974573341" AccountType:login_type_weibo FinishedBlock:^(int errorCode, ExpEffect* expEffect) {
                                                             [AlertManager dissmiss:win];
                                                             [AlertManager dissmiss:window];
                                                             strongSelf->m_proWinImport = nil;
                                                         }];
                                                         
                                                         return NO;
                                                     }];
    }
}

-(void)checkNewEventCount
{
    __typeof(self) __weak weakSelf = self;
    
    [[ApplicationContext sharedInstance]checkNewEvent:^(int errorCode){
        __typeof(self) strongSelf = weakSelf;
        
        if (errorCode == 0) {
            EventNewsInfo *eventNewsInfo = [[ApplicationContext sharedInstance]eventNewsInfo];
            RKTabItem *tblItem  = strongSelf->m_titledTabsView.tabItems[3];
            
            if (tblItem != nil) {
                if (eventNewsInfo.new_chat_count > 0 || eventNewsInfo.new_comment_count > 0 || eventNewsInfo.new_thumb_count > 0
                    || eventNewsInfo.new_reward_count > 0 || eventNewsInfo.new_attention_count > 0) {
                    [tblItem setImageEnabled:[UIImage imageNamed:@"bot-bar-contact-selected-reddot"]];
                    [tblItem setImageDisabled:[UIImage imageNamed:@"bot-bar-contact-unsel-reddot"]];
                    
                    if ([strongSelf->m_arrChatInfo count] > 0 || [strongSelf->m_arrSystemNotifyInfo count] > 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_WEBSOCKET_COMING object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:strongSelf->m_arrChatInfo, @"WSChatInfoList", strongSelf->m_arrSystemNotifyInfo, @"WSSystemNotifyList", nil]];
                        
                        [strongSelf->m_arrChatInfo removeAllObjects];
                        [strongSelf->m_arrSystemNotifyInfo removeAllObjects];
                        
                        if(eventNewsInfo.new_reward_count > 0)
                        {
                            UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                            [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                             {
                                 if (errorCode == 0)
                                 {
                                     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
                                 }
                             }];
                        }
                    }
                    
                    if (eventNewsInfo.new_attention_count > 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_LEADBOARD object:nil];
                    }
                }
                else
                {
                    [tblItem setImageEnabled:[UIImage imageNamed:@"bot-bar-contact-selected"]];
                    [tblItem setImageDisabled:[UIImage imageNamed:@"bot-bar-contact"]];
                }
                
                [strongSelf->m_titledTabsView updateTabItem:tblItem];
            }
        }
    }];
}

-(void)checkNewAttention
{
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"Profile"];
    
    NSString* strAuthId = [dict objectForKey:@"AuthUserId"];
    NSString* strAccessToken = [dict objectForKey:@"AccessToken"];
    
    if (strAuthId.length > 0 && strAccessToken.length > 0) {
        NSMutableDictionary *articleDict = [[ApplicationContext sharedInstance] getObjectByKey:@"AttentionCircleId"];
        NSString *strArticleId = [articleDict objectForKey:@"ArticleId"];
        
        [m_timeCheckNewAttention invalidate];
        m_timeCheckNewAttention = nil;
        
        [[SportForumAPI sharedInstance]articleNewsByArticleId:strArticleId FinishedBlock:^(int errorCode, NSInteger nNewsCount, NSArray* arrProfilesImgs){
            if (errorCode == 0) {
                RKTabItem *tblItem  = m_titledTabsView.tabItems[1];
                
                if (tblItem != nil) {
                    if (nNewsCount > 0) {
                        [tblItem setImageEnabled:[UIImage imageNamed:@"bot-bar-discover-sel-reddot"]];
                        [tblItem setImageDisabled:[UIImage imageNamed:@"bot-bar-discover-reddot"]];
                    }
                    else
                    {
                        [tblItem setImageEnabled:[UIImage imageNamed:@"bot-bar-discover-sel"]];
                        [tblItem setImageDisabled:[UIImage imageNamed:@"bot-bar-discover"]];
                        
                        [self restartTimer_checkNewAttention];
                    }
                    
                    [m_titledTabsView updateTabItem:tblItem];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_NEW_ARTICLE_UPDATE object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@(nNewsCount), @"NewsCount", arrProfilesImgs, @"NewProfiles", nil]];
                }
            }
            else
            {
                [self restartTimer_checkNewAttention];
            }
        }];
    }
}

-(void)handleOperateNotices:(NSTimer *)timer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_ANIMATION_STATE object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:timer.userInfo[@"AnimationState"], @"AnimationState", nil]];
}

-(void)checkNewNotices
{
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"Profile"];
    
    NSString* strAuthId = [dict objectForKey:@"AuthUserId"];
    NSString* strAccessToken = [dict objectForKey:@"AccessToken"];
    
    if (strAuthId.length > 0 && strAccessToken.length > 0) {
        [[SportForumAPI sharedInstance]eventNotices:^(int errorCode, EventNotices* eventNotices){
            if (errorCode == 0 && eventNotices.notices.data.count > 0) {
                BOOL bLevelup = NO;
                BOOL bTaskdone = NO;
                BOOL bTaskFailure = NO;
                NSTimeInterval fBeginTime = 0.0;
                ExpEffect *expEffect = [[ExpEffect alloc]init];
                
                for (MsgWsInfo *msgWsInfo in eventNotices.notices.data) {
                    if ([msgWsInfo.push.type isEqualToString:@"levelup"]) {
                        bLevelup = YES;
                    }
                    else if([msgWsInfo.push.type isEqualToString:@"taskdone"])
                    {
                        for (MsgWsBodyItem *msgWsBodyItem in msgWsInfo.push.body.data) {
                            if ([msgWsBodyItem.type isEqualToString:@"physique_value"]) {
                                expEffect.exp_physique += [msgWsBodyItem.content integerValue];
                            }
                            else if([msgWsBodyItem.type isEqualToString:@"literature_value"])
                            {
                                expEffect.exp_literature = [msgWsBodyItem.content integerValue];
                            }
                            else if([msgWsBodyItem.type isEqualToString:@"magic_value"])
                            {
                                expEffect.exp_magic = [msgWsBodyItem.content integerValue];
                            }
                            else if([msgWsBodyItem.type isEqualToString:@"coin_value"])
                            {
                                expEffect.exp_coin += [msgWsBodyItem.content longLongValue];
                            }
                            else if([msgWsBodyItem.type isEqualToString:@"task_id"] && msgWsBodyItem.content.length > 0)
                            {
                                bTaskdone = YES;
                            }
                        }
                    }
                    else if([msgWsInfo.push.type isEqualToString:@"taskfailure"])
                    {
                        for (MsgWsBodyItem *msgWsBodyItem in msgWsInfo.push.body.data) {
                            if([msgWsBodyItem.type isEqualToString:@"task_id"] && msgWsBodyItem.content.length > 0)
                            {
                                bTaskFailure = YES;
                            }
                        }
                    }
                }
                
                if (expEffect.exp_physique > 0 || bLevelup) {
                    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                    
                    [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                     {
                         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                     }];
                    
                    fBeginTime += 1.5;
                }

                if (bLevelup) {
                    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(handleOperateNotices:) userInfo:@{@"AnimationState" : @"UpgradeLevelSuccess"} repeats:NO];
                }
                else if(bTaskdone){
                    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(handleOperateNotices:) userInfo:@{@"AnimationState" : @"TaskSuccess"} repeats:NO];
                }
                else if(bTaskFailure)
                {
                    [NSTimer scheduledTimerWithTimeInterval:0.0 target:self selector:@selector(handleOperateNotices:) userInfo:@{@"AnimationState" : @"TaskFail"} repeats:NO];
                }
                
                /*if (bTaskdone) {
                    [NSTimer scheduledTimerWithTimeInterval:fBeginTime target:self selector:@selector(handleOperateNotices:) userInfo:@{@"AnimationState" : @"TaskSuccess"} repeats:NO];
    
                    fBeginTime += 7.0;
                }
                
                if (bTaskFailure) {
                    [NSTimer scheduledTimerWithTimeInterval:fBeginTime target:self selector:@selector(handleOperateNotices:) userInfo:@{@"AnimationState" : @"TaskFail"} repeats:NO];
                    fBeginTime += 5.0;
                }
                
                if (bLevelup) {
                    [NSTimer scheduledTimerWithTimeInterval:fBeginTime target:self selector:@selector(handleOperateNotices:) userInfo:@{@"AnimationState" : @"UpgradeLevelSuccess"} repeats:NO];
                }*/
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_TASK_STATUS object:nil];
            }
        }];
    }
}

/*-(void)updateProfileInfo:(NSDictionary*) dictUserInfo
{
    if (m_timerReward != nil) {
        dictUserInfo = m_timerReward.userInfo;
    }
    
    __typeof(self) __weak weakSelf = self;
    ExpEffect* expEffect = [dictUserInfo objectForKey:@"RewardEffect"];
    
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
     {
         __typeof(self) strongSelf = weakSelf;
         
         if (errorCode == 0)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
         }
         
         [strongSelf->m_timerReward invalidate];
         strongSelf->m_timerReward = nil;
     }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_TASK_STATUS object:nil];
}*/

-(void)handleWebSocketReceiveData:(NSData*)dataWs
{
    BOOL bUpTbItem = NO;
    NSError *error = nil;
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:dataWs options:NSJSONReadingAllowFragments error:&error];
    
    if (jsonObject) {
        NSArray *arrKeys = [jsonObject allKeys];
        
        if ([arrKeys indexOfObject:@"userid"] == 0) {
            if (((NSString*)[jsonObject objectForKey:@"userid"]).length == 0) {
                
                if ([arrKeys indexOfObject:@"ban_time"] != NSNotFound && [[jsonObject objectForKey:@"ban_time"]longLongValue] < 0) {
                    [JDStatusBarNotification showWithStatus:@"你的账户已被拉黑，将无法登录!" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                }
                else
                {
                    [JDStatusBarNotification showWithStatus:@"你的账号Token已过期，请重新登录!" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                }
                
                m_bCheckAfterZero = NO;
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Profile"];
                [self disconnectWebSocket];
                [self switchViewController:_startLoginViewController];
                
                [[ApplicationContext sharedInstance]logout:^void((int nErrorCode)){
                }];
            }
            else
            {
                m_bTokenVaild = YES;
                NSLog(@"Current AccessToken is not expired!");
                int nLoginCount = [[jsonObject objectForKey:@"login_count"]intValue];
                m_lLastTime = [[jsonObject objectForKey:@"last_login_time"]longLongValue];
                NSMutableDictionary *loginDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @(nLoginCount), @"login_count", nil];
                [[ApplicationContext sharedInstance] saveObject:loginDict byKey:@"LoginInfo"];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_LOGIN_INFO object:nil];
                
                if (m_bCheckAfterZero) {
                    m_bCheckAfterZero = NO;
                    NSString* strAuthId = [[[ApplicationContext sharedInstance] getObjectByKey:@"Profile"] objectForKey:@"AuthUserId"];
                    
                    [[ApplicationContext sharedInstance]getProfileInfo:strAuthId FinishedBlock:^void(int errorCode)
                     {
                         if (errorCode == 0) {
                             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_GET_MAIN_INFO object:nil];
                         }
                     }];
                }
                
                //Get Current Location Info
                [self getLocationInfo];
                
                //Set Device Token
                [self setDeviceToken];
            }
        }
        else if(jsonObject && ((NSString*)[jsonObject objectForKey:@"type"]).length > 0){
            MsgWsInfo *msgWsInfo = [[MsgWsInfo alloc]init];
            [msgWsInfo reflectDataFromOtherObject:jsonObject];
            
            if ([msgWsInfo.type isEqualToString:@"message"]) {
                if ([msgWsInfo.push.type isEqualToString:@"chat"]) {
                    bUpTbItem = YES;
                    [m_arrChatInfo addObject:msgWsInfo];
                }
                else if([msgWsInfo.push.type isEqualToString:@"subscribe"]) {
                    bUpTbItem = YES;
                    [m_arrSystemNotifyInfo addObject:msgWsInfo];
                }
            }
            else if([msgWsInfo.type isEqualToString:@"article"]) {
                bUpTbItem = YES;
                [m_arrSystemNotifyInfo addObject:msgWsInfo];
            }
            else if([msgWsInfo.type isEqualToString:@"wallet"])
            {
                bUpTbItem = YES;
                [m_arrSystemNotifyInfo addObject:msgWsInfo];
            }
            else if([msgWsInfo.type isEqualToString:@"system"])
            {
                bUpTbItem = YES;
                [m_arrSystemNotifyInfo addObject:msgWsInfo];
            }
            else if([msgWsInfo.type isEqualToString:@"notice"])
            {
                [self checkNewNotices];
            }
            else if([msgWsInfo.type isEqualToString:@"status"])
            {
                if ([msgWsInfo.push.type isEqualToString:@"lock"]) {
                    NSLog(@"Current Account is locked!");
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Profile"];
                    m_bCheckAfterZero = NO;
                    [self disconnectWebSocket];
                    [JDStatusBarNotification showWithStatus:@"你的账户已被拉黑，将无法登录!" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                    [self switchViewController:_startLoginViewController];
                    
                    [[ApplicationContext sharedInstance]logout:^void((int nErrorCode)){
                    }];
                }
                else if([msgWsInfo.push.type isEqualToString:@"ban"] || [msgWsInfo.push.type isEqualToString:@"unban"])
                {
                    NSLog(@"Current Account is %@， reGetUserInfo!", msgWsInfo.push.type);
                    NSString* strAuthId = [[[ApplicationContext sharedInstance] getObjectByKey:@"Profile"] objectForKey:@"AuthUserId"];
                    
                    [[ApplicationContext sharedInstance]getProfileInfo:strAuthId FinishedBlock:^void(int errorCode)
                     {
                         if (errorCode == 0)
                         {
                             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
                         }
                     }];
                }
//                else if([msgWsInfo.push.type isEqualToString:@"task"])
//                {
//                    ExpEffect *expEffect = [[ExpEffect alloc]init];
//                    
//                    for (MsgWsBodyItem *msgWsBodyItem in msgWsInfo.push.body.data) {
//                        if ([msgWsBodyItem.type isEqualToString:@"physique_value"]) {
//                            expEffect.exp_physique = [msgWsBodyItem.content integerValue];
//                        }
//                        else if([msgWsBodyItem.type isEqualToString:@"literature_value"])
//                        {
//                            expEffect.exp_literature = [msgWsBodyItem.content integerValue];
//                        }
//                        else if([msgWsBodyItem.type isEqualToString:@"magic_value"])
//                        {
//                            expEffect.exp_magic = [msgWsBodyItem.content integerValue];
//                        }
//                        else if([msgWsBodyItem.type isEqualToString:@"coin_value"])
//                        {
//                            expEffect.exp_coin = [msgWsBodyItem.content longLongValue];
//                        }
//                    }
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_TASK_STATUS object:nil];
//                    
//                    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
//                    
//                    [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
//                     {
//                     }];
//
//                    
//                    /*m_timerReward = [NSTimer scheduledTimerWithTimeInterval: 2
//                                                                     target: self
//                                                                   selector: @selector(updateProfileInfo:)
//                                                                   userInfo: [NSDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]
//                                                                    repeats: NO];*/
//                }
            }
        }
        
        if (bUpTbItem) {
            [[CommonUtility sharedInstance]playAudioFromName:@"newMessage.mp3"];
            [self restartTimer_checkEventNews];
        }
    }
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSString* strAccessToken = @"";
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"Profile"];
    
    if (dict) {
        strAccessToken = [dict objectForKey:@"AccessToken"];
    }
    
    if (strAccessToken.length > 0) {
        NSLog(@"Websocket Connected, First send token to server, Account Token is %@", strAccessToken);
        [_webSocket send:[NSString stringWithFormat:@"{\"token\": \"%@\"}", strAccessToken]];
    }
    
    m_bTokenVaild = NO;
    [self restartTimer_checkAfterZero];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    NSString* strAccessToken = @"";
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"Profile"];
    
    if (dict) {
        strAccessToken = [dict objectForKey:@"AccessToken"];
    }
    
    if (strAccessToken.length > 0) {
        NSLog(@"WebSocket closed, reconnect after 30 seconds!");
        _webSocket = nil;
        [self restartTimer_connectWebSocket];
    }
    
    m_bTokenVaild = NO;
    
    if (!m_bNetWorkTips) {
        m_bNetWorkTips = YES;
        [JDStatusBarNotification showWithStatus:@"亲，网络连接异常，无法获取数据~" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self handleWebSocketReceiveData:data];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSString* strAccessToken = @"";
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"Profile"];
    
    if (dict) {
        strAccessToken = [dict objectForKey:@"AccessToken"];
    }
    
    if (strAccessToken.length > 0) {
        NSLog(@"WebSocket closed, reconnect after 30 seconds!");
        _webSocket = nil;
        [self restartTimer_connectWebSocket];
    }
    
    m_bTokenVaild = NO;
}

- (void)restartTimer_connectWebSocket
{
    if (m_timeReconnect != nil && [m_timeReconnect isValid]) {
        [m_timeReconnect invalidate];
        m_timeReconnect = nil;
    }
    
    m_timeReconnect = [NSTimer scheduledTimerWithTimeInterval: 3
                                                          target: self
                                                        selector: @selector(connectWebSocket)
                                                        userInfo: nil
                                                         repeats: NO];
}

- (void)restartTimer_checkAfterZero
{
    [m_timeCheckAfterZero invalidate];
    m_timeCheckAfterZero = nil;
    
    int nSeconds = [[CommonUtility sharedInstance]getSecondsFromZeroOfNextDay] + 60;
    
    NSLog(@"Logining still after %d Seconds, we will check first reward!", nSeconds);
    
    m_timeCheckAfterZero = [NSTimer scheduledTimerWithTimeInterval: nSeconds
                                                       target: self
                                                     selector: @selector(checkAfterZero)
                                                     userInfo: nil
                                                      repeats: NO];
}


- (void)restartTimer_checkEventNews
{
    if (m_timeCheckEvent != nil && [m_timeCheckEvent isValid]) {
        [m_timeCheckEvent invalidate];
        m_timeCheckEvent = nil;
    }
    
    m_timeCheckEvent = [NSTimer scheduledTimerWithTimeInterval: 1
                                                       target: self
                                                     selector: @selector(checkNewEventCount)
                                                     userInfo: nil
                                                      repeats: NO];
}

- (void)restartTimer_checkNewAttention
{
    if (m_timeCheckNewAttention != nil && [m_timeCheckNewAttention isValid]) {
        [m_timeCheckNewAttention invalidate];
        m_timeCheckNewAttention = nil;
    }
    
    m_timeCheckNewAttention = [NSTimer scheduledTimerWithTimeInterval: 30
                                                        target: self
                                                      selector: @selector(checkNewAttention)
                                                      userInfo: nil
                                                       repeats: NO];
}

- (void)handleAuthLoginSuccess:(NSNotification*) notification
{
    //Get System Config Info
    [[ApplicationContext sharedInstance]getSysConfigInfo];
    
    //Create websocket
    [self connectWebSocket];
}

- (void)handleLogoutSuccess
{
    NSLog(@"Logout successfully, disconnect socket!");
    
    [m_arrChatInfo removeAllObjects];
    [m_arrSystemNotifyInfo removeAllObjects];
    [m_timeReconnect invalidate];
    [m_timeCheckAfterZero invalidate];
    m_timeReconnect = nil;
    m_timeCheckAfterZero = nil;
    m_bTokenVaild = NO;
    m_lLastTime = 0;

    [self disconnectWebSocket];
    [self resetAllControllers];
}

-(void)resetAllControllers
{
    [[SDImageCache sharedImageCache] clearMemory];
    
    if (_mainViewController != nil) {
        [_mainViewController.view removeFromSuperview];
        _mainViewController = nil;
        _mainViewController = [[MainViewController alloc]init];
    }
    
    if(_nearByViewController != nil) {
        [_nearByViewController.view removeFromSuperview];
        _nearByViewController = nil;
        _nearByViewController = [[NearByViewController alloc]init];
    }
    
    if(_contactsViewController != nil) {
        [_contactsViewController.view removeFromSuperview];
        _contactsViewController = nil;
        _contactsViewController = [[ContactsViewController alloc]init];
    }
    
    if(_accountInfoViewController != nil) {
        [_accountInfoViewController.view removeFromSuperview];
        _accountInfoViewController = nil;
        _accountInfoViewController = [[AccountInfoViewController alloc]init];
    }
    
    if(_videoViewController != nil) {
        [_videoViewController.view removeFromSuperview];
        _videoViewController = nil;
        _videoViewController = [[VideoViewController alloc]init];
    }
}

-(void)handleSwitchViewController:(NSNotification*) notification
{
    NSString *strItem = [[notification userInfo]objectForKey:@"PageName"];

    if ([strItem isEqualToString:VIEW_LOGIN_PAGE]) {
        [self switchViewController:_startLoginViewController];
    }
    else if ([strItem isEqualToString:VIEW_MAIN_PAGE]) {
        [self switchViewController:_mainViewController];
    }
    else if([strItem isEqualToString:VIEW_SEARCH_PAGE])
    {
        [self switchViewController:_nearByViewController];
    }
    else if([strItem isEqualToString:VIEW_CONTACTS_PAGE])
    {
        [self switchViewController:_contactsViewController];
    }
    else if([strItem isEqualToString:VIEW_ACCOUNT_PAGE])
    {
        [self switchViewController:_accountInfoViewController];
    }
    
    [self selectItemByTag:strItem];
}

-(void)handleUpdateMsgStatus
{
    EventNewsInfo *eventNewsInfo = [[ApplicationContext sharedInstance]eventNewsInfo];
    RKTabItem *tblItem  = m_titledTabsView.tabItems[3];
    
    if (tblItem != nil) {
        if (eventNewsInfo.new_chat_count > 0 || eventNewsInfo.new_comment_count > 0 || eventNewsInfo.new_thumb_count > 0
            || eventNewsInfo.new_reward_count > 0 || eventNewsInfo.new_attention_count > 0) {
            [tblItem setImageEnabled:[UIImage imageNamed:@"bot-bar-contact-selected-reddot"]];
            [tblItem setImageDisabled:[UIImage imageNamed:@"bot-bar-contact-unsel-reddot"]];
        }
        else
        {
            [tblItem setImageEnabled:[UIImage imageNamed:@"bot-bar-contact-selected"]];
            [tblItem setImageDisabled:[UIImage imageNamed:@"bot-bar-contact"]];
        }
        
        [m_titledTabsView updateTabItem:tblItem];
    }
}

-(void)handleUpdateProfileInfo:(NSNotification*) notification
{
    ExpEffect* expEffect = [notification.userInfo objectForKey:@"RewardEffect"];
    
    if (expEffect != nil && (expEffect.exp_physique > 0 || expEffect.exp_literature > 0 || expEffect.exp_magic > 0 || expEffect.exp_coin > 0)) {
        [self startRewardAnimation:expEffect];
    }
}

-(void)handleAnimationState:(NSNotification*) notification
{
    NSString *strState = [notification.userInfo objectForKey:@"AnimationState"];
    
    if ([strState isEqualToString:@"TaskFail"]) {
        [self animationWhenFail];
    }
    else if([strState isEqualToString:@"TaskSuccess"])
    {
        [self animationWhenSuccess];
    }
    else if([strState isEqualToString:@"UpgradeLevelSuccess"])
    {
        [self animationWhenLevelSuccess];
    }
}

- (void)handleWebSocketMsgComing:(NSNotification*) notification
{
    NSMutableArray *arrSystemNotifyInfo = [[notification userInfo]objectForKey:@"WSSystemNotifyList"];
    
    for (MsgWsInfo *systemWsInfo in arrSystemNotifyInfo) {
        NSString *strTips = @"";
        NSString *strNickName = @"";
        NSString *strUserId = @"";
        NSString *strRecordId = @"";
        NSString *strLocAddr = @"";
        NSString *strArticleId = @"";
        NSString *strLatlng = @"";
        NSString *strMapUrl = @"";
        NSString *strTime = [[CommonUtility sharedInstance]compareCurrentTime:[NSDate dateWithTimeIntervalSince1970:systemWsInfo.time]];
        long long lRunBeginTime = 0;
        
        for (MsgWsBodyItem *msgWsBodyItem in systemWsInfo.push.body.data) {
            if([msgWsBodyItem.type isEqualToString:@"nikename"])
            {
                strNickName = msgWsBodyItem.content;
            }
            else if([msgWsBodyItem.type isEqualToString:@"userid"])
            {
                strUserId = msgWsBodyItem.content;
            }
            else if([msgWsBodyItem.type isEqualToString:@"record_id"])
            {
                strRecordId = msgWsBodyItem.content;
            }
            else if([msgWsBodyItem.type isEqualToString:@"locaddr"])
            {
                strLocAddr = msgWsBodyItem.content;
            }
            else if([msgWsBodyItem.type isEqualToString:@"article_id"])
            {
                strArticleId = msgWsBodyItem.content;
            }
            else if([msgWsBodyItem.type isEqualToString:@"time"])
            {
                lRunBeginTime = [msgWsBodyItem.content longLongValue];
            }
            else if([msgWsBodyItem.type isEqualToString:@"latlng"])
            {
                strLatlng = msgWsBodyItem.content;
            }
            else if([msgWsBodyItem.type isEqualToString:@"addr_image"])
            {
                strMapUrl = msgWsBodyItem.content;
            }
        }
        
        if ([systemWsInfo.push.type isEqualToString:@"thumb"]) {
            strTips = [NSString stringWithFormat:@"%@%@赞了你的博文, 去看看多少人赞了吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"comment"])
        {
            strTips = [NSString stringWithFormat:@"%@%@回复了你的博文, 去看看多少人评论了吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"at"]){
            strTips = [NSString stringWithFormat:@"%@%@在博文中@了你, 去看看是什么事吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"coach"])
        {
            strTips = [NSString stringWithFormat:@"%@%@回复了你, 去看看点评吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"coachpass"]){
            strTips = [NSString stringWithFormat:@"跑步成绩%@通过审核, 请查看审核通过的运动记录！", strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"coachnpass"]){
            strTips = [NSString stringWithFormat:@"跑步成绩%@被拒绝, 请查看被拒绝的运动记录！", strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"subscribe"])
        {
            strTips = [NSString stringWithFormat:@"%@%@关注了你, 去Ta的主页看看吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"reward"])
        {
            strTips = [NSString stringWithFormat:@"%@%@给你的博文打赏了, 去看看有多少金币了吧！！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"tx"])
        {
            strTips = [NSString stringWithFormat:@"%@%@给你转帐了, 去Ta的主页看看吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"sendheart"])
        {
            strTips = [NSString stringWithFormat:@"%@%@给你发送了心跳, 和Ta一起感知运动的韵律吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"recvheart"])
        {
            strTips = [NSString stringWithFormat:@"%@%@接收了你的心跳, 成为你的朋友了，去聊聊吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"runshare"])
        {
            NSDate * beginDay = [NSDate dateWithTimeIntervalSince1970:lRunBeginTime];
            NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginDay];
            NSString *strRunTime = [NSString stringWithFormat:@"%02ld/%02ld/%04ld %.2ld:%.2ld", [comps month], [comps day], [comps year], [comps hour], [comps minute]];
            
            strTips = [NSString stringWithFormat:@"%@%@约你一起跑步, 去和Ta一起跑步吧！跑步时间：%@, 跑步地点：%@.", strNickName, strTime, strRunTime, strLocAddr];
        }
        else if([systemWsInfo.push.type isEqualToString:@"runshared"])
        {
            strTips = [NSString stringWithFormat:@"%@%@接受约跑了, 成为你的朋友了，去聊聊吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"postshare"])
        {
            strTips = [NSString stringWithFormat:@"%@%@发表了新文章, 去给Ta的文章点个赞吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"postshared"])
        {
            strTips = [NSString stringWithFormat:@"%@%@赞了你的博文, 成为你的朋友了，去聊聊吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"pkshare"])
        {
            strTips = [NSString stringWithFormat:@"%@%@向你发起了挑战, 去接受Ta的挑战吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"pkshared"])
        {
            strTips = [NSString stringWithFormat:@"%@%@接受了你的挑战, 成为你的朋友了，去聊聊吧！", strNickName, strTime];
        }
        else if([systemWsInfo.push.type isEqualToString:@"info"])
        {
            strTips = @"速度完善个人资料, 去领取50个金币奖励吧！";
        }
        else if([systemWsInfo.push.type isEqualToString:@"record"])
        {
            strTips = @"有人提交记录了, 去看看Ta的运动记录吧！";
        }
        
        __weak __typeof(self) weakSelf = self;
        
        [JDStatusBarNotification showWithStatus:strTips dismissAfter:6 styleName:JDStatusBarStyleDark actionBlock:^(void){
            __typeof(self) strongSelf = weakSelf;
            
            [JDStatusBarNotification dismiss];
            
            if ([systemWsInfo.push.type isEqualToString:@"comment"] || [systemWsInfo.push.type isEqualToString:@"at"] || [systemWsInfo.push.type isEqualToString:@"coach"] || [systemWsInfo.push.type isEqualToString:@"coachpass"] || [systemWsInfo.push.type isEqualToString:@"coachnpass"] || [systemWsInfo.push.type isEqualToString:@"thumb"] || [systemWsInfo.push.type isEqualToString:@"reward"] || [systemWsInfo.push.type isEqualToString:@"record"]) {
                
                [[SportForumAPI sharedInstance]articleGetByArticleId:systemWsInfo.push.pid FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
                    
                    if (strongSelf != nil) {
                        if (errorCode == 0) {
                            ArticlePagesViewController* articlePagesViewController = [[ArticlePagesViewController alloc] init];
                            articlePagesViewController.currentIndex = 0;
                            articlePagesViewController.arrayArticleInfos = [NSMutableArray arrayWithObject:articlesObject];
                            [strongSelf pushViewController:articlePagesViewController animated:YES];
                        }
                        else
                        {
                            [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                            
                            [[SportForumAPI sharedInstance]eventChangeStatusReadByEventType:-1 EventTypeStr:@"article" EventId:systemWsInfo.push.pid FinishedBlock:^(int errorCode){
                                [[ApplicationContext sharedInstance]checkNewEvent:nil];
                            }];
                        }
                    }
                }];
            }
            else
            {
                event_type eEventType = event_type_subscribe;
                
                if ([systemWsInfo.push.type isEqualToString:@"subscribe"]) {
                    eEventType = event_type_subscribe;
                }
                else if ([systemWsInfo.push.type isEqualToString:@"tx"]) {
                    eEventType = event_type_tx;
                }
                else if([systemWsInfo.push.type isEqualToString:@"sendheart"])
                {
                    eEventType = event_type_send_heart;
                }
                else if([systemWsInfo.push.type isEqualToString:@"recvheart"])
                {
                    eEventType = event_type_receive_heart;
                }
                else if([systemWsInfo.push.type isEqualToString:@"runshare"])
                {
                    eEventType = event_type_run_share;
                }
                else if([systemWsInfo.push.type isEqualToString:@"runshared"])
                {
                    eEventType = event_type_run_shared;
                }
                else if([systemWsInfo.push.type isEqualToString:@"postshare"])
                {
                    eEventType = event_type_post_share;
                }
                else if([systemWsInfo.push.type isEqualToString:@"postshared"])
                {
                    eEventType = event_type_post_shared;
                }
                else if([systemWsInfo.push.type isEqualToString:@"pkshare"])
                {
                    eEventType = event_type_pk_share;
                }
                else if([systemWsInfo.push.type isEqualToString:@"pkshared"])
                {
                    eEventType = event_type_pk_shared;
                }
                else if([systemWsInfo.push.type isEqualToString:@"info"])
                {
                    eEventType = event_type_info;
                }
                
                [[SportForumAPI sharedInstance]eventChangeStatusReadByEventType:eEventType EventTypeStr:@"" EventId:systemWsInfo.push.pid FinishedBlock:^(int errorCode){
                    [[ApplicationContext sharedInstance]checkNewEvent:nil];
                }];
                
                if (eEventType == event_type_send_heart) {
                    RecordReceiveHeartViewController * recordReceiveHeartViewController = [[RecordReceiveHeartViewController alloc]init];
                    recordReceiveHeartViewController.strSendId = strUserId;
                    recordReceiveHeartViewController.strRecordId = strRecordId;
                    [strongSelf pushViewController:recordReceiveHeartViewController animated:YES];
                }
                else if(eEventType == event_type_run_share)
                {
                    RunShareViewController *runShareViewController = [[RunShareViewController alloc]init];
                    runShareViewController.strSendId = systemWsInfo.push.from;
                    runShareViewController.strRecordId = strRecordId;
                    runShareViewController.strLocAddr = strLocAddr;
                    runShareViewController.lRunBeginTime = lRunBeginTime;
                    runShareViewController.strImgAddr = strMapUrl;
                    runShareViewController.strLatlng = strLatlng;
                    [strongSelf pushViewController:runShareViewController animated:YES];
                }
                else if(eEventType == event_type_post_share)
                {
                    ThumbShareViewController *thumbShareViewController = [[ThumbShareViewController alloc]init];
                    thumbShareViewController.strSendId = systemWsInfo.push.from;
                    thumbShareViewController.strArticleId = strArticleId;
                    [strongSelf pushViewController:thumbShareViewController animated:YES];
                }
                else if(eEventType == event_type_pk_share)
                {
                    PKShareViewController *pkShareViewController = [[PKShareViewController alloc]init];
                    pkShareViewController.strSendId = systemWsInfo.push.from;
                    pkShareViewController.strRecordId = strRecordId;
                    [strongSelf pushViewController:pkShareViewController animated:YES];
                }
                else if(eEventType == event_type_info)
                {
                    AccountEditViewController *accountEditViewController = [[AccountEditViewController alloc]init];
                    [strongSelf pushViewController:accountEditViewController animated:YES];
                }
                else
                {
                    AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
                    accountPreViewController.strUserId = systemWsInfo.push.from;
                    [strongSelf pushViewController:accountPreViewController animated:YES];
                }
            }
        }];
    }
}

/*- (BOOL)shouldAutorotate
{
    UINavigationController *pNavigationController = (UINavigationController*)self;
    
    if (pNavigationController.topViewController != nil && [pNavigationController.topViewController isKindOfClass:[TestWebViewController class]]) {
        return pNavigationController.topViewController.shouldAutorotate;
    }
    else
    {
        return NO;
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    UINavigationController *pNavigationController = (UINavigationController*)self;
    
    if (pNavigationController.topViewController != nil
        && [pNavigationController.topViewController isKindOfClass:[TestWebViewController class]]) {
        return pNavigationController.topViewController.supportedInterfaceOrientations;
    }
    else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    UINavigationController *pNavigationController = (UINavigationController*)self;
    
    if (pNavigationController.topViewController != nil && [pNavigationController.topViewController isKindOfClass:[TestWebViewController class]]) {
        return [pNavigationController.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
    }
    else
    {
        return interfaceOrientation == UIInterfaceOrientationPortrait;
    }
}*/

@end
