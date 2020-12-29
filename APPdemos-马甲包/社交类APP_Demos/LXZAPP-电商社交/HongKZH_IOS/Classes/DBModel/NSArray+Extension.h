//
//  NSArray+Extension.h
//  HandsUp
//
//  Created by wanghui on 2018/4/19.
//  Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Extension)
+ (instancetype)getProperties:(Class)cls;
+ (instancetype)getPropertiesAndSuper:(Class)cls;
@end
