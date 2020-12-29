//
//  ArticleCircleViewController.m
//  SportForum
//
//  Created by liyuan on 3/31/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "ArticleCircleViewController.h"
#import "UIViewController+SportFormu.h"
#import "RecommendCircleTableViewCell.h"
#import "MWPhotoBrowser.h"
#import "EGORefreshTableHeaderView.h"
#import "PublishSelectionView.h"
#import "ArticlePublicViewController.h"
#import "ArticlePagesViewController.h"
#import "RelatedPeoplesViewController.h"
#import "RecordSportViewController.h"
#import "GameViewController.h"
#import "ContentWebViewController.h"
#import "SwipeView.h"
#import "WallCell.h"
#import "AlertManager.h"
#import "XHMessageInputView.h"
#import "IQKeyboardManager.h"

#import "UIImageView+WebCache.h"
#import "ImageEditViewController.h"
#import "CustomMenuViewController.h"
#import "ZYQAssetPickerController.h"

#import "DXAlertView.h"
#import "RegexKitLite.h"

// Categorys
#import "UIScrollView+XHkeyboardControl.h"
#import "AccountPreViewController.h"
#import "TRSDialScrollView.h"
#import "ChatMessageTableViewController.h"

#import <MediaPlayer/MediaPlayer.h>

#define MAX_PUBLISH_PNG_COUNT 6
#define SWIPE_CELL_WEIGHT 120
#define COMMENT_BOARD_HEIGHT 158

@interface ArticleCircleViewController ()<UITableViewDelegate, UITableViewDataSource, MWPhotoBrowserDelegate, EGORefreshTableHeaderDelegate, UIScrollViewDelegate, SwipeViewDelegate, SwipeViewDataSource, XHMessageInputViewDelegate, UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@end

@implementation ArticleCircleViewController
{
    UIView *m_barView;
    
    UITableView *m_tableAttention;
    NSMutableArray * _arrAttentions;
    NSMutableArray *_photos;
    
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _imgViewArray;
    NSMutableArray * _imgBtnArray;
    
    NSMutableDictionary *_replyDict;
    
    BOOL _bUpdatePhotos;
    
    EGORefreshTableHeaderView* _PullDownRefreshView;
    EGORefreshTableHeaderView* _PullRightRefreshView;
    UIActivityIndicatorView *_tableFooterActivityIndicator;
    UIActivityIndicatorView *m_activityIndicatorMain;
    BOOL _bDownHandleLoading;
    BOOL _bUpHandleLoading;
    BOOL _bShowMwPhotoBrowser;
    NSString *_strFirstPageId;
    NSString *_strLastPageId;
    
    PublishSelectionView* _publishSelectionView;
    BOOL _reloading;
    
    UIView* _viewCommentBoard;
    UILabel* _lbReviewTitle;
    UILabel* _lbNoReview;
    CSButton* _btnReview;
    SwipeView* _swipeView;
    
    CGPoint _fOffset;
    CGPoint _fOffsetShowKeyBoard;
    NSMutableArray *_arrayCommentInfos;
    id  _progressInCommentBoard;
    id m_processWindow;
    
    UIView *m_footViewIndicator;
    UIActivityIndicatorView *m_activityIndicator;
    UITapGestureRecognizer* m_tapGestureRecognizer;
    UITapGestureRecognizer* m_tapGestureRecognizer0;
    
    CSButton *m_btnAddPng;
    CSButton *m_btnSend;
    UIView *m_viewShareMenu;
    XHMessageInputView *m_viewReply;
    XHInputViewType _textViewInputViewType;
    
    CGFloat _keyboardViewHeight;
    CGFloat _previousTextViewContentHeight;
    
    ArticlesObject *_currentObject;
    
    ImageEditViewController* _imageEditViewController;
    CustomMenuViewController* _customMenuViewController;
    
    UIAlertView* _alertView;
    
    //Reward PickView
    UIView *m_viewReward;
    UIView * m_pickerView0;
    
    UIImageView *m_imgViewReward;
    
    int m_nOffset;
    UITextField* m_textFiledReward;
    DXAlertView *m_rewardAlert;
}

-(void)initTestData
{
    //For test
    ArticlesObject *articlesObject = [[ArticlesObject alloc]init];
    articlesObject.longitude = 121.597771;
    articlesObject.latitude = 31.2647209;
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    
    ArticleSegmentObject* segobj = [ArticleSegmentObject new];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = @"楚天都市报讯 据《中国日报》报道 英国《每日邮报》6日称，大小约为地球3倍的格利泽581d行星是人类在太阳系之外发现的第一个位于宜居带中的行星，被称为超级地球。它距离地球22光年，在浩瀚的宇宙中算得上是“邻居”，而学者过去曾一度认为它根本不存在。格利泽581d围绕格利泽581公转，并且位于后者的宜居带中，是人类潜在的太空移民选择，人称超级地球。英国玛丽皇后大学的安格拉达-埃斯屈得教授说：格利泽581d存在与否事关重大，因为这是我们首次在另一个恒星的宜居带中发现类似地球的行星。";
    [articlesObject.article_segments.data addObject:segobj];
    
    segobj = [ArticleSegmentObject new];
    segobj.seg_type = @"IMAGE";
    segobj.seg_content = userInfo.profile_image;
    [articlesObject.article_segments.data addObject:segobj];
    [articlesObject.article_segments.data addObject:segobj];
    [articlesObject.article_segments.data addObject:segobj];
    [articlesObject.article_segments.data addObject:segobj];
    articlesObject.thumb_users.data = [NSMutableArray arrayWithObjects:userInfo.profile_image, userInfo.profile_image, userInfo.profile_image, userInfo.profile_image, userInfo.profile_image,nil];
    articlesObject.article_id = @"54f46ff8fd19c433bb000069";
    [_arrAttentions addObject:articlesObject];
    
    articlesObject = [[ArticlesObject alloc]init];
    segobj = [ArticleSegmentObject new];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = @"楚天都市报讯 据《中国日报》报道 英国《每日邮报》6日称，大小约为地球3倍的格利泽581d.";
    [articlesObject.article_segments.data addObject:segobj];
    segobj = [ArticleSegmentObject new];
    segobj.seg_type = @"IMAGE";
    segobj.seg_content = userInfo.profile_image;
    [articlesObject.article_segments.data addObject:segobj];
    articlesObject.article_id = @"54e2a7f2fd19c42ae600004b";
    [_arrAttentions addObject:articlesObject];
    
    articlesObject = [[ArticlesObject alloc]init];
    segobj = [ArticleSegmentObject new];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = @"跑步有益身心健康";
    [articlesObject.article_segments.data addObject:segobj];
    segobj = [ArticleSegmentObject new];
    segobj.seg_type = @"IMAGE";
    segobj.seg_content = userInfo.profile_image;
    [articlesObject.article_segments.data addObject:segobj];
    [articlesObject.article_segments.data addObject:segobj];
    articlesObject.thumb_users.data = [NSMutableArray arrayWithObjects:userInfo.profile_image, userInfo.profile_image, userInfo.profile_image, userInfo.profile_image, nil];
    articlesObject.article_id = @"54f15c37fd19c433bb00005b";
    [_arrAttentions addObject:articlesObject];
    
    for(NSUInteger i = 0; i < 5; i++)
    {
        articlesObject = [[ArticlesObject alloc]init];
        segobj = [ArticleSegmentObject new];
        segobj.seg_type = @"TEXT";
        segobj.seg_content = @"跑步有益身心健康";
        [articlesObject.article_segments.data addObject:segobj];
        segobj = [ArticleSegmentObject new];
        segobj.seg_type = @"IMAGE";
        segobj.seg_content = userInfo.profile_image;
        [articlesObject.article_segments.data addObject:segobj];
        [articlesObject.article_segments.data addObject:segobj];
        articlesObject.thumb_users.data = [NSMutableArray arrayWithObjects:userInfo.profile_image, nil];
        articlesObject.article_id = @"54f15c37fd19c433bb00005b";
        [_arrAttentions addObject:articlesObject];
    }
}

