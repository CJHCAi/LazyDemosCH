//
//  FriendInfoViewController.m
//  SportForum
//
//  Created by zyshi on 14-9-28.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "FriendInfoViewController.h"
#import "SFGridView.h"
#import "WallCell.h"
#import "ArticlePagesViewController.h"
#import "CSButton.h"
#import "AlertManager.h"
#import "UIViewController+SportFormu.h"
#import "UIImageView+WebCache.h"
#import "HistoryViewController.h"
#import "MBProgressHUD.h"
#import "ChatMessageTableViewController.h"
#import "RelatedPeoplesViewController.h"
#import "MWPhotoBrowser.h"

@interface FriendInfoViewController () <MBProgressHUDDelegate, SFGridViewDelegate, MWPhotoBrowserDelegate>

@end

@implementation FriendInfoViewController
{
    NSMutableDictionary * _dicUpdateControl;
    UIScrollView *_scrollView;
    UIImageView *_imageViewUser;
    UIView *_viewMan;
    UIView *_viewWomen;
    UILabel *_lbAge;
    UIView *_viewPhone;
    UIImageView * _imgStar[12];
    UIImageView * _imgLevelBK;
    UILabel *_lbLevelValue;
    UILabel *_lbScoreValue;
    CSButton *_btnHistory;
    UIImageView *_imgPrivatePicture[4];
    UIView *_imgPriPicFrame[4];
    CSButton *_btnPrivate[4];
    UIView *_viewNoPrivatePicture;
    UILabel *_lbAttentionValue;
    UILabel *_lbFanValue;
    UILabel *_lbRingValue;
    UILabel *_lbShoesValue;
    UILabel *_lbPhoneValue;
    UILabel *_lbTotalDistanceValue;
    UILabel *_lbMaxforDayValue;
    UILabel *_lbFastestSpeedValue;
    UILabel *_lbLoc;
    UILabel *_lbHisBlog;
    UILabel *_lbBlogCount;
    CSButton *_btnBlackList;
    CSButton *_btnAttention;
    CSButton *_btnChat;
    MBProgressHUD * _HUD;
    
    NSString * _strUserID;
    UserInfo *_userInfo;
    NSMutableArray *_arrayForumDatas;
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _photos;
    SFGridView* _gridView;
    
    NSString *_strFirstPageId;
    NSString *_strLastPageId;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _strUserID = @"";
        _strFirstPageId = @"";
        _strLastPageId = @"";
        _arrayForumDatas = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dicUpdateControl = [[NSMutableDictionary alloc]init];
    _photos = [[NSMutableArray alloc]init];
    _imgUrlArray = [[NSMutableArray alloc]init];
    
    [self generateCommonViewInParent:self.view Title:@"" IsNeedBackBtn:YES];
    
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

    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame) - 44)];
    [viewBody addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, 520);

    [self generateUserTitleView];
    [self generateUserInfoView];
    [self viewLoadGirdTable];
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [viewBody addSubview:_HUD];
    [viewBody bringSubviewToFront:_HUD];
    _HUD.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshInfo];
    
    //Load Data
    _strFirstPageId = @"";
    _strLastPageId = @"";
    [self viewDidLoadData:_strFirstPageId LastPageId:_strLastPageId];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlRecordStatistics, urlUserArticles, nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"FriendInfoViewController dealloc called!");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setID:(NSString *)strID
{
    _strUserID = strID;
    //[self refreshInfo];
}

