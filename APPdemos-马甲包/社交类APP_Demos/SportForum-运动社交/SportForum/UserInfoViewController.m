//
//  UserInfoViewController.m
//  SportForum
//
//  Created by liyuan on 14-6-23.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "UserInfoViewController.h"
#import "SFGridView.h"
#import "WallCell.h"
#import "CSButton.h"
#import "CommonUtility.h"
#import "UIViewController+SportFormu.h"
#import "UIImageView+WebCache.h"
#import "UserFitnessDataViewController.h"
#import "WalletViewController.h"
#import "SettingsViewController.h"
#import "SettingMainViewController.h"
#import "HistoryViewController.h"
#import "UIImage+Utility.h"
#import "RelatedPeoplesViewController.h"
#import "MWPhotoBrowser.h"
#import "AppDelegate.h"
#import "AlertManager.h"
#import "ArticlePagesViewController.h"

@interface UserInfoViewController ()<SFGridViewDelegate, MWPhotoBrowserDelegate>

@end

@implementation UserInfoViewController
{
    NSMutableDictionary * _dicUpdateControl;
    UIScrollView *_scrollView;
    UIImageView *_imageViewUser;
    UIView *_viewMan;
    UIView *_viewWomen;
    UILabel *_lbAge;
    UIImageView * _imgStar[12];
    UIImageView * _imgLevelBK;
    UILabel *_lbLevelValue;
    UILabel *_lbScoreValue;
    UIView *_viewPhone;
    UIImageView *_imgPrivatePicture[4];
    UIView *_imgPriPicFrame[4];
    CSButton *_btnPrivate[4];
    UIView *_viewNoPrivatePicture;
    UILabel *_lbAttentionValue;
    UILabel *_lbFanValue;
    UILabel *_lbRingValue;
    UILabel *_lbShoesValue;
    UILabel *_lbPhoneValue;
    UILabel *_lbLastLogin;
    
    //For Test
    NSMutableArray *_arrayForumDatas;
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _photos;
    
    SFGridView* _gridView;
    
    NSString *_strFirstPageId;
    NSString *_strLastPageId;
    BOOL _bArticleComment;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo:) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateLoginTime) name:NOTIFY_MESSAGE_UPDATE_LOGIN_INFO object:nil];
    _dicUpdateControl = [[NSMutableDictionary alloc]init];
    _imgUrlArray = [[NSMutableArray alloc]init];
    _photos = [[NSMutableArray alloc]init];

    UIImage *image = [UIImage imageNamed:@"the-lowest-bg"];
    self.view.layer.contents = (id) image.CGImage;
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"the-lowest-bg"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 49 - 65)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 520);
    _arrayForumDatas = [[NSMutableArray alloc]init];
    
    [self generateUserTitleView];
    [self generateUserInfoView];
    [self viewLoadGirdTable];

    [self viewDidLoadData:@"" LastPageId:@"" IsArticleComments:_bArticleComment];
    [self handleUpdateProfileInfo:nil];
}

