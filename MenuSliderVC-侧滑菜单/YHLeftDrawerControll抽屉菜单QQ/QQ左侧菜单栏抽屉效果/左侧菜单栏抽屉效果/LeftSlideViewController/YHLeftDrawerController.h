//
//  YHLeftDrawerController.h
//  左侧菜单栏抽屉效果
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView_extra.h"

#define kScreenSize           [[UIScreen mainScreen] bounds].size
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight         [[UIScreen mainScreen] bounds].size.height

#define kMainPageDistance   60   //打开左侧窗时，中视图(右视图)露出的宽度
#define kMainPageScale   0.8  //打开左侧窗时，中视图(右视图）缩放比例,可以设置在 0 ~ 1
#define kMainPageCenter  CGPointMake(kScreenWidth + kScreenWidth * kMainPageScale / 2.0 - kMainPageDistance, kScreenHeight / 2)  //打开左侧窗时，中视图中心点

#define vCouldChangeDeckStateDistance  (kScreenWidth - kMainPageDistance) / 2.0 - 40 //滑动距离大于此数时，状态改变（关--》开，或者开--》关）
#define vSpeedFloat   0.7    //滑动速度

#define kLeftAlpha 0.9  //左侧蒙版的最大值
#define kLeftCenterX 30 //左侧初始偏移量
#define kLeftScale 0.7 //左侧初始缩放比例

#define vDeckCanNotPanViewTag    987654   // 不响应此侧滑的View的tag


@interface YHLeftDrawerController : UIViewController


//滑动速度系数-建议在0.5-1之间。默认为0.5
@property (nonatomic, assign) CGFloat speedf;

//左侧窗控制器
@property (nonatomic, strong) UIViewController *leftVC;

// 中心控制器
@property (nonatomic, strong) UIViewController *mainVC;
// 点击手势控制器，是否允许点击视图恢复视图位置。默认为 YES
@property (nonatomic, strong) UITapGestureRecognizer *sideslipTapGes;

// 滑动手势控制器
@property (nonatomic, strong) UIPanGestureRecognizer *pan;

// 侧滑窗是否关闭(关闭时显示为主页)
@property (nonatomic, assign) BOOL closed;


/**
 @brief 初始化侧滑控制器
 @param leftVC 左侧菜单控制器
 mainVC 中间视图控制器
 @result instancetype 初始化生成的对象, 设置成window的根控制器,即可
 */
- (instancetype)initWithLeftView:(UIViewController *)leftVC
                     andMainView:(UIViewController *)mainVC;

/**
 @brief 关闭左侧控制器
 */
- (void)closeLeftView;


/**
 @brief 打开左侧控制器
 */
- (void)openLeftView;

/**
 *  设置滑动开关是否开启
 *
 *  @param enabled YES:支持滑动手势，NO:不支持滑动手势
 */
- (void)setPanEnabled: (BOOL) enabled;

@end
