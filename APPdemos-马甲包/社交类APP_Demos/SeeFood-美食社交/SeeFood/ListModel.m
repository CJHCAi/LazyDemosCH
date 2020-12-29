//
//  ListModel.m
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"listId"];
    }
}

@end