-(void)viewLoadGirdTable
{
    _arrayForumDatas = [[NSMutableArray alloc]init];
    
    _gridView.gridViewDelegate = self;
    [_gridView enablePullRefreshHeaderViewTarget:self DidTriggerRefreshAction:@selector(actionPullHeaderRefresh)];
    [_gridView enablePullRefreshFooterViewTarget:self DidTriggerRefreshAction:@selector(actionPullFooterRefresh)];
    [_gridView.tableFooterActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    
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
    [self viewDidLoadData:_strFirstPageId LastPageId:@""];
}

-(void)actionPullFooterRefresh {
    NSLog(@"loading footer.....");
    [self viewDidLoadData:@"" LastPageId:_strLastPageId];
}

-(void)viewDidLoadData:(NSString*)strFirstrPageId LastPageId:(NSString*)strLastPageId
{
    __weak __typeof(self) weakSelf = self;
        
    [[SportForumAPI sharedInstance]userArticlesByUserId:_strUserID ArticleType:article_type_articles FirstPageId:strFirstrPageId LastPageId:strLastPageId PageItemNum:4 FinishedBlock:^void(int errorCode, ArticlesInfo *articlesInfo){
        __typeof(self) strongSelf = weakSelf;
        
        if (strongSelf == nil) {
            return;
        }
        
        [_gridView completePullHeaderRefresh];
        [_gridView completePullFooterRefresh];
        
        if (errorCode == 0 && [articlesInfo.articles_without_content.data count] > 0) {
            if (strFirstrPageId.length == 0 && strLastPageId.length == 0) {
                [_arrayForumDatas removeAllObjects];
                
                _strFirstPageId = articlesInfo.page_frist_id;
                _strLastPageId = articlesInfo.page_last_id;
                _arrayForumDatas = articlesInfo.articles_without_content.data;
            }
            else if (strFirstrPageId.length == 0 && strLastPageId.length > 0)
            {
                _strLastPageId = articlesInfo.page_last_id;
                
                for (ArticlesObject *articlesObject in articlesInfo.articles_without_content.data) {
                    [_arrayForumDatas addObject:articlesObject];
                }
            }
            else if(strFirstrPageId.length > 0 && strLastPageId.length == 0)
            {
                _strFirstPageId = articlesInfo.page_frist_id;
                
                for (ArticlesObject *articlesObject in articlesInfo.articles_without_content.data) {
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

-(UIView*)generateUserTitleViewItem:(NSString*)strTitle ScoreValue:(NSString*)strScoreValue
{
    UIView* viewItem = [[UIView alloc]init];
    
    UIImageView *viewImage = [[UIImageView alloc]init];
    viewImage.frame = CGRectMake(10, 5, 15, 15);
    [viewItem addSubview:viewImage];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 30, 10)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.text = strTitle;
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.font = [UIFont boldSystemFontOfSize:11];
    [viewItem addSubview:labelTitle];
    
    UILabel *labelScore = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(labelTitle.frame) + 5, 35, 10)];
    labelScore.backgroundColor = [UIColor clearColor];
    labelScore.textColor = [UIColor whiteColor];
    labelScore.text = strScoreValue;
    labelScore.textAlignment = NSTextAlignmentRight;
    labelScore.font = [UIFont systemFontOfSize:11];
    labelScore.tag = 10;
    [viewItem addSubview:labelScore];
    
    viewItem.frame = CGRectMake(0, 0, 70, 35);
    [_dicUpdateControl setObject:labelScore forKey:strTitle];
    
    return viewItem;
}

-(void)generateUserTitleView
{
    UIView *viewSport = [self generateUserTitleViewItem:@"体魄" ScoreValue:@"0"];
    CGRect rect = viewSport.frame;
    rect.origin = CGPointMake(4, 5);
    viewSport.frame = rect;
    UIImage *image = [UIImage imageNamed:@"others-status-body"];
    viewSport.layer.contents = (id) image.CGImage;
    //viewSport.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"others-status-body"]];
    [_scrollView addSubview:viewSport];
    
    UIView *viewLiterature = [self generateUserTitleViewItem:@"文学" ScoreValue:@"0"];
    rect = viewLiterature.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewSport.frame) + 6, 5);
    viewLiterature.frame = rect;
    image = [UIImage imageNamed:@"others-status-blog"];
    viewLiterature.layer.contents = (id) image.CGImage;
    //viewLiterature.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"others-status-blog"]];
    [_scrollView addSubview:viewLiterature];
    
    UIView *viewMagic = [self generateUserTitleViewItem:@"魔法" ScoreValue:@"0"];
    rect = viewMagic.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewLiterature.frame) + 6, 5);
    viewMagic.frame = rect;
    image = [UIImage imageNamed:@"others-status-magic"];
    viewMagic.layer.contents = (id) image.CGImage;
    //viewMagic.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"others-status-magic"]];
    [_scrollView addSubview:viewMagic];
    
    UIView *viewBtc = [self generateUserTitleViewItem:@"贝币" ScoreValue:@"0"];
    rect = viewBtc.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewMagic.frame) + 6, 5);
    viewBtc.frame = rect;
    image = [UIImage imageNamed:@"others-status-money"];
    viewBtc.layer.contents = (id) image.CGImage;
    //viewBtc.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"others-status-money"]];
    [_scrollView addSubview:viewBtc];
}

