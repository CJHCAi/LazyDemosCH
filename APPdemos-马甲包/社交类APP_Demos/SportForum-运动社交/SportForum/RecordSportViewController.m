//
//  RecordSportViewController.m
//  SportForum
//
//  Created by liyuan on 4/14/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import "RecordSportViewController.h"
#import "UIViewController+SportFormu.h"
#import "ImageEditViewController.h"
#import "CustomMenuViewController.h"
#import "UIImageView+WebCache.h"
#import "ZYQAssetPickerController.h"
#import "AlertManager.h"
#import "MWPhotoBrowser.h"
#import "IQKeyboardManager.h"
#import "CommonUtility.h"
#import "TRSDialScrollView.h"
#import "JRHealthKitManager.h"
#import "ZJSwitch.h"
#import "ALDClock.h"
#import "GCPlaceholderTextView.h"
#import "RecordSendHeartViewController.h"
#import "AppDelegate.h"
#import "IQKeyboardManager.h"

#import "RecordReceiveHeartViewController.h"

#define MAX_PUBLISH_PNG_COUNT 1

@interface RecordSportViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate, MWPhotoBrowserDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@end

@implementation RecordSportViewController
{
    UIScrollView *m_scrollView;
    UIView *m_viewBody;
    
    //Sport Clock View
    UIView *m_viewSpeed;
    UIView *m_viewPace;
    ALDClock *m_clock;
    
    //Sport Info
    UITextField *_tfDate;
    UITextField *_tfWeidget;
    UITextField *_tfDuration;
    UITextField *_tfDistance;
    ZJSwitch *m_switchAuto;
    
    CSButton *_btnAddPng;
    UILabel *_lbSource;
    UILabel *_lbAutoTips;
    UILabel *_labelPng;
    
    GCPlaceholderTextView * _tvContent;
    
    //Begin Date PickView
    UIView *m_viewBeginDate;
    UIView *m_pickerView0;
    UIDatePicker *m_pickerDate;
    
    //Weidget PickView
    UIView *m_viewWeidget;
    UIView * m_pickerView1;
    
    //Duration PickView
    UIView *m_viewDuration;
    UIView * m_pickerView2;
    
    ImageEditViewController* _imageEditViewController;
    CustomMenuViewController* _customMenuViewController;
    
    NSString *_strOldData;
    NSString *_strSource;
    
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _imgViewArray;
    NSMutableArray * _imgBtnArray;
    NSMutableArray * _imgBackFrameArray;
    NSMutableArray *_photos;
    
    BOOL _bUpdatePhotos;
    BOOL _bHealthAvail;
    BOOL _bUpdateTime;
    BOOL _bPublic;
    id m_processWindow;
    NSInteger _durationSec;
    
    NSTimer *_timeRefresh;
    NSDate *_beginTime;
    NSDate *_endTime;
    NSInteger _nHeartRate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self generateCommonViewInParent:self.view Title:@"记录运动" IsNeedBackBtn:YES];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
    
    m_viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    m_viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = m_viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    m_viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:m_viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = m_viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    m_viewBody.layer.mask = maskLayer;
    
    m_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(m_viewBody.frame), CGRectGetHeight(m_viewBody.frame))];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.scrollEnabled = YES;
    [m_viewBody addSubview:m_scrollView];

    UIImageView *viewTitleBar = (UIImageView *)[self.view viewWithTag:GENERATE_VIEW_TITLE_BAR];
    UIImageView *imgViewFinish = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewTitleBar.frame) - 39, 27, 37, 37)];
    [imgViewFinish setImage:[UIImage imageNamed:@"nav-finish-btn"]];
    [self.view addSubview:imgViewFinish];
    
    CSButton *btnFinish = [CSButton buttonWithType:UIButtonTypeCustom];
    btnFinish.frame = CGRectMake(CGRectGetMinX(imgViewFinish.frame) - 5, CGRectGetMinY(imgViewFinish.frame) - 5, 45, 45);
    btnFinish.backgroundColor = [UIColor clearColor];
    [self.view addSubview:btnFinish];
    [self.view bringSubviewToFront:btnFinish];
    
    __weak typeof (self) thisPoint = self;
    
    btnFinish.actionBlock = ^void()
    {
        __typeof(self) strongSelf = thisPoint;
        [strongSelf actionPublish];
    };

    [self generateSportClockView];
    
    _imgUrlArray = [[NSMutableArray alloc]init];
    _imgViewArray = [[NSMutableArray alloc]init];
    _imgBtnArray = [[NSMutableArray alloc]init];
    _imgBackFrameArray = [[NSMutableArray alloc]init];
    _photos = [[NSMutableArray alloc]init];
    _bUpdatePhotos = NO;
    [self checkHealthyAvailable];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshImageViews];
    [self startTimeRefresh];
    _strOldData = @"";
    [MobClick beginLogPageView:@"记录运动成绩 - RecordSportViewController"];
    [[ApplicationContext sharedInstance]setRegUserPath:@"记录运动成绩 - RecordSportViewController"];
    [_tfDistance addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_timeRefresh invalidate];
    _timeRefresh = nil;
    [self hidenCommonProgress];
    [_tfDistance removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"RecordTime"];
    NSMutableDictionary * recordTimeDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [recordTimeDict setObject:@(m_clock.hour) forKey:@"Hour"];
    [recordTimeDict setObject:@(m_clock.minute) forKey:@"Minute"];
    [recordTimeDict setObject:@(_durationSec / 60) forKey:@"Duration"];
    [[ApplicationContext sharedInstance] saveObject:recordTimeDict byKey:@"RecordTime"];
    [MobClick endLogPageView:@"记录运动成绩 - RecordSportViewController"];
    [super viewWillDisappear:animated];
}

-(void)showCommonProgress{
    m_processWindow = [AlertManager showCommonProgress];
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:m_processWindow];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"RecordSportViewController dealloc called!");
}

