//
//  RecordViewController.m
//  SportForum
//
//  Created by liyuan on 14-9-1.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "RecordViewController.h"
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

#define MAX_PUBLISH_PNG_COUNT 4

@interface RecordViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ZYQAssetPickerControllerDelegate, MWPhotoBrowserDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@end

@implementation RecordViewController
{
    UIScrollView *m_scrollView;
    UITextField *_tfDate;
    UILabel *_lbTimeDateBegin;
    UILabel *_lbTimeDurationData;
    
    UITextField *_tfDistance;
    UILabel *_lbDistance;
    UILabel *_lbSpeed;
    UILabel *_lbPace;
    
    UIView *m_viewPickBg;
    UIView *_pickerFrame;
    UIDatePicker *_pickerView;
    
    UIView *m_viewWeightBg;
    UIView *_weightFrame;
    UILabel *_lbCurWeight;
    TRSDialScrollView *_weightDialView;
    
    UIView *_viewBody;
    CSButton *_btnAddPng;
    CSButton *_btnPublish;
    ZJSwitch *m_switchAuto;
    UILabel *_labelNote;
    UILabel *_lbSource;
    UILabel *_lbSourceData;
    UILabel *_lbAutoTips;
    UILabel *_labelPng;
    
    ALDClock *m_clock;
    TRSDialScrollView * _dialView;
    ImageEditViewController* _imageEditViewController;
    CustomMenuViewController* _customMenuViewController;
    
    NSString *_strOldData;
    
    NSMutableArray * _imgUrlArray;
    NSMutableArray * _imgViewArray;
    NSMutableArray * _imgBtnArray;
    NSMutableArray * _imgBackFrameArray;
    NSMutableArray *_photos;
    
    BOOL _bUpdatePhotos;
    BOOL _bHealthAvail;
    BOOL _bUpdateTime;
    id m_processWindow;
    NSInteger _durationSec;
    
    NSTimer *_timeRefresh;
    NSTimer *m_timerReward;
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
    [self generateCommonViewInParent:self.view Title:@"记录运动" IsNeedBackBtn:YES];
    
    _viewBody = [self.view viewWithTag:GENERATE_VIEW_BODY];
    _viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    CGRect rect = _viewBody.frame;
    rect.size = CGSizeMake(self.view.frame.size.width - 10, CGRectGetHeight(self.view.frame) - 70);
    _viewBody.frame = rect;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    _viewBody.layer.mask = maskLayer;
    
    m_scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_viewBody.frame), CGRectGetHeight(_viewBody.frame))];
    m_scrollView.backgroundColor = [UIColor clearColor];
    m_scrollView.scrollEnabled = NO;
    [_viewBody addSubview:m_scrollView];
    
    UILabel *labelDate = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 50, 20)];
    labelDate.backgroundColor = [UIColor clearColor];
    labelDate.textColor = [UIColor blackColor];
    labelDate.text = @"日期：";
    labelDate.textAlignment = NSTextAlignmentLeft;
    labelDate.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:labelDate];
    
    rect = CGRectMake(75, 10, 5, 30);
    UILabel * lbSpacer = [[UILabel alloc] initWithFrame:rect];
    lbSpacer.backgroundColor = [UIColor clearColor];
    lbSpacer.textColor = [UIColor blackColor];
    lbSpacer.textAlignment = NSTextAlignmentCenter;
    [m_scrollView addSubview:lbSpacer];
    
    _tfDate = [[UITextField alloc]initWithFrame:CGRectMake(55, 10, 245, 30)];
    _tfDate.backgroundColor = [UIColor whiteColor];
    _tfDate.font = [UIFont systemFontOfSize:14];
    _tfDate.textAlignment = NSTextAlignmentLeft; //水平左对齐
    _tfDate.text = @"";
    _tfDate.multipleTouchEnabled = YES;
    _tfDate.enabled = NO;
    _tfDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tfDate.layer.borderWidth = 1.0;
    _tfDate.layer.cornerRadius = 5.0;
    _tfDate.leftView = lbSpacer;
    _tfDate.leftViewMode = UITextFieldViewModeAlways;
    [m_scrollView addSubview:_tfDate];
    
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy年MM月dd日"];
    NSDate *curDate = [NSDate date];
    _tfDate.text = [formater stringFromDate:curDate];
    
    CSButton *btnDate = [CSButton buttonWithType:UIButtonTypeCustom];
    btnDate.frame = _tfDate.frame;
    btnDate.backgroundColor = [UIColor clearColor];
    [m_scrollView addSubview:btnDate];
    
    __weak __typeof(self) weakSelf = self;
    
    btnDate.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->_tfDistance endEditing:YES];
        [strongSelf popDatePickView];
        //[self popWeidgetView];
    };
    
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
    
    //Create Time Snap
    CGRect clockFrame = CGRectMake(10, 50, 190, 185);
    /*UserInfo *userInfo = [[ApplicationContext sharedInstance]accountInfo];
    
    if (userInfo.profile_image.length > 0) {
        UIImageView *profileImage = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (CGRectGetWidth(clockFrame) - 35) / 2, 50 + CGRectGetHeight(clockFrame) / 2 + 15, 35, 35)];
        [profileImage sd_setImageWithURL:[NSURL URLWithString:userInfo.profile_image] placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:10];
        [m_scrollView addSubview:profileImage];
    }*/
    
    m_clock = [[ALDClock alloc] initWithFrame:clockFrame];
    [m_scrollView addSubview:m_clock];
    [self applyClockCustomisations];
    // Set the initial time
    [m_clock setHour:nHour minute:nMinute animated:NO];
    
    _lbTimeDateBegin = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(m_clock.frame) + 5, 190, 20)];
    _lbTimeDateBegin.backgroundColor = [UIColor clearColor];
    _lbTimeDateBegin.textColor = [UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0];
    _lbTimeDateBegin.textAlignment = NSTextAlignmentCenter;
    _lbTimeDateBegin.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:_lbTimeDateBegin];
    
    if (nHour >= 0 && nHour <= 12) {
        _lbTimeDateBegin.text = [NSString stringWithFormat:@"%02ld:%02ld AM", nHour, nMinute];
    }
    else
    {
        _lbTimeDateBegin.text = [NSString stringWithFormat:@"%02ld:%02ld PM", nHour - 12, nMinute];
    }
    
    UILabel *lbTimeDuration = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(m_scrollView.frame) - 80, 50, 70, 20)];
    lbTimeDuration.backgroundColor = [UIColor clearColor];
    lbTimeDuration.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    lbTimeDuration.text = @"持续时间";
    lbTimeDuration.textAlignment = NSTextAlignmentCenter;
    lbTimeDuration.font = [UIFont systemFontOfSize:14];
    [m_scrollView addSubview:lbTimeDuration];
    
    UIEdgeInsets insetsBox = UIEdgeInsetsMake(12, 12, 12,12);
    UIImage * imgBoxVertical = [UIImage imageNamed:@"select-box-transp"];
    imgBoxVertical = [imgBoxVertical resizableImageWithCapInsets:insetsBox];
    UIImageView * imgBK = [[UIImageView alloc] init];
    _dialView = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth(m_scrollView.frame) - 80, 70, 70, 165)];
    imgBK.frame = CGRectInset(_dialView.frame, -8, 0);
    imgBK.image = imgBoxVertical;
    imgBK.userInteractionEnabled = NO;
    [m_scrollView addSubview:_dialView];
    [m_scrollView addSubview:imgBK];
    
    [_dialView setDirection:NO];
    _dialView.dataFormat = DATA_FORMAT_NUM;
    [_dialView setMinorTicksPerMajorTick:10];
    [_dialView setMinorTickDistance:8];
    
    [_dialView setBackgroundColor:[UIColor whiteColor]];
    
    [_dialView setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
    [_dialView setLabelStrokeWidth:0.1f];
    [_dialView setLabelFillColor:[UIColor darkGrayColor]];
    
    [_dialView setLabelFont:[UIFont fontWithName:@"Avenir" size:16]];
    
    [_dialView setMinorTickColor:[UIColor lightGrayColor]];
    [_dialView setMinorTickLength:15.0];
    [_dialView setMinorTickWidth:1.0];
    
    [_dialView setMajorTickColor:[UIColor darkGrayColor]];
    [_dialView setMajorTickLength:30.0];
    [_dialView setMajorTickWidth:1.5];
    
    [_dialView setDialRangeFrom:0 to:240];
    _dialView.delegate = self;
    _dialView.currentValue = nDuration;
    
    _lbTimeDurationData = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetWidth(m_scrollView.frame) - 80, CGRectGetMaxY(m_clock.frame) + 5, 70, 20)];
    _lbTimeDurationData.backgroundColor = [UIColor clearColor];
    _lbTimeDurationData.textColor = [UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0];
    _lbTimeDurationData.text = [NSString stringWithFormat:@"%ld分钟", nDuration];
    _lbTimeDurationData.textAlignment = NSTextAlignmentCenter;
    _lbTimeDurationData.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:_lbTimeDurationData];
    
    UILabel *lbTimeTips = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_lbTimeDurationData.frame), CGRectGetWidth(m_scrollView.frame) - 20, 30)];
    lbTimeTips.backgroundColor = [UIColor clearColor];
    lbTimeTips.textColor = [UIColor lightGrayColor];
    lbTimeTips.textAlignment = NSTextAlignmentLeft;
    lbTimeTips.font = [UIFont systemFontOfSize:13];
    lbTimeTips.text = @"拨动时钟调整开始时间，拨动滑轮调整持续时间";
    lbTimeTips.numberOfLines = 0;
    [m_scrollView addSubview:lbTimeTips];
    
    _lbDistance = [[UILabel alloc]initWithFrame:CGRectMake(10, 290, 90, 20)];
    _lbDistance.backgroundColor = [UIColor clearColor];
    _lbDistance.textColor = [UIColor blackColor];
    _lbDistance.text = @"距离(公里)：";
    _lbDistance.textAlignment = NSTextAlignmentLeft;
    _lbDistance.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:_lbDistance];
    
    rect = CGRectMake(120, 285, 5, 30);
    UILabel * lbSpacer1 = [[UILabel alloc] initWithFrame:rect];
    lbSpacer1.backgroundColor = [UIColor clearColor];
    lbSpacer1.textColor = [UIColor blackColor];
    lbSpacer1.textAlignment = NSTextAlignmentCenter;
    [m_scrollView addSubview:lbSpacer1];
    
    _tfDistance = [[UITextField alloc]initWithFrame:CGRectMake(100, 285, 90, 30)];
    _tfDistance.font = [UIFont boldSystemFontOfSize:15];
    _tfDistance.textAlignment = NSTextAlignmentLeft; //水平左对齐
    _tfDistance.text = @"";
    _tfDistance.textColor = [UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0];
    _tfDistance.backgroundColor = [UIColor clearColor];
    _tfDistance.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _tfDistance.multipleTouchEnabled = YES;
    _tfDistance.enabled = NO;
    _tfDistance.delegate = self;
    _tfDistance.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _tfDistance.layer.borderWidth = 0;
    _tfDistance.layer.cornerRadius = 5.0;
    _tfDistance.leftView = lbSpacer1;
    _tfDistance.leftViewMode = UITextFieldViewModeAlways;
    [m_scrollView addSubview:_tfDistance];
    
    m_switchAuto = [[ZJSwitch alloc] initWithFrame:CGRectMake(210, 285, 90, 27)];
    m_switchAuto.onTintColor = [UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0];
    m_switchAuto.tintColor = [UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0];
    m_switchAuto.thumbTintColor = [UIColor blackColor];
    m_switchAuto.style = ZJSwitchStyleBorder;
    m_switchAuto.onText = @"自动导入";
    m_switchAuto.offText = @"手工填写";
    m_switchAuto.textFont = [UIFont systemFontOfSize:13];
    [m_switchAuto addTarget:self action:@selector(autoModeChanged:) forControlEvents:UIControlEventValueChanged];
    m_switchAuto.on = YES;
    [m_scrollView addSubview:m_switchAuto];

    UILabel *labelSpeed = [[UILabel alloc]initWithFrame:CGRectMake(10, 320, 50, 20)];
    labelSpeed.backgroundColor = [UIColor clearColor];
    labelSpeed.textColor = [UIColor blackColor];
    labelSpeed.text = @"速度：";
    labelSpeed.textAlignment = NSTextAlignmentLeft;
    labelSpeed.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:labelSpeed];
    
    _lbSpeed = [[UILabel alloc]initWithFrame:CGRectMake(55, 320, 95, 20)];
    _lbSpeed.backgroundColor = [UIColor clearColor];
    _lbSpeed.textColor = [UIColor lightGrayColor];
    _lbSpeed.text = @"自动换算";
    _lbSpeed.textAlignment = NSTextAlignmentLeft;
    _lbSpeed.font = [UIFont systemFontOfSize:13];
    [m_scrollView addSubview:_lbSpeed];
    
    UILabel *labelPace = [[UILabel alloc]initWithFrame:CGRectMake(150, 320, 60, 20)];
    labelPace.backgroundColor = [UIColor clearColor];
    labelPace.textColor = [UIColor blackColor];
    labelPace.text = @"卡路里：";
    labelPace.textAlignment = NSTextAlignmentLeft;
    labelPace.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:labelPace];
    
    _lbPace = [[UILabel alloc]initWithFrame:CGRectMake(210, 320, 100, 20)];
    _lbPace.backgroundColor = [UIColor clearColor];
    _lbPace.textColor = [UIColor lightGrayColor];
    _lbPace.text = @"自动换算";
    _lbPace.textAlignment = NSTextAlignmentLeft;
    _lbPace.font = [UIFont systemFontOfSize:13];
    [m_scrollView addSubview:_lbPace];
    
    _lbSource = [[UILabel alloc]initWithFrame:CGRectMake(10, 345, 215, 20)];
    _lbSource.backgroundColor = [UIColor clearColor];
    _lbSource.textColor = [UIColor blackColor];
    _lbSource.text = @"从本机健康App导入，数据来源：";
    _lbSource.textAlignment = NSTextAlignmentLeft;
    _lbSource.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:_lbSource];
    
    _lbSourceData = [[UILabel alloc]initWithFrame:CGRectMake(225, 345, 85, 20)];
    _lbSourceData.backgroundColor = [UIColor clearColor];
    _lbSourceData.textColor = [UIColor colorWithRed:239.0 / 255.0 green:162.0 / 255.0 blue:1.0 / 255.0 alpha:1.0];
    _lbSourceData.text = @"";
    _lbSourceData.textAlignment = NSTextAlignmentLeft;
    _lbSourceData.font = [UIFont boldSystemFontOfSize:14];
    [m_scrollView addSubview:_lbSourceData];
    
    _lbAutoTips = [[UILabel alloc]initWithFrame:CGRectMake(10, 365, 290, 60)];
    _lbAutoTips.backgroundColor = [UIColor clearColor];
    _lbAutoTips.textColor = [UIColor lightGrayColor];
    _lbAutoTips.text = @"如果读取的距离为空，请确认您已授权健康App读取权限，可以在【健康App>数据来源>悦动力】应用程序中授权。";
    _lbAutoTips.textAlignment = NSTextAlignmentLeft;
    _lbAutoTips.font = [UIFont systemFontOfSize:13];
    _lbAutoTips.numberOfLines = 0;
    [m_scrollView addSubview:_lbAutoTips];
    
    _labelPng = [[UILabel alloc]initWithFrame:CGRectMake(10, 345, 290, 35)];
    _labelPng.backgroundColor = [UIColor clearColor];
    _labelPng.textColor = [UIColor blackColor];
    _labelPng.text = @"有图有真相：(点击加号添加GPS运动轨迹图，或运动器材的数值记录)";
    _labelPng.textAlignment = NSTextAlignmentLeft;
    _labelPng.numberOfLines = 0;
    _labelPng.font = [UIFont boldSystemFontOfSize:14];
    _labelPng.hidden = YES;
    [m_scrollView addSubview:_labelPng];
    
    _btnAddPng = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnAddPng.frame = CGRectMake(10, 380, 60, 60);
    [_btnAddPng setImage:[UIImage imageNamed:@"add-images"] forState:UIControlStateNormal];
    _btnAddPng.hidden = YES;
    [m_scrollView addSubview:_btnAddPng];
    
    _btnAddPng.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
        [strongSelf->_tfDistance endEditing:YES];
        [strongSelf showPicSelect];
    };

    _labelNote = [[UILabel alloc]initWithFrame:CGRectMake(10, 255, 290, 40)];
    _labelNote.backgroundColor = [UIColor clearColor];
    _labelNote.textColor = [UIColor lightGrayColor];
    _labelNote.text = @"可以添加GPS运动轨迹图，或运动器材的数值记录，点击加号进行图片添加。";
    _labelNote.textAlignment = NSTextAlignmentLeft;
    _labelNote.font = [UIFont systemFontOfSize:12];
    _labelNote.numberOfLines = 0;
    //[_viewBody addSubview:_labelNote];
    
    _btnPublish = [CSButton buttonWithType:UIButtonTypeCustom];
    _btnPublish.frame = CGRectMake((CGRectGetWidth(_viewBody.frame) - 123) / 2, CGRectGetMaxY(_btnAddPng.frame) + 10, 123, 38);
    [_btnPublish setTitle:@"完成" forState:UIControlStateNormal];
    [_btnPublish setBackgroundImage:[UIImage imageNamed:@"btn-3-yellow"] forState:UIControlStateNormal];
    [_btnPublish setBackgroundImage:[UIImage imageNamed:@"btn-3-grey"] forState:UIControlStateDisabled];
    _btnPublish.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_btnPublish setTitleColor:[UIColor colorWithRed:184.0 / 255.0 green:126.0 / 255.0 blue:0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [_btnPublish setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [_btnPublish setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    _btnPublish.enabled = NO;
    [m_scrollView addSubview:_btnPublish];
    
    _btnPublish.actionBlock = ^void()
    {
        __typeof(self) strongSelf = weakSelf;
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
        
        [strongSelf actionPublish];
    };
    
    m_scrollView.contentSize = CGSizeMake(m_scrollView.contentSize.width, CGRectGetMaxY(_btnPublish.frame) + 15);
    
    [self createPickView];
    [self createWidgetView];
    _durationSec = nDuration * 60;
}

- (void)applyClockCustomisations
{
    // Change the background color of the clock (note that this is the color
    // of the clock face)
    m_clock.backgroundColor = [UIColor clearColor];//[UIColor colorWithWhite:0.97 alpha:1.0];
    
    // Add a title and subtitle to the clock face
    m_clock.title = @"开始时间";
    //self.clock.subtitle = @"By Andy Drizen";
    
    // When the time changes, call the the clockDidChangeTime: method.
    [m_clock addTarget:self action:@selector(clockDidChangeTime:) forControlEvents:UIControlEventValueChanged];
    
    // When the user begins/ends manually changing the time, call these methods.
    [m_clock addTarget:self action:@selector(clockDidBeginDragging:) forControlEvents:UIControlEventTouchDragEnter];
    [m_clock addTarget:self action:@selector(clockDidEndDragging:) forControlEvents:UIControlEventTouchDragExit];
    
    // Change the clock's border color and width
    m_clock.borderColor = [UIColor colorWithRed:0.22 green:0.78 blue:0.22 alpha:1.0];
    m_clock.borderWidth = 4.0f;
}

#pragma mark - Clock Callback Methods
- (void)clockDidChangeTime:(ALDClock *)clock
{
     //NSLog(@"The time is: %02ld:%02ld", clock.hour, clock.minute);
    _bUpdateTime = YES;
    
    if (clock.hour >= 0 && clock.hour <= 12) {
        _lbTimeDateBegin.text = [NSString stringWithFormat:@"%02ld:%02ld AM", clock.hour, clock.minute];
    }
    else
    {
        _lbTimeDateBegin.text = [NSString stringWithFormat:@"%02ld:%02ld PM", clock.hour - 12, clock.minute];
    }
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

-(void)actionTap:(UITapGestureRecognizer*)gr {
    [self hideDatePickView];
}

-(void)setWidgetViewValue:(NSInteger)nValue
{
    NSDictionary *attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:30], NSForegroundColorAttributeName:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0]};
    NSAttributedString * strPart1Value = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", nValue] attributes:attribs];
    attribs = @{NSFontAttributeName: [UIFont systemFontOfSize:14], NSForegroundColorAttributeName:[UIColor lightGrayColor]};
    NSAttributedString * strPart2Value = [[NSAttributedString alloc] initWithString:@" kg" attributes:attribs];
    
    NSMutableAttributedString * strWeidget = [[NSMutableAttributedString alloc] initWithAttributedString:strPart1Value];
    [strWeidget appendAttributedString:strPart2Value];
    _lbCurWeight.attributedText = strWeidget;
}

