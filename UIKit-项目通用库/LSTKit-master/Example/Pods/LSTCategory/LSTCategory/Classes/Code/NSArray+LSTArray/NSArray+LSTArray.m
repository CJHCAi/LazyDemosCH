//
//  NSArray+LSTArray.m
//  DYwttai
//
//  Created by LoSenTrad on 2017/5/5.
//  Copyright © 2017年 dongyu. All rights reserved.
//

#import "NSArray+LSTArray.h"

@implementation NSArray (LSTArray)

- (NSString *)arrayToStringWithSeparator:(NSString *)separator {
    return [self componentsJoinedByString:separator];
}

- (NSArray *)checkResponse {
    if ([self isKindOfClass:[NSString class]]) {
        return [NSArray array];
    }else {
        return self;
    }
}

///冒泡排序
- (NSArray *)change:(NSMutableArray *)array
{
    if (array.count > 1) {
        for (int  i =0; i<[array count]-1; i++) {
            
            for (int j = i+1; j<[array count]; j++) {
                
                if ([array[i] intValue]>[array[j] intValue]) {
                    
                    //交换
                    
                    [array exchangeObjectAtIndex:i withObjectAtIndex:j];
                    
                }
                
            }
            
        }
    }
    NSArray * resultArray = [[NSArray alloc]initWithArray:array];
    
    return resultArray;
}

@end