-(void)viewLoadGirdTable
{
    _strFirstPageId = @"";
    _strLastPageId = @"";
    _bArticleComment = NO;
    _arrayForumDatas = [[NSMutableArray alloc]init];
    
    _gridView.gridViewDelegate = self;
    [_gridView enablePullRefreshHeaderViewTarget:self DidTriggerRefreshAction:@selector(actionPullHeaderRefresh)];
    [_gridView enablePullRefreshFooterViewTarget:self DidTriggerRefreshAction:@selector(actionPullFooterRefresh)];
    [_gridView.tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    self.title = userInfo.nikename;
    _gridView.contentInset = UIEdgeInsetsMake(0, 0, 25, 0);
}

- (NSInteger) numberOfCells:(SFGridView *)gridView {
    return _arrayForumDatas.count;
}

- (SFGridViewCell *) gridView:(SFGridView *)gridView Row:(NSInteger)rowIndex Column:(NSInteger)columnIndex {
    WallCell *cell = (WallCell *)[gridView dequeueReusableCell];
    
    if (cell == nil) {
        cell = [[WallCell alloc]initWithFrame:CGRectMake(0, 0, gridView.cellWidth, gridView.cellHeight)];
    }
    
    ArticlesObject* articleObj = _arrayForumDatas[rowIndex * gridView.colCount + columnIndex];
    WallCellInfo *cellInfo = [[WallCellInfo alloc]init];
    cellInfo.imageURL = articleObj.cover_image;
    cellInfo.title = articleObj.cover_text;
    cellInfo.thumbCount = articleObj.thumb_count;
    cellInfo.commentCount = articleObj.sub_article_count;
    
    cell.cellInfo = cellInfo;
    
    return cell;
}

- (void) gridView:(SFGridView *)grid didSelectRow:(NSInteger)rowIndex Column:(NSInteger)columnIndex {
    NSLog(@"clicked %ld %ld", (long)rowIndex, columnIndex);
    if ([_arrayForumDatas count] > 0) {
        ArticlePagesViewController* articlePagesViewController = [[ArticlePagesViewController alloc] init];
        articlePagesViewController.currentIndex = rowIndex * grid.colCount + columnIndex;
        articlePagesViewController.arrayArticleInfos = [NSMutableArray arrayWithArray:_arrayForumDatas];
        [self.navigationController pushViewController:articlePagesViewController animated:YES];
    }
}

-(void)actionPullHeaderRefresh {
    NSLog(@"loading header.....");
    [self viewDidLoadData:_strFirstPageId LastPageId:@"" IsArticleComments:_bArticleComment];
}

-(void)actionPullFooterRefresh {
    NSLog(@"loading footer.....");
    [self viewDidLoadData:@"" LastPageId:_strLastPageId IsArticleComments:_bArticleComment];
}

-(void)viewDidLoadData:(NSString*)strFirstrPageId LastPageId:(NSString*)strLastPageId IsArticleComments:(BOOL)bArticleComment
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    [[SportForumAPI sharedInstance]userArticlesByUserId:userInfo.userid ArticleType:bArticleComment ? article_type_comments : article_type_articles FirstPageId:strFirstrPageId LastPageId:strLastPageId PageItemNum:4 FinishedBlock:^void(int errorCode, ArticlesInfo *articlesInfo){
        [_gridView completePullHeaderRefresh];
        [_gridView completePullFooterRefresh];
        
        if (errorCode == 0)
        {
            if (strFirstrPageId.length == 0 && strLastPageId.length == 0)
            {
                [_arrayForumDatas removeAllObjects];
                
                _strFirstPageId = articlesInfo.page_frist_id;
                _strLastPageId = articlesInfo.page_last_id;
                _arrayForumDatas = articlesInfo.articles_without_content.data;
            }
            else if (strFirstrPageId.length == 0 && strLastPageId.length > 0)
            {
                _strLastPageId = articlesInfo.page_last_id;
                
                for (ArticlesObject *articlesObject in articlesInfo.articles_without_content.data)
                {
                    [_arrayForumDatas addObject:articlesObject];
                }
            }
            else if(strFirstrPageId.length > 0 && strLastPageId.length == 0)
            {
                _strFirstPageId = articlesInfo.page_frist_id;
                
                for (ArticlesObject *articlesObject in articlesInfo.articles_without_content.data)
                {
                    [_arrayForumDatas addObject:articlesObject];
                }
            }
            
            [_gridView reloadData];
        }
        else
        {
            if (strFirstrPageId.length == 0 && strLastPageId.length == 0)
            {
                [_arrayForumDatas removeAllObjects];
                [_gridView reloadData];
            }
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _scrollView.frame = CGRectMake(0, 70, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 60 - 65);
    [self updateProfilePro];
}

-(void)updateProfilePro
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if(userInfo.userid.length > 0)
    {
        UILabel *lbPhysique = [_dicUpdateControl objectForKey:@"体魄"];
        lbPhysique.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.physique_value];
        
        UILabel *lbLiterature = [_dicUpdateControl objectForKey:@"文学"];
        lbLiterature.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.literature_value];
        
        UILabel *lbMagic = [_dicUpdateControl objectForKey:@"魔法"];
        lbMagic.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.magic_value];
        
        UILabel *lbCoin = [_dicUpdateControl objectForKey:@"贝币"];
        lbCoin.text = [NSString stringWithFormat:@"%lld", userInfo.proper_info.coin_value / 100000000];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"UserInfoViewController dealloc called!");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)bShowFooterViewController {
    return YES;
}

-(UIView*)generateUserTitleViewItem:(NSString*)strTitle ScoreValue:(NSString*)strScoreValue
{
    UIView* viewItem = [[UIView alloc]init];
    
    UIImageView *viewImage = [[UIImageView alloc]init];
    viewImage.frame = CGRectMake(10, 5, 15, 15);
    [viewItem addSubview:viewImage];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 30, 10)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor colorWithRed:112.0 / 255.0 green:230.0 / 255.0 blue:243.0 / 255.0 alpha:1.0];
    labelTitle.text = strTitle;
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.font = [UIFont boldSystemFontOfSize:11];
    [viewItem addSubview:labelTitle];
    
    UILabel *labelScore = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(labelTitle.frame) + 6.5, 35, 10)];
    labelScore.backgroundColor = [UIColor clearColor];
    labelScore.textColor = [UIColor whiteColor];
    labelScore.text = strScoreValue;
    labelScore.textAlignment = NSTextAlignmentRight;
    labelScore.font = [UIFont systemFontOfSize:11];
    labelScore.tag = 10;
    [viewItem addSubview:labelScore];
    
    viewItem.frame = CGRectMake(0, 0, 73, 39);
    [_dicUpdateControl setObject:labelScore forKey:strTitle];
    
    return viewItem;
}

-(void)generateUserTitleView
{
    UIView *viewSport = [self generateUserTitleViewItem:@"体魄" ScoreValue:@"0"];
    CGRect rect = viewSport.frame;
    rect.origin = CGPointMake(5, 25);
    viewSport.frame = rect;
    UIImage *image = [UIImage imageNamed:@"status-run"];
    viewSport.layer.contents = (id) image.CGImage;
    //viewSport.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"status-run"]];
    [self.view addSubview:viewSport];
    
    UIView *viewLiterature = [self generateUserTitleViewItem:@"文学" ScoreValue:@"0"];
    rect = viewLiterature.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewSport.frame) + 7, 25);
    viewLiterature.frame = rect;
    image = [UIImage imageNamed:@"status-blog"];
    viewLiterature.layer.contents = (id) image.CGImage;
    //viewLiterature.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"status-blog"]];
    [self.view addSubview:viewLiterature];
    
    UIView *viewMagic = [self generateUserTitleViewItem:@"魔法" ScoreValue:@"0"];
    rect = viewMagic.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewLiterature.frame) + 7, 25);
    viewMagic.frame = rect;
    image = [UIImage imageNamed:@"status-magic"];
    viewMagic.layer.contents = (id) image.CGImage;
    //viewMagic.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"status-magic"]];
    [self.view addSubview:viewMagic];
    
    UIView *viewBtc = [self generateUserTitleViewItem:@"贝币" ScoreValue:@"0"];
    rect = viewBtc.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewMagic.frame) + 7, 25);
    viewBtc.frame = rect;
    image = [UIImage imageNamed:@"status-money"];
    viewBtc.layer.contents = (id) image.CGImage;
    //viewBtc.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"status-money"]];
    [self.view addSubview:viewBtc];
}

