//
//  SXTLocationManager.h
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/6.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LocationBlock)(NSString * lat, NSString * lon);

@interface SXTLocationManager : NSObject

+ (instancetype)sharedManager;

- (void)getGps:(LocationBlock)block;

@property (nonatomic, copy) NSString * lat;
@property (nonatomic, copy) NSString * lon;


@end
