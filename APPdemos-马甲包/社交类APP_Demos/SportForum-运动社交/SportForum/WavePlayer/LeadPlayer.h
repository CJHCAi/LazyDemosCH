//
//  HeartBeatDrawing.h
//  ECG
//
//  Created by Will Yang (yangyu.will@gmail.com) on 5/7/11.
//  Copyright 2013 WMS Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LiveMonitorVC;

@interface LeadPlayer : UIView <UIGestureRecognizerDelegate> {
	CGPoint drawingPoints[1000];
	CGPoint endPoint, endPoint2, endPoint3, viewCenter;
	int currentPoint;
	CGContextRef context;
	
	LiveMonitorVC *__unsafe_unretained liveMonitor;
	
	NSMutableArray *pointsArray;
	int index;
	NSString *label;
	
	int count;
	UIView *lightSpot;
	int pos_x_offset;
}

@property (nonatomic, strong) NSMutableArray *pointsArray;
@property (nonatomic, strong) UIView *lightSpot;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, unsafe_unretained) LiveMonitorVC *liveMonitor;

@property (nonatomic) int index;
@property (nonatomic) int currentPoint;
@property (nonatomic) int pos_x_offset;
@property (nonatomic) CGPoint viewCenter;


- (void)fireDrawing;
- (void)drawGrid:(CGContextRef)ctx;
- (void)drawCurve:(CGContextRef)ctx;
- (void)drawLabel:(CGContextRef)ctx;
- (void)clearDrawing;
- (void)redraw;
- (CGFloat)getPosX:(int)tick;
- (BOOL)pointAvailable:(NSInteger)pointIndex;
- (void)resetBuffer;
- (void)addGestureRecgonizer;

@end