-(NSString*)generateTitle
{
    NSString *strTitle;
    
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if ([_strAuthorId isEqualToString:userInfo.userid]) {
        strTitle = _bComment ? @"我的回复" : @"我的博文";
    }
    else
    {
        strTitle = _bComment ? @"Ta的回复" : @"Ta的博文";
    }
    
    return strTitle;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    m_nOffset = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version >= 5.0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
    __weak __typeof(self) weakSelf = self;
    
    [self generateCommonViewInParent:self.view Title:[self generateTitle] IsNeedBackBtn:YES ActionBlock:^(void)
     {
         __typeof(self) strongSelf = weakSelf;
         
         CGRect rect = strongSelf->_viewCommentBoard.frame;
         
         if (rect.origin.y != strongSelf.view.frame.size.height) {
             [strongSelf hideCommentBoard];
         }
         
         [strongSelf->m_tableAttention removeFromSuperview];
         
         strongSelf.view.userInteractionEnabled = NO;
         
         CGRect inputViewFrame = strongSelf->m_viewReply.frame;
         
         if (inputViewFrame.origin.y != strongSelf.view.bounds.size.height && strongSelf->_textViewInputViewType != XHInputViewTypeNormal) {
             [strongSelf layoutOtherMenuViewHiden:YES];
         }
         
         [strongSelf.navigationController popViewControllerAnimated:YES];
     }];
    
    _keyboardViewHeight = 216;
    
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
    
    //Create Add View
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if (!_bComment && [_strAuthorId isEqualToString:userInfo.userid]) {
        UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
        UIImageView *imgViewNew = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
        [imgViewNew setImage:[UIImage imageNamed:@"nav-plus-btn"]];
        [self.view addSubview:imgViewNew];
        
        CSButton *btnNew = [CSButton buttonWithType:UIButtonTypeCustom];
        btnNew.frame = CGRectMake(CGRectGetMinX(imgViewNew.frame) - 5, CGRectGetMinY(imgViewNew.frame) - 5, 45, 45);
        btnNew.backgroundColor = [UIColor clearColor];
        [self.view addSubview:btnNew];
        [self.view bringSubviewToFront:btnNew];
        
        btnNew.actionBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            CGRect rect = strongSelf->_viewCommentBoard.frame;
            
            [strongSelf actionReplyTap:nil];
            
            if (rect.origin.y != strongSelf.view.frame.size.height) {
                [strongSelf->m_tableAttention setContentOffset:strongSelf->_fOffset animated:YES];
                [strongSelf hideCommentBoard];
            }
            
            [[CommonUtility sharedInstance]playAudioFromName:@"plusPopupBtn.mp3"];
            [strongSelf->_publishSelectionView showInView:strongSelf.navigationController.view PublishMode:PUBLISH_MODE_CUSTOM];
        };
    }
    
    //Create Table
    rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
    m_tableAttention = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    m_tableAttention.delegate = self;
    m_tableAttention.dataSource = self;
    m_tableAttention.allowsSelection = NO;
    [viewBody addSubview:m_tableAttention];
    
    m_tableAttention.backgroundColor = [UIColor clearColor];
    m_tableAttention.separatorColor = [UIColor clearColor];
    
    if ([m_tableAttention respondsToSelector:@selector(setSeparatorInset:)]) {
        [m_tableAttention setSeparatorInset:UIEdgeInsetsZero];
    }
    
    _PullDownRefreshView = [[EGORefreshTableHeaderView alloc] initWithScrollView:m_tableAttention orientation:EGOPullOrientationDown];
    _PullDownRefreshView.delegate = self;
    
    //Create BottomView For Table
    m_tableAttention.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, m_tableAttention.frame.size.width, 20.0f)];
    m_tableAttention.tableFooterView.backgroundColor = [UIColor clearColor];
    _tableFooterActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    [_tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [_tableFooterActivityIndicator setCenter:[m_tableAttention.tableFooterView center]];
    [m_tableAttention.tableFooterView addSubview:_tableFooterActivityIndicator];
    
    //Create Bar View
    m_barView = [[UIView alloc]initWithFrame:CGRectMake(5, -30, 300, 30)];
    m_barView.backgroundColor = [UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:0.8];
    m_barView.layer.cornerRadius = 5.0;
    [viewBody addSubview:m_barView];
    
    m_imgViewReward = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    m_imgViewReward.image = [UIImage imageNamed:@"blog-heart-2"];
    m_imgViewReward.hidden = YES;
    [viewBody addSubview:m_imgViewReward];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.tag = 100;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [m_barView addSubview:label];
    
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 20.0f, 20.0f)];
    m_activityIndicatorMain = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 48) / 2, (CGRectGetHeight(viewBody.frame) - 48) / 2, 48, 48)];
    m_activityIndicatorMain.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    m_activityIndicatorMain.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    m_activityIndicatorMain.hidden = NO;
    m_activityIndicatorMain.hidesWhenStopped = YES;
    [viewBody addSubview:m_activityIndicatorMain];
    
    [self initSelectView];
    [self createCommentBoard];
    [self createReplyView];
    //[self createRewardView];
    
    _imgUrlArray = [[NSMutableArray alloc]init];
    _imgViewArray = [[NSMutableArray alloc]init];
    _imgBtnArray = [[NSMutableArray alloc]init];
    _photos = [[NSMutableArray alloc]init];
    _replyDict = [[NSMutableDictionary alloc]init];
    _bUpdatePhotos = NO;
    
    //[self initTestData];
    //[m_tableAttention reloadData];
    
    _strFirstPageId = @"";
    _strLastPageId = @"";
    _arrAttentions = [[NSMutableArray alloc]init];
    
    [m_activityIndicatorMain startAnimating];
    [self reloadArticlesData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshImageViews];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [MobClick beginLogPageView:@"个人博文 - ArticleCircleViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"个人博文 - ArticleCircleViewController"];
    
    // 设置键盘通知或者手势控制键盘消失
    [m_tableAttention setupPanGestureControlKeyboardHide:YES];
    
    // KVO 检查contentSize
    [m_viewReply.inputTextView addObserver:self
                                forKeyPath:@"contentSize"
                                   options:NSKeyValueObservingOptionNew
                                   context:nil];
    
    [m_viewReply addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 取消输入框
    [m_viewReply.inputTextView resignFirstResponder];
    [self setEditing:NO animated:YES];
    [MobClick endLogPageView:@"个人博文 - ArticleCircleViewController"];
    [self hidenCommonProgress];
    
    // remove键盘通知或者手势
    [m_tableAttention disSetupPanGestureControlKeyboardHide:YES];
    
    // remove KVO
    [m_viewReply.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    [m_viewReply removeObserver:self forKeyPath:@"frame"];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"ArticleCircleViewController dealloc called!");
    [m_viewReply removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)showCommonProgress{
    m_processWindow = [AlertManager showCommonProgress];
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:m_processWindow];
}

-(void)actionThumb:(ArticlesObject*)articlesObj TabelCellIndexPath:(NSIndexPath*)cellIndexPath {
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
            [JDStatusBarNotification showWithStatus:@"你发表的文章，自己不可以点赞哦~" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleDefault];
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
                                               ThumbStatus: !bIsThumbed
                                             FinishedBlock:^(int errorCode, NSString* strDescErr, ExpEffect* expEffect){
                                                 if (errorCode == 0) {
                                                     
                                                     __typeof(self) strongself = weakself;
                                                     if (strongself == nil) {
                                                         [self hidenCommonProgress];
                                                         return;
                                                     }
                                                     
                                                     UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                                                     
                                                     [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                                                      {
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect",nil]];
                                                      }];
                                                     
                                                     [[SportForumAPI sharedInstance]articleGetByArticleId:articlesObj.article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
                                                         __typeof(self) strongself = weakself;
                                                         [self hidenCommonProgress];
                                                         
                                                         if (strongself != nil) {
                                                             if (errorCode == 0) {
                                                                 [_arrAttentions replaceObjectAtIndex:[cellIndexPath row] withObject:articlesObject];
                                                                 
                                                                 [strongself->m_tableAttention beginUpdates];
                                                                 [strongself->m_tableAttention reloadRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                                                                 [strongself->m_tableAttention endUpdates];
                                                                 
                                                                 if(!bIsThumbed)
                                                                 {
                                                                     RecommendCircleTableViewCell *cell = (RecommendCircleTableViewCell*)[strongself->m_tableAttention cellForRowAtIndexPath:cellIndexPath];
                                                                     
                                                                     UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
                                                                     CGRect rectThubm = [cell convertRect:cell.thumbImageView.frame toView:viewBody];
                                                                     
                                                                     m_imgViewReward.frame = rectThubm;
                                                                     m_imgViewReward.hidden = NO;
                                                                     
                                                                     [UIView animateWithDuration:0.4 animations:^{
                                                                         CGRect frame = m_imgViewReward.frame;
                                                                         frame.origin.y -= 30;
                                                                         m_imgViewReward.frame = frame;
                                                                     } completion:^(BOOL finished){
                                                                         m_imgViewReward.hidden = YES;
                                                                     }];
                                                                 }
                                                             }
                                                             else
                                                             {
                                                                 [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                             }
                                                         }
                                                     }];
                                                 }
                                                 else
                                                 {
                                                     [self hidenCommonProgress];
                                                     [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                 }
                                             }
     ];
}

-(void)publishSportLog
{
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
    
    if ([_currentObject.relation isEqualToString:@"DEFRIEND"])
    {
        [JDStatusBarNotification showWithStatus:@"你已被拉黑，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        return;
    }

    NSMutableArray* articleSegments = [[NSMutableArray alloc]init];
    
    ArticleSegmentObject* segobj = [ArticleSegmentObject new];
    segobj.seg_type = @"TEXT";
    segobj.seg_content = m_viewReply.inputTextView.text;
    [articleSegments addObject:segobj];
    
    for (NSString *strUrl in _imgUrlArray) {
        ArticleSegmentObject* segobj = [ArticleSegmentObject new];
        segobj.seg_type = @"IMAGE";
        segobj.seg_content = strUrl;
        [articleSegments addObject:segobj];
    }
    
    if (articleSegments.count == 0) {
        return;
    }
    
    NSMutableArray *arrAtList = [[NSMutableArray alloc]init];
    //NSArray *matchArray = [_tvLiterator.text componentsMatchedByRegex:@"(?<=@)[^\\s]+\\s?"];
    NSArray *matchArray = [m_viewReply.inputTextView.text componentsMatchedByRegex:@"((?<=@)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)_]+))|(?<=@)([\u4e00-\u9fa5]+)"];
    
    for (NSString *str in matchArray) {
        NSString *trimmedString = [str stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([arrAtList indexOfObject:trimmedString] == NSNotFound) {
            [arrAtList addObject:str];
        }
    }
    
    e_article_tag_type eArticleType = e_article_log;
    
    [self showCommonProgress];
    
    [[SportForumAPI sharedInstance]articleNewByParArticleId:_currentObject.article_id
                                             ArticleSegment:articleSegments
                                                 ArticleTag:[NSArray arrayWithObject:[CommonFunction ConvertArticleTagTypeToString:eArticleType]] Type:@"" AtNameList:arrAtList
                                              FinishedBlock:^(int errorCode, NSString* strDescErr, ExpEffect* expEffect) {
                                                  if (errorCode == RSA_ERROR_NONE) {
                                                      UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                                                      
                                                      [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                                                       {
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", @(YES), @"UpdateArticle",nil]];
                                                       }];
                                                      
                                                      [_replyDict removeObjectForKey:_currentObject.article_id];
                                                      
                                                      [[SportForumAPI sharedInstance]articleGetByArticleId:_currentObject.article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
                                                          [self hidenCommonProgress];
                                                          
                                                          if (errorCode == 0) {
                                                              NSUInteger nIndex = [self indexOfAttentionObject:_currentObject];//[_arrAttentions indexOfObject:_currentObject];
                                                              
                                                              if (nIndex == NSNotFound) {
                                                                  return;
                                                              }
                                                              
                                                              [_arrAttentions replaceObjectAtIndex:nIndex withObject:articlesObject];
                                                              _currentObject = articlesObject;
                                                              
                                                              [m_tableAttention beginUpdates];
                                                              [m_tableAttention reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:nIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                              [m_tableAttention endUpdates];
                                                          }
                                                          else
                                                          {
                                                              [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                          }
                                                      }];
                                                  } else {
                                                      [self hidenCommonProgress];
                                                      [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                  }
                                              }];
}

-(void)deleteArticle
{
    NSUInteger nIndex = [_arrAttentions indexOfObject:_currentObject];
    [self showCommonProgress];
    
    [[SportForumAPI sharedInstance]articleDeleteByArticleId:_currentObject.article_id FinishedBlock:^(int errorCode, NSString* strDescErr) {
        [self hidenCommonProgress];
        
        if (errorCode == 0) {
            [_arrAttentions removeObjectAtIndex:nIndex];
            [m_tableAttention deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:nIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
        }
    }];
}

#pragma mark - Reward Logic

-(void)walletTradeByValue:(NSInteger)nCoinValue
{
    [m_rewardAlert dismissAlert];
    
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    id processWin = [AlertManager showCommonProgress];
    
    [[SportForumAPI sharedInstance] walletTradeBySelfAddress:userInfo.wallet
                                                     TradeTo:_currentObject.authorInfo.wallet
                                                   TradeType:e_reward
                                                   ArticleId:_currentObject.article_id
                                                  TradeValue:nCoinValue * (long long)100000000
                                               FinishedBlock:^void(int errorCode, NSString* strDescErr, NSString* strTxid)
     {
         [AlertManager dissmiss:processWin];
         
         if(errorCode != 0)
         {
             [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
         }
         else
         {
             [JDStatusBarNotification showWithStatus:@"打赏成功！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleSuccess];
             _currentObject.reward_total += nCoinValue * (long long)100000000;
             NSUInteger nIndex = [self indexOfAttentionObject:_currentObject];
             
             if (nIndex == NSNotFound) {
                 return;
             }
             
             [m_tableAttention beginUpdates];
             [m_tableAttention reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:nIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
             [m_tableAttention endUpdates];
             
             //[self actionTradeSuccess];
//             [NSTimer scheduledTimerWithTimeInterval: 1
//                                              target: self
//                                            selector: @selector(actionTradeSuccess)
//                                            userInfo: nil
//                                             repeats: NO];
         }
     }];
}

-(NSUInteger)indexOfAttentionObject:(ArticlesObject *)articleObject
{
    NSUInteger nIndex = [_arrAttentions indexOfObject:articleObject];
    
    if (nIndex == NSNotFound) {
        for (ArticlesObject *object in _arrAttentions) {
            if ([object.article_id isEqualToString:articleObject.article_id]) {
                nIndex = [_arrAttentions indexOfObject:object];
                break;
            }
        }
    }
    
    return nIndex;
}

-(void)actionTradeSuccess
{
    [[SportForumAPI sharedInstance]articleGetByArticleId:_currentObject.article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
        
        if (errorCode == 0) {
            NSUInteger nIndex = [self indexOfAttentionObject:_currentObject];//[_arrAttentions indexOfObject:_currentObject];
            
            if (nIndex == NSNotFound) {
                return;
            }
            
            [_arrAttentions replaceObjectAtIndex:nIndex withObject:articlesObject];
            _currentObject = articlesObject;
            
            [m_tableAttention beginUpdates];
            [m_tableAttention reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:nIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [m_tableAttention endUpdates];
        }
        else
        {
            [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
        }
    }];
    
    
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
     {
         if (errorCode == 0)
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
         }
     }];
}

-(UIView*)generateRewardView:(NSInteger)nCoinValue
{
    UIView *viewReward = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 240, 100)];
    viewReward.backgroundColor = [UIColor clearColor];
    
    CGRect rect = CGRectMake(10, 13, 70, 20);
    UILabel* lbReward = [[UILabel alloc]initWithFrame:rect];
    lbReward.backgroundColor = [UIColor clearColor];
    lbReward.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
    lbReward.numberOfLines = 0;
    lbReward.text = @"打赏数目：";
    lbReward.font = [UIFont systemFontOfSize:14.0];
    [viewReward addSubview:lbReward];
    
    m_textFiledReward = [[UITextField alloc] initWithFrame:CGRectMake(80, 10, 120, 30)];
    m_textFiledReward.backgroundColor = [UIColor clearColor];
    m_textFiledReward.font = [UIFont systemFontOfSize:13];
    m_textFiledReward.tintColor = [UIColor darkGrayColor];
    m_textFiledReward.keyboardType = UIKeyboardTypeNumberPad;
    m_textFiledReward.autocapitalizationType = UITextAutocapitalizationTypeNone;
    m_textFiledReward.enablesReturnKeyAutomatically = YES;
    m_textFiledReward.textAlignment = NSTextAlignmentLeft;
    m_textFiledReward.multipleTouchEnabled = YES;
    m_textFiledReward.returnKeyType = UIReturnKeyDone;
    m_textFiledReward.delegate = self;
    m_textFiledReward.textColor = [UIColor darkGrayColor];
    m_textFiledReward.layer.borderColor = [UIColor lightGrayColor].CGColor;
    m_textFiledReward.layer.borderWidth = 1.0;
    m_textFiledReward.layer.cornerRadius = 5.0;
    m_textFiledReward.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    m_textFiledReward.leftViewMode = UITextFieldViewModeAlways;
    m_textFiledReward.text = @"1";
    [viewReward addSubview:m_textFiledReward];
    
    rect = CGRectMake(10, CGRectGetMaxY(m_textFiledReward.frame) + 10, 220, 40);
    UILabel *lbTips = [[UILabel alloc]initWithFrame:rect];
    lbTips.backgroundColor = [UIColor clearColor];
    lbTips.textColor = [UIColor lightGrayColor];
    lbTips.font = [UIFont systemFontOfSize:13];
    lbTips.numberOfLines = 0;
    lbTips.text = [NSString stringWithFormat:@"亲，您当前的金币总额为%lu, 默认打赏数目为1个金币。", nCoinValue];
    [viewReward addSubview:lbTips];
    
    return viewReward;
}

-(void)popRewardView
{
    id processWin = [AlertManager showCommonProgress];
    
    [[SportForumAPI sharedInstance] walletGetBalanceInfo:^void(int errorCode, WalletBalanceInfo* walletBalanceInfo)
     {
         [AlertManager dissmiss:processWin];
         
         if(errorCode == 0 && [walletBalanceInfo.addresses.data count] > 0)
         {
             WalletBalanceItem * item = walletBalanceInfo.addresses.data[0];
             NSInteger nCoinValue = item.confirmed / 100000000;
             
             if(nCoinValue > 0)
             {
                 NSString *strRewardTitle = [NSString stringWithFormat:@"打赏%@", _currentObject.authorInfo.nikename];
                 m_rewardAlert = [[DXAlertView alloc] initWithTitle:strRewardTitle contentView:[self generateRewardView:nCoinValue] leftButtonTitle:nil rightButtonTitle:@"打赏"];
                 [m_rewardAlert show];
                 
                 __weak __typeof(self) weakSelf = self;
                 
                 m_rewardAlert.dismissBlock = ^() {
                     __typeof(self) strongSelf = weakSelf;
                     [strongSelf->m_textFiledReward resignFirstResponder];
                     strongSelf->m_textFiledReward.text = @"1";
                 };
                 
                 m_rewardAlert.rightBlock = ^() {
                     __typeof(self) strongSelf = weakSelf;
                     
                     [strongSelf->m_textFiledReward resignFirstResponder];
                     
                     if ([strongSelf->m_textFiledReward.text integerValue] > nCoinValue) {
                         [JDStatusBarNotification showWithStatus:@"您的余额不足！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                     }
                     else
                     {
                         [[CommonUtility sharedInstance]playAudioFromName:@"rewardTips.wav"];
                         
                         if(strongSelf->m_textFiledReward.text.length == 0)
                         {
                             strongSelf->m_textFiledReward.text = @"1";
                         }
                         
                         [strongSelf walletTradeByValue:[strongSelf->m_textFiledReward.text integerValue]];
                     }
                 };
             }
             else
             {
                 [JDStatusBarNotification showWithStatus:@"金币余额为0，不能打赏，赶快去赚取金币吧" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
             }
         }
         else
         {
             [JDStatusBarNotification showWithStatus:@"获取你的资产信息失败，请重新尝试" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
         }
     }];
}

- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

-(void)setYOffset:(CGFloat)offset ID:(id)win {
    [UIView beginAnimations:@"animiMove" context:nil];
    [UIView setAnimationDuration:0.2];
    UIView* view = (UIView*)win;
    CGRect viewRect  = view.frame;
    viewRect.origin.y = offset;
    view.frame = viewRect;
    [UIView commitAnimations];
}

- (void) keyboardWillShow:(NSNotification *) notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    if (m_rewardAlert != nil) {
        CGRect rect = self.appRootViewController.view.frame;
        
        int nOffset = (rect.size.height - m_rewardAlert.frame.origin.y - m_rewardAlert.frame.size.height) - keyboardSize.height - 20;
        nOffset = nOffset <= 0 ? nOffset : 0;
        
        if (m_nOffset != nOffset) {
            m_nOffset = nOffset;
            [self setYOffset:nOffset ID:self.appRootViewController.view];
        }
    }
}

- (void) keyboardWillHide:(NSNotification *) notification
{
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (m_rewardAlert != nil) {
        [self setYOffset:0 ID:self.appRootViewController.view];
    }
    
    m_nOffset = 0;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int MAX_CHARS = 8;
    BOOL bAllowWord = NO;
    
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    
    [newtxt replaceCharactersInRange:range withString:string];
    
    if ([newtxt length] > MAX_CHARS)
    {
        bAllowWord = NO;
    }
    else
    {
        bAllowWord = [self validateNumber:string];
    }
    
    return bAllowWord;
}

- (BOOL)validateNumber:(NSString*)number
{
    BOOL res = YES;
    NSString *strCharacter = @"0123456789";
    
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:strCharacter];
    int i = 0;
    while (i < number.length)
    {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0)
        {
            res = NO;
            break;
        }
        
        i++;
    }
    
    return res;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (m_rewardAlert != nil) {
        m_rewardAlert.rightBlock();
    }
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Reload Data Logic

- (void)updateUI:(NSUInteger)nUpdateItem {
    UILabel *label = (UILabel *)[m_barView viewWithTag:100];
    label.text = [NSString stringWithFormat:@"更新了%lu条博文",nUpdateItem];
    [label sizeToFit];
    CGRect frame = label.frame;
    frame.origin = CGPointMake((m_barView.frame.size.width - frame.size.width)/2, (m_barView.frame.size.height - frame.size.height)/2);
    label.frame = frame;
    
    [UIView animateWithDuration:0.6 animations:^{
        CGRect frame = m_barView.frame;
        frame.origin.y = 5;
        m_barView.frame = frame;
    } completion:^(BOOL finished){
        if (finished) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelay:3.0];
            [UIView setAnimationDuration:0.6];
            CGRect frame = m_barView.frame;
            frame.origin.y = -30;
            m_barView.frame = frame;
            [UIView commitAnimations];
        }
    }];
}

-(void)reloadArticlesData
{
    [self reloadDataWithFirstPageID:_strFirstPageId LastPageId:@""];
}

-(void)reloadDataWithFirstPageID:(NSString*)strFirstrPageId LastPageId:(NSString*)strLastPageId

{
    __weak __typeof(self) weakSelf = self;
    
    [[SportForumAPI sharedInstance]userArticlesByUserId:_strAuthorId ArticleType:_bComment ? article_type_comments : article_type_articles FirstPageId:strFirstrPageId LastPageId:strLastPageId PageItemNum:10 FinishedBlock:^void(int errorCode, ArticlesInfo *articlesInfo)
     {
         __typeof(self) strongSelf = weakSelf;
         
         if (strongSelf == nil) {
             return;
         }
         
         [m_activityIndicatorMain stopAnimating];
         [strongSelf stopRefresh];
         
         if (errorCode == 0 && [articlesInfo.articles_without_content.data count] > 0)
         {
             if (strFirstrPageId.length == 0 && strLastPageId.length == 0)
             {
                 [strongSelf->_arrAttentions removeAllObjects];
                 
                 strongSelf->_strFirstPageId = articlesInfo.page_frist_id;
                 strongSelf->_strLastPageId = articlesInfo.page_last_id;
             }
             else if (strFirstrPageId.length == 0 && strLastPageId.length > 0)
             {
                 strongSelf->_strLastPageId = articlesInfo.page_last_id;
             }
             else if(strFirstrPageId.length > 0 && strLastPageId.length == 0)
             {
                 strongSelf->_strFirstPageId = articlesInfo.page_frist_id;
                 //[strongSelf updateUI:[articlesInfo.articles_without_content.data count]];
             }
             
             [strongSelf->_arrAttentions addObjectsFromArray:articlesInfo.articles_without_content.data];
             [strongSelf->m_tableAttention reloadData];
         }
     }];
}

#pragma mark - Action New Operation

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

-(void)actionNewRecord:(id)sender {
    RecordSportViewController *recordSportViewController = [[RecordSportViewController alloc]init];
    [self.navigationController pushViewController:recordSportViewController animated:YES];
}

-(void)actionNewArticle:(id)sender {
    ArticlePublicViewController* articlePublicViewController = [[ArticlePublicViewController alloc]init];
    [self.navigationController pushViewController:articlePublicViewController animated:YES];
}

-(void)actionGame:(id)sender {
    GameViewController *gameViewController = [[GameViewController alloc]init];
    [self.navigationController pushViewController:gameViewController animated:YES];
}

#pragma mark - Reply Operation
- (UIView *)shareMenuView {
    if (!m_viewShareMenu) {
        UIView *shareMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), _keyboardViewHeight)];
        shareMenuView.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
        shareMenuView.alpha = 0.0;
        
        m_btnAddPng = [CSButton buttonWithType:UIButtonTypeCustom];
        m_btnAddPng.frame = CGRectMake(10, 10, 60, 60);
        [m_btnAddPng setImage:[UIImage imageNamed:@"add-images"] forState:UIControlStateNormal];
        [shareMenuView addSubview:m_btnAddPng];
        
        __weak __typeof(self) weakSelf = self;
        
        m_btnAddPng.actionBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            [strongSelf showPicSelect];
        };
        
        m_btnSend = [CSButton buttonWithType:UIButtonTypeCustom];
        [m_btnSend setTitle:@"发送" forState:UIControlStateNormal];
        [m_btnSend.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        m_btnSend.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [m_btnSend setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [m_btnSend setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        m_btnSend.backgroundColor = [UIColor clearColor];
        m_btnSend.frame = CGRectMake(CGRectGetWidth(shareMenuView.frame) - 100, CGRectGetHeight(shareMenuView.frame) - 30, 80, 20);
        [shareMenuView addSubview:m_btnSend];
        
        m_btnSend.actionBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            [strongSelf actionReplyTap:nil];
            [strongSelf publishSportLog];
        };
        
        m_viewShareMenu = shareMenuView;
    }
    
    m_btnSend.enabled = m_viewReply.inputTextView.text.length > 0;
    return m_viewShareMenu;
}

-(void)createReplyView
{
    typeof(self) __weak weakSelf = self;
    
    if (NO) {
        // 控制输入工具条的位置块
        void (^AnimationForMessageInputViewAtPoint)(CGPoint point) = ^(CGPoint point) {
            __typeof(self) strongSelf = weakSelf;
            CGRect inputViewFrame = strongSelf->m_viewReply.frame;
            CGPoint keyboardOrigin = [weakSelf.view convertPoint:point fromView:nil];
            inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
            strongSelf->m_viewReply.frame = inputViewFrame;
        };
        
        m_tableAttention.keyboardDidScrollToPoint = ^(CGPoint point) {
            __typeof(self) strongSelf = weakSelf;
            if (strongSelf->_textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        m_tableAttention.keyboardWillSnapBackToPoint = ^(CGPoint point) {
            __typeof(self) strongSelf = weakSelf;
            if (strongSelf->_textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        m_tableAttention.keyboardWillBeDismissed = ^() {
            __typeof(self) strongSelf = weakSelf;
            CGRect inputViewFrame = strongSelf->m_viewReply.frame;
            inputViewFrame.origin.y = strongSelf.view.bounds.size.height;
            strongSelf->m_viewReply.frame = inputViewFrame;
        };
    }
    
    // block回调键盘通知
    __typeof__(m_tableAttention) __weak thisTable = m_tableAttention;
    
    m_tableAttention.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
        __typeof(self) strongSelf = weakSelf;
        if (strongSelf->_textViewInputViewType == XHInputViewTypeText) {
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:options
                             animations:^{
                                 CGFloat keyboardY = [weakSelf.view convertRect:keyboardRect fromView:nil].origin.y;
                                 
                                 CGRect inputViewFrame = strongSelf->m_viewReply.frame;
                                 CGFloat inputViewFrameY = (showKeyborad ? keyboardY - inputViewFrame.size.height : keyboardY);
                                 
                                 // for ipad modal form presentations
                                 CGFloat messageViewFrameBottom = (showKeyborad ? weakSelf.view.frame.size.height - inputViewFrame.size.height : weakSelf.view.frame.size.height);
                                 if (inputViewFrameY > messageViewFrameBottom)
                                     inputViewFrameY = messageViewFrameBottom;
                                 
                                 strongSelf->m_viewReply.frame = CGRectMake(inputViewFrame.origin.x,
                                                                            inputViewFrameY,
                                                                            inputViewFrame.size.width,
                                                                            inputViewFrame.size.height);
                                 
                                 if (showKeyborad)
                                 {
                                     NSUInteger nIndex = [strongSelf->_arrAttentions indexOfObject:strongSelf->_currentObject];
                                     RecommendCircleTableViewCell *cell = (RecommendCircleTableViewCell*)[thisTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nIndex inSection:0]];
                                     
                                     CGRect rect = [thisTable convertRect:cell.lbSep2.frame fromView:cell];
                                     CGFloat fOffset = CGRectGetMaxY(rect) + inputViewFrame.size.height + keyboardRect.size.height - CGRectGetHeight(thisTable.frame);
                                     
                                     if (fOffset > 0) {
                                         [thisTable setContentOffset:CGPointMake(0.0, fOffset) animated:YES];
                                     }
                                 }
                                 else
                                 {
                                     [thisTable setContentOffset:strongSelf->_fOffsetShowKeyBoard animated:YES];
                                 }
                             }
                             completion:nil];
        }
    };
    
    m_tableAttention.keyboardDidChange = ^(BOOL didShowed) {
        __typeof(self) strongSelf = weakSelf;
        
        if ([strongSelf->m_viewReply.inputTextView isFirstResponder]) {
            if (didShowed) {
                if (strongSelf->_textViewInputViewType == XHInputViewTypeText) {
                    strongSelf.shareMenuView.alpha = 0.0;
                }
            }
        }
    };
    
    m_tableAttention.keyboardDidHide = ^() {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->m_viewReply.inputTextView resignFirstResponder];
    };
    
    // 输入工具条的frame
    CGRect inputFrame = CGRectMake(0.0f,
                                   self.view.frame.size.height,
                                   self.view.frame.size.width,
                                   45.0f);
    
    m_viewReply = [[XHMessageInputView alloc] initWithFrame:inputFrame];
    m_viewReply.allowsSendFace = NO;
    m_viewReply.allowsSendVoice = NO;
    m_viewReply.allowsSendMultiMedia = YES;
    m_viewReply.delegate = self;
    m_viewReply.messageInputViewStyle = XHMessageInputViewStyleFlat;
    [self.navigationController.view addSubview:m_viewReply];
    [self.navigationController.view bringSubviewToFront:m_viewReply];
    
    m_viewReply.inputTextView.placeHolder = @"评论";
    UIImage *image = [UIImage imageNamed:@"tool-bg-1"];
    m_viewReply.layer.contents = (id) image.CGImage;
}

#pragma mark - PickView Create

-(void)createCustomSelectPick:(UIView*)viewMain PickView:(UIView*)viewPick Title:(NSString*)strTitle DoneAction:(void(^)(void))doneBlock CancelAction:(void(^)(void))cancelBlock TitleAction:(void(^)(void))titleBlock
{
    viewMain.frame = [UIScreen mainScreen].bounds;
    viewMain.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    UIView *viewTapPickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewMain.frame.size.width, CGRectGetHeight(viewMain.frame) - 260)];
    viewTapPickView.backgroundColor = [UIColor clearColor];
    [viewMain addSubview:viewTapPickView];
    [viewMain bringSubviewToFront:viewTapPickView];
    
    UITapGestureRecognizer* tapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTapPickView:)];
    [viewTapPickView addGestureRecognizer:tapRecogniser];
    
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height - 260, viewMain.frame.size.width, 260);
    viewPick.backgroundColor = [UIColor whiteColor];
    [viewMain addSubview:viewPick];
    [viewMain bringSubviewToFront:viewPick];
    
    CSButton *doneButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.frame = CGRectMake(250.0f, 10.0f, 60.0f, 30.0f);
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    doneButton.actionBlock = doneBlock;
    
    CSButton *cancelButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.frame = CGRectMake(10.0f, 10.0f, 60.0f, 30.0f);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.actionBlock = cancelBlock;
    
    CSButton *titleButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [titleButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    titleButton.backgroundColor = [UIColor clearColor];
    titleButton.frame = CGRectMake((CGRectGetWidth(viewPick.frame) - 160.0) / 2, 10.0f, 160.0f, 30.0f);
    [titleButton setTitle:strTitle forState:UIControlStateNormal];
    titleButton.actionBlock = titleBlock;
    
    TRSDialScrollView *dialView = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(0, 80, [UIScreen screenWidth], 100)];
    dialView.tag = 11000;
    
    UILabel *lbValue = [[UILabel alloc]init];
    lbValue.backgroundColor = [UIColor clearColor];
    lbValue.textAlignment = NSTextAlignmentCenter;
    lbValue.frame = CGRectMake(0, CGRectGetMaxY(dialView.frame), [UIScreen screenWidth], 40);
    lbValue.tag = 11001;
    
    [viewPick addSubview:doneButton];
    [viewPick addSubview:cancelButton];
    [viewPick addSubview:titleButton];
    [viewPick addSubview:lbValue];
    [viewPick addSubview:dialView];
    
    [dialView setDirection:YES];
    dialView.dataFormat = DATA_FORMAT_NUM;
    [dialView setMinorTicksPerMajorTick:10];
    [dialView setMinorTickDistance:8];
    [dialView setBackgroundColor:[UIColor whiteColor]];
    [dialView setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
    [dialView setLabelStrokeWidth:0.1f];
    [dialView setLabelFillColor:[UIColor darkGrayColor]];
    [dialView setLabelFont:[UIFont systemFontOfSize:14]];
    [dialView setMinorTickColor:[UIColor lightGrayColor]];
    [dialView setMinorTickLength:15.0];
    [dialView setMinorTickWidth:1.0];
    [dialView setMajorTickColor:[UIColor darkGrayColor]];
    [dialView setMajorTickLength:30.0];
    [dialView setMajorTickWidth:1];
    [dialView setCurValueViewLength:70];
    dialView.delegate = self;
    
    if (viewMain == m_viewReward) {
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        NSInteger nCoinValue = userInfo.proper_info.coin_value / 100000000;
        [dialView setDialRangeFrom:1 to:nCoinValue];
        dialView.currentValue = nCoinValue < 5 ? 1 : 5;
        [self setDialViewValue:nCoinValue < 5 ? 1 : 5 ViewPick:viewPick UnitFormat:@" 金币"];
    }
}

- (void)popPickView:(UIView*)viewMain PickView:(UIView*)viewPick
{
    if(viewMain == m_viewReward)
    {
        TRSDialScrollView *dialView = (TRSDialScrollView*)[m_viewReward viewWithTag:11000];
        UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
        NSInteger nCoinValue = userInfo.proper_info.coin_value / 100000000;
        [dialView setCurrentValue:nCoinValue < 5 ? 1 : 5];
        [self setDialViewValue:nCoinValue < 5 ? 1 : 5 ViewPick:m_viewReward UnitFormat:@" 金币"];
    }
    
    [self.navigationController.view addSubview:viewMain];
    [viewMain bringSubviewToFront:viewPick];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height - 260, [UIScreen screenWidth], 260);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)hidePickView:(UIView*)viewMain PickView:(UIView*)viewPick{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    viewPick.frame = CGRectMake(0, viewMain.frame.size.height, [UIScreen screenWidth], 260);
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

-(void)actionTapPickView:(UITapGestureRecognizer*)gr {
    [self hidePickView:m_viewReward PickView:m_pickerView0];
}

-(void)animationFinished{
    [m_viewReward removeFromSuperview];
}

-(void)setDialViewValue:(NSInteger)nValue ViewPick:(UIView*)viewPick UnitFormat:(NSString*)strUnitFormat
{
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:30], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", nValue] attributes:attribs];
    attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:strUnitFormat attributes:attribs];
    
    NSMutableAttributedString * strValue = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strValue appendAttributedString:strPart2Value];
    
    UILabel *lbValue = (UILabel*)[viewPick viewWithTag:11001];
    lbValue.attributedText = strValue;
}

