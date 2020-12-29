//
//  ArticleViewController.m
//  SportForum
//
//  Created by zhengying on 6/12/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "ArticleViewController.h"
#import "UIImageView+WebCache.h"
#import "AccountPreViewController.h"
#import "RelatedPeoplesViewController.h"
#import "SportForumAPI.h"
#import "CSButton.h"
#import "TFHpple.h"
#import "MWPhotoBrowser.h"
#import "AppDelegate.h"
#import <CoreGraphics/CoreGraphics.h>

#import "AlertManager.h"
#import "XHMessageInputView.h"
#import "ImageEditViewController.h"
#import "CustomMenuViewController.h"
#import "ZYQAssetPickerController.h"
#import "SwipeView.h"
#import "WallCell.h"
#import "EGORefreshTableHeaderView.h"
#import "UIScrollView+XHkeyboardControl.h"
#import "ArticlePagesViewController.h"
#import "TRSDialScrollView.h"
#import "ChatMessageTableViewController.h"

#import "DXAlertView.h"
#import "RegexKitLite.h"
#import <MediaPlayer/MediaPlayer.h>

#define MAX_PUBLISH_PNG_COUNT 6
#define SWIPE_CELL_WEIGHT 120
#define COMMENT_BOARD_HEIGHT 158

@interface ArticleViewController ()<UIWebViewDelegate, MWPhotoBrowserDelegate, EGORefreshTableHeaderDelegate, SwipeViewDelegate, SwipeViewDataSource, XHMessageInputViewDelegate, UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate, UIScrollViewDelegate,  UINavigationControllerDelegate, UITextFieldDelegate>

@end

@implementation ArticleViewController {
    UIImageView* _imageViewProfile;
    UILabel* _lblTitle;
    UILabel* _lbPublishTime;
    UILabel *_lbSep;
    UILabel *_lbAge;
    UIView * _viewOperation;
    UIScrollView* _scrollView;
    UIImageView *_thubmersImgView[6];
    UIImageView *_sexTypeImageView;
    UIImageView *_imgViePhone;
    UIImageView *_imgVieCoach;
    UIImageView *_imgViewThumbAnimate;
    UIWebView *_webView;
    CSButton *_btnTutor;
    CSButton* _btnUserInfo;
    CSButton* _btnParentArticle;
    UIActivityIndicatorView* _activityIndicatorView;
    
    NSMutableArray *_imgConArray;
    NSMutableArray *_photos;
    
    BOOL _isVideo;
    BOOL _isLoadingFinished;
    NSString *_strHtmlContent;
    
    NSMutableArray *_photoAdds;
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _imgViewArray;
    NSMutableArray * _imgBtnArray;
    
    NSMutableDictionary *_replyDict;
    
    BOOL _bUpdatePhotos;
    
    EGORefreshTableHeaderView* _PullRightRefreshView;
    
    BOOL _reloading;
    
    UIView* _viewRecord;
    UIView* _viewScreenComment;
    UIView* _viewCommentBoard;
    UILabel* _lbReviewTitle;
    UILabel* _lbNoReview;
    CSButton* _btnReview;
    SwipeView* _swipeView;
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
    UIView *m_viewScreenReply;
    XHMessageInputView *m_viewReply;
    XHInputViewType _textViewInputViewType;
    
    CGFloat _keyboardViewHeight;
    CGFloat _previousTextViewContentHeight;
    
    ImageEditViewController* _imageEditViewController;
    CustomMenuViewController* _customMenuViewController;
    
    //Reward PickView
    UIView *m_viewReward;
    UIView * m_pickerView0;
    
    int m_nOffset;
    UITextField* m_textFiledReward;
    DXAlertView *m_rewardAlert;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView {
    [super loadView];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,
                                                                self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor clearColor];
    [_scrollView setAlwaysBounceHorizontal:NO];
    [_scrollView setAlwaysBounceVertical:YES];
    _scrollView.delegate = self;
    [self createAllObject];
}

#define cTopSapce 10.0
#define cToContentSpace 10.0
#define cHeaderHeight 80.0
#define cContentWidth [UIScreen mainScreen].bounds.size.width
#define cContentSpace 10.0

#define cProfileImage2TitleSpace 10.0

#define cFONT_TEXT [UIFont systemFontOfSize:12]


