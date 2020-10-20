//
//  LocalizationManager.m
//  mxchipApp
//
//  Created by 黄坚 on 2018/3/16.
//  Copyright © 2018年 黄坚. All rights reserved.
//

#import "LocalizationManager.h"
#import "AppDelegate.h"
#import "HJTabbarViewController.h"
#import "MineViewController.h"
#import "LanguageViewController.h"


@implementation LocalizationManager

//static NSString *TableName = @"Localizable";
static NSBundle *bundle = nil;
static NSString *UserLanguage = @"UserLanguage";

+ (NSBundle *)bundle
{
    if(!bundle)
    {
        [self initUserLanguage];
    }
    return bundle;
}

+ (void)initUserLanguage{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:UserLanguage];
    if(string.length == 0)
    {
        //获取系统当前语言版本(中文zh-Hans,英文en)
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *current = [languages objectAtIndex:0];
        string = [self languageFormat:current];
        //个人需求 目前就两种语言
        if (![string isEqualToString:@"zh-Hans"]&&![string isEqualToString:@"en"]) {
            string=@"en";
        }
        [def setValue:current forKey:UserLanguage];
        [def synchronize];
        
    }
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:[self languageFormat:string] ofType:@"lproj"];
    
    bundle = [NSBundle bundleWithPath:path];//生成bundle
}

+ (void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:[self languageFormat:language] ofType:@"lproj" ];
    
    bundle = [NSBundle bundleWithPath:path];
    
    //2.持久化
    [def setValue:language forKey:UserLanguage];
    
    [def synchronize];
    [self resetRootViewController];
}

+ (NSString *)userLanguage
{
    NSString *userLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:UserLanguage];

    return [self languageFormat:userLanguage];
}

+ (NSString *)getStringByKey:(NSString *)key table:(NSString *)fileName
{
    
    if (![[LocalizationManager bundle] localizedStringForKey:key value:@"" table:fileName]) {
           return [[NSBundle mainBundle] localizedStringForKey:key value:@"" table:fileName];
       }
       return [[LocalizationManager bundle] localizedStringForKey:key value:@"" table:fileName];
}

///语言和语言对应的.lproj的文件夹前缀不一致时在这里做处理
+ (NSString *)languageFormat:(NSString*)language {
    if([language rangeOfString:@"zh-Hans"].location != NSNotFound)
    {
        return @"zh-Hans";
    }
    else if([language rangeOfString:@"zh-Hant"].location != NSNotFound)
    {
        return @"zh-Hant";
    }
    else
    {
        //字符串查找
        if([language rangeOfString:@"-"].location != NSNotFound) {
            //除了中文以外的其他语言统一处理@"ru_RU" @"ko_KR"取前面一部分
            NSArray *ary = [language componentsSeparatedByString:@"-"];
            if (ary.count > 1) {
                NSString *str = ary[0];
                return str;
            }
        }
    }
    return language;
}

//重新设置
+ (void)resetRootViewController
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    HJTabbarViewController *tabbarVC = [[HJTabbarViewController alloc] init];
    delegate.window.rootViewController = tabbarVC;
    tabbarVC.selectedIndex=tabbarVC.childViewControllers.count-1;
    for (UINavigationController *navi in tabbarVC.childViewControllers) {
        for (UIViewController *vc in navi.childViewControllers) {
            if ([vc isKindOfClass:[MineViewController class]]) {

                [(MineViewController *)vc changeLanguage];
            }
        }
    }
   
    
}
+(NSString *)getSystemLanguage
{
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    return languageName;
}

@end
