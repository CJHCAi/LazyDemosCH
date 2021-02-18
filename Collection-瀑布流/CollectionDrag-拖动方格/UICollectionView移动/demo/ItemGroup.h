//
//  ItemGroup.h
//  demo
//
//  Created by zhong on 17/1/16.
//  Copyright © 2017年 Xz Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemModel.h"

@interface ItemGroup : NSObject
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSMutableArray<ItemModel *> *items;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
