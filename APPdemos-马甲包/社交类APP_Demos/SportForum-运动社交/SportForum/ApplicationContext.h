//
//  ApplicationContext.h
//  housefinder
//
//  Created by zhengying on 4/8/13.
//  Copyright (c) 2013 zhengying. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SportForum.h"

#define kSTORE_DEVICE_TOKEN @"kSTORE_DEVICE_TOKEN"

@interface UploadImageInfo : NSObject

@property(strong, nonatomic) UIImage *preImage;
@property(strong, nonatomic) UIImage *upLoadImage;
@property(strong, nonatomic) NSString *upLoadUrl;
@property(assign, nonatomic) BOOL bIsOk;

@end

@interface ApplicationContext : NSObject

+(ApplicationContext *)sharedInstance;
-(UserInfo*)accountInfo;
-(EventNewsInfo*)eventNewsInfo;
-(SysConfig*)systemConfigInfo;
-(NSString*)pkEffectUrlString;

-(BOOL)saveObject:(id)Obj byKey:(NSString*)key;
-(id)getObjectByKey:(NSString*)key;
-(void)setRegUserPath:(NSString*)strPath;
-(NSString*)getRegUserPaths;
-(void)getSysConfigInfo;
-(void)getPreSportFormStatus;
-(BOOL)IsPreSportForm;
-(void)createAccountWithId:(NSString*)strId password:(NSString*)password Type:(NSUInteger)nType nikeName:(NSString*)nikename ProfileUrl:(NSString*)strUrl Gender:(NSString*)strGender Birthday:(long long)lBirthDay FinishedBlock:(void(^)(int errorCode, NSString* strErr, NSString* strUserId))finishedBlock;
-(void)login:(NSString*)strID key:(NSString*)strKey type:(account_login_type)type reset:(BOOL)bResetPwd FinishedBlock:(void(^)(int errorCode, NSString* strErr, NSString* strUserId))finishedBlock;
-(void)logout:(void(^)(int errorCode))finishedBlock;
-(void)getProfileInfo:(NSString*)strId FinishedBlock:(void(^)(int errorCode))finishedBlock;
-(void)checkNewEvent:(void(^)(int errorCode))finishedBlock;
-(void)cancelCurrentRequests:(NSArray*)arrayReuqests;
-(void)upLoadByImageArray:(NSArray*)arrayImage FinishedBlock:(void(^)(NSMutableArray *arrayResult))finishedBlock;

@end
