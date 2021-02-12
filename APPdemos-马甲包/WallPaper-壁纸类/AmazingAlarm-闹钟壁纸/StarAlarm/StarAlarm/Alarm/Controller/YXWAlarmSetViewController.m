//
//  YXWAlarmSetViewController.m
//  StarAlarm
//
//  Created by dllo on 16/3/30.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWAlarmSetViewController.h"
#import "YXWAlarmWayView.h"
#import "YXWBaseCollectionView.h"
#import "YXWDayCollectionViewCell.h"
#import "YXWChoseViewController.h"
#import "XFZ_Notification.h"
#import "WDGDatabaseTool.h"
#import <MediaPlayer/MediaPlayer.h>
#import "YXWAlarmModel.h"
#import "YXWAlartTimeTool.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface YXWAlarmSetViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,YXWAlarmWayViewDelegate> {
    __block YXWAlarmModel *p_alarmModel;
}

@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, strong) NSMutableArray *hours;
@property (nonatomic, strong) NSMutableArray *minutes;
@property (nonatomic, strong) NSString *hour;
@property (nonatomic, strong) NSString *minute;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) Monday_Model *monday;
@property (nonatomic, assign) BOOL isWorkDay;
@property (nonatomic, assign) BOOL isEveryDay;
@property (nonatomic, assign) BOOL isWeekDay;



/**
 *  整体的scrollView
 */
@property (nonatomic, strong) UIScrollView *backScrollView;
/**
 *  闹钟模式的View
 */
@property (nonatomic, strong) YXWAlarmWayView *alarmWayView;
/**
 *  闹钟时间view
 */
@property (nonatomic, strong) UIView *timeView;
/**
 *  时间标题
 */
@property (nonatomic, strong) UILabel *timeTitleLabel;
/**
 *  时间label
 */
@property (nonatomic, strong) UIButton *timeButton;
@property (nonatomic, assign) BOOL isPic;
/**
 *  周期View
 */
@property (nonatomic, strong) UIView *cycleView;
@property (nonatomic, strong) UILabel *cycleLable;
@property (nonatomic, strong) UIButton *weekendayBt;
@property (nonatomic, strong) UIButton *everydayBt;
@property (nonatomic, strong) UIButton *workdayBt;
@property (nonatomic, strong) YXWBaseCollectionView *dayCollectionView;
@property (nonatomic, strong) NSMutableArray *dayArray;

/**
 *  震动
 */
@property (nonatomic, strong) UIView *shockView;
@property (nonatomic, strong) UISwitch *shockSwitch;
@property (nonatomic, strong) UILabel *shockLabel;

/**
 *  音量
 */

@property (nonatomic, strong) UIView *voiceView;
@property (nonatomic, strong) UILabel *voiceLabel;
@property (nonatomic, strong) UISlider *voiceSlider;
@property (nonatomic,strong)UISlider *slider;
@property (nonatomic,assign)CGPoint firstPoint;
@property (nonatomic,assign)CGPoint secondPoint;

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, strong) WDGDatabaseTool *alarmData;
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableString *dayStr;

@end

