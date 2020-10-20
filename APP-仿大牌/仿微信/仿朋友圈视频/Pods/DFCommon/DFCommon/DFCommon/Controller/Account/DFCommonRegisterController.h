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
