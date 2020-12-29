//
//  AccountPreViewController.m
//  SportForum
//
//  Created by liyuan on 4/8/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "AccountPreViewController.h"
#import "AlertManager.h"
#import "UIViewController+SportFormu.h"
#import "UIImageView+WebCache.h"
#import "HistoryViewController.h"
#import "ChatMessageTableViewController.h"
#import "RelatedPeoplesViewController.h"
#import "MWPhotoBrowser.h"
#import "UIScrollView+TwitterCover.h"
#import "ArticleCircleViewController.h"

@interface AccountPreViewController ()<MWPhotoBrowserDelegate, UIScrollViewDelegate>

@end

@implementation AccountPreViewController
{
    UIScrollView *_scrollView;
    
    UIView *_viewPhotoBoard;
    UIImageView *_imgPrivatePicture[5];
    CSButton *_btnPrivate[5];
    
    UIView *_viewUserInfo;
    UIImageView * _imgStar[12];
    
    UIView *_viewCoach;
    UIView *_viewUserEquip;
    UIView *_viewAdvance;
    UIView *_viewAdvanceEx;
    UIView *_viewBottom;
    
    CSButton *_btnBlackList;
    CSButton *_btnAttention;
    CSButton *_btnChat;
    
    NSMutableDictionary * _dicUpdateControl;
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _photos;
    
    id _processWin;
    int _nCurBoardCover;
    BOOL _bUpdateCover;
    UserInfo *_userInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dicUpdateControl = [[NSMutableDictionary alloc]init];
    _photos = [[NSMutableArray alloc]init];
    _imgUrlArray = [[NSMutableArray alloc]init];
    
    if (self.navigationController == nil) {
        CGRect rect1 = CGRectMake(0, 0, CGRectGetHeight([UIScreen mainScreen].bounds), CGRectGetWidth([UIScreen mainScreen].bounds));
        self.view.frame = rect1;
    }

    __weak __typeof(self) weakSelf = self;
    
    [self generateCommonViewInParent:self.view Title:@"" IsNeedBackBtn:YES ActionBlock:^(void)
     {
         __typeof(self) strongSelf = weakSelf;
        
         if (strongSelf.bGame) {
             [strongSelf dismissViewControllerAnimated:YES completion:nil];
         }
         else
         {
             [strongSelf.navigationController popViewControllerAnimated:YES];
         }
     }];

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
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    [viewBody addSubview:_scrollView];
    _scrollView.delegate = self;
    _scrollView.scrollEnabled = YES;

    [self generatePhotoBoard];
    [self generateUserInfoView];
    [self generateUserAdvanceExView];
    
    if (![[[ApplicationContext sharedInstance]accountInfo].userid isEqualToString:_strUserId]) {
        [self generateUserRelateAction];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人信息预览 - AccountPreViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"个人信息预览 - AccountPreViewController"];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshInfo];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人信息预览 - AccountPreViewController"];
    [AlertManager dissmiss:_processWin];
    [[ApplicationContext sharedInstance]cancelCurrentRequests:[NSArray arrayWithObjects:urlRecordStatistics, urlUserArticles, nil]];
}

-(NSString*)convertEmotionToHanzi:(NSString*)strEmotion
{
    NSString *strHanzi = @"";
    
    //SECRECY/SINGLE/LOVE/MARRIED/HOMOSEXUAL
    if ([strEmotion isEqualToString:@"SECRECY"]) {
        strHanzi = @"保密";
    }
    else if([strEmotion isEqualToString:@"SINGLE"]) {
        strHanzi = @"单身";
    }
    else if([strEmotion isEqualToString:@"LOVE"]) {
        strHanzi = @"恋爱中";
    }
    else if([strEmotion isEqualToString:@"MARRIED"]) {
        strHanzi = @"已婚";
    }
    else if([strEmotion isEqualToString:@"HOMOSEXUAL"]) {
        strHanzi = @"同性";
    }
    
    return strHanzi;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"AccountPreViewController dealloc called!");
    [_scrollView removeTwitterCoverView];
}

#pragma mark - User Photo Board Logic

-(UIView*)generateUserTitleViewItem:(NSString*)strTitle ScoreValue:(NSString*)strScoreValue
{
    UIView* viewItem = [[UIView alloc]init];
    
    UIImageView *viewImage = [[UIImageView alloc]init];
    viewImage.frame = CGRectMake(10, 5, 15, 15);
    [viewItem addSubview:viewImage];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 30, 10)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor darkGrayColor];
    labelTitle.text = strTitle;
    labelTitle.textAlignment = NSTextAlignmentLeft;
    labelTitle.font = [UIFont boldSystemFontOfSize:11];
    [viewItem addSubview:labelTitle];
    
    UILabel *labelScore = [[UILabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(labelTitle.frame) + 5, 35, 10)];
    labelScore.backgroundColor = [UIColor clearColor];
    labelScore.textColor = [UIColor darkGrayColor];
    labelScore.text = strScoreValue;
    labelScore.textAlignment = NSTextAlignmentRight;
    labelScore.font = [UIFont systemFontOfSize:11];
    labelScore.tag = 10;
    [viewItem addSubview:labelScore];
    
    viewItem.frame = CGRectMake(0, 0, 70, 35);
    [_dicUpdateControl setObject:labelScore forKey:strTitle];
    
    return viewItem;
}

- (void)generatePhotoBoard
{
    _viewPhotoBoard = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), 75)];
    _viewPhotoBoard.backgroundColor = [UIColor clearColor];
    _viewPhotoBoard.hidden = YES;
    [_scrollView addSubview:_viewPhotoBoard];
    
    for(int i = 0; i < 5; i++)
    {
        int nRectWidth = 52;
        _imgPrivatePicture[i] = [[UIImageView alloc] initWithFrame:CGRectMake(5 + (nRectWidth + 10) * i, 12, nRectWidth, nRectWidth)];
        _imgPrivatePicture[i].contentMode = UIViewContentModeScaleAspectFill;
        _imgPrivatePicture[i].layer.cornerRadius = 5.0;
        _imgPrivatePicture[i].layer.masksToBounds = YES;

        [_viewPhotoBoard addSubview:_imgPrivatePicture[i]];
        [_viewPhotoBoard bringSubviewToFront:_imgPrivatePicture[i]];
        
        _btnPrivate[i] = [CSButton buttonWithType:UIButtonTypeCustom];
        _btnPrivate[i].frame = _imgPrivatePicture[i].frame;
        _btnPrivate[i].backgroundColor = [UIColor clearColor];
        
        __weak __typeof(self) weakSelf = self;
        
        _btnPrivate[i].actionBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            [strongSelf onClickImageViewByIndex:i];
        };
        
        _imgPrivatePicture[i].hidden = YES;
        _btnPrivate[i].hidden = YES;
        [_viewPhotoBoard addSubview:_btnPrivate[i]];
        [_viewPhotoBoard bringSubviewToFront:_btnPrivate[i]];
    }

    UIView *viewSport = [self generateUserTitleViewItem:@"体魄" ScoreValue:@"0"];
    CGRect rect = viewSport.frame;
    rect.origin = CGPointMake(4, 5);
    viewSport.frame = rect;
    UIImage *image = [UIImage imageNamed:@"other-info-runner"];
    viewSport.layer.contents = (id) image.CGImage;
    viewSport.tag = 1000;
    [_viewPhotoBoard addSubview:viewSport];
    
    UIView *viewLiterature = [self generateUserTitleViewItem:@"文学" ScoreValue:@"0"];
    rect = viewLiterature.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewSport.frame) + 6, 5);
    viewLiterature.frame = rect;
    image = [UIImage imageNamed:@"other-info-pen"];
    viewLiterature.layer.contents = (id) image.CGImage;
    viewLiterature.tag = 1001;
    [_viewPhotoBoard addSubview:viewLiterature];
    
    UIView *viewMagic = [self generateUserTitleViewItem:@"魔法" ScoreValue:@"0"];
    rect = viewMagic.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewLiterature.frame) + 6, 5);
    viewMagic.frame = rect;
    image = [UIImage imageNamed:@"other-info-magic"];
    viewMagic.layer.contents = (id) image.CGImage;
    viewMagic.tag = 1002;
    [_viewPhotoBoard addSubview:viewMagic];
    
    NSString *strItem = @"关系";
    NSString *strItemValue = @"陌生人";
    NSString *strImg = @"other-info-connection-stanger";
    
    if ([[[ApplicationContext sharedInstance]accountInfo].userid isEqualToString:_strUserId])
    {
        strItem = @"金币";
        strItemValue = @"0";
        strImg = @"other-info-beibitcoin";
    }
    
    UIView *viewItem = [self generateUserTitleViewItem:strItem ScoreValue:strItemValue];
    rect = viewItem.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewMagic.frame) + 6, 5);
    viewItem.frame = rect;
    image = [UIImage imageNamed:strImg];
    viewItem.layer.contents = (id) image.CGImage;
    viewItem.tag = 1003;
    [_viewPhotoBoard addSubview:viewItem];

    UIImageView *sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    sexTypeImageView.frame = CGRectMake(5, CGRectGetMaxY(viewSport.frame) + 10, 40, 18);
    sexTypeImageView.backgroundColor = [UIColor clearColor];
    sexTypeImageView.hidden = YES;
    sexTypeImageView.tag = 1004;
    [_viewPhotoBoard addSubview:sexTypeImageView];
    
    UILabel *lbAge = [[UILabel alloc]initWithFrame:CGRectZero];
    lbAge.backgroundColor = [UIColor clearColor];
    lbAge.textColor = [UIColor whiteColor];
    lbAge.font = [UIFont systemFontOfSize:10];
    lbAge.frame = CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, CGRectGetMinY(sexTypeImageView.frame), 20, 10);
    lbAge.textAlignment = NSTextAlignmentRight;
    lbAge.hidden = YES;
    lbAge.tag = 1005;
    [_viewPhotoBoard addSubview:lbAge];
    
    UIImageView *imgViePhone = [[UIImageView alloc]initWithFrame:CGRectZero];
    imgViePhone.frame = CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) + 5, CGRectGetMinY(sexTypeImageView.frame), 11, 19);
    [imgViePhone setImage:[UIImage imageNamed:@"phone-verified-bigger"]];
    imgViePhone.backgroundColor = [UIColor clearColor];
    imgViePhone.hidden = YES;
    imgViePhone.tag = 1006;
    [_viewPhotoBoard addSubview:imgViePhone];
    
    UIImageView *imgVieCoach = [[UIImageView alloc]initWithFrame:CGRectZero];
    imgVieCoach.frame = CGRectMake(CGRectGetMaxX(imgViePhone.frame) + 5, CGRectGetMinY(imgViePhone.frame), 20, 20);
    [imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
    imgVieCoach.backgroundColor = [UIColor clearColor];
    imgVieCoach.hidden = YES;
    imgVieCoach.tag = 1010;
    [_viewPhotoBoard addSubview:imgVieCoach];

    UIImageView * imgLoc = [[UIImageView alloc] initWithFrame:CGRectZero];
    imgLoc.image = [UIImage imageNamed:@"location-icon"];
    imgLoc.hidden = YES;
    imgLoc.tag = 1007;
    [_viewPhotoBoard addSubview:imgLoc];
    
    UILabel *lbLoc = [[UILabel alloc] initWithFrame:CGRectZero];
    lbLoc.backgroundColor = [UIColor clearColor];
    lbLoc.hidden = YES;
    lbLoc.font = [UIFont boldSystemFontOfSize:13];
    lbLoc.textColor = [UIColor darkGrayColor];
    lbLoc.tag = 1008;
    [_viewPhotoBoard addSubview:lbLoc];
    
    UILabel *lbSep0 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_viewPhotoBoard.frame) - 1, CGRectGetWidth(_viewPhotoBoard.frame), 1)];
    lbSep0.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    lbSep0.tag = 1009;
    lbSep0.hidden = YES;
    [_viewPhotoBoard addSubview:lbSep0];
}

