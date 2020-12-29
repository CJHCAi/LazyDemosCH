//
//  PKViewController.m
//  SportForum
//
//  Created by liyuan on 14-9-24.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "PKViewController.h"
#import "UIViewController+SportFormu.h"
#import "ImageEditViewController.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
//#import "AGViewDelegate.h"
#import "IQKeyboardManager.h"
#import "ArticlePublicViewController.h"
#import "RecordSportViewController.h"
#import "GameViewController.h"
#import "CommonUtility.h"
#import "AlertManager.h"
#import "ZipArchive.h"
#import "MyDownLoadTask.h"

@interface PKViewController ()

@end

@implementation PKViewController
{
    UIView *_viewBody;
    UIView *_viewBackground;
    UIImageView *_imgViewUser;
    UIImageView *_imgViewPKUser;
    UIImageView *_myAnimatedView;
    UIImageView *_pkResultView;
    UIImageView *_pkLoseView;
    UIImageView *_pkWinView;
    UILabel *_lbWinerNick;
    UILabel *_lbLoseNick;
    NSTimer *_myAnimatedTimer;
    NSTimer *m_timerReward;
    UIView *_viewUp;
    NSString *_strScreenImgPath;
    
    UIView *_viewDetail;
    UIImageView *_imgViewUserDetail;
    UIImageView *_imgViewPKUserDetail;
    UILabel *_lbMyScore[4];
    UILabel *_lbTargetScore[4];
    UILabel *_lbOffsetScore[4];
    CSButton *_btnEarnPoint[3];
    CSButton *_btnShare;
    UIImageView *_imgViewShare;
    
    BOOL _bShareWeibo;
    BOOL _bShareCircle;
    int _nNextImage;
    id _processWin;
    
    NSMutableArray *_arrAnimationImgs;
    
    NSString *_strEffectUrl;
    MyDownLoadTask *_myDownLoadTask;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoadGui
{
    UserInfo * userInfo = [[ApplicationContext sharedInstance] accountInfo];
    [self generateCommonViewInParent:self.view Title:[NSString stringWithFormat:@"我 PK %@", _leaderBoardItem.nikename] IsNeedBackBtn:YES];
    
    /*CSButton *btnBack = [CSButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(7, 27, 37, 37);
    [btnBack setImage:[UIImage imageNamed:@"back-btn"] forState:UIControlStateNormal];
    [self.view addSubview:btnBack];*/
    
    __weak __typeof(self) weakSelf = self;
    
    /*btnBack.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PK_TIMES object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:strongSelf.leaderBoardItem.userid, @"PKUserId", strongSelf.leaderBoardItem.nikename, @"PKNikeName", nil]];
        [strongSelf.navigationController popViewControllerAnimated:YES];
    };*/

    _viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    _viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = _viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    _viewBody.frame = rect;
    
    rect.origin.y = self.view.frame.origin.y + self.view.frame.size.height;
    _viewDetail = [[UIView alloc] initWithFrame:rect];
    _viewDetail.backgroundColor = APP_MAIN_BG_COLOR;
    [self.view addSubview:_viewDetail];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    _viewBody.layer.mask = maskLayer;
    
    _viewBackground = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_viewBody.frame), CGRectGetHeight(_viewBody.frame))];
    _viewBackground.backgroundColor = [UIColor colorWithRed:31.0 / 255.0 green:64.0 / 255.0 blue:141.0 / 255.0 alpha:1.0];
    _viewBackground.alpha = 0;
    [_viewBody addSubview:_viewBackground];
    
    _imgViewUser = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(_viewBody.frame), 93, 93)];
    _imgViewUser.layer.cornerRadius = 10.0;
    _imgViewUser.layer.masksToBounds = YES;
    [_viewBody addSubview:_imgViewUser];
    
    _imgViewPKUser = [[UIImageView alloc]initWithFrame:CGRectMake(197, CGRectGetHeight(_viewBody.frame), 93, 93)];
    _imgViewPKUser.layer.cornerRadius = 10.0;
    _imgViewPKUser.layer.masksToBounds = YES;
    [_viewBody addSubview:_imgViewPKUser];
    
    _pkLoseView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 93, 93)];
    [_pkLoseView setImage:[UIImage imageNamed:@"glass-broken"]];
    _pkLoseView.layer.cornerRadius = 10.0;
    _pkLoseView.layer.masksToBounds = YES;
    _pkLoseView.hidden = YES;
    
    _myAnimatedView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_viewBody.frame) / 2 - 134, CGRectGetHeight(_viewBody.frame) / 2 - CGRectGetMinY(_viewBody.frame) / 2 - 134, 268, 268)];
    [_viewBody addSubview:_myAnimatedView];
    
    UIImage *imagePk = [UIImage imageNamed:@"PK-result-bg"];
    
    if ([CommonFunction ConvertStringToSexType:userInfo.sex_type] == e_sex_male && [_leaderBoardItem.sex_type isEqualToString:sex_male]) {
        imagePk = [UIImage imageNamed:@"PK-result-bg-4"];
    }
    else if([CommonFunction ConvertStringToSexType:userInfo.sex_type] == e_sex_female && [_leaderBoardItem.sex_type isEqualToString:sex_female])
    {
        imagePk = [UIImage imageNamed:@"PK-result-bg"];
    }
    else if([CommonFunction ConvertStringToSexType:userInfo.sex_type] == e_sex_male && [_leaderBoardItem.sex_type isEqualToString:sex_female])
    {
        imagePk = (userInfo.proper_info.rankscore > _leaderBoardItem.score ? [UIImage imageNamed:@"PK-result-bg-3"] : [UIImage imageNamed:@"PK-result-bg-2"]);
    }
    else if([CommonFunction ConvertStringToSexType:userInfo.sex_type] == e_sex_female && [_leaderBoardItem.sex_type isEqualToString:sex_male])
    {
       imagePk = (userInfo.proper_info.rankscore > _leaderBoardItem.score ? [UIImage imageNamed:@"PK-result-bg-2"] : [UIImage imageNamed:@"PK-result-bg-3"]);
    }
    
    _pkResultView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_viewBody.frame) / 2 - 142, 10, 284, 279)];
    [_pkResultView setImage:imagePk];
    _pkResultView.alpha = 0;
    [_viewBody addSubview:_pkResultView];
    
    _pkWinView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_viewBody.frame) / 2 - 33, CGRectGetHeight(_viewBody.frame) - 130, 66, 41)];
    [_pkWinView setImage:[UIImage imageNamed:@"PK-win"]];
    _pkWinView.alpha = 0;
    [_viewBody addSubview:_pkWinView];
    
    _lbWinerNick = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetHeight(_viewBody.frame) - 105, 93, 20)];
    _lbWinerNick.backgroundColor = [UIColor clearColor];
    _lbWinerNick.textColor = [UIColor blackColor];
    _lbWinerNick.textAlignment = NSTextAlignmentCenter;
    _lbWinerNick.font = [UIFont boldSystemFontOfSize:14];
    _lbWinerNick.alpha = 0;
    [_viewBody addSubview:_lbWinerNick];
    
    _lbLoseNick = [[UILabel alloc]initWithFrame:CGRectMake(200, CGRectGetHeight(_viewBody.frame) - 105, 93, 20)];
    _lbLoseNick.backgroundColor = [UIColor clearColor];
    _lbLoseNick.textColor = [UIColor blackColor];
    _lbLoseNick.textAlignment = NSTextAlignmentCenter;
    _lbLoseNick.font = [UIFont boldSystemFontOfSize:14];
    _lbLoseNick.alpha = 0;
    [_viewBody addSubview:_lbLoseNick];
    
    [_imgViewUser sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image]
                    placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    [_imgViewPKUser sd_setImageWithURL:[NSURL URLWithString:_leaderBoardItem.user_profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    _lbWinerNick.text = userInfo.nikename;
    _lbLoseNick.text = _leaderBoardItem.nikename;
    
    if (userInfo.proper_info.rankscore > _leaderBoardItem.score) {
        [_pkWinView setImage:[UIImage imageNamed:@"PK-win"]];
        [_imgViewPKUser addSubview:_pkLoseView];
        [_imgViewPKUser bringSubviewToFront:_pkLoseView];
    }
    else
    {
        [_pkWinView setImage:[UIImage imageNamed:@"PK-lose"]];
        [_imgViewUser addSubview:_pkLoseView];
        [_imgViewUser bringSubviewToFront:_pkLoseView];
    }
    /*
    if (userInfo.proper_info.rankscore > _leaderBoardItem.score) {
        [_imgViewUser sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image]
                          placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        [_imgViewPKUser sd_setImageWithURL:[NSURL URLWithString:_leaderBoardItem.user_profile_image]
                        placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        _lbWinerNick.text = userInfo.nikename;
        _lbLoseNick.text = _leaderBoardItem.nikename;
    }
    else
    {
        [_imgViewUser sd_setImageWithURL:[NSURL URLWithString:_leaderBoardItem.user_profile_image]
                        placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        [_imgViewPKUser sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image]
                          placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        _lbWinerNick.text = _leaderBoardItem.nikename;
        _lbLoseNick.text = userInfo.nikename;
    }*/
    
    //Create Share View
    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    _imgViewShare = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [_imgViewShare setImage:[UIImage imageNamed:@"nav-share-btn-disable"]];
    [self.view addSubview:_imgViewShare];
    
    _btnShare = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnShare.frame = CGRectMake(CGRectGetMinX(_imgViewShare.frame) - 5, CGRectGetMinY(_imgViewShare.frame) - 5, 45, 45);
    _btnShare.backgroundColor = [UIColor clearColor];
    _btnShare.enabled = NO;
    [self.view addSubview:_btnShare];
    [self.view bringSubviewToFront:_btnShare];
    
    _btnShare.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf customShareMenuItemsHandler];
    };

    _viewUp = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(_viewBody.frame) / 2 - 60, CGRectGetMaxY(_lbWinerNick.frame) + 10, 120, 20)];
    _viewUp.backgroundColor = [UIColor clearColor];
    _viewUp.alpha = 0;
    [_viewBody addSubview:_viewUp];
    
    UIImageView *imageViewUp = [[UIImageView alloc]initWithFrame:CGRectMake(0, 4, 22, 12)];
    [imageViewUp setImage:[UIImage imageNamed:@"arrow-2"]];
    [_viewUp addSubview:imageViewUp];
    
    UILabel *lbTips = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 100, 20)];
    lbTips.backgroundColor = [UIColor clearColor];
    lbTips.textColor = [UIColor lightGrayColor];
    lbTips.textAlignment = NSTextAlignmentCenter;
    lbTips.font = [UIFont systemFontOfSize:12];
    lbTips.text = @"上滑查看相关比分";
    [_viewUp addSubview:lbTips];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(20, 20, 20, 20);
    UIImage * imgLightBlueBk = [UIImage imageNamed:@"PK-Table-row-1"];
    imgLightBlueBk = [imgLightBlueBk resizableImageWithCapInsets:insets];
    UIImage * imgBlueBk = [UIImage imageNamed:@"PK-Table-row-2"];
    imgBlueBk = [imgBlueBk resizableImageWithCapInsets:insets];
    
    UIImageView * imgBlueBkView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 15, 300, 44)];
    imgBlueBkView.image = imgBlueBk;
    [_viewDetail addSubview:imgBlueBkView];
    
    UIImageView * imgLightBlueBkView[5];
    UIImageView * imgTableHeadView[5];
    for(int i = 0; i < 4; i++)
    {
        imgLightBlueBkView[i] = [[UIImageView alloc] initWithFrame:CGRectMake(5, 65 + i * 50, 300, 44)];
        imgLightBlueBkView[i].image = imgLightBlueBk;
        [_viewDetail addSubview:imgLightBlueBkView[i]];
        
        imgTableHeadView[i] = [[UIImageView alloc] initWithFrame:CGRectMake(7, 65 + i * 50 + 2, 40, 40)];
        [_viewDetail addSubview:imgTableHeadView[i]];
    }
    imgTableHeadView[0].image = [UIImage imageNamed:@"PK-table-run"];
    imgTableHeadView[1].image = [UIImage imageNamed:@"PK-table-blog"];
    imgTableHeadView[2].image = [UIImage imageNamed:@"PK-table-magic"];
    imgTableHeadView[3].image = [UIImage imageNamed:@"PK-table-score"];
    
    _imgViewUserDetail = [[UIImageView alloc]initWithFrame:CGRectMake(55, CGRectGetMinY(imgBlueBkView.frame) + 2, 40, 40)];
    _imgViewUserDetail.layer.cornerRadius = 10.0;
    _imgViewUserDetail.layer.masksToBounds = YES;
    [_imgViewUserDetail sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image]
                    placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    [_viewDetail addSubview:_imgViewUserDetail];
    
    _imgViewPKUserDetail = [[UIImageView alloc]initWithFrame:CGRectMake(125, CGRectGetMinY(imgBlueBkView.frame) + 2, 40, 40)];
    _imgViewPKUserDetail.layer.cornerRadius = 10.0;
    _imgViewPKUserDetail.layer.masksToBounds = YES;
    [_imgViewPKUserDetail sd_setImageWithURL:[NSURL URLWithString:_leaderBoardItem.user_profile_image]
                      placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
    [_viewDetail addSubview:_imgViewPKUserDetail];
    
    UILabel * lbDifference = [[UILabel alloc] initWithFrame:CGRectMake(200, CGRectGetMinY(imgBlueBkView.frame) + 12, 80, 20)];
    lbDifference.backgroundColor = [UIColor clearColor];
    lbDifference.textColor = [UIColor whiteColor];
    lbDifference.text = @"差值";
    lbDifference.font = [UIFont boldSystemFontOfSize:14];
    [_viewDetail addSubview:lbDifference];
    
    UILabel * lbTotalScore = [[UILabel alloc] initWithFrame:imgTableHeadView[3].frame];
    lbTotalScore.backgroundColor = [UIColor clearColor];
    lbTotalScore.textColor = [UIColor whiteColor];
    lbTotalScore.text = @"总分";
    lbTotalScore.font = [UIFont boldSystemFontOfSize:14];
    lbTotalScore.textAlignment = NSTextAlignmentCenter;
    [_viewDetail addSubview:lbTotalScore];
    
    for(int i = 0; i < 4; i++)
    {
        _lbMyScore[i] = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imgViewUserDetail.frame) + 10, CGRectGetMinY(imgTableHeadView[i].frame) + 12, CGRectGetWidth(_imgViewUserDetail.frame), 20)];
        _lbMyScore[i].backgroundColor = [UIColor clearColor];
        _lbMyScore[i].textColor = [UIColor whiteColor];
        _lbMyScore[i].font = [UIFont boldSystemFontOfSize:16];
        _lbMyScore[i].textAlignment = NSTextAlignmentLeft;
        [_viewDetail addSubview:_lbMyScore[i]];
        
        _lbTargetScore[i] = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_imgViewPKUserDetail.frame) + 10, CGRectGetMinY(imgTableHeadView[i].frame) + 12, CGRectGetWidth(_imgViewPKUserDetail.frame), 20)];
        _lbTargetScore[i].backgroundColor = [UIColor clearColor];
        _lbTargetScore[i].textColor = [UIColor whiteColor];
        _lbTargetScore[i].font = [UIFont boldSystemFontOfSize:16];
        _lbTargetScore[i].textAlignment = NSTextAlignmentLeft;
        [_viewDetail addSubview:_lbTargetScore[i]];
        
        _lbOffsetScore[i] = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbDifference.frame), CGRectGetMinY(imgTableHeadView[i].frame) + 12, CGRectGetWidth(lbDifference.frame), 20)];
        _lbOffsetScore[i].backgroundColor = [UIColor clearColor];
        _lbOffsetScore[i].textColor = [UIColor whiteColor];
        _lbOffsetScore[i].font = [UIFont boldSystemFontOfSize:18];
        _lbOffsetScore[i].textAlignment = NSTextAlignmentLeft;
        [_viewDetail addSubview:_lbOffsetScore[i]];
    }
    
    _btnEarnPoint[0] = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnEarnPoint[0].frame = CGRectMake(263, 67, 40, 41);
    [_btnEarnPoint[0] setBackgroundImage:[UIImage imageNamed:@"PK-table-run-btn"] forState:UIControlStateNormal];
    [_viewDetail addSubview:_btnEarnPoint[0]];
    _btnEarnPoint[1] = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnEarnPoint[1].frame = CGRectMake(263, 117, 40, 41);
    [_btnEarnPoint[1] setBackgroundImage:[UIImage imageNamed:@"PK-table-blog-btn"] forState:UIControlStateNormal];
    [_viewDetail addSubview:_btnEarnPoint[1]];
    _btnEarnPoint[2] = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnEarnPoint[2].frame = CGRectMake(263, 167, 40, 41);
    [_btnEarnPoint[2] setBackgroundImage:[UIImage imageNamed:@"PK-table-magic-btn"] forState:UIControlStateNormal];
    [_viewDetail addSubview:_btnEarnPoint[2]];
    
    CGRect rectDown = imageViewUp.frame;
    rectDown.origin.x = (_viewDetail.frame.size.width - rectDown.size.width) / 2;
    rectDown.origin.y = CGRectGetMinY(_viewUp.frame);
    UIImageView *imageViewDown = [[UIImageView alloc] initWithFrame:rectDown];
    [imageViewDown setImage:[UIImage imageNamed:@"arrow-3"]];
    [_viewDetail addSubview:imageViewDown];

    _btnEarnPoint[0].actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        RecordSportViewController* recordSportViewController = [[RecordSportViewController alloc] init];
        [strongSelf.navigationController pushViewController:recordSportViewController animated:YES];
    };
    
    _btnEarnPoint[1].actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        ArticlePublicViewController* articlePublicViewController = [[ArticlePublicViewController alloc]init];
        [strongSelf.navigationController pushViewController:articlePublicViewController animated:YES];
    };
    
    _btnEarnPoint[2].actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        GameViewController *gameViewController = [[GameViewController alloc]init];
        [strongSelf.navigationController pushViewController:gameViewController animated:YES];
    };
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanDragUp:)];
    [_viewBody addGestureRecognizer:panGes];
    
    UIPanGestureRecognizer *panGes2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanDragDown:)];
    [_viewDetail addGestureRecognizer:panGes2];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateProfileInfo) name:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];

    _arrAnimationImgs = [[NSMutableArray alloc]init];
    
    _strEffectUrl = [[ApplicationContext sharedInstance]pkEffectUrlString];
    
    if (_strEffectUrl.length > 0) {
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *filePath = [path stringByAppendingPathComponent:@"animation"];
        
        NSArray *files = [fileManager subpathsAtPath:filePath];
        
        if (files != nil && files.count > 0) {
            for (NSInteger i = 0; i < files.count; i++) {
                NSString *imgPath = [NSString stringWithFormat:@"%@/%ld.png", filePath, i + 1];
                UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
                
                if (image != nil) {
                    [_arrAnimationImgs addObject:image];
                }
            }
        }
        else
        {
            for(NSInteger i = 0; i < 17; i++)
            {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"PK-ball-%ld.png", i + 1]];
                [_arrAnimationImgs addObject:image];
            }
        }
    }
    else
    {
        for(NSInteger i = 0; i < 17; i++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"PK-ball-%ld.png", i + 1]];
            [_arrAnimationImgs addObject:image];
        }
    }
    
    [self viewDidLoadGui];
    
    _bShareWeibo = NO;
    _bShareCircle = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startAnimation) userInfo:nil repeats:NO];
}

