#import "DDYAuthorityManager.h"
// 弹窗使用
#import "AppDelegate.h"

@implementation DDYAuthorityManager

#pragma mark 麦克风权限
+ (void)ddy_AudioAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(AVAuthorizationStatus))fail {
    void (^handleResult)(BOOL, AVAuthorizationStatus) = ^(BOOL isAuthorized, AVAuthorizationStatus authStatus) {
        if (isAuthorized && success) success();
        if (!isAuthorized && fail) fail(authStatus);
        if (!isAuthorized && show) [self showAlertWithAuthName:@"麦克风"];
    };
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == AVAuthorizationStatusNotDetermined) { 
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handleResult(granted, granted ? AVAuthorizationStatusAuthorized : AVAuthorizationStatusDenied);
            });
        }];
    } else  {
       handleResult(authStatus == AVAuthorizationStatusAuthorized, authStatus);
    }
}

#pragma mark 摄像头(相机)权限
+ (void)ddy_CameraAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(AVAuthorizationStatus))fail {
    void (^handleResult)(BOOL, AVAuthorizationStatus) = ^(BOOL isAuthorized, AVAuthorizationStatus authStatus) {
        if (isAuthorized && success) success();
        if (!isAuthorized && fail) fail(authStatus);
        if (!isAuthorized && show) [self showAlertWithAuthName:@"摄像头"];
    };
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handleResult(granted, granted ? AVAuthorizationStatusAuthorized : AVAuthorizationStatusDenied);
            });
        }];
    } else  {
        handleResult(authStatus == AVAuthorizationStatusAuthorized, authStatus);
    }
}

#pragma mark 判断设备摄像头是否可用
+ (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark 前面的摄像头是否可用
+ (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

#pragma mark 后面的摄像头是否可用
+ (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

#pragma mark 相册使用权限(iOS 8+)
+ (void)ddy_AlbumAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(PHAuthorizationStatus))fail {
    void (^handleResult)(BOOL, PHAuthorizationStatus) = ^(BOOL isAuthorized, PHAuthorizationStatus authStatus) {
        if (isAuthorized && success) success();
        if (!isAuthorized && fail) fail(authStatus);
        if (!isAuthorized && show) [self showAlertWithAuthName:@"相册"];
    };
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handleResult(status == PHAuthorizationStatusAuthorized, status);
            });
        }];
    } else {
        handleResult(authStatus == PHAuthorizationStatusAuthorized, authStatus);
    }
}

#pragma mark 通讯录权限
+ (void)ddy_ContactsAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(DDYContactsAuthStatus))fail {
    void (^handleResult)(BOOL, DDYContactsAuthStatus) = ^(BOOL isAuthorized, DDYContactsAuthStatus authStatus) {
        if (isAuthorized && success) success();
        if (!isAuthorized && fail) fail(authStatus);
        if (!isAuthorized && show) [self showAlertWithAuthName:@"通讯录"];
    };
    
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (authStatus == CNAuthorizationStatusNotDetermined) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            [contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handleResult(granted, granted ? DDYContactsAuthStatusAuthorized : DDYContactsAuthStatusDenied);
                });
            }];
        } else if (authStatus == CNAuthorizationStatusRestricted) {
            handleResult(NO, DDYContactsAuthStatusRestricted);
        } else if (authStatus == CNAuthorizationStatusDenied) {
            handleResult(NO, DDYContactsAuthStatusDenied);
        } else if (authStatus == CNAuthorizationStatusAuthorized) {
            handleResult(YES, DDYContactsAuthStatusAuthorized);
        }
    } else {
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        if (authStatus == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handleResult(granted, granted ? DDYContactsAuthStatusAuthorized : DDYContactsAuthStatusDenied);
                });
            });
        } else if (authStatus == kABAuthorizationStatusRestricted) {
            handleResult(NO, DDYContactsAuthStatusRestricted);
        } else if (authStatus == kABAuthorizationStatusDenied) {
            handleResult(NO, DDYContactsAuthStatusDenied);
        } else if (authStatus == kABAuthorizationStatusAuthorized) {
            handleResult(YES, DDYContactsAuthStatusAuthorized);
        }
    }
}

#pragma mark 日历权限
+ (void)ddy_EventAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(EKAuthorizationStatus))fail {
    void (^handleResult)(BOOL, EKAuthorizationStatus) = ^(BOOL isAuthorized, EKAuthorizationStatus authStatus) {
        if (isAuthorized && success) success();
        if (!isAuthorized && fail) fail(authStatus);
        if (!isAuthorized && show) [self showAlertWithAuthName:@"日历"];
    };
    
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    if (authStatus == EKAuthorizationStatusNotDetermined) {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handleResult(granted, granted ? EKAuthorizationStatusAuthorized : EKAuthorizationStatusDenied);
            });
        }];
    } else  {
        handleResult(authStatus == EKAuthorizationStatusAuthorized, authStatus);
    }
}