-(CGFloat)updatePhotoBoard:(UserInfo*)userInfo
{
    CGFloat fStartYPoint = 0;
    _viewPhotoBoard.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), 75);
    
    if (userInfo.user_images.data.count > 0) {
        userInfo.cover_image = [userInfo.cover_image stringByReplacingOccurrencesOfString:@".png" withString:@".jpg"];
        
        if(_scrollView.twitterCoverView == nil)
        {
            [_scrollView addTwitterCoverWithImage:[UIImage imageNamed:userInfo.cover_image.length > 0 ? userInfo.cover_image : @"cover-0.jpg"]];
            [_scrollView sendSubviewToBack:_scrollView.twitterCoverView];
        }
        else
        {
            [_scrollView.twitterCoverView setImage:[UIImage imageNamed:userInfo.cover_image.length > 0 ? userInfo.cover_image : @"cover-0.jpg"]];
        }

        [_imgUrlArray removeAllObjects];
        [_imgUrlArray addObjectsFromArray:userInfo.user_images.data];
        
        NSUInteger nImageCount = userInfo.user_images.data.count;
        
        for(int i = 0; i < MIN(nImageCount, 5); i++)
        {
            _btnPrivate[i].hidden = NO;
            _imgPrivatePicture[i].hidden = NO;
            [_imgPrivatePicture[i] sd_setImageWithURL:[NSURL URLWithString:userInfo.user_images.data[i]]
                                                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        }
        
        for(NSUInteger i = MIN(nImageCount, 5); i < 5; i++)
        {
            _btnPrivate[i].hidden = YES;
            _imgPrivatePicture[i].hidden = YES;
        }
        
        fStartYPoint = CGRectGetHeight(_scrollView.twitterCoverView.frame) + 5;
        _viewPhotoBoard.frame = CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), 155);
    }
    
    UILabel *lbPhysique = [_dicUpdateControl objectForKey:@"体魄"];
    lbPhysique.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.physique_value];
    
    UILabel *lbLiterature = [_dicUpdateControl objectForKey:@"文学"];
    lbLiterature.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.literature_value];
    
    UILabel *lbMagic = [_dicUpdateControl objectForKey:@"魔法"];
    lbMagic.text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.magic_value];
    
    if ([[[ApplicationContext sharedInstance]accountInfo].userid isEqualToString:_strUserId])
    {
        UILabel *lbCoin = [_dicUpdateControl objectForKey:@"金币"];
        lbCoin.text = [NSString stringWithFormat:@"%lld", userInfo.proper_info.coin_value / 100000000];
    }
    else
    {
        UIView *viewItem = [_viewPhotoBoard viewWithTag:1003];

        //FRIENDS/ATTENTION/FANS/DEFRIEND
        NSString *strItem = @"other-info-connection-stanger";
        UILabel *lbItem = [_dicUpdateControl objectForKey:@"关系"];
        
        if ([userInfo.relation isEqualToString:@"FRIENDS"]) {
            lbItem.text = @"朋友";
            strItem = @"other-info-connection-friends";
        }
        else if ([userInfo.relation isEqualToString:@"ATTENTION"]) {
            lbItem.text = @"关注";
            strItem = @"other-info-connection-follow";
        }
        else if ([userInfo.relation isEqualToString:@"FANS"]) {
            lbItem.text = @"粉丝";
            strItem = @"other-info-connection-fens";
        }
        else if ([userInfo.relation isEqualToString:@"DEFRIEND"]) {
            lbItem.text = @"拉黑";
            strItem = @"other-info-connection-black";
        }
        else
        {
            lbItem.text = @"陌生人";
            strItem = @"other-info-connection-stanger";
        }
        
        UIImage *image = [UIImage imageNamed:strItem];
        viewItem.layer.contents = (id) image.CGImage;
    }
    
    UIView *viewSport = [_viewPhotoBoard viewWithTag:1000];
    CGRect rect = viewSport.frame;
    rect.origin = CGPointMake(4, 5 + fStartYPoint);
    viewSport.frame = rect;
    
    UIView *viewLiterature = [_viewPhotoBoard viewWithTag:1001];
    rect = viewLiterature.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewSport.frame) + 6, 5 + fStartYPoint);
    viewLiterature.frame = rect;
    
    UIView *viewMagic = [_viewPhotoBoard viewWithTag:1002];
    rect = viewMagic.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewLiterature.frame) + 6, 5 + fStartYPoint);
    viewMagic.frame = rect;

    UIView *viewBtc = [_viewPhotoBoard viewWithTag:1003];
    rect = viewBtc.frame;
    rect.origin = CGPointMake(CGRectGetMaxX(viewMagic.frame) + 6, 5 + fStartYPoint);
    viewBtc.frame = rect;
    
    UIImageView *sexTypeImageView = (UIImageView*)[_viewPhotoBoard viewWithTag:1004];
    sexTypeImageView.frame = CGRectMake(5, CGRectGetMaxY(viewSport.frame) + 10, 40, 18);
    sexTypeImageView.hidden = NO;
    [sexTypeImageView setImage:[UIImage imageNamed:[userInfo.sex_type isEqualToString:sex_male] ? @"gender-male" : @"gender-female"]];

    UILabel *lbAge = (UILabel*)[_viewPhotoBoard viewWithTag:1005];
    lbAge.frame = CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, CGRectGetMinY(sexTypeImageView.frame) + 3, 20, 10);
    lbAge.hidden = NO;
    lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:userInfo.birthday];
    
    UIImageView *imgViePhone = (UIImageView*)[_viewPhotoBoard viewWithTag:1006];
    imgViePhone.frame = CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) + 5, CGRectGetMinY(sexTypeImageView.frame), 11, 19);
    imgViePhone.hidden = userInfo.phone_number.length > 0 ? NO : YES;

    UIImageView *imgVieCoach = (UIImageView*)[_viewPhotoBoard viewWithTag:1010];
    
    if (imgViePhone.hidden) {
        imgVieCoach.frame = CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) + 5, CGRectGetMinY(imgViePhone.frame), 20, 20);
    }
    else
    {
        imgVieCoach.frame = CGRectMake(CGRectGetMaxX(imgViePhone.frame) + 5, CGRectGetMinY(imgViePhone.frame), 20, 20);
    }
    
    imgVieCoach.hidden = ([userInfo.actor isEqualToString:@"coach"]) ? NO : YES;
    
    float dMyLon = [[ApplicationContext sharedInstance] accountInfo].longitude;
    float dMyLat = [[ApplicationContext sharedInstance] accountInfo].latitude;
    float dOtherLon =  userInfo.longitude;
    float dOtherLat = userInfo.latitude;
    double dDistance = [[CommonUtility sharedInstance] getDistanceBySelfLon:dMyLon SelfLantitude:dMyLat OtherLon:dOtherLon OtherLat:dOtherLat];
    
    UIImageView * imgLoc = (UIImageView*)[_viewPhotoBoard viewWithTag:1007];
    UILabel *lbLoc = (UILabel*)[_viewPhotoBoard viewWithTag:1008];

    NSString * strDate = @"";
    
    if (userInfo.last_login_time > 0) {
        NSDate * dateLastLogin = [NSDate dateWithTimeIntervalSince1970:userInfo.last_login_time];
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
    
    if (dDistance < 1000 && dDistance >= 0) {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@, 距离%.2f米", strDate, dDistance];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.2f米", dDistance];
        }
    }
    else if(dDistance >= 1000)
    {
        if (strDate.length > 0) {
            strDate = [NSString stringWithFormat:@"%@, 距离%.2f公里", strDate, dDistance / 1000];
        }
        else
        {
            strDate = [NSString stringWithFormat:@"距离%.2f公里", dDistance / 1000];
        }
    }

    if (strDate.length > 0) {
        imgLoc.hidden = NO;
        lbLoc.hidden = NO;
        lbLoc.text = strDate;
        
        //CGSize lbSize = [lbLoc.text sizeWithFont:lbLoc.font
        //                             constrainedToSize:CGSizeMake(FLT_MAX, 20) lineBreakMode:NSLineBreakByWordWrapping];
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize lbSize = [lbLoc.text boundingRectWithSize:CGSizeMake(FLT_MAX, 20)
                                                           options:options
                                                        attributes:@{NSFontAttributeName:lbLoc.font} context:nil].size;
        
        lbLoc.frame = CGRectMake(310 - lbSize.width - 5, CGRectGetMinY(sexTypeImageView.frame), lbSize.width, 20);
        imgLoc.frame = CGRectMake(CGRectGetMinX(lbLoc.frame) - 22, CGRectGetMinY(sexTypeImageView.frame) + 2, 17, 17);
    }
    else
    {
        imgLoc.hidden = YES;
        lbLoc.hidden = YES;
    }

    
    UILabel *lbSep0 = (UILabel*)[_viewPhotoBoard viewWithTag:1009];
    lbSep0.frame = CGRectMake(0, CGRectGetHeight(_viewPhotoBoard.frame) - 1, CGRectGetWidth(_viewPhotoBoard.frame), 1);
    lbSep0.hidden = NO;
    
    return CGRectGetMaxY(_viewPhotoBoard.frame);
}