@implementation YXWAlarmSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dayArray = [NSMutableArray array];
    NSArray  *dayArr = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    
    for (int i = 0; i < 7; i ++) {
        Monday_Model *monday = [[Monday_Model alloc] init];
        monday.day = dayArr[i];
        monday.isSelect = NO;
        [self.dayArray addObject:monday];
    }
    
    _hours = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 24; i++) {
        [_hours addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    _minutes = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < 60; i++) {
        [_minutes addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.dayStr = [[NSMutableString alloc] init];

    [self setNav];
    [self creatView];
    
}

- (void)creatView {
    [self creatScrollView];
    [self creatAlarmWayView];
    [self creatTimeView];
    [self creatCycleView];
    [self creatShockView];
    [self creatVoiceView];
}

#pragma mark - 建立VoiceView

- (void)creatVoiceView {
    self.voiceView = [UIView new];
    self.voiceView.backgroundColor = mBackColor;
    self.voiceView.layer.masksToBounds = YES;
    [self.voiceView.layer setCornerRadius:5.0];
    [self.backScrollView addSubview:self.voiceView];
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shockView.mas_bottom).offset(20);
        make.left.equalTo(self.backScrollView).offset(10);
        make.right.equalTo(self.backScrollView).offset(-10);
        make.height.equalTo(@35);
        make.centerX.equalTo(self.backScrollView.mas_centerX);
    }];
    
    self.voiceLabel = [UILabel new];
    self.voiceLabel.textColor = [UIColor whiteColor];
    self.voiceLabel.text = @"音量:";
    [self.voiceView addSubview:self.voiceLabel];
    [self.voiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceView.mas_top).offset(0);
        make.left.equalTo(self.voiceView).offset(5);
        make.size.mas_offset(CGSizeMake(50, 35));
    }];
    
    
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    
    [self.view addSubview:volumeView];
    [volumeView sizeToFit];
    
    
    
    
    self.voiceSlider = [[UISlider alloc] init];
    [self.voiceSlider setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
    [self.voiceSlider setMinimumTrackImage:[UIImage imageNamed:@"76N58PICwqn_1024_Fotor"] forState:UIControlStateNormal];
    self.voiceSlider.minimumValue = 0.0;
    self.voiceSlider.maximumValue = 1.0;
    self.voiceSlider.continuous = YES;
    [self.voiceView addSubview:self.voiceSlider];
    [self.voiceSlider addTarget:self action:@selector(volumeChange) forControlEvents:UIControlEventValueChanged];
    [self.voiceSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceView.mas_top).offset(8.5);
        make.centerX.equalTo(self.voiceView.mas_centerX).offset(20);
        make.size.mas_offset(CGSizeMake(self.view.bounds.size.width - 120, 20));
    }];
    self.slider = [[UISlider alloc]init];
    self.slider.backgroundColor = [UIColor blueColor];
    for (UIControl *view in volumeView.subviews) {
        if ([view.superclass isSubclassOfClass:[UISlider class]]) {
            NSLog(@"1");
            self.slider = (UISlider *)view;
        }
    }
    self.slider.autoresizesSubviews = NO;
    self.slider.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:self.slider];
    self.slider.hidden = YES;
}

- (void)creatShockView {
    self.shockView = [UIView new];
    self.shockView.backgroundColor = mBackColor;
    self.shockView.layer.masksToBounds = YES;
    [self.shockView.layer setCornerRadius:5.0];
    [self.backScrollView addSubview:self.shockView];
    [self.shockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_bottom).offset(20);
        make.left.equalTo(self.backScrollView).offset(10);
        make.right.equalTo(self.backScrollView).offset(-10);
        make.height.equalTo(@35);
        make.centerX.equalTo(self.backScrollView.mas_centerX);
    }];
    
    self.shockLabel = [UILabel new];
    self.shockLabel.textColor = [UIColor whiteColor];
    self.shockLabel.text = @"震动:";
    [self.shockView addSubview:self.shockLabel];
    [self.shockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shockView.mas_top).offset(0);
        make.left.equalTo(self.shockView).offset(5);
        make.size.mas_offset(CGSizeMake(50, 35));
    }];
    
    self.shockSwitch = [UISwitch new];
    self.shockSwitch.onTintColor = mStarColor;
    [self.shockView addSubview:self.shockSwitch];
    [self.shockSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shockView.mas_top).offset(2.5);
        make.right.equalTo(self.shockView).offset(-5);
        make.size.mas_offset(CGSizeMake(50, 30));
    }];
    [self.shockSwitch addTarget:self action:@selector(shockSwitch) forControlEvents:UIControlEventValueChanged];
}

