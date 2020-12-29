//
//  YXWMainViewController.m
//  StarAlarm
//
//  Created by dllo on 16/3/30.
//  Copyright © 2016年 YXW. All rights reserved.
//

#import "YXWMainViewController.h"
#import "YXWAlarmSetViewController.h"
#import "YXWGlobalSetViewController.h"
#import "XFZ_TimeView.h"
#import "YXWCalmCosmosViewController.h"
#import "XFZ_AddAlarm_TableViewCell.h"
#import "WDGDatabaseTool.h"
#import "ZFZ_dataModel.h"
#import "YXWWeatherModel.h"
#import "ZFZ_didAction.h"
#import "YXWBigAlpView.h"
#import "YXWAlarmSetViewController.h"
#import "XFZ_Notification.h"
#import "YXWAlartTimeTool.h"

@interface YXWMainViewController ()<UITableViewDelegate,UITableViewDataSource,ZFZ_didActionDelegate> {
    CAShapeLayer *arcLayer;
    BOOL _isIntroduceVC;
    NSInteger numberOfHeight;
    BOOL _isIos5;
    BOOL _isAnimation;
    BOOL _isPressButton;
}

@property (strong, nonatomic) IBOutlet UIButton *menuBt;

@property (strong, nonatomic) IBOutlet UIButton *addBt;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) XFZ_TimeView *time;
@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) UIView *vieww;
@property (nonatomic, strong) UIView *viewwy;
@property (nonatomic, strong) ZFZ_didAction *didView;
@property (nonatomic, assign) CGRect rect;

//粒子效果
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) CAEmitterLayer *emitter;
@property (nonatomic, strong) CAEmitterCell *cell;
@property (nonatomic, strong) CAEmitterLayer *newenitter;

@property (nonatomic, strong) NSMutableArray *dataSource;
//天气
@property (nonatomic, strong) YXWWeatherModel *weatherModel;

@end

@implementation YXWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ViewTime];
    [self getDataBase];


    //通知显现粒子动画
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PSONotification:) name:@"lizi" object:nil];
    [[NSUserDefaults standardUserDefaults] objectForKey:@"lizi"];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getWeather:) name:@"city" object:nil];
    [[NSUserDefaults standardUserDefaults] objectForKey:@"city"];
    
    
}
#pragma mark -粒子动画
-(void)PSONotification:(NSNotification *)message {
    if (!_isShow) {
        self.emitter = [CAEmitterLayer layer];
        self.emitter.frame = self.view.frame;
        [self.view.layer addSublayer:self.emitter];
        //configure emitter
        //发射模式
        self.emitter.emitterMode = kCAEmitterLayerOutline;
        //渲染模式
        //  emitter.renderMode = kCAEmitterLayerUnordered;
        //发射位置
        self.emitter.emitterPosition = CGPointMake(0-20, self.emitter.frame.size.height  );
        //发射源形状
        self.emitter.emitterShape = kCAEmitterLayerCircle;
        //creat newemitter
        self.newenitter = [CAEmitterLayer layer];
        self.emitter.frame = self.view.frame;
        [self.view.layer addSublayer:self.newenitter];
        self.newenitter.emitterMode = kCAEmitterLayerOutline;
        self.emitter.emitterPosition = CGPointMake(self.view.frame.size.width + 20, self.view.frame.size.height);
        self.newenitter.emitterShape = kCAEmitterLayerCircle;
        //create a particle template
        self.cell = [[CAEmitterCell alloc] init];
        //cell 上添加图片
        self.cell.contents = (__bridge id)[UIImage imageNamed:@"qp.png"].CGImage;
        //每次发射的个数
        self.cell.birthRate = 3.0;
        //生命周期
        self.cell.lifetime = 11.0;
        //发射的速度
        self.cell.velocity = 300;
        //发射周围的速度
        self.cell.velocityRange = 500;
        //发射的角度
        self.cell.emissionLongitude = M_1_PI;
        //add particle template to emitter
        //添加到cell上
        self.emitter.emitterCells = @[self.cell];
        self.newenitter.emitterCells = @[self.cell];
        _isShow = 1;
        
    } else if (_isShow) {
        [self.emitter removeFromSuperlayer];
        [self.newenitter removeFromSuperlayer];
        _isShow = 0;
    }
}

// 模态到添加界面
- (IBAction)AddAction:(id)sender {
    YXWAlarmSetViewController *setAlarm = [[YXWAlarmSetViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setAlarm];
    [self presentViewController:nav animated:YES completion:^{
    }];
}
- (IBAction)wallAction:(id)sender {
    YXWGlobalSetViewController *globa = [[YXWGlobalSetViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:globa];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithBgColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    [self getDataBase];
    
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

//  添加一个时钟

- (void)ViewTime {
    
    self.time = [[XFZ_TimeView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.55/16, -self.view.bounds.size.height * 0.45, self.view.bounds.size.width * 0.45, self.view.bounds.size.width * 0.45)];

    _time.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, -self.view.bounds.size.height * 0.45/2 - 50);
    
 
    self.tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];

    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tabView];
    self.tabView.delegate = self;
    self.tabView.dataSource = self;
    self.tabView.contentInset = UIEdgeInsetsMake(self.view.bounds.size.height * 0.55 , 0, 0, 0);
    [self.tabView registerClass:[XFZ_AddAlarm_TableViewCell class] forCellReuseIdentifier:@"UITableViewCellIdentifier"];
    [self.tabView addSubview:self.time];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XFZ_AddAlarm_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellIdentifier"];
    cell.dataModel = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0.502 alpha:0.0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld", indexPath.row);

    XFZ_AddAlarm_TableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    YXWBigAlpView *bigBackView = [[YXWBigAlpView alloc] initWithFrame:CGRectMake(0, self.time.frame.origin.y, self.view.bounds.size.width, self.tabView.bounds.size.height)];
    bigBackView.blockRemove = ^(){
        
        if (self.didView) {
            [self.didView removeFromSuperview];
        }
    };
    
    [self.tabView addSubview:bigBackView];
    
    self.didView = [[ZFZ_didAction alloc] initWithFrame:cell.yyy.frame];
    self.didView.delegate = self;
    _didView.backgroundColor = [UIColor colorWithWhite:0.010 alpha:0.99];
    _didView.layer.cornerRadius = 20;
    self.didView.layer.borderWidth = 1;
    
    self.didView.layer.borderColor = [[UIColor whiteColor] CGColor];

    _didView.dataModel = self.dataSource[indexPath.row];
    [self.tabView addSubview:_didView];
    
    _didView.blockOfRemoveBigView = ^(){
        
        if (bigBackView) {
            [bigBackView removeFromSuperview];
        }
    
    };
    
}