#pragma mark - User Info Logic

-(void)setValueWithView:(UILabel*)lbView ValueDesc:(NSString*)strDesc ValueContent:(NSString*)strContent
{
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:strDesc attributes:attribs];
    attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:[UIColor blackColor]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:strContent attributes:attribs];
    
    NSMutableAttributedString * strValue = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strValue appendAttributedString:strPart2Value];

    lbView.attributedText = strValue;
}

-(void)generateUserInfoView
{
    _viewUserInfo = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewPhotoBoard.frame), CGRectGetWidth(_scrollView.frame), 145)];
    _viewUserInfo.backgroundColor = [UIColor clearColor];
    _viewUserInfo.hidden = YES;
    [_scrollView addSubview:_viewUserInfo];
    
    UIImageView *imageViewUser = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 70, 70)];
    imageViewUser.layer.cornerRadius = 8.0;
    imageViewUser.clipsToBounds = YES;
    imageViewUser.tag = 2000;
    [_viewUserInfo addSubview:imageViewUser];
    
    CSButton *btnUser = [CSButton buttonWithType:UIButtonTypeCustom];
    btnUser.frame = imageViewUser.frame;
    btnUser.backgroundColor = [UIColor clearColor];
    btnUser.tag = 1999;
    btnUser.hidden = YES;
    [_viewUserInfo addSubview:btnUser];
    
    __weak __typeof(self) weakSelf = self;
    
    btnUser.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf onClickImageView];
    };
    
    UIImage * imgBK = [UIImage imageNamed:@"level-bg"];
    UIImageView *imgLevelBK = [[UIImageView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(imageViewUser.frame) + 10, 70, 20)];
    imgBK = [imgBK stretchableImageWithLeftCapWidth:floorf(imgBK.size.width/2) topCapHeight:floorf(imgBK.size.height/2)];
    imgLevelBK.image = imgBK;
    [_viewUserInfo addSubview:imgLevelBK];
    
    UILabel *lbLevelValue = [[UILabel alloc]initWithFrame:imgLevelBK.frame];
    lbLevelValue.backgroundColor = [UIColor clearColor];
    lbLevelValue.textColor = [UIColor whiteColor];
    lbLevelValue.font = [UIFont italicSystemFontOfSize:12];
    lbLevelValue.textAlignment = NSTextAlignmentCenter;
    lbLevelValue.tag = 2001;
    [_viewUserInfo addSubview:lbLevelValue];
    
    UILabel *lbScoreValue = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbLevelValue.frame) + 5, 80, 25)];
    lbScoreValue.backgroundColor = [UIColor clearColor];
    lbScoreValue.textColor = [UIColor darkGrayColor];
    lbScoreValue.font = [UIFont boldSystemFontOfSize:13];
    lbScoreValue.textAlignment = NSTextAlignmentCenter;
    lbScoreValue.tag = 2002;
    [_viewUserInfo addSubview:lbScoreValue];

    UILabel * lbTotalDistance = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageViewUser.frame) + 10, 8, (CGRectGetWidth(_viewUserInfo.frame) - (CGRectGetMaxX(imageViewUser.frame) + 10 + 5)) / 3 + 10, 20)];
    lbTotalDistance.backgroundColor = [UIColor clearColor];
    lbTotalDistance.textAlignment = NSTextAlignmentLeft;
    lbTotalDistance.textColor = [UIColor blackColor];
    lbTotalDistance.font = [UIFont boldSystemFontOfSize:18];
    lbTotalDistance.tag = 2003;
    lbTotalDistance.text = @"0.0";
    [_viewUserInfo addSubview:lbTotalDistance];
    
    UILabel * lbMaxforDay = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbTotalDistance.frame), 8, CGRectGetWidth(lbTotalDistance.frame) - 5, 20)];
    lbMaxforDay.backgroundColor = [UIColor clearColor];
    lbMaxforDay.textAlignment = NSTextAlignmentLeft;
    lbMaxforDay.textColor = [UIColor blackColor];
    lbMaxforDay.font = [UIFont boldSystemFontOfSize:18];
    lbMaxforDay.tag = 2004;
    lbMaxforDay.text = @"0.0";
    [_viewUserInfo addSubview:lbMaxforDay];
    
    UILabel * lbFastestSpeed = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbMaxforDay.frame), 8, CGRectGetWidth(lbTotalDistance.frame) - 5, 20)];
    lbFastestSpeed.backgroundColor = [UIColor clearColor];
    lbFastestSpeed.textAlignment = NSTextAlignmentLeft;
    lbFastestSpeed.textColor = [UIColor blackColor];
    lbFastestSpeed.font = [UIFont boldSystemFontOfSize:18];
    lbFastestSpeed.tag = 2005;
    lbFastestSpeed.text = @"0.0";
    [_viewUserInfo addSubview:lbFastestSpeed];
    
    UILabel * lbTotalTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbTotalDistance.frame), CGRectGetMaxY(lbTotalDistance.frame) + 2, CGRectGetWidth(lbTotalDistance.frame), 20)];
    lbTotalTitle.backgroundColor = [UIColor clearColor];
    lbTotalTitle.textAlignment = NSTextAlignmentLeft;
    lbTotalTitle.textColor = [UIColor darkGrayColor];
    lbTotalTitle.font = [UIFont boldSystemFontOfSize:13];
    lbTotalTitle.text = @"总里程";
    [_viewUserInfo addSubview:lbTotalTitle];
    
    UILabel * lbMaxTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbMaxforDay.frame), CGRectGetMaxY(lbMaxforDay.frame) + 2, CGRectGetWidth(lbMaxforDay.frame), 20)];
    lbMaxTitle.backgroundColor = [UIColor clearColor];
    lbMaxTitle.textAlignment = NSTextAlignmentLeft;
    lbMaxTitle.textColor = [UIColor darkGrayColor];
    lbMaxTitle.font = [UIFont boldSystemFontOfSize:13];
    lbMaxTitle.text = @"最长跑距";
    [_viewUserInfo addSubview:lbMaxTitle];
    
    UILabel * lbSpeedTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbFastestSpeed.frame), CGRectGetMaxY(lbFastestSpeed.frame) + 2, CGRectGetWidth(lbFastestSpeed.frame), 20)];
    lbSpeedTitle.backgroundColor = [UIColor clearColor];
    lbSpeedTitle.textAlignment = NSTextAlignmentLeft;
    lbSpeedTitle.textColor = [UIColor darkGrayColor];
    lbSpeedTitle.font = [UIFont boldSystemFontOfSize:13];
    lbSpeedTitle.text = @"最快速度";
    [_viewUserInfo addSubview:lbSpeedTitle];
    
    UILabel * lbTotalUnit = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbTotalTitle.frame), CGRectGetMaxY(lbTotalTitle.frame), CGRectGetWidth(lbTotalTitle.frame), 15)];
    lbTotalUnit.backgroundColor = [UIColor clearColor];
    lbTotalUnit.textAlignment = NSTextAlignmentLeft;
    lbTotalUnit.textColor = [UIColor darkGrayColor];
    lbTotalUnit.font = [UIFont boldSystemFontOfSize:12];
    lbTotalUnit.text = @"km";
    [_viewUserInfo addSubview:lbTotalUnit];
    
    UILabel * lbMaxUnit = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbMaxTitle.frame), CGRectGetMaxY(lbMaxTitle.frame), CGRectGetWidth(lbMaxTitle.frame), 15)];
    lbMaxUnit.backgroundColor = [UIColor clearColor];
    lbMaxUnit.textAlignment = NSTextAlignmentLeft;
    lbMaxUnit.textColor = [UIColor darkGrayColor];
    lbMaxUnit.font = [UIFont boldSystemFontOfSize:12];
    lbMaxUnit.text = @"km";
    [_viewUserInfo addSubview:lbMaxUnit];
    
    UILabel * lbSpeedUnit = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbSpeedTitle.frame), CGRectGetMaxY(lbSpeedTitle.frame), CGRectGetWidth(lbSpeedTitle.frame), 15)];
    lbSpeedUnit.backgroundColor = [UIColor clearColor];
    lbSpeedUnit.textAlignment = NSTextAlignmentLeft;
    lbSpeedUnit.textColor = [UIColor darkGrayColor];
    lbSpeedUnit.font = [UIFont boldSystemFontOfSize:12];
    lbSpeedUnit.text = @"km/h";
    [_viewUserInfo addSubview:lbSpeedUnit];
    
    UILabel *lbSep0 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(lbTotalDistance.frame), CGRectGetMaxY(lbTotalUnit.frame) + 5, (CGRectGetWidth(_viewUserInfo.frame) - CGRectGetMinX(lbTotalDistance.frame)), 1)];
    lbSep0.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    [_viewUserInfo addSubview:lbSep0];
    
    NSString * strStarImage[3] = {@"level-horse", @"level-rabbit", @"level-snail"};
    for(int i = 0; i < 3; i++)
    {
        for(int j = 0; j < 4; j++)
        {
            _imgStar[i * 4 + j] = [[UIImageView alloc] initWithFrame:CGRectMake(j * 20 + CGRectGetMinX(lbTotalDistance.frame), CGRectGetMaxY(lbSep0.frame) + 5 + i * 22, 20, 20)];
            _imgStar[i * 4 + j].image = [UIImage imageNamed:strStarImage[i]];
            [_viewUserInfo addSubview:_imgStar[i * 4 + j]];
            _imgStar[i * 4 + j].hidden = YES;
        }
    }
    
    UILabel *lbSep1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_viewUserInfo.frame) - 1, CGRectGetWidth(_viewUserInfo.frame), 1)];
    lbSep1.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    [_viewUserInfo addSubview:lbSep1];
}

