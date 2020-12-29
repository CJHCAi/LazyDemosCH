//
//  GraphDataObject.m
//  SCGraphView
//
//  Created by Anton Domashnev on 25.02.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "GraphDataObject.h"
#import "GraphConstants.h"

@implementation GraphDataObject

#pragma mark Helpers

+ (NSInteger)randomBetweenFirst:(int)first andSecond:(int)second{
    
    return arc4random_uniform(second - first) + first;
}

+ (NSArray *)randomGraphDataObjectsArray:(NSInteger)count startDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for(int i = 0; i < count; i++){
        
        GraphDataObject *object = [[GraphDataObject alloc] init];
        object.time = [startDate dateByAddingTimeInterval:(60*60*24*i)];
        object.value = [NSNumber numberWithInt: arc4random() % 100];
        
        [array addObject: object];
    }
    
    return array;
}

@end