-(void)generateUserInfoView
{
    UILabel * plbSeparate0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, _scrollView.frame.size.width, 1)];
    plbSeparate0.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [_scrollView addSubview:plbSeparate0];
    
    UILabel * plbSeparate1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 330, _scrollView.frame.size.width, 1)];
    plbSeparate1.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [_scrollView addSubview:plbSeparate1];
    
    UILabel * plbSeparate2 = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 1, 280)];
    plbSeparate2.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [_scrollView addSubview:plbSeparate2];
    
    UILabel * plbSeparate3 = [[UILabel alloc] initWithFrame:CGRectMake(90, 120, _scrollView.frame.size.width - 100, 1)];
    plbSeparate3.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [_scrollView addSubview:plbSeparate3];
    
    UILabel * plbSeparate4 = [[UILabel alloc] initWithFrame:CGRectMake((_scrollView.frame.size.width + 80 ) / 2, 123, 1, 24)];
    plbSeparate4.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [_scrollView addSubview:plbSeparate4];
    
    UILabel * plbSeparate5 = [[UILabel alloc] initWithFrame:CGRectMake(90, 150, _scrollView.frame.size.width - 100, 1)];
    plbSeparate5.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [_scrollView addSubview:plbSeparate5];
    
    UILabel * plbSeparate6 = [[UILabel alloc] initWithFrame:CGRectMake(90, 220, _scrollView.frame.size.width - 100, 1)];
    plbSeparate6.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [_scrollView addSubview:plbSeparate6];
    
    UILabel * plbSeparate7 = [[UILabel alloc] initWithFrame:CGRectMake(90, 290, _scrollView.frame.size.width - 100, 1)];
    plbSeparate7.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:201 / 255.0 alpha:1];
    [_scrollView addSubview:plbSeparate7];
    
    _imageViewUser = [[UIImageView alloc]initWithFrame:CGRectMake(10, 60, 60, 60)];
    _imageViewUser.layer.cornerRadius = 8.0;
    _imageViewUser.clipsToBounds = YES;
    [_scrollView addSubview:_imageViewUser];
    
    _viewMan = [[UIView alloc]initWithFrame:CGRectMake(20, 125, 40, 18)];
    _viewWomen = [[UIView alloc]initWithFrame:CGRectMake(20, 125, 40, 18)];
    UIImage *image = [UIImage imageNamed:@"gender-male"];
    _viewMan.layer.contents = (id) image.CGImage;
    
    image = [UIImage imageNamed:@"gender-female"];
    _viewWomen.layer.contents = (id) image.CGImage;
    
    //_viewMan.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gender-male"]];
    //_viewWomen.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gender-female"]];
    [_scrollView addSubview:_viewMan];
    [_scrollView addSubview:_viewWomen];
    
    _lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_viewMan.frame) - 25, 126, 20, 14)];
    _lbAge.backgroundColor = [UIColor clearColor];
    _lbAge.textColor = [UIColor whiteColor];
    _lbAge.font = [UIFont systemFontOfSize:10];
    _lbAge.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_lbAge];
    
    NSString * strStarImage[3] = {@"level-horse", @"level-rabbit", @"level-snail"};
    for(int i = 0; i < 3; i++)
    {
        for(int j = 0; j < 4; j++)
        {
            _imgStar[i * 4 + j] = [[UIImageView alloc] initWithFrame:CGRectMake(j * 20, 145 + i * 22, 20, 20)];
            _imgStar[i * 4 + j].image = [UIImage imageNamed:strStarImage[i]];
            [_scrollView addSubview:_imgStar[i * 4 + j]];
            _imgStar[i * 4 + j].hidden = YES;
        }
    }
    
    UIImage * imgBK = [UIImage imageNamed:@"level-bg"];
    _imgLevelBK = [[UIImageView alloc] initWithFrame:CGRectMake(15, 215, imgBK.size.width, imgBK.size.height)];
    //imgBK = [imgBK stretchableImageWithLeftCapWidth:floorf(imgBK.size.width/2) topCapHeight:floorf(imgBK.size.height/2)];
    _imgLevelBK.image = imgBK;
    [_scrollView addSubview:_imgLevelBK];
    
    _lbLevelValue = [[UILabel alloc]initWithFrame:_imgLevelBK.frame];
    _lbLevelValue.backgroundColor = [UIColor clearColor];
    _lbLevelValue.textColor = [UIColor whiteColor];
    _lbLevelValue.font = [UIFont italicSystemFontOfSize:10];
    _lbLevelValue.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_lbLevelValue];
    [_dicUpdateControl setObject:_lbLevelValue forKey:@"Level"];
    
    _lbScoreValue = [[UILabel alloc]initWithFrame:CGRectMake(0, 235, 80, 20)];
    _lbScoreValue.backgroundColor = [UIColor clearColor];
    _lbScoreValue.textColor = [UIColor colorWithRed:180 / 255.0 green:160 / 255.0 blue:40 / 255.0 alpha:1.0];
    _lbScoreValue.font = [UIFont boldSystemFontOfSize:12];
    _lbScoreValue.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:_lbScoreValue];
    
    _viewPhone = [[UIView alloc]initWithFrame:CGRectMake(0, 255, 80, 25)];
    _viewPhone.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_viewPhone];
    
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
    
    _viewPhone.hidden = YES;
    
    _btnHistory = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnHistory.frame = CGRectMake(11, 290, 57, 57);
    [_btnHistory setBackgroundImage:[UIImage imageNamed:@"me-history"] forState:UIControlStateNormal];
    [_scrollView addSubview:_btnHistory];
    
    for(int i = 0; i < 4; i++)
    {
        int nRectWidth = 48;
        _imgPrivatePicture[i] = [[UIImageView alloc] initWithFrame:CGRectMake(90 + (nRectWidth + 5) * i, 60, nRectWidth, nRectWidth)];
        _imgPrivatePicture[i].contentMode = UIViewContentModeScaleAspectFit;
        
        _imgPriPicFrame[i] = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imgPrivatePicture[i].frame) - 1, CGRectGetMinY(_imgPrivatePicture[i].frame) - 1, CGRectGetWidth(_imgPrivatePicture[i].frame) + 2, CGRectGetHeight(_imgPrivatePicture[i].frame) + 2)];
        _imgPriPicFrame[i].backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
        _imgPriPicFrame[i].layer.borderWidth = 1.0;
        _imgPriPicFrame[i].layer.borderColor = [[UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1] CGColor];
        
        [_scrollView addSubview:_imgPrivatePicture[i]];
        [_scrollView addSubview:_imgPriPicFrame[i]];
        [_scrollView bringSubviewToFront:_imgPrivatePicture[i]];
        
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
        [_scrollView addSubview:_btnPrivate[i]];
        [_scrollView bringSubviewToFront:_btnPrivate[i]];
    }
    
    _viewNoPrivatePicture = [[UIView alloc] initWithFrame:CGRectMake(85, 55, 220, 60)];
    _viewNoPrivatePicture.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_viewNoPrivatePicture];
    
    UIImageView * imgLazyMan = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    imgLazyMan.image = [UIImage imageNamed:@"lanhan"];
    [_viewNoPrivatePicture addSubview:imgLazyMan];
    
    UILabel * lbLackImage1 = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 160, 20)];
    lbLackImage1.backgroundColor = [UIColor clearColor];
    lbLackImage1.textColor = [UIColor grayColor];
    lbLackImage1.font = [UIFont boldSystemFontOfSize:12];
    lbLackImage1.text = @"Ta很懒，还没有上传生活照。";
    [_viewNoPrivatePicture addSubview:lbLackImage1];
    
    UILabel * lbLackImage2 = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 160, 20)];
    lbLackImage2.backgroundColor = [UIColor clearColor];
    lbLackImage2.textColor = [UIColor blueColor];
    lbLackImage2.font = [UIFont boldSystemFontOfSize:12];
    lbLackImage2.text = @"提醒Ta上传生活照";
    [_viewNoPrivatePicture addSubview:lbLackImage2];
    
    CSButton * btnSelectImage = [CSButton buttonWithType:UIButtonTypeCustom];
    btnSelectImage.frame = _viewNoPrivatePicture.bounds;
    [_viewNoPrivatePicture addSubview:btnSelectImage];

    UILabel *_lbAttention = [[UILabel alloc] initWithFrame:CGRectMake(90, 125, 45, 20)];
    _lbAttention.backgroundColor = [UIColor clearColor];
    _lbAttention.textColor = [UIColor blueColor];
    _lbAttention.text = @"关注：";
    _lbAttention.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:_lbAttention];
    
    UILabel *_lbFan = [[UILabel alloc] initWithFrame:CGRectMake(plbSeparate4.frame.origin.x + 10, 125, 45, 20)];
    _lbFan.backgroundColor = [UIColor clearColor];
    _lbFan.textColor = [UIColor blueColor];
    _lbFan.text = @"粉丝：";
    _lbFan.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:_lbFan];
    
    _lbAttentionValue = [[UILabel alloc] initWithFrame:CGRectMake(130, 125, 45, 20)];
    _lbAttentionValue.backgroundColor = [UIColor clearColor];
    _lbAttentionValue.textColor = [UIColor blueColor];
    _lbAttentionValue.text = @"0";
    _lbAttentionValue.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:_lbAttentionValue];
    
    _lbFanValue = [[UILabel alloc] initWithFrame:CGRectMake(plbSeparate4.frame.origin.x + 50, 125, 45, 20)];
    _lbFanValue.backgroundColor = [UIColor clearColor];
    _lbFanValue.textColor = [UIColor blueColor];
    _lbFanValue.text = @"0";
    _lbFanValue.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:_lbFanValue];
    
    CSButton *btnAttention = [CSButton buttonWithType:UIButtonTypeCustom];
    btnAttention.frame = CGRectMake(CGRectGetMinX(_lbAttention.frame), 125, CGRectGetMaxX(_lbAttentionValue.frame) - CGRectGetMinX(_lbAttention.frame), 20);
    [_scrollView addSubview:btnAttention];
    [_scrollView bringSubviewToFront:btnAttention];
    
    __weak typeof (self) thisPoint = self;
    
    btnAttention.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        
        RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
        relatedPeoplesViewController.eRelatedType = e_related_people_attention;
        relatedPeoplesViewController.strUserId = thisStrongPoint->_strUserID;
        [thisStrongPoint.navigationController pushViewController:relatedPeoplesViewController animated:YES];
    };
    
    CSButton *btnFans = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFans.frame = CGRectMake(CGRectGetMinX(_lbFan.frame), 125, CGRectGetMaxX(_lbFanValue.frame) - CGRectGetMinX(_lbFan.frame), 20);
    [_scrollView addSubview:btnFans];
    [_scrollView bringSubviewToFront:btnFans];
    
    btnFans.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        
        RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
        relatedPeoplesViewController.eRelatedType = e_related_people_fans;
        relatedPeoplesViewController.strUserId = thisStrongPoint->_strUserID;
        [thisStrongPoint.navigationController pushViewController:relatedPeoplesViewController animated:YES];
    };

    UILabel * lbEquipmentTitle = [[UILabel alloc] initWithFrame:CGRectMake(90, 155, 45, 20)];
    lbEquipmentTitle.backgroundColor = [UIColor clearColor];
    lbEquipmentTitle.textColor = [UIColor blackColor];
    lbEquipmentTitle.text = @"装备：";
    lbEquipmentTitle.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:lbEquipmentTitle];
    
    UIImageView * imgRing = [[UIImageView alloc] initWithFrame:CGRectMake(130, 155, 21, 21)];
    imgRing.image = [UIImage imageNamed:@"equipment-wearable"];
    [_scrollView addSubview:imgRing];
    
    UIImageView * imgShoes = [[UIImageView alloc] initWithFrame:CGRectMake(130, 175, 21, 21)];
    imgShoes.image = [UIImage imageNamed:@"equipment-shoe"];
    [_scrollView addSubview:imgShoes];
    
    UIImageView * imgPhone = [[UIImageView alloc] initWithFrame:CGRectMake(130, 195, 21, 21)];
    imgPhone.image = [UIImage imageNamed:@"equipment-software"];
    [_scrollView addSubview:imgPhone];
    
    _lbRingValue = [[UILabel alloc] initWithFrame:CGRectMake(155, 155, _scrollView.frame.size.width - 160, 20)];
    _lbRingValue.backgroundColor = [UIColor clearColor];
    _lbRingValue.textColor = [UIColor blackColor];
    _lbRingValue.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:_lbRingValue];
    
    _lbShoesValue = [[UILabel alloc] initWithFrame:CGRectMake(155, 175, _scrollView.frame.size.width - 160, 20)];
    _lbShoesValue.backgroundColor = [UIColor clearColor];
    _lbShoesValue.textColor = [UIColor blackColor];
    _lbShoesValue.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:_lbShoesValue];
    
    _lbPhoneValue = [[UILabel alloc] initWithFrame:CGRectMake(155, 195, _scrollView.frame.size.width - 160, 20)];
    _lbPhoneValue.backgroundColor = [UIColor clearColor];
    _lbPhoneValue.textColor = [UIColor blackColor];
    _lbPhoneValue.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:_lbPhoneValue];
    
    UILabel * lbTotalDistance = [[UILabel alloc] initWithFrame:CGRectMake(90, 225, 130, 20)];
    lbTotalDistance.backgroundColor = [UIColor clearColor];
    lbTotalDistance.textColor = [UIColor blackColor];
    lbTotalDistance.text = @"总里程：";
    lbTotalDistance.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:lbTotalDistance];
    
    _lbTotalDistanceValue = [[UILabel alloc] initWithFrame:CGRectMake(220, 225, _scrollView.frame.size.width - 225, 20)];
    _lbTotalDistanceValue.backgroundColor = [UIColor clearColor];
    _lbTotalDistanceValue.textColor = [UIColor blackColor];
    _lbTotalDistanceValue.font = [UIFont boldSystemFontOfSize:14];
    _lbTotalDistanceValue.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_lbTotalDistanceValue];
    
    UILabel * lbMaxforDay = [[UILabel alloc] initWithFrame:CGRectMake(90, 245, 130, 20)];
    lbMaxforDay.backgroundColor = [UIColor clearColor];
    lbMaxforDay.textColor = [UIColor blackColor];
    lbMaxforDay.text = @"单日运动最长距离：";
    lbMaxforDay.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:lbMaxforDay];
    
    _lbMaxforDayValue = [[UILabel alloc] initWithFrame:CGRectMake(220, 245, _scrollView.frame.size.width - 225, 20)];
    _lbMaxforDayValue.backgroundColor = [UIColor clearColor];
    _lbMaxforDayValue.textColor = [UIColor blackColor];
    _lbMaxforDayValue.font = [UIFont boldSystemFontOfSize:14];
    _lbMaxforDayValue.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_lbMaxforDayValue];
    
    UILabel * lbFastestSpeed = [[UILabel alloc] initWithFrame:CGRectMake(90, 265, 130, 20)];
    lbFastestSpeed.backgroundColor = [UIColor clearColor];
    lbFastestSpeed.textColor = [UIColor blackColor];
    lbFastestSpeed.text = @"历史最快速度：";
    lbFastestSpeed.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:lbFastestSpeed];
    
    _lbFastestSpeedValue = [[UILabel alloc] initWithFrame:CGRectMake(220, 265, _scrollView.frame.size.width - 225, 20)];
    _lbFastestSpeedValue.backgroundColor = [UIColor clearColor];
    _lbFastestSpeedValue.textColor = [UIColor blackColor];
    _lbFastestSpeedValue.font = [UIFont boldSystemFontOfSize:14];
    _lbFastestSpeedValue.textAlignment = NSTextAlignmentRight;
    [_scrollView addSubview:_lbFastestSpeedValue];

    UIImageView * imgLoc = [[UIImageView alloc] initWithFrame:CGRectMake(90, 302, 17, 17)];
    imgLoc.image = [UIImage imageNamed:@"location-icon"];
    [_scrollView addSubview:imgLoc];
    
    _lbLoc = [[UILabel alloc] initWithFrame:CGRectMake(110, 300, _scrollView.frame.size.width - 110, 20)];
    _lbLoc.backgroundColor = [UIColor clearColor];
    _lbLoc.text = @"";
    _lbLoc.font = [UIFont boldSystemFontOfSize:14];
    [_scrollView addSubview:_lbLoc];

    _lbHisBlog = [[UILabel alloc] initWithFrame:CGRectMake(10, 340, 80, 20)];
    _lbHisBlog.backgroundColor = [UIColor clearColor];
    _lbHisBlog.text = @"";
    _lbHisBlog.font = [UIFont boldSystemFontOfSize:16];
    [_scrollView addSubview:_lbHisBlog];
    
    _lbBlogCount = [[UILabel alloc] initWithFrame:CGRectMake(90, 340, 100, 20)];
    _lbBlogCount.backgroundColor = [UIColor clearColor];
    _lbBlogCount.text = @"";
    _lbBlogCount.textColor = [UIColor grayColor];
    _lbBlogCount.font = [UIFont boldSystemFontOfSize:12];
    [_scrollView addSubview:_lbBlogCount];
    
    _gridView = [[SFGridView alloc]initWithFrame:CGRectMake(10, 370, 290, 145)];
    _gridView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview: _gridView];

    UIView * viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 49, CGRectGetWidth(self.view.frame), 49)];
    viewBottom.backgroundColor = [UIColor colorWithRed:96 / 255.0 green:205 / 255.0 blue:255 / 255.0 alpha:1.0];
    [self.view addSubview:viewBottom];
    
    _btnBlackList = [[CSButton alloc] initWithFrame:CGRectMake(10, 1, 47, 47)];
    [_btnBlackList setImage:[UIImage imageNamed:@"others-block-btn"] forState:UIControlStateNormal];
    [_btnBlackList setTitle:@"拉黑" forState:UIControlStateNormal];
    [_btnBlackList.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [_btnBlackList setTitleEdgeInsets:UIEdgeInsetsMake(20.0, -47, 0.0, 0.0)];
    [_btnBlackList setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [viewBottom addSubview:_btnBlackList];
    
    _btnAttention = [[CSButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(viewBottom.frame) / 2 - 24, 1, 47, 47)];
    [_btnAttention setImage:[UIImage imageNamed:@"others-following-btn"] forState:UIControlStateNormal];
    [_btnAttention setTitle:@"关注" forState:UIControlStateNormal];
    [_btnAttention.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [_btnAttention setTitleEdgeInsets:UIEdgeInsetsMake(20.0, -47, 0.0, 0.0)];
    [_btnAttention setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [viewBottom addSubview:_btnAttention];
    
    _btnChat = [[CSButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(viewBottom.frame) - 10 - 47, 1, 47, 47)];
    [_btnChat setImage:[UIImage imageNamed:@"chat-btn"] forState:UIControlStateNormal];
    [_btnChat setTitle:@"私聊" forState:UIControlStateNormal];
    [_btnChat.titleLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [_btnChat setTitleEdgeInsets:UIEdgeInsetsMake(20.0, -47, 0.0, 0.0)];
    [_btnChat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   [viewBottom addSubview:_btnChat];

    _btnHistory.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        HistoryViewController *historyViewController = [[HistoryViewController alloc]init];
        [historyViewController setHistoryType:HISTORY_TYPE_ALL];
        historyViewController.userInfo = thisStrongPoint->_userInfo;
        [thisStrongPoint.navigationController pushViewController:historyViewController animated:YES];
    };
    
    _btnBlackList.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
        
        if (userInfo != nil) {
            if (userInfo.ban_time > 0) {
                [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:thisStrongPoint.view hiddenAfter:2];
                return;
            }
            else if(userInfo.ban_time < 0)
            {
                [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:thisStrongPoint.view hiddenAfter:2];
                return;
            }
        }
        
        if ([userInfo.userid isEqualToString:thisStrongPoint->_strUserID]) {
            [AlertManager showAlertText:@"亲，不可以把自己拉黑哦！" InView:thisStrongPoint.view hiddenAfter:2];
            return;
        }
        
        BOOL bDeFriend = false;
        NSString *strAudio = @"blackList.mp3";
        
        if([thisStrongPoint->_userInfo.relation isEqualToString:@"DEFRIEND"])
        {
            bDeFriend = YES;
            strAudio = @"whiteList.mp3";
        }
        
        
        [[CommonUtility sharedInstance]playAudioFromName:strAudio];
        
        [[SportForumAPI sharedInstance] userDeFriendByUserId:@[thisStrongPoint->_strUserID]
                                                          DeFriend:!bDeFriend
                                                      FinishedBlock:^void(int errorCode, NSString* strDescErr)
         {
             if(errorCode == 0)
             {
                 [thisStrongPoint refreshInfo];
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_LEADBOARD object:nil];
             }
             else
             {
                 [AlertManager showAlertText:strDescErr InView:thisStrongPoint.view hiddenAfter:2];
             }
         }];
    };
    
    _btnAttention.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
        
        if (userInfo != nil) {
            if (userInfo.ban_time > 0) {
                [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:thisStrongPoint.view hiddenAfter:2];
                return;
            }
            else if(userInfo.ban_time < 0)
            {
                [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:thisStrongPoint.view hiddenAfter:2];
                return;
            }
        }
        
        if ([userInfo.userid isEqualToString:thisStrongPoint->_strUserID]) {
            [AlertManager showAlertText:@"亲，不可以关注自己哦！" InView:thisStrongPoint.view hiddenAfter:2];
            return;
        }
        
        BOOL bAttention = false;
        if([thisStrongPoint->_userInfo.relation isEqualToString:@"ATTENTION"] || [thisStrongPoint->_userInfo.relation isEqualToString:@"FRIENDS"])
        {
            bAttention = YES;
        }

        [[SportForumAPI sharedInstance] userEnableAttentionByUserId:@[thisStrongPoint->_strUserID]
                                                          Attention:!bAttention
                                                      FinishedBlock:^void(int errorCode, NSString* strDescErr, ExpEffect* expEffect)
         {
             if(errorCode == 0)
             {
                 [thisStrongPoint refreshInfo];
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_LEADBOARD object:nil];
             }
             else
             {
                 [AlertManager showAlertText:strDescErr InView:thisStrongPoint.view hiddenAfter:2];
             }
         }];
    };
    
    _btnChat.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
        
        if (userInfo != nil) {
            if (userInfo.ban_time > 0) {
                [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:thisStrongPoint.view hiddenAfter:2];
                return;
            }
            else if(userInfo.ban_time < 0)
            {
                [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:thisStrongPoint.view hiddenAfter:2];
                return;
            }
        }
        
        if ([userInfo.userid isEqualToString:thisStrongPoint->_strUserID]) {
            [AlertManager showAlertText:@"亲，不可以和自己聊天哦！" InView:thisStrongPoint.view hiddenAfter:2];
            return;
        }
        
        ChatMessageTableViewController *chatMessageTableViewController = [[ChatMessageTableViewController alloc]init];
        chatMessageTableViewController.userId = thisStrongPoint->_strUserID;
        chatMessageTableViewController.useProImage = thisStrongPoint->_userInfo.profile_image;
        chatMessageTableViewController.useNickName = thisStrongPoint->_userInfo.nikename;
        [thisStrongPoint.navigationController pushViewController:chatMessageTableViewController animated:YES];
    };
    
    btnSelectImage.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
        
        if (userInfo != nil) {
            if (userInfo.ban_time > 0) {
                [AlertManager showAlertText:@"用户已被禁言，无法完成本次操作。" InView:thisStrongPoint.view hiddenAfter:2];
                return;
            }
            else if(userInfo.ban_time < 0)
            {
                [AlertManager showAlertText:@"用户已进入黑名单，无法完成本次操作。" InView:thisStrongPoint.view hiddenAfter:2];
                return;
            }
        }
        
        if ([userInfo.userid isEqualToString:thisStrongPoint->_strUserID]) {
            [AlertManager showAlertText:@"亲，不可以和自己聊天哦！" InView:thisStrongPoint.view hiddenAfter:2];
            return;
        }
        
        ChatMessageTableViewController *chatMessageTableViewController = [[ChatMessageTableViewController alloc]init];
        chatMessageTableViewController.userId = thisStrongPoint->_strUserID;
        chatMessageTableViewController.useProImage = thisStrongPoint->_userInfo.profile_image;
        chatMessageTableViewController.useNickName = thisStrongPoint->_userInfo.nikename;
        chatMessageTableViewController.strDefaultText = @"很高兴能认识您，能上传几张生活照吗？";
        [thisStrongPoint.navigationController pushViewController:chatMessageTableViewController animated:YES];
    };
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

