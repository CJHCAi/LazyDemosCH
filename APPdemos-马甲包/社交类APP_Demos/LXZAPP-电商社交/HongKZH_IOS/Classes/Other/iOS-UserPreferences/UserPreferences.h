#import <Foundation/Foundation.h>

@interface UserPreferences : NSObject

+(NSString*)getStringWithKey:(NSString*)key ;
+(NSString*)getStringWithKey:(NSString*)key withDefault:(NSString*)d;
+(void)setString:(NSString*)v withKey:(NSString*)key;
+(BOOL)getBoolWithKey:(NSString*)key;
+(BOOL)getBoolWithKey:(NSString*)key withDefault:(BOOL)d;
+(void)setBool:(BOOL)v withKey:(NSString*)key;
+(int)getIntWithKey:(NSString*)key;
+(int)getIntWithKey:(NSString*)key withDefault:(int)d;
+(void)setInt:(int)v withKey:(NSString*)key;
+(BOOL)keyExists:(NSString*)key;
+(BOOL)keyUndefined:(NSString*)key;
+(BOOL)isKeyUndefinedThenDefine:(NSString*)what;

@end
