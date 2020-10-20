//
//  DFToolUtil.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/10/3.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFToolUtil : NSObject

+(NSString *) md5:(NSString *) str;

+(NSString *) preettyTime:(long long) ts;


@end