-(void)loadServerAnimation
{
    if (_strEffectUrl.length > 0) {
        _myDownLoadTask = [[MyDownLoadTask alloc]initWithUrl:_strEffectUrl DownloadProcess:^void(CGFloat progress)
                           {
                               NSLog(@"Download Process is %.2f!", progress);
                           } CompleteProcess:^void(BOOL isCompleted, NSString* strByteTotal, NSString *error, NSData *responseData)
                           {
                               if (isCompleted) {
                                   NSLog(@"Download Successfully, totalByte is %@!", strByteTotal);
                                   
                                   NSError *error = nil;
                                   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                                   NSString *path = [paths objectAtIndex:0];
                                   NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
                                
                                   [responseData writeToFile:zipPath options:0 error:&error];
                                   
                                   if(!error)
                                   {
                                       ZipArchive *za = [[ZipArchive alloc] init];
                                       if ([za UnzipOpenFile: zipPath]) {
                                           BOOL ret = [za UnzipFileTo: path overWrite: YES];
                                           if (NO == ret){} [za UnzipCloseFile];
                                           
                                           NSArray *list=[_strEffectUrl componentsSeparatedByString:@"/"];
                                           NSString *strFileName = [list.lastObject componentsSeparatedByString:@"."].firstObject;
                                           NSString *fileDest = [path stringByAppendingPathComponent:strFileName];
                                           NSString *filePath= [path stringByAppendingPathComponent:@"animation"];
                                           NSFileManager *fileManager = [NSFileManager defaultManager];
                                           
                                           if ([fileManager fileExistsAtPath:filePath])
                                           {
                                               [fileManager removeItemAtPath:filePath error:nil];
                                           }
                                           
                                           [fileManager moveItemAtPath:fileDest toPath:filePath error:&error];
                                       }
                                   }
                                   else
                                   {
                                       NSLog(@"Error saving file %@",error);
                                   }
                               }
                               else
                               {
                                   NSLog(@"Download Error, error desc is %@!", error);
                               }
                           }];
        
        [_myDownLoadTask start];
    }
    
    /*
    dispatch_queue_t queue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSURL *url = [NSURL URLWithString:strUrl];
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
        
        if(!error)
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];
            NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
            
            [data writeToFile:zipPath options:0 error:&error];
            
            if(!error)
            {
                ZipArchive *za = [[ZipArchive alloc] init];
                if ([za UnzipOpenFile: zipPath]) {
                    BOOL ret = [za UnzipFileTo: path overWrite: YES];
                    if (NO == ret){} [za UnzipCloseFile];
                    
                    NSArray *list=[strUrl componentsSeparatedByString:@"/"];
                    NSString *strFileName = [list.lastObject componentsSeparatedByString:@"."].firstObject;
                    NSString *fileDest = [path stringByAppendingPathComponent:strFileName];
                    NSString *filePath= [path stringByAppendingPathComponent:@"animation"];
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    
                    if ([fileManager fileExistsAtPath:filePath])
                    {
                        [fileManager removeItemAtPath:filePath error:nil];
                    }
                    
                    [fileManager moveItemAtPath:fileDest toPath:filePath error:&error];
                }
            }
            else
            {
                NSLog(@"Error saving file %@",error);
            }
        }
        else
        {
            NSLog(@"Error downloading zip file: %@", error);
        }
    });*/
}

