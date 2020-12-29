//
//Created by ESJsonFormatForMac on 18/10/12.
//

#import <Foundation/Foundation.h>
#import "HKBaseModelRespone.h"
@class UploadsData;
@interface HKUploadRespone : HKBaseModelRespone

@property (nonatomic, copy) NSString *msg;

@property (nonatomic, strong) UploadsData *data;

@property (nonatomic,assign) int time;
//@property (nonatomic, assign) NSInteger code;
-(BOOL)isLoad;
@end
@interface UploadsData : NSObject

@property (nonatomic, copy) NSString *accessKeySecret;

@property (nonatomic, copy) NSString *accessKeyId;

@property (nonatomic, copy) NSString *expiration;

@property (nonatomic, copy) NSString *securityToken;

@end

