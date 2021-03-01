//
//  BUAdSDKManager.h
//  BUAdSDK
//
//  Copyright © 2017 bytedance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BUAdSDKDefines.h"
#import "BUMopubAdMarkUpDelegate.h"

///CN china, NO_CN is not china
typedef NS_ENUM(NSUInteger, BUAdSDKTerritory) {
    BUAdSDKTerritory_CN = 1,
    BUAdSDKTerritory_NO_CN,
};

@class BUAdSlot;

typedef void (^BUConfirmGDPR)(BOOL isAgreed);

@interface BUAdSDKManager : NSObject

@property (nonatomic, copy, readonly, class) NSString *SDKVersion;
/**
This property should be set when integrating non-China areas at the same time, otherwise it does not need to be set.you‘d better set Territory first,  if you need to set them
@param territory : Regional value
*/
+ (void)setTerritory:(BUAdSDKTerritory)territory;
/**
 Register the App key that’s already been applied before requesting an ad from TikTok Audience Network.
 @param appID : the unique identifier of the App
 */
+ (void)setAppID:(NSString *)appID;
/**
 Configure development mode.
 @param level : default BUAdSDKLogLevelNone
 */
+ (void)setLoglevel:(BUAdSDKLogLevel)level;

/* Set the COPPA of the user, COPPA is the short of Children's Online Privacy Protection Rule, the interface only works in the United States.
 * @params Coppa 0 adult, 1 child
 */
+ (void)setCoppa:(NSUInteger)Coppa;

/// Set the user's keywords, such as interests and hobbies, etc.
/// Must obtain the consent of the user before incoming.
+ (void)setUserKeywords:(NSString *)keywords;

/// set additional user information.
+ (void)setUserExtData:(NSString *)data;

/// Set whether the app is a paid app, the default is a non-paid app.
/// Must obtain the consent of the user before incoming
+ (void)setIsPaidApp:(BOOL)isPaidApp;

/// Solve the problem when your WKWebview post message empty,default is BUOfflineTypeWebview
+ (void)setOfflineType:(BUOfflineType)type;

/// Custom set the GDPR of the user,GDPR is the short of General Data Protection Regulation,the interface only works in The European.
/// @params GDPR 0 close privacy protection, 1 open privacy protection
+ (void)setGDPR:(NSInteger)GDPR;

/// Custom set the AB vid of the user. Array element type is NSNumber
+ (void)setABVidArray:(NSArray<NSNumber *> *)abvids;

/// Custom set the tob ab sdk version of the user.
+ (void)setABSDKVersion:(NSString *)abSDKVersion;

/// Custom set disable sdadnetwork. if won't need skadnetwork to record conversion set disable to YES, default is enable
+ (void)setDisableSKAdNetwork:(BOOL)disable;

/// Open GDPR Privacy for the user to choose before setAppID.
+ (void)openGDPRPrivacyFromRootViewController:(UIViewController *)rootViewController confirm:(BUConfirmGDPR)confirm;

/// Custom set idfa value
+ (void)setCustomIDFA:(NSString *)idfa;

/// get appID
+ (NSString *)appID;

/// get isPaidApp
+ (BOOL)isPaidApp;

/// get GDPR
+ (NSInteger)GDPR;

/// get coppa
+ (NSUInteger)coppa;

@end


@interface BUAdSDKManager (MopubAdaptor) <BUMopubAdMarkUpDelegate>

@end

@interface BUAdSDKManager (BUAdNR)
+ (NSDictionary *)bunr_dictionaryWithSlot:(BUAdSlot *)slot isDynamicRender:(BOOL)isDynamicRender;
@end