-(UIView*)generateUserContentViewItem:(NSString*)strTitle
{
    UIView *viewItem = [[UIView alloc]init];
    viewItem.backgroundColor = [UIColor clearColor];
    viewItem.layer.borderColor = [UIColor colorWithRed:93.0 / 255.0 green:147.0 / 255.0 blue:255.0 / 255.0 alpha:1.0].CGColor;
    viewItem.layer.borderWidth = 0;
    viewItem.frame = CGRectMake(5, 0, self.view.frame.size.width - 10, self.view.frame.size.height - 140);
    
    UIImage *imgBk = [UIImage imageNamed:@"header-small"];
    imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
    
    UIImageView *imageViewTop = [[UIImageView alloc]init];
    imageViewTop.frame = CGRectMake(0, 0, CGRectGetWidth(viewItem.frame), imgBk.size.height);
    imgBk = [UIImage imageFitForSize:CGSizeMake(CGRectGetWidth(viewItem.frame), imgBk.size.height) forSourceImage:imgBk];
    [imageViewTop setImage:imgBk];
    [viewItem addSubview:imageViewTop];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 150) / 2, 5, 150, 20)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.text = strTitle;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont boldSystemFontOfSize:14];
    [viewItem addSubview:labelTitle];
    
    UILabel *labelSep = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, viewItem.frame.size.width, 1)];
    labelSep.backgroundColor = [UIColor colorWithRed:51.0 / 255.0 green:92.0 / 255.0 blue:150.0 / 255.0 alpha:1.0];
    [viewItem addSubview:labelSep];
    
    [_dicUpdateControl setObject:labelTitle forKey:@"NickName"];

    return viewItem;
}

