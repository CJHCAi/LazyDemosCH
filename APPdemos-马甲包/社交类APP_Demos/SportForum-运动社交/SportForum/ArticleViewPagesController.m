//
//  ArticleViewPagesController.m
//  SportForum
//
//  Created by zhengying on 6/12/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "ArticleViewPagesController.h"
#import "ArticleViewController.h"
#import "SwipeView.h"
#import "WallCell.h"
#import "ImageEditViewController.h"
#import "CustomMenuViewController.h"
#import "FooterViewController.h"
#import "SportForumAPI.h"
#import "AlertManager.h"
#import "ArticlePublicViewController.h"
#import "ApplicationContext.h"
#import "ChatMessageTableViewController.h"
#import <ShareSDK/ShareSDK.h>
//#import "RegisterLonginViewController.h"
#import "UIViewController+SportFormu.h"
#import "WalletTransferViewController.h"

#define cCommentBoardHeight 210
#define cCountIconWidth 20
#define cBoardTopSpace 8
#define cCountLableWidth 80
#define CCountLableHeight 30.0

#define cUnhidenWidth  26

#define cCommentCellHeight  120

@interface ArticleViewPagesController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate, SwipeViewDelegate, SwipeViewDataSource, ISSShareViewDelegate, UIAlertViewDelegate>

@end

@implementation ArticleViewPagesController {
    UIPageViewController* _pageViewController;
    UIView* _viewCommentBoard;
    SwipeView* _swipeView;
    
    UIImageView* _imageViewThumbCount;
    UIImageView* _imageViewCommentCount;
    UIImageView* _imageViewRewardCount;
    
    UILabel* _lblThumbCount;
    UILabel* _lblCommentCount;
    UILabel* _lblRewardCount;
    
    UIButton* _btnNoComment;
    CSButton *_btnDel;
    UIAlertView* _alertView;
    BOOL _blToggling;
    BOOL _blCommentBoardShowed;
    FooterViewController* _footViewController;
    
    CustomMenuViewController *_customMenuViewController;
    
    UIActivityIndicatorView* _activityIndicatorView;
    
    NSMutableArray* _arrayCommentInfos; // comments
    NSString* _lastCommentID;
    NSString* _fristCommentID;
    
    id  _progressInCommentBoard;
    id m_processWindow;
    
    BOOL _isThumbed;
    
    __weak ArticleViewController* _currentArticleViewController;
}

-(void)loadTestData {
    /*
     _arrayCommentInfos = [[NSMutableArray alloc]init];
     
     WallCellInfo* cellInfo = [[WallCellInfo alloc]init];
     cellInfo.imageURL = @"TESTPIC";
     cellInfo.title = @"测试一下评论";
     
     
     [_arrayCommentInfos addObject:cellInfo];
     
     cellInfo = [[WallCellInfo alloc]init];
     cellInfo.imageURL = @"TESTPIC";
     cellInfo.title = @"测试一下评论";
     
     
     [_arrayCommentInfos addObject:cellInfo];
     
     cellInfo = [[WallCellInfo alloc]init];
     cellInfo.imageURL = @"TESTPIC";
     cellInfo.title = @"测试一下评论";
     
     
     [_arrayCommentInfos addObject:cellInfo];
     
     cellInfo = [[WallCellInfo alloc]init];
     cellInfo.imageURL = @"TESTPIC";
     cellInfo.title = @"测试一下评论";
     
     
     [_arrayCommentInfos addObject:cellInfo];
     
     cellInfo = [[WallCellInfo alloc]init];
     cellInfo.imageURL = @"TESTPIC";
     cellInfo.title = @"测试一下评论";
     
     
     [_arrayCommentInfos addObject:cellInfo];
     
     cellInfo = [[WallCellInfo alloc]init];
     cellInfo.imageURL = @"TESTPIC";
     cellInfo.title = @"测试一下评论";
     
     
     [_arrayCommentInfos addObject:cellInfo];
     */
    
    _arrayCommentInfos = _arrayArticleInfos;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateArticle) name:NOTIFY_MESSAGE_UPDATE_ARTICLE_AFTER_EVENT object:nil];
    [self generateCommonViewInParent:self.view Title:@"" IsNeedBackBtn:YES];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70 - cUnhidenWidth);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    _btnDel = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnDel.frame = CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 42, CGRectGetMinY(viewTitleBar.frame) + 3, 39, 35);
    [_btnDel setBackgroundImage:[UIImage imageNamed:@"btn-4-yellow-del"] forState:UIControlStateNormal];
    _btnDel.hidden = !_bOwnArticles;
    [self.view addSubview:_btnDel];
    
    __weak typeof (self) thisPoint = self;
    
    _btnDel.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
        
        if (userInfo != nil) {
            if (userInfo.ban_time > 0) {
                [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:strongSelf.view hiddenAfter:2];
                return;
            }
            else if(userInfo.ban_time < 0)
            {
                [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:strongSelf.view hiddenAfter:2];
                return;
            }
        }
        
        [strongSelf actionDelete];
    };

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
    
    ArticleViewController* articleViewController = [[ArticleViewController alloc]init];
    
    if (_arrayArticleInfos.count > _currentIndex) {
        [_pageViewController setViewControllers:@[articleViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        [viewBody addSubview:_pageViewController.view];
        _currentArticleViewController = articleViewController;
    }
    
    [self createCommentBoard];
    
    articleViewController = _currentArticleViewController;
    articleViewController.articleObject = _arrayArticleInfos[_currentIndex];
    
    [self loadProcessShow:YES];
    
    __weak __typeof(self) weakself = self;
    
    [[SportForumAPI sharedInstance]articleGetByArticleId:articleViewController.articleObject.article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            [self loadProcessShow:NO];
            
            if (errorCode == 0) {
                articleViewController.articleObject = articlesObject;
                [_arrayArticleInfos replaceObjectAtIndex:_currentIndex withObject:articlesObject];
                [self checkNewEvent:articleViewController.articleObject];
                [self updateCommentBoard];
            }
        }
    }];
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

