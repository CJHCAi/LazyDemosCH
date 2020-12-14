//
//  Helper.h
//
//  Created by 郭军 on 2017/3/16.
//  Copyright © 2017年 ZJNY. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^AlertTouchOkBlock)();
typedef void(^AlertTouchNoBlock)();

@interface Helper : NSObject

//---------转换返回数据中的空字符 null

//+(NSDictionary *)JSONObjectWithData:(NSString *)JsString;

//---------设置label

+(UILabel *)commonLableWithFrame:(CGRect)Size
                            text:(NSString *)text
                           front:(UIFont *)front
                   textAlignment:(NSTextAlignment)textAlignment;

//---------图片
+(UIImageView *)commonImageWithFram:(CGRect)Size
                          Image:(UIImage *)Image;


//---------alertview
+(UIAlertView *)alertWith:(NSString *)title message:(NSString *)message;

+(UIImageView *)setBgimageView;


/**
 自定义alert

 @param title 标题
 @param prompt 提示
 @param cancenl 取消按钮
 @param defaultLb 确定按钮
 @param viewcontroller 当前控制器
 @param touchOkBlock 点击确定
 @param touchNoBlock 点击取消
 */
+(void)ShowAlertWithTitle:(NSString *)title
                   prompt:(NSString *)prompt
                   cancel:(NSString *)cancenl
                  defaultLb:(NSString *)defaultLb
           ViewController:(UIViewController *)viewcontroller
             alertOkClick:(AlertTouchOkBlock)touchOkBlock
             alertNoClick:(AlertTouchNoBlock)touchNoBlock;

@end
