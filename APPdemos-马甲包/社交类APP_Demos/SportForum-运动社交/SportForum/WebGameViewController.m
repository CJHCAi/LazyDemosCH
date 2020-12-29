//
//  WebGameViewController.m
//  SportForum
//
//  Created by liyuan on 12/23/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "WebGameViewController.h"
#import "UIViewController+SportFormu.h"
#import "WebViewJavascriptBridge.h"
#import "AlertManager.h"
#import "UIImageView+WebCache.h"
#import "GameBoardViewController.h"

@interface WebGameViewController ()<UIWebViewDelegate>

@end

@implementation WebGameViewController
{
    UIWebView* _webView;
    UIView* _viewBoard;
    CSButton* m_btnBack;
    id m_popWindow;
    BOOL m_bNoNeedNotify;
    NSUInteger m_nCurScore;
    UIActivityIndicatorView* _activityIndicatorView;
    NSTimer *m_timerReward;
    UIImageView *_imgRewards[6];
    WebViewJavascriptBridge *javascriptBridge;
    NSDate *_startTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self generateCommonViewInParent:self.view Title:_gameTitle IsNeedBackBtn:YES];
    
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
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height)];
    _webView.scrollView.scrollEnabled = NO;
    _webView.scalesPageToFit = YES;
    _webView.opaque = NO;
    _webView.delegate = self;
    _webView.hidden = YES;
    _webView.backgroundColor = [UIColor clearColor];
    [viewBody addSubview:_webView];
    
    NSString *strDir = [NSString stringWithFormat:@"Game/%@", _gameDir];
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html" inDirectory:strDir];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    path = [path stringByAppendingString:@"/"];
    path = [path stringByAppendingString:strDir];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [_webView loadHTMLString:htmlString baseURL:baseURL];

    _startTime = [NSDate date];
    [self initWebViewBridge];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _webView.hidden = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"小游戏 - WebGameViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"小游戏 - WebGameViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self clearCacheAndCookies];
    [MobClick endLogPageView:@"小游戏 - WebGameViewController"];
    //[[SDImageCache sharedImageCache] clearDisk];
    //[[SDImageCache sharedImageCache] clearMemory];
}

//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

-(void)moveShowPathAnimation1
{
    [self moveShowPath:(UIView*)_imgRewards[1]];
}

-(void)moveShowPathAnimation2
{
    [self moveShowPath:(UIView*)_imgRewards[2]];
}

-(void)moveShowPathAnimation3
{
    [self moveShowPath:(UIView*)_imgRewards[3]];
}

-(void)moveShowPathAnimation4
{
    [self moveShowPath:(UIView*)_imgRewards[4]];
}

-(void)moveShowPathAnimation5
{
    [self moveShowPath:(UIView*)_imgRewards[5]];
}

- (void)moveShowPath:(UIView *)view
{
    CGRect frame = view.frame;
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, frame.size.height / 2);
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, APP_SCREEN_HEIGHT + frame.size.height / 2);
    
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = 0.8f;
    shakeAnimation.removedOnCompletion = NO;
    shakeAnimation.fillMode = kCAFillModeForwards;
    
    [shakeAnimation setCalculationMode:kCAAnimationLinear];
    [shakeAnimation setKeyTimes:[NSArray arrayWithObjects:
                                 [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0], nil]];
    
    [view.layer addAnimation:shakeAnimation forKey:nil];
    CFRelease(shakePath);
    
    frame = view.frame;
    frame.origin = CGPointMake(frame.origin.x,  APP_SCREEN_HEIGHT + frame.size.height / 2);
    view.frame = frame;
}

