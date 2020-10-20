//
//  RegisterViewController.h
//  QQ空间登录
//
//  Created by 妖精的尾巴 on 15-8-19.
//  Copyright (c) 2015年 妖精的尾巴. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void (^myBlock)(NSString*);
@interface RegisterViewController : UIViewController

/**
 *保存用户注册的QQ号和QQ密码
 */
@property(nonatomic,strong)NSString* userInfoKey;

@property(nonatomic,copy)myBlock block;

@end
