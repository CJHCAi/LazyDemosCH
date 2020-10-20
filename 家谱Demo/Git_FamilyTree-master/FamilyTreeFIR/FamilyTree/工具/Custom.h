//
//  Custom.h
//  测试接口
//
//  Created by 姚珉 on 16/5/25.
//  Copyright © 2016年 yaomin. All rights reserved.
//

#ifndef Custom_h
#define Custom_h

//NSLog
#ifdef DEBUG        //调试状态打开LOG功能
#define MYLog(...) NSLog(__VA_ARGS__)
#else               //发布状态关闭LOG功能
#define MYLog(...)
#endif

//weakSelf
#define WK(weakSelf) \
__block __weak __typeof(&*self)weakSelf = self;
//ranking..
#define __kWidth [[UIScreen mainScreen]bounds].size.width
#define __kHeight [[UIScreen mainScreen]bounds].size.height
#define __k4Height         480
#define __k5Height         568
#define __k6Height         667
#define __k6pHeigt         736
//button
# define BtnNormal            UIControlStateNormal
# define BtnTouchUpInside     UIControlEventTouchUpInside
# define BtnStateSelected     UIControlStateSelected
# define BtnHighlighted       UIControlStateHighlighted

//屏幕宽高

#define Screen_width CGRectGetWidth([UIScreen mainScreen].bounds)
#define Screen_height CGRectGetHeight([UIScreen mainScreen].bounds)
#define StatusBar_Height [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavigationBar_Height self.navigationController.navigationBar.frame.size.height
#define HeightExceptNaviAndTabbar (Screen_height-64-self.tabBarController.tabBar.bounds.size.height)
//view自身宽高
#define SelfView_width self.bounds.size.width
#define SelfView_height self.bounds.size.height

//导航栏，状态栏

#define StatusBar_Height [[UIApplication sharedApplication] statusBarFrame].size.height
#define NavigationBar_Height self.navigationController.navigationBar.frame.size.height

//字体大小
#define MFont(font)   [UIFont systemFontOfSize:(font)]
#define BFont(font)   [UIFont boldSystemFontOfSize:(font)]
#define WFont(font)   [UIFont systemFontOfSize:(font*AdaptationWidth())]
//图片命名
#define MImage(image) [UIImage imageNamed:(image)]


#define IsNull(__Text) [__Text isKindOfClass:[NSNull class]]
#define IsEquallString(_Str1,_Str2)  [_Str1 isEqualToString:_Str2]
//RGB
#define LH_RGBCOLOR(R, G, B)    [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:1.0]
#define BorderColor LH_RGBCOLOR(215, 215, 215).CGColor
#define LH_RandomColor          LH_RGBCOLOR(arc4random_uniform(255),arc4random_uniform(255),arc4random_uniform(255))
//addmethod
#define CGRectOrigin(v)    v.frame.origin
#define CGRectSize(v)      v.frame.size
#define CGRectX(v)         CGRectOrigin(v).x
#define CGRectY(v)         CGRectOrigin(v).y
#define CGRectW(v)         CGRectSize(v).width
#define CGRectH(v)         CGRectSize(v).height

#define CGRectXW(v)         (CGRectSize(v).width+CGRectOrigin(v).x)
#define CGRectYH(v)         (CGRectSize(v).height+CGRectOrigin(v).y)
#define USERDEFAULT [NSUserDefaults standardUserDefaults]

//RootURL
#define RootURL @"http://59.53.92.160:1085/Api/Mobile/TestPost"
//#define RootURL @"http://192.168.1.176:8081/Api/Mobile/TestPost"
//#define RootURL @"http://120.55.70.181:1080/Api/Mobile/TestPost"
#define SecretKeySend @"abc123"
#define SecretKeyReiceive @"123abc"

//创建家谱控件高度
#define InputView_height 40
//通知字段
#define LogStatusNotifacation @"loginNotifacation"
//管理家谱
#define ZeroContentOffset 580

//提示信息显示 时间
#define  SXLoadingTime 1.5

#define DidLoadFailure @"加载失败"
#define DidLoadSuccess @"加载成功"

#define LoadComplete @"已经加载完了"
#define IsLoading @"正在加载数据,请稍后..."


//登录信息
#define LoginStates @"loginStatus"
#define UserAccount @"userAccount"
#define UserPassword @"userPassword"
#define VIPLevel @"VIPLevel"
#define MeNickName @"MeNickname"


//保存用户登录信息
#define GetUserId  [USERDEFAULT valueForKey:@"userid"]

//判断数据是否为空
#define IsNilString(__String) (__String==nil || [__String isEqualToString:@""]|| [__String isEqualToString:@"null"])
#define IsNull(__Text) [__Text isKindOfClass:[NSNull class]]

//存贮路径
#define UserDocumentD NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]



#endif /* Custom_h */