-(void)createRewardView
{
    m_viewReward = [[UIView alloc]init];
    m_pickerView0 = [[UIView alloc]init];
    
    __weak __typeof(self) weakSelf = self;
    
    [self createCustomSelectPick:m_viewReward PickView:m_pickerView0 Title:@"设置打赏金币"
                      DoneAction:^void(){
                          __typeof(self) strongSelf = weakSelf;
                          TRSDialScrollView *dialView = (TRSDialScrollView*)[strongSelf->m_viewReward viewWithTag:11000];
                          [strongSelf walletTradeByValue:dialView.currentValue];
                          [strongSelf hidePickView:strongSelf->m_viewReward PickView:strongSelf->m_pickerView0];
                      } CancelAction:^void(){
                          __typeof(self) strongSelf = weakSelf;
                          [strongSelf hidePickView:strongSelf->m_viewReward PickView:strongSelf->m_pickerView0];
                      } TitleAction:nil];
}

#pragma mark - Comment Operation

-(void)createCommentBoard {
    
    _viewCommentBoard = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height,
                                                                self.view.frame.size.width,
                                                                COMMENT_BOARD_HEIGHT)];
    
    _lbReviewTitle = [[UILabel alloc]initWithFrame:CGRectMake(5,
                                                              10, 150, 20)];
    _lbReviewTitle.textColor = [UIColor whiteColor];
    _lbReviewTitle.font = [UIFont boldSystemFontOfSize:14];
    _lbReviewTitle.text =  @"";
    [_viewCommentBoard addSubview:_lbReviewTitle];
    
    _btnReview = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnReview.frame = CGRectMake(self.view.frame.size.width - 44, 5, 39, 35);
    [_btnReview setImage:[UIImage imageNamed:@"reply-btn"] forState:UIControlStateNormal];
    [_viewCommentBoard addSubview:_btnReview];
    
    __weak __typeof(self) weakSelf = self;
    
    _btnReview.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf hideCommentBoard];
        strongSelf->_fOffsetShowKeyBoard = strongSelf->m_tableAttention.contentOffset;
        
        for (UIImageView* imageView in strongSelf->_imgViewArray) {
            [imageView removeFromSuperview];
        }
        
        for (CSButton *btnImage in strongSelf->_imgBtnArray) {
            [btnImage removeFromSuperview];
        }
        
        [strongSelf->_imgUrlArray removeAllObjects];
        [strongSelf->_imgViewArray removeAllObjects];
        [strongSelf->_imgBtnArray removeAllObjects];
        
        strongSelf->m_btnAddPng.hidden = NO;
        strongSelf->m_btnAddPng.frame = CGRectMake(10, 10, 60, 60);
        
        NSMutableDictionary *dictData = [strongSelf->_replyDict objectForKey:strongSelf->_currentObject.article_id];
        
        if (dictData != nil) {
            [strongSelf->m_viewReply.inputTextView setText:[dictData objectForKey:@"Content"]];
            [strongSelf generateImageViewByUrls:[dictData objectForKey:@"ImgUrls"]];
        }
        else
        {
            [strongSelf->m_viewReply.inputTextView setText:@""];
        }
        
        [strongSelf->m_viewReply.inputTextView becomeFirstResponder];
    };
    
    _lbNoReview = [[UILabel alloc]initWithFrame:CGRectMake(10,
                                                           CGRectGetMaxY(_lbReviewTitle.frame) + 60, 310, 20)];
    _lbNoReview.textColor = [UIColor whiteColor];
    _lbNoReview.font = [UIFont boldSystemFontOfSize:18];
    _lbNoReview.text =  @"还没有人评论，赶紧抢沙发哦！";
    _lbNoReview.textAlignment = NSTextAlignmentCenter;
    _lbNoReview.hidden = YES;
    [_viewCommentBoard addSubview:_lbNoReview];
    
    _swipeView = [[SwipeView alloc]initWithFrame:CGRectMake(0, COMMENT_BOARD_HEIGHT - 110,
                                                            self.view.frame.size.width, 110)];
    UIImage *image = [UIImage imageNamed:@"tool-bg-2"];
    _viewCommentBoard.layer.contents = (id) image.CGImage;
    
    //_viewCommentBoard.backgroundColor = [UIColor colorWithRed:96.0 / 255.0 green:205.0 / 255.0 blue:255.0 / 255.0 alpha:1.0];
    _swipeView.alignment = SwipeViewAlignmentEdge;
    _swipeView.pagingEnabled = NO;
    _swipeView.truncateFinalPage = YES;
    _swipeView.scrollEnabled = YES;
    _swipeView.delegate = self;
    _swipeView.dataSource = self;
    _swipeView.backgroundColor = [UIColor clearColor];
    
    [_viewCommentBoard addSubview:_swipeView];
    
    _PullRightRefreshView = [[EGORefreshTableHeaderView alloc] initWithScrollView:(UIScrollView*)[_swipeView currentSwipeView] orientation:EGOPullOrientationRight];
    _PullRightRefreshView.delegate = self;
    _PullRightRefreshView.backgroundColor = [UIColor clearColor];
    
    m_footViewIndicator = [[UIView alloc] initWithFrame:CGRectZero];
    m_activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 20.0f, 20.0f)];
    [m_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 10.0f, 80.0f, 20.0f)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont boldSystemFontOfSize:13.0f];
    label.textColor = [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0];
    label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.text = @"正在加载...";
    
    m_footViewIndicator.backgroundColor = [UIColor clearColor];
    m_footViewIndicator.hidden = YES;
    [m_footViewIndicator addSubview:m_activityIndicator];
    [m_footViewIndicator addSubview:label];
    [[_swipeView currentSwipeView] addSubview:m_footViewIndicator];
    m_footViewIndicator.transform = CGAffineTransformMakeRotation((-90.0f * M_PI) / 180.0f);
    
    _arrayCommentInfos = [[NSMutableArray alloc]init];
}

