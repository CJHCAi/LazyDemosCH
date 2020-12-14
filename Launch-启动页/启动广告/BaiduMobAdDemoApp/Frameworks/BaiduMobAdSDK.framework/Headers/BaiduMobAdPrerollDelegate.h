//
//  BaiduMobAdPrerollDelegate.h
//  BaiduMobAdSdk
//
//  Created by lishan04 on 15-6-8.
//
//

#import <Foundation/Foundation.h>
#import "BaiduMobAdCommonConfig.h"

@class BaiduMobAdPreroll;

@protocol BaiduMobAdPrerollDelegate <NSObject>

@optional
/**
 *  渠道ID
 */
- (NSString *)channelId;
/**
 *  启动位置信息
 */
-(BOOL) enableLocation;

/**
 *  广告准备播放
 */
- (void)didAdReady:(BaiduMobAdPreroll *)preroll;

/**
 *  广告展示失败
 */
- (void)didAdFailed:(BaiduMobAdPreroll *)preroll withError:(BaiduMobFailReason) reason;

/**
 *  广告展示成功
 */
- (void)didAdStart:(BaiduMobAdPreroll *)preroll;

/**
 *  广告展示结束
 */
- (void)didAdFinish:(BaiduMobAdPreroll *)preroll;

/**
 *  广告点击
 */
- (void)didAdClicked:(BaiduMobAdPreroll *)preroll;

/**
 *  在用户点击完广告条出现全屏广告页面以后，用户关闭广告时的回调
 */
- (void)didDismissLandingPage;

///---------------------------------------------------------------------------------------
/// @name 人群属性板块
///---------------------------------------------------------------------------------------

/**
 *  关键词数组
 */
-(NSArray*) keywords;

/**
 *  用户性别
 */
-(BaiduMobAdUserGender) userGender;

/**
 *  用户生日
 */
-(NSDate*) userBirthday;

/**
 *  用户城市
 */
-(NSString*) userCity;


/**
 *  用户邮编
 */
-(NSString*) userPostalCode;


/**
 *  用户职业
 */
-(NSString*) userWork;

/**
 *  - 用户最高教育学历
 *  - 学历输入数字，范围为0-6
 *  - 0代表小学，1代表初中，2代表中专/高中，3代表专科
 *  - 4代表本科，5代表硕士，6代表博士
 */
-(NSInteger) userEducation;

/**
 *  - 用户收入
 *  - 收入输入数字,以元为单位
 */
-(NSInteger) userSalary;

/**
 *  用户爱好
 */
-(NSArray*) userHobbies;

/**
 *  其他自定义字段,key以及value都为NSString
 */
-(NSDictionary*) userOtherAttributes;


@end