-(UIView*)generateBoardCellByRect:(CGRect)rectFrame Data:(LeaderBoardItem *)leaderBoardItem
{
    UIView *view = [[UIView alloc]initWithFrame:rectFrame];
    
    UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
    imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
    
    UIImageView *imgBoard = [[UIImageView alloc]init];
    [imgBoard setImage:imgBk];
    [view addSubview:imgBoard];
    
    UIImageView *boardImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imgBoard addSubview:boardImageView];
    
    UILabel* lbBoardRank = [[UILabel alloc]initWithFrame:CGRectZero];
    [imgBoard addSubview:lbBoardRank];
    
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imgBoard addSubview:userImageView];
    
    UIImageView *sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imgBoard addSubview:sexTypeImageView];
    
    UILabel* lbAge = [[UILabel alloc]initWithFrame:CGRectZero];
    [imgBoard addSubview:lbAge];
    
    UIImageView *imgViePhone = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imgBoard addSubview:imgViePhone];
    
    UIImageView *imgVieCoach = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imgBoard addSubview:imgVieCoach];
    
    UILabel *lbNickName = [[UILabel alloc]initWithFrame:CGRectZero];
    [imgBoard addSubview:lbNickName];
    
    UILabel *lbScore = [[UILabel alloc]initWithFrame:CGRectZero];
    [imgBoard addSubview:lbScore];

    UILabel *lbTime = [[UILabel alloc]initWithFrame:CGRectZero];
    [imgBoard addSubview:lbTime];
    
    imgBoard.frame = CGRectMake(0, 1, 290, 50);
    
    UIImage *image = nil;
    
    switch (leaderBoardItem.index) {
        case 1:
        {
            image = [UIImage imageNamed:@"crown-1"];
        }
            break;
        case 2:
        {
            image = [UIImage imageNamed:@"crown-2"];
        }
            break;
        case 3:
        {
            image = [UIImage imageNamed:@"crown-3"];
        }
            break;
        default:
            break;
    }
    
    if (image != nil) {
        lbBoardRank.hidden = YES;
        boardImageView.hidden = NO;
        boardImageView.frame = CGRectMake(5, 7, 40, 36);
        [boardImageView setImage:image];
    }
    else
    {
        lbBoardRank.hidden = NO;
        boardImageView.hidden = YES;
    }
    
    lbBoardRank.backgroundColor = [UIColor clearColor];
    lbBoardRank.text = [NSString stringWithFormat:@"%ld", leaderBoardItem.index];
    lbBoardRank.textColor = [UIColor blackColor];
    lbBoardRank.font = [UIFont boldSystemFontOfSize:16];
    lbBoardRank.frame = CGRectMake(8, 15, 30, 20);
    lbBoardRank.textAlignment = NSTextAlignmentCenter;
    
    [userImageView sd_setImageWithURL:[NSURL URLWithString:leaderBoardItem.user_profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    userImageView.layer.cornerRadius = 5.0;
    userImageView.layer.masksToBounds = YES;
    userImageView.frame = CGRectMake(CGRectGetMaxX(lbBoardRank.frame) + 8, 3, 40, 40);
    
    sexTypeImageView.frame = CGRectMake(CGRectGetMaxX(userImageView.frame) + 8, 5, 40, 18);
    [sexTypeImageView setImage:[UIImage imageNamed:[leaderBoardItem.sex_type isEqualToString:sex_male] ? @"gender-male" : @"gender-female"]];
    sexTypeImageView.backgroundColor = [UIColor clearColor];
    
    lbAge.backgroundColor = [UIColor clearColor];
    lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:leaderBoardItem.birthday];
    lbAge.textColor = [UIColor whiteColor];
    lbAge.font = [UIFont systemFontOfSize:10];
    lbAge.frame = CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, 7, 20, 10);
    lbAge.textAlignment = NSTextAlignmentRight;
    
    CGFloat fStartPoint = CGRectGetMaxX(sexTypeImageView.frame) + 4;
    
    imgViePhone.frame = CGRectMake(fStartPoint, 7, 8, 14);
    [imgViePhone setImage:[UIImage imageNamed:@"phone-verified-small"]];
    imgViePhone.backgroundColor = [UIColor clearColor];
    imgViePhone.hidden = leaderBoardItem.phone_number.length > 0 ? NO : YES;
    
    if (!imgViePhone.hidden) {
        fStartPoint = CGRectGetMaxX(imgViePhone.frame) + 2;
    }
    
    [imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
    imgVieCoach.backgroundColor = [UIColor clearColor];
    imgVieCoach.hidden = ([leaderBoardItem.actor isEqualToString:@"coach"]) ? NO : YES;
    imgVieCoach.frame = CGRectMake(fStartPoint, 3, 20, 20);
    
    if (!imgVieCoach.hidden) {
        fStartPoint = CGRectGetMaxX(imgVieCoach.frame) + 2;
    }
    
    lbNickName.backgroundColor = [UIColor clearColor];
    lbNickName.text = leaderBoardItem.nikename;
    lbNickName.textColor = [UIColor blackColor];
    lbNickName.font = [UIFont boldSystemFontOfSize:12];
    lbNickName.frame = CGRectMake(fStartPoint, 3, CGRectGetWidth(imgBoard.frame) - fStartPoint - 10, 20);
    lbNickName.textAlignment = NSTextAlignmentLeft;
    
    lbScore.backgroundColor = [UIColor clearColor];
    
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if([leaderBoardItem.userid isEqualToString:userInfo.userid])
    {
         lbScore.text = [NSString stringWithFormat:@"本次分：%ld", leaderBoardItem.score];
    }
    else
    {
        lbScore.text = [NSString stringWithFormat:@"最高分：%ld", leaderBoardItem.score];
    }
    
    lbScore.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];//[UIColor colorWithRed:176.0 / 255.0 green:150.0 / 255.0 blue:32.0 / 255.0 alpha:1.0];
    lbScore.font = [UIFont boldSystemFontOfSize:12];
    lbScore.frame = CGRectMake(CGRectGetMinX(sexTypeImageView.frame), CGRectGetMaxY(userImageView.frame) - 20, 150, 20);
    lbScore.textAlignment = NSTextAlignmentLeft;
    
    lbTime.backgroundColor = [UIColor clearColor];
    lbTime.textColor = [UIColor darkGrayColor];
    lbTime.font = [UIFont boldSystemFontOfSize:12];
    lbTime.frame = CGRectMake(CGRectGetWidth(imgBoard.frame) - 100, CGRectGetMaxY(userImageView.frame) - 20, 90, 20);
    lbTime.textAlignment = NSTextAlignmentRight;
    
    if (leaderBoardItem.recent_login_time > 0) {
        lbTime.hidden = NO;
        lbTime.text = [NSString stringWithFormat:@"%@玩过", [[CommonUtility sharedInstance]compareCurrentTime:[NSDate dateWithTimeIntervalSince1970:leaderBoardItem.recent_login_time]]];
    }
    else
    {
        lbTime.hidden = YES;
    }
    
    return view;
}