-(void)refreshInfo
{
    if(!_strUserID || [_strUserID isEqualToString:@""])
    {
        return;
    }
    
    __weak typeof (self) thisPoint = self;
    [_HUD show:YES];
    [[SportForumAPI sharedInstance] userGetInfoByUserId:_strUserID
                                                  FinishedBlock:^void(int errorCode, UserInfo* userInfo)
     {
         typeof(self) thisStrongPoint = thisPoint;
         
         if (thisStrongPoint == nil) {
             return;
         }
         
         [thisStrongPoint->_HUD hide:YES];
         if(errorCode == 0)
         {
             if(userInfo.userid.length > 0)
             {
                 thisStrongPoint->_userInfo = userInfo;
                 
                 UILabel * lbTitle = (UILabel *)[thisStrongPoint.view viewWithTag:GENERATE_VIEW_TITLE];
                 lbTitle.text = userInfo.nikename;

                 UILabel *lbPhysique = [thisStrongPoint->_dicUpdateControl objectForKey:@"体魄"];
                 lbPhysique.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.physique_value];
                 
                 UILabel *lbLiterature = [thisStrongPoint->_dicUpdateControl objectForKey:@"文学"];
                 lbLiterature.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.literature_value];
                 
                 UILabel *lbMagic = [thisStrongPoint->_dicUpdateControl objectForKey:@"魔法"];
                 lbMagic.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.magic_value];
                 
                 UILabel *lbCoin = [thisStrongPoint->_dicUpdateControl objectForKey:@"贝币"];
                 lbCoin.text = [NSString stringWithFormat:@"%lld", userInfo.proper_info.coin_value / 100000000];
                 
                 UILabel *lbNickName = [thisStrongPoint->_dicUpdateControl objectForKey:@"NickName"];
                 lbNickName.text = userInfo.nikename;
                 
                 UILabel *lbLevel = [thisStrongPoint->_dicUpdateControl objectForKey:@"Level"];
                 lbLevel.text = [NSString stringWithFormat:@"LV.%ld", userInfo.proper_info.rankLevel];
                 
                 [thisStrongPoint->_imageViewUser sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image]
                                   placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
                 
                 NSDate * dateBirthday = [NSDate dateWithTimeIntervalSince1970:userInfo.birthday];
                 NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dateBirthday];
                 NSInteger birthdayYear = [comps year];
                 NSDateComponents * comps2 =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
                 NSInteger year = [comps2 year];
                 thisStrongPoint->_lbAge.text = [NSString stringWithFormat:@"%ld", year - birthdayYear];
                 
                 thisStrongPoint->_lbLevelValue.text = [NSString stringWithFormat:@"LV. %ld", userInfo.proper_info.rankLevel];
                 NSUInteger nLevel = userInfo.proper_info.rankLevel;
                 NSUInteger nHorseCount = nLevel / 25;
                 NSUInteger nRabbitCount = (nLevel - nHorseCount * 25) / 5;
                 NSUInteger nSnailCount = nLevel - nHorseCount * 25 - nRabbitCount * 5;
                 NSUInteger nButtonStartPoint = _imgStar[0].frame.origin.y;
                 for(NSUInteger i = 0; i < 4; i++)
                 {
                     thisStrongPoint->_imgStar[i].hidden = (i >= nHorseCount);
                     thisStrongPoint->_imgStar[4 + i].hidden = (i >= nRabbitCount);
                     thisStrongPoint->_imgStar[8 + i].hidden = (i >= nSnailCount);
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
                 if(nRabbitCount != 0)
                 {
                     nButtonStartPoint += 22;
                 }
                 if(nSnailCount != 0)
                 {
                     nButtonStartPoint += 22;
                 }
                 
                 thisStrongPoint->_imgLevelBK.frame = CGRectMake(thisStrongPoint->_imgLevelBK.frame.origin.x, nButtonStartPoint + 4, thisStrongPoint->_imgLevelBK.frame.size.width, thisStrongPoint->_imgLevelBK.frame.size.height);
                 thisStrongPoint->_lbLevelValue.frame = thisStrongPoint->_imgLevelBK.frame;
                 thisStrongPoint->_lbScoreValue.frame = CGRectMake(thisStrongPoint->_lbScoreValue.frame.origin.x, thisStrongPoint->_lbLevelValue.frame.origin.y + 20, thisStrongPoint->_lbScoreValue.frame.size.width, thisStrongPoint->_lbScoreValue.frame.size.height);
                 thisStrongPoint->_viewPhone.frame = CGRectMake(thisStrongPoint->_viewPhone.frame.origin.x, thisStrongPoint->_lbScoreValue.frame.origin.y + 20, thisStrongPoint->_viewPhone.frame.size.width, thisStrongPoint->_viewPhone.frame.size.height);
                 thisStrongPoint->_btnHistory.frame = CGRectMake(thisStrongPoint->_btnHistory.frame.origin.x, thisStrongPoint->_viewPhone.frame.origin.y + 30, thisStrongPoint->_btnHistory.frame.size.width, thisStrongPoint->_btnHistory.frame.size.height);

                 thisStrongPoint->_lbScoreValue.text = [NSString stringWithFormat:@"总分：%ld", userInfo.proper_info.rankscore];
                 thisStrongPoint->_viewPhone.hidden = userInfo.phone_number.length > 0 ? NO : YES;
                 
                 thisStrongPoint->_lbAttentionValue.text = [NSString stringWithFormat:@"%ld", userInfo.attention_count];
                 thisStrongPoint->_lbFanValue.text = [NSString stringWithFormat:@"%ld", userInfo.fans_count];
                 
                 [thisStrongPoint->_imgUrlArray removeAllObjects];
                 [thisStrongPoint->_imgUrlArray addObjectsFromArray:userInfo.user_images.data];
                 
                 NSUInteger nImageCount = userInfo.user_images.data.count;
                 if(nImageCount > 4)
                 {
                     nImageCount = 4;
                 }
                 for(int i = 0; i < nImageCount; i++)
                 {
                     thisStrongPoint->_btnPrivate[i].hidden = NO;
                     thisStrongPoint->_imgPrivatePicture[i].hidden = NO;
                     thisStrongPoint->_imgPriPicFrame[i].hidden = NO;
                     [thisStrongPoint->_imgPrivatePicture[i] sd_setImageWithURL:[NSURL URLWithString:userInfo.user_images.data[i]]
                                              placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
                 }
                 for(NSUInteger i = nImageCount; i < 4; i++)
                 {
                     thisStrongPoint->_btnPrivate[i].hidden = YES;
                     thisStrongPoint->_imgPrivatePicture[i].hidden = YES;
                     thisStrongPoint->_imgPriPicFrame[i].hidden = YES;
                 }
                 
                 thisStrongPoint->_viewNoPrivatePicture.hidden = (nImageCount != 0);
                 if(userInfo.user_equipInfo.ele_product.data.count)
                 {
                     thisStrongPoint->_lbRingValue.textColor = [UIColor blackColor];
                     thisStrongPoint->_lbRingValue.text = userInfo.user_equipInfo.ele_product.data[0];
                 }
                 else
                 {
                     thisStrongPoint->_lbRingValue.text = @"";
                 }
                 if([thisStrongPoint->_lbRingValue.text isEqualToString:@""])
                 {
                     thisStrongPoint->_lbRingValue.textColor = [UIColor grayColor];
                     thisStrongPoint->_lbRingValue.text = @"Ta还没有可穿戴设备";
                 }
                 if(userInfo.user_equipInfo.run_shoe.data.count)
                 {
                     thisStrongPoint->_lbShoesValue.textColor = [UIColor blackColor];
                     thisStrongPoint->_lbShoesValue.text = userInfo.user_equipInfo.run_shoe.data[0];
                 }
                 else
                 {
                     thisStrongPoint->_lbShoesValue.text = @"";
                 }
                if([thisStrongPoint->_lbShoesValue.text isEqualToString:@""])
                 {
                     thisStrongPoint->_lbShoesValue.textColor = [UIColor grayColor];
                     thisStrongPoint->_lbShoesValue.text = @"Ta还没有跑鞋";
                 }
                 if(userInfo.user_equipInfo.step_tool.data.count)
                 {
                     thisStrongPoint->_lbPhoneValue.textColor = [UIColor blackColor];
                     thisStrongPoint->_lbPhoneValue.text = userInfo.user_equipInfo.step_tool.data[0];
                 }
                 else
                 {
                     thisStrongPoint->_lbPhoneValue.text = @"";
                 }
                 if([thisStrongPoint->_lbPhoneValue.text isEqualToString:@""])
                 {
                     thisStrongPoint->_lbPhoneValue.textColor = [UIColor grayColor];
                     thisStrongPoint->_lbPhoneValue.text = @"Ta还没装健身应用";
                 }

                 if([userInfo.sex_type isEqualToString:@"male"])
                 {
                     thisStrongPoint->_lbHisBlog.text = @"他的博文";
                     thisStrongPoint->_viewMan.hidden = NO;
                     thisStrongPoint->_viewWomen.hidden = YES;
                 }
                 else
                 {
                     thisStrongPoint->_lbHisBlog.text = @"她的博文";
                     thisStrongPoint->_viewMan.hidden = YES;
                     thisStrongPoint->_viewWomen.hidden = NO;
                 }
                 BOOL bDeFriend = false;
                 if([thisStrongPoint->_userInfo.relation isEqualToString:@"DEFRIEND"])
                 {
                     bDeFriend = YES;
                 }
                 BOOL bAttention = false;
                 if([thisStrongPoint->_userInfo.relation isEqualToString:@"ATTENTION"] || [thisStrongPoint->_userInfo.relation isEqualToString:@"FRIENDS"])
                 {
                     bAttention = YES;
                 }
                 if(bDeFriend)
                 {
                     [thisStrongPoint->_btnBlackList setTitle:@"取消" forState:UIControlStateNormal];
                 }
                 else
                 {
                     [thisStrongPoint->_btnBlackList setTitle:@"拉黑" forState:UIControlStateNormal];
                 }
                 if(bAttention)
                 {
                     [thisStrongPoint->_btnAttention setTitle:@"取消" forState:UIControlStateNormal];
                 }
                 else
                 {
                     [thisStrongPoint->_btnAttention setTitle:@"关注" forState:UIControlStateNormal];
                 }
                 thisStrongPoint->_btnChat.enabled = !bDeFriend;
                 thisStrongPoint->_btnAttention.enabled = !bDeFriend;
                 
                 float dMyLon = [[ApplicationContext sharedInstance] accountInfo].longitude;
                 float dMyLat = [[ApplicationContext sharedInstance] accountInfo].latitude;
                 float dFriendLon = thisStrongPoint->_userInfo.longitude;
                 float dFriendLat = thisStrongPoint->_userInfo.latitude;
                 double dDistance = [[CommonUtility sharedInstance] getDistanceBySelfLon:dMyLon SelfLantitude:dMyLat OtherLon:dFriendLon OtherLat:dFriendLat];
                 
                 NSString * strDate = @"无登录数据";
                 
                 if (thisStrongPoint->_userInfo.last_login_time > 0) {
                     NSDate * dateLastLogin = [NSDate dateWithTimeIntervalSince1970:thisStrongPoint->_userInfo.last_login_time];
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
                 
                 if(dDistance == 0)
                 {
                     _lbLoc.text = [NSString stringWithFormat:@"%@,位置不明", strDate];
                 }
                 else if (dDistance < 1000) {
                     _lbLoc.text = [NSString stringWithFormat:@"%@,距离%.2f米", strDate, dDistance];
                 }
                 else
                 {
                     _lbLoc.text = [NSString stringWithFormat:@"%@,距离%.2f公里", strDate, dDistance / 1000];
                 }
             }

             [[SportForumAPI sharedInstance] recordStatisticsByUserId:userInfo.userid
                                                        FinishedBlock:^void(int errorCode, RecordStatisticsInfo *recordStatisticsInfo)
              {
                  if (thisStrongPoint == nil) {
                      return;
                  }
                  
                  if(recordStatisticsInfo.total_distance != 0)
                  {
                      thisStrongPoint->_lbTotalDistanceValue.textColor = [UIColor blackColor];
                      thisStrongPoint->_lbTotalDistanceValue.text = [NSString stringWithFormat:@"%ld公里", recordStatisticsInfo.total_distance / 1000];
                  }
                  else
                  {
                      thisStrongPoint->_lbTotalDistanceValue.textColor = [UIColor grayColor];
                      thisStrongPoint->_lbTotalDistanceValue.text = @"无数据";
                  }
                  if(recordStatisticsInfo.max_distance_record.duration != 0)
                  {
                      thisStrongPoint->_lbMaxforDayValue.textColor = [UIColor blackColor];
                      thisStrongPoint->_lbMaxforDayValue.text = [NSString stringWithFormat:@"%ld公里", recordStatisticsInfo.max_distance_record.distance / 1000];
                  }
                  else
                  {
                      thisStrongPoint->_lbMaxforDayValue.textColor = [UIColor grayColor];
                      thisStrongPoint->_lbMaxforDayValue.text = @"无数据";
                  }
                  
                  NSUInteger nMaxSpeed = 0;
                  if(recordStatisticsInfo.max_speed_record.duration != 0)
                  {
                      nMaxSpeed = (recordStatisticsInfo.max_speed_record.distance * 3600) / (recordStatisticsInfo.max_speed_record.duration * 1000);
                      thisStrongPoint->_lbFastestSpeedValue.textColor = [UIColor blackColor];
                      thisStrongPoint->_lbFastestSpeedValue.text = [NSString stringWithFormat:@"%ld公里/小时", nMaxSpeed];
                  }
                  else
                  {
                      thisStrongPoint->_lbFastestSpeedValue.textColor = [UIColor grayColor];
                      thisStrongPoint->_lbFastestSpeedValue.text = @"无数据";
                  }
              }];
         }
     }];
}

@end
