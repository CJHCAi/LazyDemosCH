//
//  DFCommonRegisterController.h
//  coder
//
//  Created by Allen Zhong on 15/5/7.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseTableViewController.h"

@interface DFCommonRegisterController : DFBaseTableViewController

-(UIColor *) mainColor;

-(void) onSendVerifyCode;

-(void) onNextStep;


-(NSString *) getPhoneNum;
-(NSString *) getCode;
-(NSString *) getPassword;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com