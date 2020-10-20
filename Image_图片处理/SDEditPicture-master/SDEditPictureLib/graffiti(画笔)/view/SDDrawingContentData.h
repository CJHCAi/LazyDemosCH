//
//  SDDrawingContentData.h
//  NestHouse
//
//  Created by shansander on 2017/5/6.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDDrawingContentData : NSObject<NSCopying>

@property (nonatomic, strong) UIColor * drawColor;

@property (nonatomic, assign) CGFloat drawSize;

@property (nonatomic, strong) NSMutableArray * pointlist;

@property (nonatomic, strong) UIBezierPath * path;

@property (nonatomic, assign) CGBlendMode blendModel;

- (void)addPoint:(CGPoint)point;

@end