-(void)showCommonProgress{
    if (_processWin) {
        [self hidenCommonProgress];
    }
    
    _processWin = [AlertManager showCommonProgress];
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:_processWin];
    _processWin = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self handleUpdateProfileInfo];
    [MobClick beginLogPageView:@"PKViewController"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    //[IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [super viewWillDisappear:animated];
    [self hidenCommonProgress];
    [MobClick endLogPageView:@"PKViewController"];
    [_myDownLoadTask stop];
}

-(void)handleUpdateProfileInfo
{
    [[SportForumAPI sharedInstance] userGetPropertiesValue:_leaderBoardItem.userid FinishedBlock:^void(int errorCode, PropertiesInfo* propertiesInfo)
     {
         UserInfo * userInfo = [[ApplicationContext sharedInstance] accountInfo];
         _lbMyScore[0].text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.physique_value];
         _lbMyScore[1].text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.literature_value];
         _lbMyScore[2].text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.magic_value];
         _lbMyScore[3].text = [NSString stringWithFormat:@"%ld", userInfo.proper_info.rankscore];
         _lbTargetScore[0].text = [NSString stringWithFormat:@"%ld", propertiesInfo.physique_value];
         _lbTargetScore[1].text = [NSString stringWithFormat:@"%ld", propertiesInfo.literature_value];
         _lbTargetScore[2].text = [NSString stringWithFormat:@"%ld", propertiesInfo.magic_value];
         _lbTargetScore[3].text = [NSString stringWithFormat:@"%ld", propertiesInfo.rankscore];
         int nDiff[4] = {(int)(userInfo.proper_info.physique_value - propertiesInfo.physique_value), (int)(userInfo.proper_info.literature_value - propertiesInfo.literature_value), (int)(userInfo.proper_info.magic_value - propertiesInfo.magic_value), (int)(userInfo.proper_info.rankscore - propertiesInfo.rankscore)};
         for(int i = 0; i < 4; i++)
         {
             _lbOffsetScore[i].text = (nDiff[i] == 0 ? @"0" : [NSString stringWithFormat:@"%@%d", nDiff[i] >= 0 ? @"+" : @"", nDiff[i]]);
             _lbOffsetScore[i].textColor = nDiff[i] >= 0 ? [UIColor redColor] : [UIColor greenColor];
         }
         _btnEarnPoint[0].hidden = (nDiff[0] >= 0);
         _btnEarnPoint[1].hidden = (nDiff[1] >= 0);
         _btnEarnPoint[2].hidden = (nDiff[2] >= 0);
     }];
}

