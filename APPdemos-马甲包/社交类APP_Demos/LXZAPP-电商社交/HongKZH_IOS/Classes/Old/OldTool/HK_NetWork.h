//
//  HK_NetWork.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/16.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HK_UploadImagesModel.h"
#import "HJNetwork.h"
#import "HK_ProductSpecifications.h"
#import "MyGoodsRespone.h"
#import "HKUpdataFromDataModel.h"
@class YYCache, AFHTTPSessionManager;


/**请求的Block*/
typedef void(^HJHttpRequest)(id responseObject, NSError *error);

/**下载的Block*/
typedef void(^HJHttpDownload)(NSString *path, NSError *error);

/*上传或者下载的进度*/
typedef void(^HJHttpProgress)(NSProgress *progress);

/**网络状态Block*/
typedef void(^HJNetworkStatus)(HJNetworkStatusType status);



@interface HK_NetWork : NSObject

/**是否按App版本号缓存网络请求内容(默认关闭)*/
+ (void)setCacheVersionEnabled:(BOOL)bFlag;

/**使用自定义缓存版本号*/
+ (void)setCacheVersion:(NSString*)version;

/**输出Log信息开关(默认打开)*/
+ (void)setLogEnabled:(BOOL)bFlag;

/**过滤缓存Key*/
+ (void)setFiltrationCacheKey:(NSArray *)filtrationCacheKey;

/**设置接口根路径, 设置后所有的网络访问都使用相对路径 尽量以"/"结束*/
+ (void)setBaseURL:(NSString *)baseURL;

/** 设置接口请求头 */
+ (void)setHeadr:(NSDictionary *)heder;

/**设置接口基本参数(如:用户ID, Token)*/
+ (void)setBaseParameters:(NSDictionary *)parameters;

/**实时获取网络状态*/
+ (void)getNetworkStatusWithBlock:(HJNetworkStatus)networkStatus;

/**判断是否有网*/
+ (BOOL)isNetwork;

/**是否是手机网络*/
+ (BOOL)isWWANNetwork;

/**是否是WiFi网络*/
+ (BOOL)isWiFiNetwork;

/**取消所有Http请求*/
+ (void)cancelAllRequest;

/**取消指定URL的Http请求*/
+ (void)cancelRequestWithURL:(NSString *)url;

/**设置请求超时时间(默认30s) */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**是否打开网络加载菊花(默认打开)*/
+ (void)openNetworkActivityIndicator:(BOOL)open;


/**
 GET请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)GETWithURL:(NSString *)url
        parameters:(NSDictionary *)parameters
       cachePolicy:(HJCachePolicy)cachePolicy
          callback:(HJHttpRequest)callback;


/**
 POST请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)POSTWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
        cachePolicy:(HJCachePolicy)cachePolicy
           callback:(HJHttpRequest)callback;

/**
 HEAD请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)HEADWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
        cachePolicy:(HJCachePolicy)cachePolicy
           callback:(HJHttpRequest)callback;


/**
 PUT请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)PUTWithURL:(NSString *)url
        parameters:(NSDictionary *)parameters
       cachePolicy:(HJCachePolicy)cachePolicy
          callback:(HJHttpRequest)callback;



/**
 PATCH请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)PATCHWithURL:(NSString *)url
          parameters:(NSDictionary *)parameters
         cachePolicy:(HJCachePolicy)cachePolicy
            callback:(HJHttpRequest)callback;


/**
 DELETE请求
 
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)DELETEWithURL:(NSString *)url
           parameters:(NSDictionary *)parameters
          cachePolicy:(HJCachePolicy)cachePolicy
             callback:(HJHttpRequest)callback;


/**
 自定义请求方式
 
 @param method 请求方式(GET, POST, HEAD, PUT, PATCH, DELETE)
 @param url 请求地址
 @param parameters 请求参数
 @param cachePolicy 缓存策略
 @param callback 请求回调
 */
+ (void)HTTPWithMethod:(HJRequestMethod)method
                   url:(NSString *)url
            parameters:(NSDictionary *)parameters
           cachePolicy:(HJCachePolicy)cachePolicy
              callback:(HJHttpRequest)callback;