-(UIView*)generateBoardView:(int)nCurScores
{
    if (_viewBoard != nil) {
        for (UIView *view in [_viewBoard subviews]) {
            [view removeFromSuperview];
        }
        
        [_viewBoard removeFromSuperview];
    }

    _viewBoard = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 290, 260)];
    _viewBoard.backgroundColor = [UIColor clearColor];
    
    UIImage * imgBlogTabLeft = [UIImage imageNamed:@"blog-tab-left"];
    UIImage * imgBlogTabLeftSel = [UIImage imageNamed:@"blog-tab-left-sel"];
    UIImage * imgBlogTabRight = [UIImage imageNamed:@"blog-tab-right"];
    UIImage * imgBlogTabRightSel = [UIImage imageNamed:@"blog-tab-right-sel"];
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
    imgBlogTabLeft = [imgBlogTabLeft resizableImageWithCapInsets:insets];
    imgBlogTabLeftSel = [imgBlogTabLeftSel resizableImageWithCapInsets:insets];
    imgBlogTabRight = [imgBlogTabRight resizableImageWithCapInsets:insets];
    imgBlogTabRightSel = [imgBlogTabRightSel resizableImageWithCapInsets:insets];
    
    CSButton *btnTotalBoard = [CSButton buttonWithType:UIButtonTypeCustom];
    btnTotalBoard.frame = CGRectMake(_viewBoard.frame.size.width / 2 - 100, 15, 100, 23);
    btnTotalBoard.tag = 10;
    btnTotalBoard.hidden = YES;
    [btnTotalBoard setTitle:@"总排行" forState:UIControlStateNormal];
    [btnTotalBoard.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [btnTotalBoard setBackgroundImage:imgBlogTabLeft forState:UIControlStateNormal];
    [btnTotalBoard setBackgroundImage:imgBlogTabLeftSel forState:UIControlStateSelected];
    [btnTotalBoard setTitleColor:[UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnTotalBoard setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnTotalBoard setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_viewBoard addSubview:btnTotalBoard];
    
    CSButton *btnFriendBoard = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFriendBoard.frame = CGRectMake(_viewBoard.frame.size.width / 2, 15, 100, 23);
    btnFriendBoard.tag = 11;
    btnFriendBoard.hidden = YES;
    [btnFriendBoard setTitle:@"好友排行" forState:UIControlStateNormal];
    [btnFriendBoard.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [btnFriendBoard setBackgroundImage:imgBlogTabRight forState:UIControlStateNormal];
    [btnFriendBoard setBackgroundImage:imgBlogTabRightSel forState:UIControlStateSelected];
    [btnFriendBoard setTitleColor:[UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnFriendBoard setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnFriendBoard setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_viewBoard addSubview:btnFriendBoard];

    UILabel *lbNetWorkError = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btnTotalBoard.frame) + 10, _viewBoard.frame.size.width - 30, 30)];
    lbNetWorkError.backgroundColor = [UIColor clearColor];
    lbNetWorkError.tag = 30;
    lbNetWorkError.textColor = [UIColor whiteColor];
    lbNetWorkError.textAlignment = NSTextAlignmentLeft;
    lbNetWorkError.font = [UIFont boldSystemFontOfSize:14];
    lbNetWorkError.text = @"获取游戏排行榜失败！";
    lbNetWorkError.hidden = YES;
    [_viewBoard addSubview:lbNetWorkError];

    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicatorView.color = [UIColor whiteColor];
    activityIndicatorView.center = _viewBoard.center;
    activityIndicatorView.tag = 13;
    activityIndicatorView.hidden = NO;
    activityIndicatorView.hidesWhenStopped = YES;
    [_viewBoard addSubview:activityIndicatorView];
    [_viewBoard bringSubviewToFront:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
    UIView *viewTotalBoard = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btnTotalBoard.frame) + 10, 290, 160)];
    viewTotalBoard.backgroundColor = [UIColor clearColor];
    viewTotalBoard.tag = 14;
    viewTotalBoard.hidden = YES;
    [_viewBoard addSubview:viewTotalBoard];
    
    UILabel *lbNoRecord = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 270, 15)];
    lbNoRecord.backgroundColor = [UIColor clearColor];
    lbNoRecord.tag = 15;
    lbNoRecord.textColor = [UIColor whiteColor];
    lbNoRecord.textAlignment = NSTextAlignmentLeft;
    lbNoRecord.font = [UIFont boldSystemFontOfSize:14];
    lbNoRecord.text = @"亲，还没人玩过该游戏哦~";
    lbNoRecord.hidden = YES;
    [viewTotalBoard addSubview:lbNoRecord];
    
    CSButton *btnTotalCell = [CSButton buttonWithType:UIButtonTypeCustom];
    btnTotalCell.frame = CGRectMake(0, 0, CGRectGetWidth(viewTotalBoard.frame), CGRectGetHeight(viewTotalBoard.frame));
    btnTotalCell.tag = 16;
    btnTotalCell.backgroundColor = [UIColor clearColor];
    [viewTotalBoard addSubview:btnTotalCell];
    
    UIView *viewFriendBoard = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(btnTotalBoard.frame) + 10, 290, 160)];
    viewFriendBoard.backgroundColor = [UIColor clearColor];
    viewFriendBoard.tag = 17;
    viewFriendBoard.hidden = YES;
    [_viewBoard addSubview:viewFriendBoard];
    
    CSButton *btnFriendsCell = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFriendsCell.frame = CGRectMake(0, 0, CGRectGetWidth(viewFriendBoard.frame), CGRectGetHeight(viewFriendBoard.frame));
    btnFriendsCell.tag = 18;
    btnFriendsCell.backgroundColor = [UIColor clearColor];
    [viewFriendBoard addSubview:btnFriendsCell];
    
    UILabel *lbNoRecord1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 270, 15)];
    lbNoRecord1.backgroundColor = [UIColor clearColor];
    lbNoRecord1.tag = 19;
    lbNoRecord1.textColor = [UIColor whiteColor];
    lbNoRecord1.textAlignment = NSTextAlignmentLeft;
    lbNoRecord1.font = [UIFont boldSystemFontOfSize:14];
    lbNoRecord1.text = @"亲，您还没有好友玩过该游戏哦~";
    lbNoRecord1.hidden = YES;
    [viewFriendBoard addSubview:lbNoRecord1];
    
    UILabel *lbCurScores = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewTotalBoard.frame), 100, 20)];
    lbCurScores.backgroundColor = [UIColor clearColor];
    lbCurScores.tag = 20;
    lbCurScores.textColor = [UIColor whiteColor];
    lbCurScores.textAlignment = NSTextAlignmentLeft;
    lbCurScores.font = [UIFont boldSystemFontOfSize:14];
    lbCurScores.text = @"本次分数：";
    [_viewBoard addSubview:lbCurScores];
    
    UILabel *lbCurScoresData = [[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(viewTotalBoard.frame), 170, 20)];
    lbCurScoresData.backgroundColor = [UIColor clearColor];
    lbCurScoresData.tag = 40;
    lbCurScoresData.textColor = [UIColor colorWithRed:248.0 / 255.0 green:236.0 / 255.0 blue:56.0 / 255.0 alpha:1.0];
    lbCurScoresData.textAlignment = NSTextAlignmentLeft;
    lbCurScoresData.font = [UIFont boldSystemFontOfSize:20];
    lbCurScoresData.text = [NSString stringWithFormat:@"%d", nCurScores];
    [_viewBoard addSubview:lbCurScoresData];
    
    UILabel *lbTopScores = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbCurScores.frame), 100, 20)];
    lbTopScores.backgroundColor = [UIColor clearColor];
    lbTopScores.tag = 21;
    lbTopScores.textColor = [UIColor whiteColor];
    lbTopScores.textAlignment = NSTextAlignmentLeft;
    lbTopScores.font = [UIFont boldSystemFontOfSize:14];
    lbTopScores.text = @"历史最高分：";
    [_viewBoard addSubview:lbTopScores];
    
    UILabel *lbTopScoresData = [[UILabel alloc]initWithFrame:CGRectMake(100, CGRectGetMaxY(lbCurScores.frame), 170, 20)];
    lbTopScoresData.backgroundColor = [UIColor clearColor];
    lbTopScoresData.tag = 41;
    lbTopScoresData.textColor = [UIColor whiteColor];
    lbTopScoresData.textAlignment = NSTextAlignmentLeft;
    lbTopScoresData.font = [UIFont boldSystemFontOfSize:14];
    lbTopScoresData.text = @"正在努力加载...";
    [_viewBoard addSubview:lbTopScoresData];
    
    UILabel *lbPercent = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbTopScores.frame), 270, 20)];
    lbPercent.backgroundColor = [UIColor clearColor];
    lbPercent.tag = 22;
    lbPercent.textColor = [UIColor whiteColor];
    lbPercent.textAlignment = NSTextAlignmentLeft;
    lbPercent.font = [UIFont boldSystemFontOfSize:14];
    lbPercent.text = @"";
    lbPercent.hidden = YES;
    [_viewBoard addSubview:lbPercent];
    
    UILabel *lbPercentFri = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbTopScores.frame), 270, 20)];
    lbPercentFri.backgroundColor = [UIColor clearColor];
    lbPercentFri.tag = 23;
    lbPercentFri.textColor = [UIColor whiteColor];
    lbPercentFri.textAlignment = NSTextAlignmentLeft;
    lbPercentFri.font = [UIFont boldSystemFontOfSize:14];
    lbPercentFri.text = @"";
    lbPercentFri.hidden = YES;
    [_viewBoard addSubview:lbPercentFri];
    
    __weak typeof (self) thisPoint = self;
    __typeof__(CSButton) __weak *thisbtnTotal = btnTotalBoard;
    __typeof__(CSButton) __weak *thisbtnFriend = btnFriendBoard;
    btnTotalBoard.selected = true;
    btnFriendBoard.selected = false;
    btnTotalBoard.actionBlock = ^void()
    {
        typeof(CSButton) *thisStrongbtnTotal = thisbtnTotal;
        typeof(CSButton) *thisStrongbtnFriend = thisbtnFriend;
        if(thisStrongbtnFriend.selected)
        {
            thisStrongbtnTotal.selected = true;
            thisStrongbtnFriend.selected = false;
        }
        
        viewTotalBoard.hidden = NO;
        viewFriendBoard.hidden = YES;
        
        lbPercent.hidden = NO;
        lbPercentFri.hidden = YES;
    };
    
    btnFriendBoard.actionBlock = ^void()
    {
        typeof(CSButton) *thisStrongbtnTotal = thisbtnTotal;
        typeof(CSButton) *thisStrongbtnFriend = thisbtnFriend;
        if(thisStrongbtnTotal.selected)
        {
            thisStrongbtnFriend.selected = true;
            thisStrongbtnTotal.selected = false;
        }
        
        viewTotalBoard.hidden = YES;
        viewFriendBoard.hidden = NO;
        
        lbPercent.hidden = YES;
        lbPercentFri.hidden = NO;
    };

    btnTotalCell.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        strongSelf->m_bNoNeedNotify = YES;
        strongSelf->m_btnBack.actionBlock();
        
        GameBoardViewController *gameBoardViewController = [[GameBoardViewController alloc]init];
        gameBoardViewController.eQueryType = board_query_type_top;
        gameBoardViewController.eGameType = strongSelf.eGameType;
        gameBoardViewController.isTask = (strongSelf.taskInfo != nil ? YES : NO);
        gameBoardViewController.nCurScore = strongSelf->m_nCurScore;
        [strongSelf.navigationController pushViewController:gameBoardViewController animated:YES];
    };
    
    btnFriendsCell.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        strongSelf->m_bNoNeedNotify = YES;
        strongSelf->m_btnBack.actionBlock();
        
        GameBoardViewController *gameBoardViewController = [[GameBoardViewController alloc]init];
        gameBoardViewController.eQueryType = board_query_type_friend;
        gameBoardViewController.eGameType = strongSelf.eGameType;
        gameBoardViewController.isTask = (strongSelf.taskInfo != nil ? YES : NO);
        gameBoardViewController.nCurScore = strongSelf->m_nCurScore;
        [strongSelf.navigationController pushViewController:gameBoardViewController animated:YES];
    };

    return _viewBoard;
}