-(void)handleUpdateArticle
{
    ArticleViewController*articleViewController = _currentArticleViewController;
    articleViewController.articleObject = _arrayArticleInfos[_currentIndex];
    
    [self loadProcessShow:YES];
    
    __weak __typeof(self) weakself = self;
    
    [[SportForumAPI sharedInstance]articleGetByArticleId:articleViewController.articleObject.article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            [self loadProcessShow:NO];
            
            if (errorCode == 0) {
                articleViewController.articleObject = articlesObject;
                [_arrayArticleInfos replaceObjectAtIndex:_currentIndex withObject:articlesObject];
                [self updateCommentBoard];
            }
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _blCommentBoardShowed = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hidenCommonProgress];
    [self dismissAlertView];
    [self loadProcessShow:NO];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlArticleGet, urlArticleIsThumbed, urlArticleThumb, nil]];
    
    if (_arrayArticleInfos.count > 0 && _blCommentBoardShowed) {
        [self toggleCommentBoard];
    }
}

-(void)checkNewEvent:(ArticlesObject*)articleObj
{
    [[ApplicationContext sharedInstance]checkNewEvent:nil];
    /*
    UserInfo * userInfo = [[ApplicationContext sharedInstance] accountInfo];
    
    if ([userInfo.userid isEqualToString:articleObj.author])
    {
        if (articleObj.new_sub_article_count > 0 || articleObj.new_thumb_count > 0) {
            [[SportForumAPI sharedInstance]eventChangeStatusReadByEventType:event_type_article EventId:articleObj.article_id FinishedBlock:^(int errorCode){
                [[ApplicationContext sharedInstance]checkNewEvent:nil];
            }];
        }
    }*/
}

-(void)updateCurrentViewController:(UIViewController*)viewController
{
    ArticleViewController* articleViewController = (ArticleViewController*)viewController;
    NSUInteger nIndex = [_arrayArticleInfos indexOfObject:articleViewController.articleObject];

    [self loadProcessShow:YES];

    __weak __typeof(self) weakself = self;
    
    [[SportForumAPI sharedInstance]articleGetByArticleId:articleViewController.articleObject.article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            [self loadProcessShow:NO];
            
            if (errorCode == 0) {
                articleViewController.articleObject = articlesObject;
                [_arrayArticleInfos replaceObjectAtIndex:nIndex withObject:articlesObject];
                [self updateCommentBoard];
            }
        }
    }];
    
    _blCommentBoardShowed = YES;
    [self toggleCommentBoard];
}

