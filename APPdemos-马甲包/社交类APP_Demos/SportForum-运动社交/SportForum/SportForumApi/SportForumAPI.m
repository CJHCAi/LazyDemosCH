//
//  SportForumAPI.m
//  SportForumApi
//
//  Created by liyuan on 14-6-12.
//  Copyright (c) 2014年 liyuan. All rights reserved.
//

#import "SportForumAPI.h"
#import "SVHTTPRequest.h"
#import "APIConfigure.h"
#import "CommonFunction.h"

#define COMPRESSED_RATE 0.5
#define NO_RESPONSE -1
#define NO_NETWORK @"网络连接超时，请求失败"

__strong static SportForumAPI *singleton = nil;
__strong static NSString *sStrAccessToken = @"";

@implementation SportForumAPI
{
    int m_nExpEffect;
    
    NSString *m_strBasePath;
    NSMutableDictionary *m_dictOperations;
}

-(id)init {
    self = [super init];
    if (self) {
        m_strBasePath = [NSString stringWithFormat:@"%@%@",API_CFG_HTTP_REQUEST_URL,API_HTTP_REQUEST_VERSION];
        [[SVHTTPClient sharedClient] setBasePath:m_strBasePath];
        [SVHTTPClient sharedClient].sendParametersAsJSON = YES;
        [SVHTTPClient sharedClient].timeoutInterval = kRequestTimeOut;
        m_dictOperations = [[NSMutableDictionary alloc]init];
        
        m_nExpEffect = 0;
        
        NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"Profile"];
        NSString* strAccessToken = [dict objectForKey:@"AccessToken"];
        [self setAccessToken:strAccessToken];
    }
    
    return self;
}

+(SportForumAPI *)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

+ (NSString*) stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

-(NSDictionary*)getAllOperation
{
    return m_dictOperations;
}

-(int)getCurEffectScore
{
    return m_nExpEffect;
}

-(void)setCurEffect:(int)nEffect
{
    m_nExpEffect = nEffect;
}

-(void)setAccessToken:(NSString*)strAccessToken
{
    sStrAccessToken = strAccessToken.length > 0 ? strAccessToken : @"";
}

-(NSString*)getAccessToken
{
    return sStrAccessToken;
}

-(BOOL)saveObject:(id)Obj byKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults]setObject:Obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

-(id)getObjectByKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

/*- (void)loginWhenAccessInvalid
{
    NSDictionary * dict = [self getObjectByKey:@"Profile"];
    
    NSString* stringUid = [dict objectForKey:@"uid"];
    NSString* stringPassword = [dict objectForKey:@"Password"];
    NSNumber* numType = [dict objectForKey:@"LoginType"];
    
    int nloginType = login_type_user_pass;
    
    if (numType != nil) {
        nloginType = [numType intValue];
    }
    
    if (stringUid && stringPassword) {
        NSLog(@"Account RSA_ERROR_ACCESS_TOKEN_ERROR, ReLogin with user account! ");
        [[SportForumAPI sharedInstance]accountLoginByUserName:stringUid Verfiycode:stringPassword AccountType:nloginType FinishedBlock:nil];
    }
    else
    {
        NSLog(@"Guest RSA_ERROR_ACCESS_TOKEN_ERROR, ReLogin with guest accout! ");
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:login_guest];
        [self setAccessToken:@""];
        [[SportForumAPI sharedInstance]accountLoginByUserName:@"" Verfiycode:@"" AccountType:login_type_guest FinishedBlock:nil];
    }
}*/

-(int)handleErrorResponse:(NSMutableDictionary*) dictResponse error:(NSError *)error
{
    int nErr = NO_RESPONSE;
    
    if ([dictResponse isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Result From Server Data is %@!", dictResponse);
        
        nErr = [[[dictResponse valueForKey:@"error"] objectForKey:@"error_id"] intValue];
        NSLog(@"Error Code is %d, error message is %@.", nErr, [[dictResponse valueForKey:@"error"] objectForKey:@"error_msg"]);
        
        if (nErr == RSA_ERROR_ACCESS_TOKEN_ERROR) {
            /*NSRange range = [[dictResponse valueForKey:@"req_path"] rangeOfString:urlAccountLogin];
            
            // Contain @"account/login"
            if (range.length > 0) {
                [self setAccessToken:[self getObjectByKey:login_guest]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGIN_ACCESS_TOKEN_ERROR" object:nil];
            }
            //Not Contain @"account/login"
            else
            {
                [self performSelector:@selector(loginWhenAccessInvalid) withObject:nil afterDelay:2];
            }*/
        }
    }
    else if(dictResponse == nil && error != nil)
    {
        NSInteger nCode = [error code];
        
        if (nCode == NSURLErrorTimedOut) {
            NSLog(@"Request Time Out!");
            //nErr = RSA_ERROR_NETWORK_TIME_OUT;
        }
    }
    
    return nErr;
}

-(UIImage*)convertImage:(UIImage*)image {
    
    if(image == nil) {
        return nil;
    }
    
    CGFloat factor = image.size.width / image.size.height;
    CGRect newRect = CGRectZero;
    
    if (factor == 0) {
        factor = 0.1;
    }
    
    if ( image.size.width > 1136 ) {
        newRect.size.width = 1136;
        newRect.size.height = newRect.size.width / factor;
    }
    else {
        newRect.size = image.size;
    }
    
    UIGraphicsBeginImageContext(newRect.size);
    [image drawInRect:newRect blendMode:kCGBlendModePlusDarker alpha:1];
    UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tmpImage;
}

-(SVHTTPRequest*)startHttpReqByMethod:(int)nMethod UrlPath:(NSString*)strUrlPath Parameters:(NSDictionary*)parameters Completion:(SVHTTPRequestCompletionHandler)completionBlock
{
    SVHTTPRequest *request = nil;
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, strUrlPath], parameters);
    
    if (nMethod == SVHTTPRequestMethodGET) {
        request = [[SVHTTPClient sharedClient] GET:strUrlPath parameters:parameters completion:completionBlock];
    }
    else if(nMethod == SVHTTPRequestMethodPOST)
    {
        request = [[SVHTTPClient sharedClient] POST:strUrlPath parameters:parameters completion:completionBlock];
    }

    NSMutableDictionary *dictMethodReqs = [NSMutableDictionary dictionaryWithDictionary:[m_dictOperations objectForKey:strUrlPath]];
    
    if (dictMethodReqs == nil) {
        dictMethodReqs = [[NSMutableDictionary alloc]init];
    }
    
    [dictMethodReqs setObject:request forKey:[SportForumAPI stringWithUUID]];
    [m_dictOperations setObject:dictMethodReqs forKey:strUrlPath];
    
    return request;
}

-(void)individualRequests:(BaseOperation**)baseOperation UrlPath:(NSString*) strUrl Method:(NSUInteger) nType
                Parameters:(NSDictionary*)parameters OpeartionId:(NSString*) strOperationId
                Completion:SVHTTPRequestCompletionHandler
{
    SVHTTPRequest *request = [[SVHTTPRequest alloc] initWithAddress:[NSString stringWithFormat:@"%@%@", m_strBasePath, strUrl]
                                                             method:nType
                                                         parameters:parameters
                                                         completion:SVHTTPRequestCompletionHandler];
    
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.sendParametersAsJSON = YES;
    
    (*baseOperation).requestOperation = request;
    (*baseOperation).operationID = strOperationId;
}