- (void)handlePanDragUp:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:_viewBody];
    if(point.y < 0 && _viewDetail.frame.origin.y != _viewBody.frame.origin.y)
    {
        CGRect rect = _viewDetail.frame;
        rect.origin.y = self.view.frame.origin.y + self.view.frame.size.height;
        _viewDetail.frame = rect;
        [UIView beginAnimations:@"animiMove" context:nil];
        [UIView setAnimationDuration:0.2];
        _viewDetail.frame = _viewBody.frame;
        _btnShare.enabled = NO;
        [_imgViewShare setImage:[UIImage imageNamed:@"nav-share-btn-disable"]];
        [UIView commitAnimations];
    }
}

- (void)handlePanDragDown:(UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan translationInView:_viewDetail];
    if(point.y > 0 && _viewDetail.frame.origin.y == _viewBody.frame.origin.y)
    {
        CGRect rect = _viewDetail.frame;
        rect.origin.y = self.view.frame.origin.y + self.view.frame.size.height;
        [UIView beginAnimations:@"animiMove" context:nil];
        [UIView setAnimationDuration:0.2];
        _viewDetail.frame = rect;
        _btnShare.enabled = YES;
        [_imgViewShare setImage:[UIImage imageNamed:@"nav-share-btn"]];
        [UIView commitAnimations];
    }
}

