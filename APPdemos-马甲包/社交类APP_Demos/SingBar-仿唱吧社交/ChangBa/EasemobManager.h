//
//  EasemobManager.h
//  环信测试
//
//  Created by tarena on 16/9/1.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EaseMob.h>
@interface EasemobManager : NSObject<EMChatManagerDelegate,IEMChatProgressDelegate>
@property (nonatomic, strong)NSMutableArray *requets;
+(EasemobManager *)shareManager;


-(void)registerWithName:(NSString *)name andPW:(NSString *)pw;

-(void)logingWithName:(NSString *)name andPW:(NSString *)pw;

-(void)logout;

-(void)addFriendWithName:(NSString *)name;


-(void)deleteFirendWithName:(NSString *)name;

-(EMMessage *)sendMessageWithText:(NSString *)text andUsername:(NSString *)username;
-(EMMessage *)sendMessageWithImage:(UIImage *)image andUsername:(NSString *)username;
-(EMMessage *)sendMessageWithVoiceData:(NSData *)data andTime:(float)time andUsername:(NSString *)username;
@end