- (void)shockSwitchAction {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

#pragma mark - 创建周期View
- (void)creatCycleView {
    self.cycleView = [[UIView alloc] init];
    self.cycleView.backgroundColor = mBackColor;
    self.cycleView.layer.masksToBounds = YES;
    [self.cycleView.layer setCornerRadius:5.0];
    [self.backScrollView addSubview:self.cycleView];
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom).offset(20);
        make.left.equalTo(self.backScrollView).offset(10);
        make.right.equalTo(self.backScrollView).offset(-10);
        make.height.equalTo(@71);
        make.centerX.equalTo(self.backScrollView.mas_centerX);
    }];
    
    self.cycleLable = [[UILabel alloc] init];
    self.cycleLable.text = @"周期:";
    self.cycleLable.textColor = [UIColor whiteColor];
    [self.cycleView addSubview:self.cycleLable];
    [self.cycleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_top).offset(0);
        make.left.equalTo(self.cycleView).offset(5);
        make.size.mas_offset(CGSizeMake(50, 35));
    }];
    
    UIView *separatView = [[UIView alloc] init];
    separatView.backgroundColor = [UIColor whiteColor];
    [self.cycleView addSubview:separatView];
    [separatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cycleView).offset(-10);
        make.left.equalTo(self.cycleView).offset(10);
        make.height.equalTo(@1);
        make.centerY.equalTo(self.cycleView.mas_centerY);
    }];
    [self creatButton];
}

#pragma mark - 创建时间周期button 
- (void)creatButton {
    self.workdayBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.workdayBt setTitle:@"工作日" forState:UIControlStateNormal];
    [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.workdayBt addTarget:self action:@selector(gongzuoAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cycleView addSubview:self.workdayBt];
    [self.workdayBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_top).offset(0);
        make.right.equalTo(self.cycleView).offset(0);
        make.height.equalTo(@35);
        make.width.equalTo(@60);
    }];
    
    self.everydayBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.everydayBt setTitle:@"每日" forState:UIControlStateNormal];
    [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.everydayBt addTarget:self action:@selector(everydayAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.cycleView addSubview:self.everydayBt];
    [self.everydayBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_top).offset(0);
        make.right.equalTo(self.workdayBt.mas_left).offset(5);
        make.height.equalTo(@35);
        make.width.equalTo(@60);
    }];
    
    self.weekendayBt = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.weekendayBt setTitle:@"周末" forState:UIControlStateNormal];
    [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.weekendayBt addTarget:self action:@selector(weekendayAction) forControlEvents:UIControlEventTouchUpInside];
    [self.cycleView addSubview:self.weekendayBt];
    [self.weekendayBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cycleView.mas_top).offset(0);
        make.right.equalTo(self.everydayBt.mas_left).offset(5);
        make.height.equalTo(@35);
        make.width.equalTo(@60);
    }];
    [self creatDayCollectionView];
}

#pragma maek - 周末的点击事件

