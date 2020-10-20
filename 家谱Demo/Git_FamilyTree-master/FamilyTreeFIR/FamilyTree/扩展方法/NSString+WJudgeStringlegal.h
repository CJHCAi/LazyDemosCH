//
//  NSString+WJudgeStringlegal.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WJudgeStringlegal)
/** 判断输入的字辈格式是否合法 */
+(BOOL)judgeWithString:(NSString *)string;
@end
