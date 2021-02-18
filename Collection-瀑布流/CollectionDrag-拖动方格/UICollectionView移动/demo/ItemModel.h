//
//  ItemModel.h
//  demo
//
//  Created by zhong on 17/1/16.
//  Copyright © 2017年 Xz Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Status) {
    StatusMinusSign = 1, // 减号
    StatusPlusSign, // 加号
    StatusCheck, // 对勾
};

@interface ItemModel : NSObject
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *itemTitle;
@property (nonatomic, assign) Status status;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
