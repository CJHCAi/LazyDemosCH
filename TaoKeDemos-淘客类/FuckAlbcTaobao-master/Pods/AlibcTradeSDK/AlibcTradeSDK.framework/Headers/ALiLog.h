/*
 * ALiLog.h 
 *
 * 阿里百川电商
 * 项目名称：阿里巴巴电商 AlibcTradeSDK 
 * 版本号：3.1.1.5
 * 发布时间：2016-10-14
 * 开发团队：阿里巴巴百川商业化团队
 * 阿里巴巴电商SDK答疑群号：1229144682(阿里旺旺)
 * Copyright (c) 2016-2019 阿里巴巴-移动事业群-百川. All rights reserved.
 */

#import <Foundation/Foundation.h>

#undef NSAssert
#ifdef DEBUG
#define NSAssert(condition, info) \
do { \
@try { \
if (!(condition)) { \
if(tbim_check_debugger() == 0){      \
TLOG_ERROR(info)\
[NSException raise:@"Assert" format:@"%@",info];} \
else {TLOG_ALERT(info)} \
} \
}\
@catch (NSException *exception) {} \
} while (0);
#else
#define NSAssert(condition, info) \
do { \
if (!(condition)) {TLOG_ERROR(info)}\
} while (0);
#endif

#ifdef DEBUG
#define NSAssert_F(condition, frmt, ...) \
do { \
@try { \
if (!(condition)) { \
if(tbim_check_debugger() == 0){ \
TLOG_ERROR_F(frmt,##__VA_ARGS__) \
[NSException raise:@"Assert" format:@"Assert"];} \
else {TLOG_ALERT_F(frmt,##__VA_ARGS__)} \
} \
}\
@catch (NSException *exception) {} \
} while (0);
#else
#define NSAssert_F(condition, frmt, ...) \
do { \
if (!(condition)) { \
TLOG_ERROR_F(frmt,##__VA_ARGS__) \
} \
} while (0);
#endif

#define TLOG_ALERT(info) [[ALiLog GetInstance] showAssertAlert:__FILE__ funcName:__func__ line: __LINE__ msg:info];
#define TLOG_ALERT_F(fmt, ...) [[ALiLog GetInstance] showAssertAlert:__FILE__ funcName:__func__ line: __LINE__ msg:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];


#define TLOG_DEBUG_EMPTY [[ALiLog GetInstance] logDebugMsg:__FILE__ funcName:__func__ line: __LINE__ msg:@""];
#define TLOG_INFO_EMPTY  [[ALiLog GetInstance] logInfoMsg:__FILE__ funcName:__func__ line: __LINE__ msg:@""];
#define TLOG_WARN_EMPTY [[ALiLog GetInstance] logWarnMsg:__FILE__ funcName:__func__ line: __LINE__ msg:@""];
#define TLOG_ERROR_EMPTY [[ALiLog GetInstance] logErrorMsg:__FILE__ funcName:__func__ line: __LINE__ msg:@""];

#define TLOG_DEBUG(info) [[ALiLog GetInstance] logDebugMsg:__FILE__  funcName:__func__ line:__LINE__ msg:info];
#define TLOG_INFO(info)  [[ALiLog GetInstance] logInfoMsg:__FILE__ funcName:__func__ line:__LINE__ msg:info];
#define TLOG_WARN(info)  [[ALiLog GetInstance] logWarnMsg:__FILE__  funcName:__func__ line: __LINE__ msg:info];
#define TLOG_ERROR(info) [[ALiLog GetInstance] logErrorMsg:__FILE__  funcName:__func__ line: __LINE__ msg:info];

#define TLOG_DEBUG_F(fmt, ...) [[ALiLog GetInstance] logDebugMsg:__FILE__ funcName:__func__ line: __LINE__ msg:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];
#define TLOG_INFO_F(fmt, ...)  [[ALiLog GetInstance] logInfoMsg:__FILE__ funcName:__func__ line: __LINE__ msg:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];
#define TLOG_WARN_F(fmt, ...) [[ALiLog GetInstance] logWarnMsg:__FILE__ funcName:__func__ line: __LINE__ msg:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];
#define TLOG_ERROR_F(fmt, ...) [[ALiLog GetInstance] logErrorMsg:__FILE__ funcName:__func__ line: __LINE__ msg:[NSString stringWithFormat:fmt, ##__VA_ARGS__]];


int tbim_check_debugger( );


@interface ALiLog : NSObject

+ (instancetype)GetInstance;
- (NSString*)getLogFilePath;

- (void)showAssertAlert:(const char*)file funcName:(const char*)func line:(int)line msg:(NSString*)msg;
- (void)logDebugMsg:(const char*)file funcName:(const char*)func line:(int)line msg:(NSString *) msg;
- (void)logInfoMsg:(const char*)file funcName:(const char*)func line:(int)line msg:(NSString *) msg;
- (void)logWarnMsg:(const char*)file funcName:(const char*)func line:(int)line msg:(NSString *) msg;
- (void)logErrorMsg:(const char*)file funcName:(const char*)func line:(int)line msg:(NSString *) msg;
- (void)setDebugLogOpen:(BOOL)isDebugLogOpen;
@end