-(void)startAnimation
{
    [UIView animateWithDuration:1.0 animations:^{
        _viewBackground.alpha = 1.0f;
    }];
    
    [self moveImagePath:_imgViewUser];
    [self moveImagePath:_imgViewPKUser];
    
    /*[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startChangePngAnimated) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:4.25 target:self selector:@selector(stopChangeAnimated) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:4.75 target:self selector:@selector(showPKResult) userInfo:nil repeats:NO];*/
    
    [NSTimer scheduledTimerWithTimeInterval:4.5 target:self selector:@selector(startChangePngAnimated) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:7.25 target:self selector:@selector(stopChangeAnimated) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:7.75 target:self selector:@selector(showPKResult) userInfo:nil repeats:NO];
}

-(void)updateBoardPkTimes
{
    NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"BoardPkTimes"];
    NSMutableDictionary * boardDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if ([boardDict objectForKey:_leaderBoardItem.userid] != nil) {
        NSUInteger nTimes = [[boardDict objectForKey:_leaderBoardItem.userid]unsignedIntegerValue];
        
        if (nTimes > 0) {
            [boardDict setObject:@(nTimes - 1) forKey:_leaderBoardItem.userid];
            nTimes -= 1;
        }
        
        NSString *strTips = @"";
        
        if (nTimes > 0) {
            strTips = [NSString stringWithFormat:@"亲，您今天已与%@PK分享了%lu次，还剩%lu次分享机会哦~", _leaderBoardItem.nikename, (4 - nTimes), (unsigned long)nTimes];
        }
        else
        {
            strTips = [NSString stringWithFormat:@"亲，您今天已与%@PK分享了4次，明天才可以分享结果哦~", _leaderBoardItem.nikename];
            [AlertManager showAlertText:strTips InView:self.view hiddenAfter:2];
        }
    }
    
    [[ApplicationContext sharedInstance] saveObject:boardDict byKey:@"BoardPkTimes"];
}

