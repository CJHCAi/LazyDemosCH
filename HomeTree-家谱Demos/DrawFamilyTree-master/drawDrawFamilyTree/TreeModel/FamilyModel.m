//
//  FamilyModel.m
//  drawDrawFamilyTree
//
//  Created by Nicole on 2018/3/16.
//  Copyright © 2018年 Nicole. All rights reserved.
//

#import "FamilyModel.h"

@implementation FamilyModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"mates" : FamilyModel.class,
             @"children" : FamilyModel.class};
}

@end
