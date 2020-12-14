//
//  BaiduMobAdNativeAdView.h
//  BaiduMobAdSdk
//
//  Created by lishan04 on 15-1-6.
//
//

#import <UIKit/UIKit.h>
#import "BaiduMobAdCommonConfig.h"
@class BaiduMobAdNativeVideoBaseView;
@class BaiduMobAdNativeAdObject;
@class BaiduMobAdNativeWebView;
@interface BaiduMobAdNativeAdView : UIView 

typedef void (^BaiduMobAdViewCompletionBlock)(NSArray *errors);

/**
 * 初始化，非视频信息流，MaterialType是NORMAL的初始化方法
 * 添加品牌名称brandName
 */
-(id)initWithFrame:(CGRect)frame
         brandName:(UILabel *) brandLabel
             title:(UILabel *) titleLabel
              text:(UILabel *) textLabel
              icon:(UIImageView *) iconView
         mainImage:(UIImageView *) mainView;

/**
 * 如果MaterialType是VIDEO的初始化方法
 * 添加品牌名称brandName
 1.开发者可用百度自带播放器组建BaiduMobAdNativeVideoView渲染，并传入视频view
 2.开发者可使用自己的视频播放控件渲染，并传入视频view
 */
-(id)initWithFrame:(CGRect)frame
         brandName:(UILabel *) brandLabel
             title:(UILabel *) titleLabel
              text:(UILabel *) textLabel
              icon:(UIImageView *) iconView
         mainImage:(UIImageView *) mainView
         videoView:(BaiduMobAdNativeVideoBaseView *) videoView;
/**
 * 如果MaterialType是HTML的初始化方法
 */
-(id)initWithFrame:(CGRect)frame
           webview:(BaiduMobAdNativeWebView *) webView;



/**
 * 小图
 */
@property (assign, nonatomic)  UIImageView *iconImageView;
/**
 * 大图
 */
@property (assign, nonatomic)  UIImageView *mainImageView;

/**
 * 广告标示
 */
@property (assign, nonatomic)  UIImageView *adLogoImageView;
/**
 * 百度广告logo
 */
@property (assign, nonatomic)  UIImageView *baiduLogoImageView;

/**
 * 标题 view
 */
@property (assign, nonatomic)  UILabel *titleLabel;
/**
 * 描述 view
 */
@property (assign, nonatomic)  UILabel *textLabel;
/**
 * 品牌名称 view
 */
@property (assign, nonatomic)  UILabel *brandLabel;
/**
 * 视频 view
 */
@property (assign, nonatomic)  BaiduMobAdNativeVideoBaseView *videoView;
/**
 * web view
 */
@property (assign, nonatomic)  BaiduMobAdNativeWebView *webView;
/**
 *  展示用的vc, 可以不传
 */
@property (nonatomic, assign)  UIViewController *presentAdViewController;

/**
 * 根据BaiduMobAdNativeAdObject广告内容，在广告视图上缓存和展示广告,同时关联广告视图和点击展现行为
 * object 包含文字内容和物料地址
 */
- (void)loadAndDisplayNativeAdWithObject:(BaiduMobAdNativeAdObject *)object completion:(BaiduMobAdViewCompletionBlock)completionBlock;
/**
 * 发送展现日志
 */
- (void)trackImpression;
@end