- (void)customShareMenuItemsHandler
{
    UIImage *imgResult = [self renderScrollViewToImage];
    NSString *strShare = [NSString stringWithFormat:@"%@: %@与%@PK赢了!", @"悦动帮运动社区分享", _lbWinerNick.text, _lbLoseNick.text];
    //创建分享内容
    id<ISSContent> publishContent = [ShareSDK content:strShare
                                       defaultContent:@""
                                                image:[ShareSDK jpegImageWithImage:imgResult quality:1.0]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeImage];
    
    //自定义菜单项
    id<ISSShareActionSheetItem> item0 = [ShareSDK shareActionSheetItemWithTitle:@"新浪微博"
                                                                          icon:[UIImage imageNamed:@"weibo-icon"]
                                                                  clickHandler:^{
                                                                      NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"BoardPkTimes"];
                                                                      NSUInteger nPKTimes = [[dict objectForKey:_leaderBoardItem.userid]unsignedIntegerValue];
                                                                      
                                                                      if (nPKTimes == 0) {
                                                                          [AlertManager showAlertText:[NSString stringWithFormat:@"亲，您今天已与%@PK分享了4次，明天才可以继续分享哦~", _leaderBoardItem.nikename]];
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
                                                                      
                                                                      if (_bShareWeibo) {
                                                                          [AlertManager showAlertText:@"亲，您已经分享过了，不可以重复分享哦！" InView:self.view hiddenAfter:2];
                                                                      }
                                                                      else
                                                                      {
                                                                          [self showCommonProgress];
                                                                          
                                                                          [[CommonUtility sharedInstance]sinaWeiBoShare:imgResult Content:@"分享了悦动帮圈子博文。" FinishBlock:^void(int errorCode)
                                                                           {
                                                                               [self hidenCommonProgress];
                                                                               
                                                                               if (errorCode == 0) {
                                                                                   _bShareWeibo = YES;
                                                                                   [self updateBoardPkTimes];
                                                                                   
                                                                                   [[SportForumAPI sharedInstance]userShareToFriends:^void(int errorCode, ExpEffect* expEffect){
                                                                                       if (errorCode == 0) {
                                                                                           UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                                                                                           
                                                                                           [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                                                                                            {
                                                                                                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                                                                                            }];
                                                                                       }
                                                                                   }];
                                                                               }
                                                                           }];
                                                                      }
                                                                  }];
    
    id<ISSShareActionSheetItem> item1 = [ShareSDK shareActionSheetItemWithTitle:@"关注动态"
                                                                           icon:[UIImage imageNamed:@"discover-status"]
                                                                   clickHandler:^{
                                                                       NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"BoardPkTimes"];
                                                                       NSUInteger nPKTimes = [[dict objectForKey:_leaderBoardItem.userid]unsignedIntegerValue];
                                                                       
                                                                       if (nPKTimes == 0) {
                                                                           [AlertManager showAlertText:[NSString stringWithFormat:@"亲，您今天已与%@PK分享了4次，明天才可以继续分享哦~", _leaderBoardItem.nikename]];
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
                                                                       
                                                                       if (_bShareCircle) {
                                                                           [AlertManager showAlertText:@"亲，您已经分享过了，不可以重复分享哦！"];
                                                                       }
                                                                       else
                                                                       {
                                                                           [self publishSportLog:strShare ArrImgs:[NSMutableArray arrayWithObjects:imgResult, nil] FinishBlock:^void(int errorCode)
                                                                            {
                                                                                if (errorCode == 0) {
                                                                                    _bShareCircle = YES;
                                                                                    [self updateBoardPkTimes];
                                                                                }
                                                                            }];
                                                                       }
                                                                   }];
    
    
    NSArray *shareList = [ShareSDK customShareListWithType:
                          item0,
                          item1,
                          nil];
    
    //创建容器
    id<ISSContainer> container = [ShareSDK container];
    
    //显示分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:shareList
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                [[IQKeyboardManager sharedManager]resignFirstResponder];
                                
                                if (state == SSPublishContentStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_SUC", @"分享成功"));
                                }
                                else if (state == SSPublishContentStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_SHARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
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

-(void)publishSportLog:(NSString*)strContent ArrImgs:(NSMutableArray*)arrImgs FinishBlock:(void(^)(int errorCode))finishedBlock
{
    [self showCommonProgress];
    
    [[ApplicationContext sharedInstance]upLoadByImageArray:arrImgs FinishedBlock:^(NSMutableArray *arrayResult){
        NSMutableArray * arrUrls = [[NSMutableArray alloc]init];
        
        for (UploadImageInfo *uploadImageInfo in arrayResult) {
            if (uploadImageInfo.bIsOk) {
                [arrUrls addObject:uploadImageInfo.upLoadUrl];
            }
        }
        
        NSMutableArray* articleSegments = [[NSMutableArray alloc]init];
        
        ArticleSegmentObject* segobj = [ArticleSegmentObject new];
        segobj.seg_type = @"TEXT";
        segobj.seg_content = strContent;
        [articleSegments addObject:segobj];
        
        for (NSString *strUrl in arrUrls) {
            ArticleSegmentObject* segobj = [ArticleSegmentObject new];
            segobj.seg_type = @"IMAGE";
            segobj.seg_content = strUrl;
            [articleSegments addObject:segobj];
        }
        
        [[SportForumAPI sharedInstance]articleNewByParArticleId:@""
                                                 ArticleSegment:articleSegments
                                                     ArticleTag:[NSArray arrayWithObject:[CommonFunction ConvertArticleTagTypeToString:e_article_life]] Type:@"" 
                                                  FinishedBlock:^(int errorCode, NSString* strDescErr, ExpEffect* expEffect) {
                                                      [self hidenCommonProgress];
                                                      
                                                      if (errorCode == RSA_ERROR_NONE) {
                                                          UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
                                                          
                                                          [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                                                           {
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                                                           }];
                                                          
                                                          /*m_timerReward = [NSTimer scheduledTimerWithTimeInterval: 2
                                                                                                           target: self
                                                                                                         selector: @selector(updateProfileInfo:)
                                                                                                         userInfo: [NSDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]
                                                                                                          repeats: NO];*/
                                                      } else {
                                                          [AlertManager showAlertText:strDescErr InView:self.view hiddenAfter:2];
                                                      }
                                                      
                                                      if (finishedBlock != nil) {
                                                          finishedBlock(errorCode);
                                                      }
                                                  }];
    }];
}

- (void)screenShot{
    /*UIImage* image = nil;
    UIGraphicsBeginImageContext(m_scrollView.contentSize);
    
    {
        CGPoint savedContentOffset = m_scrollView.contentOffset;
        CGRect savedFrame = m_scrollView.frame;
        m_scrollView.contentOffset = CGPointZero;
        
        m_scrollView.frame = CGRectMake(0, 0, m_scrollView.contentSize.width, m_scrollView.contentSize.height);        [m_scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        m_scrollView.contentOffset = savedContentOffset;
        m_scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        NSLog(@"截图成功!");
        
    }*/
    
    UIGraphicsBeginImageContext(self.view.frame.size); //currentView 当前的view
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    /*
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height * 2), YES, 0);
    
    //设置截屏大小
    
    [[self.view layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = viewImage.CGImage;
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width * 2, self.view.frame.size.height * 2);//self.view.frame;//;//这里可以设置想要截图的区域

    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    */
    
    //以下为图片保存代码
    
    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);//保存图片到照片库
    
    NSData *imageViewData = UIImagePNGRepresentation(viewImage);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pictureName= @"screenShow.png";
    _strScreenImgPath = [documentsDirectory stringByAppendingPathComponent:pictureName];
    [imageViewData writeToFile:_strScreenImgPath atomically:YES];//保存照片到沙盒目录
    
    //从手机本地加载图片
    //UIImage *bgImage2 = [[UIImage alloc]initWithContentsOfFile:savedImagePath];
}

- (UIImage*) renderScrollViewToImage
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size,NO,0.0f);
    {
        [self.view.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
    }
    
    UIGraphicsEndImageContext();
    return image;
}

