//
//  NearByViewController.m
//  SportForum
//
//  Created by liyuan on 14-8-14.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

//
//  NearByViewController.m
//  SportForum
//
//  Created by liyuan on 14-8-14.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "NearByViewController.h"
#import "UIViewController+SportFormu.h"
#import "RecommendCircleViewController.h"
#import "AppDelegate.h"
#import "AlertManager.h"
#import "MobClick.h"
#import "UIImageView+WebCache.h"
#import "ArticlePagesViewController.h"
#import "AccountPreViewController.h"

@interface NearByViewController ()

@end

@implementation NearByViewController
{
    UIScrollView *m_scrollView;
    UIView *m_viewRefer;
    UILabel *m_lbDescRefer;
    UIImageView *m_imgViewRefer;
    CSButton *m_btnDesc;
    CSButton *m_btnImg;
    
    UIActivityIndicatorView *_activityIndicatorView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)bShowFooterViewController {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNewArticleStatus:) name:NOTIFY_MESSAGE_NEW_ARTICLE_UPDATE object:nil];
    
    m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    m_scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_scrollView];
    m_scrollView.scrollEnabled = YES;

    // Do any additional setup after loading the view.
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(m_scrollView.frame) / 2 - 120, 10, 240, 20)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor blackColor];
    labelTitle.text = @"悦动达人";
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont boldSystemFontOfSize:16];
    [m_scrollView addSubview:labelTitle];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 48, 48)];
    _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    _activityIndicatorView.color = [UIColor colorWithRed:0 green:137.0 / 255.0 blue:207.0 / 255.0 alpha:1.0];
    _activityIndicatorView.center = m_scrollView.center;
    _activityIndicatorView.hidden = NO;
    _activityIndicatorView.hidesWhenStopped = YES;
    [m_scrollView addSubview:_activityIndicatorView];
    
    [self generateReferralView];
    
    m_lbDescRefer = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(labelTitle.frame) + 10, CGRectGetWidth(m_scrollView.frame) - 20, 20)];
    m_lbDescRefer.backgroundColor = [UIColor clearColor];
    m_lbDescRefer.font = [UIFont boldSystemFontOfSize:15];
    m_lbDescRefer.textColor = [UIColor darkGrayColor];
    m_lbDescRefer.textAlignment = NSTextAlignmentLeft;
    m_lbDescRefer.numberOfLines = 0;
   // m_lbDescDesc.text = @"她爱好跑步，经常跑个15公里，快乐，身体很健康，也通过跑步人事了好多人";
    [m_scrollView addSubview:m_lbDescRefer];
    
    CGSize constraint = CGSizeMake(CGRectGetWidth(m_scrollView.frame) - 20, 20000.0f);
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    CGSize size = [m_lbDescRefer.text boundingRectWithSize:constraint
                                         options:options
                                      attributes:@{NSFontAttributeName:m_lbDescRefer.font} context:nil].size;
    
    m_lbDescRefer.frame = CGRectMake(10, CGRectGetMaxY(labelTitle.frame) + 10, CGRectGetWidth(m_scrollView.frame) - 20, size.height + 10);

    m_imgViewRefer = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(m_lbDescRefer.frame) + 30, CGRectGetWidth(m_scrollView.frame), 320)];
    //[m_imgViewRefer setImage:[UIImage imageNamed:@"111.jpg"]];
    [m_scrollView addSubview:m_imgViewRefer];

    m_btnDesc = [CSButton buttonWithType:UIButtonTypeCustom];
    m_btnDesc.backgroundColor = [UIColor clearColor];
    m_btnDesc.hidden = YES;
    [m_scrollView addSubview:m_btnDesc];
    
    m_btnImg = [CSButton buttonWithType:UIButtonTypeCustom];
    m_btnImg.backgroundColor = [UIColor clearColor];
    m_btnImg.hidden = YES;
    [m_scrollView addSubview:m_btnImg];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发现 - NearByViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"发现 - NearByViewController"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [delegate.mainNavigationController checkNewAttention];
    
    [self handleGetReferInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发现 - NearByViewController"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"NearByViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadProcessShow:(BOOL)blShow {
    if (blShow) {
        [_activityIndicatorView startAnimating];
    } else {
        [_activityIndicatorView stopAnimating];
    }
}

-(void)loadArticleWhenClickImg:(ArticlesObject*)articlesMember
{
    if (articlesMember.refer_article.length > 0) {
        id processWin = [AlertManager showCommonProgressInView:m_scrollView];
        __weak __typeof(self) weakself = self;
        
        [[SportForumAPI sharedInstance]articleGetByArticleId:articlesMember.refer_article FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
            __typeof(self) strongSelf = weakself;
            
            [AlertManager dissmiss:processWin];
            
            if (strongSelf != nil) {
                if (errorCode == 0) {
                    ArticlePagesViewController* articlePagesViewController = [[ArticlePagesViewController alloc] init];
                    articlePagesViewController.currentIndex = 0;
                    articlePagesViewController.arrayArticleInfos = [NSMutableArray arrayWithObject:articlesObject];
                    [self.navigationController pushViewController:articlePagesViewController animated:YES];
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
        AccountPreViewController *accountPreViewController = [[AccountPreViewController alloc]init];
        accountPreViewController.strUserId = articlesMember.refer;
        [self.navigationController pushViewController:accountPreViewController animated:YES];
    }
}

-(void)loadDefaultAtcileWhenClick
{
    id processWin = [AlertManager showCommonProgressInView:m_scrollView];
    __weak __typeof(self) weakself = self;
    
    [[SportForumAPI sharedInstance]articleGetByArticleId:@"55cabb82fd19c44250000063" FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
        __typeof(self) strongSelf = weakself;
        
        [AlertManager dissmiss:processWin];
        
        if (strongSelf != nil) {
            if (errorCode == 0) {
                ArticlePagesViewController* articlePagesViewController = [[ArticlePagesViewController alloc] init];
                articlePagesViewController.currentIndex = 0;
                articlePagesViewController.arrayArticleInfos = [NSMutableArray arrayWithObject:articlesObject];
                [self.navigationController pushViewController:articlePagesViewController animated:YES];
            }
            else
            {
                [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
            }
        }
    }];
}

-(void)updateReferInfoByReferObject:(ArticlesObject*)articlesObject
{
    if (articlesObject != nil) {
        CGSize constraint = CGSizeMake(CGRectGetWidth(m_scrollView.frame) - 20, 20000.0f);
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        CGSize size = [articlesObject.cover_text boundingRectWithSize:constraint
                                                      options:options
                                                   attributes:@{NSFontAttributeName:m_lbDescRefer.font} context:nil].size;
        
        m_lbDescRefer.frame = CGRectMake(10, 40, CGRectGetWidth(m_scrollView.frame) - 20, size.height + 30);
        
        NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
        NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:articlesObject.cover_text attributes:attribs];
        
        attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15], NSForegroundColorAttributeName:[UIColor colorWithRed:98.0 / 255.0 green:197.0 / 255.0 blue:255.0 / 255.0 alpha:1]};
        NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:@" 访谈>>" attributes:attribs];
        
        NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
        [strPer appendAttributedString:strPart2Value];
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setParagraphSpacing:10];
        [strPer addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [strPer length])];
        m_lbDescRefer.attributedText = strPer;

        [m_imgViewRefer sd_setImageWithURL:[NSURL URLWithString:articlesObject.cover_image]
                          placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        m_imgViewRefer.frame = CGRectMake(0, CGRectGetHeight(m_scrollView.frame) - 49.0 - 50 - 340 - [UIApplication sharedApplication].statusBarFrame.size.height, CGRectGetWidth(m_scrollView.frame), 340);
        
        m_btnDesc.hidden = NO;
        m_btnDesc.frame = m_lbDescRefer.frame;
        
        m_btnImg.hidden = NO;
        m_btnImg.frame = m_imgViewRefer.frame;
        
        __weak __typeof(self) weakself = self;
        
        m_btnDesc.actionBlock = ^(void)
        {
            __typeof(self) strongself = weakself;
            
            if(articlesObject.content.length > 0)
            {
                ArticlePagesViewController* articlePagesViewController = [[ArticlePagesViewController alloc] init];
                articlePagesViewController.currentIndex = 0;
                articlePagesViewController.arrayArticleInfos = [NSMutableArray arrayWithObject:articlesObject];
                [strongself.navigationController pushViewController:articlePagesViewController animated:YES];
            }
            else
            {
                [strongself loadArticleWhenClickImg:articlesObject];
            }
        };
        
        m_btnImg.actionBlock = ^(void)
        {
            __typeof(self) strongself = weakself;
            [strongself loadArticleWhenClickImg:articlesObject];
        };
    }
    else
    {
        //悦动力邀您用镜头留住活力、用记忆波动心弦、用感动书写生命。
        m_lbDescRefer.text = @"我们正在寻找悦动达人，如果你在运动很有心得，想跟大家分享一下，请联系我们，我们将联系你做访谈，让整个社区都更加了解你。";
        
        CGSize constraint = CGSizeMake(CGRectGetWidth(m_scrollView.frame) - 20, 20000.0f);
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        CGSize size = [m_lbDescRefer.text boundingRectWithSize:constraint
                                                      options:options
                                                   attributes:@{NSFontAttributeName:m_lbDescRefer.font} context:nil].size;
        
        m_lbDescRefer.frame = CGRectMake(10, 40, CGRectGetWidth(m_scrollView.frame) - 20, size.height + 10);
        
        [m_imgViewRefer setImage:[UIImage imageNamedWithWebP:@"default_refer"]];
        m_imgViewRefer.frame = CGRectMake(0, CGRectGetHeight(m_scrollView.frame) - 49.0 - 50 - 320 - [UIApplication sharedApplication].statusBarFrame.size.height, CGRectGetWidth(m_scrollView.frame), 320);
        
        m_btnImg.hidden = YES;
        
        m_btnDesc.hidden = YES;
//        m_btnDesc.frame = m_lbDescRefer.frame;
//
//        __weak __typeof(self) weakself = self;
//        
//        m_btnDesc.actionBlock = ^(void)
//        {
//            __typeof(self) strongself = weakself;
//            [strongself loadDefaultAtcileWhenClick];
//        };
    }
    
    m_scrollView.contentSize = CGSizeMake(CGRectGetWidth(m_scrollView.frame), CGRectGetMaxY(m_imgViewRefer.frame));
}

