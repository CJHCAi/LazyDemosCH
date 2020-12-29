//
//  G2XToolkits.h
//  ZhiHuiAnBao
//
//  Created by Guo xuxing on 4/10/13.
//
//

#import <Foundation/Foundation.h>

@interface G2XToolkits : NSObject

/**------------------------------------------------------------
 /- Date 处理
 -------------------------------------------------------------*/
+ (NSTimeInterval) numberOfSecondsFrom1970:(NSDate*)date;

+ (NSString *)getLocalDateTime;

/**
 format: must be the group of yyyy ,MM and dd .
 result: [0:  today ] [<0: before] [>0: after]
 eg: yyyy-MM-dd is right. yyyy-MM-dd hh:mm is wrong. yyyy-MM is wrong
 */
+ (NSInteger) numberOfDaysFromTodayByTime:(NSString*)time timeStringFormat:(NSString*)format;

+ (NSInteger) numberOfDaysFromTodayByTime:(NSString *)time;

/**
 format: must be the group of yyyy, MM, dd, hh, mm, or ss.
 */
+ (NSString*) stringFromDate:(NSDate*)date stringFormat:(NSString*)format;

/** 
 default format is: yyyy-MM-dd hh:mm:ss
 */
+ (NSString*) stringFromDate:(NSDate*)date;

/**
 format: must be the group of yyyy, MM, dd, hh, mm, or ss.
 */
+ (NSDate*) dateFromString:(NSString*)dateTime stringFormat:(NSString*)format;

/**
 default format is: yyyy-MM-dd hh:mm:ss
 */
+ (NSDate *)dateFromString:(NSString *)dateTime;

/**------------------------------------------------------------
/- URL encoding / decoding
-------------------------------------------------------------*/

+ (NSString *)urlEncoding:(NSString *)source;

+ (NSString *)urlDecoding:(NSString *)source;

/**------------------------------------------------------------
/- url param parser: key1=value1&key2=value2 ... <=> NSDictionary 格式
-------------------------------------------------------------*/

+ (NSDictionary*) dictionaryFromURLParam:(NSString *)source;

+ (NSString *) urlParamFromDictionary:(NSDictionary *)source;

//------------------------------------------------------------
+ (BOOL) regexMatch:(NSString*)regex sourceString:(NSString*)source;
+ (NSString*) regexReplaceString:(NSString*)regex sourceString:(NSString*)source withTemplate:(NSString*)templateString;

/**
 JSON
 */
+ (NSDictionary*) dictionaryFromJSON:(NSString *)source;
+ (NSDictionary*) dictionaryFromJSONData:(NSData *)source;
+ (NSArray*) arrayFromJSON:(NSString*)source;
+ (NSArray*) arrayFromJSONData:(NSData*)source;
+ (NSString*) jsonStringFromDictionary:(NSDictionary *)source;
+ (NSString*) jsonStringFromArray:(NSArray *)source;
//

+ (NSString*)md5FromStringByUTF8:(NSString *)dataString;

+ (BOOL) isMatchByRegex:(NSString*)string regex:(NSString*)regex;
+ (NSString*) documentPath;
+ (NSString*) cachePath;

+ (NSDictionary*) paramsOfUrlParamsString:(NSString*)params;

+ (double) getDistanceByLongitudeAndLatitude:(double)long1 lat1:(double)lat1 long2:(double)long2 lat2:(double)lat2;

+ (NSString*) getSafeStringValue:(NSDictionary*)dic key:(NSString*)key;

@end

@interface G2XDelayExcute : NSObject

+ (G2XDelayExcute*) initWithBlock:(void(^)(void))block delay:(NSTimeInterval)interval;

@end

@interface G2XParamStoreTool : NSObject
{
@private
    NSMutableDictionary* plistData;
}
@property (nonatomic,readonly) NSString* filePath;

/** While the data has been changed ,it will save data to file. */
@property (nonatomic) BOOL enableAutoSave;

-(id)initWithPlistFilePathOrNil:(NSString*)path;
-(void)print;
-(BOOL)save;
-(BOOL) isPathExist:(NSString*)keyPath;

/**
 add value, if path not exist, it will create path for the key.
 */
-(BOOL) addValue:(id)value path:(NSString*)path key:(NSString*)key;

/**
 eg: 
 addStringValue:@"guoxuxing" path:@"system.userInfo" key:@"name" 
 */
-(BOOL) addStringValue:(NSString*)value path:(NSString*)path key:(NSString*)key;

/**
 eg:
 addArrayValue:@[@"羽毛球",@"乒乓球"] path:@"system.userInfo" key:@"hobby"
 */
-(BOOL) addArrayValue:(NSArray*)value path:(NSString*)path key:(NSString*)key;

/**
 eg:
 addDictionaryValue:@{@"name":@"guoxuxing", @"hobby": @[@"羽毛球",@"乒乓球"]} path:@"system" key:@"userInfo";
 */
-(BOOL) addDictionaryValue:(NSDictionary*)value path:(NSString*)path key:(NSString*)key;

-(id) idForKeyPath:(NSString*)path;

/**
 eg:
 stringForKeyPath:@"system.userInfo.name" -> result: guoxuxing
 stringForKeyPath:@"system.userInfo.hobby.~1" -> result: 羽毛球 (得到数组的第一个元素)
 stringForKeyPath:@"system.userInfo.hobby.~2" -> result: 乒乓球
 */
-(NSString*) stringForKeyPath:(NSString*)path;

/**
 eg:
 arrayForKeyPath:@"system.userInfo.hobby" -> result: @[@"羽毛球",@"乒乓球"]
 */
-(NSArray*) arrayForKeyPath:(NSString*)path;

/**
 eg:
 dictionaryForKeyPath:@"system.userInfo" -> result: @{@"name":@"guoxuxing", @"hobby": @[@"羽毛球",@"乒乓球"]
 */
-(NSDictionary*) dictionaryForKeyPath:(NSString*)path;

-(NSInteger) integerForKeyPath:(NSString*)path;

@end
