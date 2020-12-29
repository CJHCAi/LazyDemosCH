//
//  CommonUtility.m
//  SportForum
//
//  Created by liyuan on 14-6-23.
//  Copyright (c) 2014年 zhengying. All rights reserved.
//

#import "CommonUtility.h"
#import "SportForum.h"
#import "ApplicationContext.h"
#import "AlertManager.h"
#import <ShareSDK/ShareSDK.h>
#import <CoreLocation/CLLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <sys/sysctl.h>
#import <mach/mach.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import "AppDelegate.h"
#import "RegisterInfoViewController.h"

__strong static CommonUtility *singleton = nil;

@implementation CommonUtility

+(CommonUtility *)sharedInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

-(NSDate*) convertStringToNSDate:(NSString*) strDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateTime = [formatter dateFromString:strDate];
    return dateTime;
}

-(NSString*)convertBirthdayToAge:(long long)llBirthday
{
    NSDate * dateBirthday = [NSDate dateWithTimeIntervalSince1970:llBirthday];
    NSDateComponents * comps =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dateBirthday];
    NSInteger birthdayYear = [comps year];
    NSDateComponents * comps2 =[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
    NSInteger year = [comps2 year];
    NSString *result = [NSString stringWithFormat:@"%ld",year - birthdayYear];
    
    /*NSDate *dateBir = [NSDate dateWithTimeIntervalSince1970:llBirthday];
    NSTimeInterval  timeInterval = [dateBir timeIntervalSinceNow];
    timeInterval = -timeInterval;
    NSUInteger temp = 0;
    NSString *result;
    
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%u分钟",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%u小时",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%d天",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%d月",temp];
    }
    else
    {
        temp = temp/12;
        result = [NSString stringWithFormat:@"%d",temp];
    }*/
    
    return result;
}

-(NSString*)convertBirthdayToString:(long long)llBirthday
{
    NSDate * dateBirthday = [NSDate dateWithTimeIntervalSince1970:llBirthday];
    NSString *result;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy年MM月dd日"];
    result = [formatter stringFromDate:dateBirthday];
    return result;
}

-(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    NSUInteger temp = 0;
    NSString *result;
    
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%lu分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%lu小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld个月前",temp];
    }
    else
    {
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    /*else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"MM-dd HH:mm"];
        result = [formatter stringFromDate:compareDate];
    }*/
    
    return result;
}

-(NSString *) compareLastLoginTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //NSUInteger temp = 0;
    NSString *result;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat : @"yyyy年MM月dd日 HH:mm"];
    result = [formatter stringFromDate:compareDate];

    /*
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%lu分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%lu小时前",temp];
    }
    else{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat : @"yyyy-MM-dd HH:mm"];
        result = [formatter stringFromDate:compareDate];
    }*/
    
    /*else
     {
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     [formatter setDateFormat : @"MM-dd HH:mm"];
     result = [formatter stringFromDate:compareDate];
     }*/
    
    return result;
}

- (int)getSecondsFromZeroOfNextDay
{
    int timeDiff = 0;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeInterval interval = 24*60*60*1;
    NSDate *dateNext = [NSDate dateWithTimeIntervalSinceNow:interval];
    NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:dateNext];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    NSTimeInterval ts = (double)(int)[[calendar dateFromComponents:components] timeIntervalSince1970];
    
    timeDiff = [[NSDate date] timeIntervalSinceDate:[NSDate dateWithTimeIntervalSince1970:ts]];
    return fabs(timeDiff);
}

-(NSString*)convertToActor:(NSString*)strActor
{
    NSString *strActorer = @"爱好者";
    
    if ([strActor isEqualToString:actor_pro]) {
        strActorer = @"专业";
    }
    else if([strActor isEqualToString:actor_mid])
    {
        strActorer = @"业余";
    }
    else if([strActor isEqualToString:actor_amatrur])
    {
        strActorer = @"爱好者";
    }
    
    return strActorer;
}

-(double)getDistanceBySelfLon:(double) selfLon SelfLantitude:(double) selfLat OtherLon:(double)othLon OtherLat:(double)othLat
{
    CLLocationDistance kilometers;
    
    if((selfLon == 0 && selfLat == 0) || (othLon == 0 && othLat == 0))
    {
        kilometers = -1;
    }
    else
    {
        CLLocation *origLocation = [[CLLocation alloc] initWithLatitude:selfLat longitude:selfLon];
        CLLocation *distLocation = [[CLLocation alloc] initWithLatitude:othLat longitude:othLon];
        kilometers = [origLocation distanceFromLocation:distLocation];
    }

    return kilometers;
}