-(void)actionTap:(UITapGestureRecognizer*)gr {
    [m_tableAttention setContentOffset:_fOffset animated:YES];
    [self hideCommentBoard];
}

-(void)actionReplyTap:(UITapGestureRecognizer*)gr {
    CGRect inputViewFrame = m_viewReply.frame;
    
    if (inputViewFrame.origin.y != self.view.bounds.size.height && _textViewInputViewType != XHInputViewTypeNormal) {
        [self layoutOtherMenuViewHiden:YES];
    }
}

-(void)hideCommentBoard
{
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlArticleComments, nil]];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    _viewCommentBoard.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, COMMENT_BOARD_HEIGHT);
    [UIView commitAnimations];
    
    _fOffset = CGPointZero;
    
    if (m_tapGestureRecognizer != nil) {
        [m_tapGestureRecognizer removeTarget:self action:@selector(actionTap:)];
        m_tapGestureRecognizer = nil;
    }
    
    [_viewCommentBoard removeFromSuperview];
}

-(void)showCommentByArticleId:(NSString*)articleID {
    [AlertManager dissmiss:_progressInCommentBoard];
    _progressInCommentBoard = [AlertManager showCommonProgressInView:_viewCommentBoard];
    
    __weak __typeof(self) weakself = self;
    
    [[SportForumAPI sharedInstance]articleCommentsByArticleId:articleID FirstPageId:nil LastPageId:nil PageItemNum:5 Type:@""  FinishedBlock:^(int errorCode, ArticlesInfo *articlesInfo) {
        __typeof(self) strongself = weakself;
        
        [AlertManager dissmiss:_progressInCommentBoard];
        if (strongself == nil) {
            return;
        }
        
        if (errorCode == 0 && [articlesInfo.articles_without_content.data count] > 0) {
            _arrayCommentInfos = articlesInfo.articles_without_content.data;
            [_swipeView reloadData];
        }
        
        if (_arrayCommentInfos.count == 0) {
            _lbNoReview.hidden = NO;
            _swipeView.hidden = YES;
            
        } else {
            _lbNoReview.hidden = YES;
            _swipeView.hidden = NO;
        }
        
        _lbReviewTitle.text = [NSString stringWithFormat:@"评论(%lu)", _arrayCommentInfos.count];
    }];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    
    _viewCommentBoard.frame = CGRectMake(0, self.view.frame.size.height - COMMENT_BOARD_HEIGHT, self.view.frame.size.width, COMMENT_BOARD_HEIGHT);
    [UIView commitAnimations];
    
    _fOffset = m_tableAttention.contentOffset;
    
    if (m_tapGestureRecognizer == nil) {
        m_tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
        [self.view addGestureRecognizer:m_tapGestureRecognizer];
    }
    
    [self.navigationController.view addSubview:_viewCommentBoard];
}

