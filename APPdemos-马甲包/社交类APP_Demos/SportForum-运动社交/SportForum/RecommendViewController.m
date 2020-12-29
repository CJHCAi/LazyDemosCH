//
//  RecommendViewController.m
//  SportForum
//
//  Created by liyuan on 12/16/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "RecommendViewController.h"
#import "UIViewController+SportFormu.h"
#import "DRPaginatedScrollView.h"
#import "UIImageView+WebCache.h"
#import "AlertManager.h"

enum
{
    SWIP_LEFT,
    SWIP_CENTER,
    SWIP_RIGHT,
};

@interface RecommendViewController ()<UIScrollViewDelegate>

@end

@implementation RecommendViewController
{
    UIView *_viewLeft;
    UIView *_viewCenter;
    UIView *_viewRight;
    CSButton * _btnFinish;
    UIScrollView *m_scrollView;
    NSMutableDictionary *_dictBtnCheck;
    NSMutableArray *_arrPageViews;
    DRPaginatedScrollView * _paginatedScrollView;
    LeaderBoardItemList *_recommendsList;
}

-(UIView*)generateSwipView:(int)nSwip
{
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewBody.frame) - 200) / 2, CGRectGetMaxY(_paginatedScrollView.frame), 200, 25)];
    
    UILabel *lbDesc = [[UILabel alloc]initWithFrame:CGRectZero];
    lbDesc.backgroundColor = [UIColor clearColor];
    lbDesc.textColor = [UIColor lightGrayColor];
    lbDesc.font = [UIFont systemFontOfSize:14];
    lbDesc.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lbDesc];
    
    UIImageView *imageViewLeft = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imageViewLeft setImage:[UIImage imageNamed:@"intro-arrow-back"]];
    
    UIImageView *imageViewRight = [[UIImageView alloc]initWithFrame:CGRectZero];
    [imageViewRight setImage:[UIImage imageNamed:@"intro-arrow"]];
    
    switch (nSwip) {
        case SWIP_LEFT:
        {
            lbDesc.text = @"左滑换组新的";
            [view addSubview:imageViewRight];
        }
        
            break;
        case SWIP_CENTER:
        {
            lbDesc.text = @"滑动换组新的";
        }
            break;
        case SWIP_RIGHT:
        {
            lbDesc.text = @"右滑换组新的";
            [view addSubview:imageViewLeft];
        }
            break;
        default:
            break;
    }
    
    CGSize constraint = CGSizeMake(160, 20000.0f);
    //CGSize needSize = [lbDesc.text sizeWithFont:lbDesc.font
    //                   constrainedToSize:constraint
    //                       lineBreakMode:NSLineBreakByWordWrapping];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize needSize = [lbDesc.text boundingRectWithSize:constraint
                                                       options:options
                                                    attributes:@{NSFontAttributeName:lbDesc.font} context:nil].size;
    
    lbDesc.frame = CGRectMake((CGRectGetWidth(view.frame) - needSize.width) / 2, 5, needSize.width, 20);
    imageViewLeft.frame = CGRectMake(CGRectGetMinX(lbDesc.frame) - 15, 8, 11, 14);
    imageViewRight.frame = CGRectMake(CGRectGetMaxX(lbDesc.frame) + 5, 8, 11, 14);

    return view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dictBtnCheck = [[NSMutableDictionary alloc]init];
    _arrPageViews = [[NSMutableArray alloc]init];
    [self generateCommonViewInParent:self.view Title:@"推荐关注" IsNeedBackBtn:NO];
    
    UIView *viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    viewBody.backgroundColor = APP_BORDER_BG_COLOR;
    CGRect rect = viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    m_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewBody.frame), CGRectGetHeight(viewBody.frame))];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.scrollEnabled = YES;
    [viewBody addSubview:m_scrollView];
    
    //Create Scroll
    _paginatedScrollView = [[DRPaginatedScrollView alloc]init];
    _paginatedScrollView.backgroundColor = [UIColor clearColor];
    _paginatedScrollView.frame = CGRectMake(10, 10, CGRectGetWidth(viewBody.frame) - 20, 412);
    _paginatedScrollView.delegate = self;
    [m_scrollView addSubview:_paginatedScrollView];
    
    //Create Swip Tips
    _viewLeft = [self generateSwipView:SWIP_LEFT];
    [m_scrollView addSubview:_viewLeft];
    
    _viewCenter = [self generateSwipView:SWIP_CENTER];
    [m_scrollView addSubview:_viewCenter];
    
    _viewRight = [self generateSwipView:SWIP_RIGHT];
    [m_scrollView addSubview:_viewRight];
    
    _viewLeft.hidden = NO;
    _viewCenter.hidden = YES;
    _viewRight.hidden = YES;
    
    UIImage * imgButton = [UIImage imageNamed:@"btn-2-blue"];
    _btnFinish = [[CSButton alloc] initNormalButtonTitle:@"完成" Rect:CGRectMake((CGRectGetWidth(viewBody.frame) - 266) / 2, CGRectGetMaxY(_viewRight.frame) + 5, 266, 38)];
    [_btnFinish setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnFinish setBackgroundImage:imgButton forState:UIControlStateNormal];
    [_btnFinish setBackgroundImage:[UIImage imageNamed:@"btn-2-grey"] forState:UIControlStateDisabled];
    [_btnFinish setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
    _btnFinish.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _btnFinish.enabled = NO;
    [m_scrollView addSubview:_btnFinish];
    
    CGSize contentSize = CGSizeMake(CGRectGetWidth(viewBody.frame), CGRectGetMaxY(_btnFinish.frame) + 30);
    [m_scrollView setContentSize:contentSize];
    
    __weak typeof (self) thisPoint = self;
    
    _btnFinish.actionBlock = ^void()
    {
        typeof(self) thisStrongPoint = thisPoint;
        
        if ([thisStrongPoint->_recommendsList.members_list.data count] > 0) {
            NSMutableArray *arrUseIds = [[NSMutableArray alloc]init];
            UIView *curView = thisStrongPoint->_arrPageViews[thisStrongPoint->_paginatedScrollView.currentPage];
            NSUInteger nCurrentItem = [curView.subviews count];
            
            for (NSUInteger i = 0; i < nCurrentItem; i++) {
                LeaderBoardItem *leaderBoardItem = thisStrongPoint->_recommendsList.members_list.data[thisStrongPoint->_paginatedScrollView.currentPage * 6 + i];
                CSButton *btnCheckOn = (CSButton*)[thisStrongPoint->_dictBtnCheck objectForKey:leaderBoardItem.userid];
                
                if (btnCheckOn != nil && !btnCheckOn.hidden) {
                    [arrUseIds addObject:leaderBoardItem.userid];
                }
            }
            
            if ([arrUseIds count] > 0) {
                [[SportForumAPI sharedInstance] userEnableAttentionByUserId:arrUseIds
                                                                  Attention:YES
                                                              FinishedBlock:^void(int errorCode, NSString* strDescErr, ExpEffect* expEffect)
                 {
                     
                 }];
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_SWITCH_VIEW object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:VIEW_MAIN_PAGE, @"PageName", nil]];
        
        NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"Profile"];
        NSString* strAuthId = [dict objectForKey:@"AuthUserId"];
        
        [[ApplicationContext sharedInstance]getProfileInfo:strAuthId FinishedBlock:^void(int errorCode)
         {
             if (errorCode == 0) {
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_GET_MAIN_INFO object:nil];
             }
         }];
    };
    
    [self loadRecommendData];
}

