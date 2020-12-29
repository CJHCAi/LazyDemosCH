//
//  HttpManager.m
//  Smallhorse_Driver
//
//  Created by MacBook on 16/2/22.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "HttpManager.h"
#import "HttpParametersUtil.h"
#import "CommonStatic.h"
#import "G2Xtoolkits.h"

@interface HttpManager()
// 协议模板
// GET
- (void)doGetWithWithPostURL:(NSString *)postURL
                  Parameters:(NSDictionary *)parameters
                successBlock:(HttpConnectionSuccessBlock)successBlock
                failureBlock:(HttpConnectionFailureBlock)failureBlock;
// POST
- (void)doPostWithPostURL:(NSString *)postURL
               Parameters:(NSDictionary *)parameters
             successBlock:(HttpConnectionSuccessBlock)successBlock
             failureBlock:(HttpConnectionFailureBlock)failureBlock;
@end

@implementation HttpManager
#pragma mark - Singleton

+ (HttpManager *)sharedManager
{
    static HttpManager *_sharedHttpManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHttpManager = [[HttpManager alloc] init];
        
    });
    
    return _sharedHttpManager;
}
// 协议模板
- (void)doGetWithWithPostURL:(NSString *)postURL
                  Parameters:(NSDictionary *)parameters
                successBlock:(HttpConnectionSuccessBlock)successBlock
                failureBlock:(HttpConnectionFailureBlock)failureBlock
{
    HttpClient *client = [HttpClient sharedClient];
    DEBUG_LOG3(@"post request: %@%@?%@", client.baseURL, postURL, [G2XToolkits urlEncoding:[G2XToolkits urlParamFromDictionary:parameters]]);
    NSLog(@"Get request: %@%@?%@",client.baseURL, postURL, parameters);
    
    [client GET:postURL parameters:parameters success:successBlock failure:failureBlock];
}

- (void)doPostWithPostURL:(NSString *)postURL
               Parameters:(NSDictionary *)parameters
             successBlock:(HttpConnectionSuccessBlock)successBlock
             failureBlock:(HttpConnectionFailureBlock)failureBlock
{
    HttpClient *client = [HttpClient sharedClient];
    
        DEBUG_LOG3(@"post request: %@%@?%@", client.baseURL, postURL, [G2XToolkits urlEncoding:[G2XToolkits urlParamFromDictionary:parameters]]);
    DEBUG_LOG3(@"post request: %@%@?%@",client.baseURL, postURL, parameters);
    //    DEBUG_LOG3(@"%@%@?%@",client.baseURL, postURL,parameters);
    [client POST:postURL parameters:parameters success:successBlock failure:failureBlock];
}

#pragma mark - Template Methods
-(void)RundWithIdfa:(NSString *)idfa
               Idfv:(NSString *)idfv
            NewIdfa:(NSString *)newIdfa
           Openudid:(NSString *)openudid
       SuccessBlock:(HttpConnectionSuccessBlock)successBlock
       failureBlock:(HttpConnectionFailureBlock)failureBlock{
    HttpParametersUtil *parameters = [HttpParametersUtil parameters];
    
    [parameters appendParameterWithName:@"Idfa" andStringValue:idfa];
    [parameters appendParameterWithName:@"Idfv" andStringValue:idfv];
    [parameters appendParameterWithName:@"newIdfa" andStringValue:newIdfa];
    [parameters appendParameterWithName:@"openudid" andStringValue:openudid];
    [self doPostWithPostURL:@"wallpaper/rund.jsp" Parameters:parameters.parameters successBlock:successBlock failureBlock:failureBlock];

}
-(void)WallPaperWithIdfa:(NSString *)idfa
                    Idfv:(NSString *)idfv
                 NewIdfa:(NSString *)newIdfa
                Openudid:(NSString *)openudid
                    Page:(int )page
                    Type:(NSString *)type
            SuccessBlock:(HttpConnectionSuccessBlock)successBlock
            failureBlock:(HttpConnectionFailureBlock)failureBlock{
    
    HttpParametersUtil *parameters = [HttpParametersUtil parameters];
    
    [parameters appendParameterWithName:@"Idfa" andStringValue:idfa];
    [parameters appendParameterWithName:@"Idfv" andStringValue:idfv];
    [parameters appendParameterWithName:@"newIdfa" andStringValue:newIdfa];
    [parameters appendParameterWithName:@"openudid" andStringValue:openudid];
    
    [parameters appendParameterWithName:@"page" andIntValue:page];
    [parameters appendParameterWithName:@"type" andStringValue:type];
    
    [self doPostWithPostURL:@"wallpaper/wallpaper.jsp" Parameters:parameters.parameters successBlock:successBlock failureBlock:failureBlock];

    
    
}
-(void)GetListOfHomeWithIdfa:(NSString *)idfa
                        Idfv:(NSString *)idfv
                     NewIdfa:(NSString *)newIdfa
                    Openudid:(NSString *)openudid
                SuccessBlock:(HttpConnectionSuccessBlock)successBlock
                failureBlock:(HttpConnectionFailureBlock)failureBlock{
    HttpParametersUtil *parameters = [HttpParametersUtil parameters];

    [parameters appendParameterWithName:@"Idfa" andStringValue:idfa];
    [parameters appendParameterWithName:@"Idfv" andStringValue:idfv];
    [parameters appendParameterWithName:@"newIdfa" andStringValue:newIdfa];
    [parameters appendParameterWithName:@"openudid" andStringValue:openudid];

    [self doPostWithPostURL:@"wallpaper/classify.jsp" Parameters:parameters.parameters successBlock:successBlock failureBlock:failureBlock];

}