-(CGFloat)updateUserInfoView:(UserInfo*)userInfo
{
    _viewUserInfo.frame = CGRectMake(0, CGRectGetMaxY(_viewPhotoBoard.frame), CGRectGetWidth(_scrollView.frame), 145);
    UIImageView *imageViewUser = (UIImageView*)[_viewUserInfo viewWithTag:2000];
    [imageViewUser sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image]
                             placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    
    CSButton *btnUser = (CSButton*)[_viewUserInfo viewWithTag:1999];
    btnUser.hidden = userInfo.profile_image.length > 0 ? NO : YES;
    
    UILabel *lbLevelValue = (UILabel*)[_viewUserInfo viewWithTag:2001];
    lbLevelValue.text = [NSString stringWithFormat:@"LV. %ld", userInfo.proper_info.rankLevel];
    
    UILabel *lbScoreValue = (UILabel*)[_viewUserInfo viewWithTag:2002];
    lbScoreValue.text = [NSString stringWithFormat:@"总分:%ld", userInfo.proper_info.rankscore];
    
    /*UILabel *lbTotalDistance = (UILabel*)[_viewUserInfo viewWithTag:2003];
    [self setValueWithView:lbTotalDistance ValueDesc:@"总里程 " ValueContent:@"0km"];
    
    UILabel *lbMaxforDay = (UILabel*)[_viewUserInfo viewWithTag:2004];
    [self setValueWithView:lbMaxforDay ValueDesc:@"最长跑距 " ValueContent:@"21.6km"];
    
    UILabel *lbFastestSpeed = (UILabel*)[_viewUserInfo viewWithTag:2005];
    [self setValueWithView:lbFastestSpeed ValueDesc:@"最快速度 " ValueContent:@"21.6km/h"];*/
    
    NSUInteger nLevel = userInfo.proper_info.rankLevel;
    NSUInteger nHorseCount = nLevel / 25;
    NSUInteger nRabbitCount = (nLevel - nHorseCount * 25) / 5;
    NSUInteger nSnailCount = nLevel - nHorseCount * 25 - nRabbitCount * 5;

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
    
    return CGRectGetMaxY(_viewUserInfo.frame);
}

#pragma mark - User Coach Info

-(void)generateCoachView
{
    _viewCoach = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewUserInfo.frame), CGRectGetWidth(_scrollView.frame), 100)];
    _viewCoach.backgroundColor = [UIColor clearColor];
    _viewCoach.hidden = YES;
    [_scrollView addSubview:_viewCoach];
    
    UILabel *lbCoachTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 30, 25)];
    lbCoachTitle.backgroundColor = [UIColor clearColor];
    lbCoachTitle.textColor = [UIColor blackColor];
    lbCoachTitle.font = [UIFont boldSystemFontOfSize:14];
    lbCoachTitle.textAlignment = NSTextAlignmentLeft;
    lbCoachTitle.tag = 3050;
    lbCoachTitle.text = @"教练";
    [_viewCoach addSubview:lbCoachTitle];
    
    UIImageView *imgCoach = [[UIImageView alloc]initWithFrame:CGRectMake(35, CGRectGetMinY(lbCoachTitle.frame) - 5, 40, 40)];
    [imgCoach setImage:[UIImage imageNamed:@"me-coach-applying"]];
    [_viewCoach addSubview:imgCoach];
    
    UILabel *lbIdCardTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 80, 25)];
    lbIdCardTitle.backgroundColor = [UIColor clearColor];
    lbIdCardTitle.textColor = [UIColor darkGrayColor];
    lbIdCardTitle.font = [UIFont boldSystemFontOfSize:13];
    lbIdCardTitle.textAlignment = NSTextAlignmentLeft;
    lbIdCardTitle.tag = 3051;
    lbIdCardTitle.text = @"个人简介";
    [_viewCoach addSubview:lbIdCardTitle];
    
    UILabel *lbIdCardValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbIdCardTitle.frame), CGRectGetMinY(lbIdCardTitle.frame), 100, 25)];
    lbIdCardValue.backgroundColor = [UIColor clearColor];
    lbIdCardValue.textColor = [UIColor blackColor];
    lbIdCardValue.font = [UIFont boldSystemFontOfSize:13];
    lbIdCardValue.textAlignment = NSTextAlignmentLeft;
    lbIdCardValue.tag = 3052;
    [_viewCoach addSubview:lbIdCardValue];
    
    UILabel *lbCertTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbIdCardValue.frame), 80, 25)];
    lbCertTitle.backgroundColor = [UIColor clearColor];
    lbCertTitle.textColor = [UIColor darkGrayColor];
    lbCertTitle.font = [UIFont boldSystemFontOfSize:13];
    lbCertTitle.textAlignment = NSTextAlignmentLeft;
    lbCertTitle.tag = 3053;
    lbCertTitle.text = @"资格证书";
    [_viewCoach addSubview:lbCertTitle];
    
    UILabel *lbCertValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbCertTitle.frame), CGRectGetMinY(lbCertTitle.frame), 100, 25)];
    lbCertValue.backgroundColor = [UIColor clearColor];
    lbCertValue.textColor = [UIColor blackColor];
    lbCertValue.font = [UIFont boldSystemFontOfSize:13];
    lbCertValue.textAlignment = NSTextAlignmentLeft;
    lbCertValue.tag = 3054;
    [_viewCoach addSubview:lbCertValue];
    
    UILabel *lbRecordTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbCertValue.frame), 80, 25)];
    lbRecordTitle.backgroundColor = [UIColor clearColor];
    lbRecordTitle.textColor = [UIColor darkGrayColor];
    lbRecordTitle.font = [UIFont boldSystemFontOfSize:13];
    lbRecordTitle.textAlignment = NSTextAlignmentLeft;
    lbRecordTitle.tag = 3055;
    lbRecordTitle.text = @"运动成绩";
    [_viewCoach addSubview:lbRecordTitle];
    
    UILabel *lbRecordValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbRecordTitle.frame), CGRectGetMinY(lbRecordTitle.frame), 100, 25)];
    lbRecordValue.backgroundColor = [UIColor clearColor];
    lbRecordValue.textColor = [UIColor blackColor];
    lbRecordValue.font = [UIFont boldSystemFontOfSize:13];
    lbRecordValue.textAlignment = NSTextAlignmentLeft;
    lbRecordValue.tag = 3056;
    [_viewCoach addSubview:lbRecordValue];
    
    UILabel *lbSep0 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_viewCoach.frame) - 1, CGRectGetWidth(_viewCoach.frame), 1)];
    lbSep0.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    lbSep0.tag = 3057;
    [_viewCoach addSubview:lbSep0];
}

-(CGFloat)updateCoachPosition:(CGFloat)fStartPoint TagId:(NSInteger)nTag DataCoach:(NSString*)strCoach
{
    CGFloat fPoint = fStartPoint;
    UILabel *lbItemTitle = (UILabel*)[_viewCoach viewWithTag:nTag];
    UILabel *lbItemValue = (UILabel*)[_viewCoach viewWithTag:nTag + 1];
    
    if (strCoach.length > 0) {
        lbItemTitle.hidden = NO;
        lbItemTitle.frame = CGRectMake(5, fStartPoint, 80, 30);
        
        lbItemValue.hidden = NO;
        lbItemValue.text = strCoach;
        
        //CGSize lbSize = [lbItemValue.text sizeWithFont:lbItemValue.font
        //                         constrainedToSize:CGSizeMake(300 - 90, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize lbSize = [lbItemValue.text boundingRectWithSize:CGSizeMake(300 - 90, FLT_MAX)
                                                       options:options
                                                    attributes:@{NSFontAttributeName:lbItemValue.font} context:nil].size;
        lbItemValue.numberOfLines = 0;
        lbItemValue.frame = CGRectMake(CGRectGetMaxX(lbItemTitle.frame) + 5, CGRectGetMinY(lbItemTitle.frame), 210, MAX(lbSize.height + 10, 30));
        
        fPoint = CGRectGetMaxY(lbItemValue.frame);
    }
    else
    {
        lbItemTitle.hidden = YES;
        lbItemValue.hidden = YES;
    }
    
    return fPoint;
}

-(void)updateCoachView:(UserInfo*)userInfo
{
    CGFloat fStartPoint = 45;
    
    fStartPoint = [self updateCoachPosition:fStartPoint TagId:3051 DataCoach:userInfo.auth_info.idcard.auth_desc];
    fStartPoint = [self updateCoachPosition:fStartPoint TagId:3053 DataCoach:userInfo.auth_info.cert.auth_desc];
    fStartPoint = [self updateCoachPosition:fStartPoint TagId:3055 DataCoach:userInfo.auth_info.record.auth_desc];
    
    _viewCoach.frame = CGRectMake(0, CGRectGetMaxY(_viewUserInfo.frame), CGRectGetWidth(_scrollView.frame), fStartPoint + 5);
    UILabel *lbSep0 = (UILabel*)[_viewCoach viewWithTag:3057];
    lbSep0.frame = CGRectMake(0, CGRectGetHeight(_viewCoach.frame) - 1, CGRectGetWidth(_viewCoach.frame), 1);
    _viewCoach.hidden = (fStartPoint == 45 ? YES : NO);
}

#pragma mark - User Equipment Info