-(void)loadRecommendData
{
    id process = [AlertManager showCommonProgress];
    
    [[SportForumAPI sharedInstance]userGetRecommendsByPageId:@"" LastPageId:@"" FinishedBlock:^void(int errorCode, LeaderBoardItemList *recommendsList){
        [AlertManager dissmiss:process];
        _btnFinish.enabled = YES;
        _recommendsList = recommendsList;
        
        if (errorCode == 0 && [recommendsList.members_list.data count] > 0) {
            [self generatePageView:recommendsList];
        }
    }];
}

-(void)generatePageView:(LeaderBoardItemList*)recommendsList
{
    NSUInteger nPages = [recommendsList.members_list.data count] / 6;
    
    for (NSUInteger i = 0; i < nPages; i++) {
        UIView *viewPage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_paginatedScrollView.frame), CGRectGetHeight(_paginatedScrollView.frame))];
        viewPage.backgroundColor = [UIColor clearColor];
        
        CGFloat fBtnY = 0;
        
        for (int j = 0; j < 6; j++) {
            LeaderBoardItem *leaderBoardItem = recommendsList.members_list.data[i * 6 + j];
            UIView *viewItem = [self generateItemViewFromData:leaderBoardItem];
            
            CGFloat fBtnHeight = CGRectGetHeight(viewItem.frame);
            
            if (j % 3 == 0 && j > 0) {
                fBtnY += (10 + fBtnHeight);
            }
            
            CGRect rect = viewItem.frame;
            rect.origin = CGPointMake((10 + CGRectGetWidth(viewItem.frame)) * (j % 3), fBtnY);
            viewItem.frame = rect;
            [viewPage addSubview:viewItem];
        }

        [_arrPageViews addObject:viewPage];
        [_paginatedScrollView addPageWithHandler:^(UIView *pageView) {
            [pageView addSubview:viewPage];
        }];
    }
    
    NSUInteger nLeftItem = [recommendsList.members_list.data count] % 6;
    
    if (nLeftItem > 0) {
        UIView *viewPage = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_paginatedScrollView.frame), CGRectGetHeight(_paginatedScrollView.frame))];
        viewPage.backgroundColor = [UIColor clearColor];
        
        CGFloat fBtnY = 0;

        for(NSUInteger i = 0; i < nLeftItem; i++)
        {
            LeaderBoardItem *leaderBoardItem = recommendsList.members_list.data[nPages * 6 + i];
            UIView *viewItem = [self generateItemViewFromData:leaderBoardItem];
            
            CGFloat fBtnHeight = CGRectGetHeight(viewItem.frame);
            
            if (i % 3 == 0 && i > 0) {
                fBtnY += (10 + fBtnHeight);
            }
            
            CGRect rect = viewItem.frame;
            rect.origin = CGPointMake((10 + CGRectGetWidth(viewItem.frame)) * (i % 3), fBtnY);
            viewItem.frame = rect;
            [viewPage addSubview:viewItem];
        }
        
        [_arrPageViews addObject:viewPage];
        [_paginatedScrollView addPageWithHandler:^(UIView *pageView) {
            [pageView addSubview:viewPage];
        }];
    }
}