-(void)actionPublish{
    /*RecordSendHeartViewController *recordSendHeartViewController = [[RecordSendHeartViewController alloc]init];
    recordSendHeartViewController.nHeartRateValue = 80;
    [self.navigationController popViewControllerAnimated:NO];
    
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [delegate.mainNavigationController pushViewController:recordSendHeartViewController animated:YES];
    return;
    
    RecordReceiveHeartViewController * recordReceiveHeartViewController = [[RecordReceiveHeartViewController alloc]init];
    recordReceiveHeartViewController.strSendId = [[ApplicationContext sharedInstance] accountInfo].userid;
    recordReceiveHeartViewController.strRecordId = @"556819ba81b6037f37000001";
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [delegate.mainNavigationController pushViewController:recordReceiveHeartViewController animated:YES];
    return;*/
    
    BOOL blErr = NO;
    
    [_tfDistance endEditing:YES];
    [_tvContent resignFirstResponder];
    
    if ([_tfDistance.text floatValue] == 0) {
        blErr = YES;
        [JDStatusBarNotification showWithStatus:@"跑步距离不能为0，没有记录意义" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
    } else if([_tfDistance.text floatValue] > 50) {
        blErr = YES;
        [JDStatusBarNotification showWithStatus:@"跑步数超过50公里，数据不合理" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
    }
    
    if (blErr == NO) {
        if (_durationSec < 10 * 60) {
            blErr = YES;
            [JDStatusBarNotification showWithStatus:@"跑步时间太短，10分钟都没有，没有记录意义" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        }
        else if(_durationSec > 4 * 60 * 60)
        {
            blErr = YES;
            [JDStatusBarNotification showWithStatus:@"跑步时间超过4小时，数据不合理" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        }
    }
    
    if (blErr == NO && !m_switchAuto.on) {
        if (_imgUrlArray.count == 0) {
            blErr = YES;
            [JDStatusBarNotification showWithStatus:@"手工填写记录时，必须上传运动轨迹图" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
        }
    }
    
    //__typeof(self) __weak weakSelf = self;
    
    if (blErr == NO) {
        NSString *strDate = _tfDate.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy年MM月dd日 HH:mm"];
        NSDate *myDate0 = [formatter dateFromString:strDate];
        NSDate *myDate1 = [[NSDate alloc]initWithTimeInterval:_durationSec sinceDate:myDate0];
        
        if ([myDate1 timeIntervalSinceDate:[NSDate date]] > 0.0) {
            [JDStatusBarNotification showWithStatus:@"无法统计未来时间的运动记录情况" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
        
        if (m_switchAuto.on) {
            myDate0 = _beginTime;
            myDate1 = _endTime;
        }

        float fSpeed = [_tfDistance.text floatValue] / ([myDate1 timeIntervalSinceDate:myDate0] / 3600.0);
        
        if (fSpeed < 1) {
            [JDStatusBarNotification showWithStatus:@"跑步速度太慢，没有记录意义" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
            return;
        }
        
        [self showCommonProgress];
        
        SportRecordInfo* sportRecordInfo =[[SportRecordInfo alloc]init];
        sportRecordInfo.type = @"run";
        sportRecordInfo.source = (m_switchAuto.on ? _strSource : @"");
        sportRecordInfo.begin_time = [myDate0 timeIntervalSince1970];
        sportRecordInfo.end_time = [myDate1 timeIntervalSince1970];
        sportRecordInfo.duration = [myDate1 timeIntervalSinceDate:myDate0];
        sportRecordInfo.distance = [_tfDistance.text floatValue] * 1000;
        sportRecordInfo.sport_pics.data = _imgUrlArray;
        sportRecordInfo.weight = [_tfWeidget.text integerValue];
        sportRecordInfo.mood = _tvContent.text;
        sportRecordInfo.heart_rate = _nHeartRate;

        __typeof(self) __weak weakSelf = self;
        
        [[SportForumAPI sharedInstance]recordNewByRecordItem:sportRecordInfo RecordId:_taskInfo.task_id Public:_bPublic
                                               FinishedBlock:^(int errorCode, NSString* strDescErr, NSString* strRecordId, ExpEffect* expEffect) {
                                                   __typeof(self) strongSelf = weakSelf;
                                                   
                                                   if (strongSelf == nil) {
                                                       return;
                                                   }
                                                   
                                                   [self hidenCommonProgress];
                                                   
                                                   if (errorCode == 0) {
                                                       UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
                                                       userInfo.weight = sportRecordInfo.weight;

                                                       [[ApplicationContext sharedInstance]getProfileInfo:userInfo.userid FinishedBlock:^void(int errorCode)
                                                        {
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                                                        }];
                                                       
                                                       if (_taskInfo != nil) {
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_TASK_STATUS object:nil];
                                                           
                                                           if (_bPublic && strRecordId.length > 0) {
                                                               RecordSendHeartViewController *recordSendHeartViewController = [[RecordSendHeartViewController alloc]init];
                                                               //recordSendHeartViewController.nHeartRateValue = 80;
                                                               recordSendHeartViewController.strRecordId = strRecordId;
                                                               [self.navigationController popViewControllerAnimated:NO];
                                                               
                                                               AppDelegate* delegate = [UIApplication sharedApplication].delegate;
                                                               [delegate.mainNavigationController pushViewController:recordSendHeartViewController animated:YES];
                                                               
                                                               return;
                                                           }
                                                           else
                                                           {
                                                               [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_SWITCH_VIEW object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:VIEW_MAIN_PAGE, @"PageName", nil]];
                                                           }
                                                       }
                                                       else
                                                       {
                                                           if (_bPublic && strRecordId.length > 0) {
                                                               RecordSendHeartViewController *recordSendHeartViewController = [[RecordSendHeartViewController alloc]init];
                                                               //recordSendHeartViewController.nHeartRateValue = 80;
                                                               recordSendHeartViewController.strRecordId = strRecordId;
                                                               [self.navigationController popViewControllerAnimated:NO];
                                                               
                                                               AppDelegate* delegate = [UIApplication sharedApplication].delegate;
                                                               [delegate.mainNavigationController pushViewController:recordSendHeartViewController animated:YES];
                                                               
                                                               return;
                                                           }
                                                           else
                                                           {
                                                               [self.navigationController popViewControllerAnimated:YES];
                                                           }
                                                       }
                                                   }else{
                                                       [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                   }
                                               }];
    }
}

#pragma mark - Create View

-(void)generateSportClockView
{
    m_viewSpeed = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 140)];
    m_viewSpeed.backgroundColor = [UIColor clearColor];
    m_viewSpeed.hidden = YES;
    [m_scrollView addSubview:m_viewSpeed];
    
    UIImageView *imgViewSpeed = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 20, 20)];
    [imgViewSpeed setImage:[UIImage imageNamed:@"data-record-speed"]];
    [m_viewSpeed addSubview:imgViewSpeed];
    
    UILabel *lbSpeed = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgViewSpeed.frame) + 10, CGRectGetMinY(imgViewSpeed.frame), 40, 25)];
    lbSpeed.backgroundColor = [UIColor clearColor];
    lbSpeed.textColor = [UIColor darkGrayColor];
    lbSpeed.font = [UIFont boldSystemFontOfSize:14];
    lbSpeed.textAlignment = NSTextAlignmentLeft;
    lbSpeed.text = @"速度";
    [m_viewSpeed addSubview:lbSpeed];
    
    UILabel *lbSpeedValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgViewSpeed.frame), CGRectGetMaxY(imgViewSpeed.frame), 80, 25)];
    lbSpeedValue.backgroundColor = [UIColor clearColor];
    lbSpeedValue.textColor = [UIColor darkGrayColor];
    lbSpeedValue.font = [UIFont boldSystemFontOfSize:14];
    lbSpeedValue.textAlignment = NSTextAlignmentLeft;
    lbSpeedValue.tag = 10000;
    [m_viewSpeed addSubview:lbSpeedValue];
    
    NSInteger nHour = 0;
    NSInteger nMinute = 0;
    NSInteger nDuration = 0;
    
    NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"RecordTime"];
    NSMutableDictionary * recordTimeDict = nil;
    
    if (dict == nil) {
        nHour = 6;
        nMinute = 0;
        nDuration = 65;
        recordTimeDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(6), @"Hour", @(0), @"Minute", @(65), @"Duration", nil];
        [[ApplicationContext sharedInstance] saveObject:recordTimeDict byKey:@"RecordTime"];
    }
    else
    {
        NSMutableDictionary * recordTimeDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        nHour = [[recordTimeDict objectForKey:@"Hour"]integerValue];
        nMinute = [[recordTimeDict objectForKey:@"Minute"]integerValue];
        nDuration = [[recordTimeDict objectForKey:@"Duration"]integerValue];
    }
    
    UIImageView *imgViewClock = [[UIImageView alloc]initWithFrame:CGRectMake((CGRectGetWidth(m_scrollView.frame) - 131) / 2, 2, 131, 131)];
    [imgViewClock setImage:[UIImage imageNamed:@"data-record-clock"]];
    [m_scrollView addSubview:imgViewClock];
    
    //Create Time Snap
    m_clock = [[ALDClock alloc] initWithFrame:imgViewClock.frame];
    [m_scrollView addSubview:m_clock];
    [self applyClockCustomisations];
    [m_clock setHour:nHour minute:nMinute animated:NO];
    
    if (nHour >= 0 && nHour <= 12) {
        m_clock.title = @"AM";
    }
    else
    {
        m_clock.title = @"PM";
    }
    
    m_viewPace = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetWidth(m_scrollView.frame) - 90, 0, 90, 140)];
    m_viewPace.backgroundColor = [UIColor clearColor];
    m_viewPace.hidden = YES;
    [m_scrollView addSubview:m_viewPace];

    UIImageView *imgViewPace = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 20, 20)];
    [imgViewPace setImage:[UIImage imageNamed:@"data-record-cal"]];
    [m_viewPace addSubview:imgViewPace];
    
    UILabel *lbPace = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgViewPace.frame) + 10, CGRectGetMinY(imgViewPace.frame), 40, 25)];
    lbPace.backgroundColor = [UIColor clearColor];
    lbPace.textColor = [UIColor darkGrayColor];
    lbPace.font = [UIFont boldSystemFontOfSize:14];
    lbPace.textAlignment = NSTextAlignmentLeft;
    lbPace.text = @"热量";
    [m_viewPace addSubview:lbPace];
    
    UILabel *lbPaceValue = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imgViewPace.frame) + 2, CGRectGetMaxY(imgViewPace.frame), 80, 25)];
    lbPaceValue.backgroundColor = [UIColor clearColor];
    lbPaceValue.textColor = [UIColor darkGrayColor];
    lbPaceValue.font = [UIFont boldSystemFontOfSize:14];
    lbPaceValue.textAlignment = NSTextAlignmentLeft;
    lbPaceValue.tag = 10000;
    [m_viewPace addSubview:lbPaceValue];
    
    UserInfo *userInfo = [ApplicationContext sharedInstance].accountInfo;
    
    UILabel *labelDate = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_viewPace.frame), 70, 20)];
    labelDate.backgroundColor = [UIColor clearColor];
    labelDate.textColor = [UIColor darkGrayColor];
    labelDate.text = @"开始时间：";
    labelDate.textAlignment = NSTextAlignmentLeft;
    labelDate.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:labelDate];
    
    _tfDate = [[UITextField alloc]initWithFrame:CGRectMake(80, CGRectGetMinY(labelDate.frame) - 3, 220, 30)];
    _tfDate.backgroundColor = [UIColor whiteColor];
    _tfDate.font = [UIFont systemFontOfSize:14];
    _tfDate.textAlignment = NSTextAlignmentLeft; //水平左对齐
    _tfDate.text = @"";
    _tfDate.multipleTouchEnabled = YES;
    _tfDate.enabled = NO;
    _tfDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tfDate.layer.borderWidth = 1.0;
    _tfDate.layer.cornerRadius = 5.0;
    _tfDate.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];;
    _tfDate.leftViewMode = UITextFieldViewModeAlways;
    [m_scrollView addSubview:_tfDate];
    
    [self setBeginDate:nHour Minute:nMinute];
    
    CSButton *btnDate = [CSButton buttonWithType:UIButtonTypeCustom];
    btnDate.frame = _tfDate.frame;
    btnDate.backgroundColor = [UIColor clearColor];
    [m_scrollView addSubview:btnDate];
    
    __weak __typeof(self) weakSelf = self;
    
    btnDate.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
         [strongSelf->_tfDistance endEditing:YES];
        [strongSelf->_tvContent resignFirstResponder];
        [strongSelf popPickView:strongSelf->m_viewBeginDate PickView:strongSelf->m_pickerView0];
    };
    
    UILabel *lbTimeDuration = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_tfDate.frame) + 10, 70, 20)];
    lbTimeDuration.backgroundColor = [UIColor clearColor];
    lbTimeDuration.textColor = [UIColor darkGrayColor];
    lbTimeDuration.text = @"持续时间：";
    lbTimeDuration.textAlignment = NSTextAlignmentLeft;
    lbTimeDuration.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbTimeDuration];
    
    _tfDuration = [[UITextField alloc]initWithFrame:CGRectMake(80, CGRectGetMinY(lbTimeDuration.frame) - 3, 50, 30)];
    _tfDuration.backgroundColor = [UIColor whiteColor];
    _tfDuration.font = [UIFont systemFontOfSize:14];
    _tfDuration.textAlignment = NSTextAlignmentLeft; //水平左对齐
    _tfDuration.text = @"";
    _tfDuration.multipleTouchEnabled = YES;
    _tfDuration.enabled = NO;
    _tfDuration.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tfDuration.layer.borderWidth = 1.0;
    _tfDuration.layer.cornerRadius = 5.0;
    _tfDuration.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _tfDuration.leftViewMode = UITextFieldViewModeAlways;
    [m_scrollView addSubview:_tfDuration];
    
    _tfDuration.text = [NSString stringWithFormat:@"%lu", nDuration > 0 ? nDuration : 60];
    
    CSButton *btnDuration = [CSButton buttonWithType:UIButtonTypeCustom];
    btnDuration.frame = _tfDuration.frame;
    btnDuration.backgroundColor = [UIColor clearColor];
    [m_scrollView addSubview:btnDuration];
    
    btnDuration.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->_tfDistance endEditing:YES];
        [strongSelf->_tvContent resignFirstResponder];
        [strongSelf popPickView:strongSelf->m_viewDuration PickView:strongSelf->m_pickerView2];
    };
    
    UILabel *lbDurationUnit = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tfDuration.frame) + 5, CGRectGetMinY(lbTimeDuration.frame), 40, 20)];
    lbDurationUnit.backgroundColor = [UIColor clearColor];
    lbDurationUnit.textColor = [UIColor darkGrayColor];
    lbDurationUnit.text = @"分钟";
    lbDurationUnit.textAlignment = NSTextAlignmentLeft;
    lbDurationUnit.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbDurationUnit];
    
    UILabel *lbWeidgt = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbDurationUnit.frame), CGRectGetMinY(lbTimeDuration.frame), 50, 20)];
    lbWeidgt.backgroundColor = [UIColor clearColor];
    lbWeidgt.textColor = [UIColor darkGrayColor];
    lbWeidgt.text = @"体重：";
    lbWeidgt.textAlignment = NSTextAlignmentLeft;
    lbWeidgt.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbWeidgt];
    
    _tfWeidget = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbWeidgt.frame), CGRectGetMinY(lbWeidgt.frame) - 3, 50, 30)];
    _tfWeidget.backgroundColor = [UIColor whiteColor];
    _tfWeidget.font = [UIFont systemFontOfSize:14];
    _tfWeidget.textAlignment = NSTextAlignmentLeft; //水平左对齐
    _tfWeidget.text = @"";
    _tfWeidget.multipleTouchEnabled = YES;
    _tfWeidget.enabled = NO;
    _tfWeidget.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tfWeidget.layer.borderWidth = 1.0;
    _tfWeidget.layer.cornerRadius = 5.0;
    _tfWeidget.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];;
    _tfWeidget.leftViewMode = UITextFieldViewModeAlways;
    [m_scrollView addSubview:_tfWeidget];
    
    _tfWeidget.text = [NSString stringWithFormat:@"%lu", [[CommonUtility sharedInstance]generateWeightBySex:userInfo.sex_type Weight:userInfo.weight]];
    
    CSButton *btnWeidget = [CSButton buttonWithType:UIButtonTypeCustom];
    btnWeidget.frame = _tfWeidget.frame;
    btnWeidget.backgroundColor = [UIColor clearColor];
    [m_scrollView addSubview:btnWeidget];
    
    btnWeidget.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->_tfDistance endEditing:YES];
        [strongSelf->_tvContent resignFirstResponder];
        [strongSelf popPickView:strongSelf->m_viewWeidget PickView:strongSelf->m_pickerView1];
    };
    
    UILabel *lbWeidgtUnit = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tfWeidget.frame) + 5, CGRectGetMinY(lbWeidgt.frame), 60, 20)];
    lbWeidgtUnit.backgroundColor = [UIColor clearColor];
    lbWeidgtUnit.textColor = [UIColor darkGrayColor];
    lbWeidgtUnit.text = @"kg";
    lbWeidgtUnit.textAlignment = NSTextAlignmentLeft;
    lbWeidgtUnit.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbWeidgtUnit];
    
    UIView *viewDistanceBg = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_tfDuration.frame) + 5, CGRectGetWidth(m_scrollView.frame), 125)];
    viewDistanceBg.backgroundColor = [UIColor colorWithRed:230.0 / 255.0 green:230.0 / 255.0 blue:230.0 / 255.0 alpha:1.0];
    [m_scrollView addSubview:viewDistanceBg];
    
    UILabel *lbDistance = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMinY(viewDistanceBg.frame) + 10, 70, 30)];
    lbDistance.backgroundColor = [UIColor clearColor];
    lbDistance.textColor = [UIColor darkGrayColor];
    lbDistance.text = @"距离：";
    lbDistance.textAlignment = NSTextAlignmentLeft;
    lbDistance.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbDistance];
    
    _tfDistance = [[UITextField alloc]initWithFrame:CGRectMake(80, CGRectGetMinY(lbDistance.frame), 50, 30)];
    _tfDistance.font = [UIFont systemFontOfSize:14];
    _tfDistance.textAlignment = NSTextAlignmentLeft; //水平左对齐
    _tfDistance.text = @"";
    _tfDistance.textColor = [UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0];
    _tfDistance.backgroundColor = [UIColor clearColor];
    _tfDistance.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _tfDistance.multipleTouchEnabled = YES;
    _tfDistance.enabled = NO;
    _tfDistance.delegate = self;
    _tfDistance.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tfDistance.layer.borderWidth = 1;
    _tfDistance.layer.cornerRadius = 5.0;
    _tfDistance.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 25)];
    _tfDistance.leftViewMode = UITextFieldViewModeAlways;
    [m_scrollView addSubview:_tfDistance];
    
    UILabel *lbDistanceUnit = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_tfDistance.frame) + 5, CGRectGetMinY(lbDistance.frame), 30, 30)];
    lbDistanceUnit.backgroundColor = [UIColor clearColor];
    lbDistanceUnit.textColor = [UIColor darkGrayColor];
    lbDistanceUnit.text = @"km";
    lbDistanceUnit.textAlignment = NSTextAlignmentLeft;
    lbDistanceUnit.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbDistanceUnit];
    
    m_switchAuto = [[ZJSwitch alloc] initWithFrame:CGRectMake(210, CGRectGetMinY(_tfDistance.frame) - 2, 90, 27)];
    m_switchAuto.onTintColor = [UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0];
    m_switchAuto.tintColor = [UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0];
    m_switchAuto.thumbTintColor = [UIColor blackColor];
    m_switchAuto.style = ZJSwitchStyleBorder;
    m_switchAuto.onText = @"自动导入";
    m_switchAuto.offText = @"手工填写";
    m_switchAuto.textFont = [UIFont systemFontOfSize:13];
    [m_switchAuto addTarget:self action:@selector(autoModeChanged:) forControlEvents:UIControlEventValueChanged];
    m_switchAuto.on = NO;
    [m_scrollView addSubview:m_switchAuto];
    
    _lbSource = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_switchAuto.frame) + 5, CGRectGetWidth(m_scrollView.frame) - 20, 40)];
    _lbSource.backgroundColor = [UIColor clearColor];
    _lbSource.textColor = [UIColor darkGrayColor];
    _lbSource.text = @"从本机健康App导入，数据来源：";
    _lbSource.textAlignment = NSTextAlignmentLeft;
    _lbSource.font = [UIFont systemFontOfSize:13];
    _lbSource.numberOfLines = 0;
    [m_scrollView addSubview:_lbSource];
    