-(void)startChangePngAnimated
{
    _imgViewUser.alpha = 0.f;
    _imgViewPKUser.alpha = 0.f;
    _nNextImage = 0;
    _myAnimatedView.hidden = NO;
    _myAnimatedView.image = _arrAnimationImgs[_nNextImage++];
    
    _myAnimatedTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(setNextImage) userInfo:nil repeats:YES];
}

-(void)stopChangeAnimated
{
    _imgViewUser.alpha = 1.f;
    _imgViewPKUser.alpha = 1.f;
    
    CGRect frame = _imgViewUser.frame;
    frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(_viewBody.frame) / 2 - frame.size.height / 2);
    _imgViewUser.frame = frame;
    
    frame = _imgViewPKUser.frame;
    frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(_viewBody.frame) / 2 - frame.size.height / 2);
    _imgViewPKUser.frame = frame;
    
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = _imgViewUser.frame;
        frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(_viewBody.frame) - 206);
        _imgViewUser.frame = frame;
        
        frame = _imgViewPKUser.frame;
        frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(_viewBody.frame) - 206);
        _imgViewPKUser.frame = frame;
    }];

    [UIView animateWithDuration:0.25 animations:^{
        _viewBackground.alpha = 0.f;
        _myAnimatedView.hidden = YES;
        [_myAnimatedTimer invalidate];
        _myAnimatedTimer = nil;
        
        _pkLoseView.hidden = NO;
        
        CGRect frame = _imgViewUser.frame;
        frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(_viewBody.frame) - 206);
        _imgViewUser.frame = frame;
        
        frame = _imgViewPKUser.frame;
        frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(_viewBody.frame) - 206);
        _imgViewPKUser.frame = frame;
        
        [self loadServerAnimation];
    }];
}

