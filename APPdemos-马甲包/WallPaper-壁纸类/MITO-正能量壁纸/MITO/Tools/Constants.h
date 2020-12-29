//
//  Constants.h
//  MITO
//
//  Created by keenteam on 2017/12/9.
//  Copyright © 2017年 keenteam. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

//屏幕宽度
#define kWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define kHeight [UIScreen mainScreen].bounds.size.height

//16>10
#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
//rgb颜色转换
#define is_IOS_7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define UIColorFromRGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

#define  DOCUMENTPATH   NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject

//防止循环引用
#define DefineWeakSelf __weak __typeof(self) weakSelf = self
// 大于375宽度屏幕以375为参照按比例取值，其他不变
#define KTSALE_kWidht_NUM  (kWidth / 375.f )
#define KTSALE_kWidht_Plus(x)     KTSALE_kWidht_NUM * (x)


CG_INLINE CGRect CGRectMakeKT(CGFloat x,CGFloat y,CGFloat width,CGFloat height)
{
    return CGRectMake(x *KTSALE_kWidht_NUM,  y *KTSALE_kWidht_NUM, width *KTSALE_kWidht_NUM, height *KTSALE_kWidht_NUM);
}

CG_INLINE CGSize CGSizeMakeKT(CGFloat width, CGFloat height)
{
    return CGSizeMake(width *KTSALE_kWidht_NUM, height *KTSALE_kWidht_NUM);
}

CG_INLINE CGPoint CGPointMakeKT(CGFloat x,CGFloat y)
{
    return CGPointMake(x *KTSALE_kWidht_NUM, y *KTSALE_kWidht_NUM);
}

CG_INLINE UIEdgeInsets UIEdgeInsetsMakeKT(CGFloat top,CGFloat  left,CGFloat bottom,CGFloat right)
{
    return UIEdgeInsetsMake( top*KTSALE_kWidht_NUM, left*KTSALE_kWidht_NUM, bottom *KTSALE_kWidht_NUM, right *KTSALE_kWidht_NUM);
}


#endif /* Constants_h */