//    _lbSourceData = [[UILabel alloc]initWithFrame:CGRectMake(225, CGRectGetMinY(_lbSource.frame), 85, 20)];
//    _lbSourceData.backgroundColor = [UIColor clearColor];
//    _lbSourceData.textColor = [UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0];
//    _lbSourceData.text = @"";
//    _lbSourceData.textAlignment = NSTextAlignmentLeft;
//    _lbSourceData.font = [UIFont boldSystemFontOfSize:14];
//    [m_scrollView addSubview:_lbSourceData];
    
    _lbAutoTips = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_lbSource.frame), 290, 40)];
    _lbAutoTips.backgroundColor = [UIColor clearColor];
    _lbAutoTips.textColor = [UIColor darkGrayColor];
    _lbAutoTips.text = @"如果没有健康App读取权限，可以在【健康App>数据来源>悦动力】应用程序中授权。";
    _lbAutoTips.textAlignment = NSTextAlignmentLeft;
    _lbAutoTips.font = [UIFont systemFontOfSize:13];
    _lbAutoTips.numberOfLines = 0;
    [m_scrollView addSubview:_lbAutoTips];
    
    _labelPng = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_switchAuto.frame) + 15, 220, 60)];
    _labelPng.backgroundColor = [UIColor clearColor];
    _labelPng.textColor = [UIColor darkGrayColor];
    _labelPng.text = @"有图有真相：(点击加号添加GPS运动轨迹图，或运动器材的数值记录)";
    _labelPng.textAlignment = NSTextAlignmentLeft;
    _labelPng.numberOfLines = 0;
    _labelPng.font = [UIFont boldSystemFontOfSize:14];
    _labelPng.hidden = YES;
    [m_scrollView addSubview:_labelPng];
    
    _btnAddPng = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnAddPng.frame = CGRectMake(CGRectGetWidth(m_scrollView.frame) - 70, CGRectGetMaxY(m_switchAuto.frame) + 15, 60, 60);
    [_btnAddPng setImage:[UIImage imageNamed:@"add-images"] forState:UIControlStateNormal];
    _btnAddPng.hidden = YES;
    [m_scrollView addSubview:_btnAddPng];
    
    _btnAddPng.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->_tfDistance endEditing:YES];
        [strongSelf showPicSelect];
    };
    
    UILabel *lbFeel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(viewDistanceBg.frame) + 10, 70, 30)];
    lbFeel.backgroundColor = [UIColor clearColor];
    lbFeel.textColor = [UIColor darkGrayColor];
    lbFeel.text = @"运动心情：";
    lbFeel.textAlignment = NSTextAlignmentLeft;
    lbFeel.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:lbFeel];
    
    _tvContent = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(80, CGRectGetMaxY(viewDistanceBg.frame) + 10, 220, 110)];
    _tvContent.backgroundColor = [UIColor whiteColor];
    _tvContent.font = [UIFont boldSystemFontOfSize:14];
    _tvContent.textAlignment = NSTextAlignmentLeft; //水平左对齐
    _tvContent.textColor = [UIColor darkGrayColor];
    _tvContent.returnKeyType = UIReturnKeyDefault;
    _tvContent.multipleTouchEnabled = YES;
    _tvContent.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tvContent.layer.borderWidth = 1.0;
    _tvContent.layer.cornerRadius = 5.0;
    _tvContent.placeholder = @"亲，记录下运动心情吧...";
    [m_scrollView addSubview:_tvContent];
    
    UILabel *lbSep = [[UILabel alloc]init];
    lbSep.backgroundColor = [UIColor colorWithRed:222.0 / 255.0 green:222.0 / 255.0 blue:222.0 / 255.0 alpha:1.0];
    lbSep.frame = CGRectMake(0, CGRectGetMaxY(_tvContent.frame) + 10, 310, 1);
    [m_scrollView addSubview:lbSep];
    
    UIImageView *imgViewLock = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lbSep.frame) + 5, 24, 25)];
    [imgViewLock setImage:[UIImage imageNamed:@"data-record-public-2"]];
    [m_scrollView addSubview:imgViewLock];
    
    UILabel *lbLock = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgViewLock.frame) + 2, CGRectGetMinY(imgViewLock.frame) + 3, 215, 20)];
    lbLock.backgroundColor = [UIColor clearColor];
    lbLock.textColor = [UIColor darkGrayColor];
    lbLock.text = @"公开，所有人可见";
    lbLock.textAlignment = NSTextAlignmentLeft;
    lbLock.font = [UIFont systemFontOfSize:13];
    [m_scrollView addSubview:lbLock];
    
    CSButton *btnLock = [CSButton buttonWithType:UIButtonTypeCustom];
    btnLock.frame = CGRectMake(10, CGRectGetMinY(imgViewLock.frame), 290, 20);
    btnLock.backgroundColor = [UIColor clearColor];
    [m_scrollView addSubview:btnLock];
    
    btnLock.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        
        if ([lbLock.text isEqualToString:@"公开，所有人可见"]) {
            [imgViewLock setImage:[UIImage imageNamed:@"data-record-private-2"]];
            lbLock.text = @"隐私，仅自己可见";
            strongSelf->_bPublic = NO;
        }
        else
        {
            [imgViewLock setImage:[UIImage imageNamed:@"data-record-public-2"]];
            lbLock.text = @"公开，所有人可见";
            strongSelf->_bPublic = YES;
        }
    };
    
    [self createBeginDateView];
    [self createWeidgetView];
    [self createDurationView];
    _durationSec = nDuration * 60;
    _bPublic = YES;
    
    m_scrollView.contentSize = CGSizeMake(m_scrollView.contentSize.width, CGRectGetMaxY(btnLock.frame));
}

