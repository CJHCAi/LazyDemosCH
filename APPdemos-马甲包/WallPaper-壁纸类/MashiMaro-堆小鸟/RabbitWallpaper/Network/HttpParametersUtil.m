//
//  HttpParametersUtil.m
//  Smallhorse_Driver
//
//  Created by MacBook on 16/2/17.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import "HttpParametersUtil.h"

@implementation HttpParametersUtil

- (id)init
{
    if (self = [super init]) {
        _parameters = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    return self;
}

+ (HttpParametersUtil *)parameters
{
    return [[HttpParametersUtil alloc] init];
}

- (void)appendParameterWithName:(NSString *)name andStringValue:(NSString *)value
{
    [self.parameters setObject:value forKey:name];
}


- (void)appendParameterWithName:(NSString *)name andIntValue:(int)value
{
    [self appendParameterWithName:name andStringValue:[NSString stringWithFormat:@"%d",value]];
}

- (void)appendParameterWithName:(NSString *)name andLongValue:(long)value
{
    [self appendParameterWithName:name andStringValue:[NSString stringWithFormat:@"%ld",value]];
}

- (void)appendParameterWithName:(NSString *)name andLongLongValue:(long long)value
{
    [self appendParameterWithName:name andStringValue:[NSString stringWithFormat:@"%lld",value]];
}
- (void)appendParameterWithName:(NSString *)name andDicValue:(NSDictionary *)value{
    [self.parameters setObject:value forKey:name];
}
- (void)appendParameterWithName:(NSString *)name andDataValue:(NSData *)value{
    [self.parameters setObject:value forKey:name];
    
}


@end