- (void)showBottomIndicator:(BOOL)blShow {
    UIScrollView *scrollView = (UIScrollView*)[_swipeView currentSwipeView];
    
    if (blShow) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 60.0f)];
        [UIView commitAnimations];
        
        m_footViewIndicator.hidden = NO;
        [m_activityIndicator startAnimating];
    }
    else {
        m_footViewIndicator.hidden = YES;
        [m_activityIndicator stopAnimating];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
        [UIView commitAnimations];
    }
}

#pragma mark - Swip Comment Items

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView {
    return _arrayCommentInfos.count;
}

- (void)swipeViewResetAfterlayoutSubviews:(SwipeView *)swipeView {
    UIScrollView *scrollView = (UIScrollView*)[_swipeView currentSwipeView];
    m_footViewIndicator.frame = CGRectMake(SWIPE_CELL_WEIGHT * _arrayCommentInfos.count + 10, 0.0, 40, CGRectGetHeight(scrollView.frame));
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view {
    
    WallCell* cell = (WallCell*)view;
    
    if (!cell) {
        cell = [[WallCell alloc]initWithFrame:CGRectMake(0, 0, SWIPE_CELL_WEIGHT, SWIPE_CELL_WEIGHT)];
    }
    
    ArticlesObject* articleObj = [_arrayCommentInfos objectAtIndex:index];
    WallCellInfo* cellInfo = [[WallCellInfo alloc]init];
    cellInfo.imageUser = articleObj.authorInfo.profile_image;
    cellInfo.imageURL = articleObj.cover_image;
    cellInfo.title = articleObj.cover_text;
    cellInfo.thumbCount = articleObj.thumb_count;
    cellInfo.commentCount = articleObj.sub_article_count;
    cell.cellInfo = cellInfo;
    cell.tag = 100000 + index;
    [cell addTarget:self action:@selector(actionCommentSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)swipeViewDidScroll:(SwipeView *)swipeView
{
    if (_reloading == NO)
    {
        [_PullRightRefreshView egoRefreshScrollViewDidScroll:(UIScrollView*)[swipeView currentSwipeView]];
    }
}

- (void)swipeViewDidEndDragging:(SwipeView *)swipeView willDecelerate:(BOOL)decelerate
{
    if (_reloading == NO)
    {
        [_PullRightRefreshView egoRefreshScrollViewDidEndDragging:(UIScrollView*)[swipeView currentSwipeView]];
    }
    
    UIScrollView *scrollView = (UIScrollView*)[swipeView currentSwipeView];
    CGFloat x = scrollView.contentOffset.x+scrollView.frame.size.width-scrollView.contentSize.width;
    
    if((x > 40 && scrollView.contentSize.width > 0) || (scrollView.contentOffset.x > 40 && scrollView.contentSize.width < 0))
    {
        [self showBottomIndicator:YES];
        [self performSelector:@selector(upDragLoadData) withObject:nil afterDelay:1];
    }
}

-(void)actionCommentSelect:(WallCell*)sender {
    [self hideCommentBoard];
    ArticlePagesViewController* articlePagesViewController = [[ArticlePagesViewController alloc]init];
    articlePagesViewController.currentIndex = sender.tag - 100000;
    articlePagesViewController.arrayArticleInfos = _arrayCommentInfos;
    [self.navigationController pushViewController:articlePagesViewController animated:YES];
}

#pragma mark - Key-value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object == m_viewReply.inputTextView && [keyPath isEqualToString:@"contentSize"]) {
        [self layoutAndAnimateMessageInputTextView:object];
    }
    else if(object == m_viewReply && [keyPath isEqualToString:@"frame"])
    {
        CGRect rect = m_viewReply.frame;
        
        if (rect.origin.y == self.view.bounds.size.height) {
            if (m_tapGestureRecognizer0 != nil) {
                [m_tapGestureRecognizer0 removeTarget:self action:@selector(actionReplyTap:)];
                m_tapGestureRecognizer0 = nil;
            }
            
            if(_currentObject != nil)
            {
                NSMutableArray *arrImgUrls = [NSMutableArray arrayWithArray:_imgUrlArray];
                [_replyDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:m_viewReply.inputTextView.text, @"Content", arrImgUrls, @"ImgUrls", nil] forKey:_currentObject.article_id];
            }
        }
        else
        {
            if (m_tapGestureRecognizer0 == nil) {
                m_tapGestureRecognizer0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionReplyTap:)];
                [self.view addGestureRecognizer:m_tapGestureRecognizer0];
            }
        }
    }
}

