//
//  AVCEventManager.h
//  QUSDK
//
//  Created by Worthy on 2017/8/23.
//  Copyright © 2017年 Alibaba Group Holding Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DefaultEventManager [AVCEventManager sharedManager]

typedef NS_ENUM(NSInteger, AVCEvent) {
    AVCEventRecordInit = 2001,
    AVCEventRecordStart,
    AVCEventRecordStopSuccess,
    AVCEventRecordDelete,
    AVCEventRecordFinish,
    AVCEventRecordError,
    AVCEventRecordPaster,
    AVCEventRecordMusic,
    AVCEventRecordFilter,
    AVCEventRecordRate,
    AVCEventRecordBeauty,
    AVCEventRecordPosition,
    AVCEventRecordStop,
    AVCEventEditInit = 3001,
    AVCEventEditFilter = 3005,
    AVCEventEditMV,
    AVCEventEditExportStart = 3011,
    AVCEventEditExportCancel,
    AVCEventEditExportError = 3016,
    AVCEventEditExportFinish,
    AVCEventTranscodeStart = 8001,
    AVCEventTranscodeCancel,
    AVCEventTranscodeError,
    AVCEventTranscodeFinish,
    
    
    AVCEventUploadAddFile = 20001,
    AVCEventUploadStarted,
    AVCEventUploadSucceed,
    AVCEventUploadFailed,
    AVCEventUploadPartStarted,
    AVCEventUploadPartFailed,
    AVCEventUploadPartCompleted,
    AVCEventUploadCancel,
};

extern NSString * const AVCEventProductKey;
extern NSString * const AVCEventProductPlayer;
extern NSString * const AVCEventProductPusher;
extern NSString * const AVCEventProductMixer;
extern NSString * const AVCEventProductSvideo;
extern NSString * const AVCEventProductUpload;


extern NSString * const AVCEventModuleKey;
extern NSString * const AVCEventModuleSaasPlayer;
extern NSString * const AVCEventModulePaasPlayer;
extern NSString * const AVCEventModuleMixer;
extern NSString * const AVCEventModulePublisher;
extern NSString * const AVCEventModuleSvideoBase;
extern NSString * const AVCEventModuleSvideoStandard;
extern NSString * const AVCEventModuleSvideoPro;
extern NSString * const AVCEventModuleUploader;


extern NSString * const AVCEventSubModuleKey;
extern NSString * const AVCEventSubModulePlay;
extern NSString * const AVCEventSubModuleDownload;
extern NSString * const AVCEventSubModuleRecord;
extern NSString * const AVCEventSubModuleCut;
extern NSString * const AVCEventSubModuleEdit;
extern NSString * const AVCEventSubModuleUpload;

extern NSString * const AVCEventVersionKey;


@interface AVCEventManager : NSObject

@property (nonatomic, copy) NSString *requestID;
// 是否开启
@property (nonatomic, assign) BOOL enabled;
// logstore
@property (nonatomic, copy) NSString *logstore;

+ (instancetype)sharedManager;

- (instancetype)newInstance:(NSString *)logstore;

- (void)sendEvent:(AVCEvent)event params:(NSDictionary *)params __attribute__((deprecated("This method will not send necessary common parameters such as sdk version.")));

- (void)sendEvent:(AVCEvent)event params:(NSDictionary *)params commonParams:(NSDictionary *)commonParams;

- (void)refreshRequestID;

@end
