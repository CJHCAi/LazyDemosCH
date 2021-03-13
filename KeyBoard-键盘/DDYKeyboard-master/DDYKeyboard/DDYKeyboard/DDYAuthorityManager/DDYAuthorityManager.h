#import <Foundation/Foundation.h>
// 麦克风/摄像头(相机)权限使用
@import AVFoundation;
// 相册权限使用
@import AssetsLibrary;  // iOS 6-9
@import Photos;         // iOS 8+
// 通讯录权限使用
@import AddressBook;    // iOS 9-
@import Contacts;       // iOS 9+
// 日历/备忘录权限使用
@import EventKit;
// 联网权限使用
@import CoreTelephony;
// 通知权限使用
@import UserNotifications;
// 定位权限使用
@import CoreLocation;
// 语音识别(转文字)权限使用
@import Speech;
// FaceID权限使用
@import LocalAuthentication;
// 健康数据权限使用
@import HealthKit;

/** 通讯录兼容(iOS 9- 和 iOS 9+)权限状态 */
typedef NS_ENUM(NSInteger, DDYContactsAuthStatus) {
    DDYContactsAuthStatusNotDetermined = 0,
    DDYContactsAuthStatusRestricted    = 1,
    DDYContactsAuthStatusDenied        = 2,
    DDYContactsAuthStatusAuthorized    = 3,
};

/** 推送通知兼容(iOS 10+ 和 iOS 8+)权限状态 */
typedef NS_OPTIONS(NSUInteger, DDYPushNotiType) {
    DDYPushNotiTypeBadge   = (1 << 0),
    DDYPushNotiTypeSound   = (1 << 1),
    DDYPushNotiTypeAlert   = (1 << 2),
};

/** 定位 只允许鉴定两种状态  */
typedef NS_ENUM(NSUInteger, DDYCLLocationType) {
    DDYCLLocationTypeAlways = 3,
    DDYCLLocationTypeInUse  = 4,
};

@interface DDYAuthorityManager : NSObject

/**
 麦克风权限 带主动请权
 @param show 无权限时默认提示
 @param success 已授权
 @param fail 无权限
 */
+ (void)ddy_AudioAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(AVAuthorizationStatus authStatus))fail;

/**
 摄像头(相机)权限 带主动请权 使用前最好先判断摄像头是否可用
 */
+ (void)ddy_CameraAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(AVAuthorizationStatus authStatus))fail;

/** 判断设备摄像头是否可用 */
+ (BOOL)isCameraAvailable;

/** 前面的摄像头是否可用 */
+ (BOOL)isFrontCameraAvailable;

/** 后面的摄像头是否可用 */
 + (BOOL)isRearCameraAvailable;

/**
 相册权限 iOS 8+ 带主动请权
 */
+ (void)ddy_AlbumAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(PHAuthorizationStatus authStatus))fail;

/**
 通讯录权限 带主动请权
 */
+ (void)ddy_ContactsAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(DDYContactsAuthStatus authStatus))fail;

/**
 日历权限 带主动请权
 */
+ (void)ddy_EventAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(EKAuthorizationStatus authStatus))fail;

/**
 备忘录权限 带主动请权
 */
+ (void)ddy_ReminderAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(EKAuthorizationStatus authStatus))fail;

/**
 用网络请求方式主动获取一次权限 首次安装才可能联网权限弹窗(如果弹窗时没点击任何信息直接关机，下次启动仍视为首次)
 @param url 要请求的URL 如:www.baidu.com http需设置AST
 */
+ (void)ddy_GetNetAuthWithURL:(NSURL *)url;

/**
 联网权限 iOS 10+ 不带主动请权 http需设置AST
 */
+ (void)ddy_NetAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(CTCellularDataRestrictedState authStatus))fail API_AVAILABLE(ios(10.0));

/**
 推送通知权限 需要在打开 target -> Capabilities —> Push Notifications iOS10+带主动请权，iOS9-不带主动请权
 @param show 无权限时默认提示
 @param success 已授权
 @param fail 未授权 只返回是否有权限推送，不返回具体权限(badge,alert,sound)
 */
+ (void)ddy_PushNotificationAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(void))fail;