-(void)clearCacheAndCookies
{
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
 
    //清除cookies
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    
    //清除缓存（全）
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];
}

-(void)initWebViewBridge
{
    //[WebViewJavascriptBridge enableLogging];
    
    m_nCurScore = 0;
    __typeof(self) __weak weakSelf = self;
    
    javascriptBridge = [WebViewJavascriptBridge bridgeForWebView:_webView handler:^(id data, WVJBResponseCallback responseCallback) {
        __typeof(self) strongSelf = weakSelf;
        
        if (strongSelf == nil) {
            return;
        }
        
        NSLog(@"ObjC received message from JS: %@", data);
        
        int nCurScore = [[data objectForKey:@"CurrentScore"]intValue];
        [strongSelf clearCacheAndCookies];
        
        __typeof(self) __weak weakStrongSelf = strongSelf;
        
        strongSelf->m_popWindow = [AlertManager showConfirmAlertWithTitle:@"分数排行" ContentView:[strongSelf generateBoardView:nCurScore] ConfirmButtonTitle:@"关闭" ConfirmBlock:^BOOL(id window){
            __typeof(self) strongStrongSelf = weakStrongSelf;
            
            if (strongStrongSelf != nil) {
                if (strongStrongSelf->_taskInfo != nil) {
                    if (!strongStrongSelf->m_bNoNeedNotify) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_SWITCH_VIEW object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:VIEW_MAIN_PAGE, @"PageName", nil]];
                        
                        if(nCurScore < 100)
                        {
                            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showFailAnimationWhenExecuteTask) userInfo:nil repeats:NO];
                        }
                        else
                        {
                            [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showSuccessAnimationWhenExecuteTask) userInfo:nil repeats:NO];
                        }
                    }
                }
                else
                {
                    if (!strongStrongSelf->m_bNoNeedNotify) {
                        [strongStrongSelf.navigationController popViewControllerAnimated:YES];
                    }
                }
            }

            return YES;
        } WithCancelButton:NO];
        
        [strongSelf publishAfterGameOver:nCurScore];
        /*
        int nBestScore = [[data objectForKey:@"BestScore"]intValue];
        
        NSArray* array = [[NSBundle mainBundle]loadNibNamed:@"GameCompleteView" owner:nil options:nil];
        GameCompleteView* completeView = array[0];
        completeView.nleaderBoEffect = nBestScore;
        completeView.nExpEffect = nCurScore;
        
        __typeof(self) __weak weakStrongSelf = strongSelf;
        
        completeView.closeActionBlock = ^(id sender){
            UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
            
            if (userInfo != nil) {
                if (userInfo.ban_time > 0) {
                    [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    return;
                }
                else if(userInfo.ban_time < 0)
                {
                    [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    return;
                }
            }
            
            __typeof(self) strongSelf1 = weakStrongSelf;
            
            if (nCurScore > 0) {
                [strongSelf1 publishAfterGameOver:nCurScore];
            }
            else
            {
                [AlertManager showAlertText:@"游戏总分低，没有金币和魔法值奖励哦！"];
                [strongSelf1.navigationController popViewControllerAnimated:YES];
            }
        };
        
        [completeView showInView:strongSelf.navigationController.view];*/
    }];
    
    /*[javascriptBridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
    NSString *strImagePath = [[NSBundle mainBundle]pathForResource:@"image-placeholder" ofType:@"png"];
    
    [javascriptBridge send:@{ @"NickName":userInfo.nikename.length > 0 ? userInfo.nikename : @"匿名",  @"ProfileUrl":userInfo.profile_image.length > 0 ? userInfo.profile_image : strImagePath } responseCallback:^(id responseData) {
        NSLog(@"objc got response! %@", responseData);
    }];*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"WebGameViewController dealloc called!");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*-(void)updateProfileInfo:(NSDictionary*) dictUserInfo
{
    if (m_timerReward != nil) {
        dictUserInfo = m_timerReward.userInfo;
    }
    
    ExpEffect* expEffect = [dictUserInfo objectForKey:@"RewardEffect"];
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
     {
         if (errorCode == 0)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
         }
         
         [m_timerReward invalidate];
         m_timerReward = nil;
     }];
}*/

