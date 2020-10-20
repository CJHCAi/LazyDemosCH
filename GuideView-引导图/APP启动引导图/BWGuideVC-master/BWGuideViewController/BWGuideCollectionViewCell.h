//
//  BWGuideCollectionViewCell.h
//  BWGuideViewController
//
//  Created by syt on 2019/12/20.
//  Copyright © 2019 syt. All rights reserved.
//

#import <UIKit/UIKit.h>

/**判断是否是ipad*/
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
/**判断iPhone4系列*/
#define is_IPhone_4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
/**判断iPhone5系列*/
#define is_IPhone_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
/**判断iPhone6 6s 7系列*/
#define is_IPhone_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
/**判断iPhone6p 6sp 7p系列*/
#define is_IPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
/**判断iPhoneX，Xs（iPhoneX，iPhoneXs）*/
#define is_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
/**判断iPhoneXr*/
#define is_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
/**判断iPhoneXsMax*/
#define is_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)&& !isPad : NO)
/**判断iPhoneX及以上系列所有系列*/
#define is_PhoneXAll             (is_IPHONE_X || is_IPHONE_Xr || is_IPHONE_Xs_Max)


/**状态栏的高度*/
#define k_StatusBar_Height   (is_PhoneXAll ? 44.0 : 20.0)
/**导航栏的高度*/
#define k_NavBar_Height      (is_PhoneXAll ? 88.0 : 64.0)
/**tabBar栏高度差*/
#define k_TabBar_DValue_Height (is_PhoneXAll ? 34.0 : 0.0)
/**tabar高度*/
#define k_TabBar_Height      (is_PhoneXAll ? 83.0 : 49.0)

/**屏幕宽度*/
#define k_Screen_Width      [UIScreen mainScreen].bounds.size.width
/**屏幕高度*/
#define k_Screen_Height     [UIScreen mainScreen].bounds.size.height

NS_ASSUME_NONNULL_BEGIN

@interface BWGuideCollectionViewCell : UICollectionViewCell


@property (nonatomic, copy) void (^enterButtonClick) (void);

- (void)updateContent:(NSString *)imgName isHiden:(BOOL)isHiden;

@end

NS_ASSUME_NONNULL_END