-(void)generateUserEquipmentView
{
    _viewUserEquip = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewCoach.frame), CGRectGetWidth(_viewCoach.frame), 100)];
    _viewUserEquip.backgroundColor = [UIColor clearColor];
    _viewUserEquip.hidden = YES;
    [_scrollView addSubview:_viewUserEquip];
    
    UILabel *lbEquipTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 80, 25)];
    lbEquipTitle.backgroundColor = [UIColor clearColor];
    lbEquipTitle.textColor = [UIColor blackColor];
    lbEquipTitle.font = [UIFont boldSystemFontOfSize:14];
    lbEquipTitle.textAlignment = NSTextAlignmentLeft;
    lbEquipTitle.tag = 3001;
    lbEquipTitle.text = @"装备";
    [_viewUserEquip addSubview:lbEquipTitle];
    
    UILabel *lbEqShoe = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbEquipTitle.frame), 80, 25)];
    lbEqShoe.backgroundColor = [UIColor clearColor];
    lbEqShoe.textColor = [UIColor darkGrayColor];
    lbEqShoe.font = [UIFont boldSystemFontOfSize:13];
    lbEqShoe.textAlignment = NSTextAlignmentLeft;
    lbEqShoe.tag = 3002;
    lbEqShoe.text = @"跑鞋";
    [_viewUserEquip addSubview:lbEqShoe];
    
    UILabel *lbEqShoeName = [[UILabel alloc]init];
    lbEqShoeName.font = [UIFont boldSystemFontOfSize:13.0];
    lbEqShoeName.textAlignment = NSTextAlignmentLeft;
    lbEqShoeName.backgroundColor = [UIColor clearColor];
    lbEqShoeName.textColor = [UIColor blackColor];
    lbEqShoeName.frame = CGRectMake(CGRectGetMaxX(lbEqShoe.frame), CGRectGetMinY(lbEqShoe.frame), 40, 40);
    lbEqShoeName.tag = 3003;
    [_viewUserEquip addSubview:lbEqShoeName];
    
    UIImageView *imgViewEqShoe = [[UIImageView alloc]init];
    imgViewEqShoe.tag = 3004;
    [_viewUserEquip addSubview:imgViewEqShoe];
    
    UILabel *lbEqShoeModel = [[UILabel alloc]init];
    lbEqShoeModel.font = [UIFont boldSystemFontOfSize:12.0];
    lbEqShoeModel.textAlignment = NSTextAlignmentLeft;
    lbEqShoeModel.backgroundColor = [UIColor clearColor];
    lbEqShoeModel.textColor = [UIColor darkGrayColor];
    lbEqShoeModel.tag = 3005;
    [_viewUserEquip addSubview:lbEqShoeModel];
    
    UILabel *lbEqCircle = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbEqShoe.frame), 80, 25)];
    lbEqCircle.backgroundColor = [UIColor clearColor];
    lbEqCircle.textColor = [UIColor darkGrayColor];
    lbEqCircle.font = [UIFont boldSystemFontOfSize:13];
    lbEqCircle.textAlignment = NSTextAlignmentLeft;
    lbEqCircle.tag = 3006;
    lbEqCircle.text = @"可穿戴设备";
    [_viewUserEquip addSubview:lbEqCircle];
    
    UILabel *lbEqCircleName = [[UILabel alloc]init];
    lbEqCircleName.font = [UIFont boldSystemFontOfSize:13.0];
    lbEqCircleName.textAlignment = NSTextAlignmentLeft;
    lbEqCircleName.backgroundColor = [UIColor clearColor];
    lbEqCircleName.textColor = [UIColor blackColor];
    lbEqCircleName.frame = CGRectMake(CGRectGetMaxX(lbEqCircle.frame), CGRectGetMinY(lbEqCircle.frame), 40, 40);
    lbEqCircleName.tag = 3007;
    [_viewUserEquip addSubview:lbEqCircleName];
    
    UIImageView *imgViewEqCircle = [[UIImageView alloc]init];
    imgViewEqCircle.tag = 3008;
    [_viewUserEquip addSubview:imgViewEqCircle];
    
    UILabel *lbEqCircleModel = [[UILabel alloc]init];
    lbEqCircleModel.font = [UIFont boldSystemFontOfSize:12.0];
    lbEqCircleModel.textAlignment = NSTextAlignmentLeft;
    lbEqCircleModel.backgroundColor = [UIColor clearColor];
    lbEqCircleModel.textColor = [UIColor darkGrayColor];
    lbEqCircleModel.tag = 3009;
    [_viewUserEquip addSubview:lbEqCircleModel];
    
    UILabel *lbEqApp = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbEqCircle.frame), 80, 25)];
    lbEqApp.backgroundColor = [UIColor clearColor];
    lbEqApp.textColor = [UIColor darkGrayColor];
    lbEqApp.font = [UIFont boldSystemFontOfSize:13];
    lbEqApp.textAlignment = NSTextAlignmentLeft;
    lbEqApp.tag = 3010;
    lbEqApp.text = @"轨迹记录App";
    [_viewUserEquip addSubview:lbEqApp];

    UILabel *lbEqAppName = [[UILabel alloc]init];
    lbEqAppName.font = [UIFont boldSystemFontOfSize:13.0];
    lbEqAppName.textAlignment = NSTextAlignmentLeft;
    lbEqAppName.backgroundColor = [UIColor clearColor];
    lbEqAppName.textColor = [UIColor blackColor];
    lbEqAppName.frame = CGRectMake(CGRectGetMaxX(lbEqApp.frame), CGRectGetMinY(lbEqApp.frame), 40, 40);
    lbEqAppName.tag = 3011;
    [_viewUserEquip addSubview:lbEqAppName];
    
    UIImageView *imgViewEqApp = [[UIImageView alloc]init];
    imgViewEqApp.tag = 3012;
    [_viewUserEquip addSubview:imgViewEqApp];
    
    UILabel *lbEqAppModel = [[UILabel alloc]init];
    lbEqAppModel.font = [UIFont boldSystemFontOfSize:12.0];
    lbEqAppModel.textAlignment = NSTextAlignmentLeft;
    lbEqAppModel.backgroundColor = [UIColor clearColor];
    lbEqAppModel.textColor = [UIColor darkGrayColor];
    lbEqAppModel.tag = 3013;
    [_viewUserEquip addSubview:lbEqAppModel];

    UILabel *lbSep0 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_viewUserEquip.frame) - 1, CGRectGetWidth(_viewUserEquip.frame), 1)];
    lbSep0.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    lbSep0.tag = 3014;
    [_viewUserEquip addSubview:lbSep0];
}

-(CGFloat)updateEquipPosition:(CGFloat)fStartPoint TagId:(NSInteger)nTag DataEquip:(NSMutableArray*)arrDataEquip
{
    CGFloat fPoint = fStartPoint;
    UILabel *lbEq = (UILabel*)[_viewUserEquip viewWithTag:nTag];
    UILabel *lbEqName = (UILabel*)[_viewUserEquip viewWithTag:nTag + 1];
    UIImageView *imgViewEq = (UIImageView*)[_viewUserEquip viewWithTag:nTag + 2];
    UILabel *lbEqModel = (UILabel*)[_viewUserEquip viewWithTag:nTag + 3];
    
    NSString *strData = arrDataEquip.firstObject;
    
    if (strData.length > 0) {
        lbEq.hidden = NO;
        lbEq.frame = CGRectMake(5, fStartPoint, 80, 30);
        
        NSString *strName = @"";
        NSString *strModel = @"";
        NSString *strImg = @"";
        
        NSArray *list = [strData componentsSeparatedByString:@"###"];
        
        if ([list count] == 1) {
            strName = list[0];
            strImg = [NSString stringWithFormat:@"%@-small", list[0]];
        }
        else
        {
            strName = list[0];
            strModel = list[1];
            strImg = [NSString stringWithFormat:@"%@-small", list[0]];
        }
        
        lbEqName.hidden = NO;
        lbEqName.text = strName;
        
        //CGSize lbSize = [lbEqName.text sizeWithFont:lbEqName.font
        //                              constrainedToSize:CGSizeMake(FLT_MAX, 30) lineBreakMode:NSLineBreakByWordWrapping];
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize lbSize = [lbEqName.text boundingRectWithSize:CGSizeMake(FLT_MAX, 30)
                                                           options:options
                                                        attributes:@{NSFontAttributeName:lbEqName.font} context:nil].size;
        
        lbEqName.frame = CGRectMake(CGRectGetMaxX(lbEq.frame) + 5, CGRectGetMinY(lbEq.frame), MIN(CGRectGetWidth(_scrollView.frame) - (CGRectGetMaxX(lbEq.frame) + 5), lbSize.width), 30);
        
        lbEqModel.hidden = NO;
        
        //CGSize lbSize1 = [lbEqModel.text sizeWithFont:lbEqModel.font
        //                                constrainedToSize:CGSizeMake(FLT_MAX, 30) lineBreakMode:NSLineBreakByWordWrapping];
        
        
        NSString *path = [[NSBundle mainBundle] pathForResource:strImg ofType:@"webp"];
        
        if(path == NULL)
        {
            imgViewEq.hidden = YES;
        }
        else
        {
            UIImage *image = [UIImage imageNamedWithWebP:strImg];
            imgViewEq.hidden = NO;
            [imgViewEq setImage:image];
            imgViewEq.frame = CGRectMake(CGRectGetMaxX(lbEqName.frame) + 5, CGRectGetMinY(lbEqName.frame), 66, 27);
        }
        
        if (strModel.length > 0) {
            lbEqModel.text = [NSString stringWithFormat:@"%@(型号)", strModel];
            
            CGSize lbSize1 = [lbEqModel.text boundingRectWithSize:CGSizeMake(310 - 95, FLT_MAX)
                                                          options:options
                                                       attributes:@{NSFontAttributeName:lbEqModel.font} context:nil].size;
            lbEqModel.frame = CGRectMake(CGRectGetMaxX(lbEq.frame) + 5, CGRectGetMaxY(lbEq.frame), 310 - 95, lbSize1.height);
        }
        
        fPoint = (strModel.length > 0 ? CGRectGetMaxY(lbEqModel.frame) + 10 : CGRectGetMaxY(lbEq.frame));
    }
    else
    {
        lbEq.hidden = YES;
        lbEqName.hidden = YES;
        imgViewEq.hidden = YES;
        lbEqModel.hidden = YES;
    }
    
    return fPoint;
}