-(void)setSourceData:(NSString*)strText
{
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName:[UIColor darkGrayColor]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:@"从本机健康App导入，数据来源：" attributes:attribs];
    
    attribs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14], NSForegroundColorAttributeName:[UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:strText attributes:attribs];
    
    NSMutableAttributedString * strPer = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strPer appendAttributedString:strPart2Value];
    _lbSource.attributedText = strPer;
    
    _strSource = strText;
}

#pragma mark - Clock Control Logic

- (void)applyClockCustomisations
{
    // Change the background color of the clock (note that this is the color
    // of the clock face)
    m_clock.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.97 alpha:1.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    m_clock.digitAttributes = @{NSForegroundColorAttributeName : [UIColor clearColor],
                                NSParagraphStyleAttributeName: paragraphStyle,
                                NSFontAttributeName : [UIFont systemFontOfSize:16.0f]};
    
    m_clock.majorMarkingColor = [UIColor clearColor];
    m_clock.minorMarkingColor = [UIColor clearColor];
    // Add a title and subtitle to the clock face
    
    // When the time changes, call the the clockDidChangeTime: method.
    [m_clock addTarget:self action:@selector(clockDidChangeTime:) forControlEvents:UIControlEventValueChanged];
    
    // When the user begins/ends manually changing the time, call these methods.
    [m_clock addTarget:self action:@selector(clockDidBeginDragging:) forControlEvents:UIControlEventTouchDragEnter];
    [m_clock addTarget:self action:@selector(clockDidEndDragging:) forControlEvents:UIControlEventTouchDragExit];
    
    // Change the clock's border color and width
    m_clock.borderColor = [UIColor clearColor];
    m_clock.borderWidth = 0.0f;
}

