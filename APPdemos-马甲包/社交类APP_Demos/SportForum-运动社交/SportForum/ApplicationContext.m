//
//  ApplicationContext.m
//  housefinder
//
//  Created by zhengying on 4/8/13.
//  Copyright (c) 2013 zhengying. All rights reserved.
//

#import "ApplicationContext.h"
#import "AppNotification.h"

#define COMPRESSED_RATE 0.5

@implementation UploadImageInfo
@end

__strong static ApplicationContext *singleton = nil;

@implementation ApplicationContext {
    BOOL m_bPreSportForm;
    UserInfo *_userInfo;
    EventNewsInfo *_eventNewsInfo;
    SysConfig *_sysConfigInfo;
    NSTimer * m_timeGetEventNews;
    NSTimer * m_timeGetSysConfig;
    long long _lLoginTime;
    NSInteger _nPkEffectIndex;
    NSMutableArray *_arrUserDefaultsKeys;
    NSMutableArray *_arrUserPaths;
}

-(id)init {
    self = [super init];
    if (self) {
        _userInfo = nil;
        _eventNewsInfo = nil;
        m_timeGetEventNews = nil;
        m_timeGetSysConfig = nil;
        _sysConfigInfo = nil;
        _lLoginTime = 0;
        _nPkEffectIndex = 0;
        m_bPreSportForm = NO;
        _arrUserDefaultsKeys = [[NSMutableArray alloc]init];
        _arrUserPaths = [[NSMutableArray alloc]init];
    }
    
    return self;
}

-(BOOL)saveObject:(id)Obj byKey:(NSString*)key {
    if ([_arrUserDefaultsKeys indexOfObject:key] == NSNotFound) {
        [_arrUserDefaultsKeys addObject:key];
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:Obj forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

-(id)getObjectByKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

-(void)setRegUserPath:(NSString*)strPath
{
    if ([_arrUserPaths indexOfObject:strPath] == NSNotFound) {
        [_arrUserPaths addObject:strPath];
    }
}

-(NSString*)getRegUserPaths
{
    NSMutableString *strPaths = [[NSMutableString alloc]init];
    
    for (NSString *strKeys in _arrUserPaths) {
        [strPaths appendString:strKeys];
        
        if (![[_arrUserPaths lastObject] isEqualToString:strKeys]) {
            [strPaths appendString:@","];
        }
    }
    
    [_arrUserPaths removeAllObjects];
    return strPaths;
}

+(ApplicationContext *)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}

-(UserInfo*)accountInfo {
    int nCurEffset = [[SportForumAPI sharedInstance]getCurEffectScore];
    
    if (_userInfo.proper_info.rankscore < nCurEffset) {
        _userInfo.proper_info.rankscore = nCurEffset;
    }
    
    return _userInfo;
}

-(EventNewsInfo*)eventNewsInfo {
    return _eventNewsInfo;
}

-(NSString*)pkEffectUrlString {
    NSString* strUrl = @"";
    
    if (_sysConfigInfo != nil && _sysConfigInfo.pk_effects.data.count > 0 && _nPkEffectIndex < _sysConfigInfo.pk_effects.data.count) {
        strUrl = _sysConfigInfo.pk_effects.data[_nPkEffectIndex++];
    }
    else
    {
        _nPkEffectIndex = 0;
    }
    
    NSLog(@"PK Effect Url String is %@!", strUrl);
    return strUrl;
}

-(SysConfig*)systemConfigInfo {
    return _sysConfigInfo;
}

-(void)getSysConfigInfo
{
    NSDictionary * dict = [[ApplicationContext sharedInstance] getObjectByKey:@"Profile"];
    
    NSString* strAuthId = [dict objectForKey:@"AuthUserId"];
    NSString* strAccessToken = [dict objectForKey:@"AccessToken"];
    
    if (strAuthId.length > 0 && strAccessToken.length > 0) {
        [[SportForumAPI sharedInstance]sysConfig:^(int errorCode, SysConfig* sysConfig)
         {
             if (errorCode == 0) {
                 _sysConfigInfo = sysConfig;
                 [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_GET_SYSCONFIG_INFO object:nil userInfo:nil];
             }
             else
             {
                 [self restartTimer_getSysConfig];
             }
         }];
    }
}

-(void)getPreSportFormStatus
{
    [[SportForumAPI sharedInstance]userIsPreSportForm:^(int errorCode, BOOL isPreSportForm)
     {
         m_bPreSportForm = isPreSportForm;
     }];
}

-(BOOL)IsPreSportForm
{
    return m_bPreSportForm;
}

-(void)removeAllUserDefaults
{
    for (NSString *strKey in _arrUserDefaultsKeys) {
        if ([strKey isEqualToString:@"Profile"] || [strKey isEqualToString:@"RegProfile"]) {
            continue;
        }
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:strKey];
    }
    
    [_arrUserDefaultsKeys removeAllObjects];
    [_arrUserPaths removeAllObjects];
}