-(UIView*)generateUserInfoView
{
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    UIView *viewUserInfo = [self generateUserContentViewItem:userInfo.nikename];
    CGRect rect = viewUserInfo.frame;
    rect.origin = CGPointMake(5, 0);
    rect.size = CGSizeMake(rect.size.width, 520);
    viewUserInfo.frame = rect;
    viewUserInfo.clipsToBounds = true;
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:viewUserInfo.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewUserInfo.bounds;
    maskLayer.path = maskPath.CGPath;
    viewUserInfo.layer.mask = maskLayer;
    [_scrollView addSubview:viewUserInfo];
    
    UIView *viewInfoBody = [[UIView alloc]initWithFrame:CGRectMake(0, 31, viewUserInfo.frame.size.width, viewUserInfo.frame.size.height - 31)];
    viewInfoBody.backgroundColor = APP_MAIN_BG_COLOR;
    [viewUserInfo addSubview:viewInfoBody];
    
    UILabel * plbSeparate1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, viewInfoBody.frame.size.width, 1)];
    plbSeparate1.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewInfoBody addSubview:plbSeparate1];
    
    UILabel * plbSeparate2 = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 1, 210)];
    plbSeparate2.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewInfoBody addSubview:plbSeparate2];
    
    UILabel * plbSeparate3 = [[UILabel alloc] initWithFrame:CGRectMake(90, 70, viewInfoBody.frame.size.width - 100, 1)];
    plbSeparate3.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewInfoBody addSubview:plbSeparate3];
    
    UILabel * plbSeparate4 = [[UILabel alloc] initWithFrame:CGRectMake((viewInfoBody.frame.size.width + 80 ) / 2, 73, 1, 24)];
    plbSeparate4.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewInfoBody addSubview:plbSeparate4];
    
    UILabel * plbSeparate5 = [[UILabel alloc] initWithFrame:CGRectMake(90, 100, viewInfoBody.frame.size.width - 100, 1)];
    plbSeparate5.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewInfoBody addSubview:plbSeparate5];
    
    UILabel * plbSeparate6 = [[UILabel alloc] initWithFrame:CGRectMake(90, 170, viewInfoBody.frame.size.width - 100, 1)];
    plbSeparate6.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewInfoBody addSubview:plbSeparate6];
    
    UILabel * plbSeparate7 = [[UILabel alloc] initWithFrame:CGRectMake(0, 280, viewInfoBody.frame.size.width, 1)];
    plbSeparate7.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [viewInfoBody addSubview:plbSeparate7];

    _imageViewUser = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
    [_imageViewUser sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image]
                   placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _imageViewUser.layer.cornerRadius = 8.0;
    _imageViewUser.clipsToBounds = YES;
    [viewInfoBody addSubview:_imageViewUser];
    
    _viewMan = [[UIView alloc]initWithFrame:CGRectMake(20, 75, 40, 18)];
    _viewWomen = [[UIView alloc]initWithFrame:CGRectMake(20, 75, 40, 18)];
    UIImage *image = [UIImage imageNamed:@"gender-male"];
    _viewMan.layer.contents = (id) image.CGImage;
    
    image = [UIImage imageNamed:@"gender-female"];
    _viewWomen.layer.contents = (id) image.CGImage;
    
    //_viewMan.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gender-male"]];
    //_viewWomen.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gender-female"]];
    [viewInfoBody addSubview:_viewMan];
    [viewInfoBody addSubview:_viewWomen];
    
    _lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_viewMan.frame) - 25, 76, 20, 14)];
    _lbAge.backgroundColor = [UIColor clearColor];
    _lbAge.textColor = [UIColor whiteColor];
    _lbAge.font = [UIFont systemFontOfSize:10];
    _lbAge.textAlignment = NSTextAlignmentRight;
    [viewInfoBody addSubview:_lbAge];
    
    NSString * strStarImage[3] = {@"level-horse", @"level-rabbit", @"level-snail"};
    for(int i = 0; i < 3; i++)
    {
        for(int j = 0; j < 4; j++)
        {
            _imgStar[i * 4 + j] = [[UIImageView alloc] initWithFrame:CGRectMake(j * 20, 95 + i * 22, 20, 20)];
            _imgStar[i * 4 + j].image = [UIImage imageNamed:strStarImage[i]];
            [viewInfoBody addSubview:_imgStar[i * 4 + j]];
            _imgStar[i * 4 + j].hidden = YES;
        }
    }
    
    UIImage * imgBK = [UIImage imageNamed:@"level-bg"];
    _imgLevelBK = [[UIImageView alloc] initWithFrame:CGRectMake(15, 165, imgBK.size.width, imgBK.size.height)];
    //imgBK = [imgBK stretchableImageWithLeftCapWidth:floorf(imgBK.size.width/2) topCapHeight:floorf(imgBK.size.height/2)];
    _imgLevelBK.image = imgBK;
    [viewInfoBody addSubview:_imgLevelBK];

    _lbLevelValue = [[UILabel alloc]initWithFrame:_imgLevelBK.frame];
    _lbLevelValue.backgroundColor = [UIColor clearColor];
    _lbLevelValue.textColor = [UIColor whiteColor];
    _lbLevelValue.font = [UIFont italicSystemFontOfSize:10];
    _lbLevelValue.textAlignment = NSTextAlignmentCenter;
    [viewInfoBody addSubview:_lbLevelValue];
    [_dicUpdateControl setObject:_lbLevelValue forKey:@"Level"];

    _lbScoreValue = [[UILabel alloc]initWithFrame:CGRectMake(0, 185, 80, 20)];
    _lbScoreValue.backgroundColor = [UIColor clearColor];
    _lbScoreValue.textColor = [UIColor colorWithRed:180 / 255.0 green:160 / 255.0 blue:40 / 255.0 alpha:1.0];
    _lbScoreValue.font = [UIFont systemFontOfSize:10];
    _lbScoreValue.textAlignment = NSTextAlignmentCenter;
    [viewInfoBody addSubview:_lbScoreValue];
    
    _viewPhone = [[UIView alloc]initWithFrame:CGRectMake(0, 205, 80, 25)];
    _viewPhone.backgroundColor = [UIColor clearColor];
    [viewInfoBody addSubview:_viewPhone];
    
    UIImageView *imgPhoneVer = [[UIImageView alloc]initWithFrame:CGRectMake(5, 3, 11, 19)];
    imgPhoneVer.backgroundColor = [UIColor clearColor];
    [imgPhoneVer setImage:[UIImage imageNamed:@"phone-verified-bigger"]];
    [_viewPhone addSubview:imgPhoneVer];
    
    UILabel *lbPhone = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgPhoneVer.frame), 3, CGRectGetWidth(_viewPhone.frame) - CGRectGetMaxX(imgPhoneVer.frame), 19)];
    lbPhone.backgroundColor = [UIColor clearColor];
    lbPhone.textColor = [UIColor darkGrayColor];
    lbPhone.font = [UIFont boldSystemFontOfSize:12];
    lbPhone.textAlignment = NSTextAlignmentCenter;
    lbPhone.text = @"已手机认证";
    [_viewPhone addSubview:lbPhone];
    
    _viewPhone.hidden = userInfo.phone_number.length > 0 ? NO : YES;
    
    for(int i = 0; i < 4; i++)
    {
        int nRectWidth = 48;
        _imgPrivatePicture[i] = [[UIImageView alloc] initWithFrame:CGRectMake(90 + (nRectWidth + 5) * i, 10, nRectWidth, nRectWidth)];
        _imgPrivatePicture[i].contentMode = UIViewContentModeScaleAspectFit;
        
        _imgPriPicFrame[i] = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imgPrivatePicture[i].frame) - 1, CGRectGetMinY(_imgPrivatePicture[i].frame) - 1, CGRectGetWidth(_imgPrivatePicture[i].frame) + 2, CGRectGetHeight(_imgPrivatePicture[i].frame) + 2)];
        _imgPriPicFrame[i].backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
        _imgPriPicFrame[i].layer.borderWidth = 1.0;
        _imgPriPicFrame[i].layer.borderColor = [[UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1] CGColor];
        
        [viewInfoBody addSubview:_imgPrivatePicture[i]];
        [viewInfoBody addSubview:_imgPriPicFrame[i]];
        [viewInfoBody bringSubviewToFront:_imgPrivatePicture[i]];
        
        _btnPrivate[i] = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnPrivate[i].frame = _imgPriPicFrame[i].frame;
        _btnPrivate[i].backgroundColor = [UIColor clearColor];
        
        __weak __typeof(self) weakSelf = self;
        
        _btnPrivate[i].actionBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            [strongSelf onClickImageViewByIndex:i];
        };
        
        _imgPrivatePicture[i].hidden = YES;
        _imgPriPicFrame[i].hidden = YES;
        _btnPrivate[i].hidden = YES;
        
        [viewInfoBody addSubview:_btnPrivate[i]];
        [viewInfoBody bringSubviewToFront:_btnPrivate[i]];
    }
    
    _viewNoPrivatePicture = [[UIView alloc] initWithFrame:CGRectMake(85, 5, 220, 60)];
    _viewNoPrivatePicture.backgroundColor = [UIColor clearColor];
    [viewInfoBody addSubview:_viewNoPrivatePicture];
    
    UIImageView * imgLazyMan = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    imgLazyMan.image = [UIImage imageNamed:@"lanhan"];
    [_viewNoPrivatePicture addSubview:imgLazyMan];
    
    UILabel * lbLackImage1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 160, 20)];
    lbLackImage1.backgroundColor = [UIColor clearColor];
    lbLackImage1.textColor = [UIColor grayColor];
    lbLackImage1.font = [UIFont boldSystemFontOfSize:12];
    lbLackImage1.text = @"亲，您还没有上传生活照哦。";
    [_viewNoPrivatePicture addSubview:lbLackImage1];
    
    UILabel * lbLackImage2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 160, 20)];
    lbLackImage2.backgroundColor = [UIColor clearColor];
    lbLackImage2.textColor = [UIColor blueColor];
    lbLackImage2.font = [UIFont boldSystemFontOfSize:12];
    lbLackImage2.text = @"点击，消灭自己懒汉形象";
    [_viewNoPrivatePicture addSubview:lbLackImage2];
    
    CSButton * btnSelectImage = [CSButton buttonWithType:UIButtonTypeCustom];
    btnSelectImage.frame = _viewNoPrivatePicture.bounds;
    [_viewNoPrivatePicture addSubview:btnSelectImage];
    
    UILabel *_lbAttention = [[UILabel alloc] initWithFrame:CGRectMake(90, 75, 45, 20)];
    _lbAttention.backgroundColor = [UIColor clearColor];
    _lbAttention.textColor = [UIColor blueColor];
    _lbAttention.text = @"关注：";
    _lbAttention.font = [UIFont boldSystemFontOfSize:14];
    [viewInfoBody addSubview:_lbAttention];
    
    UILabel *_lbFan = [[UILabel alloc] initWithFrame:CGRectMake(plbSeparate4.frame.origin.x + 10, 75, 45, 20)];
    _lbFan.backgroundColor = [UIColor clearColor];
    _lbFan.textColor = [UIColor blueColor];
    _lbFan.text = @"粉丝：";
    _lbFan.font = [UIFont boldSystemFontOfSize:14];
    [viewInfoBody addSubview:_lbFan];
    
    _lbAttentionValue = [[UILabel alloc] initWithFrame:CGRectMake(130, 75, 45, 20)];
    _lbAttentionValue.backgroundColor = [UIColor clearColor];
    _lbAttentionValue.textColor = [UIColor blueColor];
    _lbAttentionValue.text = [NSString stringWithFormat:@"%ld", userInfo.attention_count];
    _lbAttentionValue.font = [UIFont boldSystemFontOfSize:14];
    [viewInfoBody addSubview:_lbAttentionValue];
    
    _lbFanValue = [[UILabel alloc] initWithFrame:CGRectMake(plbSeparate4.frame.origin.x + 50, 75, 45, 20)];
    _lbFanValue.backgroundColor = [UIColor clearColor];
    _lbFanValue.textColor = [UIColor blueColor];
    _lbFanValue.text = [NSString stringWithFormat:@"%ld", userInfo.fans_count];
    _lbFanValue.font = [UIFont boldSystemFontOfSize:14];
    [viewInfoBody addSubview:_lbFanValue];
    
    CSButton *btnAttention = [CSButton buttonWithType:UIButtonTypeCustom];
    btnAttention.frame = CGRectMake(CGRectGetMinX(_lbAttention.frame), 75, CGRectGetMaxX(_lbAttentionValue.frame) - CGRectGetMinX(_lbAttention.frame), 20);
    [viewInfoBody addSubview:btnAttention];
    [viewInfoBody bringSubviewToFront:btnAttention];
    
    __weak typeof (self) thisPoint = self;
    
    btnAttention.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        UserInfo *accountInfo = [[ApplicationContext sharedInstance]accountInfo];
        RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
        relatedPeoplesViewController.eRelatedType = e_related_people_attention;
        relatedPeoplesViewController.strUserId = accountInfo.userid;
        [thisStrongPoint.navigationController pushViewController:relatedPeoplesViewController animated:YES];
    };
    
    CSButton *btnFans = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFans.frame = CGRectMake(CGRectGetMinX(_lbFan.frame), 75, CGRectGetMaxX(_lbFanValue.frame) - CGRectGetMinX(_lbFan.frame), 20);
    [viewInfoBody addSubview:btnFans];
    [viewInfoBody bringSubviewToFront:btnFans];
    
    btnFans.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        UserInfo *accountInfo = [[ApplicationContext sharedInstance]accountInfo];
        RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
        relatedPeoplesViewController.eRelatedType = e_related_people_fans;
        relatedPeoplesViewController.strUserId = accountInfo.userid;
        [thisStrongPoint.navigationController pushViewController:relatedPeoplesViewController animated:YES];
    };
    
    UILabel * lbEquipmentTitle = [[UILabel alloc] initWithFrame:CGRectMake(90, 105, 45, 20)];
    lbEquipmentTitle.backgroundColor = [UIColor clearColor];
    lbEquipmentTitle.textColor = [UIColor blackColor];
    lbEquipmentTitle.text = @"装备：";
    lbEquipmentTitle.font = [UIFont boldSystemFontOfSize:14];
    [viewInfoBody addSubview:lbEquipmentTitle];
    
    UIImageView * imgRing = [[UIImageView alloc] initWithFrame:CGRectMake(130, 105, 21, 21)];
    imgRing.image = [UIImage imageNamed:@"equipment-wearable"];
    [viewInfoBody addSubview:imgRing];
    
    UIImageView * imgShoes = [[UIImageView alloc] initWithFrame:CGRectMake(130, 125, 21, 21)];
    imgShoes.image = [UIImage imageNamed:@"equipment-shoe"];
    [viewInfoBody addSubview:imgShoes];
    
    UIImageView * imgPhone = [[UIImageView alloc] initWithFrame:CGRectMake(130, 145, 21, 21)];
    imgPhone.image = [UIImage imageNamed:@"equipment-software"];
    [viewInfoBody addSubview:imgPhone];
    
    _lbRingValue = [[UILabel alloc] initWithFrame:CGRectMake(155, 105, viewInfoBody.frame.size.width - 160, 20)];
    _lbRingValue.backgroundColor = [UIColor clearColor];
    _lbRingValue.textColor = [UIColor blackColor];
    _lbRingValue.font = [UIFont boldSystemFontOfSize:14];
    [viewInfoBody addSubview:_lbRingValue];
    
    _lbShoesValue = [[UILabel alloc] initWithFrame:CGRectMake(155, 125, viewInfoBody.frame.size.width - 160, 20)];
    _lbShoesValue.backgroundColor = [UIColor clearColor];
    _lbShoesValue.textColor = [UIColor blackColor];
    _lbShoesValue.font = [UIFont boldSystemFontOfSize:14];
    [viewInfoBody addSubview:_lbShoesValue];
    
    _lbPhoneValue = [[UILabel alloc] initWithFrame:CGRectMake(155, 145, viewInfoBody.frame.size.width - 160, 20)];
    _lbPhoneValue.backgroundColor = [UIColor clearColor];
    _lbPhoneValue.textColor = [UIColor blackColor];
    _lbPhoneValue.font = [UIFont boldSystemFontOfSize:14];
    [viewInfoBody addSubview:_lbPhoneValue];
    
    /*
    UIImageView * imgLoc = [[UIImageView alloc] initWithFrame:CGRectMake(90, 180, 17, 17)];
    imgLoc.image = [UIImage imageNamed:@"location-icon"];
    [viewInfoBody addSubview:imgLoc];
    
    UILabel * lbLoc = [[UILabel alloc] initWithFrame:CGRectMake(120, 180, viewInfoBody.frame.size.width - 130, 20)];
    lbLoc.backgroundColor = [UIColor clearColor];
    lbLoc.text = @"1分钟前，距离00公里";
    lbLoc.font = [UIFont boldSystemFontOfSize:14];
    [viewInfoBody addSubview:lbLoc];*/
    
    _lbLastLogin = [[UILabel alloc] initWithFrame:CGRectMake(90, 180, viewInfoBody.frame.size.width - 95, 20)];
    _lbLastLogin.backgroundColor = [UIColor clearColor];
    _lbLastLogin.textColor = [UIColor blackColor];
    _lbLastLogin.font = [UIFont boldSystemFontOfSize:13];
    [self handleUpdateLoginTime];
    [viewInfoBody addSubview:_lbLastLogin];
    
    CSButton *btnDiagram = [CSButton buttonWithType:UIButtonTypeCustom];
    btnDiagram.frame = CGRectMake(16, 217, 57, 57);
    [btnDiagram setBackgroundImage:[UIImage imageNamed:@"me-data"] forState:UIControlStateNormal];
    [viewInfoBody addSubview:btnDiagram];
    
    CSButton *btnWallet = [CSButton buttonWithType:UIButtonTypeCustom];
    btnWallet.frame = CGRectMake(92, 217, 57, 57);
    [btnWallet setBackgroundImage:[UIImage imageNamed:@"me-wallet"] forState:UIControlStateNormal];
    [viewInfoBody addSubview:btnWallet];
    
    CSButton *btnHistory = [CSButton buttonWithType:UIButtonTypeCustom];
    btnHistory.frame = CGRectMake(168, 217, 57, 57);
    [btnHistory setBackgroundImage:[UIImage imageNamed:@"me-history"] forState:UIControlStateNormal];
    [viewInfoBody addSubview:btnHistory];
    
    CSButton *btnSetting = [CSButton buttonWithType:UIButtonTypeCustom];
    btnSetting.frame = CGRectMake(242, 217, 57, 57);
    [btnSetting setBackgroundImage:[UIImage imageNamed:@"me-settings"] forState:UIControlStateNormal];
    [viewInfoBody addSubview:btnSetting];
    
    UIImage * imgBlogTabLeft = [UIImage imageNamed:@"blog-tab-left"];
    UIImage * imgBlogTabLeftSel = [UIImage imageNamed:@"blog-tab-left-sel"];
    UIImage * imgBlogTabRight = [UIImage imageNamed:@"blog-tab-right"];
    UIImage * imgBlogTabRightSel = [UIImage imageNamed:@"blog-tab-right-sel"];
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 5, 5, 5);
    imgBlogTabLeft = [imgBlogTabLeft resizableImageWithCapInsets:insets];
    imgBlogTabLeftSel = [imgBlogTabLeftSel resizableImageWithCapInsets:insets];
    imgBlogTabRight = [imgBlogTabRight resizableImageWithCapInsets:insets];
    imgBlogTabRightSel = [imgBlogTabRightSel resizableImageWithCapInsets:insets];
    
    CSButton *btnMyBlog = [CSButton buttonWithType:UIButtonTypeCustom];
    btnMyBlog.frame = CGRectMake(viewInfoBody.frame.size.width / 2 - 100, 290, 100, 23);
    [btnMyBlog setTitle:@"我的博文" forState:UIControlStateNormal];
    [btnMyBlog.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [btnMyBlog setBackgroundImage:imgBlogTabLeft forState:UIControlStateNormal];
    [btnMyBlog setBackgroundImage:imgBlogTabLeftSel forState:UIControlStateSelected];
    [btnMyBlog setTitleColor:[UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnMyBlog setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnMyBlog setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [viewInfoBody addSubview:btnMyBlog];
    
    CSButton *btnMyReply = [CSButton buttonWithType:UIButtonTypeCustom];
    btnMyReply.frame = CGRectMake(viewInfoBody.frame.size.width / 2, 290, 100, 23);
    [btnMyReply setTitle:@"我的回复" forState:UIControlStateNormal];
    [btnMyReply.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [btnMyReply setBackgroundImage:imgBlogTabRight forState:UIControlStateNormal];
    [btnMyReply setBackgroundImage:imgBlogTabRightSel forState:UIControlStateSelected];
    [btnMyReply setTitleColor:[UIColor colorWithRed:141 / 255.0 green:78 / 255.0 blue:4 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [btnMyReply setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btnMyReply setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [viewInfoBody addSubview:btnMyReply];
    
    //For Test
    _gridView = [[SFGridView alloc]initWithFrame:CGRectMake(10, 320, 290, 150)];
    _gridView.backgroundColor = [UIColor clearColor];
    //[_gridView setDirection:1];
    //[_gridView setColumnCount:1];
    //_gridView.frame = CGRectMake(10, 470, 290, 150);
    [viewInfoBody addSubview: _gridView];
    
    btnSelectImage.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        SettingsViewController *settingsViewController = [[SettingsViewController alloc]init];
        [settingsViewController setType:SETTING_TYPE_IMAGE];
        [settingsViewController setUserLifePhotos];
        [thisStrongPoint.navigationController pushViewController:settingsViewController animated:YES];
    };

    btnDiagram.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        UserFitnessDataViewController *userFitnessDataViewController = [[UserFitnessDataViewController alloc]init];
        [thisStrongPoint.navigationController pushViewController:userFitnessDataViewController animated:YES];
    };
    
    btnWallet.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        WalletViewController *walletViewController = [[WalletViewController alloc]init];
        [thisStrongPoint.navigationController pushViewController:walletViewController animated:YES];
    };
    
    btnHistory.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        UserInfo *accountInfo = [[ApplicationContext sharedInstance]accountInfo];
        HistoryViewController *historyViewController = [[HistoryViewController alloc]init];
        [historyViewController setHistoryType:HISTORY_TYPE_ALL];
        historyViewController.userInfo = accountInfo;
        [thisStrongPoint.navigationController pushViewController:historyViewController animated:YES];
    };
    
    btnSetting.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        SettingMainViewController *settingMainViewController = [[SettingMainViewController alloc]init];
        [thisStrongPoint.navigationController pushViewController:settingMainViewController animated:YES];
    };
    
    __typeof__(CSButton) __weak *thisbtnMyBlog = btnMyBlog;
    __typeof__(CSButton) __weak *thisbtnMyReply = btnMyReply;
    btnMyBlog.selected = true;
    btnMyReply.selected = false;
    btnMyBlog.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        typeof(CSButton) *thisStrongbtnMyBlog = thisbtnMyBlog;
        typeof(CSButton) *thisStrongbtnMyReply = thisbtnMyReply;
        if(thisbtnMyReply.selected)
        {
            thisStrongbtnMyBlog.selected = true;
            thisStrongbtnMyReply.selected = false;
        }
        
        thisStrongPoint->_bArticleComment = NO;
        [thisStrongPoint viewDidLoadData:@"" LastPageId:@"" IsArticleComments:NO];
    };
    btnMyReply.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        typeof(CSButton) *thisStrongbtnMyBlog = thisbtnMyBlog;
        typeof(CSButton) *thisStrongbtnMyReply = thisbtnMyReply;
        if(thisbtnMyBlog.selected)
        {
            thisStrongbtnMyReply.selected = true;
            thisStrongbtnMyBlog.selected = false;
        }
        
        thisStrongPoint->_bArticleComment = YES;
        [thisStrongPoint viewDidLoadData:@"" LastPageId:@"" IsArticleComments:YES];
    };

    return viewUserInfo;
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

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

