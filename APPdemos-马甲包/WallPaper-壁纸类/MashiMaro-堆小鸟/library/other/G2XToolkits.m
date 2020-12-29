//
//  G2XToolkits.m
//  ZhiHuiAnBao
//
//  Created by Guo xuxing on 4/10/13.
//
//

#import "G2XToolkits.h"
#import <CommonCrypto/CommonDigest.h>

@implementation G2XToolkits

+ (NSTimeInterval)numberOfSecondsFrom1970:(NSDate *)date
{
    return [date timeIntervalSince1970];
}

+ (NSString *)getLocalDateTime
{
    NSDate *date = [NSDate date];
    
    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:localTimeZone];
    [formatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd HH:mm:ss",nil)];
    
    return [formatter stringFromDate:date];
}

+ (NSInteger)numberOfDaysFromTodayByTime:(NSString *)time timeStringFormat:(NSString *)format
{
    // format可以形如： @"yyyy-MM-dd"
    
    NSDate *today = [NSDate date];
    
    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:localTimeZone];
    [formatter setDateFormat:NSLocalizedString(format,nil)];
    
    // 时分秒转为00:00:00
    NSDate *today2 = [formatter dateFromString:[formatter stringFromDate:today]];
    
    NSDate *newDate = [formatter dateFromString:time];
    // 时分秒转为00:00:00
    NSDate *newDate2 = [formatter dateFromString:[formatter stringFromDate:newDate]];
    
    double dToday = [G2XToolkits numberOfSecondsFrom1970:today2];
    double dNewDate = [G2XToolkits numberOfSecondsFrom1970:newDate2];
    
    NSInteger nSecs = (NSInteger)(dNewDate - dToday);
    NSInteger oneDaySecs = 24*3600;
    return nSecs / oneDaySecs;
}

+ (NSInteger)numberOfDaysFromTodayByTime:(NSString *)time
{  //小于10返回0
    if (time.length < 10) {
        return 0;
    }
    return [G2XToolkits numberOfDaysFromTodayByTime:[time substringToIndex:10] timeStringFormat:@"yyyy-MM-dd"];
}


+ (NSString *)stringFromDate:(NSDate *)date stringFormat:(NSString *)format
{
    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:localTimeZone];
    [formatter setDateFormat:NSLocalizedString(format,nil)];
    return [formatter stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    return [G2XToolkits stringFromDate:date stringFormat:@"yyyy-MM-dd hh:mm:ss"];
}

+ (NSDate *)dateFromString:(NSString *)dateTime stringFormat:(NSString *)format
{
    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:localTimeZone];
    [formatter setDateFormat:NSLocalizedString(format,nil)];
    return [formatter dateFromString:dateTime];
}

+ (NSDate *)dateFromString:(NSString *)dateTime
{
    NSTimeZone *localTimeZone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:localTimeZone];
    [formatter setDateFormat:NSLocalizedString(@"yyyy-MM-dd hh:mm:ss",nil)];
    return [formatter dateFromString:dateTime];
}

