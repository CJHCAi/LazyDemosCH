/** 布局尺寸 */
// 屏幕尺寸
#define DDYSCREENBOUNDS [UIScreen mainScreen].bounds
#define DDYSCREENSIZE [UIScreen mainScreen].bounds.size
// 需要横屏或者竖屏，获取屏幕宽度与高度
#define DDYSCREENW [UIScreen mainScreen].bounds.size.width
#define DDYSCREENH [UIScreen mainScreen].bounds.size.height
/**
 #define kScreenWidth \
 ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.width)
 #define kScreenHeight \
 ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale : [UIScreen mainScreen].bounds.size.height)
 #define kScreenSize \
 ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)
 */
// 控制器中使用，获得导航高度
#define DDYNAVBARH self.navigationController.navigationBar.bounds.size.height
// 获取状态条高度 iPhoneX 44 其他20 有后台(比如后台音乐)+20
#define DDYstatusH [[UIApplication sharedApplication] statusBarFrame].size.height
// 安全区域
#define DDYSafeInsets(view) ({ UIEdgeInsets i; if (@available(iOS 11.0, *)) { i = view.safeAreaInsets; } else { i = UIEdgeInsetsZero; } i; })

// 是否竖屏 BOOL
#define DDYPortrait (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact && self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)

/** 颜色 */
// [0, 1]范围
#define DDYColor(r,g,b,a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]
// [0, 255]范围
#define DDYRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
// 随机色
#define DDYRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
// 深黑
#define DDY_Big_Black [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]
// 中黑
#define DDY_Mid_Black [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1.0]
// 浅黑
#define DDY_Small_Black [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0]
// 系统黑色 0.0 white
#define DDY_Black [UIColor blackColor]
// 系统白色 1.0 white
#define DDY_White [UIColor whiteColor]
// 系统浅灰 0.667 white
#define DDY_LightGray [UIColor lightGrayColor]
// 系统深灰 0.333 white
#define DDY_DarkGray [UIColor darkGrayColor]
// 系统灰色 0.5 white
#define DDY_Gray [UIColor grayColor]
// 系统红色 1.0, 0.0, 0.0 RGB
#define DDY_Red [UIColor redColor]
// 系统绿色 0.0, 1.0, 0.0 RGB
#define DDY_Green [UIColor greenColor]
// 系统蓝色 0.0, 0.0, 1.0 RGB
#define DDY_Blue [UIColor blueColor]
// 系统无色 0.0 white, 0.0 alpha
#define DDY_ClearColor [UIColor clearColor]

/** 字体 */
#define DDYFont(f) [UIFont systemFontOfSize:(f)]
#define DDYBDFont(f) [UIFont boldSystemFontOfSize:(f)]

/** 本地存储 */
#define DDYUserDefaults [NSUserDefaults standardUserDefaults]
#define DDYUserDefaultsGet(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define DDYUserDefaultsSet(objt, key)\
\
[[NSUserDefaults standardUserDefaults] setObject:objt forKey:key];\
[[NSUserDefaults standardUserDefaults] synchronize]

/** 通知中心 */
#define DDYNotificationCenter [NSNotificationCenter defaultCenter]
/** 排序规则 */
#define DDYCollation [UILocalizedIndexedCollation currentCollation]
/** 文件管理器 */
#define DDYFileManager [NSFileManager defaultManager]

/** 为view设置圆角和边框 */
#define DDYBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

/** 沙盒路径:temp,Document,Cache */
#define DDYPathTemp NSTemporaryDirectory()
#define DDYPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define DDYPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

/** 系统版本 */
#define IOS_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_8_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IOS_9_LATER  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IOS_10_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
#define IOS_11_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)


/** 语言 */
// 获取当前语言
#define DDYCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
// 国际化
#define DDYLocalStr(key)  [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:nil]
#define DDYLocalStrFromTable(key, tbl)  [NSBundle.mainBundle localizedStringForKey:(key) value:@"" table:(tbl)]

/**  常数 */
#define DDYPI 3.14159265358979323846

/** masonry */
// 定义这个常量,就可以在使用Masonry不必总带着前缀 `mas_`:
#define MAS_SHORTHAND
// 定义这个常量,以支持在 Masonry 语法中自动将基本类型转换为 object 类型:
#define MAS_SHORTHAND_GLOBALS

/** 几个缩写 */
#define DDYApplication [UIApplication sharedApplication]
#define DDYAppDelegate [UIApplication sharedApplication].delegate
#define DDYKeyWindow \
(UIApplication.sharedApplication.delegate.window ? \
UIApplication.sharedApplication.delegate.window : \
UIApplication.sharedApplication.keyWindow)
// DDYKeyWindow.safeAreaInsets.bottom

/** 判断真机模拟器 必须先判断TARGET_IPHONE_SIMULATOR，原因自行search */
#if TARGET_IPHONE_SIMULATOR
// 模拟器
#elif TARGET_OS_IPHONE
// 真机
#endif

/** 日志 */
// 处于开发阶段
#ifdef DEBUG
#define DDYLog(fmt, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);
//#define DDYInfoLog(fmt, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, ［NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);
#define DDYInfoLog(fmt, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
[dateFormatter setDateFormat:@"HH:mm:ss:SSS"]; \
NSString *str = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr,"[%s %s %d]: %s\n",[str UTF8String], [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);\
}
//#define DDYInfoLog(fmt, ...) NSLog((@"\n[fileName:%s]\n[methodName:%s]\n[lineNumber:%d]\n" fmt),__FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
// 处于发布阶段
#else
#define DDYLog(...)
#define DDYInfoLog(...)
#endif

/** 线程 */
// 异步子线程
#define ddy_async_global_queue(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
// 保证异步主线程
#define ddy_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

/** weak & strong */
// 有autoreleasepool 加@ 例如 @weakify(self) @strongify(self)
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

/** 单例 */
#define DDYSingle(name) +(instancetype)share##name;

#if __has_feature(objc_arc)

#define singleM(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)share##name\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}
#else
#define singleM static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)shareTools\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
-(oneway void)release\
{\
}\
\
-(instancetype)retain\
{\
return _instance;\
}\
\
-(NSUInteger)retainCount\
{\
return MAXFLOAT;\
}
#endif
