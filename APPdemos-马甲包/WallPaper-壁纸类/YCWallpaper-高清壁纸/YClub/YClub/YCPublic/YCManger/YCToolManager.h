//
//  YCToolManager.h
//  YClub
//
//  Created by 岳鹏飞 on 2017/5/9.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCToolManager : NSObject

+ (BOOL)bUpdate;

+ (NSString *)currentVerson;

+ (void)gotoJudge;

+ (BOOL)isOnCheck;

@end
