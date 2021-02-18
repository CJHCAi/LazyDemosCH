//
//  NSString+addLineBreakOrSpace.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (addLineBreakOrSpace)
+(NSMutableString *)addLineBreaks:(NSString *)str;
+(NSMutableString *)addSpace:(NSString *)str withNumber:(NSInteger)num;
@end
