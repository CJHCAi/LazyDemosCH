//
//  ItemModel.m
//  demo
//
//  Created by zhong on 17/1/16.
//  Copyright © 2017年 Xz Studio. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.imageName = dict[@"imageName"];
        self.itemTitle = dict[@"itemTitle"];
    }
    return self;
}


@end