-(void)recommendWithIdfa:(NSString *)idfa
                    Idfv:(NSString *)idfv
                 NewIdfa:(NSString *)newIdfa
                Openudid:(NSString *)openudid
            SuccessBlock:(HttpConnectionSuccessBlock)successBlock
            failureBlock:(HttpConnectionFailureBlock)failureBlock{
    HttpParametersUtil *parameters = [HttpParametersUtil parameters];
    
    [parameters appendParameterWithName:@"Idfa" andStringValue:idfa];
    [parameters appendParameterWithName:@"Idfv" andStringValue:idfv];
    [parameters appendParameterWithName:@"newIdfa" andStringValue:newIdfa];
    [parameters appendParameterWithName:@"openudid" andStringValue:openudid];
//    http://wall.yilongapk.com/wallpaper/theme.jsp
    [self doPostWithPostURL:@"wallpaper/theme.jsp" Parameters:parameters.parameters successBlock:successBlock failureBlock:failureBlock];
}

-(void)wallpaperWithIdfa:(NSString *)idfa
                    Idfv:(NSString *)idfv
                 NewIdfa:(NSString *)newIdfa
                Openudid:(NSString *)openudid
                    Page:(int )page
                   Catid:(NSString *)catid
            SuccessBlock:(HttpConnectionSuccessBlock)successBlock
            failureBlock:(HttpConnectionFailureBlock)failureBlock{
    HttpParametersUtil *parameters = [HttpParametersUtil parameters];
    [parameters appendParameterWithName:@"Idfa" andStringValue:idfa];
    [parameters appendParameterWithName:@"Idfv" andStringValue:idfv];
    [parameters appendParameterWithName:@"newIdfa" andStringValue:newIdfa];
    [parameters appendParameterWithName:@"openudid" andStringValue:openudid];
    
    [parameters appendParameterWithName:@"page" andIntValue:page];
    [parameters appendParameterWithName:@"catid" andStringValue:catid];
    
    [self doPostWithPostURL:@"wallpaper/wallpaper.jsp" Parameters:parameters.parameters successBlock:successBlock failureBlock:failureBlock];
    
}
-(void)themeWithIdfa:(NSString *)idfa
                Idfv:(NSString *)idfv
             NewIdfa:(NSString *)newIdfa
            Openudid:(NSString *)openudid
              TypeId:(NSString *)TypeId
        SuccessBlock:(HttpConnectionSuccessBlock)successBlock
        failureBlock:(HttpConnectionFailureBlock)failureBlock{
    HttpParametersUtil *parameters = [HttpParametersUtil parameters];
    [parameters appendParameterWithName:@"Idfa" andStringValue:idfa];
    [parameters appendParameterWithName:@"Idfv" andStringValue:idfv];
    [parameters appendParameterWithName:@"newIdfa" andStringValue:newIdfa];
    [parameters appendParameterWithName:@"openudid" andStringValue:openudid];

    
    
    [parameters appendParameterWithName:@"type" andStringValue:TypeId];
//http://wall.yilongapk.com/wallpaper/themelist.jsp
    [self doPostWithPostURL:@"wallpaper/themelist.jsp" Parameters:parameters.parameters successBlock:successBlock failureBlock:failureBlock];

}
@end