//不要边框，只把图片变成圆形
- (UIImage *) ellipseImage: (UIImage *) image withInset: (CGFloat) inset
{
    return [self ellipseImage:image withInset:inset withBorderWidth:0 withBorderColor:[UIColor clearColor]];
}

- (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (UIImage *) ellipseImage: (UIImage *) image withInset: (CGFloat) inset withBorderWidth:(CGFloat)width withBorderColor:(UIColor*)color
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f , image.size.height - inset * 2.0f);
    
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [image drawInRect:rect];
    
    if (width > 0) {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineCap(context,kCGLineCapButt);
        CGContextSetLineWidth(context, width);
        CGContextAddEllipseInRect(context, CGRectMake(inset + width/2, inset +  width/2, image.size.width - width- inset * 2.0f, image.size.height - width - inset * 2.0f));//在这个框中画圆
        
        CGContextStrokePath(context);
    }
    
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

-(BOOL)isAllowChar:(NSString*)strInput AlowedChars:(NSString*)strAlowChars
{
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:strAlowChars];
    int i = 0;
    while (i < strInput.length)
    {
        NSString * string = [strInput substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0)
        {
            res = NO;
            break;
        }
        i++;
    }
    
    return res;
}

-(NSString*)updateAllowChar:(NSString*)strInput AlowedChars:(NSString*)strAlowChars
{
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:strAlowChars];
    int i = 0;
    while (i < strInput.length)
    {
        NSString * string = [strInput substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0)
        {
            if (i == 0) {
                strInput = @"";
            }
            else
            {
                strInput = [strInput stringByReplacingOccurrencesOfString:string withString:@""];
            }
            //strInput = [strInput stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:@""];
        }
        
        i++;
    }
    
    return strInput.length > 0 ? strInput : @"";
}

- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    
    if (kernReturn != KERN_SUCCESS
        ) {
        return NSNotFound;
    }
    
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

-(void)sinaWeiBoLogin {
    [[ApplicationContext sharedInstance] saveObject:@(YES) byKey:@"WeiBoLogin"];
    
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    //在授权页面中添加关注官方微博
    [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                    [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"关注我爱悦动力的微博"],
                                    SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                    nil]];
    
    [authOptions setPowerByHidden:NO];
    
    [ShareSDK authWithType:ShareTypeSinaWeibo options:authOptions result:^(SSAuthState state, id<ICMErrorInfo> error) {
        [[ApplicationContext sharedInstance] saveObject:@(NO) byKey:@"WeiBoLogin"];
        
        if (state == SSAuthStateSuccess) {
            id process = [AlertManager showCommonProgress];
            
            [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo
                              authOptions:nil
                                   result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error){
                                       NSLog(@"UserInfo Data is: %@.", [userInfo sourceData]);
                                       
                                       id<ISSPlatformCredential> credential = [ShareSDK getCredentialWithType:ShareTypeSinaWeibo];    //传入获取授权信息的类型
                                       NSLog(@"accessToken = %@", [credential token]);
                                       NSLog(@"expiresIn = %@", [credential expired]);
                                       
                                       NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: [credential token], @"WeiBoToken", [credential expired], @"WeiBoExpird", nil];
                                       [[ApplicationContext sharedInstance] saveObject:dict byKey:@"WeiBoInfo"];
                                       
                                       [[SportForumAPI sharedInstance]accountCheckExistById:userInfo.uid AccountType:login_type_weibo FinishedBlock:^(int errorCode, NSString* userId)
                                        {
                                            [AlertManager dissmiss:process];
                                            
                                            if (errorCode == 0) {
                                                if (userId.length > 0) {
                                                    id process = [AlertManager showCommonProgressWithText:@"正在登录"];
                                                    
                                                    [[ApplicationContext sharedInstance]login:userInfo.uid key:[credential token] type:login_type_weibo reset:NO FinishedBlock:^(int errorCode, NSString* strErr, NSString* strUserId){
                                                        [AlertManager dissmiss:process];
                                                        
                                                        if (errorCode == 0) {
                                                            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_SWITCH_VIEW object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:VIEW_MAIN_PAGE, @"PageName", nil]];
                                                        }
                                                        else
                                                        {
                                                            [JDStatusBarNotification showWithStatus:strErr dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                                                        }
                                                    }];
                                                }
                                                else
                                                {
                                                    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
                                                    
                                                    RegisterInfoViewController *registerInfoViewController = [[RegisterInfoViewController alloc]init];
                                                    registerInfoViewController.nRegisterType = REGISTER_NIKENAME_PAGE;
                                                    registerInfoViewController.userWeiboInfo = userInfo;
                                                    [delegate.mainNavigationController pushViewController:registerInfoViewController animated:YES];
                                                }
                                            }
                                            else
                                            {
                                                [JDStatusBarNotification showWithStatus:@"检查数据异常" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleWarning];
                                            }
                                        }];
                                    }];
        }
        else
        {
            [JDStatusBarNotification showWithStatus:@"登录失败。" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
            //[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_SWITCH_VIEW object:nil userInfo:[NSMutableDictionary dictionaryWithObjectsAndKeys:VIEW_LOGIN_PAGE, @"PageName", nil]];
        }
    }];
}