-(void)createWidgetView
{
    m_viewWeightBg = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    m_viewWeightBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    UIView *viewTapWeidget = [[UIView alloc]initWithFrame:CGRectMake(0, 0, m_viewWeightBg.frame.size.width, CGRectGetHeight(m_viewWeightBg.frame) - 260)];
    viewTapWeidget.backgroundColor = [UIColor clearColor];
    [m_viewWeightBg addSubview:viewTapWeidget];
    [m_viewWeightBg bringSubviewToFront:viewTapWeidget];
    
    UITapGestureRecognizer* tapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
    [viewTapWeidget addGestureRecognizer:tapRecogniser];
    
    CGRect rect = CGRectMake(0, m_viewWeightBg.frame.size.height - 260, m_viewWeightBg.frame.size.width, 260);
    
    _weightFrame = [[UIView alloc] initWithFrame:rect];
    _weightFrame.backgroundColor = [UIColor whiteColor];
    [m_viewWeightBg addSubview:_weightFrame];
    [m_viewWeightBg bringSubviewToFront:_weightFrame];
    
    CSButton *doneButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.frame = CGRectMake(250.0f, 10.0f, 60.0f, 30.0f);
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];
    
    __weak __typeof(self) weakSelf = self;
    
    doneButton.actionBlock = ^void(){
        __typeof(self) strongSelf = weakSelf;
         [strongSelf hideDatePickView];
    };
    
    CSButton *cancelButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.frame = CGRectMake(10.0f, 10.0f, 60.0f, 30.0f);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    cancelButton.actionBlock = ^void(){
        __typeof(self) strongSelf = weakSelf;
        [strongSelf hideDatePickView];
    };
    
    UILabel *lbTitle = [[UILabel alloc]init];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.text = @"设定体重";
    lbTitle.textColor = [UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0];
    lbTitle.font = [UIFont boldSystemFontOfSize:16];
    lbTitle.textAlignment = NSTextAlignmentCenter;
    lbTitle.frame = CGRectMake((CGRectGetWidth(_weightFrame.frame) - 80) / 2, 10.0f, 80.0f, 30.0f);
    
    UILabel *lbCurWeidget = [[UILabel alloc]init];
    lbCurWeidget.backgroundColor = [UIColor clearColor];
    lbCurWeidget.text = @"当前体重 60kg";
    lbCurWeidget.textColor = [UIColor lightGrayColor];
    lbCurWeidget.font = [UIFont systemFontOfSize:14];
    lbCurWeidget.textAlignment = NSTextAlignmentLeft;
    lbCurWeidget.frame = CGRectMake(10, CGRectGetMaxY(cancelButton.frame) + 20, 130, 20);
    
    UILabel *lbSetWeidget = [[UILabel alloc]init];
    lbSetWeidget.backgroundColor = [UIColor clearColor];
    lbSetWeidget.text = @"参考标准范围 55kg-65kg";
    lbSetWeidget.textColor = [UIColor lightGrayColor];
    lbSetWeidget.font = [UIFont systemFontOfSize:14];
    lbSetWeidget.textAlignment = NSTextAlignmentRight;
    lbSetWeidget.frame = CGRectMake(CGRectGetMaxX(lbCurWeidget.frame), CGRectGetMaxY(cancelButton.frame) + 20, 170, 20);
    
    _weightDialView = [[TRSDialScrollView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lbSetWeidget.frame) + 40, 300, 80)];
    
    _lbCurWeight = [[UILabel alloc]init];
    _lbCurWeight.backgroundColor = [UIColor clearColor];
    _lbCurWeight.textAlignment = NSTextAlignmentCenter;
    _lbCurWeight.frame = CGRectMake(10, CGRectGetMaxY(_weightDialView.frame), 300, 40);
    
    [_weightFrame addSubview:doneButton];
    [_weightFrame addSubview:cancelButton];
    [_weightFrame addSubview:lbTitle];
    [_weightFrame addSubview:lbCurWeidget];
    [_weightFrame addSubview:lbSetWeidget];
    [_weightFrame addSubview:_lbCurWeight];
    [_weightFrame addSubview:_weightDialView];
    
    [_weightDialView setDirection:YES];
    _weightDialView.dataFormat = DATA_FORMAT_NUM;
    [_weightDialView setMinorTicksPerMajorTick:10];
    [_weightDialView setMinorTickDistance:8];
    [_weightDialView setBackgroundColor:[UIColor whiteColor]];
    [_weightDialView setLabelStrokeColor:[UIColor colorWithRed:0.400 green:0.525 blue:0.643 alpha:1.000]];
    [_weightDialView setLabelStrokeWidth:0.1f];
    [_weightDialView setLabelFillColor:[UIColor darkGrayColor]];
    [_weightDialView setLabelFont:[UIFont systemFontOfSize:14]];
    [_weightDialView setMinorTickColor:[UIColor lightGrayColor]];
    [_weightDialView setMinorTickLength:15.0];
    [_weightDialView setMinorTickWidth:1.0];
    [_weightDialView setMajorTickColor:[UIColor darkGrayColor]];
    [_weightDialView setMajorTickLength:30.0];
    [_weightDialView setMajorTickWidth:1];
    [_weightDialView setCurValueViewLength:70];
    [_weightDialView setDialRangeFrom:30 to:150];
    _weightDialView.delegate = self;
    _weightDialView.currentValue = 65;
    [self setWidgetViewValue:65];
}