-(void)updateEquipmentView:(UserInfo*)userInfo
{
    if (userInfo.user_equipInfo.run_shoe.data.count == 0 && userInfo.user_equipInfo.ele_product.data.count == 0
        && userInfo.user_equipInfo.step_tool.data.count == 0) {
        _viewUserEquip.hidden = YES;
    }
    else
    {
        UILabel *lbEquipTitle = (UILabel*)[_viewUserEquip viewWithTag:3001];
        lbEquipTitle.frame = CGRectMake(5, 10, 150, 25);
        
        CGFloat fStartPoint = CGRectGetMaxY(lbEquipTitle.frame);
        fStartPoint = [self updateEquipPosition:fStartPoint TagId:3002 DataEquip:userInfo.user_equipInfo.run_shoe.data];
        fStartPoint = [self updateEquipPosition:fStartPoint TagId:3006 DataEquip:userInfo.user_equipInfo.ele_product.data];
        fStartPoint = [self updateEquipPosition:fStartPoint TagId:3010 DataEquip:userInfo.user_equipInfo.step_tool.data];
        
        _viewUserEquip.frame = CGRectMake(0, CGRectGetMaxY(_viewCoach != nil && !_viewCoach.isHidden ? _viewCoach.frame : _viewUserInfo.frame), CGRectGetWidth(_scrollView.frame), fStartPoint + 5);
        UILabel *lbSep0 = (UILabel*)[_viewUserEquip viewWithTag:3014];
        lbSep0.frame = CGRectMake(0, CGRectGetHeight(_viewUserEquip.frame) - 1, CGRectGetWidth(_viewUserEquip.frame), 1);

        _viewUserEquip.hidden = (fStartPoint == CGRectGetMaxY(lbEquipTitle.frame) ? YES : NO);
    }
}

#pragma mark - User Advance Info

-(void)generateUserAdvanceView
{
    _viewAdvance = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewUserEquip.frame), CGRectGetWidth(_scrollView.frame), 100)];
    _viewAdvance.backgroundColor = [UIColor clearColor];
    _viewAdvance.hidden = YES;
    [_scrollView addSubview:_viewAdvance];
    
    UILabel *lbSignTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 100, 25)];
    lbSignTitle.backgroundColor = [UIColor clearColor];
    lbSignTitle.textColor = [UIColor darkGrayColor];
    lbSignTitle.font = [UIFont boldSystemFontOfSize:13];
    lbSignTitle.textAlignment = NSTextAlignmentLeft;
    lbSignTitle.tag = 4001;
    lbSignTitle.text = @"签名";
    [_viewAdvance addSubview:lbSignTitle];
    
    UILabel *lbSignValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbSignTitle.frame), CGRectGetMinY(lbSignTitle.frame), 100, 25)];
    lbSignValue.backgroundColor = [UIColor clearColor];
    lbSignValue.textColor = [UIColor blackColor];
    lbSignValue.font = [UIFont boldSystemFontOfSize:13];
    lbSignValue.textAlignment = NSTextAlignmentLeft;
    lbSignValue.tag = 4002;
    [_viewAdvance addSubview:lbSignValue];
    
    UILabel *lbEmotionTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbSignValue.frame), 100, 25)];
    lbEmotionTitle.backgroundColor = [UIColor clearColor];
    lbEmotionTitle.textColor = [UIColor darkGrayColor];
    lbEmotionTitle.font = [UIFont boldSystemFontOfSize:13];
    lbEmotionTitle.textAlignment = NSTextAlignmentLeft;
    lbEmotionTitle.tag = 4003;
    lbEmotionTitle.text = @"情感状态";
    [_viewAdvance addSubview:lbEmotionTitle];
    
    UILabel *lbEmotionValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbEmotionTitle.frame), CGRectGetMinY(lbEmotionTitle.frame), 100, 25)];
    lbEmotionValue.backgroundColor = [UIColor clearColor];
    lbEmotionValue.textColor = [UIColor blackColor];
    lbEmotionValue.font = [UIFont boldSystemFontOfSize:13];
    lbEmotionValue.textAlignment = NSTextAlignmentLeft;
    lbEmotionValue.tag = 4004;
    [_viewAdvance addSubview:lbEmotionValue];
    
    UILabel *lbProfessionTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbEmotionValue.frame), 100, 25)];
    lbProfessionTitle.backgroundColor = [UIColor clearColor];
    lbProfessionTitle.textColor = [UIColor darkGrayColor];
    lbProfessionTitle.font = [UIFont boldSystemFontOfSize:13];
    lbProfessionTitle.textAlignment = NSTextAlignmentLeft;
    lbProfessionTitle.tag = 4005;
    lbProfessionTitle.text = @"职业";
    [_viewAdvance addSubview:lbProfessionTitle];
    
    UILabel *lbProfessionValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbProfessionTitle.frame), CGRectGetMinY(lbProfessionTitle.frame), 100, 25)];
    lbProfessionValue.backgroundColor = [UIColor clearColor];
    lbProfessionValue.textColor = [UIColor blackColor];
    lbProfessionValue.font = [UIFont boldSystemFontOfSize:13];
    lbProfessionValue.textAlignment = NSTextAlignmentLeft;
    lbProfessionValue.tag = 4006;
    [_viewAdvance addSubview:lbProfessionValue];
    
    UILabel *lbFontTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbProfessionValue.frame), 100, 25)];
    lbFontTitle.backgroundColor = [UIColor clearColor];
    lbFontTitle.textColor = [UIColor darkGrayColor];
    lbFontTitle.font = [UIFont boldSystemFontOfSize:13];
    lbFontTitle.textAlignment = NSTextAlignmentLeft;
    lbFontTitle.tag = 4007;
    lbFontTitle.text = @"兴趣爱好";
    [_viewAdvance addSubview:lbFontTitle];
    
    UILabel *lbFontValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbFontTitle.frame), CGRectGetMinY(lbFontTitle.frame), 100, 25)];
    lbFontValue.backgroundColor = [UIColor clearColor];
    lbFontValue.textColor = [UIColor blackColor];
    lbFontValue.font = [UIFont boldSystemFontOfSize:13];
    lbFontValue.textAlignment = NSTextAlignmentLeft;
    lbFontValue.tag = 4008;
    [_viewAdvance addSubview:lbFontValue];
    
    UILabel *lbHomeTownTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbFontValue.frame), 100, 25)];
    lbHomeTownTitle.backgroundColor = [UIColor clearColor];
    lbHomeTownTitle.textColor = [UIColor darkGrayColor];
    lbHomeTownTitle.font = [UIFont boldSystemFontOfSize:13];
    lbHomeTownTitle.textAlignment = NSTextAlignmentLeft;
    lbHomeTownTitle.tag = 4009;
    lbHomeTownTitle.text = @"家乡";
    [_viewAdvance addSubview:lbHomeTownTitle];
    
    UILabel *lbHomeTownValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbHomeTownTitle.frame), CGRectGetMinY(lbHomeTownTitle.frame), 100, 25)];
    lbHomeTownValue.backgroundColor = [UIColor clearColor];
    lbHomeTownValue.textColor = [UIColor blackColor];
    lbHomeTownValue.font = [UIFont boldSystemFontOfSize:13];
    lbHomeTownValue.textAlignment = NSTextAlignmentLeft;
    lbHomeTownValue.tag = 4010;
    [_viewAdvance addSubview:lbHomeTownValue];
    
    UILabel *lbAppearTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(lbHomeTownValue.frame), 100, 25)];
    lbAppearTitle.backgroundColor = [UIColor clearColor];
    lbAppearTitle.textColor = [UIColor darkGrayColor];
    lbAppearTitle.font = [UIFont boldSystemFontOfSize:13];
    lbAppearTitle.textAlignment = NSTextAlignmentLeft;
    lbAppearTitle.tag = 4011;
    lbAppearTitle.text = @"常出没地";
    [_viewAdvance addSubview:lbAppearTitle];
    
    UILabel *lbAppearnValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbAppearTitle.frame), CGRectGetMinY(lbAppearTitle.frame), 100, 25)];
    lbAppearnValue.backgroundColor = [UIColor clearColor];
    lbAppearnValue.textColor = [UIColor blackColor];
    lbAppearnValue.font = [UIFont boldSystemFontOfSize:13];
    lbAppearnValue.textAlignment = NSTextAlignmentLeft;
    lbAppearnValue.tag = 4012;
    [_viewAdvance addSubview:lbAppearnValue];
    
    UILabel *lbSep0 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_viewAdvance.frame) - 1, CGRectGetWidth(_viewAdvance.frame), 1)];
    lbSep0.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    lbSep0.tag = 4013;
    [_viewAdvance addSubview:lbSep0];
}

-(CGFloat)updateAdvancePosition:(CGFloat)fStartPoint TagId:(NSInteger)nTag DataAdvance:(NSString*)strAdvance
{
    CGFloat fPoint = fStartPoint;
    UILabel *lbItemTitle = (UILabel*)[_viewAdvance viewWithTag:nTag];
    UILabel *lbItemValue = (UILabel*)[_viewAdvance viewWithTag:nTag + 1];
    
    if (strAdvance.length > 0) {
        lbItemTitle.hidden = NO;
        lbItemTitle.frame = CGRectMake(5, fStartPoint, 80, 30);
        
        lbItemValue.hidden = NO;
        lbItemValue.text = strAdvance;
        
        //CGSize lbSize = [lbItemValue.text sizeWithFont:lbItemValue.font
         //                         constrainedToSize:CGSizeMake(300 - 90, FLT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        CGSize lbSize = [lbItemValue.text boundingRectWithSize:CGSizeMake(300 - 90, FLT_MAX)
                                                           options:options
                                                        attributes:@{NSFontAttributeName:lbItemValue.font} context:nil].size;
        lbItemValue.numberOfLines = 0;
        lbItemValue.frame = CGRectMake(CGRectGetMaxX(lbItemTitle.frame) + 5, CGRectGetMinY(lbItemTitle.frame), 210, MAX(lbSize.height + 10, 30));
        
        fPoint = CGRectGetMaxY(lbItemValue.frame);
    }
    else
    {
        lbItemTitle.hidden = YES;
        lbItemValue.hidden = YES;
    }
    
    return fPoint;
}