-(void)sinaWeiBoLogout
{
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
}

-(void)sinaWeiBoShare:(UIImage *) image Content:(NSString*)strContent FinishBlock:(void(^)(int errorCode))finishedBlock
{
    id<ISSContent> publishContent = [ShareSDK content:@"我在 @悦动力 看到一篇好帖，分享给大家一起看看："
                                       defaultContent:strContent
                                                image:[ShareSDK jpegImageWithImage:image quality:1.0]
                                                title:nil
                                                  url:nil
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeImage];
    
    [[ApplicationContext sharedInstance] saveObject:@(YES) byKey:@"WeiBoShare"];
    NSArray *shareList = [ShareSDK getShareListWithType:ShareTypeSinaWeibo, nil];
    [ShareSDK oneKeyShareContent:publishContent//内容对象
                       shareList:shareList//平台类型列表
                     authOptions:nil//授权选项
                   statusBarTips:YES
                          result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {//返回事件
                              [[ApplicationContext sharedInstance] saveObject:@(NO) byKey:@"WeiBoShare"];
                              if (state == SSPublishContentStateSuccess)
                              {
                                  [JDStatusBarNotification showWithStatus:@"分享成功" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleSuccess];
                              }
                              else if (state == SSPublishContentStateFail)
                              {
                                  NSString *strDesc = [error errorDescription];
                                  [JDStatusBarNotification showWithStatus:strDesc.length > 0 ? [NSString stringWithFormat:@"分享失败，错误描述：%@!", strDesc] : @"分享失败" dismissAfter:DISMISS_TIME styleName:JDStatusBarStyleError];
                              }
                              
                              if (finishedBlock != nil && (state != SSPublishContentStateBegan)) {
                                  finishedBlock(state == SSPublishContentStateSuccess ? 0 : 1);
                              }
                          }];
}

-(void)playAudioFromName:(NSString*)strAudioName
{
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:[NSString stringWithFormat:@"/Audios/%@", strAudioName]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        SystemSoundID sound;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &sound);
        AudioServicesPlaySystemSound(sound);
    }
    else {
        NSLog(@"Error: audio file not found at path: %@", path);
    }
}

- (NSString *)disable_emoji:(NSString *)text
{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u278a-\\u2793\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

-(NSUInteger)generateWeightBySex:(NSString*)strSexType Weight:(NSUInteger)nWeight
{
    NSUInteger nResult = nWeight;
    
    if(nResult == 0)
    {
        if ([strSexType isEqualToString:sex_male]) {
            nResult = 65;
        }
        else
        {
            nResult = 55;
        }
    }
    
    return nResult;
}

-(NSUInteger)generateHeightBySex:(NSString*)strSexType Height:(NSUInteger)nHeight
{
    NSUInteger nResult = nHeight;
    
    if(nResult == 0)
    {
        if ([strSexType isEqualToString:sex_male]) {
            nResult = 170;
        }
        else
        {
            nResult = 160;
        }
    }
    
    return nResult;
}

+ (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath {
    if (!videoPath)
        return nil;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = 0;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    CGImageRelease(thumbnailImageRef);
    
    return thumbnailImage;
}

@end