- (void)clockDidChangeTime:(ALDClock *)clock
{
    _bUpdateTime = YES;
    
    if (clock.hour >= 0 && clock.hour <= 12) {
        m_clock.title = @"AM";
    }
    else
    {
        m_clock.title = @"PM";
    }
    
    [self setBeginDate:clock.hour Minute:clock.minute];
}

- (void)clockDidBeginDragging:(ALDClock *)clock
{
    clock.borderColor = [UIColor colorWithRed:0.78 green:0.22 blue:0.22 alpha:1.0];
}

- (void)clockDidEndDragging:(ALDClock *)clock
{
    clock.borderColor = [UIColor colorWithRed:0.22 green:0.78 blue:0.22 alpha:1.0];
    
    if(_bUpdateTime && _bHealthAvail && m_switchAuto.on)
    {
        [self updateDistance];
    }
    
    _bUpdateTime = NO;
}

-(void)setBeginDate:(NSInteger)nHour Minute:(NSInteger)nMinute
{
    NSDate *myDate = [NSDate date];
    
    if (_tfDate.text.length > 0) {
        NSString *strDate = _tfDate.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy年MM月dd日 HH:mm"];
        myDate = [formatter dateFromString:strDate];
    }
    
    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned units  = NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *_comps = [calendar components:units fromDate:myDate];
    NSInteger month = [_comps month];
    NSInteger year = [_comps year];
    NSInteger day = [_comps day];
    _tfDate.text = [NSString stringWithFormat:@"%04ld年%02ld月%02ld日 %02ld:%02ld", year, month, day, nHour, nMinute];
}

#pragma mark - Switch Distance logic
- (void)autoModeChanged:(id)sender
{
    if (_bHealthAvail) {
        NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"RecordMode"];
        NSMutableDictionary * recorddDict = nil;
        
        if (dict == nil) {
            recorddDict = [[NSMutableDictionary alloc]init];
        }
        else
        {
            recorddDict = [NSMutableDictionary dictionaryWithDictionary:dict];
        }
        
        [recorddDict setObject:@(m_switchAuto.on) forKey:@"Mode"];
        [[ApplicationContext sharedInstance] saveObject:recorddDict byKey:@"RecordMode"];
    }
    
    if (m_switchAuto.on) {
        _tfDistance.enabled = NO;
        _tfDistance.layer.borderWidth = 0;
        _tfDistance.textColor = [UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0];
        _tfDistance.backgroundColor = [UIColor clearColor];
        _tfDistance.font = [UIFont boldSystemFontOfSize:15];
        _lbSource.hidden = NO;
        _lbAutoTips.hidden = NO;
        
        _labelPng.hidden = YES;
        _btnAddPng.hidden = YES;
        
        [[JRHealthKitManager shareManager] getReadAndWriteAuthorizeWithCompleted:^(BOOL success, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!success) {
                    m_switchAuto.on = NO;
                    [self autoModeChanged:m_switchAuto];
                    
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"未授权健康App" message:@"您未授权健康App读写数据，无法使用自动导入数据功能。可以在【健康App>数据来源】应用程序中授权访问，方便自动导入运动数据。" delegate:nil cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                
                [self updateDistance];
            });
        }];
    }
    else
    {
        _tfDistance.enabled = YES;
        _tfDistance.layer.borderWidth = 1.0;
        _tfDistance.textColor = [UIColor blackColor];
        _tfDistance.text = @"";
        _tfDistance.backgroundColor = [UIColor whiteColor];
        _tfDistance.font = [UIFont systemFontOfSize:14];
        _lbSource.hidden = YES;
        _lbAutoTips.hidden = YES;
        
        _labelPng.hidden = NO;
        _btnAddPng.hidden = NO;
    }
    
    for (UIImageView* imageView in _imgViewArray) {
        [imageView removeFromSuperview];
    }
    
    for (CSButton *btnImage in _imgBtnArray) {
        [btnImage removeFromSuperview];
    }
    
    for (UIView *view in _imgBackFrameArray) {
        [view removeFromSuperview];
    }
    
    [_imgUrlArray removeAllObjects];
    [_imgViewArray removeAllObjects];
    [_imgBtnArray removeAllObjects];
    [_imgBackFrameArray removeAllObjects];
    [_photos removeAllObjects];
}

