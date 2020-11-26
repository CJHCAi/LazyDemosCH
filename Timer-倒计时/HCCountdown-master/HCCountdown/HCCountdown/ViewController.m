//
//  ViewController.m
//  HCCountdown
//
//  Created by 微微笑了 on 2017/10/13.
//  Copyright © 2017年 微微笑了. All rights reserved.
//

#import "ViewController.h"

#import "HCCountdown.h"

#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *selfHeaderView;
@property (nonatomic, strong) HCCountdown *countdown;
@property (strong, nonatomic)  UILabel *minuteLabel_1;
@property (strong, nonatomic)  UILabel *minuteLabel_2;
@property (strong, nonatomic)  UILabel *secondLabel_1;
@property (strong, nonatomic)  UILabel *secondLabel_2;

@property (nonatomic) long nowTimeSp;
@property (nonatomic) long fiveMinuteSp;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _countdown = [[HCCountdown alloc] init];
    
    //现在时间
    NSDate *datenow = [NSDate date];
    
    //获取当前时间的时间戳 long
    long timeSpam = [_countdown timeStampWithDate:datenow];
    
    //获取当前时间 NSSting
    NSString *timeStr = [_countdown getNowTimeString];
    
    //时间戳转时间
    NSString *timeStrWithSpam = [_countdown dateWithTimeStamp:timeSpam];
    
    NSLog(@"timeSpam = %ld", timeSpam);
    NSLog(@"timeDate = %@", timeStr);
    NSLog(@"timeStrWithSpam = %@", timeStrWithSpam);

    //创建倒计时的UI
    [self createHeaderView];
    [self getNowTimeSP:@"订单成功"];


}

- (void) didInBackground: (NSNotification *)notification {
    
    NSLog(@"倒计时进入后台");
    [_countdown destoryTimer];
    
}

- (void) willEnterForground: (NSNotification *)notification {
    
    NSLog(@"倒计时进入前台");
    [self getNowTimeSP:@""];  //进入前台重新获取当前的时间戳，在进行倒计时， 主要是为了解决app退到后台倒计时停止的问题，缺点就是不能防止用户更改本地时间造成的倒计时错误
    
}

- (void) getNowTimeSP: (NSString *) string {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY年MM月dd日HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成NSString
    NSString *currentTimeString_1 = [formatter stringFromDate:datenow];
    NSDate *applyTimeString_1 = [formatter dateFromString:currentTimeString_1];
    _nowTimeSp = (long long)[applyTimeString_1 timeIntervalSince1970];
    
    if ([string isEqualToString:@"订单成功"]) {
        
        NSTimeInterval time = 5 * 60;//5分钟后的秒数
        NSDate *lastTwoHour = [datenow dateByAddingTimeInterval:time];
        NSString *currentTimeString_2 = [formatter stringFromDate:lastTwoHour];
        NSDate *applyTimeString_2 = [formatter dateFromString:currentTimeString_2];
        _fiveMinuteSp = (long)[applyTimeString_2 timeIntervalSince1970];
        
    }
    
    //时间戳进行倒计时
    long startLong = _nowTimeSp;
    long finishLong = _fiveMinuteSp;
    [self startLongLongStartStamp:startLong longlongFinishStamp:finishLong];
    
    NSLog(@"currentTimeString_1 = %@", currentTimeString_1);
    NSLog(@"_nowTimeSp = %ld", _nowTimeSp);
    NSLog(@"_fiveMinuteSp = %ld", _fiveMinuteSp);
    
}


