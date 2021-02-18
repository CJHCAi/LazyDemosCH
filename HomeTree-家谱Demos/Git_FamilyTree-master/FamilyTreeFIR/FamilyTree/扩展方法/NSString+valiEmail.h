//
//  NSString+valiEmail.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/29.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (valiEmail)
+ (BOOL) validateEmail:(NSString *)email;
@end