#pragma mark - UITextView Helper Method

- (CGFloat)getTextViewContentH:(UITextView *)textView {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

#pragma mark - Layout Message Input View Helper Method

- (void)layoutAndAnimateMessageInputTextView:(UITextView *)textView {
    CGFloat maxHeight = [XHMessageInputView maxHeight];
    
    CGFloat contentH = [self getTextViewContentH:textView];
    
    BOOL isShrinking = contentH < _previousTextViewContentHeight;
    CGFloat changeInHeight = contentH - _previousTextViewContentHeight;
    
    CGSize size = [[textView text] sizeWithAttributes:@{NSFontAttributeName:[textView font]}];
    int length = size.height;
    int colomNumber = textView.contentSize.height/length;
    
    if (!isShrinking && (_previousTextViewContentHeight == maxHeight || textView.text.length == 0 || colomNumber == 1)) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - _previousTextViewContentHeight);
    }
    
    if (changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             
                             //[self setTableViewInsetsWithBottomValue:self.messageTableView.contentInset.bottom + changeInHeight];
                             
                             //[self scrollToBottomAnimated:NO];
                             
                             if (isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     _previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [m_viewReply adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = m_viewReply.frame;
                             m_viewReply.frame = CGRectMake(0.0f,
                                                            inputViewFrame.origin.y - changeInHeight,
                                                            inputViewFrame.size.width,
                                                            inputViewFrame.size.height + changeInHeight);
                             if (!isShrinking) {
                                 if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
                                     _previousTextViewContentHeight = MIN(contentH, maxHeight);
                                 }
                                 // growing the view, animate the text view frame AFTER input view frame
                                 [m_viewReply adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             NSUInteger nIndex = [_arrAttentions indexOfObject:_currentObject];
                             RecommendCircleTableViewCell *cell = (RecommendCircleTableViewCell*)[m_tableAttention cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nIndex inSection:0]];
                             
                             CGRect rect = [m_tableAttention convertRect:cell.lbSep2.frame fromView:cell];
                             CGFloat fOffset = CGRectGetMaxY(rect) + CGRectGetHeight(self.view.frame) - CGRectGetMinY(m_viewReply.frame) - CGRectGetHeight(m_tableAttention.frame);
                             
                             if (fOffset > 0) {
                                 [m_tableAttention setContentOffset:CGPointMake(0.0, fOffset) animated:YES];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        _previousTextViewContentHeight = MIN(contentH, maxHeight);
    }
    
    // Once we reached the max height, we have to consider the bottom offset for the text view.
    // To make visible the last line, again we have to set the content offset.
    if (_previousTextViewContentHeight == maxHeight) {
        double delayInSeconds = 0.01;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime,
                       dispatch_get_main_queue(),
                       ^(void) {
                           CGPoint bottomOffset = CGPointMake(0.0f, contentH - textView.bounds.size.height);
                           [textView setContentOffset:bottomOffset animated:YES];
                       });
    }
}

#pragma mark - Other Menu View Frame Helper Mehtod

- (void)layoutOtherMenuViewHiden:(BOOL)hide {
    [m_viewReply.inputTextView resignFirstResponder];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        __block CGRect inputViewFrame = m_viewReply.frame;
        __block CGRect otherMenuViewFrame;
        
        void (^InputViewAnimation)(BOOL hide) = ^(BOOL hide) {
            inputViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.bounds) : (CGRectGetMinY(otherMenuViewFrame) - CGRectGetHeight(inputViewFrame)));
            m_viewReply.frame = inputViewFrame;
        };
        
        void (^ShareMenuViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.shareMenuView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(self.view.frame) : (CGRectGetHeight(self.view.frame) - CGRectGetHeight(otherMenuViewFrame)));
            self.shareMenuView.alpha = !hide;
            self.shareMenuView.frame = otherMenuViewFrame;
            
            if (hide) {
                [m_viewShareMenu removeFromSuperview];
            }
            else
            {
                BOOL bContains = NO;
                NSArray *arrSubViews = [self.navigationController.view subviews];
                
                for (UIView *view in arrSubViews) {
                    if (view == m_viewShareMenu) {
                        bContains = YES;
                        break;
                    }
                }
                
                // at this point, view is nil or a table view cell; ask the table view for its index path
                if (!bContains) {
                    [self.navigationController.view addSubview:m_viewShareMenu];
                    [self.navigationController.view bringSubviewToFront:m_viewShareMenu];
                }
            }
        };
        
        ShareMenuViewAnimation(hide);
        InputViewAnimation(hide);
        
        if (hide) {
            [m_tableAttention setContentOffset:_fOffsetShowKeyBoard animated:YES];
        }
        else
        {
            NSUInteger nIndex = [_arrAttentions indexOfObject:_currentObject];
            RecommendCircleTableViewCell *cell = (RecommendCircleTableViewCell*)[m_tableAttention cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nIndex inSection:0]];
            
            CGRect rect = [m_tableAttention convertRect:cell.lbSep2.frame fromView:cell];
            CGFloat fOffset = CGRectGetMaxY(rect) + CGRectGetHeight(self.view.frame) - CGRectGetMinY(m_viewReply.frame) - CGRectGetHeight(m_tableAttention.frame);
            
            if (fOffset > 0) {
                [m_tableAttention setContentOffset:CGPointMake(0.0, fOffset) animated:YES];
            }
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - XHMessageInputView Delegate

- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView {
    _textViewInputViewType = XHInputViewTypeText;
    [m_viewReply.multiMediaSendButton setBackgroundImage:[UIImage imageNamed:@"blog-reply-plus"] forState:UIControlStateNormal];
    [m_viewReply.multiMediaSendButton setBackgroundImage:[UIImage imageNamed:@"blog-reply-plus"] forState:UIControlStateHighlighted];
}

- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView {
    if (!_previousTextViewContentHeight)
        _previousTextViewContentHeight = [self getTextViewContentH:messageInputTextView];
}

- (void)didSendTextAction:(NSString *)text {
    [self actionReplyTap:nil];
    [self publishSportLog];
}

