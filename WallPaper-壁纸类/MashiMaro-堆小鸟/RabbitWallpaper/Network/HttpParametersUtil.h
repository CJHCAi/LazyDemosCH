//
//  HttpParametersUtil.h
//  Smallhorse_Driver
//
//  Created by MacBook on 16/2/17.
//  Copyright © 2016年 liuhaoyun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpParametersUtil : NSObject

@property (strong, nonatomic) NSMutableDictionary *parameters;

+ (HttpParametersUtil *)parameters;

- (void)appendParameterWithName:(NSString *)name andStringValue:(NSString *)value;
- (void)appendParameterWithName:(NSString *)name andIntValue:(int)value;
- (void)appendParameterWithName:(NSString *)name andLongValue:(long)value;
- (void)appendParameterWithName:(NSString *)name andLongLongValue:(long long)value;

- (void)appendParameterWithName:(NSString *)name andDicValue:(NSDictionary *)value;
- (void)appendParameterWithName:(NSString *)name andDataValue:(NSData *)value;

@end
