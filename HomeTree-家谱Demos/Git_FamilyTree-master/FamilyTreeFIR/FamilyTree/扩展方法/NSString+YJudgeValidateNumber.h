//
//  NSString+YJudgeValidateNumber.h
//  FamilyTree
//
//  Created by 姚珉 on 16/8/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YJudgeValidateNumber)
//判断只能输入数字
+ (BOOL)validateNumber:(NSString*)number;
@end