- (void)weekendayAction {
    [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dayStr = [NSMutableString stringWithCapacity:0];
    _isWorkDay = NO;
    _isEveryDay = NO;
    if (_isWeekDay == YES) {
        for (int i = 0; i < 7; i++) {
            Monday_Model * model = _dayArray[i];
            model.isSelect = NO;
        }
        [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isWeekDay = NO;
    }else{
        for (int i = 5; i < 7; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = YES;
            [self.dayStr insertString:model.day atIndex:self.dayStr.length];
        }
        
        for (int i = 0; i < 5; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = NO;
        }
        [self.weekendayBt setTitleColor:mStarColor forState:UIControlStateNormal];

        _isWeekDay = YES;

    }
    
    [self.dayCollectionView reloadData];
}

#pragma mark - 每天的点击事件

- (void)everydayAction {
    [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dayStr = [NSMutableString stringWithCapacity:0];
    _isWorkDay = NO;
    _isWeekDay = NO;
    if (_isEveryDay == YES) {
        for (int i = 0; i< 7; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = NO;
        }
        [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isEveryDay = NO;
    } else {
        
        for (int i = 0; i < 7; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = YES;
            [self.dayStr insertString:model.day atIndex:self.dayStr.length];
        }
        [self.everydayBt setTitleColor:mStarColor forState:UIControlStateNormal];

        _isEveryDay = YES;
    }
    [self.dayCollectionView reloadData];
}

#pragma mark - 工作日点击事件
- (void)gongzuoAction {
    [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.dayStr = [NSMutableString stringWithCapacity:0];
    _isWeekDay = NO;
    _isEveryDay = NO;
    if (_isWorkDay == YES) {
        for (int i = 0; i< 7; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = NO;
        }
        [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                _isWorkDay = NO;
    } else {
        
        for (int i = 0; i < 5; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = YES;
            [self.dayStr insertString:model.day atIndex:self.dayStr.length];
        }
        for (int i = 5; i< 7; i++) {
            Monday_Model *model = _dayArray[i];
            model.isSelect = NO;
        }
        [self.workdayBt setTitleColor:mStarColor forState:UIControlStateNormal];

               _isWorkDay = YES;
    }
    
    [self.dayCollectionView reloadData];
}

- (void)changeButtonColor {
    NSString *str1 = @"一";
    NSString *str2 = @"二";
    NSString *str3 = @"三";
    NSString *str4 = @"四";
    NSString *str5 = @"五";
    NSString *str6 = @"六";
    NSString *str7 = @"日";
    NSRange range1 = [self.dayStr rangeOfString:str1];
    NSRange range2 = [self.dayStr rangeOfString:str2];
    NSRange range3 = [self.dayStr rangeOfString:str3];
    NSRange range4 = [self.dayStr rangeOfString:str4];
    NSRange range5 = [self.dayStr rangeOfString:str5];
    NSRange range6 = [self.dayStr rangeOfString:str6];
    NSRange range7 = [self.dayStr rangeOfString:str7];
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (range1.length != 0) {
        [str insertString:@"周一" atIndex:str.length];
    }
    if (range2.length != 0) {
        [str insertString:@"周二" atIndex:str.length];
    }
    if (range3.length != 0) {
        [str insertString:@"周三" atIndex:str.length];
    }
    if (range4.length != 0) {
        [str insertString:@"周四" atIndex:str.length];
    }
    if (range5.length != 0) {
        [str insertString:@"周五" atIndex:str.length];
    }
    if (range6.length != 0) {
        [str insertString:@"周六" atIndex:str.length];
    }
    if (range7.length != 0) {
        [str insertString:@"周日" atIndex:str.length];
    }

    self.dayStr = [NSMutableString stringWithString:str];
    
    if (range1.length != 0 && range2.length != 0 && range3.length != 0 && range4.length != 0 && range5.length != 0 && range6.length == 0 && range7.length == 0) {
        [self.workdayBt setTitleColor:mStarColor forState:UIControlStateNormal];
        [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isWorkDay = YES;
        _isWeekDay = NO;
        _isEveryDay = NO;
    } else if (range1.length != 0 && range2.length != 0 && range3.length != 0 && range4.length != 0 && range5.length != 0 && range6.length != 0 && range7.length != 0) {
        [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.everydayBt setTitleColor:mStarColor forState:UIControlStateNormal];
        [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isWorkDay = NO;
        _isWeekDay = NO;
        _isEveryDay = YES;
    } else if (range1.length == 0 && range2.length == 0 && range3.length == 0 && range4.length == 0 && range5.length == 0 && range6.length != 0 && range7.length != 0) {
        [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.weekendayBt setTitleColor:mStarColor forState:UIControlStateNormal];
        _isWorkDay = NO;
        _isWeekDay = YES;
        _isEveryDay = NO;
    } else {
        [self.workdayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.everydayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.weekendayBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _isWorkDay = NO;
        _isWeekDay = NO;
        _isEveryDay = NO;
    }
    
}


#pragma mark - 创建时间的collectionView
- (void)creatDayCollectionView {
   
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((self.backScrollView.frame.size.width - 20) / 7, 35);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.dayCollectionView = [[YXWBaseCollectionView alloc] initWithFrame:CGRectMake(0, 36, self.backScrollView.frame.size.width - 20, 35) collectionViewLayout:flowLayout];

    [self.dayCollectionView registerClass:[YXWDayCollectionViewCell class] forCellWithReuseIdentifier:@"YXWDayCollectionViewCellIdentifier"];
    
    self.dayCollectionView.delegate = self;
    self.dayCollectionView.dataSource = self;
    self.dayCollectionView.backgroundColor = [UIColor clearColor];
    
    [self.cycleView addSubview:self.dayCollectionView];
}

#pragma makr - 时间collecttionView的代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dayArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    YXWDayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXWDayCollectionViewCellIdentifier" forIndexPath:indexPath];
    
    Monday_Model *model = _dayArray[indexPath.item];
    
    if (model.isSelect == YES) {
        cell.titileLabel.textColor = mStarColor;
    } else {
        cell.titileLabel.textColor = [UIColor whiteColor];
    }
    
    cell.titileLabel.text = model.day;
    
    return cell;
}


#pragma mark - 添加星期的点击事件

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    Monday_Model *model = _dayArray[indexPath.item];
    if (self.dayStr.length == 0) {
        self.dayStr = [NSMutableString stringWithCapacity:0];
    }
    if (model.isSelect) {
        NSRange range = [self.dayStr rangeOfString:model.day];
        [self.dayStr deleteCharactersInRange:range];
        model.isSelect = NO;
    } else {
        model.isSelect = YES;
        [self.dayStr insertString:model.day atIndex:self.dayStr.length];
    }
    [self.dayCollectionView reloadData];
    NSLog(@"%@", self.dayStr);
    [self changeButtonColor];

}

#pragma mark - 创建时间view
- (void)creatTimeView {
    self.timeView = [[UIView alloc] init];
    [self.backScrollView addSubview:self.timeView];
    self.timeView.layer.masksToBounds = YES;
    [self.timeView.layer setCornerRadius:5.0];
    self.timeView.backgroundColor = mBackColor;
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alarmWayView.mas_bottom).offset(20);
        make.left.equalTo(self.backScrollView).offset(10);
        make.right.equalTo(self.backScrollView).offset(-10);
        make.height.equalTo(@35);
        make.centerX.equalTo(self.backScrollView.mas_centerX);
    }];

    self.timeTitleLabel = [[UILabel alloc] init];
    self.timeTitleLabel.text = @"时间:";
    self.timeTitleLabel.font = [UIFont systemFontOfSize:13];
    self.timeTitleLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    [self.timeView addSubview:self.timeTitleLabel];
    [self.timeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_top).offset(0);
        make.left.equalTo(self.timeView.mas_left).offset(5);
        make.height.equalTo(@35);
        make.centerY.equalTo(self.timeView.mas_centerY);
    }];
    
    
//    创建保存时间Button
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.saveButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton setTitleColor:mStarColor forState:UIControlStateNormal];
    [self.timeView addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeView.mas_right).offset(-5);
        make.top.equalTo(self.timeView.mas_top).offset(0);
        make.height.equalTo(@35);
        make.width.equalTo(@60);
    }];
    