- (ArticleViewController *)viewControllerByIndex:(NSUInteger)index {
    if (([self.arrayArticleInfos count] == 0) || (index >= [self.arrayArticleInfos count])) {
        return nil;
    }
    
    ArticleViewController* articleViewController = [[ArticleViewController alloc]init];
    articleViewController.articleObject = _arrayArticleInfos[index];

    [self loadProcessShow:YES];

    __weak __typeof(self) weakself = self;
        
    [[SportForumAPI sharedInstance]articleGetByArticleId:articleViewController.articleObject.article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            [self loadProcessShow:NO];
            
            if (errorCode == 0) {
                articleViewController.articleObject = articlesObject;
                [_arrayArticleInfos replaceObjectAtIndex:index withObject:articlesObject];
                
                NSLog(@"Current Index is %ld, index is %ld!", _currentIndex, index);
                [self updateCommentBoard];
            }
        }
    }];

    _blCommentBoardShowed = YES;
    [self toggleCommentBoard];
    return articleViewController;
}

-(NSUInteger)pageIndexByViewController:(UIViewController*)viewController {
    ArticleViewController*  articleViewController = (ArticleViewController*)viewController;
    return [_arrayArticleInfos indexOfObject:articleViewController.articleObject];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self pageIndexByViewController:viewController];
    _currentIndex = index;
    
    if (index == NSNotFound || index == 0) {
        if (index == 0) {
            [self updateCurrentViewController:viewController];
        }
        
        return nil;
    }
    
    _currentArticleViewController = (ArticleViewController*)viewController;
    
    return [self viewControllerByIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self pageIndexByViewController:viewController];
    _currentIndex = index;

    if (index == NSNotFound || index == [self.arrayArticleInfos count] - 1) {
        if (index == [self.arrayArticleInfos count] - 1) {
            [self updateCurrentViewController:viewController];
        }
        
        return nil;
    }
    
    _currentArticleViewController = (ArticleViewController*)viewController;
    
    return [self viewControllerByIndex:index + 1];
}

-(void)updateCommentBoard {
    ArticlesObject* articlesObj = _arrayArticleInfos[_currentIndex];
    _lblThumbCount.text =  [NSString stringWithFormat:@"%ld",  articlesObj.thumb_count];
    _lblCommentCount.text = [NSString stringWithFormat:@"%ld",  articlesObj.sub_article_count];
    _lblRewardCount.text = [NSString stringWithFormat:@"%ld",  articlesObj.reward_total / 100000000];
    
    if([articlesObj.relation isEqualToString:@"DEFRIEND"])
    {
        [_footViewController enableBarItemByTag:@"thumb" Enable:NO];
        [_footViewController enableBarItemByTag:@"reply" Enable:NO];
        [_footViewController enableBarItemByTag:@"chat" Enable:NO];
        [_footViewController enableBarItemByTag:@"reward" Enable:NO];
        [_footViewController enableBarItemByTag:@"forward" Enable:NO];
        _btnNoComment.enabled = NO;
    }
    else
    {
        UserInfo *userAccountInfo = [[ApplicationContext sharedInstance]accountInfo];
        
        if ([userAccountInfo.userid isEqualToString:articlesObj.author]) {
            [_footViewController enableBarItemByTag:@"thumb" Enable:NO];
            [_footViewController enableBarItemByTag:@"chat" Enable:NO];
            [_footViewController enableBarItemByTag:@"reward" Enable:NO];
            [_footViewController enableBarItemByTag:@"forward" Enable:NO];
        }
        else
        {
            [_footViewController enableBarItemByTag:@"thumb" Enable:YES];
            [_footViewController enableBarItemByTag:@"reply" Enable:YES];
            [_footViewController enableBarItemByTag:@"chat" Enable:YES];
            [_footViewController enableBarItemByTag:@"reward" Enable:YES];
            [_footViewController enableBarItemByTag:@"forward" Enable:YES];
            _btnNoComment.enabled = YES;
        }
    }
    
    [self checkThumb];
}

-(void)addDeleteButtonIfNeed {
    
    UserInfo* userInfo = [ApplicationContext sharedInstance].accountInfo;
    _btnDel.hidden = YES;
    
    if (userInfo) {
        ArticlesObject* articlesObj = _arrayArticleInfos[_currentIndex];
        
        _btnDel.hidden = ([articlesObj.authorInfo.userid isEqualToString:userInfo.userid] ? NO : YES);
    }
}