#pragma mark 备忘录权限
+ (void)ddy_ReminderAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(EKAuthorizationStatus))fail {
    void (^handleResult)(BOOL, EKAuthorizationStatus) = ^(BOOL isAuthorized, EKAuthorizationStatus authStatus) {
        if (isAuthorized && success) success();
        if (!isAuthorized && fail) fail(authStatus);
        if (!isAuthorized && show) [self showAlertWithAuthName:@"备忘录"];
    };
    
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    if (authStatus == EKAuthorizationStatusNotDetermined) {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        [eventStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handleResult(granted, granted ? EKAuthorizationStatusAuthorized : EKAuthorizationStatusDenied);
            });
        }];
    } else  {
        handleResult(authStatus == EKAuthorizationStatusAuthorized, authStatus);
    }
}

/** 关于APP首次安装(卸载重装不会再弹窗)联网权限弹窗，无法得知用户是否点击允许或不允许(苹果没有给出api),所以常规按以下流程自行判断
 *  1.用keychain记录是否是首次安装(和弹窗一致)，若是首次安装则启动APP后进入特定界面(如引导页),如果不是那么严格忽略该步骤。
 *  2.用 -checkNetworkConnectWhenAirplaneModeOrNoWlanCellular 判断是否特殊情况(完全无网络时首次启动APP，不会联网权限弹窗)。
 *  3.若第二步通过(如果不考虑极端情况直接该步骤)，用户有以太网进入则发送网络请求(最好head请求，省流量且更快速)，如果是首次联网则可能弹窗。
 不确定是否弹窗(2G网络，弱网，飞行模式或同时无wifi和蜂窝网络，只wifi但wifi并没有以太网等等情况不弹窗)，也不确定如果弹窗用户的选择。
 *  4.进入真正页面,用Reachability(或AFNetworkReachabilityStatusNotReachable或RealReachability)判断网络状态。
 *  5.用 -fetchSSIDInfo 或 -fetchMobileInfo 判断确实存在能使得弹窗的网络。
 *  6.用CTCellularData获取状态，此时粗略得到用户是否授权联网权限。
 */
#pragma mark 用网络请求方式主动获取一次权限
+ (void)ddy_GetNetAuthWithURL:(NSURL *)url {
    // 为了快速请求且流量最小化，这里用Head请求，只获取响应头
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:(url ? url : [NSURL URLWithString:@"https://www.baidu.com"])];
    [request setHTTPMethod:@"HEAD"];
    NSURLSessionDataTask * dataTask =  [session dataTaskWithRequest:request completionHandler:^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error) {
        // 拿到响应头信息
        NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
        // 解析拿到的响应数据
        NSLog(@"%s_%@\n%@",__FUNCTION__, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],res.allHeaderFields);
    }];
    [dataTask resume];
}

#pragma mark 联网权限 iOS 10+
+ (void)ddy_NetAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(CTCellularDataRestrictedState))fail {
    // CTCellularData在iOS9之前是私有类，但联网权限设置是iOS10开始的
    if (@available(iOS 10.0, *)) {
        void (^handleResult)(BOOL, CTCellularDataRestrictedState) = ^(BOOL isAuthorized, CTCellularDataRestrictedState authStatus) {
            if (isAuthorized && success) success();
            if (!isAuthorized && fail) fail(authStatus);
            if (isAuthorized == kCTCellularDataRestricted && show) [self showAlertWithAuthName:@"网络"];
        };
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"DDYNetAuthorityString"];
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        CTCellularDataRestrictedState authState = cellularData.restrictedState;
        if (authState == kCTCellularDataNotRestricted) {
            handleResult(YES, authState);
        } else if (authState == kCTCellularDataRestricted) {
            handleResult(NO, authState);
        } else {
            handleResult(NO, authState);
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self ddy_GetNetAuthWithURL:nil];
            });
        }
        // 网络权限更改回调,如果不想每次改变都回调那记得置nil
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (state == kCTCellularDataNotRestricted) {
                    if (authState != state) handleResult(YES, state);
                } else {
                    if (authState != state) handleResult(NO, state);
                    if (show && authState != state) handleResult(NO, authState);
                }
            });
        };
    }
}