- (void)didSelectedMultipleMediaAction {
    if(_textViewInputViewType == XHInputViewTypeShareMenu)
    {
        [m_viewReply.inputTextView becomeFirstResponder];
    }
    else
    {
        [m_viewReply.multiMediaSendButton setBackgroundImage:[UIImage imageNamed:@"blog-reply-input"] forState:UIControlStateNormal];
        [m_viewReply.multiMediaSendButton setBackgroundImage:[UIImage imageNamed:@"blog-reply-input"] forState:UIControlStateHighlighted];
        _textViewInputViewType = XHInputViewTypeShareMenu;
        [self layoutOtherMenuViewHiden:NO];
    }
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

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser deletePhotoAtIndex:(NSUInteger)index {
    if (index <= _photos.count)
    {
        MWPhoto *mwPhoto = [_photos objectAtIndex:index];
        
        if ([mwPhoto.photoURL description].length > 0) {
            [[SportForumAPI sharedInstance]fileDeleteByIds:@[[mwPhoto.photoURL description]] FinishedBlock:^(int errorCode){
                if (errorCode == 0) {
                    _bUpdatePhotos = YES;
                    [_photos removeObjectAtIndex:index];
                    [photoBrowser reloadData];
                }
            }];
        }
    }
}

-(void)onClickImageViewByIndex:(NSUInteger)index UrlArr:(NSMutableArray*)imgUrlArray
{
    [_photos removeAllObjects];
    
    for (NSString *strUrl in imgUrlArray) {
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

-(void)onClickVideoPreView:(NSString*)strUrl
{
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    MPMoviePlayerViewController *moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:url];
    //CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI/2);
    //[moviePlayerViewController.view setTransform:transform];
    [self presentMoviePlayerViewControllerAnimated:moviePlayerViewController];
}

#pragma mark - Add Reply image logic
-(void)showPicSelect {
    __weak __typeof(self) thisPointer = self;
    
    _customMenuViewController = [[CustomMenuViewController alloc]init];
    
    [_customMenuViewController addButtonFromBackTitle:@"取消" ActionBlock:^(id sender) {
    }];
    
    [_customMenuViewController addButtonFromBackTitle:@"从本地选取" ActionBlock:^(id sender) {
        [thisPointer actionSelectPhoto:sender];
    }];
    
    [_customMenuViewController addButtonFromBackTitle:@"立即拍照" Hightlight:YES ActionBlock:^(id sender) {
        [thisPointer actionTakePhoto:sender];
    }];
    
    [_customMenuViewController showInView:self.navigationController.view];
}

-(void)onClickImageViewByIndex:(NSUInteger)index
{
    [_photos removeAllObjects];
    
    for (NSString *strUrl in _imgUrlArray) {
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:strUrl]]];
    }
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayDeleteButton = YES;
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

-(void)refreshImageViews
{
    if (_bUpdatePhotos) {
        for (UIImageView* imageView in _imgViewArray) {
            [imageView removeFromSuperview];
        }
        
        for (CSButton *btnImage in _imgBtnArray) {
            [btnImage removeFromSuperview];
        }
        
        [_imgUrlArray removeAllObjects];
        [_imgViewArray removeAllObjects];
        [_imgBtnArray removeAllObjects];
        
        m_btnAddPng.hidden = NO;
        m_btnAddPng.frame = CGRectMake(10, 10, 60, 60);
        _bUpdatePhotos = NO;
        
        NSMutableArray *arrayUrls = [[NSMutableArray alloc]init];
        
        for (MWPhoto *mwPhoto in _photos) {
            [arrayUrls addObject:[mwPhoto.photoURL description]];
        }
        
        [self generateImageViewByUrls:arrayUrls];
    }
    
    if (_bShowMwPhotoBrowser) {
        _bShowMwPhotoBrowser = NO;
        [self.navigationController.view bringSubviewToFront:m_viewReply];
        [self.navigationController.view bringSubviewToFront:m_viewShareMenu];
    }
}

-(void)generateImageViewByUrls:(NSMutableArray*)arrayUrls
{
    if ([arrayUrls count] == 0) {
        return;
    }
    
    CGRect rectEnd = CGRectZero;
    
    if ([_imgViewArray count] == 0) {
        rectEnd = m_btnAddPng.frame;
    }
    else
    {
        UIImageView *imageView = [_imgViewArray lastObject];
        rectEnd = imageView.frame;
    }
    
    for (int i = 0; i < MIN([arrayUrls count], MAX_PUBLISH_PNG_COUNT); i++) {
        if (([_imgViewArray count] - 1) % 4 == 3 && [_imgViewArray count] > 0) {
            rectEnd.origin = CGPointMake(10, CGRectGetMaxY(rectEnd) + 10);
        }
        else
        {
            rectEnd.origin = CGPointMake([_imgViewArray count] == 0 ? 10 + 77 * i : (CGRectGetMaxX(rectEnd) + 17), CGRectGetMinY(rectEnd));
        }
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rectEnd];
        [imageView sd_setImageWithURL:[NSURL URLWithString:arrayUrls[i]]
                     placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        /*UIView * backframe = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame) - 1, CGRectGetMinY(imageView.frame) - 1, CGRectGetWidth(imageView.frame) + 2, CGRectGetHeight(imageView.frame) + 2)];
         backframe.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
         backframe.layer.borderWidth = 1.0;
         backframe.layer.borderColor = [[UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1] CGColor];*/
        
        CSButton *btnImage = [CSButton buttonWithType:UIButtonTypeCustom];
        btnImage.frame = imageView.frame;
        btnImage.backgroundColor = [UIColor clearColor];
        [m_viewShareMenu addSubview:btnImage];
        
        __weak __typeof(self) weakSelf = self;
        
        btnImage.actionBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            strongSelf->_bShowMwPhotoBrowser = YES;
            [strongSelf.navigationController.view sendSubviewToBack:strongSelf->m_viewReply];
            [strongSelf.navigationController.view sendSubviewToBack:strongSelf->m_viewShareMenu];
            
            NSUInteger nIndex = [strongSelf->_imgViewArray indexOfObject:imageView];
            [strongSelf onClickImageViewByIndex:nIndex];
        };
        
        [m_viewShareMenu addSubview:imageView];
        [m_viewShareMenu addSubview:btnImage];
        [m_viewShareMenu bringSubviewToFront:imageView];
        [m_viewShareMenu bringSubviewToFront:btnImage];
        
        [_imgBtnArray addObject:btnImage];
        [_imgViewArray addObject:imageView];
        [_imgUrlArray addObject:arrayUrls[i]];
    }
    
    if (([_imgViewArray count] - 1) % 4 == 3) {
        m_btnAddPng.frame = CGRectMake(10, CGRectGetMaxY(rectEnd) + 10, CGRectGetWidth(rectEnd), CGRectGetHeight(rectEnd));
    }
    else
    {
        m_btnAddPng.frame = CGRectMake(CGRectGetMaxX(rectEnd) + 17, CGRectGetMinY(rectEnd), CGRectGetWidth(rectEnd), CGRectGetHeight(rectEnd));
    }
    
    m_btnAddPng.hidden = ([_imgUrlArray count] >= MAX_PUBLISH_PNG_COUNT);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imageEditViewController = [[ImageEditViewController alloc]initWithNibName:@"ImageEditViewController" bundle:nil];
    _imageEditViewController.checkBounds = YES;
    
    __weak __typeof(self) thisPointer = self;
    
    _imageEditViewController.doneCallback = [_imageEditViewController commonDoneCallbackWithUserDoneCallBack:^(UIImage *doneImage,
                                                                                                               NSString *doneImageID,
                                                                                                               BOOL isOK) {
        __typeof(self) strongThis = thisPointer;
        
        if (strongThis != nil) {
            if (isOK) {
                if (doneImageID != nil &&
                    [doneImageID isEqualToString:@""] == NO) {
                    [strongThis generateImageViewByUrls:[NSMutableArray arrayWithObject:doneImageID]];
                }
            }
            
            [strongThis.navigationController.view bringSubviewToFront:strongThis->m_viewReply];
            [strongThis.navigationController.view bringSubviewToFront:strongThis->m_viewShareMenu];
        }
    }];
    
    _imageEditViewController.sourceImage = image;
    [_imageEditViewController reset:NO];
    
    [self.navigationController.view sendSubviewToBack:m_viewReply];
    [self.navigationController.view sendSubviewToBack:m_viewShareMenu];
    [self.navigationController pushViewController:_imageEditViewController animated:YES];
    _imageEditViewController.cropSize = CGSizeMake([UIScreen screenWidth], 320);
}

-(IBAction)actionTakePhoto:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera, we want to take a picture, otherwise, we
    // just pick from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    [imagePicker setDelegate:self];
}

-(IBAction)actionSelectPhoto:(id)sender
{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = MAX_PUBLISH_PNG_COUNT - [_imgViewArray count];
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    NSMutableArray *arrImages = [[NSMutableArray alloc]init];
    
    for (ALAsset *asset in assets) {
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        if (image != nil) {
            [arrImages addObject:image];
        }
    }
    
    if([arrImages count] > 0)
    {
        __block id processWindow = [AlertManager showCommonProgress];
        
        [[ApplicationContext sharedInstance]upLoadByImageArray:arrImages FinishedBlock:^(NSMutableArray *arrayResult){
            NSMutableArray * arrUrls = [[NSMutableArray alloc]init];
            
            for (UIImage *image in arrImages) {
                for (UploadImageInfo *uploadImageInfo in arrayResult) {
                    if (uploadImageInfo.bIsOk && (uploadImageInfo.preImage == image)) {
                        [arrUrls addObject:uploadImageInfo.upLoadUrl];
                        break;
                    }
                }
            }
            
            [self generateImageViewByUrls:arrUrls];
            [AlertManager dissmiss:processWindow];
        }];
    }
    else
    {
        [JDStatusBarNotification showWithStatus:@"图片格式错误" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
    }
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
            [self deleteArticle];
        }
    }
    else if(alertView.tag == 11)
    {
        if (buttonIndex == 1)
        {
            [self dismissAlertView];
            [self walletTradeByValue:1];
        }
    }
}

