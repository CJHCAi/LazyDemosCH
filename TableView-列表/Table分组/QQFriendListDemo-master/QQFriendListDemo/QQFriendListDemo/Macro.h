//
//  Macro.h
//  核心动画
//
//  Created by 朱伟阁 on 2018/12/28.
//  Copyright © 2018 朱伟阁. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define UICOLOR_HEX(hexString) [UIColor colorWithRed:((float)((hexString &0xFF0000) >>16))/255.0 green:((float)((hexString &0xFF00) >>8))/255.0 blue:((float)(hexString &0xFF))/255.0 alpha:1.0]
#define UICOLOR_RGB(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define UICOLOR_RANDOM  [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0]
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define KWeakSelf __weak typeof(self) weakSelf = self;

#define DT_IS_IPHONEX_XS (SCREENHEIGHT == 812.f)//是否是iPhoneX、iPhoneXS
#define DT_IS_IPHONEXR_XSMax (SCREENHEIGHT == 896.f)//是否是iPhoneXR、iPhoneX Max
#define IS_IPHONEX_SET (DT_IS_IPHONEX_XS||DT_IS_IPHONEXR_XSMax)//是否是iPhoneX系列手机
#define State_Bar_H ((![[UIApplication sharedApplication] isStatusBarHidden]) ? [[UIApplication sharedApplication] statusBarFrame].size.height : (IS_IPHONEX_SET?44.f:20.f))
#define SafeAreaBottom_H ((IS_IPHONEX_SET) ? 34.f : 0.f)
#define Tab_Bar_H 49.f
#define Nav_Bar_H 44.f

#endif /* Macro_h */
