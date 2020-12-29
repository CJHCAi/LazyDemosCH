


//------------------------------------------------------------
// 全局日志开关, 调试开关. 发布时关闭此宏

#define TALKER_DEBUG

#ifdef TALKER_DEBUG

#define  DEBUG_LOG(_str) NSLog(_str)
#define  DEBUG_LOG1(_str,_p) NSLog(_str,_p)
#define  DEBUG_LOG2(_str,_p1,_p2) NSLog(_str,_p1,_p2)
#define  DEBUG_LOG3(_str,_p1,_p2,_p3) NSLog(_str,_p1,_p2,_p3)

#else

#define  DEBUG_LOG(_str);
#define  DEBUG_LOG1(_str,_p);
#define  DEBUG_LOG2(_str,_p1,_p2);
#define  DEBUG_LOG3(_str,_p1,_p2,_p3);

#endif


//------------------------------------------------------------
#pragma mark 网络接口

//#ifdef TALKER_DEBUG

#define kInterfaceBaseUrl @"http://wall.yilongapk.com/"//!<测试服务器


//#else
//
//#define kInterfaceBaseUrl @"http://wall.yilongapk.com/"//!<线上服务器
//
//
//
//#endif


//------------------------------------------------------------
#pragma mark 各平台key


//------------------------------------------------------------
#pragma mark 全局参数

//友盟
#define MobClickKey @"5723128d67e58e23320008d8"
/*屏幕高宽
 */
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)

/*版本
 */
#define Version ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
/*颜色配置
 */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define colorAll UIColorFromRGB(0x272636)
//#define ColorOrgane UIColorFromRGB(0xFF5400)