#pragma mark 推送通知权限 需要在打开 target -> Capabilities —> Push Notifications
+ (void)ddy_PushNotificationAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(void))fail {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *notiCenter = [UNUserNotificationCenter currentNotificationCenter];
        [notiCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                [notiCenter requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (granted && success) success();
                        if (!granted && fail) fail();
                        if (show && !granted) [self showAlertWithAuthName:@"通知"];
                    });
                }];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (settings.authorizationStatus == UNAuthorizationStatusAuthorized && success) success();
                    if (settings.authorizationStatus != UNAuthorizationStatusAuthorized && fail) fail();
                    if (show && settings.authorizationStatus == UNAuthorizationStatusDenied) [self showAlertWithAuthName:@"通知"];
                });
            }
        }];
    } else {
        if (@available(iOS 8.0, *)) {
            UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
            // UIUserNotificationTypeNone 收到通知不呈现UI，可能无权限也可能还未询问权限
            if (settings.types != UIUserNotificationTypeNone && success) success();
            if (settings.types == UIUserNotificationTypeNone && fail) fail();
            if (show && settings.types == UIUserNotificationTypeNone) [self showAlertWithAuthName:@"通知"];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            if (type != UIRemoteNotificationTypeNone && success) success();
            if (type == UIRemoteNotificationTypeNone && fail) fail();
            if (show && type == UIRemoteNotificationTypeNone) [self showAlertWithAuthName:@"通知"];
#pragma clang diagnostic pop
        }
    }
}

#pragma mark 定位权限
+ (void)ddy_LocationAuthType:(DDYCLLocationType)type alertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(CLAuthorizationStatus))fail{
    // 如果定位服务都未开启，则显示永不(无权限)
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        // kCLAuthorizationStatusAuthorized 在iOS8+是禁止的，这里是为了兼容低版本，如果应用支持的最低版本为iOS8则忽略
        if ([[UIDevice currentDevice] systemVersion].floatValue < 8.0 && authStatus == kCLAuthorizationStatusAuthorized) {
            authStatus = kCLAuthorizationStatusAuthorizedAlways;
        }
#pragma clang diagnostic pop
        if (authStatus == kCLAuthorizationStatusAuthorizedAlways) {
            if (success) success();
        } else if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse && type == DDYCLLocationTypeInUse) {
            if (success) success();
        } else if (authStatus == kCLAuthorizationStatusAuthorizedWhenInUse && type == DDYCLLocationTypeAlways) {
            if (fail) fail(kCLAuthorizationStatusAuthorizedWhenInUse);
        } else {
            if (fail) fail(authStatus);
            if (show) [self showAlertWithAuthName:@"定位"];
        }
    }
}

#pragma mark 语音识别(转文字)权限
+ (void)ddy_SpeechAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(SFSpeechRecognizerAuthorizationStatus))fail {
    void (^handleResult)(BOOL, SFSpeechRecognizerAuthorizationStatus) = ^(BOOL isAuthorized, SFSpeechRecognizerAuthorizationStatus authStatus) {
        if (isAuthorized && success) success();
        if (!isAuthorized && fail) fail(authStatus);
        if (!isAuthorized && show) [self showAlertWithAuthName:@"语音识别(转文字)"];
    };
    SFSpeechRecognizerAuthorizationStatus authStatus = [SFSpeechRecognizer authorizationStatus];
    if (authStatus == SFSpeechRecognizerAuthorizationStatusNotDetermined) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handleResult(status == SFSpeechRecognizerAuthorizationStatusAuthorized, status);
            });
        }];
    } else {
        handleResult(authStatus == SFSpeechRecognizerAuthorizationStatusAuthorized, authStatus);
    }
}

#pragma mark 健康数据权限
+ (void)ddy_HealthAuth:(HKQuantityTypeIdentifier)type alertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(HKAuthorizationStatus))fail {
    if ([HKHealthStore isHealthDataAvailable]) {
        HKHealthStore *healthStore = [[HKHealthStore alloc] init];
        HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:type];
        if (quantityType) {
            HKAuthorizationStatus authStatus = [healthStore authorizationStatusForType:quantityType];
            if (authStatus == HKAuthorizationStatusSharingAuthorized && success) success();
            if (authStatus != HKAuthorizationStatusSharingAuthorized && fail) fail(authStatus);
            if (authStatus != HKAuthorizationStatusSharingAuthorized && show) [self showAlertWithAuthName:@"健康数据"];
        }
    }
}

#pragma mark - 私有方法
#pragma mark 默认无权限提示
+ (void)showAlertWithAuthName:(NSString *)authName
{
    NSString *message = [NSString stringWithFormat:@"请开启%@对%@的权限",[self getAPPName], authName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }]];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (NSString *)getAPPName {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *bundleDisplayName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *bundleName = [infoDictionary objectForKey:@"CFBundleName"];
    return (bundleDisplayName != nil ? bundleDisplayName : bundleName);
}

@end