-(void)updateAdvanceView:(UserInfo*)userInfo
{
    CGFloat fStartPoint = 10;
    
    fStartPoint = [self updateAdvancePosition:fStartPoint TagId:4001 DataAdvance:userInfo.sign];
    fStartPoint = [self updateAdvancePosition:fStartPoint TagId:4003 DataAdvance:[self convertEmotionToHanzi:userInfo.emotion]];
    fStartPoint = [self updateAdvancePosition:fStartPoint TagId:4005 DataAdvance:userInfo.profession];
    fStartPoint = [self updateAdvancePosition:fStartPoint TagId:4007 DataAdvance:userInfo.fond];
    fStartPoint = [self updateAdvancePosition:fStartPoint TagId:4009 DataAdvance:userInfo.hometown];
    fStartPoint = [self updateAdvancePosition:fStartPoint TagId:4011 DataAdvance:userInfo.oftenAppear];
    
    _viewAdvance.frame = CGRectMake(0, CGRectGetMaxY(_viewUserEquip != nil ? _viewUserEquip.frame : (_viewCoach != nil && !_viewCoach.isHidden ? _viewCoach.frame : _viewUserInfo.frame)), CGRectGetWidth(_scrollView.frame), fStartPoint + 5);
    UILabel *lbSep0 = (UILabel*)[_viewAdvance viewWithTag:4013];
    lbSep0.frame = CGRectMake(0, CGRectGetHeight(_viewAdvance.frame) - 1, CGRectGetWidth(_viewAdvance.frame), 1);
    _viewAdvance.hidden = (fStartPoint == 10 ? YES : NO);
}

#pragma mark - User AdvanceEx Info

-(CGFloat)generateAdvanceExItem:(CGFloat)fStartY TitleImg:(NSString*)strImg Title:(NSString*)strTitle Tag:(NSInteger)nTag
{
    UIImageView *imgViewTitle = [[UIImageView alloc]initWithFrame:CGRectMake(5, fStartY, 40, 40)];
    [imgViewTitle setImage:[UIImage imageNamed:strImg]];
    imgViewTitle.tag = nTag;
    [_viewAdvanceEx addSubview:imgViewTitle];
    
    UILabel *lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(90, fStartY + 20 - 25 / 2, 80, 25)];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.textColor = [UIColor blackColor];
    lbTitle.font = [UIFont boldSystemFontOfSize:13];
    lbTitle.textAlignment = NSTextAlignmentLeft;
    lbTitle.tag = nTag + 1;
    lbTitle.text = strTitle;
    [_viewAdvanceEx addSubview:lbTitle];
    
    UILabel *lbNum = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbTitle.frame), CGRectGetMinY(lbTitle.frame), 80, 25)];
    lbNum.backgroundColor = [UIColor clearColor];
    lbNum.textColor = [UIColor darkGrayColor];
    lbNum.font = [UIFont boldSystemFontOfSize:13];
    lbNum.textAlignment = NSTextAlignmentLeft;
    lbNum.tag = nTag + 2;
    [_viewAdvanceEx addSubview:lbNum];
    
    UIImageView *imgViewMore = [[UIImageView alloc]initWithFrame:CGRectMake(310 - 18, fStartY + 20 - 16 / 2, 8, 16)];
    [imgViewMore setImage:[UIImage imageNamed:@"arrow-1"]];
    imgViewMore.tag = nTag + 3;
    [_viewAdvanceEx addSubview:imgViewMore];
    
    CSButton *btnAction = [CSButton buttonWithType:UIButtonTypeCustom];
    btnAction.backgroundColor = [UIColor clearColor];
    btnAction.tag = nTag + 4;
    btnAction.frame = CGRectMake(0, fStartY - 5, CGRectGetWidth(_viewAdvanceEx.frame), 50);
    [_viewAdvanceEx addSubview:btnAction];
    [_viewAdvanceEx bringSubviewToFront:btnAction];
    
    UILabel *lbSep0 = [[UILabel alloc]initWithFrame:CGRectMake(90, fStartY + 45 - 1, CGRectGetWidth(_viewAdvanceEx.frame) - 90, 1)];
    lbSep0.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    [_viewAdvanceEx addSubview:lbSep0];
    
    if ([strImg isEqualToString:@"other-info-followers"]) {
        lbSep0.frame = CGRectMake(0, fStartY + 45 - 1, CGRectGetWidth(_viewAdvanceEx.frame), 1);
    }
    
    return CGRectGetMaxY(lbSep0.frame) + 5;
}

-(void)generateUserAdvanceExView
{
    _viewAdvanceEx = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewAdvance.frame), CGRectGetWidth(_scrollView.frame), 200)];
    _viewAdvanceEx.backgroundColor = [UIColor clearColor];
    _viewAdvanceEx.hidden = YES;
    [_scrollView addSubview:_viewAdvanceEx];
    
    CGFloat fStartPoint = 10;
    fStartPoint = [self generateAdvanceExItem:fStartPoint TitleImg:@"me-blog" Title:@"他的博文" Tag:5000];
    fStartPoint = [self generateAdvanceExItem:fStartPoint TitleImg:@"me-history" Title:@"他的江湖史" Tag:5005];
    fStartPoint = [self generateAdvanceExItem:fStartPoint TitleImg:@"other-info-follow" Title:@"他的关注" Tag:5010];
    [self generateAdvanceExItem:fStartPoint TitleImg:@"other-info-followers" Title:@"他的粉丝" Tag:5015];
}

-(void)updateUserAdvanceExView:(UserInfo*)userInfo
{
    CGFloat fPointY;
    
    if (_viewAdvance == nil || _viewAdvance.hidden) {
        if (_viewUserEquip == nil || _viewUserEquip.hidden) {
            if (_viewCoach == nil || _viewCoach.hidden) {
                fPointY = CGRectGetMaxY(_viewUserInfo.frame);
            }
            else
            {
                fPointY = CGRectGetMaxY(_viewCoach.frame);
            }
        }
        else
        {
            fPointY = CGRectGetMaxY(_viewUserEquip.frame);
        }
    }
    else
    {
        fPointY = CGRectGetMaxY(_viewAdvance.frame);
    }
    
    UILabel *lbTitleBloc = (UILabel*)[_viewAdvanceEx viewWithTag:5001];
    UILabel *lbNumBloc = (UILabel*)[_viewAdvanceEx viewWithTag:5002];
    CSButton *btnActionBloc = (CSButton*)[_viewAdvanceEx viewWithTag:5004];
    
    UILabel *lbTitleHistory = (UILabel*)[_viewAdvanceEx viewWithTag:5006];
    UILabel *lbNumHistory = (UILabel*)[_viewAdvanceEx viewWithTag:5007];
    CSButton *btnActionHistroy = (CSButton*)[_viewAdvanceEx viewWithTag:5009];
    
    UILabel *lbTitleAttention = (UILabel*)[_viewAdvanceEx viewWithTag:5011];
    UILabel *lbNumAttention = (UILabel*)[_viewAdvanceEx viewWithTag:5012];
    CSButton *btnActionAttention = (CSButton*)[_viewAdvanceEx viewWithTag:5014];
    
    UILabel *lbTitleFans = (UILabel*)[_viewAdvanceEx viewWithTag:5016];
    UILabel *lbNumFans = (UILabel*)[_viewAdvanceEx viewWithTag:5017];
    CSButton *btnActionFans = (CSButton*)[_viewAdvanceEx viewWithTag:5019];

    if ([[[ApplicationContext sharedInstance]accountInfo].userid isEqualToString:_strUserId]) {
        lbTitleBloc.text = @"我的博文";
        lbTitleHistory.text = @"我的江湖史";
        lbTitleAttention.text = @"我的关注";
        lbTitleFans.text = @"我的粉丝";
    }
    else if ([userInfo.sex_type isEqualToString:sex_male]) {
        lbTitleBloc.text = @"他的博文";
        lbTitleHistory.text = @"他的江湖史";
        lbTitleAttention.text = @"他的关注";
        lbTitleFans.text = @"他的粉丝";
    }
    else
    {
        lbTitleBloc.text = @"她的博文";
        lbTitleHistory.text = @"她的江湖史";
        lbTitleAttention.text = @"她的关注";
        lbTitleFans.text = @"她的粉丝";
    }
    
    lbNumBloc.text = [NSString stringWithFormat:@"共%lu篇", userInfo.post_count];
    lbNumHistory.hidden = YES;
    lbNumAttention.text = [NSString stringWithFormat:@"%lu", userInfo.attention_count];
    lbNumFans.text = [NSString stringWithFormat:@"%lu", userInfo.fans_count];
    
    __weak __typeof(self) weakSelf = self;
    
    btnActionBloc.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        ArticleCircleViewController * articleCircleViewController = [[ArticleCircleViewController alloc]init];
        articleCircleViewController.strAuthorId = userInfo.userid;
        articleCircleViewController.bComment = NO;

        [strongSelf.navigationController pushViewController:articleCircleViewController animated:YES];
    };

    btnActionHistroy.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        HistoryViewController *historyViewController = [[HistoryViewController alloc]init];
        historyViewController.userInfo = userInfo;
        [historyViewController setHistoryType:HISTORY_TYPE_ALL];
        [strongSelf.navigationController pushViewController:historyViewController animated:YES];
    };

    btnActionAttention.actionBlock = ^void()
    {
        typeof(self) strongSelf = weakSelf;
        
        RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
        relatedPeoplesViewController.eRelatedType = e_related_people_attention;
        relatedPeoplesViewController.strUserId = userInfo.userid;
        [strongSelf.navigationController pushViewController:relatedPeoplesViewController animated:YES];
    };
    
    btnActionFans.actionBlock = ^void()
    {
        typeof(self) strongSelf = weakSelf;
        
        RelatedPeoplesViewController *relatedPeoplesViewController = [[RelatedPeoplesViewController alloc]init];
        relatedPeoplesViewController.eRelatedType = e_related_people_fans;
        relatedPeoplesViewController.strUserId = userInfo.userid;
        [strongSelf.navigationController pushViewController:relatedPeoplesViewController animated:YES];
    };

    _viewAdvanceEx.frame = CGRectMake(0,fPointY, CGRectGetWidth(_scrollView.frame), 200);
}

#pragma mark - User Bottom Relate Action