//    创建时间button
    self.timeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.hour = @"00";
    self.minute = @"00";
    [self.timeButton setTitle:[NSString stringWithFormat:@"%@:%@",self.hour,self.minute] forState:UIControlStateNormal];
    [self.timeButton setTitleColor:mStarColor forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(timeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.timeView addSubview:self.timeButton];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_top).offset(0);
        make.bottom.equalTo(self.timeView.mas_bottom).offset(0);
        make.width.equalTo(@150);
        make.centerX.equalTo(self.timeView.mas_centerX);
    }];
}

#pragma mark - 保存时间的点击事件
- (void)saveAction {
    
    if (_isPic) {
        _picker.hidden = YES;
        _isPic = NO;
    }
    [UIView animateWithDuration:0.1 animations:^{
        [UIView setAnimationDuration:1];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.timeView.frame = CGRectMake(10, _alarmWayView.frame.size.height + _alarmWayView.frame.origin.y + 20, self.view.frame.size.width - 20, 30);
        [self reloadView];
    }];
}

#pragma mark - 时间的点击事件
- (void)timeButtonAction {
    [UIView animateWithDuration:0.1 animations:^{
        [UIView setAnimationDuration:1];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        self.timeView.frame = CGRectMake(10, _alarmWayView.frame.size.height + _alarmWayView.frame.origin.y + 20, self.view.frame.size.width - 20, 200);
        [self reloadView];
    }];
    if (!self.picker) {
        self.picker = [[UIPickerView alloc] init];
        [self.timeView addSubview:self.picker];
        [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.timeView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width - 20, self.timeView.bounds.size.height - 35));
            make.top.equalTo(self.timeView).offset(35);
        }];
        self.picker.delegate = self;
        _picker.dataSource = self;
        _picker.showsSelectionIndicator = YES;
    }
    if (!_isPic) {
        self.picker.hidden = NO;
        _isPic = YES;
    }
}