-(void)handleGetReferInfo
{
    [self loadProcessShow:YES];
    
    __weak __typeof(self) weakself = self;
    
    [[SportForumAPI sharedInstance]articleGetByArticleId:@"" FinishedBlock:^(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr){
        __typeof(self) strongself = weakself;
        
        if (strongself != nil) {
            [self loadProcessShow:NO];
            
            if (errorCode == 0) {
                [self updateReferInfoByReferObject:articlesObject];
            }
            else
            {
                //[JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                [self updateReferInfoByReferObject:nil];
            }
        }
    }];

}

-(void)handleNewArticleStatus:(NSNotification*) notification
{
    NSInteger nNewsCount = [[notification.userInfo objectForKey:@"NewsCount"]integerValue];
    NSArray* arrProfilesImgs = [notification.userInfo objectForKey:@"NewProfiles"];
    
    UILabel *lbRefer = (UILabel*)[m_viewRefer viewWithTag:59999];
    UIImageView *imageViewUser1 = (UIImageView*)[m_viewRefer viewWithTag:60000];
    UIImageView *imageViewUser2 = (UIImageView*)[m_viewRefer viewWithTag:60001];
    UIImageView *imgViewNum = (UIImageView*)[m_viewRefer viewWithTag:60003];
    UILabel *lbReferCount = (UILabel*)[m_viewRefer viewWithTag:60002];
    
    if (nNewsCount > 0) {
        [lbReferCount setText:[NSString stringWithFormat:@"%ld", nNewsCount]];
        CGSize constraint = CGSizeMake(20000.0f, 20.0f);
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        CGSize size = [lbReferCount.text boundingRectWithSize:constraint
                                                       options:options
                                                    attributes:@{NSFontAttributeName:lbReferCount.font} context:nil].size;
        
        lbReferCount.frame = CGRectMake(CGRectGetWidth(m_viewRefer.frame) - 15 - size.width - 5, 15, size.width, 20);

        imageViewUser1.frame = CGRectMake(CGRectGetMinX(lbReferCount.frame) - 50, 5, 40, 40);
        imgViewNum.frame = CGRectMake(CGRectGetMaxX(imageViewUser1.frame), 3, 9, 9);
        
        imgViewNum.hidden = NO;
        lbRefer.text = @"你关注的Ta有最新动态了";
        [imageViewUser1 sd_setImageWithURL:[NSURL URLWithString:arrProfilesImgs.firstObject]
                          placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
        imageViewUser1.hidden = NO;
        imageViewUser2.hidden = YES;
        
        /*if (arrProfilesImgs.count == 1) {
            [imageViewUser1 sd_setImageWithURL:[NSURL URLWithString:arrProfilesImgs.firstObject]
                              placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
            imageViewUser1.hidden = NO;
            imageViewUser2.hidden = YES;
        }
        else
        {
            imageViewUser1.hidden = NO;
            imageViewUser2.hidden = YES;
            [imageViewUser1 sd_setImageWithURL:[NSURL URLWithString:arrProfilesImgs.firstObject]
                              placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
            //[imageViewUser2 sd_setImageWithURL:[NSURL URLWithString:arrProfilesImgs.firstObject]
            //                  placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
        }*/
    }
    else
    {
        imgViewNum.hidden = YES;
        lbRefer.text = @"关注动态";
        lbReferCount.text = @"";
        imageViewUser1.hidden = YES;
        imageViewUser2.hidden = YES;
    }
}

-(void)generateReferralView
{
    m_viewRefer = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49.0 - 50, CGRectGetWidth(self.view.frame), 50)];
    m_viewRefer.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    [self.view addSubview:m_viewRefer];
    
    UILabel *lbRefer = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 180, 20)];
    lbRefer.backgroundColor = [UIColor clearColor];
    lbRefer.font = [UIFont boldSystemFontOfSize:15];
    lbRefer.textColor = [UIColor darkGrayColor];
    lbRefer.textAlignment = NSTextAlignmentLeft;
    lbRefer.text = @"关注动态";
    lbRefer.tag = 59999;
    [m_viewRefer addSubview:lbRefer];
    
    UIImageView *imgViewArrow = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(m_viewRefer.frame) - 15, 17, 8, 16)];
    [imgViewArrow setImage:[UIImage imageNamed:@"arrow-11"]];
    [m_viewRefer addSubview:imgViewArrow];
    
    UIImageView *imageViewUser1 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgViewArrow.frame) - 70, 5, 40, 40)];
    imageViewUser1.tag = 60000;
    [m_viewRefer addSubview:imageViewUser1];
    
    UIImageView *imageViewUser2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageViewUser1.frame) - 45, 5, 40, 40)];
    imageViewUser2.tag = 60001;
    [m_viewRefer addSubview:imageViewUser2];
    
    UILabel *lbReferCount = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgViewArrow.frame) - 20, 15, 15, 20)];
    lbReferCount.backgroundColor = [UIColor clearColor];
    lbReferCount.font = [UIFont systemFontOfSize:12];
    lbReferCount.textColor = [UIColor lightGrayColor];
    lbReferCount.textAlignment = NSTextAlignmentRight;
    lbReferCount.tag = 60002;
    [m_viewRefer addSubview:lbReferCount];
    
    UIImageView *imgViewNum = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageViewUser1.frame), 3, 9, 9)];
    imgViewNum.image = [UIImage imageNamed:@"info-reddot-small"];
    imgViewNum.tag = 60003;
    imgViewNum.hidden = YES;
    [m_viewRefer addSubview:imgViewNum];

    CSButton *btnAction = [CSButton buttonWithType:UIButtonTypeCustom];
    btnAction.frame = CGRectMake(0, 0, CGRectGetWidth(m_viewRefer.frame), 50);
    btnAction.backgroundColor = [UIColor clearColor];
    [m_viewRefer addSubview:btnAction];

    __weak __typeof(self) weakSelf = self;

    btnAction.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        RecommendCircleViewController *recommendCircleViewController = [[RecommendCircleViewController alloc]init];
        recommendCircleViewController.bAttentionCircle = YES;
        [strongSelf.navigationController pushViewController:recommendCircleViewController animated:YES];
    };
}

