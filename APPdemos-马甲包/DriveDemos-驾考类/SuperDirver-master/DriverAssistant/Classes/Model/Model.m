//
//  Model.m
//  ShowMoreText
//
//  Created by yaoshuai on 2017/1/20.
//  Copyright © 2017年 ys. All rights reserved.
//

#import "Model.h"

@implementation Model

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.title = [dict objectForKey:@"title"];
        self.content = [dict objectForKey:@"content"];
        self.isShowMoreText = NO;
    }
    return self;
}

@end