-(void)getGameResult:(ExpEffect*) expEffect GameScore:(int)nCurScore
{
    __typeof(self) __weak weakSelf = self;
        
    [[SportForumAPI sharedInstance]userGameResultByType:_eGameType GameScore:nCurScore FinishedBlock:^(int errorCode, GameResultInfo *gameResultInfo)
     {
         __typeof(self) strongSelf = weakSelf;
         
         if (strongSelf == nil) {
             return;
         }
         
         CSButton *btnTotalBoard = (CSButton*)[_viewBoard viewWithTag:10];
         btnTotalBoard.hidden = YES;
         
         CSButton *btnFriendBoard = (CSButton*)[_viewBoard viewWithTag:11];
         btnFriendBoard.hidden = YES;
         
         UILabel *lbNetWorkError = (UILabel*)[_viewBoard viewWithTag:30];
         lbNetWorkError.hidden = YES;
         
         UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView*)[_viewBoard viewWithTag:13];
         [activityIndicatorView stopAnimating];

         UIView *viewTotalBoard = [_viewBoard viewWithTag:14];
         viewTotalBoard.hidden = YES;
         
         UILabel *lbNoRecord = (UILabel*)[viewTotalBoard viewWithTag:15];
         lbNoRecord.hidden = YES;
         
         CSButton *btnTotalCell = (CSButton*)[viewTotalBoard viewWithTag:16];
         btnTotalCell.hidden = YES;

         UIView *viewFriendBoard = [_viewBoard viewWithTag:17];
         viewFriendBoard.hidden = YES;
         
         UILabel *lbNoRecord1 = (UILabel*)[viewFriendBoard viewWithTag:19];
         lbNoRecord1.hidden = YES;
         
         CSButton *btnFriendsCell = (CSButton*)[viewFriendBoard viewWithTag:18];
         btnFriendsCell.hidden = YES;
         
         UILabel *lbPercent = (UILabel*)[_viewBoard viewWithTag:22];
         lbPercent.hidden = YES;
         
         UILabel *lbPercentFri = (UILabel*)[_viewBoard viewWithTag:23];
         lbPercentFri.hidden = YES;
         
         UILabel *lbTopScoresData = (UILabel*)[_viewBoard viewWithTag:41];
         
         m_btnBack.enabled = YES;

         if (errorCode == 0) {
             btnTotalBoard.hidden = NO;
             btnFriendBoard.hidden = NO;
             viewTotalBoard.hidden = NO;
             
             lbTopScoresData.text = [NSString stringWithFormat:@"%lu", gameResultInfo.total_score];
             
             NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]};
             NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"本次游戏你打败了" attributes:attribs];
             
             attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName:[UIColor colorWithRed:248.0 / 255.0 green:236.0 / 255.0 blue:56.0 / 255.0 alpha:1.0]};
             NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu%%", gameResultInfo.percent] attributes:attribs];
             
            NSAttributedString * strPart3Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu%%", gameResultInfo.percentFri] attributes:attribs];
             
             attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]};
             NSAttributedString * strPart4Value = [[NSAttributedString alloc] initWithString:@"的用户" attributes:attribs];
             
             attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor whiteColor]};
             NSAttributedString * strPart5Value = [[NSAttributedString alloc] initWithString:@"的好友" attributes:attribs];
             
             NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
             [strPer appendAttributedString:strPart2Value];
             [strPer appendAttributedString:strPart4Value];
             lbPercent.attributedText = strPer;
             
             NSMutableAttributedString * strPerFri = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
             [strPerFri appendAttributedString:strPart3Value];
             [strPerFri appendAttributedString:strPart5Value];
             lbPercentFri.attributedText = strPerFri;
             
             lbPercent.hidden = NO;
             
             if ([gameResultInfo.total_list.data count] > 0) {
                 for (NSUInteger i = 0; i < MIN([gameResultInfo.total_list.data count], 3); i++) {
                     CGRect rect = CGRectMake(0, 52 * i, CGRectGetWidth(viewTotalBoard.frame), 52);
                     UIView *viewCell = [self generateBoardCellByRect:rect Data:gameResultInfo.total_list.data[i]];
                     [viewTotalBoard addSubview:viewCell];
                 }
                 
                 btnTotalCell.hidden = NO;
                 [viewTotalBoard bringSubviewToFront:btnTotalCell];
             }
             else
             {
                 lbNoRecord.hidden = NO;
             }
             
             if ([gameResultInfo.friends_list.data count] > 0) {
                 for (NSUInteger i = 0; i < MIN([gameResultInfo.friends_list.data count], 3); i++) {
                     CGRect rect = CGRectMake(0, 52 * i, CGRectGetWidth(viewTotalBoard.frame), 52);
                     UIView *viewCell = [self generateBoardCellByRect:rect Data:gameResultInfo.friends_list.data[i]];
                     [viewFriendBoard addSubview:viewCell];
                 }
                 
                 btnFriendsCell.hidden = NO;
                 [viewFriendBoard bringSubviewToFront:btnFriendsCell];
             }
             else
             {
                 lbNoRecord1.hidden = NO;
             }
         }
         else
         {
             lbNetWorkError.hidden = NO;
         }
         
         if (expEffect != nil && (expEffect.exp_physique > 0 || expEffect.exp_literature > 0 || expEffect.exp_magic > 0 || expEffect.exp_coin > 0)) {
             /*m_timerReward = [NSTimer scheduledTimerWithTimeInterval: 2
                                                              target: self
                                                            selector: @selector(updateProfileInfo:)
                                                            userInfo: [NSDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]
                                                             repeats: NO];*/
             
             UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
             
             [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
              {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
              }];
         }
         
         if(expEffect != nil && expEffect.exp_coin > 0)
         {
             [self showRewardAnimation];
         }
