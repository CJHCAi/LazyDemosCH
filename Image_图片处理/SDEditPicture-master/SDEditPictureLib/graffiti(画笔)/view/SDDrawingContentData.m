//
//  SDDrawingContentData.m
//  NestHouse
//
//  Created by shansander on 2017/5/6.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import "SDDrawingContentData.h"

@implementation SDDrawingContentData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pointlist = [[NSMutableArray alloc] init];
        self.drawColor = [UIColor blackColor];
        self.path = [UIBezierPath bezierPath];
        self.drawSize = 4;
        
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    SDDrawingContentData * draw = [[self class] allocWithZone:zone];
    draw.drawColor = self.drawColor;
    draw.pointlist = [self.pointlist mutableCopy];
    draw.drawSize = self.drawSize;
    draw.path = self.path;
    return draw;
}

- (void)addPoint:(CGPoint)point
{
    if (self.pointlist.count == 0) {
        [self.path moveToPoint:point];
        NSLog(@"move to point : %@",NSStringFromCGPoint(point));
    }else{
        [self.path addLineToPoint:point];
        NSLog(@"add line to point : %@",NSStringFromCGPoint(point));
    }
    
    NSValue * point_value = [NSValue valueWithCGPoint:point];
    
    [self.pointlist addObject:point_value];
}


@end
