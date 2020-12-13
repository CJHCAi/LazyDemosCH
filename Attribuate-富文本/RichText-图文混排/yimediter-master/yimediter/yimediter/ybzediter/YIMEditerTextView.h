//
//  YIMEditerTextView.h
//  yimediter
//
//  Created by ybz on 2017/11/21.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YIMEditerAccessoryMenuItem.h"
#import "YIMEditerFontFamilyManager.h"
#import "YIMEditerDrawAttributes.h"
#import "YIMEditerParagraphView.h"
#import "YIMEditerProtocol.h"
#import "YIMEditerFontView.h"
#import "YIMEditerSetting.h"
#import "DefualtFontItem.h"
#import "DefualtParagraphItem.h"
#import "DefualtUndoTypingItem.h"





/**
 YIMEditer的TextView
 */
@interface YIMEditerTextView : UITextView

/**菜单栏*/
@property(nonatomic,strong)NSArray<YIMEditerAccessoryMenuItem*>* menus;
/**到新window时是否进入第一响应者 默认是true*/
@property(nonatomic,assign)BOOL toNewWindowIsBecomeFirstResponder;
/**所有样式对象*/
@property(nonatomic,strong,readonly)NSArray<id<YIMEditerStyleChangeObject>> *styleObjects;

/** 根据textView选择的range，更新所有样式对象的UI */
-(void)updateObjectsUI;
/** 添加代理 */
-(void)addUserDelegate:(id<YIMEditerTextViewDelegate>)del;
/** 添加一个样式对象 */
-(void)addStyleChangeObject:(id<YIMEditerStyleChangeObject>)styleChangeObj;
/** 输出html */
-(NSString*)outPutHtmlString;
/** 设置html，注意，，最好设置由该TextView输出的html，其他html崩溃不负责。。 */
-(void)setHtml:(NSString*)htmlString;

@end