/**
 上传文件
 
 @param url 请求地址
 @param parameters 请求参数
 @param name 文件对应服务器上的字段
 @param filePath 文件路径
 @param progress 上传进度
 @param callback 请求回调
 */
+ (void)uploadFileWithURL:(NSString *)url
               parameters:(NSDictionary *)parameters
                     name:(NSString *)name
                 filePath:(NSString *)filePath
                 progress:(HJHttpProgress)progress
                 callback:(HJHttpRequest)callback;



/**
 上传文件+图片

 @param url 地址
 @param parameters 参数
 @param name 文件对应字段
 @param filePath 文件名
 @param images 保存的是数组,数组装的是图片封装类
 @param progress 进度
 @param callback 回调
 */
+ (void)uploadFileWithURL:(NSString *)url
               parameters:(NSDictionary *)parameters
                     name:(NSString *)name
                 filePath:(NSString *)filePath
                   images:(NSMutableArray<NSMutableArray<HK_UploadImagesModel *> *> *)images
                 progress:(HJHttpProgress)progress callback:(HJHttpRequest)callback;


/**
 上传图片文件
 
 @param url 请求地址
 @param parameters 请求参数
 @param images 图片数组
 @param name 文件对应服务器上的字段
 @param fileName 文件名
 @param mimeType 图片文件类型：png/jpeg(默认类型)
 @param progress 上传进度
 @param callback 请求回调
 */
+ (void)uploadImageURL:(NSString *)url
            parameters:(NSDictionary *)parameters
                images:(NSArray<UIImage *> *)images
                  name:(NSString *)name
              fileName:(NSString *)fileName
              mimeType:(NSString *)mimeType
              progress:(HJHttpProgress)progress
              callback:(HJHttpRequest)callback;

/**
 添加商品专用接口
 
 @param url 请求地址
 @param parameters 请求参数
 @param images 图片数组
 @param name 文件对应服务器上的字段
 @param fileName 文件名
 @param mimeType 图片文件类型：png/jpeg(默认类型)
 @param specifications 商品规格
 @param progress 上传进度
 @param callback 请求回调
 */
+ (void)uploadImageURL:(NSString *)url
            parameters:(NSDictionary *)parameters
                images:(NSArray<UIImage *> *)images
                  name:(NSString *)name
              fileName:(NSString *)fileName
              mimeType:(NSString *)mimeType
        specifications:(NSArray <HK_ProductSpecifications *> *)specifications
              progress:(HJHttpProgress)progress
              callback:(HJHttpRequest)callback;


/**
 支持formdata请求

 @param url <#url description#>
 @param parameters <#parameters description#>
 @param dataArr 字典数组
 @param callback <#callback description#>
 */
+ (void)postWithURL:(NSString *)url
         parameters:(NSDictionary *)parameters
      formDataArray:(NSArray<NSDictionary *> *)dataArr
           callback:(HJHttpRequest)callback;
+ (void)postWithNewURL:(NSString *)url
         parameters:(NSDictionary *)parameters
      formDataArray:(NSArray<NSDictionary *> *)dataArr
           callback:(HJHttpRequest)callback;
/**
 上传图片文件(多参数)
 
 @param url 请求地址
 @param parameters 请求参数
 @param images 图片数组
 @param mimeType 图片文件类型：png/jpeg(默认类型)
 @param progress 上传进度
 @param callback 请求回调
 */
+ (void)uploadImageURL:(NSString *)url
            parameters:(NSDictionary *)parameters
                images:(NSMutableDictionary<NSString *,HK_UploadImagesModel *> *)images
              mimeType:(NSString *)mimeType
              progress:(HJHttpProgress)progress
              callback:(HJHttpRequest)callback;


/**
 下载文件
 
 @param url 请求地址
 @param fileDir 文件存储的目录(默认存储目录为Download)
 @param progress 文件下载的进度信息
 @param callback 请求回调
 */
+ (void)downloadWithURL:(NSString *)url
                fileDir:(NSString *)fileDir
               progress:(HJHttpProgress)progress
               callback:(HJHttpDownload)callback;