- (UIImage*) renderScrollViewToImage
{
    UIImage* image = nil;
   
    UIGraphicsBeginImageContextWithOptions(CGSizeMake([UIScreen screenWidth], _scrollView.contentSize.height + 20),NO,0.0f);
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
    
  /*
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, _scrollView.contentSize.height+ 40), NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [_scrollView.layer renderInContext:ctx];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    
    return image;
}

-(void)showRewardAnimate
{
    UIImageView *thumbImageView = (UIImageView*)[_viewOperation viewWithTag:15];
    _imgViewThumbAnimate.frame = thumbImageView.frame;
    _imgViewThumbAnimate.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame = _imgViewThumbAnimate.frame;
        frame.origin.y -= 30;
        _imgViewThumbAnimate.frame = frame;
    } completion:^(BOOL finished){
        _imgViewThumbAnimate.hidden = YES;
    }];

}

-(NSString*)replaceAtString:(NSString*)strSource
{
    NSString *strReturn = strSource;
    //NSArray *matchArray = [strSource componentsMatchedByRegex:@"@[^\\s]+\\s?"];
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
    
    if ([_articleObject.type isEqualToString:@"record"]) {
        if (_articleObject.record.mood.length > 0) {
            NSArray *firstSplit = [_articleObject.record.mood componentsSeparatedByString:@"\n"];
            
            for (NSString *strSplit in firstSplit) {
                if (strSplit.length > 0) {
                    [strBody appendString:[NSString stringWithFormat:@"<p>%@</p>", [self replaceAtString:strSplit]]];
                }
            }
        }
        
        for (NSUInteger nIndex = 0; nIndex < _articleObject.record.sport_pics.data.count; nIndex++) {
            [strBody appendString:[NSString stringWithFormat:@"<div class=\"divimg\"><img src=\"%@\" /></div>", _articleObject.record.sport_pics.data[nIndex]]];
        }
    }
    else
    {
        if (_articleObject.content > 0) {
            [strBody appendString:_articleObject.content];
        }
        else
        {
            for (int index = 0; index < _articleObject.article_segments.data.count; index++) {
                ArticleSegmentObject* segobj = _articleObject.article_segments.data[index];
                
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

-(void)createLayout:(ArticlesObject*)articleObject {
    
    if (articleObject == nil) {
        return;
    }
    
    [_imageViewProfile sd_setImageWithURL:[NSURL URLWithString:articleObject.authorInfo.profile_image] placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _lblTitle.text = articleObject.authorInfo.nikename;
    _lbSep.hidden = NO;
    
    [_sexTypeImageView setImage:[UIImage imageNamed:[articleObject.authorInfo.sex_type isEqualToString:sex_male] ? @"gender-male" : @"gender-female"]];
    
    _lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:articleObject.authorInfo.birthday];
    
    CGFloat fStartPoint = CGRectGetMaxX(_sexTypeImageView.frame) + 4;
    
    _imgViePhone.frame = CGRectMake(fStartPoint, CGRectGetMinY(_sexTypeImageView.frame) + 2, 8, 14);
    _imgViePhone.hidden = articleObject.authorInfo.phone_number.length > 0 ? NO : YES;
    
    if (!_imgViePhone.hidden) {
        fStartPoint = CGRectGetMaxX(_imgViePhone.frame) + 2;
    }
    
    _imgVieCoach.hidden = ([articleObject.authorInfo.actor isEqualToString:@"coach"]) ? NO : YES;
    _imgVieCoach.frame = CGRectMake(fStartPoint, CGRectGetMinY(_sexTypeImageView.frame) - 1, 20, 20);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:articleObject.time];
    NSString *strDate = [dateFormatter stringFromDate:date];
    _lbPublishTime.text = [NSString stringWithFormat:@"%@发布", strDate];
    
    if (articleObject.coach_review_count > 0) {
        _btnTutor.hidden = NO;
    }
    else
    {
        _btnTutor.hidden = YES;
    }
    
    if (articleObject.parent_article_id.length > 0) {
        _btnParentArticle.hidden = NO;
    }
    else
    {
        _btnParentArticle.hidden = YES;
    }
    
    //Load Html Content
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
    [_webView loadHTMLString:_strHtmlContent baseURL:nil];
}

-(void)loadProcessShow:(BOOL)blShow {
    if (blShow) {
        [_activityIndicatorView startAnimating];
    } else {
        [_activityIndicatorView stopAnimating];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    m_nOffset = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version >= 5.0)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    
    [self createCommentBoard];
    [self createReplyView];
    //[self createRewardView];
    
    _imgUrlArray = [[NSMutableArray alloc]init];
    _imgViewArray = [[NSMutableArray alloc]init];
    _imgBtnArray = [[NSMutableArray alloc]init];
    _photoAdds = [[NSMutableArray alloc]init];
    _replyDict = [[NSMutableDictionary alloc]init];
    _bUpdatePhotos = NO;
    _keyboardViewHeight = 216;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshImageViews];

    // 设置键盘通知或者手势控制键盘消失
    [_scrollView setupPanGestureControlKeyboardHide:YES];
    
    // KVO 检查contentSize
    [m_viewReply.inputTextView addObserver:self
                                forKeyPath:@"contentSize"
                                   options:NSKeyValueObservingOptionNew
                                   context:nil];
    
    [m_viewReply addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 取消输入框
    [m_viewReply.inputTextView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [self hidenCommonProgress];
    
    // remove键盘通知或者手势
    [_scrollView disSetupPanGestureControlKeyboardHide:YES];
    
    // remove KVO
    [m_viewReply.inputTextView removeObserver:self forKeyPath:@"contentSize"];
    [m_viewReply removeObserver:self forKeyPath:@"frame"];
    
    [super viewWillDisappear:animated];
}

-(void)setArticleObject:(ArticlesObject *)articleObject
{
    _articleObject = articleObject;
    
    if (articleObject.content.length > 0 || [articleObject.article_segments.data count] > 0 || [articleObject.type isEqualToString:@"record"]) {
        [self createLayout:articleObject];
    }
}

- (UIViewController*)superViewController {
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[ArticlePagesViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"ArticleViewController dealloc called!");
    [_viewScreenComment removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)showCommonProgress{
    m_processWindow = [AlertManager showCommonProgress];
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:m_processWindow];
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
    
    if ([_articleObject.relation isEqualToString:@"DEFRIEND"])
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
    //NSArray *matchArray = [m_viewReply.inputTextView.text componentsMatchedByRegex:@"(?<=@)[^\\s]+\\s?"];
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
    
    [[SportForumAPI sharedInstance]articleNewByParArticleId:_articleObject.article_id
                                             ArticleSegment:articleSegments
                                                 ArticleTag:[NSArray arrayWithObject:[CommonFunction ConvertArticleTagTypeToString:eArticleType]] Type:@""  AtNameList:arrAtList
                                              FinishedBlock:^(int errorCode, NSString* strDescErr, ExpEffect* expEffect) {
                                                  [self hidenCommonProgress];
                                                  
                                                  if (errorCode == RSA_ERROR_NONE) {
                                                      UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                                                      
                                                      [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                                                       {
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", @(YES), @"UpdateArticle",nil]];
                                                       }];
                                                      
                                                      [_replyDict removeObjectForKey:_articleObject.article_id];
                                                      _articleObject.sub_article_count++;
                                                      
                                                      UILabel *lbReplyCount = (UILabel*)[_viewOperation viewWithTag:19];
                                                      lbReplyCount.text = [NSString stringWithFormat:@"%lu", _articleObject.sub_article_count];
                                                  } else {
                                                      [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                  }
                                              }];
}

#pragma mark - Controls Logic

-(void)createAllObject
{
    if (_imageViewProfile == nil) {
        _imageViewProfile = [[UIImageView alloc]initWithFrame:CGRectMake(5, cTopSapce, 60, 60)];
        _imageViewProfile.layer.cornerRadius = 10.0;
        _imageViewProfile.layer.masksToBounds = YES;
        [_scrollView addSubview:_imageViewProfile];
    }
    
    if(_lblTitle == nil) {
        _lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageViewProfile.frame) + cProfileImage2TitleSpace, CGRectGetMinY(_imageViewProfile.frame), 200, 20)];
        _lblTitle.backgroundColor = [UIColor clearColor];
        _lblTitle.font = [UIFont boldSystemFontOfSize:12];
        _lblTitle.textColor = [UIColor blackColor];
        [_scrollView addSubview:_lblTitle];
    }
    
    if (_sexTypeImageView == nil) {
        _sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblTitle.frame), CGRectGetMaxY(_lblTitle.frame) + 5, 40, 18)];
        _sexTypeImageView.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:_sexTypeImageView];
    }
    
    if (_lbAge == nil) {
        _lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_sexTypeImageView.frame) - 25, CGRectGetMinY(_sexTypeImageView.frame) + 2, 20, 10)];
        _lbAge.backgroundColor = [UIColor clearColor];
        _lbAge.textColor = [UIColor whiteColor];
        _lbAge.font = [UIFont systemFontOfSize:10];
        _lbAge.textAlignment = NSTextAlignmentRight;
        [_scrollView addSubview:_lbAge];
    }
    
    if (_imgViePhone == nil) {
        _imgViePhone = [[UIImageView alloc]init];
        [_imgViePhone setImage:[UIImage imageNamed:@"phone-verified-small"]];
        _imgViePhone.backgroundColor = [UIColor clearColor];
        _imgViePhone.hidden = YES;
        [_scrollView addSubview:_imgViePhone];
    }
    
    if (_imgVieCoach == nil) {
        _imgVieCoach = [[UIImageView alloc]init];
        [_imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
        _imgVieCoach.backgroundColor = [UIColor clearColor];
        _imgVieCoach.hidden = YES;
        [_scrollView addSubview:_imgVieCoach];
    }

    if (_lbPublishTime == nil) {
        _lbPublishTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_lblTitle.frame), CGRectGetMaxY(_sexTypeImageView.frame) + 5, 200, 20)];
        _lbPublishTime.backgroundColor = [UIColor clearColor];
        _lbPublishTime.font = [UIFont systemFontOfSize:10];
        _lbPublishTime.textColor = [UIColor darkGrayColor];
        [_scrollView addSubview:_lbPublishTime];
    }
    
    if (_btnParentArticle == nil) {
        _btnParentArticle = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnParentArticle.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) - 65, CGRectGetMinY(_imageViewProfile.frame) - 10, 55, 40);
        _btnParentArticle.backgroundColor = [UIColor clearColor];
        [_btnParentArticle setTitleColor:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_btnParentArticle setTitle:@"回到原帖" forState:UIControlStateNormal];
        _btnParentArticle.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        _btnParentArticle.hidden = YES;
        [_scrollView addSubview:_btnParentArticle];
        [_scrollView bringSubviewToFront:_btnParentArticle];
        
        __weak __typeof(self) weakself = self;
        
        _btnParentArticle.actionBlock = ^(void){
            __typeof(self) strongself = weakself;
            [strongself handleBackToParentArticle];
        };
    }
    
    if (_btnTutor == nil) {
        _btnTutor = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnTutor.frame = CGRectMake(CGRectGetWidth(_scrollView.frame) - 32, CGRectGetMinY(_lbPublishTime.frame), 27, 17);
        _btnTutor.backgroundColor = [UIColor clearColor];
        [_btnTutor setImage:[UIImage imageNamed:@"blog-tutor"] forState:UIControlStateNormal];
        _btnTutor.hidden = YES;
        [_scrollView addSubview:_btnTutor];
        [_scrollView bringSubviewToFront:_btnTutor];
        
        __weak __typeof(self) weakself = self;
        
        _btnTutor.actionBlock = ^(void){
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
            chatMessageTableViewController.bNoSendAction = ([userInfo.actor isEqualToString:@"coach"] || [userInfo.userid isEqualToString:strongself->_articleObject.authorInfo.userid]) ? NO : YES;
            chatMessageTableViewController.strArticleId = strongself->_articleObject.article_id;
            UIViewController *viewController = [strongself superViewController];
            [viewController.navigationController pushViewController:chatMessageTableViewController animated:YES];
        };
    }
    
    if (_lbSep == nil) {
        _lbSep = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageViewProfile.frame) + 10, CGRectGetWidth(self.view.frame), 0.5)];
        _lbSep.backgroundColor = [UIColor lightGrayColor];
        _lbSep.hidden = YES;
        [_scrollView addSubview:_lbSep];
    }
    
    if (_btnUserInfo == nil) {
        _btnUserInfo = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnUserInfo.frame = CGRectMake(5, cTopSapce, 120, 60);
        _btnUserInfo.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:_btnUserInfo];
        [_scrollView bringSubviewToFront:_btnUserInfo];
        
        __weak __typeof(self) weakself = self;
        
        _btnUserInfo.actionBlock = ^(void){
            __typeof(self) strongself = weakself;
            AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
            accountPreViewController.strUserId = strongself.articleObject.authorInfo.userid;
            UIViewController *viewController = [strongself superViewController];
            [viewController.navigationController pushViewController:accountPreViewController animated:YES];
        };
    }
    
    if (_webView == nil) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_lbSep.frame), cContentWidth - 10, 1)];
        _webView.scrollView.scrollEnabled = NO;
        [_webView setScalesPageToFit:NO];
        _webView.delegate = self;
        _webView.backgroundColor = APP_MAIN_BG_COLOR;
        _webView.opaque = NO;
        [_scrollView addSubview:_webView];
    }
    
    if (_viewRecord == nil) {
        _viewRecord = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_webView.frame), cContentWidth - 10, 50)];
        _viewRecord.backgroundColor = [UIColor clearColor];
        _viewRecord.hidden = YES;
        [_scrollView addSubview:_viewRecord];
        
        [self generateRecordView];
    }
    
    if (_viewOperation == nil) {
        _viewOperation = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_webView.frame), cContentWidth - 10, 50)];
        _viewOperation.backgroundColor = [UIColor clearColor];
        _viewOperation.hidden = YES;
        [_scrollView addSubview:_viewOperation];
        
        [self generateOperationView];
    }
    
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _activityIndicatorView.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
        _activityIndicatorView.center = _scrollView.center;
        _activityIndicatorView.hidesWhenStopped = YES;
        [_scrollView addSubview:_activityIndicatorView];
    }
}

-(void)handleBackToParentArticle
{
    __weak __typeof(self) weakSelf = self;
    id processWin = [AlertManager showCommonProgress];
    
    [[SportForumAPI sharedInstance]articleGetByArticleId:_articleObject.parent_article_id FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
        __typeof(self) strongSelf = weakSelf;
        [AlertManager dissmiss:processWin];
        
        if (strongSelf != nil) {
            if (errorCode == 0) {
                
                ArticlePagesViewController* articlePagesViewController = [[ArticlePagesViewController alloc] init];
                articlePagesViewController.currentIndex = 0;
                articlePagesViewController.arrayArticleInfos = [NSMutableArray arrayWithObject:articlesObject];
            
                UIViewController *viewController = [strongSelf superViewController];
                [viewController.navigationController popViewControllerAnimated:NO];
                
                AppDelegate* delegate = [UIApplication sharedApplication].delegate;
                [delegate.mainNavigationController pushViewController:articlePagesViewController animated:YES];
            }
            else
            {
                [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
            }
        }
    }];
}

-(void)generateOperationView
{
    UILabel *lbSep0 = [[UILabel alloc]init];
    lbSep0.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    lbSep0.tag = 10;
    [_viewOperation addSubview:lbSep0];
    
    UILabel *lbThumbTitle = [[UILabel alloc]init];
    lbThumbTitle.backgroundColor = [UIColor clearColor];
    lbThumbTitle.textColor = [UIColor lightGrayColor];
    lbThumbTitle.font = [UIFont boldSystemFontOfSize:12];
    lbThumbTitle.textAlignment = NSTextAlignmentLeft;
    lbThumbTitle.tag = 11;
    [_viewOperation addSubview:lbThumbTitle];
    
    for (NSUInteger i = 0; i < 6; i++) {
        _thubmersImgView[i] = [[UIImageView alloc]init];
        _thubmersImgView[i].layer.cornerRadius = 5.0;
        _thubmersImgView[i].layer.masksToBounds = YES;
        [_viewOperation addSubview:_thubmersImgView[i]];
    }
    
    UIImageView *thumbMoreImaView = [[UIImageView alloc]init];
    thumbMoreImaView.image = [UIImage imageNamed:@"arrow-1"];
    thumbMoreImaView.tag = 12;
    [_viewOperation addSubview:thumbMoreImaView];
    
    CSButton *btnThumbMore = [CSButton buttonWithType:UIButtonTypeCustom];
    btnThumbMore.backgroundColor = [UIColor clearColor];
    btnThumbMore.tag = 13;
    [_viewOperation addSubview:btnThumbMore];
    [_viewOperation bringSubviewToFront:btnThumbMore];
    
    __weak __typeof(self) weakself = self;
    
    btnThumbMore.actionBlock = ^(void){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
            relatedPeoplesViewController.eRelatedType = e_related_people_thumb;
            relatedPeoplesViewController.strArticleId = strongself->_articleObject.article_id;
            UIViewController *viewController = [strongself superViewController];
            [viewController.navigationController pushViewController:relatedPeoplesViewController animated:YES];
        }
    };
    
    UILabel *lbSep1 = [[UILabel alloc]init];
    lbSep1.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    lbSep1.tag = 14;
    [_viewOperation addSubview:lbSep1];
    
    UIImageView *thumbImageView = [[UIImageView alloc]init];
    thumbImageView.image = [UIImage imageNamed:@"blog-heart-1"];
    thumbImageView.tag = 15;
    [_viewOperation addSubview:thumbImageView];
    
    _imgViewThumbAnimate = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    _imgViewThumbAnimate.image = [UIImage imageNamed:@"blog-heart-2"];
    _imgViewThumbAnimate.hidden = YES;
    [_viewOperation addSubview:_imgViewThumbAnimate];
    
    UILabel *lbThumbCount = [[UILabel alloc]init];
    lbThumbCount.backgroundColor = [UIColor clearColor];
    lbThumbCount.textColor = [UIColor lightGrayColor];
    lbThumbCount.font = [UIFont boldSystemFontOfSize:14];
    lbThumbCount.textAlignment = NSTextAlignmentLeft;
    lbThumbCount.tag = 16;
    [_viewOperation addSubview:lbThumbCount];
    
    CSButton *btnThumb = [CSButton buttonWithType:UIButtonTypeCustom];
    btnThumb.backgroundColor = [UIColor clearColor];
    btnThumb.tag = 17;
    btnThumb.actionBlock = _thumbBlock;
    [_viewOperation addSubview:btnThumb];
    [_viewOperation bringSubviewToFront:btnThumb];
    
    UIImageView *replyImageView = [[UIImageView alloc]init];
    replyImageView.image = [UIImage imageNamed:@"blog-reply"];
    replyImageView.tag = 18;
    [_viewOperation addSubview:replyImageView];
    
    UILabel *lbReplyCount = [[UILabel alloc]init];
    lbReplyCount.backgroundColor = [UIColor clearColor];
    lbReplyCount.textColor = [UIColor lightGrayColor];
    lbReplyCount.font = [UIFont boldSystemFontOfSize:14];
    lbReplyCount.textAlignment = NSTextAlignmentLeft;
    lbReplyCount.tag = 19;
    [_viewOperation addSubview:lbReplyCount];
    
    CSButton *btnReply = [CSButton buttonWithType:UIButtonTypeCustom];
    btnReply.backgroundColor = [UIColor clearColor];
    btnReply.tag = 20;
    [_viewOperation addSubview:btnReply];
    [_viewOperation bringSubviewToFront:btnReply];
    
    btnReply.actionBlock = ^(void) {
        __typeof(self) strongSelf = weakself;
        [strongSelf->_arrayCommentInfos removeAllObjects];
        [strongSelf->_swipeView reloadData];
        [strongSelf showCommentByArticleId:strongSelf.articleObject.article_id];
    };
    
    UIImageView *rewardImageView = [[UIImageView alloc]init];
    rewardImageView.image = [UIImage imageNamed:@"blog-money"];
    rewardImageView.tag = 21;
    [_viewOperation addSubview:rewardImageView];
    
    UILabel *lbRewardCount = [[UILabel alloc]init];
    lbRewardCount.backgroundColor = [UIColor clearColor];
    lbRewardCount.textColor = [UIColor lightGrayColor];
    lbRewardCount.font = [UIFont boldSystemFontOfSize:14];
    lbRewardCount.textAlignment = NSTextAlignmentLeft;
    lbRewardCount.tag = 22;
    [_viewOperation addSubview:lbRewardCount];
    
    CSButton *btnReward = [CSButton buttonWithType:UIButtonTypeCustom];
    btnReward.backgroundColor = [UIColor clearColor];
    btnReward.tag = 23;
    [_viewOperation addSubview:btnReward];
    [_viewOperation bringSubviewToFront:btnReward];
    
    btnReward.actionBlock = ^(void) {
        __typeof(self) strongSelf = weakself;
        UserInfo *accountInfo = [ApplicationContext sharedInstance].accountInfo;
        
        if (accountInfo != nil) {
            if (accountInfo.ban_time > 0) {
                [JDStatusBarNotification showWithStatus:@"用户已被禁言，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                return;
            }
            else if(accountInfo.ban_time < 0)
            {
                [JDStatusBarNotification showWithStatus:@"用户已进入黑名单，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                return;
            }
        }
        
        if ([strongSelf->_articleObject.relation isEqualToString:@"DEFRIEND"])
        {
            [JDStatusBarNotification showWithStatus:@"你已被拉黑，无法完成本次操作。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }

        if ([accountInfo.userid isEqualToString:strongSelf->_articleObject.authorInfo.userid]) {
            RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
            relatedPeoplesViewController.eRelatedType = e_related_people_reward;
            relatedPeoplesViewController.strArticleId = strongSelf->_articleObject.article_id;
            
            UIViewController *viewController = [strongSelf superViewController];
            [viewController.navigationController pushViewController:relatedPeoplesViewController animated:YES];
        }
        else
        {
            [strongSelf popRewardView];
        }
    };
    
    UIImageView *shareImageView = [[UIImageView alloc]init];
    shareImageView.image = [UIImage imageNamed:@"blog-share"];
    shareImageView.tag = 24;
    [_viewOperation addSubview:shareImageView];
    
    CSButton *btnShare = [CSButton buttonWithType:UIButtonTypeCustom];
    btnShare.backgroundColor = [UIColor clearColor];
    btnShare.actionBlock = _shareBlock;
    btnShare.tag = 25;
    [_viewOperation addSubview:btnShare];
    [_viewOperation bringSubviewToFront:btnShare];
}

-(void)updateOperationView
{
    UILabel *lbSep0 = (UILabel*)[_viewOperation viewWithTag:10];
    UILabel *lbThumbTitle = (UILabel*)[_viewOperation viewWithTag:11];
    UIImageView *thumbMoreImaView = (UIImageView*)[_viewOperation viewWithTag:12];
    CSButton *btnThumbMore = (CSButton*)[_viewOperation viewWithTag:13];
    UILabel *lbSep1 = (UILabel*)[_viewOperation viewWithTag:14];
    UIImageView *thumbImageView = (UIImageView*)[_viewOperation viewWithTag:15];
    UILabel *lbThumbCount = (UILabel*)[_viewOperation viewWithTag:16];
    CSButton *btnThumb = (CSButton*)[_viewOperation viewWithTag:17];
    UIImageView *replyImageView = (UIImageView*)[_viewOperation viewWithTag:18];
    UILabel *lbReplyCount = (UILabel*)[_viewOperation viewWithTag:19];
    CSButton *btnReply = (CSButton*)[_viewOperation viewWithTag:20];
    UIImageView *rewardImageView = (UIImageView*)[_viewOperation viewWithTag:21];
    UILabel *lbRewardCount = (UILabel*)[_viewOperation viewWithTag:22];
    CSButton *btnReward = (CSButton*)[_viewOperation viewWithTag:23];
    UIImageView *shareImageView = (UIImageView*)[_viewOperation viewWithTag:24];
    CSButton *btnShare = (CSButton*)[_viewOperation viewWithTag:25];
    
    btnThumb.hidden = NO;
    btnReply.hidden = NO;
    btnReward.hidden = NO;
    btnShare.hidden = NO;
    
    lbSep0.frame = CGRectMake(0, 0, CGRectGetWidth(_viewOperation.frame), 1);
    NSUInteger nCount = _articleObject.thumb_users.data.count;
    
    CGRect rect = lbSep0.frame;
    
    if (nCount > 0)
    {
        lbThumbTitle.hidden = NO;
        lbThumbTitle.text = [NSString stringWithFormat:@"%lu个人赞过", nCount];
        lbThumbTitle.frame = CGRectMake(5, CGRectGetMaxY(lbSep0.frame) + 5, CGRectGetWidth(_viewOperation.frame) - 10, 20);
        
        NSUInteger nPosition = CGRectGetMinX(lbThumbTitle.frame);
        
        for (NSUInteger i = 0; i < MIN(6, nCount) ; i++) {
            _thubmersImgView[i].frame = CGRectMake(nPosition + i * 55, CGRectGetMaxY(lbThumbTitle.frame) + 5, 45, 45);
            _thubmersImgView[i].hidden = NO;
            [_thubmersImgView[i] sd_setImageWithURL:[NSURL URLWithString:_articleObject.thumb_users.data[i]]
                                   placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        }
        
        for(NSUInteger i = MIN(6, nCount); i < 6; i++)
        {
            _thubmersImgView[i].hidden = YES;
        }
        
        btnThumbMore.hidden = NO;
        btnThumbMore.frame = CGRectMake(0, CGRectGetMinY(lbThumbTitle.frame), CGRectGetWidth(_viewOperation.frame), 70);
        
        thumbMoreImaView.hidden = (nCount > 6 ? NO : YES);
        thumbMoreImaView.frame = CGRectMake(CGRectGetWidth(_viewOperation.frame) - 18, CGRectGetMidY(_thubmersImgView[0].frame) - 8, 8, 16);
        
        lbSep1.hidden = NO;
        lbSep1.frame = CGRectMake(0, CGRectGetMaxY(_thubmersImgView[0].frame) + 10, CGRectGetWidth(_viewOperation.frame), 1);
        rect = lbSep1.frame;
    }
    else
    {
        lbThumbTitle.hidden = YES;
        
        for(NSUInteger i = 0; i < 6; i++)
        {
            _thubmersImgView[i].hidden = YES;
        }
        
        btnThumbMore.hidden = YES;
        thumbMoreImaView.hidden = YES;
        lbSep1.hidden = YES;
    }
    
    thumbImageView.frame = CGRectMake(5, CGRectGetMaxY(rect) + 10, 20, 20);
    [thumbImageView setImage:[UIImage imageNamed:_articleObject.isThumbed ? @"blog-heart-2" : @"blog-heart-1"]];
    lbThumbCount.text = [NSString stringWithFormat:@"%lu", nCount];
    lbThumbCount.frame = CGRectMake(CGRectGetMaxX(thumbImageView.frame) + 5, CGRectGetMinY(thumbImageView.frame), 60, 20);
    btnThumb.frame = CGRectMake(5, CGRectGetMaxY(rect), 85, 40);
    
    replyImageView.frame = CGRectMake(CGRectGetMaxX(lbThumbCount.frame), CGRectGetMinY(thumbImageView.frame), 20, 20);
    lbReplyCount.text = [NSString stringWithFormat:@"%lu", _articleObject.sub_article_count];
    lbReplyCount.frame = CGRectMake(CGRectGetMaxX(replyImageView.frame) + 5, CGRectGetMinY(replyImageView.frame), 60, 20);
    btnReply.frame = CGRectMake(CGRectGetMinX(replyImageView.frame), CGRectGetMaxY(rect), 85, 40);
    
    rewardImageView.frame = CGRectMake(CGRectGetMaxX(lbReplyCount.frame), CGRectGetMinY(thumbImageView.frame), 20, 20);
    lbRewardCount.text = [NSString stringWithFormat:@"%lld",  _articleObject.reward_total / 100000000];
    lbRewardCount.frame = CGRectMake(CGRectGetMaxX(rewardImageView.frame) + 5, CGRectGetMinY(rewardImageView.frame), 60, 20);
    btnReward.frame = CGRectMake(CGRectGetMinX(rewardImageView.frame), CGRectGetMaxY(rect), 85, 40);
    
    shareImageView.frame = CGRectMake(CGRectGetMaxX(lbRewardCount.frame), CGRectGetMinY(thumbImageView.frame), 20, 20);
    btnShare.frame = CGRectMake(CGRectGetMinX(shareImageView.frame), CGRectGetMaxY(rect), 75, 40);
    
//    if (_articleObject.isThumbed) {
//        btnThumb.hidden = YES;
//    }
    
    CGRect rectRecorcd = CGRectZero;
    CGRect rectWebView = _webView.frame;
    
    if([_articleObject.type isEqualToString:@"record"])
    {
        rectRecorcd = _viewRecord.frame;
    }
    
    CGRect frame = _viewOperation.frame;
    frame.size.height = CGRectGetMaxY(btnThumb.frame);

    if (rectWebView.size.height + frame.size.height + rectRecorcd.size.height < CGRectGetHeight(_scrollView.frame) - CGRectGetMaxY(_lbSep.frame)) {
        frame.origin.y = CGRectGetHeight(_scrollView.frame) - frame.size.height;
    }
    else
    {
        frame.origin.y = [_articleObject.type isEqualToString:@"record"] ? CGRectGetMaxY(rectRecorcd) : CGRectGetMaxY(_webView.frame);
    }
    
    _viewOperation.frame = frame;
    _viewOperation.hidden = NO;
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width, CGRectGetMaxY(_viewOperation.frame));
    
    if (_bRewardAction) {
        _bRewardAction = NO;
        [self showRewardAnimate];
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
    lbSportTitle.text = @"运动数据状态：";
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
    imgViewCal.frame = CGRectMake(CGRectGetMaxX(lbSportSpeed.frame), CGRectGetMaxY(imgViewDate.frame) + 5, 20, 20);
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
    lbRefused.tag = 20015;
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
    UILabel *lbRefused = (UILabel*)[_viewRecord viewWithTag:20015];
    
    lbSportDistance.text = [NSString stringWithFormat:@"距离：%.2f km", _articleObject.record.distance / 1000.00];
    lbSportDuration.text = [NSString stringWithFormat:@"持续时间：%ld分钟", _articleObject.record.duration / 60];
    
    NSInteger nSpeedSet = _articleObject.record.duration / (_articleObject.record.distance / 1000.00);
    lbSportSpeedSet.text = [NSString stringWithFormat:@"%ld' %ld'' km", nSpeedSet / 60,   nSpeedSet % 60];
    
    NSDate * beginDay = [NSDate dateWithTimeIntervalSince1970:_articleObject.record.begin_time];
    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:beginDay];
    lbSportDate.text = [NSString stringWithFormat:@"%02ld/%02ld/%04ld %.2ld:%.2ld", [comps month], [comps day], [comps year], [comps hour], [comps minute]];
    lbSportSpeed.text = [NSString stringWithFormat:@"%.2f km/h", (_articleObject.record.distance / 1000.00) / (_articleObject.record.duration / 3600.00)];
    lbSportCal.text = [NSString stringWithFormat:@"%.0f 卡", _articleObject.record.weight * _articleObject.record.distance / 800.0]; //跑步热量（kcal）＝体重（kg）×运动时间（小时）×指数K(指数K＝30÷速度（分钟/400米)
    
    CGRect rectPosition = lbSportCal.frame;
    imgViewHeatRate.hidden = YES;
    lbSportHeatRate.hidden = YES;
    lbRefused.hidden = YES;
    
    if (_articleObject.record.heart_rate > 0) {
        imgViewHeatRate.hidden = NO;
        lbSportHeatRate.hidden = NO;
        lbSportHeatRate.text = [NSString stringWithFormat:@"%ld 次/分", _articleObject.record.heart_rate];
        rectPosition = imgViewHeatRate.frame;
    }
    
    lbSportSource.hidden = YES;
    
    if (_articleObject.record.source.length > 0) {
        lbSportSource.text = [NSString stringWithFormat:@"数据来源：%@", _articleObject.record.source];
        lbSportSource.hidden = NO;
        lbSportSource.frame = CGRectMake(CGRectGetMinX(lbSportSource.frame), CGRectGetMaxY(rectPosition) + 5, 310 - 5 - CGRectGetMinX(lbSportSource.frame), 20);
        rectPosition = lbSportSource.frame;
    }
    
    if ([_articleObject.authorInfo.userid isEqualToString:[[ApplicationContext sharedInstance] accountInfo].userid] && [_articleObject.type isEqualToString:@"record"])
    {
        imgViewAuth.hidden = NO;
        lbSportAuth.hidden = NO;
        lbSportLock.hidden = NO;
        imgViewLock.hidden = NO;
        
        NSString *strStatus;
        UIImage *img = nil;
        
        switch ([CommonFunction ConvertStringToTaskStatusType:_articleObject.record.status]) {
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
        
        lbSportLock.text = _articleObject.isPublic ? @"所有人可见" : @"仅自己可见";
        lbSportLock.frame = CGRectMake(310 - 75, CGRectGetMinY(imgViewAuth.frame), 70, 20);
        
        [imgViewLock setImage:[UIImage imageNamed:_articleObject.isPublic ? @"blog-public" : @"blog-private"]];
        imgViewLock.frame = CGRectMake(310 - 75 - 23, CGRectGetMinY(imgViewAuth.frame) + 2, 17, 17);
        
        rectPosition = imgViewAuth.frame;
        
        if ([CommonFunction ConvertStringToTaskStatusType:_articleObject.record.status] == e_task_unfinish) {
            lbRefused.hidden = NO;
            lbRefused.text = [NSString stringWithFormat:@"审核未通过原因：%@", _articleObject.record.result.length > 0 ? _articleObject.record.result : @"非常抱歉，您的任务审核未通过。"];
            
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
    frame.origin.y = CGRectGetMaxY(_webView.frame);
    
    _viewRecord.frame = frame;
    _viewRecord.hidden = NO;
}

- (UIView *)shareMenuView {
    if (!m_viewShareMenu) {
        UIView *shareMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(m_viewScreenReply.frame), CGRectGetWidth(m_viewScreenReply.frame), _keyboardViewHeight)];
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
        [m_viewScreenReply addSubview:m_viewShareMenu];
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
            
            UIView *viewTap = [strongSelf->m_viewScreenReply viewWithTag:101];
            viewTap.frame = CGRectMake(0, 0, CGRectGetWidth(strongSelf->m_viewScreenReply.frame), CGRectGetMinY(strongSelf->m_viewReply.frame));
        };
        
        _scrollView.keyboardDidScrollToPoint = ^(CGPoint point) {
            __typeof(self) strongSelf = weakSelf;
            if (strongSelf->_textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        _scrollView.keyboardWillSnapBackToPoint = ^(CGPoint point) {
            __typeof(self) strongSelf = weakSelf;
            if (strongSelf->_textViewInputViewType == XHInputViewTypeText)
                AnimationForMessageInputViewAtPoint(point);
        };
        
        _scrollView.keyboardWillBeDismissed = ^() {
            __typeof(self) strongSelf = weakSelf;
            CGRect inputViewFrame = strongSelf->m_viewReply.frame;
            inputViewFrame.origin.y = strongSelf.view.bounds.size.height;
            strongSelf->m_viewReply.frame = inputViewFrame;
            
            UIView *viewTap = [strongSelf->m_viewScreenReply viewWithTag:101];
            viewTap.frame = CGRectMake(0, 0, CGRectGetWidth(strongSelf->m_viewScreenReply.frame), CGRectGetMinY(strongSelf->m_viewReply.frame));
        };
    }
    
    // block回调键盘通知

    _scrollView.keyboardWillChange = ^(CGRect keyboardRect, UIViewAnimationOptions options, double duration, BOOL showKeyborad) {
        __typeof(self) strongSelf = weakSelf;
        if (strongSelf->_textViewInputViewType == XHInputViewTypeText) {
            [UIView animateWithDuration:duration
                                  delay:0.0
                                options:options
                             animations:^{
                                 CGFloat keyboardY = [strongSelf->m_viewScreenReply convertRect:keyboardRect fromView:nil].origin.y;
                                 
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
                                 
                                 UIView *viewTap = [strongSelf->m_viewScreenReply viewWithTag:101];
                                 viewTap.frame = CGRectMake(0, 0, CGRectGetWidth(strongSelf->m_viewScreenReply.frame), CGRectGetMinY(strongSelf->m_viewReply.frame));
                                 
                            }
                             completion:nil];
        }
    };
    
    _scrollView.keyboardDidChange = ^(BOOL didShowed) {
        __typeof(self) strongSelf = weakSelf;
        
        if ([strongSelf->m_viewReply.inputTextView isFirstResponder]) {
            if (didShowed) {
                if (strongSelf->_textViewInputViewType == XHInputViewTypeText) {
                    strongSelf.shareMenuView.alpha = 0.0;
                }
            }
        }
    };
    
    _scrollView.keyboardDidHide = ^() {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->m_viewReply.inputTextView resignFirstResponder];
    };

    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    CGRect inputFrame = CGRectMake(0.0f,
                                   delegate.mainNavigationController.view.frame.size.height,
                                   delegate.mainNavigationController.view.frame.size.width,
                                   45.0f);
    
    m_viewReply = [[XHMessageInputView alloc] initWithFrame:inputFrame];
    m_viewReply.allowsSendFace = NO;
    m_viewReply.allowsSendVoice = NO;
    m_viewReply.allowsSendMultiMedia = YES;
    m_viewReply.delegate = self;
    m_viewReply.messageInputViewStyle = XHMessageInputViewStyleFlat;
    
    m_viewScreenReply = [[UIView alloc]initWithFrame:CGRectMake(0, 0, delegate.mainNavigationController.view.frame.size.width, delegate.mainNavigationController.view.frame.size.height)];
    m_viewScreenReply.backgroundColor = [UIColor clearColor];
    [m_viewScreenReply addSubview:m_viewReply];
    
    UIView *viewTap = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(m_viewScreenReply.frame), CGRectGetMinY(m_viewReply.frame))];
    viewTap.backgroundColor = [UIColor clearColor];
    viewTap.tag = 101;
    [m_viewScreenReply addSubview:viewTap];
    
    m_viewReply.inputTextView.placeHolder = @"评论";
    UIImage *image = [UIImage imageNamed:@"tool-bg-1"];
    m_viewReply.layer.contents = (id) image.CGImage;
}

-(void)createCommentBoard {
    
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    _viewScreenComment = [[UIView alloc]initWithFrame:CGRectMake(0, delegate.mainNavigationController.view.frame.size.height, delegate.mainNavigationController.view.frame.size.width, delegate.mainNavigationController.view.frame.size.height)];
    _viewScreenComment.backgroundColor = [UIColor clearColor];
    [delegate.mainNavigationController.view addSubview:_viewScreenComment];
    
    _viewCommentBoard = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_viewScreenComment.frame) - COMMENT_BOARD_HEIGHT,
                                                                CGRectGetWidth(_viewScreenComment.frame),
                                                                COMMENT_BOARD_HEIGHT)];
    [_viewScreenComment addSubview:_viewCommentBoard];
    
    UIView *viewTap = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_viewScreenComment.frame), CGRectGetMinY(_viewCommentBoard.frame))];
    viewTap.tag = 100;
    viewTap.backgroundColor = [UIColor clearColor];
    [_viewScreenComment addSubview:viewTap];
    
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
        
        AppDelegate* delegate = [UIApplication sharedApplication].delegate;
        
        BOOL bContain = NO;
        NSArray *subViews = [delegate.mainNavigationController.view subviews];
        
        for (UIView *view in subViews) {
            if (view == strongSelf->m_viewScreenReply) {
                bContain = YES;
                break;
            }
        }
        
        if (!bContain) {
            [delegate.mainNavigationController.view addSubview:strongSelf->m_viewScreenReply];
        }
        
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
        
        NSMutableDictionary *dictData = [strongSelf->_replyDict objectForKey:strongSelf->_articleObject.article_id];
        
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
    [self hideCommentBoard];
}

-(void)actionReplyTap:(UITapGestureRecognizer*)gr {
    CGRect inputViewFrame = m_viewReply.frame;
    
    if (inputViewFrame.origin.y != self.view.bounds.size.height && _textViewInputViewType != XHInputViewTypeNormal) {
        [self layoutOtherMenuViewHiden:YES];
    }
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
    
    UIViewController *viewController = [self superViewController];
    [viewController.navigationController.view addSubview:viewMain];
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

-(void)walletTradeByValue:(NSInteger)nCoinValue
{
    [m_rewardAlert dismissAlert];
    
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    id processWin = [AlertManager showCommonProgress];
    
    [[SportForumAPI sharedInstance] walletTradeBySelfAddress:userInfo.wallet
                                                     TradeTo:_articleObject.authorInfo.wallet
                                                   TradeType:e_reward
                                                   ArticleId:_articleObject.article_id
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
             
             _articleObject.reward_total += nCoinValue * (long long)100000000;
             
             UILabel *lbRewardCount = (UILabel*)[_viewOperation viewWithTag:22];
             lbRewardCount.text = [NSString stringWithFormat:@"%lld", _articleObject.reward_total / 100000000];
             
             [NSTimer scheduledTimerWithTimeInterval: 1
                                              target: self
                                            selector: @selector(actionTradeSuccess)
                                            userInfo: nil
                                             repeats: NO];
         }
     }];
}

-(void)actionTradeSuccess
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
    m_textFiledReward.textColor = [UIColor darkGrayColor];
    m_textFiledReward.tintColor = [UIColor darkGrayColor];
    m_textFiledReward.keyboardType = UIKeyboardTypeNumberPad;
    m_textFiledReward.autocapitalizationType = UITextAutocapitalizationTypeNone;
    m_textFiledReward.enablesReturnKeyAutomatically = YES;
    m_textFiledReward.textAlignment = NSTextAlignmentLeft;
    m_textFiledReward.multipleTouchEnabled = YES;
    m_textFiledReward.returnKeyType = UIReturnKeyDone;
    m_textFiledReward.delegate = self;
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
                 NSString *strRewardTitle = [NSString stringWithFormat:@"打赏%@", _articleObject.authorInfo.nikename];
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
        for (int index = 0; index < _articleObject.article_segments.data.count; index++) {
            ArticleSegmentObject* segobj = _articleObject.article_segments.data[index];
            
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
    
    UIViewController *viewController = [self superViewController];
    [viewController.navigationController pushViewController:browser animated:YES];
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
                         UIViewController *viewController = [self superViewController];
                         [viewController.navigationController pushViewController:accountPreViewController animated:YES];
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
    if (_articleObject.content.length > 0) {
        if(_isLoadingFinished)
        {
            CGRect frame = aWebView.frame;
            frame.size.height = 1;
            CGSize fittingSize = [aWebView sizeThatFits:CGSizeZero];
            frame.size = fittingSize;
            frame.size.height = [[aWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] floatValue];
            frame.size.width = cContentWidth - 10;
            aWebView.frame = frame;
            
            [_webView stringByEvaluatingJavaScriptFromString:[self createJavaScript]];
            [_webView stringByEvaluatingJavaScriptFromString:@"setImage()"];
            NSLog(@"size: %f, %f", frame.size.width, frame.size.height);
            [self updateOperationView];
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
        
        if([_articleObject.type isEqualToString:@"record"])
        {
            [self updateRecordView];
        }
        
        [self updateOperationView];
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

#pragma mark - Comment Logic

-(void)hideCommentBoard
{
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlArticleComments, nil]];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    _viewScreenComment.frame = CGRectMake(0, delegate.mainNavigationController.view.frame.size.height, delegate.mainNavigationController.view.frame.size.width, delegate.mainNavigationController.view.frame.size.height);
    [UIView commitAnimations];
    
    if (m_tapGestureRecognizer != nil) {
        [m_tapGestureRecognizer removeTarget:self action:@selector(actionTap:)];
        m_tapGestureRecognizer = nil;
    }
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
    
    _btnReview.enabled = ![_articleObject.relation isEqualToString:@"DEFRIEND"];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    _viewScreenComment.frame = CGRectMake(0, 0, delegate.mainNavigationController.view.frame.size.width, delegate.mainNavigationController.view.frame.size.height);
    [UIView commitAnimations];
    
    UIView *viewTap = [_viewScreenComment viewWithTag:100];
    
    if (m_tapGestureRecognizer == nil) {
        m_tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
        [viewTap addGestureRecognizer:m_tapGestureRecognizer];
    }
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
    //CGSize contentSize = scrollView.contentSize;
    //CGRect rectContent = scrollView.frame;
    //CGPoint point11 = scrollView.contentOffset;
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
    
    UIViewController *viewController = [self superViewController];
    [viewController.navigationController pushViewController:articlePagesViewController animated:YES];
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
        
        if (rect.origin.y == CGRectGetHeight(m_viewScreenReply.frame)) {
            [m_viewScreenReply removeFromSuperview];
            
            if (m_tapGestureRecognizer0 != nil) {
                [m_tapGestureRecognizer0 removeTarget:self action:@selector(actionReplyTap:)];
                m_tapGestureRecognizer0 = nil;
            }
            
            if (_articleObject != nil) {
                NSMutableArray *arrImgUrls = [NSMutableArray arrayWithArray:_imgUrlArray];
                [_replyDict setObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:m_viewReply.inputTextView.text, @"Content", arrImgUrls, @"ImgUrls", nil] forKey:_articleObject.article_id];
            }
        }
        else
        {
            UIView *viewTap = [m_viewScreenReply viewWithTag:101];
            
            if (m_tapGestureRecognizer0 == nil) {
                m_tapGestureRecognizer0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionReplyTap:)];
                [viewTap addGestureRecognizer:m_tapGestureRecognizer0];
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

    CGSize size = [[textView text] sizeWithAttributes:@{NSFontAttributeName: [textView font]}];//[[textView text] sizeWithFont:[textView font]];
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
                             
                             UIView *viewTap = [m_viewScreenReply viewWithTag:101];
                             viewTap.frame = CGRectMake(0, 0, CGRectGetWidth(m_viewScreenReply.frame), CGRectGetMinY(m_viewReply.frame));
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
            inputViewFrame.origin.y = (hide ? CGRectGetHeight(m_viewScreenReply.frame) : (CGRectGetMinY(otherMenuViewFrame) - CGRectGetHeight(inputViewFrame)));
            m_viewReply.frame = inputViewFrame;
            UIView *viewTap = [m_viewScreenReply viewWithTag:101];
            viewTap.frame = CGRectMake(0, 0, CGRectGetWidth(m_viewScreenReply.frame), CGRectGetMinY(m_viewReply.frame));
        };
        
        void (^ShareMenuViewAnimation)(BOOL hide) = ^(BOOL hide) {
            otherMenuViewFrame = self.shareMenuView.frame;
            otherMenuViewFrame.origin.y = (hide ? CGRectGetHeight(m_viewScreenReply.frame) : (CGRectGetHeight(m_viewScreenReply.frame) - CGRectGetHeight(otherMenuViewFrame)));
            self.shareMenuView.alpha = !hide;
            self.shareMenuView.frame = otherMenuViewFrame;
        };
        
        ShareMenuViewAnimation(hide);
        InputViewAnimation(hide);
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

#pragma mark - Handle Reply Add Image
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
    
    UIViewController *viewController = [self superViewController];
    [_customMenuViewController showInView:viewController.navigationController.view];
}

-(void)onClickAddImageViewByIndex:(NSUInteger)index
{
    [_photoAdds removeAllObjects];
    
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
    
    UIViewController *viewController = [self superViewController];
    [viewController.navigationController pushViewController:browser animated:YES];
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
            
            NSUInteger nIndex = [strongSelf->_imgViewArray indexOfObject:imageView];
            [strongSelf onClickAddImageViewByIndex:nIndex];
        };
        
        [m_viewShareMenu addSubview:imageView];
        [m_viewShareMenu addSubview:btnImage];
        [m_viewShareMenu bringSubviewToFront:imageView];
        [m_viewShareMenu bringSubviewToFront:btnImage];
        
        //[_imgBtnArray addObject:btnImage];
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
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    UIViewController *viewController = [self superViewController];
    [viewController dismissViewControllerAnimated:YES completion:nil];
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
            
            [delegate.mainNavigationController.view bringSubviewToFront:strongThis->m_viewScreenReply];
        }
    }];
    
    [delegate.mainNavigationController.view sendSubviewToBack:m_viewScreenReply];

    _imageEditViewController.sourceImage = image;
    [_imageEditViewController reset:NO];
    
    [viewController.navigationController pushViewController:_imageEditViewController animated:YES];
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
    
    UIViewController *viewController = [self superViewController];
    [viewController presentViewController:imagePicker animated:YES completion:nil];
    
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
    
    UIViewController *viewController = [self superViewController];
    [viewController presentViewController:picker animated:YES completion:NULL];
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

#pragma mark - EGORefreshTableHeaderDelegate

- (void)upDragLoadData {
    // Get Data From Server
    [self showBottomIndicator:NO];
}

-(void)refreshComments {
    if (_reloading) {
        _reloading = NO;
        [_PullRightRefreshView egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView*)[_swipeView currentSwipeView]];
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    _reloading = YES;
    [self performSelector:@selector(refreshComments) withObject:nil afterDelay:1.0f];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return _reloading;
}

@end