-(void)showPKResult
{
    [UIView animateWithDuration:0.25 animations:^{
        _pkResultView.alpha = 1.0;
        _pkWinView.alpha = 1.0;
        _lbWinerNick.alpha = 1.0;
        _lbLoseNick.alpha = 1.0;
        _viewUp.alpha = 1.0;
        _btnShare.enabled = YES;
        [_imgViewShare setImage:[UIImage imageNamed:@"nav-share-btn"]];
    }];
}

-(void)setNextImage
{
    if (_nNextImage == _arrAnimationImgs.count) {
        _nNextImage = 0;
    }

    _myAnimatedView.image = _arrAnimationImgs[_nNextImage++];
}

- (void)moveImagePath:(UIView *)view
{
    CGRect frame = view.frame;
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, CGRectGetHeight(_viewBody.frame) / 2 - CGRectGetMinY(_viewBody.frame) / 2);
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, CGRectGetHeight(_viewBody.frame) / 2 - CGRectGetMinY(_viewBody.frame) / 2);
    
    if(frame.origin.x < CGRectGetWidth(_viewBody.frame) / 2)
    {
        CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(_viewBody.frame) / 2 + frame.size.width/2, CGRectGetHeight(_viewBody.frame) / 2 - CGRectGetMinY(_viewBody.frame) / 2);
    }
    else
    {
        CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(_viewBody.frame) / 2 - frame.size.width/2, CGRectGetHeight(_viewBody.frame) / 2 - CGRectGetMinY(_viewBody.frame) / 2);
    }

    for (int nIndex = 0; nIndex < 12; nIndex++) {
        if(frame.origin.x < CGRectGetWidth(_viewBody.frame) / 2)
        {
            CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(_viewBody.frame) / 2 - frame.size.width/2, CGRectGetHeight(_viewBody.frame) / 2 - CGRectGetMinY(_viewBody.frame) / 2);
            CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(_viewBody.frame) / 2 + frame.size.width/2, CGRectGetHeight(_viewBody.frame) / 2 - CGRectGetMinY(_viewBody.frame) / 2);
        }
        else
        {
            CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(_viewBody.frame) / 2 + frame.size.width/2, CGRectGetHeight(_viewBody.frame) / 2 - CGRectGetMinY(_viewBody.frame) / 2);
            CGPathAddLineToPoint(shakePath, NULL, CGRectGetWidth(_viewBody.frame) / 2 - frame.size.width/2, CGRectGetHeight(_viewBody.frame) / 2 - CGRectGetMinY(_viewBody.frame) / 2);
        }
    }
    
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, CGRectGetHeight(_viewBody.frame) / 2 - CGRectGetMinY(_viewBody.frame) / 2);
    CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, CGRectGetHeight(_viewBody.frame) - 160);
    
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = 5.0f;
    shakeAnimation.removedOnCompletion = NO;
    shakeAnimation.fillMode = kCAFillModeForwards;
    
    [shakeAnimation setCalculationMode:kCAAnimationLinear];
    [shakeAnimation setKeyTimes:[NSArray arrayWithObjects:
                                               [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.1],
                                               [NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.25],
                                               [NSNumber numberWithFloat:0.275], [NSNumber numberWithFloat:0.3],
                                               [NSNumber numberWithFloat:0.325], [NSNumber numberWithFloat:0.35],
                                               [NSNumber numberWithFloat:0.375], [NSNumber numberWithFloat:0.4],
                                               [NSNumber numberWithFloat:0.425], [NSNumber numberWithFloat:0.45],
                                               [NSNumber numberWithFloat:0.475], [NSNumber numberWithFloat:0.5],
                                               [NSNumber numberWithFloat:0.525], [NSNumber numberWithFloat:0.55],
                                               [NSNumber numberWithFloat:0.575], [NSNumber numberWithFloat:0.6],
                                               [NSNumber numberWithFloat:0.625], [NSNumber numberWithFloat:0.65],
                                               [NSNumber numberWithFloat:0.675], [NSNumber numberWithFloat:0.7],
                                               [NSNumber numberWithFloat:0.725], [NSNumber numberWithFloat:0.75],
                                               [NSNumber numberWithFloat:0.775],[NSNumber numberWithFloat:0.8],
                                               [NSNumber numberWithFloat:0.825], [NSNumber numberWithFloat:0.85],
                                               [NSNumber numberWithFloat:0.9], [NSNumber numberWithFloat:1.0], nil]];
    
    [view.layer addAnimation:shakeAnimation forKey:nil];
    CFRelease(shakePath);
    
    frame = view.frame;
    frame.origin = CGPointMake(frame.origin.x, CGRectGetHeight(_viewBody.frame) - 206);
    view.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"PKViewController dealloc called!");
}

@end
