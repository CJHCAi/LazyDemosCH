//
//  PromptController.h
//  JiaPingMember
//
//  Created by Hailong Yu on 15/12/30.
//  Copyright © 2015年 zhongkeyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JGProgressHUD.h"

#define PromptManager [PromptController shareManager]

@interface PromptController : NSObject
+(PromptController*)shareManager;

/** HUD */
@property (nonatomic, strong) JGProgressHUD* HUD;

/**
 *  检查摄像头
 *
 *  @param showAlert 是否显示 alert (可用的时候不会弹出alert)
 *
 *  @return 是否可用
 */
- (BOOL)cameraCanRecordShowAlert:(BOOL)showAlert;

/**
 *  检查麦克风
 *
 *  @param showAlert 是否显示 alert (可用的时候不会弹出alert)
 *
 *  @return 是否可用
 */
- (BOOL)microphoneCanRecordShowAlert:(BOOL)showAlert;

/**
 *  @author 嘴爷, 2016-05-27 10:05:57
 *
 *  @brief 显示HUD
 *
 *  @param message 文字信息
 */
-(void)showJPGHUDWithMessage:(NSString*)message inView:(UIView*)view;

-(void)showSuccessJPGHUDWithMessage:(NSString*)message intView:(UIView*)view time:(NSInteger)time;

/**
 *  @author 嘴爷, 2016-05-27 10:05:26
 *
 *  @brief dismiss HUD
 */
-(void)dismissJPGHUD;

/**
 *  @author 嘴爷, 2016-05-27 10:05:19
 *
 *  @brief 一个按钮的alert
 *
 *  @param message     要提示的信息
 *  @param buttonTitle 按钮标题
 */
-(void)showAlertWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle block:(void (^)())block;

@end
