//
//  CommonUtility.h
//  SportForum
//
//  Created by liyuan on 14-6-23.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtility : NSObject

+(CommonUtility *)sharedInstance;

-(NSDate*) convertStringToNSDate:(NSString*) strDate;
-(NSString*)convertBirthdayToAge:(long long)llBirthday;
-(NSString*)convertBirthdayToString:(long long)llBirthday;
-(NSString *) compareCurrentTime:(NSDate*) compareDate;
-(NSString *) compareLastLoginTime:(NSDate*) compareDate;
-(NSString*)convertToActor:(NSString*)strActor;
- (int)getSecondsFromZeroOfNextDay;
-(double)getDistanceBySelfLon:(double) selfLon SelfLantitude:(double) selfLat OtherLon:(double)othLon OtherLat:(double)othLat;

- (UIImage *)createImageWithColor:(UIColor *)color;

//Without Borader
- (UIImage *) ellipseImage: (UIImage *) image withInset: (CGFloat) inset;

//With Border
- (UIImage *) ellipseImage: (UIImage *) image withInset: (CGFloat) inset withBorderWidth:(CGFloat)width withBorderColor:(UIColor*)color;

-(BOOL)isAllowChar:(NSString*)strInput AlowedChars:(NSString*)strAlowChars;

-(NSString*)updateAllowChar:(NSString*)strInput AlowedChars:(NSString*)strAlowChars;

- (BOOL)isPureNumandCharacters:(NSString *)string;

- (double)availableMemory;

- (double)usedMemory;

-(void)sinaWeiBoLogin;

-(void)sinaWeiBoLogout;

-(void)sinaWeiBoShare:(UIImage *)image Content:(NSString*)strContent FinishBlock:(void(^)(int errorCode))finishedBlock;

-(void)playAudioFromName:(NSString*)strAudioName;

- (NSString *)disable_emoji:(NSString *)text;

-(NSUInteger)generateWeightBySex:(NSString*)strSexType Weight:(NSUInteger)nWeight;

-(NSUInteger)generateHeightBySex:(NSString*)strSexType Height:(NSUInteger)nHeight;

+ (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath;

@end