-(void)createPickView
{
    m_viewPickBg = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    m_viewPickBg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    UIView *viewTapPickView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, m_viewWeightBg.frame.size.width, CGRectGetHeight(m_viewPickBg.frame) - 260)];
    viewTapPickView.backgroundColor = [UIColor clearColor];
    [m_viewPickBg addSubview:viewTapPickView];
    [m_viewPickBg bringSubviewToFront:viewTapPickView];
    
    UITapGestureRecognizer* tapRecogniser = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionTap:)];
    [viewTapPickView addGestureRecognizer:tapRecogniser];
    
    CGRect rect = CGRectMake(0, m_viewPickBg.frame.size.height - 260, m_viewPickBg.frame.size.width, 260);
    
    _pickerFrame = [[UIView alloc] initWithFrame:rect];
    _pickerFrame.backgroundColor = [UIColor whiteColor];
    [m_viewPickBg addSubview:_pickerFrame];
    [m_viewPickBg bringSubviewToFront:_pickerFrame];
    
    CSButton *doneButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.frame = CGRectMake(250.0f, 10.0f, 60.0f, 30.0f);
    [doneButton setTitle:@"确定" forState:UIControlStateNormal];

    __weak __typeof(self) weakSelf = self;
    
    doneButton.actionBlock = ^void(){
        __typeof(self) strongSelf = weakSelf;
        NSInteger unitflag =   kCFCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        NSCalendar* chineseClendar = [ [ NSCalendar alloc ] initWithCalendarIdentifier:NSGregorianCalendar ];
        NSDateComponents* dateComponent = [chineseClendar components:unitflag fromDate:strongSelf->_pickerView.date];
        strongSelf->_tfDate.text = [NSString stringWithFormat:@"%04ld年%02ld月%02ld日 %02ld时%02ld分", dateComponent.year, dateComponent.month, dateComponent.day, dateComponent.hour, dateComponent.minute];
        
        if(strongSelf->_bHealthAvail && strongSelf->m_switchAuto.on)
        {
            [strongSelf updateDistance];
        }
        
        [strongSelf hideDatePickView];
    };
    
    CSButton *cancelButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.frame = CGRectMake(10.0f, 10.0f, 60.0f, 30.0f);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    cancelButton.actionBlock = ^void(){
        __typeof(self) strongSelf = weakSelf;
        [strongSelf hideDatePickView];
    };
    
    CSButton *todayButton = [CSButton buttonWithType:UIButtonTypeCustom];
    [todayButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    todayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [todayButton setTitleColor:[UIColor colorWithRed:41.0/255.0 green:173.0/255.0 blue:240.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    todayButton.backgroundColor = [UIColor clearColor];
    todayButton.frame = CGRectMake((CGRectGetWidth(_pickerFrame.frame) - 80) / 2, 10.0f, 80.0f, 30.0f);
    [todayButton setTitle:@"当前时间" forState:UIControlStateNormal];
    
    todayButton.actionBlock = ^void(){
        __typeof(self) strongSelf = weakSelf;
        strongSelf->_pickerView.date = [NSDate date];
    };
    
    [_pickerFrame addSubview:doneButton];
    [_pickerFrame addSubview:cancelButton];
    [_pickerFrame addSubview:todayButton];
    
    _pickerView = [[UIDatePicker alloc]init];
    _pickerView.frame = CGRectMake(0, 44, 320, 216);
    _pickerView.datePickerMode = UIDatePickerModeDateAndTime;
    _pickerView.maximumDate = [NSDate date];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60 * 7;
    _pickerView.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    _pickerView.backgroundColor = [UIColor whiteColor];
    [_pickerFrame addSubview:_pickerView];
}

- (void)popWeidgetView{
    [self.navigationController.view addSubview:m_viewWeightBg];
    [m_viewWeightBg bringSubviewToFront:_weightFrame];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    _weightFrame.frame = CGRectMake(0, m_viewWeightBg.frame.size.height - 260, 320, 260);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)popDatePickView{
    [self.navigationController.view addSubview:m_viewPickBg];
    [m_viewPickBg bringSubviewToFront:_pickerFrame];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    _pickerFrame.frame = CGRectMake(0, m_viewPickBg.frame.size.height - 260, 320, 260);
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

-(void)hideDatePickView{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];//动画时间长度，单位秒，浮点数
    _pickerFrame.frame = CGRectMake(0, m_viewPickBg.frame.size.height, 320, 260);
    _weightFrame.frame = CGRectMake(0, m_viewPickBg.frame.size.height, 320, 260);
    [UIView setAnimationDelegate:self];
    // 动画完毕后调用animationFinished
    [UIView setAnimationDidStopSelector:@selector(animationFinished)];
    [UIView commitAnimations];
}

-(void)animationFinished{
    NSLog(@"动画结束!");
    [m_viewPickBg removeFromSuperview];
    [m_viewWeightBg removeFromSuperview];
}

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
        _lbSourceData.hidden = NO;
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
        _lbSourceData.hidden = YES;
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
    
    _btnAddPng.frame = CGRectMake(10, 380, 60, 60);
}

-(void)checkHealthyAvailable
{
    if (IOS8_OR_LATER && (_bHealthAvail = [[JRHealthKitManager shareManager]isHealthKitAvailable], _bHealthAvail)) {
        BOOL bAutoMode = NO;
        NSMutableDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"RecordMode"];
        NSMutableDictionary * recorddDict = nil;
        
        if (dict == nil) {
            bAutoMode = YES;
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
        _tfDistance.frame = CGRectMake(100, 280, 200, 30);
        m_switchAuto.hidden = YES;
    }
}

-(void)updateDistanceForMore:(float) fDistance Source:(NSString*)strSource
{
    NSInteger unitflag =   kCFCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [myCal components:unitflag fromDate:_pickerView.date];
    
    NSDateComponents *comp0 = [[NSDateComponents alloc]init];
    comp0.year = comp.year;
    comp0.month = comp.month;
    comp0.day = comp.day;
    comp0.hour = m_clock.hour;
    comp0.minute = m_clock.minute;
    
    NSDate *myDate0 = [myCal dateFromComponents:comp0];
    NSDate *myDate1 = [[NSDate alloc]initWithTimeInterval:_durationSec + 60 * 60 sinceDate:myDate0];
    
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
            
            if (strSourceMore.length > 0) {
                if ([strSource isEqualToString:@"本机"]) {
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
                    [_lbSourceData setText:strSourceMore];
                }
            });
        }
    }];
}

