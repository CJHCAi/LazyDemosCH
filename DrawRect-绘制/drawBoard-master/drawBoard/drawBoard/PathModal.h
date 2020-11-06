//
//  PathModal.h
//  drawBoard
//
//  Created by hyrMac on 15/8/7.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PathModal : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) CGPathRef path;

@end