-(void)createAccountWithId:(NSString*)strId password:(NSString*)password Type:(NSUInteger)nType nikeName:(NSString*)nikename ProfileUrl:(NSString*)strUrl Gender:(NSString*)strGender Birthday:(long long)lBirthDay FinishedBlock:(void(^)(int errorCode, NSString* strErr, NSString* strUserId))finishedBlock
{
    [[SportForumAPI sharedInstance]accountRegisterExById:strId Password:password AccountType:nType NickName:nikename ImgUrl:strUrl SexType:strGender BirthDay:lBirthDay FinishedBlock:^void(int errorCode, NSString* strDescErr, NSString* userId, NSString* accessToken)
    {
        if (finishedBlock != nil) {
            finishedBlock(errorCode, strDescErr, userId);
        }
        
        if (errorCode == 0) {
            [self removeAllUserDefaults];

            NSMutableDictionary *profileDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: strId, @"Account", password, @"Password", @(nType), @"LoginType", userId, @"AuthUserId", accessToken, @"AccessToken", nil];
            [[ApplicationContext sharedInstance] saveObject:profileDict byKey:@"Profile"];
            
            if (nType != login_type_weibo) {
                [[ApplicationContext sharedInstance] saveObject:strId byKey:@"AccountName"];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_AUTH_LOGIN_SUCCESS object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@(YES), @"CreateAccount", nil]];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_AUTH_LOGIN_FAILD object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@(YES), @"CreateAccount", nil]];
        }
    }];
}

-(void)login:(NSString*)strID key:(NSString*)strKey type:(account_login_type)type reset:(BOOL)bResetPwd FinishedBlock:(void(^)(int errorCode, NSString* strErr, NSString* strUserId))finishedBlock
{
    [[SportForumAPI sharedInstance]accountLoginExById:strID Password:strKey AccountType:type FinishedBlock:^(int errorCode, NSString* strDescErr, NSString* userId, NSString* accessToken){
        if (finishedBlock != nil) {
            finishedBlock(errorCode, strDescErr, userId);
        }
        
        if (errorCode != 0) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@(errorCode) forKey:@"ErrorCode"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_AUTH_LOGIN_FAILD object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@(NO), @"CreateAccount", nil]];
        }
        else
        {
            if (!bResetPwd && type != login_type_weibo) {
                [[ApplicationContext sharedInstance] saveObject:strID byKey:@"AccountName"];
            }
            
            NSMutableDictionary *profileDict = [NSMutableDictionary dictionaryWithObjectsAndKeys: strID, @"Account", strKey, @"Password", @(type), @"LoginType", userId, @"AuthUserId", accessToken, @"AccessToken", nil];
            [[ApplicationContext sharedInstance] saveObject:profileDict byKey:@"Profile"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_AUTH_LOGIN_SUCCESS object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:@(NO), @"CreateAccount", nil]];
            
            [[SportForumAPI sharedInstance]userGetInfoByUserId:userId NickName:@"" FinishedBlock:^(int errorCode, NSString* strDescErr, UserInfo *userInfo)
             {
                 if (errorCode != 0) {
                     [JDStatusBarNotification showWithStatus:strDescErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                 }
                 else
                 {
                     _userInfo = userInfo;
                     
                     [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_MESSAGE_GET_MAIN_INFO object:nil];
                     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_UPDATE_PROFILE_INFO object:nil];
                 }
             }];
        }
    }];
}

-(void)getProfileInfo:(NSString*)strId FinishedBlock:(void(^)(int errorCode))finishedBlock
{
    if (strId.length > 0) {
        [[SportForumAPI sharedInstance]userGetInfoByUserId:strId NickName:@"" FinishedBlock:^(int errorCode, NSString* strError, UserInfo *userInfo)
         {
             if (errorCode == 0) {
                 _userInfo = userInfo;
             }
             
             if (finishedBlock != nil) {
                 finishedBlock(errorCode);
             }
         }];
    }
}

-(void)logout:(void(^)(int errorCode))finishedBlock{
    [[SportForumAPI sharedInstance]userLogout:^(int errorCode){
        NSDictionary *dictOperationReqs = [[SportForumAPI sharedInstance]getAllOperation];
        
        for (NSString* strMethod in [dictOperationReqs allKeys]) {
            NSMutableDictionary *dictOperations = [dictOperationReqs objectForKey:strMethod];
            
            for (NSString *strUUID in [dictOperations allKeys]) {
                NSOperation* request = [dictOperations objectForKey:strUUID];
                
                if ([request isExecuting]) {
                    [request cancel];
                }
                
                [dictOperations removeObjectForKey:strUUID];
            }
        }

        if(errorCode == 0)
        {
            if ([CommonFunction ConvertStringToLoginType:_userInfo.account_type] == login_type_weibo) {
                [[CommonUtility sharedInstance]sinaWeiBoLogout];
            }
            
            _userInfo = nil;
            _eventNewsInfo = nil;
            _lLoginTime = 0;
            
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
            
            if (m_timeGetEventNews != nil && [m_timeGetEventNews isValid]) {
                [m_timeGetEventNews invalidate];
                m_timeGetEventNews = nil;
            }

            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Profile"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"WeiBoInfo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_LOGOUT_SUCCESS object:nil];
        }
        
        if (finishedBlock != nil) {
            finishedBlock(errorCode);
        }
    }];
}

