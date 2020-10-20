//
//  GDLocalizableController.m
//  Internationalization
//
//  Created by Qiulong-CQ on 16/12/2.
//  Copyright © 2016年 xiaoheng. All rights reserved.
//

#import "GDLocalizableController.h"

@implementation GDLocalizableController

static NSBundle *bundle = nil;

+ ( NSBundle * )bundle{
    return bundle;
}
+(void)initUserLanguage{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:@"userLanguage"];
    if(string.length == 0){
        //获取系统当前语言版本
        NSArray* languages = [def objectForKey:@"AppleLanguages"];
        NSString *current = [languages objectAtIndex:0];
        if ([current containsString:@"zh-Hans"] == YES) {
            current = @"zh-Hans";
        }else{
            current = @"en";
        }
        
        string = current;
        [def setValue:current forKey:@"userLanguage"];
        [def synchronize];//持久化，不加的话不会保存
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

+(NSString *)userLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"userLanguage"];
    return language;
}

+(void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    [def synchronize];
}


@end