-(void)checkHealthyAvailable
{
    if (IOS8_OR_LATER && (_bHealthAvail = [[JRHealthKitManager shareManager]isHealthKitAvailable], _bHealthAvail)) {
        BOOL bAutoMode = NO;
        NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"RecordMode"];
        NSMutableDictionary * recorddDict = nil;
        
        if (dict == nil) {
            recorddDict = [[NSMutableDictionary alloc]init];
            [recorddDict setObject:@(m_switchAuto.on) forKey:@"Mode"];
            [[ApplicationContext sharedInstance] saveObject:recorddDict byKey:@"RecordMode"];
        }
        else
        {
            NSMutableDictionary * recorddDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            bAutoMode = [[recorddDict objectForKey:@"Mode"]boolValue];
        }
        
        m_switchAuto.on = bAutoMode;
        [self autoModeChanged:m_switchAuto];
    }
    else
    {
        m_switchAuto.on = NO;
        [self autoModeChanged:m_switchAuto];
        m_switchAuto.hidden = YES;
    }
}

-(void)updateDistanceForMore:(float) fDistance Source:(NSString*)strSource
{
    NSString *strDate = _tfDate.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy年MM月dd日 HH:mm"];
    NSDate *myDate0 = [formatter dateFromString:strDate];
    NSDate *myDate1 = [[NSDate alloc]initWithTimeInterval:_durationSec + 60 * 60 sinceDate:myDate0];
    
    _beginTime = myDate0;
    _endTime = myDate1;
    
    [[JRHealthKitManager shareManager] fetchDistancesFrom:myDate0 toDate:myDate1 completed:^(NSArray *samples, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }else {
            float fDistanceMore = fDistance;
            NSString *strSourceMore = @"";
            NSString* userPhoneName = [[UIDevice currentDevice] name];
            
            for (HKQuantitySample *sample in samples) {
                if(sample.metadata != nil)
                {
                    if ([sample.metadata objectForKey:@"HKWasUserEntered"] != nil && [[sample.metadata objectForKey:@"HKWasUserEntered"]intValue] == 1) {
                        continue;
                    }
                }
                
                HKSource *source = sample.source;
                
                if (![source.name isEqualToString:userPhoneName]) {
                    NSLog(@"%@", sample);
                    HKQuantity  *quantity = sample.quantity;
                    NSString *strDistance = [NSString stringWithFormat:@"%@",quantity];
                    fDistanceMore += [strDistance floatValue];
                    
                    if (strSourceMore.length == 0) {
                        strSourceMore = source.name;
                    }
                }
            }
            
            if([samples count] > 0)
            {
                HKQuantitySample *sampleFirst = [samples firstObject];
                HKQuantitySample *sampleLast = [samples lastObject];
                
                _beginTime = sampleFirst.startDate;
                _endTime = sampleLast.endDate;
            }
            
            if (strSourceMore.length > 0) {
                if ([strSource isEqualToString:@"健康App"]) {
                    strSourceMore = [NSString stringWithFormat:@"%@, %@", strSourceMore, strSource];
                }
            }
            else
            {
                strSourceMore = strSource;
            }
            
            NSLog(@"手机别名: %@, 距离：%f, 数据来源 %@", userPhoneName, fDistanceMore, strSourceMore);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (m_switchAuto.on == YES) {
                    [_tfDistance setText:[NSString stringWithFormat:@"%.2f", fDistanceMore / 1000.0]];
                    [self setSourceData:strSourceMore];
                }
            });
        }
    }];
}

-(void)updateDistance
{
    NSString *strDate = _tfDate.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy年MM月dd日 HH:mm"];
    NSDate *myDate0 = [formatter dateFromString:strDate];
    NSDate *myDate1 = [[NSDate alloc]initWithTimeInterval:_durationSec sinceDate:myDate0];
    
    _beginTime = myDate0;
    _endTime = myDate1;
    
    _nHeartRate = 0;
    
    [[JRHealthKitManager shareManager] fetchHeartRateFrom:myDate0 toDate:myDate1 completed:^(NSArray *samples, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }else {
            NSInteger nRate = 0;
            NSMutableArray *arraySource = [[NSMutableArray alloc]init];
            
            for (HKQuantitySample *sample in samples) {
                /*if(sample.metadata != nil)
                {
                    if ([sample.metadata objectForKey:@"HKWasUserEntered"] != nil && [[sample.metadata objectForKey:@"HKWasUserEntered"]intValue] == 1) {
                        continue;
                    }
                }*/
                
                NSLog(@"%@", sample);
                HKQuantity  *quantity = sample.quantity;
                NSString *strRate = [NSString stringWithFormat:@"%@",quantity];
                [arraySource addObject:strRate];
            }
            
            if(arraySource.count > 0)
            {
                for (NSString *strRate in arraySource) {
                    nRate += [strRate floatValue] * 60;
                }
                
                if (nRate > 0) {
                    nRate /= arraySource.count;
                }
                
                _nHeartRate = nRate;
                NSLog(@"HeartRate is %ld 次/分钟", _nHeartRate);
            }
        }
    }];
    
    [[JRHealthKitManager shareManager] fetchDistancesFrom:myDate0 toDate:myDate1 completed:^(NSArray *samples, NSError *error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
            });
        }else {
            float fDistance = 0.00;
            NSString *strSource = @"未知";
            NSMutableArray *arraySource = [[NSMutableArray alloc]init];
            
            for (HKQuantitySample *sample in samples) {
                if(sample.metadata != nil)
                {
                    if ([sample.metadata objectForKey:@"HKWasUserEntered"] != nil && [[sample.metadata objectForKey:@"HKWasUserEntered"]intValue] == 1) {
                        continue;
                    }
                }
                
                NSLog(@"%@", sample);
                HKQuantity  *quantity = sample.quantity;
                NSString *strDistance = [NSString stringWithFormat:@"%@",quantity];
                fDistance += [strDistance floatValue];
                
                HKSource *source = sample.source;
                [arraySource addObject:source.name];
            }
            
            if([samples count] > 0)
            {
                HKQuantitySample *sampleFirst = [samples firstObject];
                HKQuantitySample *sampleLast = [samples lastObject];
                
                _beginTime = sampleFirst.startDate;
                _endTime = sampleLast.endDate;
            }
            
            NSString* userPhoneName = [[UIDevice currentDevice] name];
            
            if ([arraySource count] == 0) {
                strSource = @"未知";
            }
            else if([arraySource count] == 1)
            {
                NSString* userPhoneName = [[UIDevice currentDevice] name];
                
                strSource = arraySource[0];
                
                if ([strSource isEqualToString:userPhoneName]) {
                    strSource = @"健康App";
                }
            }
            else
            {
                NSString *strTemp0 = arraySource[0];
                NSString *strTemp1 = arraySource[0];
                
                for (NSString *strSource in arraySource) {
                    if(![strSource isEqualToString:strTemp0])
                    {
                        strTemp1 = strSource;
                        break;
                    }
                }
                
                if ([strTemp0 isEqualToString:userPhoneName]) {
                    strTemp0 = @"健康App";
                }
                
                if([strTemp1 isEqualToString:userPhoneName])
                {
                    strTemp1 = @"健康App";
                }
                
                if ([strTemp0 isEqualToString:strTemp1]) {
                    strSource = strTemp0;
                }
                else
                {
                    strSource = [NSString stringWithFormat:@"%@, %@", strTemp0, strTemp1];
                }
            }
            
            BOOL bLoadMore = NO;
            
            if (_durationSec <= 60 * 60) {
                BOOL bContainOther = NO;
                
                for (NSString *strSource in arraySource) {
                    if(![strSource isEqualToString:userPhoneName])
                    {
                        bContainOther = YES;
                        break;
                    }
                }
                
                if (!bContainOther) {
                    bLoadMore = YES;
                }
            }
            
            if (bLoadMore) {
                NSLog(@"Load Other Device Run Data, if Current Duration is not contained other data!");
                [self updateDistanceForMore:fDistance Source:strSource];
            }
            else
            {
                NSLog(@"手机别名: %@, 距离：%f, 数据来源 %@", userPhoneName, fDistance, strSource);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (m_switchAuto.on == YES) {
                        [_tfDistance setText:[NSString stringWithFormat:@"%.2f", fDistance / 1000.0]];
                        [self setSourceData:strSource];
                    }
                });
            }
        }
    }];
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
    
    UITapGestureRecognizer* tapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
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
    
    if (viewMain == m_viewDuration) {
        [dialView setDialRangeFrom:10 to:240];
        dialView.currentValue = 60;
        [self setDialViewValue:60 ViewPick:viewPick UnitFormat:@" 分钟"];
    }
    else if(viewMain == m_viewWeidget) {
        [dialView setDialRangeFrom:30 to:150];
        dialView.currentValue = 65;
        [self setDialViewValue:65 ViewPick:viewPick UnitFormat:@" kg"];
    }
}