-(BaseOperation*) accountRegisterInPoolsByUserName:(NSString*)username
                                          Password:(NSString*)password
                                          NickName:(NSString*)nickname
                                     FinishedBlock:(void(^)(int errorCode, NSString* accessToken))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:username.length > 0 ? username : @"", kEmail, password.length > 0 ? password : @"", kPassword,
                                        nickname.length > 0 ? nickname : @"", kNikeName, nil];
    
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlAccountRegester], dictRequest);
    
    BaseOperation * baseOperation = [[BaseOperation alloc]init];
    __weak typeof(baseOperation) weakbaseOperation = baseOperation;
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strToken = nil;
        BaseOperation * operation = weakbaseOperation;
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                strToken = [dictResponse objectForKey:kAccessToken];
                [self setAccessToken:strToken];
            }
        }
        
        if (finishedBlock != nil) {
            finishedBlock(nErr, strToken);
        }
        
        NSDictionary *conditionInfo = [NSDictionary dictionaryWithObjectsAndKeys: urlAccountRegester, @"OperationId", operation.taskPoolID, @"TaskPoolId", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:IS_REQUEST_TASKS_FINISHED object:nil userInfo:conditionInfo];
    };
    
    [self individualRequests:&baseOperation UrlPath:urlAccountRegester Method:SVHTTPRequestMethodPOST Parameters:dictRequest
                 OpeartionId:urlAccountRegester Completion:completionHandle];
    return baseOperation;
    
}

-(NSOperation*) accountRegisterByUserName:(NSString*)username
                                 Password:(NSString*)password
                                 NickName:(NSString*)nickname
                            FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* userId, NSString* accessToken))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys: username.length > 0 ? username : @"", kEmail, password.length > 0 ? password : @"", kPassword,
                                        nickname.length > 0 ? nickname : @"", kNikeName, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strToken = nil;
        NSString *strUserId = @"";
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {

            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                strToken = [dictResponse objectForKey:kAccessToken];
                strUserId = [dictResponse objectForKey:kUserId];
                [self setAccessToken:strToken];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            NSString *strDesc = [dictError objectForKey:@"error_desc"];
            strError = strDesc.length > 0 ? [NSString stringWithFormat:@"注册失败，%@", strDesc] : @"注册失败";
        }
        
        if (finishedBlock != nil) {
            finishedBlock(nErr, strError, strUserId, strToken);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlAccountRegester Parameters:dictRequest Completion:completionHandle];

    return request;
}

-(NSOperation*) accountRegisterExById:(NSString*)userId
                             Password:(NSString*)password
                          AccountType:(NSUInteger)nAccountType
                             NickName:(NSString*)nickname
                               ImgUrl:(NSString*)strImgUrl
                              SexType:(NSString*)strSex
                             BirthDay:(long long)lBirthday
                        FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* userId, NSString* accessToken))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys: userId.length > 0 ? userId : @"", kId, password.length > 0 ? password : @"", kPassword, [CommonFunction ConvertLoginTypeToString:(account_login_type)nAccountType], @"type", nickname.length > 0 ? nickname : @"", @"nickname", strImgUrl.length > 0 ? strImgUrl : @"", @"profile", strSex.length > 0 ? strSex : @"", @"gender", @(lBirthday), @"birthday", nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strToken = nil;
        NSString *strUserId = @"";
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {
            
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                strToken = [dictResponse objectForKey:kAccessToken];
                strUserId = [dictResponse objectForKey:kUserId];
                [self setAccessToken:strToken];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            NSString *strDesc = [dictError objectForKey:@"error_desc"];
            strError = strDesc.length > 0 ? [NSString stringWithFormat:@"注册失败，%@", strDesc] : @"注册失败";
        }
        
        if (finishedBlock != nil) {
            finishedBlock(nErr, strError, strUserId, strToken);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlAccountRegesterV2 Parameters:dictRequest Completion:completionHandle];
    
    return request;
}

-(NSOperation*) accountLoginByUserName:(NSString*)username
                            Verfiycode:(NSString*)verfiycode
                           AccountType:(NSUInteger)nAccountType
                         FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* accessToken, NSString* userId, BOOL bRegister, long long lLLoginTime, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:username.length > 0 ? username : @"", kUserId, verfiycode.length > 0 ? verfiycode : @"", kVerfiyCode, [CommonFunction ConvertLoginTypeToString:(account_login_type)nAccountType], kAccountType, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        BOOL bRegister = NO;
        long long lLLoginTime = 0;
        NSString *strError = NO_NETWORK;
        NSString *strToken = nil;
        NSString *strUserId = @"";
        ExpEffect* expEffect = [[ExpEffect alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                strToken = [dictResponse objectForKey:kAccessToken];
                strUserId = [dictResponse objectForKey:kUserId];
                bRegister = [[dictResponse objectForKey:@"register"]boolValue];
                lLLoginTime = [[dictResponse objectForKey:@"last_login_time"]longLongValue];
                [expEffect reflectDataFromOtherObject:[dictResponse objectForKey:@"ExpEffect"]];
                [self setAccessToken:strToken];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            NSString *strDesc = [dictError objectForKey:@"error_desc"];
            strError = strDesc.length > 0 ? [NSString stringWithFormat:@"登录失败，%@", strDesc] : @"登录失败";
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError, strToken, strUserId, bRegister, lLLoginTime, expEffect);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlAccountLogin Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) accountLoginExById:(NSString*)userId
                          Password:(NSString*)password
                       AccountType:(NSUInteger)nAccountType
                     FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* userId, NSString* accessToken))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:userId.length > 0 ? userId : @"", kId, password.length > 0 ? password : @"", kPassword, [CommonFunction ConvertLoginTypeToString:(account_login_type)nAccountType], @"type", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strError = NO_NETWORK;
        NSString *strToken = nil;
        NSString *strUserId = @"";
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                strToken = [dictResponse objectForKey:kAccessToken];
                strUserId = [dictResponse objectForKey:kUserId];
                [self setAccessToken:strToken];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            NSString *strDesc = [dictError objectForKey:@"error_desc"];
            strError = strDesc.length > 0 ? [NSString stringWithFormat:@"登录失败，%@", strDesc] : @"登录失败";
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError, strUserId, strToken);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlAccountLoginV2 Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) accountImportFriendsByUserName:(NSString*)username
                                    Verfiycode:(NSString*)verfiycode
                                        AppKey:(NSString*)strAppKey
                                   AccountType:(NSUInteger)nAccountType
                                 FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:username.length > 0 ? username : @"", kUserId, verfiycode.length > 0 ? verfiycode : @"", kVerfiyCode, [CommonFunction ConvertLoginTypeToString:(account_login_type)nAccountType], kAccountType, strAppKey, kAppKey, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ExpEffect* expEffect = [[ExpEffect alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [expEffect reflectDataFromOtherObject:[dictResponse objectForKey:@"ExpEffect"]];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, expEffect);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlAccountImportFriends Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) accountModifyPassword:(NSString*)strPassword
                          NewPassword:(NSString*)strNewPassword
                        FinishedBlock:(void(^)(int errorCode, NSString* strDescErr))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strPassword, @"password", strNewPassword, @"passwordNew", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlAccountChangePassword Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) accountCheckExistById:(NSString*)userId
                          AccountType:(NSUInteger)nAccountType
                        FinishedBlock:(void(^)(int errorCode, NSString* userId))finishedBlock;
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:userId.length > 0 ? userId : @"", kId,[CommonFunction ConvertLoginTypeToString:(account_login_type)nAccountType], @"type", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strUserId = @"";
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                strUserId = [dictResponse objectForKey:kUserId];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strUserId);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlAccountCheck Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userLogout:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (nErr != NO_RESPONSE)
        {
            [self setAccessToken:@""];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserLogout Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userGetDailyLoginReward:(void(^)(int errorCode, int nLoginedDays, NSMutableArray* arrLoginReward))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        int nLoginedDays = 0;
        NSMutableArray* arrLoginReward = [[NSMutableArray alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                nLoginedDays = [[dictResponse objectForKey:@"continuous_logined_days"]intValue];
                arrLoginReward = [dictResponse objectForKey:@"login_reward_list"];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, nLoginedDays, arrLoginReward);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserGetDailyLoginRewardInfo Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userGetPKPropertiesInfo:(NSString*)strUserId FinishedBlock:(void(^)(int errorCode, int nPhysiqueTimes, int nLiteratureTimes, int nMagicTimes))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId.length > 0 ? strUserId : @"", kUserId, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        int nPhysiqueTimes = 0;
        int nLiteratureTimes = 0;
        int nMagicTimes = 0;
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                nPhysiqueTimes = [[dictResponse objectForKey:@"physique_times"]intValue];
                nLiteratureTimes = [[dictResponse objectForKey:@"literature_times"]intValue];
                nMagicTimes = [[dictResponse objectForKey:@"magic_times"]intValue];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, nPhysiqueTimes, nLiteratureTimes, nMagicTimes);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserGetPKPropertiesInfo Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(BaseOperation*) userGetInfoInPoolsByUserId:(NSString*) strUserId FinishedBlock:(void(^)(int errorCode, UserInfo* userInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId.length > 0 ? strUserId : @"", kUserId, sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserGetInfo], dictRequest);
    
    BaseOperation * baseOperation = [[BaseOperation alloc]init];
    __weak BaseOperation * weakbaseOperation = baseOperation;
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        BaseOperation * operation = weakbaseOperation;
        UserInfo* userInfo = [[UserInfo alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [userInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, userInfo);
        }
        
        NSDictionary *conditionInfo = [NSDictionary dictionaryWithObjectsAndKeys: urlUserGetInfo, @"OperationId", operation.taskPoolID, @"TaskPoolId", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:IS_REQUEST_TASKS_FINISHED object:nil userInfo:conditionInfo];
    };
    
    [self individualRequests:&baseOperation UrlPath:urlUserGetInfo Method:SVHTTPRequestMethodGET Parameters:dictRequest
                 OpeartionId:urlUserGetInfo Completion:completionHandle];
    
    return baseOperation;
}