#pragma mark UIPickerViewDelegate Methods

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (!view) {
        view = [[UIView alloc] init];
    }
    [[pickerView.subviews objectAtIndex:1] setHidden:TRUE];
    if (pickerView.subviews.count > 2) {
        [[pickerView.subviews objectAtIndex:2] setHidden:TRUE];
    }
    
    if (component == 0) {
        UILabel *hoursLabel = [[UILabel alloc] init];
        hoursLabel.frame = CGRectMake(0, 0, self.timeView.bounds.size.width * 0.5, self.timeView.bounds.size.height/3);
        hoursLabel.textAlignment = NSTextAlignmentCenter;
        hoursLabel.text = [NSString stringWithFormat:@"%@时", [_hours objectAtIndex:row]];
        hoursLabel.textColor = [UIColor whiteColor];
        [view addSubview:hoursLabel];
        return view;
        
    } else {
        UILabel *minutesLabel = [[UILabel alloc]init];
        minutesLabel.frame = CGRectMake(0, 0, self.view.frame.size.width * 0.5, self.timeView.bounds.size.height/3);
         minutesLabel.text = [NSString stringWithFormat:@"%@分", [_minutes objectAtIndex:row]];
        minutesLabel.textColor = [UIColor whiteColor];
        minutesLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:minutesLabel];
         return view;
    }
}

#pragma mark UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
        return self.hours.count;
    else
        return self.minutes.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

#pragma mark - 取出值
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (component == 0) {

        self.hour = [NSString stringWithFormat:@"%02ld", row];
        [self.timeButton setTitle:[NSString stringWithFormat:@"%@:%@",self.hour,self.minute] forState:UIControlStateNormal];
        
    } else {

        self.minute = [NSString stringWithFormat:@"%02ld", row];
        [self.timeButton setTitle:[NSString stringWithFormat:@"%@:%@",self.hour,self.minute] forState:UIControlStateNormal];
    }
    
}

- (void)reloadView {
    
    self.cycleView.frame = CGRectMake(10, _timeView.frame.size.height + _timeView.frame.origin.y + 20, self.view.frame.size.width - 20, 71);
    self.shockView.frame = CGRectMake(10, _cycleView.frame.size.height + _cycleView.frame.origin.y + 20, self.view.frame.size.width - 20, 35);
    self.voiceView.frame = CGRectMake(10, _shockView.frame.size.height + _shockView.frame.origin.y + 20, self.view.frame.size.width - 20, 35);
    if (_backScrollView.contentSize.height == (self.view.bounds.size.height - 64)) {
        self.backScrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height + 200);
    } else {
        self.backScrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height - 64);
    }
    
}

#pragma mark - 创建闹钟模式选择view
- (void)creatAlarmWayView {
    
//    模式背景View
    self.alarmWayView = [YXWAlarmWayView new];
    [self.backScrollView addSubview:self.alarmWayView];
    self.alarmWayView.backgroundColor = mBackColor;
    [self.alarmWayView.layer setCornerRadius:5.0];
    self.alarmWayView.layer.masksToBounds = YES;
    self.alarmWayView.delegate = self;
    [self.alarmWayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.backScrollView).offset(10);
        make.top.equalTo(self.backScrollView).offset(64);
        make.right.equalTo(self.backScrollView).offset(-10);
        make.height.equalTo(@(220 * myScale));
        make.centerX.equalTo(self.backScrollView.mas_centerX);
    }];
}