-(void)updateDistance
{
    NSInteger unitflag =   kCFCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comp = [myCal components:unitflag fromDate:_pickerView.date];

    NSDateComponents *comp0 = [[NSDateComponents alloc]init];
    comp0.year = comp.year;
    comp0.month = comp.month;
    comp0.day = comp.day;
    comp0.hour = m_clock.hour;
    comp0.minute = m_clock.minute;
    
    NSDate *myDate0 = [myCal dateFromComponents:comp0];
    NSDate *myDate1 = [[NSDate alloc]initWithTimeInterval:_durationSec sinceDate:myDate0];
    
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
            
            NSString* userPhoneName = [[UIDevice currentDevice] name];
            
            if ([arraySource count] == 0) {
                strSource = @"未知";
            }
            else if([arraySource count] == 1)
            {
                NSString* userPhoneName = [[UIDevice currentDevice] name];
                
                strSource = arraySource[0];

                if ([strSource isEqualToString:userPhoneName]) {
                    strSource = @"本机";
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
                    strTemp0 = @"本机";
                }
                
                if([strTemp1 isEqualToString:userPhoneName])
                {
                    strTemp1 = @"本机";
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
                        [_lbSourceData setText:strSource];
                    }
                });
            }
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _imgUrlArray = [[NSMutableArray alloc]init];
    _imgViewArray = [[NSMutableArray alloc]init];
    _imgBtnArray = [[NSMutableArray alloc]init];
    _imgBackFrameArray = [[NSMutableArray alloc]init];
    _photos = [[NSMutableArray alloc]init];
    _bUpdatePhotos = NO;
    [self viewDidLoadGui];
    [self checkHealthyAvailable];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _dialView.scrollView)
    {
        _lbTimeDurationData.text = [NSString stringWithFormat:@"%ld分钟", _dialView.currentValue];
        
        _durationSec = _dialView.currentValue * 60;
        
        if(_bHealthAvail && m_switchAuto.on)
        {
            [self updateDistance];
        }
    }
    else if(scrollView == _weightDialView.scrollView)
    {
        [self setWidgetViewValue:_weightDialView.currentValue];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(scrollView == _dialView.scrollView)
    {
        _lbTimeDurationData.text = [NSString stringWithFormat:@"%ld分钟", _dialView.currentValue];
        
        _durationSec = _dialView.currentValue * 60;
        
        if(_bHealthAvail && m_switchAuto.on)
        {
            [self updateDistance];
        }
    }
    else if(scrollView == _weightDialView.scrollView)
    {
        [self setWidgetViewValue:_weightDialView.currentValue];
    }
}

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

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

