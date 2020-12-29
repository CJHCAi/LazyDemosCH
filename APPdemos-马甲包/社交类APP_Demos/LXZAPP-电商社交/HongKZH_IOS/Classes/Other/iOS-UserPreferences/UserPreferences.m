#import "UserPreferences.h"

@implementation UserPreferences

+(NSString*)getStringWithKey:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(NSString*)getStringWithKey:(NSString*)key withDefault:(NSString*)d {
	if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
		return d;
	}
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+(void)setString:(NSString*)v withKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:v forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)getBoolWithKey:(NSString*)key {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
}

+(BOOL)getBoolWithKey:(NSString*)key withDefault:(BOOL)d {
	if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
		return d;
	}
    return [[[NSUserDefaults standardUserDefaults] objectForKey:key] boolValue];
}

+(void)setBool:(BOOL)v withKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setObject:v ? @"1" : @"0" forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(int)getIntWithKey:(NSString*)key {
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+(int)getIntWithKey:(NSString*)key withDefault:(int)d {
	if([[NSUserDefaults standardUserDefaults] objectForKey:key] == nil) {
		return d;
	}
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+(void)setInt:(int)v withKey:(NSString*)key {
    [[NSUserDefaults standardUserDefaults] setInteger:v forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)keyExists:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] != nil;
}

+(BOOL)keyUndefined:(NSString*)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] == nil;
}

+(BOOL)isKeyUndefinedThenDefine:(NSString*)key {
    BOOL isKeyUndefined = [UserPreferences keyUndefined:key];
    if(isKeyUndefined) {
        [UserPreferences setString:key withKey:key];
    }
    return isKeyUndefined;
}

@end
