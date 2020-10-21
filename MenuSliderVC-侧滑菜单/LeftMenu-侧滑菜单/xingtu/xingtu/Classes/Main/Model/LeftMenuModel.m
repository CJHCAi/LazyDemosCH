//
//  LeftMenuModel.m
//  shoppingcentre
//
//  Created by Wondergirl on 16/6/19.
//  Copyright © 2016年 Wondergirl. All rights reserved.
//

#import "LeftMenuModel.h"

@implementation LeftMenuModel
-(instancetype)initWithDict:(NSDictionary *)dict{
    
    if (self = [super init]) {
        _icon=dict[@"icon"];
        _name=dict[@"name"];
    }
    return self;
    
}

+(instancetype)leftmenuWithDict:(NSDictionary *)dict{
    
    return [[self alloc] initWithDict:dict];
    
}


@end