-(void)handleUpdateLoginTime
{
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    long long lLastTime = [delegate.mainNavigationController getLastLoginTime];
    _lbLastLogin.text = lLastTime > 0 ? [NSString stringWithFormat:@"最近登录：%@", [[CommonUtility sharedInstance]compareLastLoginTime:[NSDate dateWithTimeIntervalSince1970:lLastTime]]] : @"无数据";
}

-(void)handleUpdateProfileInfo:(NSNotification*) notification
{
    BOOL bUpdateArticle = NO;
    bUpdateArticle = [[notification.userInfo objectForKey:@"UpdateArticle"]boolValue];
    
    if (bUpdateArticle) {
        [self viewDidLoadData:@"" LastPageId:@"" IsArticleComments:_bArticleComment];
    }
    
    UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if(userInfo.userid.length > 0)
    {
        UILabel *lbPhysique = [_dicUpdateControl objectForKey:@"体魄"];
        lbPhysique.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.physique_value];
        
        UILabel *lbLiterature = [_dicUpdateControl objectForKey:@"文学"];
        lbLiterature.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.literature_value];
        
        UILabel *lbMagic = [_dicUpdateControl objectForKey:@"魔法"];
        lbMagic.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.magic_value];
        
        UILabel *lbCoin = [_dicUpdateControl objectForKey:@"贝币"];
        lbCoin.text = [NSString stringWithFormat:@"%lld", userInfo.proper_info.coin_value / 100000000];
        
        UILabel *lbNickName = [_dicUpdateControl objectForKey:@"NickName"];
        lbNickName.text = userInfo.nikename;
        
        UILabel *lbLevel = [_dicUpdateControl objectForKey:@"Level"];
        lbLevel.text = [NSString stringWithFormat:@"LV.%ld", userInfo.proper_info.rankLevel];
        
        [_imageViewUser sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image]
                    placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        
        NSDate * dateBirthday = [NSDate dateWithTimeIntervalSince1970:userInfo.birthday];
        NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dateBirthday];
        NSInteger birthdayYear = [comps year];
        NSDateComponents * comps2 =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
        NSInteger year = [comps2 year];
        _lbAge.text = [NSString stringWithFormat:@"%ld", year - birthdayYear];
        
        _lbLevelValue.text = [NSString stringWithFormat:@"LV. %ld", userInfo.proper_info.rankLevel];
        NSUInteger nLevel = userInfo.proper_info.rankLevel;
        NSUInteger nHorseCount = nLevel / 25;
        NSUInteger nRabbitCount = (nLevel - nHorseCount * 25) / 5;
        NSUInteger nSnailCount = nLevel - nHorseCount * 25 - nRabbitCount * 5;
        NSUInteger nButtonStartPoint = _imgStar[0].frame.origin.y;
        for(NSUInteger i = 0; i < 4; i++)
        {
            _imgStar[i].hidden = (i >= nHorseCount);
            _imgStar[4 + i].hidden = (i >= nRabbitCount);
            _imgStar[8 + i].hidden = (i >= nSnailCount);
            CGRect rectStar = _imgStar[i].frame;
            if(nHorseCount != 0)
            {
                rectStar.origin.y += 22;
            }
            _imgStar[4 + i].frame = rectStar;
            if(nRabbitCount != 0)
            {
                rectStar.origin.y += 22;
            }
            _imgStar[8 + i].frame = rectStar;
        }
        if(nHorseCount != 0)
        {
            nButtonStartPoint += 22;
        }
        if(nRabbitCount != 0)
        {
            nButtonStartPoint += 22;
        }
        if(nSnailCount != 0)
        {
            nButtonStartPoint += 22;
        }
        
        _imgLevelBK.frame = CGRectMake(_imgLevelBK.frame.origin.x, nButtonStartPoint + 4, _imgLevelBK.frame.size.width, _imgLevelBK.frame.size.height);
        _lbLevelValue.frame = _imgLevelBK.frame;
        _lbScoreValue.frame = CGRectMake(_lbScoreValue.frame.origin.x, _lbLevelValue.frame.origin.y + 20, _lbScoreValue.frame.size.width, _lbScoreValue.frame.size.height);
        _lbScoreValue.text = [NSString stringWithFormat:@"总分：%ld", userInfo.proper_info.rankscore];
        _viewPhone.frame = CGRectMake(_viewPhone.frame.origin.x, _lbScoreValue.frame.origin.y + 20, _viewPhone.frame.size.width, _viewPhone.frame.size.height);
        _viewPhone.hidden = userInfo.phone_number.length > 0 ? NO : YES;
        
        _lbAttentionValue.text = [NSString stringWithFormat:@"%ld", userInfo.attention_count];
        _lbFanValue.text = [NSString stringWithFormat:@"%ld", userInfo.fans_count];

        [_imgUrlArray removeAllObjects];
        [_imgUrlArray addObjectsFromArray:userInfo.user_images.data];
        
        NSUInteger nImageCount = userInfo.user_images.data.count;
        if(nImageCount > 4)
        {
            nImageCount = 4;
        }
        for(NSUInteger i = 0; i < nImageCount; i++)
        {
            _btnPrivate[i].hidden = NO;
            _imgPrivatePicture[i].hidden = NO;
            _imgPriPicFrame[i].hidden = NO;
            [_imgPrivatePicture[i] sd_setImageWithURL:[NSURL URLWithString:userInfo.user_images.data[i]]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        }
        
        for(NSUInteger i = nImageCount; i < 4; i++)
        {
            _imgPrivatePicture[i].hidden = YES;
            _imgPriPicFrame[i].hidden = YES;
            _btnPrivate[i].hidden = YES;
        }
        _viewNoPrivatePicture.hidden = (nImageCount != 0);
        if(userInfo.user_equipInfo.ele_product.data.count)
        {
            _lbRingValue.textColor = [UIColor blackColor];
            _lbRingValue.text = userInfo.user_equipInfo.ele_product.data[0];
        }
        else
        {
            _lbRingValue.text = @"";
        }
        if([_lbRingValue.text isEqualToString:@""])
        {
            _lbRingValue.textColor = [UIColor grayColor];
            _lbRingValue.text = @"无可穿戴设备";
        }
        if(userInfo.user_equipInfo.run_shoe.data.count)
        {
            _lbShoesValue.textColor = [UIColor blackColor];
            _lbShoesValue.text = userInfo.user_equipInfo.run_shoe.data[0];
        }
        else
        {
            _lbShoesValue.text = @"";
        }
        if([_lbShoesValue.text isEqualToString:@""])
        {
            _lbShoesValue.textColor = [UIColor grayColor];
            _lbShoesValue.text = @"无运动跑鞋";
        }
        if(userInfo.user_equipInfo.step_tool.data.count)
        {
            _lbPhoneValue.textColor = [UIColor blackColor];
            _lbPhoneValue.text = userInfo.user_equipInfo.step_tool.data[0];
        }
        else
        {
            _lbPhoneValue.text = @"";
        }
        if([_lbPhoneValue.text isEqualToString:@""])
        {
            _lbPhoneValue.textColor = [UIColor grayColor];
            _lbPhoneValue.text = @"未安装健身应用";
        }

        if([userInfo.sex_type isEqualToString:@"male"])
        {
            _viewMan.hidden = NO;
            _viewWomen.hidden = YES;
        }
        else
        {
            _viewMan.hidden = YES;
            _viewWomen.hidden = NO;
        }
    }
}

@end