-(void)refReshGui
{
    UserInfo * userInfo = [[ApplicationContext sharedInstance] accountInfo];
    
    if ([_tfDistance.text floatValue] > 0 && _durationSec > 0) {
        _lbSpeed.text = [NSString stringWithFormat:@"%0.1f 公里/小时", [_tfDistance.text floatValue] * 1.0 / (_durationSec * 1.0 /3600)];
        
        if (userInfo.weight == 0) {
            userInfo.weight = 65;
        }
        
        _lbPace.text =  [NSString stringWithFormat:@"%.0f大卡", userInfo.weight * [_tfDistance.text floatValue] * 1000 / 800.0];
    }
    else
    {
        _lbSpeed.text = @"自动换算";
        _lbPace.text = @"自动换算";
    }
    
    if ([_tfDistance.text floatValue] > 0 && _durationSec > 0 && (m_switchAuto.on || [_imgUrlArray count] > 0)) {
        _btnPublish.enabled = YES;
    }
    else
    {
        _btnPublish.enabled = NO;
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshImageViews];
    [self startTimeRefresh];
    _strOldData = @"";
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
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"RecordViewController dealloc called!");
}

-(void)showCommonProgress{
    m_processWindow = [AlertManager showCommonProgress];
}

-(void)hidenCommonProgress {
    [AlertManager dissmiss:m_processWindow];
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

-(void)actionPublish{
    BOOL blErr = NO;
    
    [_tfDistance endEditing:YES];
    
    if ([_tfDistance.text floatValue] == 0) {
        blErr = YES;
        [AlertManager showAlertText:@"跑步距离不能为0，没有记录意义" InView:self.view hiddenAfter:2];
    } else if([_tfDistance.text floatValue] > 50) {
        blErr = YES;
        [AlertManager showAlertText:@"跑步数超过50公里，数据不合理" InView:self.view hiddenAfter:2];
    }
    
    if ( blErr == NO) {
        if (_durationSec < 10 * 60) {
            blErr = YES;
            [AlertManager showAlertText:@"跑步时间太短，10分钟都没有，没有记录意义" InView:self.view hiddenAfter:2];
        }
        else if(_durationSec > 4 * 60 * 60)
        {
            blErr = YES;
            [AlertManager showAlertText:@"跑步时间超过4小时，数据不合理" InView:self.view hiddenAfter:2];
        }
    }
    
    //__typeof(self) __weak weakSelf = self;
    
    if (blErr == NO) {
        NSInteger unitflag =   kCFCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay;
        NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents* comp = [myCal components:unitflag fromDate:_pickerView.date];
        
        NSDateComponents *comp0 = [[NSDateComponents alloc]init];
        comp0.year = comp.year;
        comp0.month = comp.month;
        comp0.day = comp.day;
        comp0.hour = m_clock.hour;
        comp0.minute = m_clock.minute;
        
        NSDate *myDate0 = [myCal dateFromComponents:comp0];
        NSDate *myDate1 = [[NSDate alloc]initWithTimeInterval:_durationSec sinceDate:myDate0];
        
        [self showCommonProgress];
        
        SportRecordInfo* sportRecordInfo =[[SportRecordInfo alloc]init];
        sportRecordInfo.type = @"run";
        sportRecordInfo.source = (m_switchAuto.on ? _lbSourceData.text : @"");
        sportRecordInfo.begin_time = [myDate0 timeIntervalSince1970];
        sportRecordInfo.end_time = [myDate1 timeIntervalSince1970];
        sportRecordInfo.duration = _durationSec;
        sportRecordInfo.distance = [_tfDistance.text floatValue] * 1000;
        sportRecordInfo.sport_pics.data = _imgUrlArray;
        
        __typeof(self) __weak weakSelf = self;
        
        [[SportForumAPI sharedInstance]recordNewByRecordItem:sportRecordInfo RecordId:_taskInfo.task_id Public:NO
                                               FinishedBlock:^(int errorCode, NSString* strDescErr, ExpEffect* expEffect) {
                                                   __typeof(self) strongSelf = weakSelf;
                                                   
                                                   if (strongSelf == nil) {
                                                       return;
                                                   }
                                                   
                                                   [self hidenCommonProgress];
                                        
                                                   if (errorCode == 0) {
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]];
                                                       /*m_timerReward = [NSTimer scheduledTimerWithTimeInterval: 2
                                                                                                        target: self
                                                                                                      selector: @selector(updateProfileInfo:)
                                                                                                      userInfo: [NSDictionary dictionaryWithObjectsAndKeys:expEffect, @"RewardEffect", nil]
                                                                                                       repeats: NO];*/
                                                       
                                                       if (_taskInfo != nil) {
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_TASK_STATUS object:nil];
                                                           [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_SWITCH_VIEW object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:VIEW_MAIN_PAGE, @"PageName", nil]];
                                                       }
                                                       else
                                                       {
                                                           [self.navigationController popViewControllerAnimated:YES];
                                                       }
                                                   }else{
                                                       [AlertManager showAlertText:strDescErr InView:self.view hiddenAfter:2];
                                                   }
                                               }];
    }
}