//         else
//         {
//             [AlertManager showAlertText:@"游戏总分低，没有金币奖励哦~" InView:strongSelf.view hiddenAfter:2];
//         }
     }];
}

-(void)showRewardAnimation
{
    UIView *viewBg = [AlertManager getViewByID:m_popWindow Tag:ALERT_VIEW_ITEM_TAG_FULL_VIEW];
    
    for(int i = 0; i < 6; i++)
    {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"game-coin-%d", i + 1]];
        int nPosX = [self getRandomNumber:0 to:(CGRectGetWidth(self.view.frame) - img.size.width)];
        _imgRewards[i] = [[UIImageView alloc] initWithFrame:CGRectMake(nPosX, -img.size.height, img.size.width, img.size.height)];
        [_imgRewards[i] setImage:img];
        
        [viewBg addSubview:_imgRewards[i]];
        [viewBg bringSubviewToFront:_imgRewards[i]];
    }
    
    [self moveShowPath:(UIView*)_imgRewards[0]];
    
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(moveShowPathAnimation1) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(moveShowPathAnimation2) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(moveShowPathAnimation3) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(moveShowPathAnimation4) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(moveShowPathAnimation5) userInfo:nil repeats:NO];
    [[CommonUtility sharedInstance]playAudioFromName:@"gameCoin.mp3"];
}