-(UIView*)generateItemViewFromData:(LeaderBoardItem*)itemData
{
    UIView *viewItem = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 200)];
    viewItem.backgroundColor = [UIColor colorWithRed:246.0 / 255.0 green:246.0 / 255.0 blue:246.0 / 255.0 alpha:1.0];
    viewItem.layer.cornerRadius = 5.0;
    
    UIImageView *userImageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewItem.frame) - 65) / 2, 10, 65, 65)];
    
    [userImageView sd_setImageWithURL:[NSURL URLWithString:itemData.user_profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    userImageView.layer.cornerRadius = 5.0;
    userImageView.layer.masksToBounds = YES;
    [viewItem addSubview:userImageView];
    
    UILabel *lbNickName = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(userImageView.frame) + 5, CGRectGetWidth(viewItem.frame), 20)];
    lbNickName.backgroundColor = [UIColor clearColor];
    lbNickName.text = itemData.nikename.length > 0 ? itemData.nikename : @"匿名";
    lbNickName.textColor = [UIColor blackColor];
    lbNickName.font = [UIFont boldSystemFontOfSize:12];
    lbNickName.textAlignment = NSTextAlignmentCenter;
    [viewItem addSubview:lbNickName];

    UIImageView *sexTypeImageView = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewItem.frame) - 40) / 2, CGRectGetMaxY(lbNickName.frame), 40, 18)];
    [sexTypeImageView setImage:[UIImage imageNamed:[itemData.sex_type isEqualToString:sex_male] ? @"gender-male" : @"gender-female"]];
    sexTypeImageView.backgroundColor = [UIColor clearColor];
    [viewItem addSubview:sexTypeImageView];
    
    UILabel *lbAge = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, CGRectGetMinY(sexTypeImageView.frame) + 3, 20, 10)];
    lbAge.backgroundColor = [UIColor clearColor];
    lbAge.text = [[CommonUtility sharedInstance]convertBirthdayToAge:itemData.birthday];
    lbAge.textColor = [UIColor whiteColor];
    lbAge.font = [UIFont boldSystemFontOfSize:10];
    lbAge.textAlignment = NSTextAlignmentRight;
    [viewItem addSubview:lbAge];
    
    UIImageView *imgVieCoach = [[UIImageView alloc]init];
    [imgVieCoach setImage:[UIImage imageNamed:@"other-info-coach-icon"]];
    imgVieCoach.backgroundColor = [UIColor clearColor];
    imgVieCoach.hidden = ([itemData.actor isEqualToString:@"coach"]) ? NO : YES;
    imgVieCoach.frame = CGRectMake(90 - 25, CGRectGetMaxY(lbNickName.frame), 20, 20);
    [viewItem addSubview:imgVieCoach];
    
    UIImageView *imgViePhone = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) + 2, CGRectGetMaxY(lbNickName.frame) + 2, 8, 14)];
    [imgViePhone setImage:[UIImage imageNamed:@"phone-verified-small"]];
    imgViePhone.backgroundColor = [UIColor clearColor];
    imgViePhone.hidden = itemData.phone_number.length > 0 ? NO : YES;
    [viewItem addSubview:imgViePhone];
    
    if (imgVieCoach.hidden) {
        imgViePhone.frame = CGRectMake((CGRectGetWidth(viewItem.frame) - 40) / 2 + 43, CGRectGetMaxY(lbNickName.frame) + 2, 8, 14);
    }
    else
    {
        imgViePhone.frame = CGRectMake(90 - 25 - 10, CGRectGetMaxY(lbNickName.frame) + 2, 8, 14);
    }
    
    if(!imgViePhone.hidden && !imgVieCoach.hidden)
    {
        sexTypeImageView.frame = CGRectMake(90 - 25 - 13 - 42, CGRectGetMaxY(lbNickName.frame), 40, 18);
    }
    else
    {
        sexTypeImageView.frame = CGRectMake((CGRectGetWidth(viewItem.frame) - 40) / 2, CGRectGetMaxY(lbNickName.frame), 40, 18);
    }
    
    lbAge.frame = CGRectMake(CGRectGetMaxX(sexTypeImageView.frame) - 25, CGRectGetMinY(sexTypeImageView.frame) + 3, 20, 10);
    
    UIImage * imgLev = [UIImage imageNamed:@"level-bg"];
    imgLev = [imgLev stretchableImageWithLeftCapWidth:floorf(imgLev.size.width/2) topCapHeight:floorf(imgLev.size.height/2)];
    UIImageView* imgLevelBK = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(viewItem.frame) - 70) / 2, CGRectGetMaxY(sexTypeImageView.frame) + 5, 70, 20)];
    imgLevelBK.image = imgLev;
    [viewItem addSubview:imgLevelBK];
    
    UILabel *lbLevel = [[UILabel alloc]initWithFrame:CGRectMake((CGRectGetWidth(viewItem.frame) - imgLev.size.width) / 2, CGRectGetMaxY(sexTypeImageView.frame) + 5, imgLev.size.width, imgLev.size.height)];
    //lbLevel.backgroundColor = [UIColor colorWithPatternImage:imgLev];
    //lbLevel.layer.contents = (id) imgLev.CGImage;
    lbLevel.backgroundColor = [UIColor clearColor];
    lbLevel.text = [NSString stringWithFormat:@"LV.%ld", itemData.rankLevel];
    lbLevel.textColor = [UIColor whiteColor];
    lbLevel.font = [UIFont italicSystemFontOfSize:12];
    lbLevel.textAlignment = NSTextAlignmentCenter;
    [viewItem addSubview:lbLevel];

    UIImageView * imgLoc = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbLevel.frame) - 10, CGRectGetMaxY(lbLevel.frame) + 5, 17, 17)];
    imgLoc.image = [UIImage imageNamed:@"location-icon"];
    [viewItem addSubview:imgLoc];
    
    UILabel * lbLoc = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgLoc.frame), CGRectGetMaxY(lbLevel.frame) + 5, CGRectGetWidth(viewItem.frame) - CGRectGetMaxX(imgLoc.frame), 20)];
    lbLoc.backgroundColor = [UIColor clearColor];
    lbLoc.textColor = [UIColor blackColor];
    lbLoc.text = itemData.locaddr.length > 0 ? itemData.locaddr : @"位置不明";
    lbLoc.font = [UIFont boldSystemFontOfSize:12];
    [viewItem addSubview:lbLoc];
    
    CSButton *btnCheckOn = [CSButton buttonWithType:UIButtonTypeCustom];
    btnCheckOn.frame = CGRectMake((CGRectGetWidth(viewItem.frame) - 23) / 2, CGRectGetMaxY(lbLoc.frame) + 5, 23, 23);
    [btnCheckOn setImage:[UIImage imageNamed:@"check-on"] forState:UIControlStateNormal];
    [btnCheckOn setImage:[UIImage imageNamed:@"check-on"] forState:UIControlStateHighlighted];
    btnCheckOn.hidden = NO;
    [_dictBtnCheck setObject:btnCheckOn forKey:itemData.userid];
    [viewItem addSubview:btnCheckOn];
    
    CSButton *btnCheckOff = [CSButton buttonWithType:UIButtonTypeCustom];
    btnCheckOff.frame = CGRectMake((CGRectGetWidth(viewItem.frame) - 23) / 2, CGRectGetMaxY(lbLoc.frame) + 5, 23, 23);
    [btnCheckOff setImage:[UIImage imageNamed:@"check-off"] forState:UIControlStateNormal];
    [btnCheckOff setImage:[UIImage imageNamed:@"check-off"] forState:UIControlStateHighlighted];
    btnCheckOff.hidden = YES;
    [viewItem addSubview:btnCheckOff];
    
    __typeof__(CSButton) __weak *thisbtn1 = btnCheckOn;
    __typeof__(CSButton) __weak *thisbtn2 = btnCheckOff;
    
    btnCheckOn.actionBlock = ^void()
    {
        thisbtn2.hidden = NO;
        thisbtn1.hidden = YES;
    };
    
    btnCheckOff.actionBlock = ^void()
    {
        thisbtn2.hidden = YES;
        thisbtn1.hidden = NO;
    };
    
    return viewItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"RecommendViewController dealloc called!");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_paginatedScrollView.numberOfPages == 1) {
        _viewLeft.hidden = YES;
        _viewCenter.hidden = YES;
        _viewRight.hidden = YES;
    }
    else if(_paginatedScrollView.currentPage == 0)
    {
        _viewLeft.hidden = NO;
        _viewCenter.hidden = YES;
        _viewRight.hidden = YES;
    }
    else if(_paginatedScrollView.currentPage == _paginatedScrollView.numberOfPages - 1)
    {
        _viewLeft.hidden = YES;
        _viewCenter.hidden = YES;
        _viewRight.hidden = NO;
    }
    else
    {
        _viewLeft.hidden = YES;
        _viewCenter.hidden = NO;
        _viewRight.hidden = YES;
    }
    
    UIView *curView = _arrPageViews[_paginatedScrollView.currentPage];
    NSUInteger nCurrentItem = [curView.subviews count];
    for (NSUInteger i = 0; i < nCurrentItem; i++) {
        LeaderBoardItem *leaderBoardItem = _recommendsList.members_list.data[_paginatedScrollView.currentPage * 6 + i];
        CSButton *btnCheckOn = (CSButton*)[_dictBtnCheck objectForKey:leaderBoardItem.userid];
        
        if (btnCheckOn != nil && btnCheckOn.hidden) {
            btnCheckOn.actionBlock();
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