+ (NSString *)urlEncoding:(NSString *)source
{
    return [source stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (NSString *)urlDecoding:(NSString *)source
{
    return [source stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
+ (NSDictionary *)dictionaryFromURLParam:(NSString *)source
{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    if (source.length > 0) {
        NSArray* arr = [source componentsSeparatedByString:@"&"];
        for (NSString* pair in arr) {
            NSRange re = [pair rangeOfString:@"="];
            if (re.length != 1 || re.location == 0)
                continue;
            NSString* key = [pair substringToIndex:re.location];
            NSString* value;
            if (re.location + 1 == pair.length) {
                value = @"";
            } else {
                value = [pair substringFromIndex:re.location + 1];
            }
            [dic setValue:value forKey:key];
        }
    }
    return dic;
}
+ (NSString *)urlParamFromDictionary:(NSDictionary *)source
{
    NSMutableString* result = [[NSMutableString alloc]init];
    for (NSString* key in source.allKeys) {
        [result appendFormat:@"&%@=%@",key,[source valueForKey:key]];
    }
    if ([result length] > 0){
        return [result substringFromIndex:1];
    }
    return result;
}
+ (BOOL)regexMatch:(NSString *)regex sourceString:(NSString *)source
{
    NSPredicate*predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    
    return [predicate evaluateWithObject:source];
}
+ (NSString *)regexReplaceString:(NSString *)regex sourceString:(NSString *)source withTemplate:(NSString *)templateString
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:
                                              
                                              @"<(/{0,})div(.{0,})>" options:0 error:nil];
    
    NSString* result = [regularExpression stringByReplacingMatchesInString:source options:0 range:NSMakeRange(0, source.length) withTemplate:templateString];
    return result;
}

+ (NSDictionary *)dictionaryFromJSON:(NSString *)source
{
    NSData* da = [source dataUsingEncoding:NSUTF8StringEncoding];
    return [G2XToolkits dictionaryFromJSONData:da];
}

+ (NSDictionary *)dictionaryFromJSONData:(NSData *)source
{
    NSError* err = nil;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:source options:NSJSONReadingAllowFragments error:&err];
    if (err != nil) {
        NSLog(@"无效的JSON: %@", err.description);
        return nil;
    }
    return dic;
}

+ (NSArray *)arrayFromJSON:(NSString *)source
{
    NSData* da = [source dataUsingEncoding:NSUTF8StringEncoding];
    return [G2XToolkits arrayFromJSONData:da];
}

+ (NSArray *)arrayFromJSONData:(NSData *)source
{
    NSError* err = nil;
    NSArray* arr = [NSJSONSerialization JSONObjectWithData:source options:NSJSONReadingAllowFragments error:&err];
    if (err != nil) {
        NSLog(@"无效的JSON: %@", err.description);
        return nil;
    }
    return arr;
}

+ (NSString *)jsonStringFromDictionary:(NSDictionary *)source
{
    NSError* err = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:source options:NSJSONWritingPrettyPrinted error:&err];
    if (err != nil) {
        NSLog(@"无法转换为JSON格式: %@", err.description);
        return nil;
    }
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)jsonStringFromArray:(NSArray *)source
{
    NSError* err = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:source options:NSJSONWritingPrettyPrinted error:&err];
    if (err != nil) {
        NSLog(@"无法转换为JSON格式: %@", err.description);
        return nil;
    }
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString*)md5FromStringByUTF8:(NSString *)dataString
{
    const char *original_str = [dataString UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    NSString* strResult = [hash lowercaseString];
    return strResult;
}

+ (BOOL)isMatchByRegex:(NSString *)string regex:(NSString *)regexStr
{
    NSError* regError = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&regError];
    NSInteger nMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) ];
    if (regError){
        NSLog(@"regex match error: %@", regError);
    }
    return nMatch != 0;
}

+ (NSString *)documentPath
{
    NSString* strPath = [[NSString alloc] initWithString:NSHomeDirectory()];
    return [strPath stringByAppendingPathComponent:@"Documents"];
}

+ (NSString *)cachePath
{
    NSString* strPath = [[NSString alloc] initWithString:NSHomeDirectory()];
    return [strPath stringByAppendingPathComponent:@"Library/Caches"];
}

+ (NSDictionary *)paramsOfUrlParamsString:(NSString *)params
{
    if (params == nil || [params isEqualToString:@""])
    {
        return nil;
    }
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    NSArray* arr = [params componentsSeparatedByString:@"&"];
    for (NSString* group in arr) {
        if (group && ![group isEqualToString:@""])
        {
            NSRange rang = [group rangeOfString:@"="];
            if (rang.length == 0)
            {
                continue;
            }
            NSString* strKey = [group substringToIndex:rang.location];
            NSString* strValue = [group substringFromIndex:rang.location + 1];
            if (strKey == nil || [strKey isEqualToString:@""]){
                continue;
            }
            if (strValue == nil)
                strValue = @"";
            [dict setValue:strValue forKey:strKey];
        }
    }
    return dict;
}

+ (double)getDistanceByLongitudeAndLatitude:(double)lng1 lat1:(double)lat1 long2:(double)lng2 lat2:(double)lat2
{
    double pi = 3.1415926535898;
    
    double pi80 = pi / 180;
	
    lat1 *= pi80;
	lng1 *= pi80;
	lat2 *= pi80;
	lng2 *= pi80;
    
    double r = 6372.797; // mean radius of Earth in km
    double dlat = lat2 - lat1;
	double dlng = lng2 - lng1;
    
    double a = sin(dlat / 2) * sin(dlat / 2) + cos(lat1) * cos(lat2) * sin(dlng / 2) * sin(dlng / 2);
	double c = 2 * atan2(sqrt(a), sqrt(1 - a));
	double km = r * c;
    
	return km;

}

+ (NSString *)getSafeStringValue:(NSDictionary *)dic key:(NSString *)key
{
    if (dic == nil || key == nil || [key length] < 1){
        return @"";
    }
    NSString* result = [dic valueForKey:key];
    if (result == nil){
        return @"";
    }
    return result;
}

@end

@implementation G2XParamStoreTool
@synthesize filePath = _filePath;
@synthesize enableAutoSave = _enableAutoSave;

- (void)print
{
    NSLog(@"G2XParamStoreTool: %@", plistData);
}
-(id)initWithPlistFilePathOrNil:(NSString *)path
{
    if (self = [super init]){
        _filePath = path;
        if (_filePath){
            plistData = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
        }
        
        if (!plistData){
            plistData = [[NSMutableDictionary alloc]init];
        }
    }
    return self;
}

- (BOOL)save
{
    if (!self.filePath || [self.filePath isEqualToString:@""]){
        return NO;
    }
    return [plistData writeToFile:self.filePath atomically:YES];
}