- (void)deleteActionWittModel:(ZFZ_dataModel *)dataModel {
    
    WDGDatabaseTool *baseTool = [WDGDatabaseTool DBManageWithTableName:@"Alarm"];
    [baseTool openDatabase];
    [baseTool deleteDataWithWhereCondition:[WDGWhereCondition conditionWithColumnName:@"id" Operator:@"=" Value:dataModel.customId]];
    [baseTool closeDatabase];
    [self getDataBase];

}


- (void)didActionWithModel:(ZFZ_dataModel *)dataModel {
    YXWAlarmSetViewController * vc =[[YXWAlarmSetViewController alloc] init];
    vc.dataModel = dataModel;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];
    
}

- (void)getDataBase {
    
    self.dataSource = [NSMutableArray arrayWithCapacity:0];// 用于tableview的cell
    NSMutableArray *timeArray = [NSMutableArray arrayWithCapacity:0];// 用于计算时间差后返回的时间的数组
    NSMutableArray *dicArr = [NSMutableArray arrayWithCapacity:0];// 用于存储闹铃风格和对应的的数组
    NSMutableArray *keyArr = [NSMutableArray arrayWithCapacity:0];// 用于存储key值的数组
    WDGDatabaseTool *datebaseToll = [WDGDatabaseTool DBManageWithTableName:@"Alarm"];
    [datebaseToll openDatabase];
    [datebaseToll selectAllData];
    for (NSDictionary *dic in [datebaseToll selectAllData]) {
        ZFZ_dataModel *dateModel = [[ZFZ_dataModel alloc] init];
        [dateModel setValuesForKeysWithDictionary:dic];
        NSDictionary *timeDic = [NSDictionary dictionaryWithObjectsAndKeys:[YXWAlartTimeTool timeWithWeek:dateModel.week withTme:[NSString stringWithFormat:@"%@:%@", dateModel.hour, dateModel.minute]], dateModel.style, nil];
        [keyArr addObject:dateModel.style];
        [dicArr addObject:timeDic];
//        计算出所有闹钟到现在的时间差存入数组
        [timeArray addObject:[YXWAlartTimeTool timeWithWeek:dateModel.week withTme:[NSString stringWithFormat:@"%@:%@", dateModel.hour, dateModel.minute]]];
        
        [self.dataSource addObject:dateModel];
    }
    [self.tabView reloadData];
    NSMutableArray *newTimeArray = [NSMutableArray arrayWithCapacity:0];
    for (NSArray *arr in timeArray) {
        [newTimeArray addObject:arr[0]];
    }
//    把所有时间取出然后取出最近的时间－－冒泡算法取第一个
    if (newTimeArray.count >= 1) {
        for (int i = 0; i < newTimeArray.count - 1; i++) {
            for (int j = 0; j < newTimeArray.count - 1 - i; j++) {
                if ([newTimeArray[j] integerValue] > [newTimeArray[j + 1] integerValue]) {
                    NSString *tempa = newTimeArray[j + 1];
                    newTimeArray[j + 1] = newTimeArray[j];
                    newTimeArray[j] = tempa;
                }
            }
        }
//        通过key值得出最近的一次闹钟响铃模式
        for (int i = 0; i < dicArr.count; i++) {
            NSArray *arr = [dicArr[i] objectForKey:keyArr[i]];
            if ([arr[0] isEqualToString:newTimeArray[0]]) {
                [[NSUserDefaults standardUserDefaults] setObject:keyArr[i] forKey:@"style"];
            }
        }
//        发送本地通知－－每次都发送一次闹钟，循环为每秒一次（系统默认每秒为每次推送持续时间为30秒）
//        同时每次到主页面之后都会进行闹钟初始化，当闹钟解除后都会回到主页面，因此可以实现闹钟不解除就会一直响，直到点进界面取消本地推送为止
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [XFZ_Notification registerLocalNotification:[newTimeArray[0] integerValue]];
    }
    
    [datebaseToll closeDatabase];
}

#pragma mark - get天气数据
-(void) getWeather:(NSNotification *)message {
    [message.object deleteCharactersInRange:[message.object rangeOfString:@"市"]];
    NSString *url = [NSString stringWithFormat:@"http://wthrcdn.etouch.cn/weather_mini?city=%@",message.object];
    NSLog(@"%@",url);
   [YYLAFNetTool GETNetWithUrl:url body:nil headerFile:nil response:YYLJSON success:^(id result) {
      self.weatherModel = [[YXWWeatherModel alloc] initWithDataSource:result[@"data"]];
       self.time.weatherModel = self.weatherModel;
      NSLog(@"231%@",self.weatherModel.wendu);
    
  } failure:^(NSError *error) {
      
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma marek - 添加返回的Button
- (void) tapAction:(UITapGestureRecognizer *)yy {
    
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
