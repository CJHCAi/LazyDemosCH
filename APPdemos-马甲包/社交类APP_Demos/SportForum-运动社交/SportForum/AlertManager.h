//
//  AlertManager.h
//  H850App
//
//  Created by zhengying on 4/4/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//
#define ALERT_VIEW_ITEM_TAG_LABLE_TITLE  9
#define ALERT_VIEW_ITEM_TAG_BTN_QUIT  10
#define ALERT_VIEW_ITEM_TAG_BTN_CONFIRM  11
#define ALERT_VIEW_ITEM_TAG_CONTENTVIEW  12
#define ALERT_VIEW_ITEM_TAG_ALERT_VIEW  13
#define ALERT_VIEW_ITEM_TAG_FULL_VIEW  14

#import <Foundation/Foundation.h>
typedef BOOL (^ConfirmBlock)(id win);
typedef BOOL (^CancelBlock)(id win);

typedef enum  {
    ConfirmAlertButtonStyleNormal,
    ConfirmAlertButtonStyleRed,
} eConfirmAlertButtonStyle;


@interface AlertManager : NSObject

+(void)showAlertText:(NSString*)text;
+(void)showAlertText:(NSString*)text InView:(UIView*)view;
+(void)showAlertText:(NSString*)text InView:(UIView*)view hiddenAfter:(NSInteger)sec;

+(id)showCommonProgress;
+(id)showCommonProgressInView:(UIView*)view;

+(id)showCommonProgressWithText:(NSString*)text;
+(id)showCommonProgressWithText:(NSString*)text InView:(UIView*)view;

+(id)showConfirmAlertWithTitle:(NSString*)title
                          Text:(NSString*)text
            ConfirmButtonTitle:(NSString*)buttonText
            ConfirmButtonStyle:(eConfirmAlertButtonStyle)style
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock;

+(id)showConfirmAlertWithTitle:(NSString*)title
                          Text:(NSString*)text
            ConfirmButtonTitle:(NSString*)buttonText
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock;

+(id)showConfirmAlertWithTitle:(NSString*)title
                   ContentView:(UIView*)contentView
            ConfirmButtonTitle:(NSString*)buttonText
            ConfirmButtonStyle:(eConfirmAlertButtonStyle)style
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock;

+(id)showConfirmAlertWithTitle:(NSString*)title
                   ContentView:(UIView*)contentView
            ConfirmButtonTitle:(NSString*)buttonText
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock;

+(id)showConfirmAlertWithTitle:(NSString*)title
                          Text:(NSString*)text
            ConfirmButtonTitle:(NSString*)buttonText
            ConfirmButtonStyle:(eConfirmAlertButtonStyle)style
                   ConfirmBlock:(ConfirmBlock)ConfirmBlock
                   CancelBlock:(CancelBlock)cancelBlock;

+(id)showConfirmAlertWithTitle:(NSString*)title
                          Text:(NSString*)text
            ConfirmButtonTitle:(NSString*)buttonText
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock
                   CancelBlock:(CancelBlock)cancelBlock;

+(id)showConfirmAlertWithTitle:(NSString*)title
                   ContentView:(UIView*)contentView
            ConfirmButtonTitle:(NSString*)buttonText
            ConfirmButtonStyle:(eConfirmAlertButtonStyle)style
                  ConfirmBlock:(ConfirmBlock)confirmBlock
              WithCancelButton:(BOOL)bNeedCancelBtn
                   CancelBlock:(CancelBlock)cancelBlock;

+(id)showConfirmAlertWithTitle:(NSString*)title
                   ContentView:(UIView*)contentView
            ConfirmButtonTitle:(NSString*)buttonText
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock
                  CancelBlock:(CancelBlock)cancelBlock;

+(id)showConfirmAlertWithTitle:(NSString*)title
                   ContentView:(UIView*)contentView
            ConfirmButtonTitle:(NSString*)buttonText
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock
                   WithCancelButton:(BOOL)bNeedCancelBtn;

+(void)setCommonProgressViewID:(id)win Text:(NSString*)text;

+(CGFloat)widthWithAlertViewContentView;

+(id)getViewByID:(id)win Tag:(NSInteger)tag;

+(void)setYOffset:(CGFloat)offset ID:(id)win;

+(void)dissmiss:(id)win;


@end