#pragma mark -- 网络缓存

/**
 *  获取YYCache对象
 */
+ (YYCache *)getYYCache;

/**
 *  异步缓存网络数据,根据请求的 URL与parameters
 *  做Key存储数据, 这样就能缓存多级页面的数据
 *
 *  @param httpData   服务器返回的数据
 *  @param url        请求的URL地址
 *  @param parameters 请求的参数
 */
+ (void)setHttpCache:(id)httpData url:(NSString *)url parameters:(NSDictionary *)parameters;

/**
 *  根据请求的 URL与parameters 异步取出缓存数据
 *
 *  @param url        请求的URL
 *  @param parameters 请求的参数
 *  @param block      异步回调缓存的数据
 *
 */
+ (void)httpCacheForURL:(NSString *)url parameters:(NSDictionary *)parameters withBlock:(void(^)(id responseObject))block;

/**
 *  磁盘最大缓存开销大小 bytes(字节)
 */
+ (void)setCostLimit:(NSInteger)costLimit;

/**
 *  获取网络缓存的总大小 bytes(字节)
 */
+ (NSInteger)getAllHttpCacheSize;

/**
 *  获取网络缓存的总大小 bytes(字节)
 *  推荐使用该方法 不会阻塞主线程，通过block返回
 */
+ (void)getAllHttpCacheSizeBlock:(void(^)(NSInteger totalCount))block;

/**
 *  删除所有网络缓存
 */
+ (void)removeAllHttpCache;

/**
 *  删除所有网络缓存
 *  推荐使用该方法 不会阻塞主线程，同时返回Progress
 */
+ (void)removeAllHttpCacheBlock:(void(^)(int removedCount, int totalCount))progress
                       endBlock:(void(^)(BOOL error))end;

#pragma mark -- 重置AFHTTPSessionManager相关属性

/**
 *  获取AFHTTPSessionManager对象
 */
+ (AFHTTPSessionManager *)getAFHTTPSessionManager;

/**
 设置网络请求参数的格式:默认为JSON格式
 
 @param requestSerializer HJRequestSerializerJSON---JSON格式  HJRequestSerializerHTTP--HTTP
 */
+ (void)setRequestSerializer:(HJRequestSerializer)requestSerializer;



/**
 设置服务器响应数据格式:默认为JSON格式
 
 @param responseSerializer HJResponseSerializerJSON---JSON格式  HJResponseSerializerHTTP--HTTP
 
 */
+ (void)setResponseSerializer:(HJResponseSerializer)responseSerializer;


/**
 设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;


/**
 配置自建证书的Https请求，参考链接:http://blog.csdn.net/syg90178aw/article/details/52839103
 
 @param cerPath 自建https证书路径
 @param validatesDomainName 是否验证域名(默认YES) 如果证书的域名与请求的域名不一致，需设置为NO
 服务器使用其他信任机构颁发的证书也可以建立连接，但这个非常危险，建议打开 .validatesDomainName=NO,主要用于这种情况:客户端请求的是子域名，而证书上是另外一个域名。因为SSL证书上的域名是独立的
 For example:证书注册的域名是www.baidu.com,那么mail.baidu.com是无法验证通过的
 */
+ (void)setSecurityPolicyWithCerPath:(NSString *)cerPath validatesDomainName:(BOOL)validatesDomainName;



+ (void)uploadEditImageURL:(NSString *)url
                parameters:(NSDictionary *)parameters
                    images:(NSArray<UIImage *> *)images
                      name:(NSString *)name
                  fileName:(NSString *)fileName
                  mimeType:(NSString *)mimeType
            specifications:(NSArray <HK_ProductSpecifications *> *)specifications
                  progress:(HJHttpProgress)progress
                  callback:(HJHttpRequest)callback;



+(void)updataFileWithURL:(NSString *)url formDataArray:(NSArray<HKUpdataFromDataModel*>*)formArray parameters:(NSDictionary*)parameters
                progress:(HJHttpProgress)progress
                callback:(HJHttpRequest)callback;
@end
