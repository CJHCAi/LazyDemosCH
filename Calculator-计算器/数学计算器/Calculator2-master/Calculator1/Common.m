//
//  Common.m
//  Calculator1
//
//  Created by ruru on 16/4/26.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import "Common.h"


@implementation Common
//方法一
+(void)configSet:(NSString *)key value:(id)value{
    NSUserDefaults *saveData=[NSUserDefaults standardUserDefaults];
    [saveData setObject:value forKey:key];
    [saveData synchronize];
}

+(id)configGet:(NSString *)key{
    NSUserDefaults *readData=[NSUserDefaults standardUserDefaults];
    return [readData objectForKey:key];
}
+(id)configGetClcikMusic:(NSString *)key{
    NSUserDefaults *readData=[NSUserDefaults standardUserDefaults];
    return [readData arrayForKey:key];
}
+(id)configGetTheme:(NSString *)key{
    NSUserDefaults *readData=[NSUserDefaults standardUserDefaults];
    return [readData dictionaryForKey:key];
}
//方法二
+(void)configMusicOnSet:(BOOL)on{
    [Common configSet:@"key_music_on" value:[NSString stringWithFormat:@"%d",on]];
}
+(BOOL)configMusicOnGet{
    BOOL defaultValue = YES;
    if([self configGet:@"key_music_on"]){
        return [[self configGet:@"key_music_on"] intValue];
    }else{
        [Common configSet:@"key_music_on" value:[NSString stringWithFormat:@"%d",defaultValue]];
        return defaultValue;
    }
}
//把UIImage保存到文件的方法
+(void)writeImage:(UIImage *)image toFileAtPath:(NSString *)aPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:aPath]];
    NSLog(@"filePath%@",filePath);
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:aPath atomically:YES];
}

@end