#pragma mark - 创建scrollView
- (void)creatScrollView {
    self.backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.backScrollView.bounces = NO;
    self.backScrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height - 64);
    self.backScrollView.delegate = self;
    self.backScrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.backScrollView];
}

#pragma mark - 设置导航栏
- (void)setNav {
    [self creatNavButtonItem];
    [self.navigationItem setTitle:@"编辑闹钟"];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],NSForegroundColorAttributeName,[UIFont systemFontOfSize: 20.0],NSFontAttributeName,nil]];
}

#pragma mark - 创建导航栏按钮

- (void)creatNavButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]  initWithTitle:@"X 关闭" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonAction:)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]  initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonAction:)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
}

#pragma mark - 导航栏按钮点击事件
- (void)leftBarButtonAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 点击完成保存到本地

- (void)rightBarButtonAction:(UIBarButtonItem *)sender {
    
    self.alarmData = [WDGDatabaseTool DBManageWithTableName:@"Alarm"];
    [self.alarmData openDatabase];
    
    if (_isChange) {
        if (self.dayStr.length != 0) {
            [self.alarmData updateDataWithNewData:[NSDictionary dictionaryWithObjectsAndKeys:self.hour, @"hour", self.minute, @"minute", self.dayStr,@"week", self.alarmWayView.alarmWayTitle.text, @"style", nil] WhereCondition:[WDGWhereCondition conditionWithColumnName:@"id" Operator:@"=" Value:self.dataModel.customId]];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.alarmData closeDatabase];
            }];
        } else {
             [[[TAlertView alloc] initWithTitle:@"" andMessage:@"请选择时间和日期"] show];
        }
    } else {
    if (self.dayStr.length != 0) {
        if ([self.alarmData selectAllData].count <= 4) {
            [self.alarmData insertDataWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:self.hour, @"hour", self.minute, @"minute", self.dayStr,@"week", self.alarmWayView.alarmWayTitle.text, @"style", nil]];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.alarmData closeDatabase];
            }];
        } else {
            [[[TAlertView alloc] initWithTitle:@"" andMessage:@"闹钟已经超过五个了，请删除后再添加"] show];
        }
        
    } else {
        [[[TAlertView alloc] initWithTitle:@"" andMessage:@"请选择时间和日期"] show];
    }
    }
    [self.alarmData closeDatabase];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
}
// 设置导航栏背景图片
-(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.backScrollView.contentOffset.y > 0) {
        [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor colorWithRed:0.702 green:0.702 blue:0.702 alpha:0.439655172413793]] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    }
}
#pragma mark - 控制系统音量方法
- (void)volumeChange
{
    
    [[MPMusicPlayerController applicationMusicPlayer] setVolume:self.voiceSlider.value];
    
    NSLog(@"adasd%f",self.voiceSlider.value);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in event.allTouches) {
        
        self.firstPoint = [touch locationInView:self.view];
        
    }
    
    UISlider *slider = (UISlider *)[self.view viewWithTag:1000];
    slider.value = self.slider.value;

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *touch in event.allTouches) {
        
        self.secondPoint = [touch locationInView:self.view];
        
    }
    
    self.slider.value += (self.firstPoint.y - self.secondPoint.y)/500.0;
    
    UISlider *slider = (UISlider *)[self.view viewWithTag:1000];
    slider.value = self.slider.value;

    self.firstPoint = self.secondPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    self.firstPoint = self.secondPoint = CGPointZero;
}
#pragma mark - push到闹钟选择的页面
- (void)pushToChooseVc {
    YXWChoseViewController *choseVC = [[YXWChoseViewController alloc] init];
    
    void(^block)(YXWAlarmModel *alarmModel) = ^(YXWAlarmModel *alarmModel) {
        p_alarmModel = alarmModel;
        self.alarmWayView.alarmModel = p_alarmModel;
        NSLog(@"%@", self.alarmWayView.alarmModel.title);
    };
    choseVC.block = block;
   
    
    [self.navigationController pushViewController:choseVC animated:YES];
}

- (void)setDataModel:(ZFZ_dataModel *)dataModel {
    _dataModel = dataModel;
    _isChange = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
