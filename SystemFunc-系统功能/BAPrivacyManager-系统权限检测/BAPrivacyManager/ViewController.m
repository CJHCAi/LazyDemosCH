//
//  ViewController.m
//  BAPrivacyManager
//
//  Created by boai on 2017/9/28.
//  Copyright © 2017年 boai. All rights reserved.
//

#import "ViewController.h"

#import "BAKit_PrivacyManager.h"

static NSString * const kCellID = @"BAFoundationViewControllerCell";

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = BAKit_Color_White_pod;
    self.title = @"BAPrivacyManager";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kCellID];
    }
    NSString *msg = [@(indexPath.row + 1).stringValue stringByAppendingString:@"、"];
    cell.textLabel.text = [msg stringByAppendingString:self.dataArray[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            //定位
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfLocationServicesWithBlock:^(BAKit_LocationAuthorizationStatus status) {
                if (status == BAKit_LocationAuthorizationStatus_Authorized)
                {
                    BAKit_ShowAlertWithMsg_ios8(@"已经授权过，无需授权");
                }
                else if (status == BAKit_LocationAuthorizationStatus_NotDetermined)
                {
                    BAKit_ShowAlertWithMsg_ios8(@"第一次授权！");
                }
                else
                {
                    NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%ld", self.dataArray[indexPath.row], status];
                    NSLog(@"%@", msg);
                    BAKit_ShowAlertWithMsg_ios8(msg);
                }
                
            }];
        }
            break;
        case 1:
        {
            //通讯录
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfContactsWithBlock:^(BAKit_PrivacyStatus status, BAKit_PrivacyType type) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%ld", self.dataArray[indexPath.row], status];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
        case 2:
        {
            //日历
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfCalendarsWithBlock:^(BAKit_PrivacyStatus status, BAKit_PrivacyType type) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%ld", self.dataArray[indexPath.row], status];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
        case 3:
        {
            //提醒事项
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfRemindersWithBlock:^(BAKit_PrivacyStatus status, BAKit_PrivacyType type) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%ld", self.dataArray[indexPath.row], status];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
        case 4:
        {
            //照片
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfPhotosWithBlock:^(BAKit_PrivacyStatus status, BAKit_PrivacyType type) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%ld", self.dataArray[indexPath.row], status];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
        case 5:
        {
            //相机
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfCameraWithBlock:^(BAKit_PrivacyStatus status, BAKit_PrivacyType type) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%ld", self.dataArray[indexPath.row], status];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
        case 6:
        {
            //蓝牙共享
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfBluetoothSharingWithBlock:^(BAKit_CBManagerStatus status) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%ld", self.dataArray[indexPath.row], status];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
        case 7:
        {
            //麦克风
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfMicrophoneWithBlock:^(BAKit_PrivacyStatus status, BAKit_PrivacyType type) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%ld", self.dataArray[indexPath.row], status];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
        case 8:
        {
            //语音识别
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfSpeechRecognitionWithBlock:^(BAKit_PrivacyStatus status, BAKit_PrivacyType type) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%ld", self.dataArray[indexPath.row], status];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
        case 9:
        {
            //健康
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfHealthWithBlock:^(BAKit_PrivacyStatus status, BAKit_PrivacyType type) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%ld", self.dataArray[indexPath.row], status];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
        case 10:
        {
            //家庭
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfHomeWithBlock:^(BOOL isHaveHomeAccess) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%d", self.dataArray[indexPath.row], isHaveHomeAccess];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
        case 11:
        {
            //媒体与Apple Music
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfAppleMusicWithBlock:^(BAKit_PrivacyStatus status, BAKit_PrivacyType type) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%ld", self.dataArray[indexPath.row], status];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
        case 12:
        {
            //运动和健身
            [BAPrivacyManagerShared ba_checkAndRequestPrivacyOfMotionAndFitness];
        }
            break;
        case 13:
        {
            //通知权限检测
            [BAPrivacyManagerShared ba_openMessageNotificationServiceWithBlock:^(BOOL isOpenMessageNotification, UIUserNotificationType type) {
                NSString *msg = [NSString stringWithFormat:@"授权类型：%@，授权状态：%d，%ld", self.dataArray[indexPath.row], isOpenMessageNotification, type];
                NSLog(@"%@", msg);
                BAKit_ShowAlertWithMsg_ios8(msg);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return FLT_MIN;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
    
}

#pragma mark - setter / getter
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        self.tableView.backgroundColor = BAKit_Color_Gray_11_pod;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        self.tableView.estimatedRowHeight = 44;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        
        self.tableView.tableFooterView = [UIView new];
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

- (NSArray *)dataArray
{
    if (!_dataArray)
    {
        _dataArray = @[@"定位", @"通讯录",
                       @"日历", @"提醒事项",
                       @"照片", @"相机",
                       @"蓝牙共享", @"麦克风",
                       @"语音识别 >= iOS 10.0",
                       @"健康 >= iOS 8.0",
                       @"家庭 >= iOS 8.0",
                       @"媒体与 Apple Music >= iOS 9.3",
                       @"运动与健身", @"通知权限监测"
                       ];
    }
    return _dataArray;
}

@end