-(void)showFailAnimationWhenExecuteTask
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_ANIMATION_STATE object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TaskFail", @"AnimationState", nil]];
}

-(void)showSuccessAnimationWhenExecuteTask
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_ANIMATION_STATE object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"TaskSuccess", @"AnimationState", nil]];
}

-(void)publishAfterGameOver:(int)nCurScore
{
    BOOL bBanTime = NO;
    m_nCurScore = nCurScore;
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    
    if (userInfo != nil) {
        if (userInfo.ban_time > 0) {
            bBanTime = YES;
            [JDStatusBarNotification showWithStatus:@"用户已被禁言，不能记录成绩。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        }
        else if(userInfo.ban_time < 0)
        {
            bBanTime = YES;
            [JDStatusBarNotification showWithStatus:@"用户已进入黑名单，不能记录成绩。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        }
    }
    
    m_btnBack = [AlertManager getViewByID:m_popWindow Tag:ALERT_VIEW_ITEM_TAG_BTN_CONFIRM];
    m_btnBack.enabled = NO;
    
    if (bBanTime) {
        [self getGameResult:nil GameScore:nCurScore];
    }
    else
    {
        if (nCurScore < 100) {
            if (_taskInfo == nil) {
                [JDStatusBarNotification showWithStatus:@"游戏总分低，没有金币和魔法值奖励哦！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            }
            
            [self getGameResult:nil GameScore:nCurScore];
        }
        else
        {
            SportRecordInfo* sportRecordInfo =[[SportRecordInfo alloc]init];
            sportRecordInfo.type = @"game";
            sportRecordInfo.begin_time = [[NSDate date] timeIntervalSince1970];
            sportRecordInfo.game_score = nCurScore;
            sportRecordInfo.game_name = _gameTitle;
            sportRecordInfo.game_type = [CommonFunction ConvertGameTypeToString:_eGameType];
            sportRecordInfo.sport_pics = nil;
            sportRecordInfo.duration = [[NSDate date] timeIntervalSinceDate:_startTime];
            
            __typeof(self) __weak weakSelf = self;

            [[SportForumAPI sharedInstance]recordNewByRecordItem:sportRecordInfo RecordId:_taskInfo.task_id Public:NO
                                                   FinishedBlock:^(int errorCode, NSString* strDescErr, NSString* strRecordId, ExpEffect* expEffect) {
                                                       __typeof(self) strongSelf = weakSelf;
                                                       
                                                       if (strongSelf != nil) {
                                                           if (errorCode == 0) {
                                                               if (_taskInfo != nil) {
                                                                   [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_TASK_STATUS object:nil];
                                                               }
                                                           }
                                                           else
                                                           {
                                                               [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                           }
                                                           
                                                           [self getGameResult:expEffect GameScore:nCurScore];
                                                       }
                                                   }];
        }
    }
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