#pragma mark -- 创建头视图
- (void) createHeaderView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didInBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    __weak typeof(self) weakSelf = self;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, WIDTH, HEIGHT*0.12)];
    headerView.backgroundColor = RGB(239, 239, 244, 1);
    [self.view addSubview:headerView];
    _selfHeaderView = headerView;
    
    UILabel *tishiLabel = [UILabel new];
    tishiLabel.textAlignment = NSTextAlignmentCenter;
    tishiLabel.font = textFontWeightSize(12, 0);
    tishiLabel.text = @"支付剩余时间";
    tishiLabel.textColor = RGB(153, 153, 153, 1);
    tishiLabel.backgroundColor = [UIColor clearColor];
    [headerView addSubview:tishiLabel];
    
    UIView *leftLine = [UIView new];
    leftLine.backgroundColor = RGB(251, 161, 72, 1);
    [headerView addSubview:leftLine];
    
    UIView *rightLine = [UIView new];
    rightLine.backgroundColor = RGB(251, 161, 72, 1);
    [headerView addSubview:rightLine];
    
    _minuteLabel_1 = [UILabel new];
    _minuteLabel_1.textColor = [UIColor whiteColor];
    _minuteLabel_1.backgroundColor = RGB(251, 161, 72, 1);
    _minuteLabel_1.layer.cornerRadius = 3;
    _minuteLabel_1.font = textFontWeightSize(12, 1);
    _minuteLabel_1.layer.masksToBounds = YES;
    _minuteLabel_1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_minuteLabel_1];
    
    _minuteLabel_2 = [UILabel new];
    _minuteLabel_2.textColor = [UIColor whiteColor];
    _minuteLabel_2.backgroundColor = RGB(251, 161, 72, 1);
    _minuteLabel_2.layer.cornerRadius = 3;
    _minuteLabel_2.layer.masksToBounds = YES;
    _minuteLabel_2.font = textFontWeightSize(12, 1);
    _minuteLabel_2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_minuteLabel_2];
    
    UILabel *maohaoLabel = [UILabel new];
    maohaoLabel.textColor = RGB(251, 161, 72, 1);
    maohaoLabel.backgroundColor = [UIColor clearColor];
    maohaoLabel.font = textFontWeightSize(12, 2);
    maohaoLabel.text = @":";
    maohaoLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:maohaoLabel];
    
    _secondLabel_1 = [UILabel new];
    _secondLabel_1.textColor = [UIColor whiteColor];
    _secondLabel_1.backgroundColor = RGB(251, 161, 72, 1);
    _secondLabel_1.layer.cornerRadius = 3;
    _secondLabel_1.layer.masksToBounds = YES;
    _secondLabel_1.font = textFontWeightSize(12, 1);
    _secondLabel_1.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_secondLabel_1];
    
    _secondLabel_2 = [UILabel new];
    _secondLabel_2.textColor = [UIColor whiteColor];
    _secondLabel_2.backgroundColor = RGB(251, 161, 72, 1);
    _secondLabel_2.layer.cornerRadius = 3;
    _secondLabel_2.layer.masksToBounds = YES;
    _secondLabel_2.font = textFontWeightSize(12, 1);
    _secondLabel_2.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_secondLabel_2];
    
    [tishiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX).offset(0);
        make.top.mas_equalTo(headerView.mas_top).offset(HEIGHT*0.02);
        make.height.mas_equalTo(30);
        
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(tishiLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(weakSelf.view.mas_left).offset(20);
        make.right.mas_equalTo(tishiLabel.mas_left).offset(-30);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(leftLine.mas_top).offset(0);
        make.left.mas_equalTo(tishiLabel.mas_right).offset(30);
        make.right.mas_equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(0.5);
        
    }];
    
    [maohaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(weakSelf.view.mas_centerX).offset(0);
        make.top.mas_equalTo(tishiLabel.mas_bottom).offset(0);
        make.width.mas_equalTo(10);
        make.height.mas_equalTo(WIDTH*0.06);
        
    }];
    
    [_minuteLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(maohaoLabel.mas_centerY).offset(0);
        make.right.mas_equalTo(maohaoLabel.mas_left).offset(-5);
        make.width.mas_equalTo(WIDTH*0.06);
        make.height.mas_equalTo(weakSelf.minuteLabel_2.mas_width);
        
    }];
    
    [_minuteLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(weakSelf.minuteLabel_2.mas_centerY).offset(0);
        make.right.mas_equalTo(weakSelf.minuteLabel_2.mas_left).offset(-5);
        make.width.mas_equalTo(WIDTH*0.06);
        make.height.mas_equalTo(weakSelf.minuteLabel_1.mas_width);
        
    }];
    
    [_secondLabel_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(maohaoLabel.mas_centerY).offset(0);
        make.left.mas_equalTo(maohaoLabel.mas_right).offset(5);
        make.width.mas_equalTo(WIDTH*0.06);
        make.height.mas_equalTo(weakSelf.secondLabel_1.mas_width);
        
    }];
    
    [_secondLabel_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(weakSelf.secondLabel_1.mas_centerY).offset(0);
        make.left.mas_equalTo(weakSelf.secondLabel_1.mas_right).offset(5);
        make.width.mas_equalTo(WIDTH*0.06);
        make.height.mas_equalTo(weakSelf.secondLabel_2.mas_width);
        
    }];
    
}

///此方法用两个时间戳做参数进行倒计时
-(void)startLongLongStartStamp:(long)strtL longlongFinishStamp:(long) finishL {
    __weak __typeof(self) weakSelf= self;
    
    NSLog(@"second = %ld, minute = %ld", strtL, finishL);
    
    [_countdown countDownWithStratTimeStamp:strtL finishTimeStamp:finishL completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        
        [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
    }];
}

-(void)refreshUIDay:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    
    NSString *str_1 = [NSString stringWithFormat:@"%ld", second];
    NSString *str_2 = [NSString stringWithFormat:@"%ld", minute];
    
    if (second == 0 && minute == 0) {
        
        [_countdown destoryTimer];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"支付超时,请重新下单" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"重新下单" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

            NSLog(@"支付超时");
            
        }];
        
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    if (minute<10) {
        
        self.minuteLabel_1.text = [NSString stringWithFormat:@"%@", @"0"];
        self.minuteLabel_2.text = [NSString stringWithFormat:@"%@",str_2];
        
    }else{
        
        self.minuteLabel_1.text = [NSString stringWithFormat:@"%@",[str_2 substringToIndex:1]];
        self.minuteLabel_2.text = [NSString stringWithFormat:@"%@",[str_2 substringFromIndex:1]];
    }
    if (second<10) {
        
        self.secondLabel_1.text = [NSString stringWithFormat:@"%@",@"0"];
        self.secondLabel_2.text = [NSString stringWithFormat:@"%@",str_1];
        
    }else{
        
        self.secondLabel_1.text = [NSString stringWithFormat:@"%@",[str_1 substringToIndex:1]];
        self.secondLabel_2.text = [NSString stringWithFormat:@"%@",[str_1 substringFromIndex:1]];
    }
}

- (void)dealloc {
    
    [_countdown destoryTimer];  //控制器释放的时候一点要停止计时器，以免再次进入发生错误
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