- (BOOL)isPathExist:(NSString *)keyPath
{
    return [self idForKeyPath:keyPath] != nil;
}

/** 检查是否为有效的路径，如果是有效的路径并且路经不存在，那么就创建路径*/
-(NSMutableDictionary*)checkPath:(NSString*)path
{
    if (!path || [path isEqualToString:@""]){
        return nil;
    }
    
    NSArray* nodeArray = [path componentsSeparatedByString:@"."];
    NSInteger nCount = [nodeArray count];
    NSMutableDictionary* result = self->plistData;
    for (int i=0; i < nCount; i++)
    {
        NSString* node = [nodeArray objectAtIndex:i];
        if ([node isEqualToString:@""]){
            if (i > 0)
                return result;
            else
                continue;
        }
        if ([result valueForKey:node] == nil){
            [result setValue:[[NSMutableDictionary alloc]init] forKey:node];
        }
        result = [result valueForKey:node];
    }
    return result;
}
- (BOOL)addValue:(id)value path:(NSString *)path key:(NSString *)key
{
    NSMutableDictionary* result = [self checkPath:path];
    if (!result) return NO;
    
    [result setValue:value forKey:key];
    BOOL bRes = [result valueForKey:key] != nil;
    if (bRes && self.enableAutoSave){
        if (![self save])
            NSLog(@"G2XParamStoreTool error: auto saving file error!");
    }
    return bRes;
}
-(BOOL)addStringValue:(NSString *)value path:(NSString *)path key:(NSString *)key
{
    return [self addValue:value path:path key:key];
}

-(BOOL)addArrayValue:(NSArray *)value path:(NSString *)path key:(NSString *)key
{
    return [self addValue:value path:path key:key];
}

-(BOOL)addDictionaryValue:(NSDictionary *)value path:(NSString *)path key:(NSString *)key
{
    return [self addValue:value path:path key:key];
}



-(id)idForKeyPath:(NSString *)path
{
    NSRange n = [path rangeOfString:@"~"];
    id result = nil;
    if (n.length == 0){
        result = [plistData valueForKeyPath:path];
    }else{
        result = [self arrayForKeyPath:[path substringToIndex:n.location - 1]];
        NSInteger nIndex = [[path substringFromIndex:n.location+1] integerValue];
        if (result){
            if (nIndex == 0 || nIndex > [result count] ){
                if (nIndex == 0)
                    NSLog(@"idForKeyPath error: %@ index is invalid, index must be > 0", path);
                else
                    NSLog(@"idForKeyPath error: %@ index is invalid, index must be <= number of array's items", path);
                return nil;
            }
            return [result objectAtIndex:nIndex - 1];
        }else{
            return nil;
        }
    }
    return result;
}
-(NSString*)stringForKeyPath:(NSString *)path
{
    id result = [self idForKeyPath:path];
    
    if (!result){
        NSLog(@"stringForKeyPath error: %@ not exist!", path);
        return nil;
    }
    if (![result isKindOfClass:[NSString class]]){
        NSLog(@"stringForKeyPath error: %@ value type is not a string!", path);
        return nil;
    }
    return result;
}
-(NSArray *)arrayForKeyPath:(NSString *)path
{
    id result = [self idForKeyPath:path];
    if (!result){
        NSLog(@"stringForKeyPath error: %@ not exist!", path);
        return nil;
    }
    if (![result isKindOfClass:[NSArray class]]){
        NSLog(@"stringForKeyPath error: %@ value type is not a array!", path);
        return nil;
    }
    return result;
}
-(NSDictionary *)dictionaryForKeyPath:(NSString *)path
{
    id result = [self idForKeyPath:path];
    if (!result){
        NSLog(@"stringForKeyPath error: %@ not exist!", path);
        return nil;
    }
    if (![result isKindOfClass:[NSDictionary class]]){
        NSLog(@"stringForKeyPath error: %@ value type is not a dictionary!", path);
        return nil;
    }
    return result;
}
- (NSInteger)integerForKeyPath:(NSString *)path
{
    NSString* str = [self stringForKeyPath:path];
    if (!str){
        return 0;
    }
    return [str integerValue];
}



@end

@interface G2XDelayExcute ()
typedef void(^G2XDelayExcuteBlock)(void);
@end

@implementation G2XDelayExcute
{
    G2XDelayExcuteBlock _block;
    NSTimer* _timer;
}

+ (G2XDelayExcute*) initWithBlock:(void (^)(void))block delay:(NSTimeInterval)interval
{
    G2XDelayExcute* e = [[G2XDelayExcute alloc] init];
    e->_block = block;
    e->_timer = [NSTimer scheduledTimerWithTimeInterval:interval target:e selector:@selector(timerSch:) userInfo:nil repeats:NO];
    return e;
}

- (void) timerSch:(id)sender
{
    self->_block();
    [self->_timer invalidate];
    self->_timer = nil;
}


@end