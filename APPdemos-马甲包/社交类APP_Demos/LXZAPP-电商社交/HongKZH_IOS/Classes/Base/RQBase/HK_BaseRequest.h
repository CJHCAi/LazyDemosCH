//
//  HK_BaseRequest.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/4/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HJNetwork.h"

//#import "AFNetworkingBaseRequest.h"
#import "UrlConst.h"
#import "ViewModelLocator.h"
#import "HK_Header.h"
//#import <NSString-UrlEncode/NSString+URLEncode.h>

typedef void(^BuinessCompletionBlock)(HJResponseSerializer responseType, NSInteger statusCode,id responseObject);
typedef void(^SuccessBlock)(NSError *error, HJNetworkStatusType statusCode,id responseObject);

@interface HK_BaseRequest : HJNetwork
@property(nonatomic , copy)NSDictionary* dicParameters;
@property(nonatomic , assign)BOOL isUseCache;
- (instancetype)initWithDic:(NSDictionary*)parameters;
@property (nonatomic,strong) BuinessCompletionBlock buinessCompletionBlock;
@property (nonatomic,strong) SuccessBlock successBlock;
@property(nonatomic,copy)NSString* url;
-(void)businessBlock:(BuinessCompletionBlock)businessBlock;
@property(nonatomic , assign)BOOL isUseAddModel;

@property (nonatomic,copy) NSString *cerpath;

@property (nonatomic,assign) HJResponseSerializer responseType;  //响应协议类型
@property (nonatomic,assign) HJRequestSerializer  requestType  NS_AVAILABLE_IOS(5_0);  //请求协议类型
-(void)buildPostRequest:(NSString *)urlString body:(NSDictionary *)body;
-(void)prepareRequest;
+(void)buildPostRequest:(NSString *)urlString body:(NSDictionary *)body success:(void (^_Nullable)(id _Nullable responseObject))success failure:(void (^_Nullable)(NSError *_Nullable error))failure;

/**
 上传图片

 @param urlString imgeUrl
 @param body @{@"image":,@"imageURL"}
 @param progres progres description
 @param callback callback description
 */
+(void)buildPostImageRequest:(NSString *)urlString body:(NSDictionary *)body  progress:(HJHttpProgress)progres callback:(HJHttpRequest)callback;
+(void)getParameterWithDict:(NSDictionary*)dic;
@end
