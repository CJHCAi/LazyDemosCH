//
//  CCTextField.h
//  CCTextField
//
//  Created by cyd on 2017/9/11.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 输入内容校验，通过checkState属性取出校验结果
typedef NS_ENUM(NSInteger, CCCheckType){
    CCCheckTel,             // 座机(校验格式: "xxx-xxxxxxx"、"xxxx-xxxxxxxx"、"xxx-xxxxxxx"、"xxx-xxxxxxxx"、"xxxxxxx"、"xxxxxxxx")
    CCCheckNone,            // 不做校验
    CCCheckDate,            // 日期(校验格式: "xxxx-xx-xx"、"xxxx-x-x")
    CCCheckEmail,           // 邮箱
    CCCheckPhone,           // 手机号
    CCCheckMoney,           // 金额(校验格式: "10000.0"、"10,000.0"、"10000"、"10,000")
    CCCheckFloat,           // 浮点数(校验格式: "10"、"10.0")
    CCCheckDomain,          // 域名
    CCCheckIDCard,          // 身份证(18位)
    CCCheckAccount,         // 帐号(字母开头，允许字母、数字、下划线，长度在6个以上)
    CCCheckZipCode,         // 邮编
    CCCheckPassword,        // 密码(以字母开头，只能包含字母、数字和下划线，长度在6个以上)
    CCCheckStrongPassword,  // 强密码(必须包含大小写字母和数字的组合，不能使用特殊字符，长度在6个以上)
};

/// 内容校验结果
typedef NS_ENUM(NSInteger, CCCheckState){
    CCTextStateEmpty,       /// 输入内容为空
    CCTextStateNormal,      /// 输入合法
    CCTextStateNotInLimit,  /// 输入不在字数限制范围内
    CCTextStateNotRegular,  /// 正则校验不合法
};

@class CCTextField;
@protocol CCTextFieldDelegate <UITextFieldDelegate>
@optional
/// 将要开始编辑
- (BOOL)textFieldShouldBeginEditing:(CCTextField *_Nonnull)textField;
/// 已经开始编辑
- (void)textFieldDidBeginEditing:(CCTextField *_Nonnull)textField;
/// 将要结束编辑
- (BOOL)textFieldShouldEndEditing:(CCTextField *_Nonnull)textField;
/// 结束编辑(iOS10以下)
- (void)textFieldDidEndEditing:(CCTextField *_Nonnull)textField;
/// 结束编辑(iOS10及以上)
- (void)textFieldDidEndEditing:(CCTextField *_Nonnull)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0);
/// 是否允许输入
- (BOOL)textField:(CCTextField *_Nonnull)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *_Nullable)string;
/// 是否清空
- (BOOL)textFieldShouldClear:(CCTextField *_Nonnull)textField;
/// 是否完成输入
- (BOOL)textFieldShouldReturn:(CCTextField *_Nonnull)textField;
@end

@interface CCTextField : UITextField

@property(nonatomic, nullable, weak) id<CCTextFieldDelegate> delegate;

/// 最小字数限制 默认 0
@property(nonatomic, assign)NSInteger minLimit;

/// 最大字数限制 默认 INT_MAX
@property(nonatomic, assign)NSInteger maxLimit;

/// 输入文字的类型
@property(nonatomic, assign)CCCheckType check;

/// 点击空白收键盘 默认 YES
@property(nonatomic, assign)BOOL isTapEnd;

/// 正则验证结果
@property(nonatomic, assign, readonly)CCCheckState checkState;

@end