//Upload Publish pngs
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
        
        _btnAddPng.frame = CGRectMake(10, 380, 60, 60);
        //_labelNote.frame = CGRectMake(10, 255, 290, 40);
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
        
        UIView * backframe = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame) - 1, CGRectGetMinY(imageView.frame) - 1, CGRectGetWidth(imageView.frame) + 2, CGRectGetHeight(imageView.frame) + 2)];
        backframe.backgroundColor = [UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
        backframe.layer.borderWidth = 1.0;
        backframe.layer.borderColor = [[UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1] CGColor];
        
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
        [m_scrollView addSubview:backframe];
        [m_scrollView bringSubviewToFront:imageView];
        [m_scrollView bringSubviewToFront:btnImage];
        
        [_imgBtnArray addObject:btnImage];
        [_imgBackFrameArray addObject:backframe];
        [_imgViewArray addObject:imageView];
        [_imgUrlArray addObject:arrayUrls[i]];
    }
    
    if (([_imgViewArray count] - 1) % 4 == 3) {
        _btnAddPng.frame = CGRectMake(10, CGRectGetMaxY(rectEnd) + 10, CGRectGetWidth(rectEnd), CGRectGetHeight(rectEnd));
    }
    else
    {
        _btnAddPng.frame = CGRectMake(CGRectGetMaxX(rectEnd) + 17, CGRectGetMinY(rectEnd), CGRectGetWidth(rectEnd), CGRectGetHeight(rectEnd));
    }
    
    //rectEnd = _labelNote.frame;
    //rectEnd.origin = CGPointMake(10, CGRectGetMaxY(_btnAddPng.frame) + 10);
    //_labelNote.frame = rectEnd;
    
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
    _imageEditViewController.cropSize = CGSizeMake(320, 320);
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
        [arrImages addObject:image];
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
}

@end