#pragma mark - TableView Logic

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_arrAttentions count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellTableIdentifier = @"RecommendCircleTableViewCell";
    RecommendCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    __block ArticlesObject *articlesObject = _arrAttentions[indexPath.row];
    
    if (cell == nil) {
        NSString *strContent = @"";
        
        if (articlesObject.content.length > 0) {
            strContent = articlesObject.cover_text;
        }
        else
        {
            if ([articlesObject.type isEqualToString:@"record"]) {
                strContent = articlesObject.record.mood;
            }
            else
            {
                for (int index = 0; index < articlesObject.article_segments.data.count; index++) {
                    
                    ArticleSegmentObject* segobj = articlesObject.article_segments.data[index];
                    
                    if([segobj.seg_type isEqualToString:@"TEXT"] && segobj.seg_content.length > 0) {
                        strContent = segobj.seg_content;
                    }
                }
            }
        }
        
        cell = [[RecommendCircleTableViewCell alloc]initWithReuseIdentifier:CellTableIdentifier WithContent:strContent];
    }
    
    if (cell.articlesObject != articlesObject) {
        __weak __typeof(self) weakSelf = self;
        __typeof__(cell) __weak thisCell = cell;
        
        cell.profileBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
            accountPreViewController.strUserId = articlesObject.authorInfo.userid;
            [strongSelf.navigationController pushViewController:accountPreViewController animated:YES];
        };
        
        cell.contentAtClickBlock = ^void(NSString *stLink)
        {
            __typeof(self) strongSelf = weakSelf;
            
            id processWin = [AlertManager showCommonProgress];
            
            [[SportForumAPI sharedInstance]userGetInfoByUserId:@"" NickName:stLink FinishedBlock:^(int errorCode, NSString* strDescErr, UserInfo *userInfo)
             {
                 [AlertManager dissmiss:processWin];
                 
                 if (errorCode != 0) {
                     [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                 }
                 else
                 {
                     AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
                     accountPreViewController.strUserId = userInfo.userid;
                     [strongSelf.navigationController pushViewController:accountPreViewController animated:YES];
                 }
             }];
        };
        
        cell.tutorBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            CGRect rect = strongSelf->_viewCommentBoard.frame;
            [strongSelf actionReplyTap:nil];
            
            if (rect.origin.y != strongSelf.view.frame.size.height) {
                [strongSelf->m_tableAttention setContentOffset:strongSelf->_fOffset animated:YES];
                [strongSelf hideCommentBoard];
            }
            
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
            chatMessageTableViewController.bNoSendAction = ([userInfo.actor isEqualToString:@"coach"] || [userInfo.userid isEqualToString:articlesObject.authorInfo.userid]) ? NO : YES;
            chatMessageTableViewController.strArticleId = articlesObject.article_id;
            [strongSelf.navigationController pushViewController:chatMessageTableViewController animated:YES];
        };
        
        cell.deleteBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            CGRect rect = strongSelf->_viewCommentBoard.frame;
            [strongSelf actionReplyTap:nil];
            
            if (rect.origin.y != strongSelf.view.frame.size.height) {
                [strongSelf->m_tableAttention setContentOffset:strongSelf->_fOffset animated:YES];
                [strongSelf hideCommentBoard];
            }
            
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
            
            if([articlesObject.type isEqualToString:@"pk"])
            {
                NSDate * datePublish = [NSDate dateWithTimeIntervalSince1970:articlesObject.time];
                NSTimeInterval  timeInterval = [datePublish timeIntervalSinceNow];
                
                if (timeInterval < 0) {
                    timeInterval = -timeInterval;
                }
                
                if (timeInterval/60 < 60) {
                    [JDStatusBarNotification showWithStatus:@"PK结果博文，发布1个小时后才能删除哦~" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                    return;
                }
            }
            
            strongSelf->_currentObject = articlesObject;
            
            strongSelf->_alertView = [[UIAlertView alloc] initWithTitle:@"删除帖子" message:@"要删除帖子吗？" delegate:strongSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            strongSelf->_alertView.tag = 10;
            [strongSelf->_alertView show];
        };
        
        cell.showMoreBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            CGRect rect = strongSelf->_viewCommentBoard.frame;
            [strongSelf actionReplyTap:nil];
            
            if (rect.origin.y != strongSelf.view.frame.size.height) {
                [strongSelf->m_tableAttention setContentOffset:strongSelf->_fOffset animated:YES];
                [strongSelf hideCommentBoard];
            }
            
            articlesObject.bExpand = !articlesObject.bExpand;
            [strongSelf->m_tableAttention beginUpdates];
            [strongSelf->m_tableAttention reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [strongSelf->m_tableAttention endUpdates];
        };
        
        cell.thumbMoreBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            CGRect rect = strongSelf->_viewCommentBoard.frame;
            [strongSelf actionReplyTap:nil];
            
            if (rect.origin.y != strongSelf.view.frame.size.height) {
                [strongSelf->m_tableAttention setContentOffset:strongSelf->_fOffset animated:YES];
                [strongSelf hideCommentBoard];
            }
            
            RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
            relatedPeoplesViewController.eRelatedType = e_related_people_thumb;
            relatedPeoplesViewController.strArticleId = articlesObject.article_id;
            [strongSelf.navigationController pushViewController:relatedPeoplesViewController animated:YES];
        };
        
        cell.previewPhotoBlock = ^(NSMutableArray *imgUrlArray, NSUInteger nIndex, BOOL bVideo)
        {
            __typeof(self) strongSelf = weakSelf;
            CGRect rect = strongSelf->_viewCommentBoard.frame;
            [strongSelf actionReplyTap:nil];
            
            if (rect.origin.y != strongSelf.view.frame.size.height) {
                [strongSelf->m_tableAttention setContentOffset:strongSelf->_fOffset animated:YES];
                [strongSelf hideCommentBoard];
            }
            
            if (bVideo) {
                for (int index = 0; index < articlesObject.article_segments.data.count; index++) {
                    ArticleSegmentObject* segobj = articlesObject.article_segments.data[index];
                    
                    if([segobj.seg_type isEqualToString:@"VIDEO"] && segobj.seg_content.length > 0) {
                        NSArray *list = [segobj.seg_content componentsSeparatedByString:@"###"];
                        [strongSelf onClickVideoPreView:list.lastObject];
                        break;
                    }
                }
            }
            else
            {
                [strongSelf onClickImageViewByIndex:nIndex UrlArr:imgUrlArray];
            }
        };
        
        cell.thumbClickBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            CGRect rect = strongSelf->_viewCommentBoard.frame;
            [strongSelf actionReplyTap:nil];
            
            if (rect.origin.y != strongSelf.view.frame.size.height) {
                [strongSelf->m_tableAttention setContentOffset:strongSelf->_fOffset animated:YES];
                [strongSelf hideCommentBoard];
            }
            
            [strongSelf actionThumb:articlesObject TabelCellIndexPath:indexPath];
        };
        
        cell.replyClickBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            
            CGRect rect = strongSelf->_viewCommentBoard.frame;
            [strongSelf actionReplyTap:nil];
            
            if (rect.origin.y != strongSelf.view.frame.size.height) {
                [strongSelf->m_tableAttention setContentOffset:strongSelf->_fOffset animated:YES];
                [strongSelf hideCommentBoard];
            }
            else
            {
                strongSelf->_currentObject = articlesObject;
                [strongSelf->_arrayCommentInfos removeAllObjects];
                [strongSelf->_swipeView reloadData];
                [strongSelf showCommentByArticleId:articlesObject.article_id];
                
                rect = [tableView convertRect:thisCell.lbSep2.frame fromView:thisCell];
                CGFloat fOffset = CGRectGetMaxY(rect) + COMMENT_BOARD_HEIGHT - CGRectGetHeight(tableView.frame);
                
                if (fOffset > 0) {
                    [tableView setContentOffset:CGPointMake(0.0, fOffset) animated:YES];
                }
            }
        };
        
        cell.rewardClickBlock = ^(void)
        {
            __typeof(self) strongSelf = weakSelf;
            CGRect rect = strongSelf->_viewCommentBoard.frame;
            [strongSelf actionReplyTap:nil];
            
            if (rect.origin.y != strongSelf.view.frame.size.height) {
                [strongSelf->m_tableAttention setContentOffset:strongSelf->_fOffset animated:YES];
                [strongSelf hideCommentBoard];
            }
            
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
            
            if ([articlesObject.relation isEqualToString:@"DEFRIEND"])
            {
                [JDStatusBarNotification showWithStatus:@"你已被拉黑，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                return;
            }
            
            if ([userInfo.userid isEqualToString:articlesObject.authorInfo.userid]) {
                RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
                relatedPeoplesViewController.eRelatedType = e_related_people_reward;
                relatedPeoplesViewController.strArticleId = articlesObject.article_id;
                [strongSelf.navigationController pushViewController:relatedPeoplesViewController animated:YES];
            }
            else
            {
                strongSelf->_currentObject = articlesObject;
                [strongSelf popRewardView];
            }
        };
        
        cell.contentViewClickBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            CGRect rect = strongSelf->_viewCommentBoard.frame;
            [strongSelf actionReplyTap:nil];
            
            if (rect.origin.y != strongSelf.view.frame.size.height) {
                [strongSelf->m_tableAttention setContentOffset:strongSelf->_fOffset animated:YES];
                [strongSelf hideCommentBoard];
            }
            
            if ([articlesObject.type isEqualToString:@"repost"]) {
                [strongSelf showCommonProgress];
                
                NSString *strArticleId = articlesObject.refer_article.length > 0 ? articlesObject.refer_article : articlesObject.article_id;
                
                [[SportForumAPI sharedInstance]articleGetByArticleId:strArticleId FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
                    [strongSelf hidenCommonProgress];
                    
                    if (strongSelf != nil) {
                        if (errorCode == 0) {
                            ContentWebViewController * contentWebViewController = [[ContentWebViewController alloc]init];
                            contentWebViewController.articlesObject = articlesObject;
                            [strongSelf.navigationController pushViewController:contentWebViewController animated:YES];
                        }
                        else
                        {
                            [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                        }
                    }
                }];
            }
            else
            {
                ContentWebViewController * contentWebViewController = [[ContentWebViewController alloc]init];
                contentWebViewController.articlesObject = articlesObject;
                [strongSelf.navigationController pushViewController:contentWebViewController animated:YES];
            }
        };
        
        cell.articlesObject = articlesObject;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

-(void)stopRefresh {
    if (_bUpHandleLoading) {
        _bUpHandleLoading = NO;
        [_PullDownRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:m_tableAttention];
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    TRSDialScrollView *dialView = (TRSDialScrollView*)[m_viewReward viewWithTag:11000];
    
    if(scrollView == dialView.scrollView)
    {
        [self setDialViewValue:dialView.currentValue ViewPick:m_viewReward UnitFormat:@" 金币"];
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
    
    if(y > (h + 50) && _bDownHandleLoading == NO)
    {
        [self tableBootomShow:YES];
        _bDownHandleLoading = YES;
        [self reloadDataWithFirstPageID:@"" LastPageId:_strLastPageId];
    }
    
    if (_bUpHandleLoading == NO)
    {
        [_PullDownRefreshView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    CGRect rect = _viewCommentBoard.frame;
    
    if (rect.origin.y != self.view.frame.size.height) {
        [m_tableAttention setContentOffset:_fOffset animated:YES];
        [self hideCommentBoard];
    }
    
    CGRect inputViewFrame = m_viewReply.frame;
    
    if (inputViewFrame.origin.y != self.view.bounds.size.height && _textViewInputViewType != XHInputViewTypeNormal) {
        [self layoutOtherMenuViewHiden:YES];
    }
    
    TRSDialScrollView *dialView = (TRSDialScrollView*)[m_viewReward viewWithTag:11000];
    
    if(scrollView == dialView.scrollView)
    {
        [self setDialViewValue:dialView.currentValue ViewPick:m_viewReward UnitFormat:@" 金币"];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_PullDownRefreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)upDragLoadData {
    // Get Data From Server
    [self showBottomIndicator:NO];
}

#pragma mark - EGORefreshTableHeaderDelegate
-(void)refreshComments {
    if (_reloading) {
        _reloading = NO;
        [_PullRightRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView*)[_swipeView currentSwipeView]];
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    if(view == _PullDownRefreshView)
    {
        _bUpHandleLoading = YES;
        _strFirstPageId = @"";
        [self performSelector:@selector(reloadArticlesData) withObject:nil afterDelay:0.2];
    }
    else
    {
        _reloading = YES;
        [self performSelector:@selector(refreshComments) withObject:nil afterDelay:1.0f];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    BOOL bRefresh = NO;
    
    if (view == _PullDownRefreshView) {
        bRefresh = _bUpHandleLoading;
    }
    else
    {
        bRefresh = _reloading;
    }
    
    return bRefresh;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    if (view == _PullDownRefreshView) {
        return [NSDate date];
    }
    
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