-(void)generateUserRelateAction
{
    _viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame) - 46, CGRectGetWidth(self.view.frame), 46)];
    UIImage *image = [UIImage imageNamed:@"tool-bg-1"];
    _viewBottom.layer.contents = (id) image.CGImage;
    _viewBottom.hidden = YES;
    [self.view addSubview:_viewBottom];
    
    _btnAttention = [[CSButton alloc] initWithFrame:CGRectMake(10, 3, 70, 40)];
    [_btnAttention setImage:[UIImage imageNamed:@"other-info-tool-follow"] forState:UIControlStateNormal];
    [_btnAttention setTitle:@"关注" forState:UIControlStateNormal];
    [_btnAttention.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [_btnAttention setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_viewBottom addSubview:_btnAttention];
    
    _btnChat = [[CSButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_viewBottom.frame) / 2 - 35, 3, 70, 40)];
    [_btnChat setImage:[UIImage imageNamed:@"other-info-tool-chat2"] forState:UIControlStateNormal];
    [_btnChat setTitle:@"私聊" forState:UIControlStateNormal];
    [_btnChat.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [_btnChat setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_viewBottom addSubview:_btnChat];
    
    _btnBlackList = [[CSButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_viewBottom.frame) - 10 - 70, 3, 70, 40)];
    [_btnBlackList setImage:[UIImage imageNamed:@"contact-blackList-1"] forState:UIControlStateNormal];
    [_btnBlackList setTitle:@"拉黑" forState:UIControlStateNormal];
    [_btnBlackList.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [_btnBlackList setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_viewBottom addSubview:_btnBlackList];
    
    __weak typeof (self) thisPoint = self;
    
    _btnAttention.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
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
        
        if ([userInfo.userid isEqualToString:thisStrongPoint->_strUserId]) {
            [JDStatusBarNotification showWithStatus:@"亲，不可以关注自己哦！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleDefault];
            return;
        }
        
        BOOL bAttention = false;
        if([thisStrongPoint->_userInfo.relation isEqualToString:@"ATTENTION"] || [thisStrongPoint->_userInfo.relation isEqualToString:@"FRIENDS"])
        {
            bAttention = YES;
        }
        
        [[SportForumAPI sharedInstance] userEnableAttentionByUserId:@[thisStrongPoint->_strUserId]
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
                 [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
             }
         }];
    };
    
    _btnChat.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
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
        
        if ([userInfo.userid isEqualToString:thisStrongPoint->_strUserId]) {
            [JDStatusBarNotification showWithStatus:@"亲，不可以和自己聊天哦！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleDefault];
            return;
        }
        else if(![thisStrongPoint->_userInfo.relation isEqualToString:@"FRIENDS"])
        {
            [JDStatusBarNotification showWithStatus:@"你和Ta还不是朋友，还不能进行私聊！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleDefault];
            return;
        }
        
        ChatMessageTableViewController *chatMessageTableViewController = [[ChatMessageTableViewController alloc]init];
        chatMessageTableViewController.userId = thisStrongPoint->_strUserId;
        chatMessageTableViewController.useProImage = thisStrongPoint->_userInfo.profile_image;
        chatMessageTableViewController.useNickName = thisStrongPoint->_userInfo.nikename;
        [thisStrongPoint.navigationController pushViewController:chatMessageTableViewController animated:YES];
    };
    
    _btnBlackList.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
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
        
        if ([userInfo.userid isEqualToString:thisStrongPoint->_strUserId]) {
            [JDStatusBarNotification showWithStatus:@"亲，不可以把自己拉黑哦！" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleDefault];
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
        
        [[SportForumAPI sharedInstance] userDeFriendByUserId:@[thisStrongPoint->_strUserId]
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
                [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
             }
         }];
    };
}

-(void)updateRelateState:(UserInfo*)userInfo
{
    BOOL bDeFriend = false;
    if([userInfo.relation isEqualToString:@"DEFRIEND"])
    {
        bDeFriend = YES;
    }
    
    BOOL bAttention = false;
    if([userInfo.relation isEqualToString:@"ATTENTION"] || [userInfo.relation isEqualToString:@"FRIENDS"])
    {
        bAttention = YES;
    }
    
    if(bDeFriend)
    {
        [_btnBlackList setImage:[UIImage imageNamed:@"other-info-tool-unblock"] forState:UIControlStateNormal];
        [_btnBlackList setTitle:@"取消" forState:UIControlStateNormal];
    }
    else
    {
        [_btnBlackList setImage:[UIImage imageNamed:@"contact-blackList-1"] forState:UIControlStateNormal];
        [_btnBlackList setTitle:@"拉黑" forState:UIControlStateNormal];
    }
    
    if(bAttention)
    {
        [_btnAttention setTitle:@"取消" forState:UIControlStateNormal];
    }
    else
    {
        [_btnAttention setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    _btnAttention.enabled = !bDeFriend;
    _viewBottom.hidden = NO;
}

#pragma mark - MWPhotoBrowserDelegate

-(void)onClickImageView
{
    [_photos removeAllObjects];
    [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:_userInfo.profile_image]]];
    
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
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
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
    __weak typeof (self) thisPoint = self;
    
    if (_processWin != nil) {
        [AlertManager dissmiss:_processWin];
        _processWin = nil;
    }
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    _processWin = [AlertManager showCommonProgressInView:viewBody];
    
    [[SportForumAPI sharedInstance] userGetInfoByUserId:_strUserId NickName:@""
                                          FinishedBlock:^void(int errorCode, NSString *strDescErr, UserInfo* userInfo)
     {
         typeof(self) thisStrongPoint = thisPoint;
         
         if (thisStrongPoint == nil) {
             return;
         }
         
         _viewPhotoBoard.hidden = NO;
         _viewUserInfo.hidden = NO;
         _viewAdvanceEx.hidden = NO;
         
         [AlertManager dissmiss:_processWin];
         
         if(errorCode == 0)
         {
             if(userInfo.userid.length > 0)
             {
                 _userInfo = userInfo;
                 
                 UILabel * lbTitle = (UILabel *)[thisStrongPoint.view viewWithTag:GENERATE_VIEW_TITLE];
                 lbTitle.text = userInfo.nikename;
                 
                 [self updatePhotoBoard:userInfo];
                 [self updateUserInfoView:userInfo];
                 
                 if ([userInfo.actor isEqualToString:@"coach"]) {
                     if (_viewCoach == nil) {
                         [self generateCoachView];
                     }
                     
                     [self updateCoachView:userInfo];
                 }
                 
                 if (!(userInfo.user_equipInfo.run_shoe.data.count == 0 && userInfo.user_equipInfo.ele_product.data.count == 0
                       && userInfo.user_equipInfo.step_tool.data.count == 0)) {
                     if (_viewUserEquip == nil) {
                         [self generateUserEquipmentView];
                     }
                     
                     [self updateEquipmentView:userInfo];
                 }
                 
                 if (!(userInfo.sign.length == 0 && userInfo.emotion.length == 0 && userInfo.profession.length == 0 && userInfo.fond.length == 0 && userInfo.hometown.length == 0)) {
                     if (_viewAdvance == nil) {
                         [self generateUserAdvanceView];
                     }
                     
                     [self updateAdvanceView:userInfo];
                 }
                 
                 [self updateUserAdvanceExView:userInfo];
                 
                 if(![[[ApplicationContext sharedInstance]accountInfo].userid isEqualToString:_strUserId])
                 {
                     [self updateRelateState:userInfo];
                 }
                 
                 _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, CGRectGetMaxY(_viewAdvanceEx.frame) + 46);
                 
                 [[SportForumAPI sharedInstance] recordStatisticsByUserId:userInfo.userid
                                                            FinishedBlock:^void(int errorCode, RecordStatisticsInfo *recordStatisticsInfo)
                  {
                      if (thisStrongPoint == nil) {
                          return;
                      }
                      
                      UILabel *lbTotalDistance = (UILabel*)[_viewUserInfo viewWithTag:2003];
                      lbTotalDistance.text = [NSString stringWithFormat:@"%0.2f", recordStatisticsInfo.total_distance / 1000.00];
                      
                      UILabel *lbMaxforDay = (UILabel*)[_viewUserInfo viewWithTag:2004];
                      lbMaxforDay.text = [NSString stringWithFormat:@"%0.2f", recordStatisticsInfo.max_distance_record.distance / 1000.00];
                      
                      UILabel *lbFastestSpeed = (UILabel*)[_viewUserInfo viewWithTag:2005];
                      
                      CGFloat nMaxSpeed = 0.0;
                      if(recordStatisticsInfo.max_speed_record.duration != 0)
                      {
                          nMaxSpeed = (recordStatisticsInfo.max_speed_record.distance * 3600) / (recordStatisticsInfo.max_speed_record.duration * 1000.00);
                          lbFastestSpeed.text = [NSString stringWithFormat:@"%0.2f", nMaxSpeed];
                      }
                      else
                      {
                          lbFastestSpeed.text = @"0.00";
                      }
                  }];
             }
         }
         else
         {
             [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
         }
     }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint offset = scrollView.contentOffset;

    if([[[ApplicationContext sharedInstance]accountInfo].userid isEqualToString:_strUserId] && _userInfo != nil && _userInfo.user_images.data.count > 0 && offset.y < - 70)
    {
        UserUpdateInfo *userUpdateInfo = [[UserUpdateInfo alloc]init];
        _nCurBoardCover = arc4random() % 8;
        userUpdateInfo.cover_image = [NSString stringWithFormat:@"cover-%d.jpg", _nCurBoardCover];
    
        _bUpdateCover = YES;
        id process = [AlertManager showCommonProgressWithText:@"更新照片墙..."];

        [[SportForumAPI sharedInstance] userSetInfoByUpdateInfo:userUpdateInfo FinishedBlock:^void(int errorCode, NSString* strDescErr, ExpEffect* expEffect)
         {
             [AlertManager dissmiss:process];
             UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
             
             [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
              {
              }];
         }];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if([[[ApplicationContext sharedInstance]accountInfo].userid isEqualToString:_strUserId] && _bUpdateCover && _userInfo != nil && _userInfo.user_images.data.count > 0)
    {
        _bUpdateCover = NO;
        [_scrollView.twitterCoverView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cover-%d.jpg", _nCurBoardCover]]];
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
