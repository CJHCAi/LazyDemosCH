//
//  BoardsModel.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "BoardsModel.h"

@implementation BoardsModel
+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc]initWithModelToJSONDictionary:@{@"boardsIdentifier":@"id"}];
}
@end
