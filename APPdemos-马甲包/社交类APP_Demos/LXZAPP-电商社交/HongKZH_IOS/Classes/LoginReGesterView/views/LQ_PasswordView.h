//
//  LQ_PasswordView.h
//  验证码输入框
//
//  Created by chongzu20 on 2018/8/3.
//  Copyright © 2018年 chongzu20. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CallBackBlcok) (NSString *text);

@interface LQ_PasswordView : UIView<UITextFieldDelegate>
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, assign)int num;//验证码位数
@property (nonatomic, strong)UIColor *lineViewColor;//横线颜色；
@property (nonatomic, strong)UIColor *selectlineViewColor;//横线颜色(已填颜色)；
@property (nonatomic, strong)UIColor *errorlineViewColor;//验证错误横线颜色；
@property (nonatomic, strong)UIColor *lineColor;//光标颜色；
@property (nonatomic, strong)UIFont *labelFont;//数字文本大小
@property (nonatomic, strong)UIColor *textLabelColor;//数字颜色；

@property (nonatomic,copy)CallBackBlcok callBackBlock;

- (void)showPassword;//显示

//此处参数传字符串:error
-(void)cleanPassword:(NSString *)error;//输入错误或者全部清除;
@end