@end



//#import "NearByViewController.h"
//#import "UIViewController+SportFormu.h"
//#import "RecommendCircleViewController.h"
//#import "RelatedPeoplesViewController.h"
//#import "RecommendPeoplesViewController.h"
//#import "MobileFriendViewController.h"
//#import "AppDelegate.h"
//
//#define NEARBY_CONTENT_VIEW 9
//#define NEARBY_TITLE_LABEL_TAG 10
//#define NEARBY_DESC_LABEL_TAG 11
//#define NEARBY_DESC_IMAGE_TAG 12
//#define NEARBY_ARROW_IMAGE_TAG 13
//
//@implementation NearByItem
//
//@end
//
//@interface NearByViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
//
//@end
//
//@implementation NearByViewController
//{
//    NSArray * _arrTableStruct;
//    NSMutableArray* m_nearByItems0;
//    NSMutableArray* m_nearByItems1;
//    UITableView *m_tableNearBy;
//    
//    NSInteger m_nNewsCount;
//}
//
//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//-(void)loadTestData
//{
//    _arrTableStruct = [NSArray arrayWithObjects:
//                       [NSNumber numberWithInt:2],
//                       [NSNumber numberWithInt:3],
//                       nil];
//    
//    m_nearByItems0 = [[NSMutableArray alloc]init];
//    
//    NearByItem *nearByItem = [[NearByItem alloc]init];
//    nearByItem.nearByTitle = @"关注动态";
//    nearByItem.nearByImg = @"discover-status";
//    [m_nearByItems0 addObject:nearByItem];
//    
//    nearByItem = [[NearByItem alloc]init];
//    nearByItem.nearByTitle = @"悦动吧";
//    nearByItem.nearByImg = @"discover-bar";
//    [m_nearByItems0 addObject:nearByItem];
//    
//    m_nearByItems1 = [[NSMutableArray alloc]init];
//    nearByItem = [[NearByItem alloc]init];
//    nearByItem.nearByTitle = @"附近的人";
//    nearByItem.nearByImg = @"discover-nearby";
//    [m_nearByItems1 addObject:nearByItem];
//    
//    nearByItem = [[NearByItem alloc]init];
//    nearByItem.nearByTitle = @"可能感兴趣的人";
//    nearByItem.nearByImg = @"discover-interest-persons";
//    [m_nearByItems1 addObject:nearByItem];
//    
//    nearByItem = [[NearByItem alloc]init];
//    nearByItem.nearByTitle = @"已经加入的朋友";
//    nearByItem.nearByImg = @"mobile-contact";
//    [m_nearByItems1 addObject:nearByItem];
//}
//
//-(BOOL)bShowFooterViewController {
//    return YES;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNewArticleStatus:) name:NOTIFY_MESSAGE_NEW_ARTICLE_UPDATE object:nil];
//    
//	// Do any additional setup after loading the view.
//    [self generateCommonViewInParent:self.view Title:@"发现" IsNeedBackBtn:NO];
//    
//    [self loadTestData];
//    
//    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
//    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
//    
//    CGRect rect = CGRectMake(0, 0, viewBody.frame.size.width, viewBody.frame.size.height);
//    m_tableNearBy = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
//    m_tableNearBy.delegate = self;
//    m_tableNearBy.dataSource = self;
//    [viewBody addSubview:m_tableNearBy];
//
//    [m_tableNearBy reloadData];
//    m_tableNearBy.backgroundColor = [UIColor clearColor];
//    m_tableNearBy.separatorColor = [UIColor clearColor];
//    
//    if ([m_tableNearBy respondsToSelector:@selector(setSeparatorInset:)]) {
//        [m_tableNearBy setSeparatorInset:UIEdgeInsetsZero];
//    }
//    
//    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
//    [delegate.mainNavigationController checkNewAttention];
//}
//
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [MobClick beginLogPageView:@"发现 - NearByViewController"];
//    [[ApplicationContext sharedInstance]setRegUserPath:@"发现 - NearByViewController"];
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [MobClick endLogPageView:@"发现 - NearByViewController"];
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//-(void)dealloc
//{
//    NSLog(@"NearByViewController dealloc");
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//-(void)handleNewArticleStatus:(NSNotification*) notification
//{
//    m_nNewsCount = [[notification.userInfo objectForKey:@"NewsCount"]integerValue];
//    [m_tableNearBy reloadData];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [[_arrTableStruct objectAtIndex:section] integerValue];
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [_arrTableStruct count];
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellTableIdentifier = @"NearByIdentifier";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellTableIdentifier];
//
//    if (cell == nil)
//    {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: CellTableIdentifier];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        UIImageView* viewContent = [[UIImageView alloc]init];
//        viewContent.tag = NEARBY_CONTENT_VIEW;
//        [cell.contentView addSubview:viewContent];
//        
//        UIImageView * imgDescImage = [[UIImageView alloc] init];
//        imgDescImage.tag = NEARBY_DESC_IMAGE_TAG;
//        [viewContent addSubview:imgDescImage];
//        
//        UILabel * lbNearByTitle = [[UILabel alloc]init];
//        lbNearByTitle.font = [UIFont boldSystemFontOfSize:14.0];
//        lbNearByTitle.textAlignment = NSTextAlignmentLeft;
//        lbNearByTitle.backgroundColor = [UIColor clearColor];
//        lbNearByTitle.textColor = [UIColor blackColor];
//        lbNearByTitle.tag = NEARBY_TITLE_LABEL_TAG;
//        [viewContent addSubview:lbNearByTitle];
//        
//        UIImageView * imgArrow = [[UIImageView alloc] init];
//        imgArrow.tag = NEARBY_ARROW_IMAGE_TAG;
//        [viewContent addSubview:imgArrow];
//        
//        UIImageView *imgViewNum = [[UIImageView alloc]initWithFrame:CGRectZero];
//        imgViewNum.tag = 8;
//        imgViewNum.hidden = YES;
//        [viewContent addSubview:imgViewNum];
//    }
//    
//    NearByItem *nearByItem = nil;
//    
//    if ([indexPath section] == 0) {
//        nearByItem = m_nearByItems0[[indexPath row]];
//    }
//    else
//    {
//        nearByItem = m_nearByItems1[[indexPath row]];
//    }
//    
//    UIImage *imgBk = [UIImage imageNamed:@"transaction-block-bg"];
//    imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
//
//    UIImageView *viewContent = (UIImageView*)[cell.contentView viewWithTag:NEARBY_CONTENT_VIEW];
//    viewContent.frame = CGRectMake(5, 1, 300, 50);
//    [viewContent setImage:imgBk];
//    
//    UIImageView *imgDescImage = (UIImageView*)[viewContent viewWithTag:NEARBY_DESC_IMAGE_TAG];
//    UIImage *image = [UIImage imageNamed:nearByItem.nearByImg];
//    [imgDescImage setImage:image];
//    imgDescImage.frame = CGRectMake(8, 3, 40, 40);
//    
//    UILabel * lbNearByTitle = (UILabel*)[viewContent viewWithTag:NEARBY_TITLE_LABEL_TAG];
//    lbNearByTitle.text = nearByItem.nearByTitle;
//    //CGSize lbLeftSize = [lbNearByTitle.text sizeWithFont:lbNearByTitle.font
//    //                            constrainedToSize:CGSizeMake(150, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
//    
//    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
//    CGSize lbLeftSize = [lbNearByTitle.text boundingRectWithSize:CGSizeMake(150, FLT_MAX)
//                                                       options:options
//                                                    attributes:@{NSFontAttributeName:lbNearByTitle.font} context:nil].size;
//    
//    lbNearByTitle.frame = CGRectMake(15 + image.size.width, 15, lbLeftSize.width, 20);
//    
//    UIImageView * imgArrow = (UIImageView*)[viewContent viewWithTag:NEARBY_ARROW_IMAGE_TAG];
//    image = [UIImage imageNamed:@"arrow-1"];
//    [imgArrow setImage:image];
//    imgArrow.frame = CGRectMake(viewContent.frame.size.width - 15 - image.size.width, 15, image.size.width, image.size.height);
//    
//    UIImageView *imgViewNum = (UIImageView*)[viewContent viewWithTag:8];
//    
//    imgViewNum.hidden = YES;
//
//    if ([indexPath section] == 0 && [indexPath row] == 0 && m_nNewsCount > 0) {
//        imgViewNum.userInteractionEnabled = NO;
//        imgViewNum.hidden = NO;
//        imgViewNum.frame = CGRectMake(CGRectGetMaxX(imgDescImage.frame) - 4, 3, 9, 9);
//        imgViewNum.image = [UIImage imageNamed:@"info-reddot-small"];
//    }
//
//    return cell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 52;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    CGFloat fHeight = 5;
//    
//    if(section > 0)
//    {
//        fHeight = 8;
//    }
//    
//    return fHeight;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 8;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NearByItem *nearByItem = nil;
//    
//    if(indexPath.section == 0)
//    {
//        nearByItem = m_nearByItems0[[indexPath row]];
//    }
//    else
//    {
//        nearByItem = m_nearByItems1[[indexPath row]];
//    }
//    
//    if([nearByItem.nearByTitle isEqualToString:@"关注动态"])
//    {
//        RecommendCircleViewController *recommendCircleViewController = [[RecommendCircleViewController alloc]init];
//        recommendCircleViewController.bAttentionCircle = YES;
//        [self.navigationController pushViewController:recommendCircleViewController animated:YES];
//    }
//    else if ([nearByItem.nearByTitle isEqualToString:@"悦动吧"]) {
//        RecommendCircleViewController *recommendCircleViewController = [[RecommendCircleViewController alloc]init];
//        recommendCircleViewController.bAttentionCircle = NO;
//        [self.navigationController pushViewController:recommendCircleViewController animated:YES];
//    }
//    else if([nearByItem.nearByTitle isEqualToString:@"附近的人"])
//    {
//        RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
//        relatedPeoplesViewController.eRelatedType = e_related_people_nearby;
//        [self.navigationController pushViewController:relatedPeoplesViewController animated:YES];
//    }
//    else if([nearByItem.nearByTitle isEqualToString:@"可能感兴趣的人"])
//    {
//        RecommendPeoplesViewController *recommendPeoplesViewController = [[RecommendPeoplesViewController alloc]init];
//        [self.navigationController pushViewController:recommendPeoplesViewController animated:YES];
//    }
//    else
//    {
//        MobileFriendViewController *mobileFriendViewController = [[MobileFriendViewController alloc]init];
//        [self.navigationController pushViewController:mobileFriendViewController animated:YES];
//    }
//}
//
//@end