-(NSOperation*) userGetInfoByUserId:(NSString*) strUserId NickName:(NSString*) strNickName FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, UserInfo* userInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId.length > 0 ? strUserId : @"", kUserId, strNickName.length > 0 ? strNickName : @"", @"nickname", sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strError = NO_NETWORK;
        UserInfo* userInfo = [[UserInfo alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [userInfo reflectDataFromOtherObject:dictResponse];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError, userInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserGetInfo Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userGetPropertiesValue:(NSString*) strUserId FinishedBlock:(void(^)(int errorCode, PropertiesInfo* propertiesInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId.length > 0 ? strUserId : @"", kUserId, sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserGetPropertiesValue], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        PropertiesInfo* propertiesInfo = [[PropertiesInfo alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [propertiesInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, propertiesInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserGetPropertiesValue Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userSetInfoByUpdateInfo:(UserUpdateInfo*) userUpdateInfo FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [userUpdateInfo convertDictionary];
    [dictRequest setObject:sStrAccessToken forKey:kAccessToken];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserSetInfo], dictRequest);

    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strError = NO_NETWORK;
        ExpEffect* expEffect = [[ExpEffect alloc]init];
        
        if (nErr != NO_RESPONSE) {
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
            
            NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
            [expEffect reflectDataFromOtherObject:[dictResponse objectForKey:@"ExpEffect"]];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError, expEffect);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserSetInfo Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userUpdateEquipment:(EquipmentInfo*) equipmentInfo FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableDictionary dictionaryWithObjectsAndKeys:equipmentInfo.run_shoe.data, @"run_shoe", equipmentInfo.ele_product.data, @"ele_product", equipmentInfo.step_tool.data, @"step_tool", nil], kUserEquipInfo, sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserUpdateEquipment], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];

        if (finishedBlock != nil)
        {
            finishedBlock(nErr, nil);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserUpdateEquipment Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userSetLifePhotos:(NSArray*)arrayPics FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:arrayPics, kPicIds, sStrAccessToken, kAccessToken, nil];
    
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserSetLifePhotos], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ExpEffect* expEffect = [[ExpEffect alloc]init];
        
        if (nErr != NO_RESPONSE) {
            NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
            [expEffect reflectDataFromOtherObject:[dictResponse objectForKey:@"ExpEffect"]];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, expEffect);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserSetLifePhotos Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userDelLifePhotoById:(NSString*)strPicId FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strPicId, kPicId, sStrAccessToken, kAccessToken, nil];
    
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserDelLifePhoto], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserDelLifePhoto Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userSetProImageByImageId:(NSString*)imageID
                           FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:imageID.length > 0 ? imageID : @"", kImageId, sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserSetProfileImage], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, nil);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserSetProfileImage Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userEnableAttentionByUserId:(NSArray*)arrUserids Attention:(BOOL)bAttention FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:arrUserids, kUserIds, @(bAttention), kbAttention,  sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserEnableAttention], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError, nil);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserEnableAttention Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userDeFriendByUserId:(NSArray*)arrUserids DeFriend:(BOOL)bDeFriend FinishedBlock:(void(^)(int errorCode, NSString* strDescErr))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:arrUserids, kUserIds, @(bDeFriend), kbDeFriend,  sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserEnableDefriend], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserEnableDefriend Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userGetRelaterdMembersCount:(void(^)(int errorCode, int nFriendCount, int nAttectionCount, int nFansCount, int nDeFriend))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        int nFriendCount = 0;
        int nAttentionCount = 0;
        int nFansCount = 0;
        int nDeFriend = 0;
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                nFriendCount = [[dictResponse objectForKey:@"friend_count"]intValue];
                nAttentionCount = [[dictResponse objectForKey:@"attention_count"]intValue];
                nFansCount = [[dictResponse objectForKey:@"fans_count"]intValue];
                nDeFriend = [[dictResponse objectForKey:@"defriend_count"]intValue];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, nFriendCount, nAttentionCount, nFansCount, nDeFriend);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserGetRelatedMembersCount Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userGetRelaterdByType:(e_related_type)eRelatedType
                          UserId:(NSString*)strUserId
                          FirstPageId:(NSString*)strPageFirstId
                           LastPageId:(NSString*)strPageLastId
                          PageItemNum:(int)nPageItemCount
                        FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:[CommonFunction ConvertRelatedTypeToString:eRelatedType], kMemberType, strUserId, kUserId, strPageFirstId.length > 0 ? strPageFirstId : @"", kPageFirstId, strPageLastId.length > 0 ? strPageLastId : @"", kPageLastId, @(nPageItemCount), kPageItemCount, sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserGetRelatedMembersList], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        LeaderBoardItemList *leaderBoardItemList = [[LeaderBoardItemList alloc]initWithSubClass:@"LeaderBoardItem"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [leaderBoardItemList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, leaderBoardItemList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserGetRelatedMembersList Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userSearchByPageId:(NSString*)strPageFirstId
                                     LastPageId:(NSString*)strPageLastId
                                    PageItemNum:(int)nPageItemCount
                                    IsNearBy:(BOOL)bIsNeerBy
                                    NickName:(NSString*)strNickeName
                                  FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strPageFirstId.length > 0 ? strPageFirstId : @"", kPageFirstId, strPageLastId.length > 0 ? strPageLastId : @"", kPageLastId, @(nPageItemCount), kPageItemCount, @(bIsNeerBy), @"search_nearby", strNickeName, @"search_nickname", sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserSearch], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        LeaderBoardItemList *leaderBoardItemList = [[LeaderBoardItemList alloc]initWithSubClass:@"LeaderBoardItem"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [leaderBoardItemList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, leaderBoardItemList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserSearch Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userArticlesByUserId:(NSString*)strUserId
                         ArticleType:(article_type)eArticleType
                         FirstPageId:(NSString*)strPageFirstId
                          LastPageId:(NSString*)strPageLastId
                         PageItemNum:(int)nPageItemCount
                       FinishedBlock:(void(^)(int errorCode, ArticlesInfo *articlesInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId.length > 0 ? strUserId : @"", kUserId, [CommonFunction ConvertArticleTypeToString:eArticleType], kArticleType, strPageFirstId.length > 0 ? strPageFirstId : @"", kPageFirstId, strPageLastId.length > 0 ? strPageLastId : @"", kPageLastId, @(nPageItemCount), kPageItemCount, sStrAccessToken, kAccessToken, nil];
   SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ArticlesInfo *articlesInfo = [[ArticlesInfo alloc]initWithSubClass:@"ArticlesObject"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [articlesInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, articlesInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserArticles Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userSendDeviceTokenByDeviceId:(NSString*)strDeviceId FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strDeviceId.length > 0 ? strDeviceId : @"", kDeviceToken, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserSendDeviceToken Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userSetPushEnableStatusByDeviceId:(NSString*)strDeviceId IsEnable:(BOOL)bEnable FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strDeviceId.length > 0 ? strDeviceId : @"", kDeviceToken, @(bEnable), kIsEnabled, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserSetPushEnable Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userIsPushEnabledByDeviceId:(NSString*)strDeviceId FinishedBlock:(void(^)(int errorCode, BOOL bEnable))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strDeviceId.length > 0 ? strDeviceId : @"", kDeviceToken, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        BOOL bEnable = NO;
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                bEnable = [[dictResponse objectForKey:kIsEnabled] boolValue];;
            }
        }
        
        if (finishedBlock != nil) {
            finishedBlock(nErr, bEnable);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserIsPushEnabled Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userNewGroupByGroupInfo:(NewGroupInfo*)newGroupInfo FinishedBlock:(void(^)(int errorCode, NSString *strGroupId))finishedBlock
{
    NSMutableDictionary *dictRequest = [newGroupInfo convertDictionary];
    [dictRequest setObject:sStrAccessToken forKey:kAccessToken];

    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strGroupId = nil;
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                strGroupId = [dictResponse objectForKey:kGroupId];
            }
        }
        
        if (finishedBlock != nil) {
            finishedBlock(nErr, strGroupId);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserNewGroup Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userGetMobileFriendsByPhones:(NSArray*)arrPhones
                               FinishedBlock:(void(^)(int errorCode, ImportContactList *importContactList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:arrPhones, kContacts, sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlImportContacts], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ImportContactList *importContactList = [[ImportContactList alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [importContactList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, importContactList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlImportContacts Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userGetRecommendsByPageId:(NSString*)strPageFirstId
                               LastPageId:(NSString*)strPageLastId
                            FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *recommendsList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strPageFirstId.length > 0 ? strPageFirstId : @"", kPageFirstId, strPageLastId.length > 0 ? strPageLastId : @"", kPageLastId, sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserSearch], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        LeaderBoardItemList *recommendsList = [[LeaderBoardItemList alloc]initWithSubClass:@"LeaderBoardItem"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [recommendsList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, recommendsList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserRecommend Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userResetPwdByPhone:(NSString*)strPhoneNum Password:(NSString*)strPwd FinishedBlock:(void(^)(int errorCode, NSString* strDescErr))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strPhoneNum, kPhoneNum, strPwd, kPassword, sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserResetPassword], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserResetPassword Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userShareToFriends:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserShareToFriends], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ExpEffect* expEffect = [[ExpEffect alloc]init];

        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [expEffect reflectDataFromOtherObject:[dictResponse objectForKey:@"ExpEffect"]];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, expEffect);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserShareToFriends Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userGameResultByType:(e_game_type)eGameType GameScore:(NSUInteger)nGameScore FinishedBlock:(void(^)(int errorCode, GameResultInfo* gameResultInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:[CommonFunction ConvertGameTypeToString:eGameType], kGameType, @(3), kPageItemCount, @(nGameScore), kGameScore, sStrAccessToken, kAccessToken, nil];
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlUserGameResults], dictRequest);
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        GameResultInfo* gameResultInfo = [[GameResultInfo alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [gameResultInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, gameResultInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserGameResults Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userIsNikeNameUsed:(NSString*)strNikeName FinishedBlock:(void(^)(int errorCode, BOOL bUsed))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strNikeName, kNikeName, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        BOOL bUsed = NO;
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                bUsed = [[dictResponse objectForKey:kIsUsed] boolValue];;
            }
        }
        
        if (finishedBlock != nil) {
            finishedBlock(nErr, bUsed);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserIsNikeNameUsed Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userPurchaseSuccessFromCoin:(long long)lCoinValue BuyTime:(long long)lBuyTime BuyValue:(NSUInteger)nValue FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(lCoinValue), kCoinValue, @(lBuyTime), @"time", @(nValue), kValue, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ExpEffect* expEffect = [[ExpEffect alloc]init];
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [expEffect reflectDataFromOtherObject:[dictResponse objectForKey:@"ExpEffect"]];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, expEffect);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserPurchaseSuccess Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userGetPayCoinListByFirPagId:(NSString*)strPageFirstId
                                  LastPageId:(NSString*)strPageLastId
                               PageItemCount:(int)nPageItemCount
                               FinishedBlock:(void(^)(int errorCode, PayHistory* payHistory))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strPageFirstId.length > 0 ? strPageFirstId : @"", kPageFirstId,
                                        strPageLastId.length > 0 ? strPageLastId : @"", kPageLastId, @(nPageItemCount), kPageItemCount, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        PayHistory *payHistory = [[PayHistory alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [payHistory reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, payHistory);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserGetPayHistory Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userLeaderBoardByFirPagId:(NSString*)strPageFirstId
                               LastPageId:(NSString*)strPageLastId
                                BoardType:(NSString*)strType
                            PageItemCount:(int)nPageItemCount
                            FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strPageFirstId.length > 0 ? strPageFirstId : @"", kPageFirstId, strPageLastId.length > 0 ? strPageLastId : @"", kPageLastId, strType, @"type", @(nPageItemCount), kPageItemCount, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        LeaderBoardItemList *leaderBoardItemList = [[LeaderBoardItemList alloc]initWithSubClass:@"LeaderBoardItem"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [leaderBoardItemList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, leaderBoardItemList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserLeaderBoard Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userAuthRequestByType:(e_auth_type)eAuthType
                             AuthImgs:(NSArray*)arrImgs
                             AuthDesc:(NSString*)strAuthDesc
                        FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:[CommonFunction ConvertAuthTypeToString:eAuthType], @"auth_type", arrImgs, @"auth_images", strAuthDesc, @"auth_desc", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserAuthRequest Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userAuthStatusByUserId:(NSString*)strUserId
                         FinishedBlock:(void(^)(int errorCode, e_auth_status_type eIdcardStatus, e_auth_status_type eCertStatus, e_auth_status_type eRecordStatus))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId.length > 0 ? strUserId : @"", kUserId, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        e_auth_status_type eIdcardStatus, eCertStatus, eRecordStatus;

        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                eIdcardStatus = [CommonFunction ConvertStringToAuthStatusType:[dictResponse objectForKey:@"id_card"]];
                eCertStatus = [CommonFunction ConvertStringToAuthStatusType:[dictResponse objectForKey:@"cert"]];
                eRecordStatus = [CommonFunction ConvertStringToAuthStatusType:[dictResponse objectForKey:@"record"]];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, eIdcardStatus, eCertStatus, eRecordStatus);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserAuthStatus Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userAuthInfoByType:(e_auth_type)eAuthType
                     FinishedBlock:(void(^)(int errorCode, NSString* strAuthDesc, NSString* strAuthReview, NSArray* arrAuthImgs, e_auth_status_type eAuthStatus))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:[CommonFunction ConvertAuthTypeToString:eAuthType], @"auth_type", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        e_auth_status_type eAuthStatus;
        NSString* strAuthDesc;
        NSString* strAuthReview;
        NSMutableArray* arrAuthImgs = [[NSMutableArray alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                eAuthStatus = [CommonFunction ConvertStringToAuthStatusType:[dictResponse objectForKey:@"auth_status"]];
                strAuthDesc = [dictResponse objectForKey:@"auth_desc"];
                strAuthReview = [dictResponse objectForKey:@"auth_review"];
                arrAuthImgs = [dictResponse objectForKey:@"auth_images"];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strAuthDesc, strAuthReview, arrAuthImgs, eAuthStatus);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserAuthInfo Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userSendHeartByRecordId:(NSString*)strRecordId
                          FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strRecordId, @"record_id", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];

        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserSendHeart Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userReceiveHeartBySendId:(NSString*)strSendId
                           IsAccept:(BOOL)bAccept
                           FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strSendId, @"sender", @(bAccept), @"accept", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserReceiveHeart Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userGetRanks:(void(^)(int errorCode, UserRanks *userRanks))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        UserRanks *userRanks = [[UserRanks alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [userRanks reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, userRanks);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserRanks Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userIsPreSportForm:(void(^)(int errorCode, BOOL isPreSportForm))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        BOOL isPreSportForm = NO;
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                isPreSportForm = [[dictResponse objectForKey:@"is_preSportForm"]boolValue];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, isPreSportForm);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlUserIsPreSportForm Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) userActionByPath:(NSString*)strPath FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strPath.length > 0 ? strPath : @"", @"action", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlUserAction Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) tasksGetInfo:(BOOL)bNext FinishedBlock:(void(^)(int errorCode, TasksCurInfo *tasksCurInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(bNext), @"next", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        TasksCurInfo *tasksCurInfo = [[TasksCurInfo alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [tasksCurInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, tasksCurInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlTasksGet Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) tasksGetResultById:(NSUInteger)nTaskId FinishedBlock:(void(^)(int errorCode, TasksInfo *tasksInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(nTaskId), kTaskId, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        TasksInfo *tasksInfo = [[TasksInfo alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [tasksInfo reflectDataFromOtherObject:[dictResponse objectForKey:@"task_info"]];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, tasksInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlTasksResult Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) tasksGetList:(void(^)(int errorCode, TasksInfoList *tasksInfoList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        TasksInfoList *tasksInfoList = [[TasksInfoList alloc]initWithSubClass:@"TasksInfo"];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [tasksInfoList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, tasksInfoList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlTasksGetList Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) tasksGetInfoByTaskId:(NSUInteger)nTaskId FinishedBlock:(void(^)(int errorCode, TasksInfo *tasksInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(nTaskId), kTaskId, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        TasksInfo *tasksInfo = [[TasksInfo alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [tasksInfo reflectDataFromOtherObject:[dictResponse objectForKey:@"task_info"]];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, tasksInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlTasksGetInfo Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) tasksExecuteByTaskId:(NSUInteger)nTaskId TaskPics:(NSArray*)arrayPics FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(nTaskId), kTaskId, sStrAccessToken, kAccessToken, nil];
    
    if ([arrayPics count] > 0) {
        [dictRequest setObject:arrayPics forKey:kTaskPics];
    }
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ExpEffect* expEffect = [[ExpEffect alloc]init];
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [expEffect reflectDataFromOtherObject:[dictResponse objectForKey:@"ExpEffect"]];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError, expEffect);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlTasksExecute Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) tasksReferrals:(void(^)(int errorCode, TasksReferList* tasksReferList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        TasksReferList *tasksReferList = [[TasksReferList alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [tasksReferList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, tasksReferList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlTasksReferrals Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) tasksShareByUserId:(NSString*)strUserId TaskId:(NSUInteger)nTaskId ShareType:(e_accept_type)eSharedType CostCoin:(long long)lCoin Latitude:(float)fLatitude
                         Longitude:(float)fLongitude AddDesc:(NSString*)strAddDesc MapImgUrl:(NSString*)strUrl RunBeginTime:(long long)lRunTime FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId, @"userid", @(nTaskId), @"task_id", [CommonFunction ConvertAcceptTypeToString:eSharedType], @"type", @(lCoin), @"coin", @(fLatitude), @"latitude", @(fLongitude), @"longitude", strAddDesc, @"addr", strUrl, @"image", @(lRunTime), @"time", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlTasksShare Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) tasksSharedByType:(e_accept_type)eSharedType SenderId:(NSString*)strSenderId ArticleId:(NSString*)strArticleId AddDesc:(NSString*)strAddDesc ImgUrl:(NSString*)strUrl RunBeginTime:(long long)lRunTime IsAccept:(BOOL)bAccept FinishedBlock:(void(^)(int errorCode, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:[CommonFunction ConvertAcceptTypeToString:eSharedType], @"type", strSenderId, @"sender", strArticleId, @"article_id", strAddDesc, @"addr", strUrl, @"image", @(lRunTime), @"time", @(bAccept), @"accept", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ExpEffect* expEffect = [[ExpEffect alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [expEffect reflectDataFromOtherObject:[dictResponse objectForKey:@"ExpEffect"]];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, expEffect);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlTasksShared Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) tasksReferralPassByUserId:(NSString*)strUserId FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId, @"userid", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlTasksReferralPass Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) articleNewByParArticleId:(NSString*)strParArticleId ArticleSegment:(NSArray*) articleSegment ArticleTag:(NSArray*)arrTags Type:(NSString*)strType AtNameList:(NSArray*)arrAtList FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, ExpEffect* expEffect))finishedBlock
{
    NSMutableArray *arraySegment = [[NSMutableArray alloc]init];
    
    for (ArticleSegmentObject *articleSegmentObject in articleSegment) {
        [arraySegment addObject:[articleSegmentObject convertDictionary]];
    }
    
    NSMutableDictionary *dictRequest = dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strParArticleId.length > 0 ? strParArticleId : @"", kParentArticleId, arraySegment, kArticleSegments, arrTags, kArticleTag, strType, @"type", sStrAccessToken, kAccessToken, nil];
    
    if (arrAtList != nil && [arrAtList count] > 0) {
        [dictRequest setObject:arrAtList forKey:@"at"];
    }
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ExpEffect* expEffect = [[ExpEffect alloc]init];
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [expEffect reflectDataFromOtherObject:[dictResponse objectForKey:@"ExpEffect"]];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError, expEffect);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlArticleNew Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) articleDeleteByArticleId:(NSString*) strArticleId FinishedBlock:(void(^)(int errorCode, NSString* strDescErr))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strArticleId.length > 0 ? strArticleId : @"", kArticleId, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }

        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlArticleDelete Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) articleThumbByArticleId:(NSString*)articleID ThumbStatus:(BOOL)blThumb
                          FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:articleID.length > 0 ? articleID : @"", kArticleId, @(blThumb), kThumbStatus, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ExpEffect* expEffect = [[ExpEffect alloc]init];
        NSString *strError = NO_NETWORK;

        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [expEffect reflectDataFromOtherObject:[dictResponse objectForKey:@"ExpEffect"]];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError, expEffect);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlArticleThumb Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) articleIsThumbedByArticleId:(NSString*)articleID FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, BOOL isThumbed))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:articleID.length > 0 ? articleID : @"", kArticleId, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        BOOL isThumbed = NO;
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                isThumbed = [[dictResponse objectForKey:kIsThumbed] boolValue];;
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil) {
            finishedBlock(nErr, strError, isThumbed);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlArticleIsThumbed Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) articleTimeLinesByFirPagId:(NSString*)strPageFirstId
                      LastPageId:(NSString*)strPageLastId
                     PageItemCount:(int)nPageItemCount
                     ArticleTag:(e_article_tag_type) eArticleTagType
                    IsCircle:(BOOL)bAttentionCircle
                   FinishedBlock:(void(^)(int errorCode, ArticlesInfo* articlesInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strPageFirstId.length > 0 ? strPageFirstId : @"", kPageFirstId,
                                        strPageLastId.length > 0 ? strPageLastId : @"", kPageLastId, @(nPageItemCount), kPageItemCount, @"", kArticleTag, @(bAttentionCircle), kIsAttentionCircle,sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ArticlesInfo *articlesInfo = [[ArticlesInfo alloc]initWithSubClass:@"ArticlesObject"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [articlesInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, articlesInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlArticleTimeLines Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) articleGetByArticleId:(NSString*)articleID FinishedBlock:(void(^)(int errorCode, ArticlesObject *articlesObject, NSString* strDescErr))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:articleID.length > 0 ? articleID : @"", kArticleId, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ArticlesObject *articlesObject = [[ArticlesObject alloc]init];
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [articlesObject reflectDataFromOtherObject:dictResponse];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, articlesObject, strError);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlArticleGet Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) articleCommentsByArticleId:(NSString*)articleID
                               FirstPageId:(NSString*)strPageFirstId
                                LastPageId:(NSString*)strPageLastId
                               PageItemNum:(int)nPageItemCount
                               Type:(NSString*)strType
                             FinishedBlock:(void(^)(int errorCode, ArticlesInfo *articlesInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:articleID.length > 0 ? articleID : @"", kArticleId, strPageFirstId.length > 0 ? strPageFirstId : @"", kPageFirstId, strPageLastId.length > 0 ? strPageLastId : @"", kPageLastId, @(nPageItemCount), kPageItemCount, strType, @"type", sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ArticlesInfo *articlesInfo = [[ArticlesInfo alloc]initWithSubClass:@"ArticlesObject"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [articlesInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, articlesInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlArticleComments Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) articleThumbsByArticleId:(NSString*) strArticleId
                               PageIndex:(int)nPageIndex
                           FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strArticleId, kArticleId, @(nPageIndex), kPageIndex, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        LeaderBoardItemList *leaderBoardItemList = [[LeaderBoardItemList alloc]initWithSubClass:@"LeaderBoardItem"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [leaderBoardItemList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, leaderBoardItemList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlArticleThumbList Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) articleRewardsByArticleId:(NSString*) strArticleId
                                PageIndex:(int)nPageIndex
                            FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strArticleId, kArticleId, @(nPageIndex), kPageIndex, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        LeaderBoardItemList *leaderBoardItemList = [[LeaderBoardItemList alloc]initWithSubClass:@"LeaderBoardItem"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [leaderBoardItemList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, leaderBoardItemList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlArticleRewardList Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) articleNewsByArticleId:(NSString*) strArticleId
                         FinishedBlock:(void(^)(int errorCode, NSInteger nNewsCount, NSArray* arrProfilesImgs))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strArticleId.length > 0 ? strArticleId : @"", kArticleId, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSInteger nNewsCount = 0;
        NSMutableArray* arrProfilesImgs = [[NSMutableArray alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                nNewsCount = [[dictResponse objectForKey:@"count"]integerValue];
                arrProfilesImgs = [dictResponse objectForKey:@"profiles"];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, nNewsCount, arrProfilesImgs);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlArticleNews Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) articleRepostByArticleId:(NSString*) strReferArticleId
                                Latitude:(float)fLatitude
                               Longitude:(float)fLongitude
                           FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strReferArticleId.length > 0 ? strReferArticleId : @"", @"refer_article", @(fLatitude), @"latitude", @(fLongitude), @"longitude", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];

        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlArticleRepost Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) recordNewByRecordItem:(SportRecordInfo*)sportRecordInfo RecordId:(NSUInteger)nRecordId Public:(BOOL)bPublic FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* strRecordId, ExpEffect* expEffect))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:[sportRecordInfo convertDictionary], kRecordItem, @(nRecordId), kTaskId, @(bPublic), @"isPublic", sStrAccessToken, kAccessToken, nil];
    
    if (sportRecordInfo.sport_pics.data.count > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[dictRequest objectForKey:kRecordItem]];
        [dict setObject:sportRecordInfo.sport_pics.data forKey:@"sport_pics"];
        [dictRequest setObject:dict forKey:kRecordItem];
    }
    else
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[dictRequest objectForKey:kRecordItem]];
        [dict removeObjectForKey:@"sport_pics"];
        [dictRequest setObject:dict forKey:kRecordItem];
    }
    
    NSLog(@"Request Url is %@, Request Parameters is %@!", [NSString stringWithFormat:@"%@%@", m_strBasePath, urlRecordNew], dictRequest);

    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ExpEffect* expEffect = [[ExpEffect alloc]init];
        NSString *strError = NO_NETWORK;
        NSString *strRecord = @"";
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [expEffect reflectDataFromOtherObject:[dictResponse objectForKey:@"ExpEffect"]];
                strRecord = [dictResponse objectForKey:@"record_id"];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError, strRecord, expEffect);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlRecordNew Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) recordTimeLineByUserId:(NSString*)strUserId
                           FirstPageId:(NSString*)strPageFirstId
                            LastPageId:(NSString*)strPageLastId
                           PageItemNum:(int)nPageItemCount
                           RecordType:(NSString*)strType
                         FinishedBlock:(void(^)(int errorCode, SportRecordInfoList *sportRecordInfoList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId.length > 0 ? strUserId : @"", kUserId, strPageFirstId.length > 0 ? strPageFirstId : @"", kPageFirstId, strPageLastId.length > 0 ? strPageLastId : @"", kPageLastId, @(nPageItemCount), kPageItemCount, strType.length > 0 ? strType : @"", @"type", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        SportRecordInfoList *sportRecordInfoList = [[SportRecordInfoList alloc]initWithSubClass:@"SportRecordInfo"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [sportRecordInfoList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, sportRecordInfoList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlRecordTimeline Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) recordGetById:(NSString*)strRecordId
                FinishedBlock:(void(^)(int errorCode, SportRecordInfo *sportRecordInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strRecordId.length > 0 ? strRecordId : @"", @"record_id", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        SportRecordInfo *sportRecordInfo = [[SportRecordInfo alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [sportRecordInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, sportRecordInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlRecordGet Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) leaderBoardListByQueryType:(board_query_type)eQueryType
                                 QueryInfo:(NSString*)strQueryInfo
                               FirstPageId:(NSString*)strPageFirstId
                                LastPageId:(NSString*)strPageLastId
                               PageItemNum:(int)nPageItemCount
                             FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:[CommonFunction ConvertBoardQueryTypeToString:eQueryType], kQueryType, strQueryInfo.length > 0 ? strQueryInfo : @"", kQueryInfo, strPageFirstId.length > 0 ? strPageFirstId : @"", kPageFirstId, strPageLastId.length > 0 ? strPageLastId : @"", kPageLastId, @(nPageItemCount), kPageItemCount, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        LeaderBoardItemList *leaderBoardItemList = [[LeaderBoardItemList alloc]initWithSubClass:@"LeaderBoardItem"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [leaderBoardItemList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, leaderBoardItemList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlLeaderBoardList Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) leaderBoardGameListByQueryType:(board_query_type)eQueryType
                                      GameType:(e_game_type)eGameType
                                      GameScore:(NSUInteger)nGameScore
                                     PageIndex:(int)nPageIndex
                                 FinishedBlock:(void(^)(int errorCode, LeaderBoardItemList *leaderBoardItemList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:[CommonFunction ConvertBoardQueryTypeToString:eQueryType], kQueryType,[CommonFunction ConvertGameTypeToString:eGameType], kGameType, @(nGameScore), kGameScore, @(nPageIndex), kPageIndex, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        LeaderBoardItemList *leaderBoardItemList = [[LeaderBoardItemList alloc]initWithSubClass:@"LeaderBoardItem"];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [leaderBoardItemList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, leaderBoardItemList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlLeaderBoardGameList Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) recordStatisticsByUserId:(NSString*)strUserId
                           FinishedBlock:(void(^)(int errorCode, RecordStatisticsInfo *recordStatisticsInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId.length > 0 ? strUserId : @"", kUserId, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        RecordStatisticsInfo *recordStatisticsInfo = [[RecordStatisticsInfo alloc]init];
        
        if (nErr != NO_RESPONSE) {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [recordStatisticsInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, recordStatisticsInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlRecordStatistics Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) eventNews:(void(^)(int errorCode, EventNewsInfo* eventNewsInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        EventNewsInfo *eventNewsInfo = [[EventNewsInfo alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [eventNewsInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, eventNewsInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlEventNews Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) eventNewsDetails:(void(^)(int errorCode, EventNewsDetails* eventNewsDetails))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        EventNewsDetails *eventNewsDetails = [[EventNewsDetails alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [eventNewsDetails reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, eventNewsDetails);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlEventNewsDetails Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) eventChangeStatusReadByEventType:(event_type)eEventType EventTypeStr:(NSString*)strTypeStr EventId:(NSString*)strEventId FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:[CommonFunction ConvertEventTypeToString:eEventType], kChatType, strTypeStr.length > 0 ? strTypeStr : @"", @"event",  strEventId, kId, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlEventChangeStatusRead Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) eventNotices:(void(^)(int errorCode, EventNotices* eventNotices))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        EventNotices *eventNotices = [[EventNotices alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [eventNotices reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, eventNotices);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlEventNotices Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) chatSendMessageBySendId:(NSString*)sendToId SendType:(chat_send_type)eSendType Content:(NSString*)strContent FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString*strMsgId))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sendToId, kChatToId, [CommonFunction ConvertSendTypeToString:eSendType], kChatType, strContent.length > 0 ? strContent : @"", kChatContent, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strMessageId = @"";
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                strMessageId = [dictResponse objectForKey:kMessageId];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError, strMessageId);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlChatSendMessage Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) chatRecentChatInfos:(void(^)(int errorCode, ContactInfos* contactInfos))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ContactInfos *contactInfos = [[ContactInfos alloc]initWithSubClass:@"ContactObject"];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [contactInfos reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, contactInfos);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlChatRecentChatInfos Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) chatGetListByUserId:(NSString*)strUserId
                FirstPageId:(NSString*)strPageFirstId
                 LastPageId:(NSString*)strPageLastId
                PageItemCount:(int)nPageItemCount
              FinishedBlock:(void(^)(int errorCode, ChatMessagesList* chatMessagesList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId.length > 0 ? strUserId : @"", kUserId, strPageFirstId.length > 0 ? strPageFirstId : @"", kPageFirstId, strPageLastId.length > 0 ? strPageLastId : @"", kPageLastId, @(nPageItemCount), kPageItemCount, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        ChatMessagesList *chatMessagesList = [[ChatMessagesList alloc]initWithSubClass:@"ChatMessage"];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [chatMessagesList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, chatMessagesList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlChatGetList Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) chatDeleteMessageByUserId:(NSString*)strUserId FinishedBlock:(void(^)(int errorCode, NSString* strDescErr))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strUserId.length > 0 ? strUserId : @"", kUserId, sStrAccessToken, kAccessToken, nil];
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE) {
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlChatDeleteMessage Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*)fileDeleteByIds:(NSArray*)arrFileIds FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    if ([arrFileIds count] > 0) {
        [dictRequest setObject:arrFileIds forKey:fileIds];
    }
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlFileDelete Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*)fileUptoken:(void(^)(int errorCode, NSString* strToken))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *token = @"";
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                token = [dictResponse objectForKey:@"token"];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, token);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlFileUpToken Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*)sysConfig:(void(^)(int errorCode, SysConfig* sysConfig))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        SysConfig* sysConfig = [[SysConfig alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [sysConfig reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, sysConfig);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlSysConfig Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(BaseOperation*) imageUploadByUIImage:(UIImage*)image Width:(NSUInteger)nWidth Height:(NSUInteger)nHeight FinishedBlock:(void(^)(int errorCode, NSString* imageID, NSString* imageURL))finishedBlock
{
    NSData *imageData = UIImageJPEGRepresentation([self convertImage:image], COMPRESSED_RATE);
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:imageData, kFileData, sStrAccessToken, kAccessToken, nil];
    
    NSString * strUrl = [NSString stringWithFormat:@"%@?width=%ld&height=%ld&access_token=%@", urlFileUpload, nWidth, nHeight, sStrAccessToken];
    
    BaseOperation * baseOperation = [[BaseOperation alloc]init];
    __weak BaseOperation * weakbaseOperation = baseOperation;
    NSString *strUUID = [SportForumAPI stringWithUUID];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strFileId = nil;
        NSString *strFileUrl = nil;
        BaseOperation * operation = weakbaseOperation;
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                strFileId = [dictResponse objectForKey:kFileId];
                strFileUrl = [dictResponse objectForKey:kFileUrl];
            }
        }
        
        if (finishedBlock != nil) {
            finishedBlock(nErr, strFileId, strFileUrl);
        }
        
        NSDictionary *conditionInfo = [NSDictionary dictionaryWithObjectsAndKeys: operation.operationID, @"OperationId", operation.taskPoolID, @"TaskPoolId", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:IS_REQUEST_TASKS_FINISHED object:nil userInfo:conditionInfo];
    };

    [self individualRequests:&baseOperation UrlPath:strUrl Method:SVHTTPRequestMethodPOST Parameters:dictRequest
                 OpeartionId:strUUID Completion:completionHandle];
    
    ((SVHTTPRequest*)baseOperation.requestOperation).sendParametersAsJSON = NO;
    return baseOperation;
}

-(NSOperation*) imageUploadByUIImage:(UIImage*)image Width:(NSUInteger)nWidth Height:(NSUInteger)nHeight IsCompress:(BOOL)bIsCompress
                 UploadProgressBlock:(void(^)(NSInteger bytesWritten, NSInteger totalBytes))uploadProgressBlock
                       FinishedBlock:(void(^)(int errorCode, NSString* imageID, NSString* imageURL))finishedBlock
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.0);
    
    if (bIsCompress) {
        imageData = UIImageJPEGRepresentation([self convertImage:image], COMPRESSED_RATE);
    }
    
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:imageData, kFileData, sStrAccessToken, kAccessToken, nil];
    
    NSString * strUrl = [NSString stringWithFormat:@"%@?width=%ld&height=%ld&access_token=%@", urlFileUpload, nWidth, nHeight, sStrAccessToken];
    
    [SVHTTPClient sharedClient].sendParametersAsJSON = NO;
    SVHTTPRequest *request = [[SVHTTPClient sharedClient] POST:strUrl parameters:dictRequest
                                                      progress:^(float progress)
                              {
                                  NSInteger nByteWritten = 0;
                                  NSInteger nTotalBytes = [imageData length];
                                  
                                  nByteWritten = nTotalBytes * progress;
                                  
                                  if (uploadProgressBlock != nil) {
                                      uploadProgressBlock(nByteWritten, nTotalBytes);
                                  }
                              }
                                                    completion:^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
                              {
                                  int nErr = [self handleErrorResponse:response error:error];
                                  NSString *strFileId = nil;
                                  NSString *strFileUrl = nil;
                                  
                                  if (nErr != NO_RESPONSE)
                                  {
                                      if(!nErr)
                                      {
                                          NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                                          strFileId = [dictResponse objectForKey:kFileId];
                                          strFileUrl = [dictResponse objectForKey:kFileUrl];
                                      }
                                  }
                                  
                                  if (finishedBlock != nil) {
                                      finishedBlock(nErr, strFileId, strFileUrl);
                                  }
                              }];
    
    [SVHTTPClient sharedClient].sendParametersAsJSON = YES;
    return request;
}

-(NSOperation*) walletGetAddressesInfo:(void(^)(int errorCode, WalletInfo* walletInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        WalletInfo *walletInfo = [[WalletInfo alloc]initWithSubClass:@"WalletAddressItem"];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [walletInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, walletInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlWalletGet Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) walletGetBalanceInfo:(void(^)(int errorCode, WalletBalanceInfo* walletBalanceInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        WalletBalanceInfo *walletBalanceInfo = [[WalletBalanceInfo alloc]initWithSubClass:@"WalletBalanceItem"];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [walletBalanceInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, walletBalanceInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlWalletBalance Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) walletNewAddress:(void(^)(int errorCode, WalletAddressItem* walletAddressItem))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        WalletAddressItem *walletAddressItem = [[WalletAddressItem alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [walletAddressItem reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, walletAddressItem);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlWalletNewAdd Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) walletTradeBySelfAddress:(NSString*)strFrom TradeTo:(NSString*)strTo TradeType:(e_trade_type)eTradeType ArticleId:(NSString*)strArticleId TradeValue:(long long)lValue FinishedBlock:(void(^)(int errorCode, NSString* strDescErr, NSString* strTxid))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strFrom, kFrom, strTo, kTo, [CommonFunction ConvertTradeTypeToString:eTradeType], kTradeType, strArticleId.length > 0 ? strArticleId : @"", kArticleId, @(lValue), kValue, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        NSString *strTxid = @"";
        NSString *strError = NO_NETWORK;
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                strTxid = [dictResponse objectForKey:@"txid"];
            }
            
            NSMutableDictionary *dictError = [response valueForKey:@"error"];
            strError = [dictError objectForKey:@"error_desc"];
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, strError, strTxid);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodPOST UrlPath:urlWalletSend Parameters:dictRequest Completion:completionHandle];
    return request;
}

-(NSOperation*) walletGetTradeListByAddress:(NSString*)strAdd FinishedBlock:(void(^)(int errorCode, WalletTradeDetailInfo* walletTradeDetailInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strAdd, kAddr, sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        WalletTradeDetailInfo *walletTradeDetailInfo = [[WalletTradeDetailInfo alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [walletTradeDetailInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, walletTradeDetailInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlWalletTxs Parameters:dictRequest Completion:completionHandle];
    return request;
}


-(NSOperation*) videoGetListByPageToken:(long long)lPageToken PageCount:(int)nPageCount FinishedBlock:(void(^)(int errorCode, VideoSearchInfoList* videoSearchInfoList))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(lPageToken), @"pagetoken", @(nPageCount), @"pagecount", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        VideoSearchInfoList *videoSearchInfoList = [[VideoSearchInfoList alloc]initWithSubClass:@"VideoSearchInfo"];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [videoSearchInfoList reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, videoSearchInfoList);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlLeaderBoardVideoList Parameters:dictRequest Completion:completionHandle];
    return request;
}


-(NSOperation*) videoGetInfoByVideoID:(NSString*)strVideoID FinishedBlock:(void(^)(int errorCode, VideoInfo* videoInfo))finishedBlock
{
    NSMutableDictionary *dictRequest = [NSMutableDictionary dictionaryWithObjectsAndKeys:strVideoID, @"videoid", sStrAccessToken, kAccessToken, nil];
    
    SVHTTPRequestCompletionHandler completionHandle = ^(id response, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        int nErr = [self handleErrorResponse:response error:error];
        VideoInfo *videoInfo = [[VideoInfo alloc]init];
        
        if (nErr != NO_RESPONSE)
        {
            if(!nErr)
            {
                NSMutableDictionary *dictResponse = [response valueForKey:@"response_data"];
                [videoInfo reflectDataFromOtherObject:dictResponse];
            }
        }
        
        if (finishedBlock != nil)
        {
            finishedBlock(nErr, videoInfo);
        }
    };
    
    SVHTTPRequest *request = [self startHttpReqByMethod:SVHTTPRequestMethodGET UrlPath:urlLeaderBoardVideoInfo Parameters:dictRequest Completion:completionHandle];
    return request;
}


@end
