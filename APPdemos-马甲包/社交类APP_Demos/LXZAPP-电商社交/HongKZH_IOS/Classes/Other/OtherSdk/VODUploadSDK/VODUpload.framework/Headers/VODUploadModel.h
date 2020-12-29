//
//  VODUploadModel.h
//  VODUpload
//
//  Created by Leigang on 2016/10/26.
//  Copyright © 2016年 Leigang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VODUploadFileStatus) {
    VODUploadFileStatusReady,
    VODUploadFileStatusUploading,
    VODUploadFileStatusCanceled,
    VODUploadFileStatusPaused,
    VODUploadFileStatusSuccess,
    VODUploadFileStatusFailure
};

typedef NS_ENUM(NSInteger, VODStatus) {
    VODStatusReady,
    VODStatusStarted,
    VODStatusPaused,
    VODStatusCancel,
    VODStatusStoped,
    VODStatusSuccess,
    VODStatusFailure,
    VODStatusExpire
};

@interface OSSConfig : NSObject

@property (nonatomic, strong) NSString* accessKeyId;
@property (nonatomic, strong) NSString* accessKeySecret;
@property (nonatomic, strong) NSString* secretToken;
@property (nonatomic, strong) NSString* expireTime;

@end


@interface VodInfo : NSObject

@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* tags;
@property (nonatomic, copy) NSString* desc;
@property (nonatomic, strong) NSNumber* cateId;
@property (nonatomic, copy) NSString* userData;
@property (nonatomic, copy) NSString* coverUrl;
@property (nonatomic, assign) BOOL isProcess;
@property (nonatomic, assign) BOOL isShowWaterMark;
@property (nonatomic, strong) NSNumber* priority;
@property (nonatomic, copy) NSString* storageLocation;
@property (nonatomic, copy) NSString* templateGroupId;
/**
 获取json字符串
 */
- (NSString*)toJson;


@end


@interface UploadFileInfo : NSObject

@property (nonatomic, copy) NSString* filePath;
@property (nonatomic, copy) NSString* endpoint;
@property (nonatomic, copy) NSString* bucket;
@property (nonatomic, copy) NSString* object;
@property (nonatomic, strong) VodInfo* vodInfo;
@property VODUploadFileStatus state;

@end


@interface VodUploadResult: NSObject
@property (nonatomic, copy) NSString* videoId;
@property (nonatomic, copy) NSString* imageUrl;
@property (nonatomic, copy) NSString* bucket;
@property (nonatomic, copy) NSString* endpoint;
@end

typedef void (^OnUploadSucceedListener) (UploadFileInfo* fileInfo);
typedef void (^OnUploadFinishedListener) (UploadFileInfo* fileInfo, VodUploadResult* result);
typedef void (^OnUploadFailedListener) (UploadFileInfo* fileInfo, NSString *code, NSString * message);
typedef void (^OnUploadProgressListener) (UploadFileInfo* fileInfo, long uploadedSize, long totalSize);
typedef void (^OnUploadTokenExpiredListener) ();
typedef void (^OnUploadRertyListener) ();
typedef void (^OnUploadRertyResumeListener) ();
typedef void (^OnUploadStartedListener) (UploadFileInfo* fileInfo);

@interface VODUploadListener : NSObject

@property (nonatomic, copy) OnUploadSucceedListener success
__attribute__((deprecated("", "use OnUploadFinishedListener to replace")));
@property (nonatomic, copy) OnUploadFinishedListener finish;
@property (nonatomic, copy) OnUploadFailedListener failure;
@property (nonatomic, copy) OnUploadProgressListener progress;
@property (nonatomic, copy) OnUploadTokenExpiredListener expire;
@property (nonatomic, copy) OnUploadRertyListener retry;
@property (nonatomic, copy) OnUploadRertyResumeListener retryResume;
@property (nonatomic, copy) OnUploadStartedListener started;

@end


@interface VODUploadModel : NSObject

@end