-(void)createDatePick:(UIView*)viewMain PickView:(UIView*)viewPick DatePick:(UIDatePicker*)datePicker Title:(NSString*)strTitle DoneAction:(void(^)(void))doneBlock CancelAction:(void(^)(void))cancelBlock TitleAction:(void(^)(void))titleBlock
{
    viewMain.frame = [UIScreen mainScreen].bounds;
    viewMain.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    UIView *viewTapPickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewMain.frame.size.width, CGRectGetHeight(viewMain.frame) - 260)];
    viewTapPickView.backgroundColor = [UIColor clearColor];
    [viewMain addSubview:viewTapPickView];
    [viewMain bringSubviewToFront:viewTapPickView];
    
    UITapGestureRecognizer* tapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
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
    
    [viewPick addSubview:doneButton];
    [viewPick addSubview:cancelButton];
    [viewPick addSubview:titleButton];
    
    datePicker.frame = CGRectMake(0, 44, [UIScreen screenWidth], 216);
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.maximumDate = [NSDate date];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60 * 7;
    datePicker.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    datePicker.backgroundColor = [UIColor clearColor];
    [viewPick addSubview:datePicker];
}

-(void)createBeginDateView
{
    m_viewBeginDate = [[UIView alloc]init];
    m_pickerView0 = [[UIView alloc] init];
    m_pickerDate = [[UIDatePicker alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    
    [self createDatePick:m_viewBeginDate PickView:m_pickerView0 DatePick:m_pickerDate Title:@"设置开始时间"
              DoneAction:^void(){
                  __typeof(self) strongSelf = weakSelf;
                  NSInteger unitflag =   kCFCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
                  NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar];
                  NSDateComponents* dateComponent = [chineseClendar components:unitflag fromDate:strongSelf->m_pickerDate.date];
                  strongSelf->_tfDate.text = [NSString stringWithFormat:@"%04ld年%02ld月%02ld日 %02ld:%02ld", dateComponent.year, dateComponent.month, dateComponent.day, dateComponent.hour, dateComponent.minute];
                  [strongSelf->m_clock setHour:dateComponent.hour minute:dateComponent.minute animated:YES];
                  
                  if(strongSelf->_bHealthAvail && strongSelf->m_switchAuto.on)
                  {
                      [strongSelf updateDistance];
                  }
                  
                  [strongSelf hidePickView:strongSelf->m_viewBeginDate PickView:strongSelf->m_pickerView0];
              } CancelAction:^void(){
                  __typeof(self) strongSelf = weakSelf;
                  [strongSelf hidePickView:strongSelf->m_viewBeginDate PickView:strongSelf->m_pickerView0];
              } TitleAction:nil];
}

-(void)createWeidgetView
{
    m_viewWeidget = [[UIView alloc]init];
    m_pickerView1 = [[UIView alloc]init];
    
    __weak __typeof(self) weakSelf = self;
    
    [self createCustomSelectPick:m_viewWeidget PickView:m_pickerView1 Title:@"设置体重"
                      DoneAction:^void(){
                          __typeof(self) strongSelf = weakSelf;
                          TRSDialScrollView *dialView = (TRSDialScrollView*)[strongSelf->m_viewWeidget viewWithTag:11000];
                          strongSelf->_tfWeidget.text = [NSString stringWithFormat:@"%ld", dialView.currentValue];
                          [strongSelf hidePickView:strongSelf->m_viewWeidget PickView:strongSelf->m_pickerView1];
                      } CancelAction:^void(){
                          __typeof(self) strongSelf = weakSelf;
                          [strongSelf hidePickView:strongSelf->m_viewWeidget PickView:strongSelf->m_pickerView1];
                      } TitleAction:nil];
}


-(void)createDurationView
{
    m_viewDuration = [[UIView alloc]init];
    m_pickerView2 = [[UIView alloc]init];
    
    __weak __typeof(self) weakSelf = self;
    
    [self createCustomSelectPick:m_viewDuration PickView:m_pickerView2 Title:@"设置持续时间"
                      DoneAction:^void(){
                          __typeof(self) strongSelf = weakSelf;
                          TRSDialScrollView *dialView = (TRSDialScrollView*)[strongSelf->m_viewDuration viewWithTag:11000];
                          strongSelf->_tfDuration.text = [NSString stringWithFormat:@"%ld", dialView.currentValue];
                          strongSelf->_durationSec = dialView.currentValue * 60;
                          
                          if(strongSelf->_bHealthAvail && strongSelf->m_switchAuto.on)
                          {
                              [strongSelf updateDistance];
                          }
                          
                          [strongSelf hidePickView:strongSelf->m_viewDuration PickView:strongSelf->m_pickerView2];
                      } CancelAction:^void(){
                          __typeof(self) strongSelf = weakSelf;
                          [strongSelf hidePickView:strongSelf->m_viewDuration PickView:strongSelf->m_pickerView2];
                      } TitleAction:nil];
}

#pragma mark - PivkView Logic
- (void)popPickView:(UIView*)viewMain PickView:(UIView*)viewPick
{
    if (viewMain == m_viewBeginDate) {
        NSString *strDate = _tfDate.text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy年MM月dd日 HH:mm"];
        NSDate *dateTime = [formatter dateFromString:strDate];
        
        [m_pickerDate setDate:dateTime];
    }
    else if(viewMain == m_viewWeidget)
    {
        TRSDialScrollView *dialView = (TRSDialScrollView*)[m_viewWeidget viewWithTag:11000];
        NSInteger nCurValue = [_tfWeidget.text integerValue];
        [dialView setCurrentValue:nCurValue > 0 ? nCurValue : 65];
        [self setDialViewValue:nCurValue > 0 ? nCurValue : 65 ViewPick:m_viewWeidget UnitFormat:@" kg"];
    }
    else if(viewMain == m_viewDuration)
    {
        TRSDialScrollView *dialView = (TRSDialScrollView*)[m_viewDuration viewWithTag:11000];
        NSInteger nCurValue = [_tfDuration.text integerValue];
        [dialView setCurrentValue:nCurValue > 0 ? nCurValue : 60];
        [self setDialViewValue:nCurValue > 0 ? nCurValue : 60 ViewPick:m_viewDuration UnitFormat:@" 分钟"];
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

-(void)actionTap:(UITapGestureRecognizer*)gr {
    [self hidePickView:m_viewBeginDate PickView:m_pickerView0];
    [self hidePickView:m_viewWeidget PickView:m_pickerView1];
    [self hidePickView:m_viewDuration PickView:m_pickerView2];
}

-(void)animationFinished{
    [m_viewBeginDate removeFromSuperview];
    [m_viewWeidget removeFromSuperview];
    [m_viewDuration removeFromSuperview];
}

#pragma mark - Custom Pick View Logic

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

#pragma mark - ScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    TRSDialScrollView *dialView = (TRSDialScrollView*)[m_viewDuration viewWithTag:11000];
    TRSDialScrollView *dialView1 = (TRSDialScrollView*)[m_viewWeidget viewWithTag:11000];
    
    if(scrollView == dialView.scrollView)
    {
        [self setDialViewValue:dialView.currentValue ViewPick:m_viewDuration UnitFormat:@" 分钟"];
    }
    else if(scrollView == dialView1.scrollView)
    {
        [self setDialViewValue:dialView1.currentValue ViewPick:m_viewWeidget UnitFormat:@" kg"];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    TRSDialScrollView *dialView = (TRSDialScrollView*)[m_viewDuration viewWithTag:11000];
    TRSDialScrollView *dialView1 = (TRSDialScrollView*)[m_viewWeidget viewWithTag:11000];
    
    if(scrollView == dialView.scrollView)
    {
        [self setDialViewValue:dialView.currentValue ViewPick:m_viewDuration UnitFormat:@" 分钟"];
    }
    else if(scrollView == dialView1.scrollView)
    {
        [self setDialViewValue:dialView1.currentValue ViewPick:m_viewWeidget UnitFormat:@" kg"];
    }
}

#pragma mark - Text Logic

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    if (string.length == 0) {
        return YES;
    }
    
    //第一个参数，被替换字符串的range，第二个参数，即将键入或者粘贴的string，返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //正则表达式
    NSString *regex = @"^\\-?([1-9]\\d{0,2}|0)(\\.\\d{0,2})?$";
    return [self isValid:checkStr withRegex:regex];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    BOOL bAllowWord = [[CommonUtility sharedInstance]isAllowChar:textField.text AlowedChars:ALLOW_NUMS];
    
    if(!bAllowWord)
    {
        textField.text = _strOldData;
    }
    else
    {
        _strOldData = textField.text;
    }
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

#pragma mark - Refresh Speed and Pake Gui

-(void)refReshGui
{
    UILabel *lbSpeedValue = (UILabel*)[m_viewSpeed viewWithTag:10000];
    UILabel *lbPaceValue = (UILabel*)[m_viewPace viewWithTag:10000];

    if ([_tfDistance.text floatValue] > 0 && [_tfDuration.text integerValue] > 0 && [_tfWeidget.text integerValue] > 0) {
        lbSpeedValue.text = [NSString stringWithFormat:@"%0.2f km/h", [_tfDistance.text floatValue] * 1.00 / (_durationSec * 1.00 / 3600)];
        lbPaceValue.text =  [NSString stringWithFormat:@"%.0f 卡", [_tfWeidget.text integerValue] * [_tfDistance.text floatValue] * 1000 / 800.0];
        m_viewSpeed.hidden = NO;
        m_viewPace.hidden = NO;
    }
    else
    {
        m_viewSpeed.hidden = YES;
        m_viewPace.hidden = YES;
    }
}

-(void)startTimeRefresh
{
    [_timeRefresh invalidate];
    _timeRefresh = nil;
    _timeRefresh = [NSTimer scheduledTimerWithTimeInterval: 0.5
                                                    target: self
                                                  selector: @selector(refReshGui)
                                                  userInfo: nil
                                                   repeats: YES];
}

#pragma mark - MWPhotoBrowserDelegate

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
        
        for (UIView *view in _imgBackFrameArray) {
            [view removeFromSuperview];
        }
        
        [_imgUrlArray removeAllObjects];
        [_imgViewArray removeAllObjects];
        [_imgBtnArray removeAllObjects];
        [_imgBackFrameArray removeAllObjects];
        
        _bUpdatePhotos = NO;
        _btnAddPng.hidden = NO;
        
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
        rectEnd = _btnAddPng.frame;
    }
    else
    {
        UIImageView *imageView = [_imgViewArray lastObject];
        rectEnd = imageView.frame;
    }
    
    for (int i = 0; i < MIN([arrayUrls count], MAX_PUBLISH_PNG_COUNT); i++) {
        /*if (([_imgViewArray count] - 1) % 4 == 3 && [_imgViewArray count] > 0) {
            rectEnd.origin = CGPointMake(10, CGRectGetMaxY(rectEnd) + 10);
        }
        else
        {
            rectEnd.origin = CGPointMake([_imgViewArray count] == 0 ? 10 + 77 * i : (CGRectGetMaxX(rectEnd) + 17), CGRectGetMinY(rectEnd));
        }*/
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:rectEnd];
        [imageView sd_setImageWithURL:[NSURL URLWithString:arrayUrls[i]]
                     placeholderImage:[UIImage imageNamed:@"image-placeholder"]];
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        /*UIView * backframe = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame) - 1, CGRectGetMinY(imageView.frame) - 1, CGRectGetWidth(imageView.frame) + 2, CGRectGetHeight(imageView.frame) + 2)];
        backframe.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
        backframe.layer.borderWidth = 1.0;
        backframe.layer.borderColor = [[UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1] CGColor];*/
        
        CSButton *btnImage = [CSButton buttonWithType:UIButtonTypeCustom];
        btnImage.frame = imageView.frame;
        btnImage.backgroundColor = [UIColor clearColor];
        [m_scrollView addSubview:btnImage];
        
        __weak __typeof(self) weakSelf = self;
        
        btnImage.actionBlock = ^void()
        {
            __typeof(self) strongSelf = weakSelf;
            NSUInteger nIndex = [strongSelf->_imgViewArray indexOfObject:imageView];
            [strongSelf onClickImageViewByIndex:nIndex];
        };
        
        [m_scrollView addSubview:imageView];
        [m_scrollView addSubview:btnImage];
        [m_scrollView bringSubviewToFront:imageView];
        [m_scrollView bringSubviewToFront:btnImage];
        
        [_imgBtnArray addObject:btnImage];
        [_imgViewArray addObject:imageView];
        [_imgUrlArray addObject:arrayUrls[i]];
    }
    
    _btnAddPng.hidden = ([_imgUrlArray count] >= MAX_PUBLISH_PNG_COUNT);
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
        }
    }];
    
    _imageEditViewController.sourceImage = image;
    [_imageEditViewController reset:NO];
    
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
    
    if ([arrImages count] > 0) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