-(void)reloadAfterDeleteData {
    
    if (_arrayArticleInfos.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (_currentIndex >= _arrayArticleInfos.count-1) {
        _currentIndex = _arrayArticleInfos.count-1;
    }
    
    ArticleViewController* articleViewController = [[ArticleViewController alloc]init];
    if (_arrayArticleInfos.count > _currentIndex) {
        
        articleViewController.articleObject = _arrayArticleInfos[_currentIndex];
        
        [self loadProcessShow:YES];
        
        __weak __typeof(self) weakself = self;
        
        [[SportForumAPI sharedInstance]articleGetByArticleId:articleViewController.articleObject.article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject){
            __typeof(self) strongself = weakself;
            
            if (strongself != nil) {
                [self loadProcessShow:NO];
                
                if (errorCode == 0) {
                    articleViewController.articleObject = articlesObject;
                    [_arrayArticleInfos replaceObjectAtIndex:_currentIndex withObject:articlesObject];
                    [self updateCommentBoard];
                }
            }
        }];
        
        _blCommentBoardShowed = YES;
        [self toggleCommentBoard];
    }
   
    __weak __typeof(self) weakself = self;
    [_pageViewController setViewControllers:@[articleViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished){
        if(finished)
        {
            __typeof(self) strongself = weakself;
            
            if (strongself != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [strongself->_pageViewController setViewControllers:@[articleViewController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];// bug fix for uipageview controller
                });
            }
        }
    }];
}

-(void)dismissAlertView {
    if (_alertView) {
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView.delegate = nil;
        _alertView = nil;
    }
}

-(void)actionDelete {
    _alertView = [[UIAlertView alloc] initWithTitle:@"删除帖子" message:@"要删除帖子吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    _alertView.tag = 10;
    [_alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10)
    {
        if (buttonIndex == 1)
        {
            ArticlesObject* articlesObj = _arrayArticleInfos[_currentIndex];
            [self showCommonProgress];
            
            __weak __typeof(self) weakself = self;
                
            [[SportForumAPI sharedInstance]articleDeleteByArticleId: articlesObj.article_id FinishedBlock:^(int errorCode, NSString* strDescErr) {
                __typeof(self) strongself = weakself;
                
                if (strongself != nil) {
                    [self hidenCommonProgress];
                    [self dismissAlertView];
                    [_arrayArticleInfos removeObjectAtIndex:_currentIndex];
                    [self reloadAfterDeleteData];
                    
                    if (errorCode == 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@(YES), @"UpdateArticle",nil]];
                    }
                }
            }];

        }
    }
    else if(alertView.tag == 11)
    {
        if (buttonIndex == 1)
        {
            [self dismissAlertView];
            [self shareToWeibo];
        }
    }
}


