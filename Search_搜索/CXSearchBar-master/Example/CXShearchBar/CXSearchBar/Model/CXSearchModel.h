//
//  CXSearchModel.h
//  CXShearchBar_Example
//
//  Created by caixiang on 2019/4/29.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CXSearchProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface CXSearchModel : NSObject <CXSearchProtocol>

- (instancetype)initWithName:(NSString *)name searchId:(NSString *)searchId;

@end

NS_ASSUME_NONNULL_END
