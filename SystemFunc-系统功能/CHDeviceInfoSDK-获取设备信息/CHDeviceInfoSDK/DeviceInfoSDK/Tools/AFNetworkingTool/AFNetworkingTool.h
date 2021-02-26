//
//  AFNetWorkingTool.h
//  Test
//
//  Created by 火虎MacBook on 2020/7/9.
//  Copyright © 2020 蔡建华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CodeSuccessBlock)(NSInteger code,id _Nullable json);
typedef void (^SuccessBlock)(id _Nullable json);
typedef void (^FailureBlock)(NSError * _Nullable error);
typedef void (^ProgressBlock)(CGFloat progress);

typedef NS_ENUM(NSInteger,RequestType) {
    POST = 0,
    GET = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface AFNetworkingTool : NSObject

+ (instancetype)sharedInstance;

/**POST Body传递参数*/
-(void)postRequestRBodyParmasWithUrl:(NSString *)url params:(NSDictionary *)params succeed:(CodeSuccessBlock)succeedBlock failure:(FailureBlock)failureBlock;

/**POST 或GET*/
- (void)requestWithType:(RequestType)type  url:(NSString *)url parameters:(NSDictionary *)params success:(CodeSuccessBlock)success failure:(FailureBlock)failure;

/**GET请求*/
- (void)GET:(NSString *)url parameters:(NSDictionary *)params success:(CodeSuccessBlock)success failure:(FailureBlock)failure;

/**POST请求*/
- (void)POST:(NSString *)url parameters:(NSDictionary *)params success:(CodeSuccessBlock)success failure:(FailureBlock)failure;

/**上传单张图片*/
-(void)uploadImageWithUrl:(NSString *)url params:(NSDictionary *)params fileKey:(NSString *)fileKey image:(UIImage *)image progress:(ProgressBlock)progress  success:(CodeSuccessBlock)success failure:(FailureBlock)failure;
/**上传多张图片*/
-(void)uploadImagesWithUrl:(NSString *)url params:(NSMutableDictionary *)params fileKey:(NSString *)fileKey images:(NSMutableArray <UIImage *>*)imagesArray progress:(ProgressBlock)progress success:(CodeSuccessBlock)success failure:(FailureBlock)failure;

/**下载文件*/
-(void)downloadWithurl:(NSString *)url progress:(ProgressBlock)progress success:(CodeSuccessBlock)success failure:(FailureBlock)failure;
@end

NS_ASSUME_NONNULL_END
