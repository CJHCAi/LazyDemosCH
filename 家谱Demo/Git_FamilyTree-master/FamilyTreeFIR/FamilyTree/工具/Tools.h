//
//  Tools.h
//  FamilyTree
//
//  Created by 王子豪 on 16/5/24.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DefineHeader.h"

#import "WGennerationModel.h"
@interface Tools : NSObject

#pragma mark *** VC Titles ***

UIKIT_EXTERN NSString * _Nonnull const kStringWithHomeVcTitle;
UIKIT_EXTERN NSString * _Nonnull const kStringWithFamilyTreeVcTitle;
UIKIT_EXTERN NSString * _Nonnull const kStringWithServiceVcTitle;
UIKIT_EXTERN NSString * _Nonnull const kStringWithPersonalCenterVcTitle;

#pragma mark *** VC Images ***
UIKIT_EXTERN NSString * _Nonnull const kImageWithHomeVc;
UIKIT_EXTERN NSString * _Nonnull const kImageWithFamilyTreeVc;
UIKIT_EXTERN NSString * _Nonnull const kImageWithServiceVc;
UIKIT_EXTERN NSString * _Nonnull const kImageWithPersonalCenterVc;

#pragma mark *** VC SelectedImages ***

UIKIT_EXTERN NSString * _Nonnull const kSelectedImageWithHomeVc;
UIKIT_EXTERN NSString * _Nonnull const kSelectedImageWithFamilyTreeVc;
UIKIT_EXTERN NSString * _Nonnull const kSelectedImageWithServiceVc;
UIKIT_EXTERN NSString * _Nonnull const kSelectedImageWithPersonalCenterVc;

#pragma mark *** 网络请求requestCode ***

UIKIT_EXTERN NSString * _Nonnull const kRequestCodeLogin;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeRegister;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeUpdatePassword;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeBackPassword;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeEditProfile;

UIKIT_EXTERN NSString * _Nonnull const kRequestCodeGetMemallInfo;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeQueryMem;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeQuerygendata;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeGetsyntype;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeUpdatepswd;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeGetprovince;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeGetVIPtq;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeGetMemys;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeUploadCefm;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeCemeteryList;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeEditCemetery;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeDelcemetery;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeCemeterDetail;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeBarrageList;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeCreateBarrage;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeRitual;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeGetNewsList;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeGetFamilyNamesList;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeGetFamilyNamesDetail;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeGetNewsDetail;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeQueryClan;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeUploadMemimg;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeMemySadd;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeCreateZqhz;
UIKIT_EXTERN NSString * _Nonnull const kRequestCodeUploadClan;
/**
 *  弹出框自动消失
 *
 *  @param title 弹出框内容
 */

/**
 *  弹出框
 *
 *  @param target  调用UIAlertController的对象
 *  @param message 提示语句
 *  @param time    延时多少秒消失
 */
+ (void)showAlertViewControllerAutoDissmissWithTarGet:(id _Nonnull)target Message:(NSString * _Nonnull)message delay:(NSInteger)time complete:(void (^ _Nullable)(BOOL))complete;

/**
 *  弹出框带确定消失按钮
 *
 *  @param target   调用UIAlertController的对象一般为selfVC
 *  @param message  提示语句
 *  @param complete 完成点击取消确定
 */

+ (void)showAlertViewcontrollerWithTarGet:(id _Nonnull)target Message:(NSString * _Nonnull)message complete:(void (^ _Nullable)(BOOL sure))complete;


@end