-(void)createCommentBoard {
    
    _viewCommentBoard = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - cUnhidenWidth,
                                                                self.view.frame.size.width,
                                                                cCommentBoardHeight)];
    
    _imageViewThumbCount = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5,
                                                                        16, 16)];
    _imageViewThumbCount.image = [UIImage imageNamed:@"blog-heart-icon"];
    
    [_viewCommentBoard addSubview:_imageViewThumbCount];
    
    _lblThumbCount = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageViewThumbCount.frame)+ 4,
                                                              5, cCountLableWidth, 16)];
    _lblThumbCount.textColor = [UIColor grayColor];
    _lblThumbCount.font = [UIFont systemFontOfSize:11];
    
    _lblThumbCount.text =  @"0";
    [_viewCommentBoard addSubview:_lblThumbCount];
    
    _imageViewCommentCount = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lblThumbCount.frame)+ 4,
                                                                          5, 16, 16)];
    
    _imageViewCommentCount.image = [UIImage imageNamed:@"blog-reply-icon"];
    [_viewCommentBoard addSubview:_imageViewCommentCount];
    
    
    _lblCommentCount = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageViewCommentCount.frame)+ 4,
                                                                5, cCountLableWidth, 16)];
    
    _lblCommentCount.textColor = [UIColor grayColor];
    _lblCommentCount.font = [UIFont systemFontOfSize:11];
    _lblCommentCount.text = @"0";
    [_viewCommentBoard addSubview:_lblCommentCount];
    
    _imageViewRewardCount = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_lblCommentCount.frame)+ 4,
                                                                          5, 16, 16)];
    
    _imageViewRewardCount.image = [UIImage imageNamed:@"blog-money-icon"];
    [_viewCommentBoard addSubview:_imageViewRewardCount];
    
    
    _lblRewardCount = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageViewRewardCount.frame)+ 4,
                                                                5, cCountLableWidth, 16)];
    
    _lblRewardCount.textColor = [UIColor grayColor];
    _lblRewardCount.font = [UIFont systemFontOfSize:11];
    _lblRewardCount.text = @"0";
    [_viewCommentBoard addSubview:_lblRewardCount];
    
    _btnNoComment = [[UIButton alloc]init];
    
    
    _swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageViewThumbCount.frame)+10,
                                                            self.view.frame.size.width, cCommentCellHeight)];
    
    _viewCommentBoard.backgroundColor = [UIColor colorWithRed:96.0 / 255.0 green:205.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    _swipeView.alignment = SwipeViewAlignmentEdge;
    _swipeView.pagingEnabled = NO;
    _swipeView.truncateFinalPage = YES;
    _swipeView.scrollEnabled = YES;
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    
    _swipeView.backgroundColor = [UIColor clearColor];
    
    [_viewCommentBoard addSubview:_swipeView];
    //_viewCommentBoard.backgroundColor = [UIColor blackColor];
    //self.view.layer.opacity = 0.5;
    
    [self.view addSubview:_viewCommentBoard];

    _btnNoComment.frame = _swipeView.frame;
    [_btnNoComment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_btnNoComment setTitle:@"还没有人评论，点击抢沙发哦！" forState:UIControlStateNormal];
    [_btnNoComment addTarget:self action:@selector(actionReply) forControlEvents:UIControlEventTouchUpInside];
    [_viewCommentBoard addSubview:_btnNoComment];
    _btnNoComment.hidden = YES;
    
    _footViewController = [[FooterViewController alloc]initWithHeight:49
                                                              BGColor:[UIColor clearColor]
                                                               Parent:_viewCommentBoard];
    
    _footViewController.animation = NO;
    
    UIImage* image = [UIImage imageNamed:@"heart-btn"];
    UIImage* selectImage = nil;
    UIImage* disableImage = nil;
    
    __typeof__(self) __weak thisPointer = self;
    
    [_footViewController addFrontFootBarItemByImageNormal:image
                                            ImageSelected:selectImage
                                             ImageDisable:disableImage
                                                      Tag:@"thumb"
                                                 ShowText:@"赞"
                                                 IsToggle:YES
                                                   Action:^{
                                                       //[thisPointer actionSelectAll];
                                                       [thisPointer actionThumb];
                                                   }];
    
    image = [UIImage imageNamed:@"reply-btn"];
    selectImage = nil;
    disableImage = nil;
    
    [_footViewController addFrontFootBarItemByImageNormal:image
                                            ImageSelected:selectImage
                                             ImageDisable:disableImage
                                                      Tag:@"reply"
                                                 ShowText:@"回复"
                                                 IsToggle:YES
                                                   Action:^{
                                                       [thisPointer actionReply];
                                                   }];
    
    
    image = [UIImage imageNamed:@"chat-btn"];
    selectImage = nil;
    disableImage = nil;
    
    [_footViewController addFrontFootBarItemByImageNormal:image
                                            ImageSelected:selectImage
                                             ImageDisable:disableImage
                                                      Tag:@"chat"
                                                 ShowText:@"私聊"
                                                 IsToggle:YES
                                                   Action:^{
                                                       [thisPointer actionChat];
                                                   }];
    
    image = [UIImage imageNamed:@"value-btn"];
    selectImage = nil;
    disableImage = nil;
    
    [_footViewController addFrontFootBarItemByImageNormal:image
                                            ImageSelected:selectImage
                                             ImageDisable:disableImage
                                                      Tag:@"reward"
                                                 ShowText:@"打赏"
                                                 IsToggle:YES
                                                   Action:^{
                                                       [thisPointer actionReward];
                                                   }];
    
    image = [UIImage imageNamed:@"share-btn"];
    selectImage = nil;
    disableImage = nil;
    
    [_footViewController addFrontFootBarItemByImageNormal:image
                                            ImageSelected:selectImage
                                             ImageDisable:disableImage
                                                      Tag:@"forward"
                                                 ShowText:@"分享"
                                                 IsToggle:YES
                                                   Action:^{
                                                       [thisPointer actionShare];
                                                   }];
    
    
    [_footViewController updateLayoutBarItem];
    
    UITapGestureRecognizer* tapGestureRecognizer = nil;
    tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


-(BOOL)loginCheck {
    if ([ApplicationContext sharedInstance].accountInfo == nil) {
        //RegisterLonginViewController* rvc = [[RegisterLonginViewController alloc]init];
        //[self.navigationController pushViewController:rvc animated:YES];
        return NO;
    }
    
    return YES;
}

-(void)changeThumbStatus:(BOOL) isThumbed {
    //UIImage* image = [UIImage imageNamed:@"heart-btn"];
    //UIImage* selectImage =[UIImage imageNamed:@"hearted"];
    
    if (isThumbed) {
        _imageViewThumbCount.image = [UIImage imageNamed:@"blog-hearted-icon"];
        //[_footViewController updateBarItemByTag:@"thumb" NormalImage:selectImage SelectImage:image];
    } else {
        _imageViewThumbCount.image = [UIImage imageNamed:@"blog-heart-icon"];
        //[_footViewController updateBarItemByTag:@"thumb" NormalImage:image SelectImage:selectImage];
    }
}

-(void)checkThumb {
    ArticlesObject* articlesObj = _arrayArticleInfos[_currentIndex];
    UserInfo *userAccountInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if ([userAccountInfo.userid isEqualToString:articlesObj.author]) {
        [self changeThumbStatus:NO];
        return;
    }
    
    if ([ApplicationContext sharedInstance].accountInfo != nil) {
        __weak __typeof(self) weakself = self;
        [[SportForumAPI sharedInstance]articleIsThumbedByArticleId: articlesObj.article_id FinishedBlock:^(int errorCode, NSString* strDescErr, BOOL isThumbed) {
            __typeof(self) strongself = weakself;
            if (strongself == nil) {
                return;
            }
            
            if (errorCode == 0) {
                strongself->_isThumbed = isThumbed;
                [strongself changeThumbStatus:isThumbed];
                
                if(isThumbed)
                {
                    [_footViewController enableBarItemByTag:@"thumb" Enable:NO];
                }
            }
            else
            {
                [AlertManager showAlertText:strDescErr InView:strongself.view hiddenAfter:2];
            }
        }];
    }
}

-(void)actionThumb {
    if ([self loginCheck] == NO || _isThumbed) {
        return;
    }
    
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    
    if (userInfo != nil) {
        if (userInfo.ban_time > 0) {
            [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
        else if(userInfo.ban_time < 0)
        {
            [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
    }
    
    ArticlesObject* articlesObj = _arrayArticleInfos[_currentIndex];
    __weak __typeof(self) weakself = self;
    [self changeThumbStatus:!_isThumbed];
    
    NSString *strAudio = (!_isThumbed == YES ? @"hot_like_large.mp3" : @"hot_like_timeout.mp3");
    [[CommonUtility sharedInstance]playAudioFromName:strAudio];
    
    [self showCommonProgress];
    
    [[SportForumAPI sharedInstance]articleThumbByArticleId:articlesObj.article_id
                                               ThumbStatus: !_isThumbed
                                             FinishedBlock:^(int errorCode, NSString* strDescErr, ExpEffect* expEffect){
                                                 if (errorCode == 0) {
                                                     
                                                     __typeof(self) strongself = weakself;
                                                     if (strongself == nil) {
                                                         return;
                                                     }
                                                     
                                                     [self hidenCommonProgress];
                                                     
                                                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                                                     
                                                     strongself->_isThumbed = !strongself->_isThumbed;
                                                     
                                                     if (strongself->_isThumbed) {
                                                         articlesObj.thumb_count++;
                                                     } else {
                                                         if (articlesObj.thumb_count!= 0) {
                                                             articlesObj.thumb_count--;
                                                         }
                                                         
                                                     }
                                                     
                                                     _lblThumbCount.text = [NSString stringWithFormat:@"%ld", articlesObj.thumb_count];
                                                     
                                                     if ([_currentArticleViewController.articleObject.article_id isEqualToString:articlesObj.article_id]) {
                                                         [self updateCurrentViewController:_currentArticleViewController];
                                                     }
                                                 }
                                                 else
                                                 {
                                                     [AlertManager showAlertText:strDescErr InView:self.view hiddenAfter:2];
                                                 }
                                             }
     ];
}

-(void)actionReply {
    if ([self loginCheck] == NO) {
        return;
    }
    
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    
    if (userInfo != nil) {
        if (userInfo.ban_time > 0) {
            [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
        else if(userInfo.ban_time < 0)
        {
            [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
    }
    
    ArticlePublicViewController *articlePublicViewController = [[ArticlePublicViewController alloc]init];
    ArticlesObject* articlesObj = _arrayArticleInfos[_currentIndex];
    articlePublicViewController.articleParent = articlesObj.article_id;
    articlePublicViewController.strTitle = @"评论";
    [[self navigationController]pushViewController:articlePublicViewController animated:YES];
}

-(void)actionChat {
    
    if ([self loginCheck] == NO) {
        return;
    }
    
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    
    if (userInfo != nil) {
        if (userInfo.ban_time > 0) {
            [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
        else if(userInfo.ban_time < 0)
        {
            [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
    }
    
    ArticlesObject* articlesObj = _arrayArticleInfos[_currentIndex];
   
    __weak __typeof(self) weakself = self;
    [[SportForumAPI sharedInstance]userGetInfoByUserId:articlesObj.author FinishedBlock:^(int errorCode, UserInfo *userInfo) {
        if (errorCode == 0) {
            __typeof(self) strongself = weakself;
            if (strongself == nil) {
                return;
            }

            ChatMessageTableViewController *chatMessageTableViewController = [[ChatMessageTableViewController alloc]init];
            chatMessageTableViewController.userId = userInfo.userid;
            chatMessageTableViewController.useProImage = userInfo.profile_image;
            chatMessageTableViewController.useNickName = userInfo.nikename;
            [self.navigationController pushViewController:chatMessageTableViewController animated:YES];
        }
    }];
}

-(void)actionReward {
    if ([self loginCheck] == NO) {
        return;
    }
    
    UserInfo *accountInfo = [ApplicationContext sharedInstance].accountInfo;
    
    if (accountInfo != nil) {
        if (accountInfo.ban_time > 0) {
            [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
        else if(accountInfo.ban_time < 0)
        {
            [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
    }
    
    ArticlesObject* articlesObj = _arrayArticleInfos[_currentIndex];
    WalletTransferViewController *walletTransferViewController = [[WalletTransferViewController alloc]init];
    [walletTransferViewController setSelfAddress:accountInfo.wallet];
    [walletTransferViewController settargetAddress:articlesObj.authorInfo.wallet withArticleID:articlesObj.article_id];
    [[self navigationController]pushViewController:walletTransferViewController animated:YES];
}

-(void)shareToWeibo {
    
    if ([self loginCheck] == NO) {
        return;
    }
    
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
            
            [[SportForumAPI sharedInstance]userShareToFriends:^void(int errorCode, ExpEffect* expEffect){
                if (errorCode == 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                }
            }];
        }
    }];
    
    /*id<ISSCAttachment> imageAttachment = [ShareSDK jpegImageWithImage:image quality:0.8];
    
    
    id<ISSContent> publishContent = [ShareSDK content:@"运动社区分享"
                                       defaultContent:@""
                                                image:imageAttachment
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeImage];
    
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, nil];
    [ShareSDK oneKeyShareContent:publishContent//内容对象
                       shareList:shareList//平台类型列表
                     authOptions:nil//授权选项
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
                              
                              if (state == SSPublishContentStateSuccess)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                              }
                          }];
    
    [ShareSDK shareContent:publishContent
                      type:ShareTypeSinaWeibo
               authOptions:nil
             statusBarTips:YES
                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                        if (state == SSPublishContentStateSuccess)
                        {
                            NSLog(@"分享成功");
                        }
                        else if (state == SSPublishContentStateFail)
                        {
                            NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode],  [error errorDescription]);
                        }
                    }];*/
    
}

-(void)actionShare {
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    
    if (userInfo != nil) {
        if (userInfo.ban_time > 0) {
            [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
        else if(userInfo.ban_time < 0)
        {
            [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:self.view hiddenAfter:2];
            return;
        }
    }
    
    NSString *strArtId = ((ArticlesObject*)_arrayArticleInfos[_currentIndex]).article_id;
    NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"ShareWeiBoInfo"];
    NSMutableDictionary * shareDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if (shareDict == nil) {
        shareDict = [[NSMutableDictionary alloc]init];
    }

    if ([[shareDict objectForKey:strArtId]boolValue]) {
        [AlertManager showAlertText:@"亲，该博文您已经分享过了，不可以重复分享哦！" InView:self.view hiddenAfter:2];
    }
    else
    {
        [self shareToWeibo];
    }
}

-(void)actionTap:(UITapGestureRecognizer*)gr {
    [self toggleCommentBoard];
}

-(void)toggleCommentBoard {
    
    if (_blToggling) {
        return;
    }
    
    if (!_blCommentBoardShowed) {
        _progressInCommentBoard = [AlertManager showCommonProgressInView:_viewCommentBoard];
        ArticlesObject* articleObj = _arrayArticleInfos[_currentIndex];
        
        __weak __typeof(self) weakself = self;
             
        [[SportForumAPI sharedInstance]articleCommentsByArticleId:articleObj.article_id FirstPageId:nil LastPageId:nil PageItemNum:20 Type:@"" FinishedBlock:^(int errorCode, ArticlesInfo *articlesInfo) {
            __typeof(self) strongself = weakself;
            
            if (strongself == nil) {
                return;
            }
            
            _arrayCommentInfos = articlesInfo.articles_without_content.data;
            [_swipeView reloadData];
            [AlertManager dissmiss:_progressInCommentBoard];
            
            articleObj.sub_article_count = articlesInfo.articles_without_content.data.count;
            [self updateCommentBoard];
            
            if (articlesInfo.articles_without_content.data.count == 0) {
                _btnNoComment.hidden = NO;
            } else {
                _btnNoComment.hidden = YES;
            }
        }];
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(toggleComentBoardFinished:finished:context:)];
    
    _blToggling = YES;
    BOOL blNeedlShow = !_blCommentBoardShowed;
    
    if (blNeedlShow) {
        _viewCommentBoard.frame = CGRectMake(0, self.view.frame.size.height - cCommentBoardHeight, self.view.frame.size.width, cCommentBoardHeight);
    } else {
        _viewCommentBoard.frame = CGRectMake(0, self.view.frame.size.height - cUnhidenWidth, self.view.frame.size.width, cCommentBoardHeight);
    }
    
    _blCommentBoardShowed = blNeedlShow;
    [UIView commitAnimations];
    
}

-(void)toggleComentBoardFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    _blToggling = NO;
}

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return _arrayCommentInfos.count;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    WallCell* cell = (WallCell*)view;
    
    if (!cell) {
        cell = [[WallCell alloc]initWithFrame:CGRectMake(0, 0, cCommentCellHeight, cCommentCellHeight)];
    }
    
    ArticlesObject* articleObj = [_arrayCommentInfos objectAtIndex:index];
    WallCellInfo* cellInfo = [[WallCellInfo alloc]init];
    cellInfo.imageURL = articleObj.cover_image;
    cellInfo.title = articleObj.cover_text;
    cellInfo.thumbCount = articleObj.thumb_count;
    cellInfo.commentCount = articleObj.sub_article_count;
    cell.cellInfo = cellInfo;
    cell.tag = index;
    [cell addTarget:self action:@selector(actionCommentSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)testCustomMenu {
    __weak __typeof(self) thisPointer = self;
    _customMenuViewController = [[CustomMenuViewController alloc]init];
    
    [_customMenuViewController addButtonFromBackTitle:@"取消" ActionBlock:^(id sender) {
    }];
    
    [_customMenuViewController addButtonFromBackTitle:@"从本地选取" ActionBlock:^(id sender) {
        
    }];
    
    [_customMenuViewController addButtonFromBackTitle:@"立即拍照" Hightlight:YES ActionBlock:^(id sender) {
        ImageEditViewController* imageEditView = [[ImageEditViewController alloc]initWithNibName:@"ImageEditViewController" bundle:nil];
        UIImage* image = [UIImage imageNamed:@"TESTPIC"];
        imageEditView.sourceImage = image;
        imageEditView.panEnabled = YES;
        imageEditView.checkBounds = YES;
        [thisPointer.navigationController pushViewController:imageEditView animated:YES];
    }];
    
    [_customMenuViewController showInView:self.navigationController.view];
}

-(void)actionCommentSelect:(WallCell*)sender {
    ArticleViewPagesController* articleViewPagesController = [[ArticleViewPagesController alloc]init];
    articleViewPagesController.currentIndex = sender.tag;
    articleViewPagesController.arrayArticleInfos = _arrayCommentInfos;
    [self.navigationController pushViewController:articleViewPagesController animated:YES];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    NSLog(@"paged....");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"ArticleViewPagesController dealloc called!");
}

@end