- (void)restartTimer_getEventNews
{
    if (m_timeGetEventNews != nil && [m_timeGetEventNews isValid]) {
        [m_timeGetEventNews invalidate];
        m_timeGetEventNews = nil;
    }
    
    m_timeGetEventNews = [NSTimer scheduledTimerWithTimeInterval: 10
                                                                  target: self
                                                        selector: @selector(checkNewEvent:)
                                                                userInfo: nil
                                                                 repeats: NO];
}

- (void)restartTimer_getSysConfig
{
    if (m_timeGetSysConfig != nil && [m_timeGetSysConfig isValid]) {
        [m_timeGetSysConfig invalidate];
        m_timeGetSysConfig = nil;
    }
    
    m_timeGetSysConfig = [NSTimer scheduledTimerWithTimeInterval: 1
                                                          target: self
                                                        selector: @selector(getSysConfigInfo)
                                                        userInfo: nil
                                                         repeats: NO];
}

-(void)checkNewEvent:(void(^)(int errorCode))finishedBlock {
    [[SportForumAPI sharedInstance]eventNews:^(int errorCode, EventNewsInfo* eventNewsInfo)
    {
        _eventNewsInfo = nil;
        
        if (errorCode == 0)
        {
            _eventNewsInfo = eventNewsInfo;
            
            NSUInteger nTotalNews = eventNewsInfo.new_chat_count + eventNewsInfo.new_comment_count + eventNewsInfo.new_thumb_count + eventNewsInfo.new_reward_count + eventNewsInfo.new_attention_count;
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:nTotalNews];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFY_MESSAGE_MSG_LIST_UPDATE object:nil userInfo:nil];
        }
        
        if (finishedBlock) {
            finishedBlock(errorCode);
        }
    }];
}

-(void)cancelCurrentRequests:(NSArray*)arrayReuqests
{
    for(NSString *strMethod in arrayReuqests)
    {
        NSMutableDictionary *dictOperations = [[[SportForumAPI sharedInstance]getAllOperation] objectForKey:strMethod];
        
        for (NSString *strUUID in [dictOperations allKeys]) {
            NSOperation* request = [dictOperations objectForKey:strUUID];
            
            if ([request isExecuting]) {
                [request cancel];
            }
            
            [dictOperations removeObjectForKey:strUUID];
        }
    }
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

-(void)upLoadByImageArray:(NSArray*)arrayImage FinishedBlock:(void(^)(NSMutableArray *arrayResult))finishedBlock
{
    NSMutableArray* arrayRequest = [[NSMutableArray alloc]init];
    __block NSMutableArray* arrayResult = [[NSMutableArray alloc]init];
    
    for(UIImage *image in arrayImage) {
        
        NSData *imageData = UIImageJPEGRepresentation([self convertImage:image], COMPRESSED_RATE);
        UIImage* uploadImage = [UIImage imageWithData:imageData];
            
        BaseOperation *uploadOperation = [[SportForumAPI sharedInstance] imageUploadByUIImage:uploadImage Width:0 Height:0
           FinishedBlock:^(int errorCode, NSString *imageID, NSString *imageURL) {
               UploadImageInfo *uploadImageInfo = [[UploadImageInfo alloc]init];
               
                if(errorCode == 0) {
                    uploadImageInfo.preImage = image;
                    uploadImageInfo.upLoadImage = uploadImage;
                    uploadImageInfo.upLoadUrl = imageURL;
                    uploadImageInfo.bIsOk = YES;
                }
                else {
                    uploadImageInfo.preImage = image;
                    uploadImageInfo.upLoadImage = uploadImage;
                    uploadImageInfo.upLoadUrl = nil;
                    uploadImageInfo.bIsOk = NO;
                }
               
               [arrayResult addObject:uploadImageInfo];
        }];
    
        [arrayRequest addObject:uploadOperation];
    }
    
    if ([arrayRequest count] > 0) {
        [[SportForumAPIHelper sharedInstance]SportForumRequestPool:arrayRequest FinishedBlock:^(BOOL bFinished)
         {
             if (bFinished && finishedBlock != nil) {
                 finishedBlock(arrayResult);
            }
         }];
    }
    else
    {
        finishedBlock(arrayResult);
    }
}

@end
