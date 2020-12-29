//
//  VODUploadSVideoModel.h
//  VODUpload
//
//  Created by Worthy on 2017/11/2.
//  Copyright © 2017年 Leigang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VodSVideoInfo : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* tags;
@property (nonatomic, copy) NSString* desc;
@property (nonatomic, strong) NSNumber* cateId;
@property (nonatomic, assign) BOOL isProcess;
@property (nonatomic, assign) BOOL isShowWaterMark;
@property (nonatomic, strong) NSNumber* priority;
@property (nonatomic, copy) NSString* storageLocation;
@property (nonatomic, copy) NSString* templateGroupId;
@end

@interface VodSVideoUploadResult: NSObject
@property (nonatomic, copy) NSString* videoId;
@property (nonatomic, copy) NSString* imageUrl;
@property (nonatomic, copy) NSString* bucket;
@property (nonatomic, copy) NSString* endpoint;
@end
