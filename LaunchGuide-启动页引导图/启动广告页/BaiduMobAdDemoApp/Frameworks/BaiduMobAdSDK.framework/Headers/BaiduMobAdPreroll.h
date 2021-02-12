//
//  BaiduMobAdVideo.h
//  BaiduMobAdSdk
//
//  Created by lishan04 on 15-6-8.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaiduMobAdPrerollDelegate.h"

@interface BaiduMobAdPreroll : NSObject
/**
 *  委托对象
 */
@property (nonatomic ,assign) id<BaiduMobAdPrerollDelegate> delegate;
/**
 *  应用的APPID
 */
@property(nonatomic, copy) NSString *publisherId;
/**
 *  设置/获取代码位id
 */
@property(nonatomic, copy) NSString *adId;
/**
 *  设置前贴baseview
 */
@property(nonatomic, retain) UIView *renderBaseView;
/**
 *  请求广告
 */
- (void)request;

@end