/**
 定位权限 不带主动请权 使用前先判断服务是否开启 [CLLocationManager locationServicesEnabled]
 @param type 定位类型 声明:Always可时时定位(包括后台时)，若不需要不建议添加，可能影响上线审核，可做一些声明描述：GPS在后台持续运行，可能降低电池的寿命。
 @param show 无权限时默认提示
 @param success 已授权
 @param fail 未授权 如果是kCLAuthorizationStatusNotDetermined未经弹框(或者弹框未任何操作，例如弹框时关机)，则需特殊处理
 */
+ (void)ddy_LocationAuthType:(DDYCLLocationType)type alertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(CLAuthorizationStatus authStatus))fail;

/**
 语音识别(转文字)权限 带主动请权
 */
+ (void)ddy_SpeechAuthAlertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(SFSpeechRecognizerAuthorizationStatus authStatus))fail API_AVAILABLE(ios(10.0));

/**
 健康数据权限 不带主动请权 使用前先判断健康数据是否可用 [HKHealthStore isHealthDataAvailable]
 @param type HKQuantityTypeIdentifier(NSString *) 要鉴权类型 HKQuantityTypeIdentifierStepCount
 @param show 无权限时默认提示
 @param success 已授权
 @param fail 未授权
 */
+ (void)ddy_HealthAuth:(HKQuantityTypeIdentifier)type alertShow:(BOOL)show success:(void (^)(void))success fail:(void (^)(HKAuthorizationStatus authStatus))fail;

@end
/**
 <!-- http AST -->
 <key>NSAppTransportSecurity</key>
 <dict>
 <key>NSAllowsArbitraryLoads</key>
 <true/>
 </dict>
 
 
 <!-- 权限配置 -->
 <key>NSAppleMusicUsageDescription</key>
 <string>App需要您的同意，才能访问媒体资料库，是否同意？</string>
 <key>NSBluetoothPeripheralUsageDescription</key>
 <string>App需要您的同意，才能访问蓝牙，是否同意？</string>
 <key>NSCalendarsUsageDescription</key>
 <string>App需要您的同意，才能访问日历，是否同意？</string>
 <key>NSCameraUsageDescription</key>
 <string>App需要您的同意，才能使用相机，是否同意？</string>
 <key>NSContactsUsageDescription</key>
 <string>App需要您的同意，才能使用通讯录，是否同意？</string>
 <key>NSHealthShareUsageDescription</key>
 <string>App需要您的同意，才能访问健康分享，是否同意？</string>
 <key>NSHealthUpdateUsageDescription</key>
 <string>App需要您的同意，才能访问健康更新，是否同意？</string>
 <key>NSLocationAlwaysUsageDescription</key>
 <string>App需要您的同意，才能始终访问位置</string>
 <key>NSLocationUsageDescription</key>
 <string>App需要您的同意，才能访问位置，是否同意？</string>
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>App需要您的同意，才能在使用期间访问位置</string>
 <key>NSMicrophoneUsageDescription</key>
 <string>App需要您的同意，才能使用麦克风，是否同意？</string>
 <key>NSMotionUsageDescription</key>
 <string>App需要您的同意，才能访问运动与健身，是否同意？</string>
 <key>NSPhotoLibraryUsageDescription</key>
 <string>App需要您的同意，才能访问相册，是否同意？</string>
 <key>NSPhotoLibraryAddUsageDescription</key>
 <string>App需要您的同意，才能保存图片到相册，是否同意？</string>
 <key>NSRemindersUsageDescription</key>
 <string>App需要您的同意，才能访问提醒事项，是否同意？</string>
 <key>NSSpeechRecognitionUsageDescription</key>
 <string>App需要您的同意，才能使用语音识别，是否同意？</string>
 <key>NSFaceIDUsageDescription</key>
 <string>App需要您的同意，才能使用Face ID，是否同意？</string>
 <key>NSHomeKitUsageDescription</key>
 <string>App需要您的同意，才能使用HomeKit，是否同意？</string>
 <key>NFCReaderUsageDescription</key>
 <string>App需要您的同意，才能使用NFC，是否同意？</string>
 <key>NSSiriUsageDescription</key>
 <string>App需要您的同意，才能使用Siri，是否同意？</string>
 */
