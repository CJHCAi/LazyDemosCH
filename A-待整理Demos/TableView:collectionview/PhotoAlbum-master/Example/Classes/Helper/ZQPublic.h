//
//  ZQPublic.h
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/1.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#ifndef ZQPublic_h
#define ZQPublic_h


#define HEXCOLORA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:a]
#define HEXCOLOR(rgbValue) HEXCOLORA(rgbValue, 1.0)

#define cacheLimit 50*1024*1024 //50M
#define cacheThumbLimit 20*1024*1024 //20M

//其他颜色：线条，不可用等
#define ZQColorOther       HEXCOLOR(0xded8d7)
#define ZQChoosePhotoNavBtnColor        HEXCOLOR(0x000)

#define kTPScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kTPScreenHeight  [UIScreen mainScreen].bounds.size.height

#define ZQSide_X 16
#define kBottomToolbarHeight 44
#define kDarkBottomBarBGColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#define kLightBottomBarBGColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5]

//weak strong
#define  __WS(weakSelf)     __weak __typeof(&*self) weakSelf = self
#define  ______WS()         __weak __typeof(&*self) wSelf = self
#define  ______SS()         __strong __typeof(&*wSelf) sSelf = wSelf
#define  ______WX(x,y)      __weak __typeof(&*x) y = x


#endif /* ZQPublic_h */
