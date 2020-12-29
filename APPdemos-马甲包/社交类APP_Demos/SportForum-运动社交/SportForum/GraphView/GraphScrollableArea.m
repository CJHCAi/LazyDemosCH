//
//  GraphScrollableArea.m
//  InflowGraph
//
//  Created by Anton Domashnev on 20.02.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "GraphScrollableArea.h"
#import "GraphLine.h"
#import "NSDate+Graph.h"
#import "UIColor+Graph.h"
#import "UIFont+Graph.h"

#define VISIBLE_FRAME CGRectMake(0, 0, 410, 200)
#define GRAPH_SCROLLABLE_VIEW_FRAME_WIDTH_DELTA 28

#define Y_OFFSET_FOR_GRAPH_POINTS 34

#define GRAPH_POINT_SIZE CGSizeMake(18, 18)

#define MAXIMUM_ZOOM_SCALE_FOR_DRAWNING_OBJECT_POINT 20

#define INTERVAL_BETWEEN_DRAWNING_DATE_POINT 41

#define MAXIMUM_FRAME_WIDTH 3000

#define X_AXIS_DATE_POINT_RADIUS 2
#define X_AXIS_DATE_POINT_BORDER_OVAL_RADIUS 3

#define DAY_STRING_FRAME CGRectMake(0, 148, 14, 14)
#define MONTH_STRING_FRAME CGRectMake(0, 161, 15, 12)
#define DAY_STRING_HORIZINTAL_LINE_Y_COORDINATE 162

@interface GraphScrollableArea()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *objectsArray;

@property (nonatomic, strong) GraphLine *objectsLine;

@property (nonatomic, unsafe_unretained) NSInteger startUNIXDate;
@property (nonatomic, unsafe_unretained) NSInteger endUNIXDate;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) UIColor *colorPaint;
@property (nonatomic, strong) NSString *strMonth;

@property (nonatomic, unsafe_unretained) NSInteger numberOfDays;
@property (nonatomic, unsafe_unretained) NSInteger newZoomRate;
@property (nonatomic, unsafe_unretained) float dayIntervalWidth;
@property (nonatomic, unsafe_unretained) float maximumZoomRate;
@property (nonatomic, unsafe_unretained) float minimumZoomRate;
@property (nonatomic, unsafe_unretained) NSInteger zoomRate;
@property (nonatomic, weak) id<GraphScrollableViewDelegate> delegate;


@end

@implementation GraphScrollableArea

@synthesize zoomRate;
@synthesize fSteps;
@synthesize fMinY;
@synthesize fMaxY;
@synthesize newZoomRate;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.objectsLine = nil;
    }
    return self;
}

- (id)initWithGraphDataObjectsArray:(CGRect)frame data:(NSArray *)objectsArray delegate:(id<GraphScrollableViewDelegate>)theDelegate{
    
    if(self = [super initWithFrame: frame]){
        
        self.backgroundColor = [UIColor clearColor];
        self.delegate = theDelegate;
        self.objectsArray = objectsArray;
        
        GraphDataObject *objectStart = [self.objectsArray objectAtIndex:0];
        self.startDate = objectStart.time;
        
        GraphDataObject *objectEnd = [self.objectsArray objectAtIndex:[self.objectsArray count] - 1];
        self.endDate = objectEnd.time;
        
        self.startUNIXDate = [self.startDate timeIntervalSince1970];
        self.endUNIXDate = [self.endDate timeIntervalSince1970];
        self.numberOfDays = self.objectsArray.count - 1; //[NSDate daysBetweenDateOne:self.startDate dateTwo:self.endDate];
        self.maximumZoomRate = self.numberOfDays;
        self.minimumZoomRate = self.numberOfDays;
        self->zoomRate = MIN(self.numberOfDays + 1, frame.size.width / 60 );
        
        self.userInteractionEnabled = YES;
        
        UIPinchGestureRecognizer *pinchRecogniser = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(userDidUsePinchGesture:)];
        
        [self addGestureRecognizer:pinchRecogniser];
    }
    
    return self;

}

- (void)dealloc{
    
    //self.delegate = nil;
}

#pragma mark Check Zoom Rate

- (BOOL)isZoomRateValid:(NSInteger)zoom{
    
    return (zoom >= self.minimumZoomRate && zoom <= self.maximumZoomRate);
}

- (void)correctNewZoomScale{
    
    if(self.newZoomRate > self.maximumZoomRate){
        
        self.newZoomRate = self.maximumZoomRate;
    }
    else if(self.newZoomRate < self.minimumZoomRate){
        
        self.newZoomRate = self.minimumZoomRate;
    }
}

#pragma mark PinchGesture

- (void)userDidUsePinchGesture:(UIPinchGestureRecognizer *)recogniser{
    
    self.newZoomRate = self.zoomRate / [recogniser scale];
    
    [self correctNewZoomScale];
    
    if([self.delegate respondsToSelector:@selector(graphScrollableView:didChangeZoomRate:)]){
        
        [self.delegate graphScrollableView:self didChangeZoomRate:self.newZoomRate];
    }
    
    switch (recogniser.state) {
        case UIGestureRecognizerStateEnded:{
            
            if([self.delegate respondsToSelector:@selector(graphScrollableViewDidEndUpdateZoomRate:)]){
                
                [self.delegate graphScrollableViewDidEndUpdateZoomRate: self];
            }
            
            if(self.zoomRate != self.newZoomRate){
                
                self.zoomRate = self.newZoomRate;
                
                [self reload];
            }
            break;
        }
        case UIGestureRecognizerStateBegan:{
            
            if([self.delegate respondsToSelector:@selector(graphScrollableViewDidStartUpdateZoomRate:)]){
                
                [self.delegate graphScrollableViewDidStartUpdateZoomRate: self];
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark Recalculate Dates

- (void)recalculateStartDate{
    
    self.startUNIXDate = self.endUNIXDate - [self numberOfDaysInWidth: self.frame.size.width] * NUMBER_OF_SECONDS_IN_DAY;
    self.startDate = [NSDate dateWithTimeIntervalSince1970: self.startUNIXDate];
}

#pragma mark Zoom Rate

- (void)setZoomRate:(NSInteger)_zoomRate{
    
    if([self isZoomRateValid: _zoomRate]){
        
        self->zoomRate = _zoomRate;
    }
}

- (void)setFSteps:(CGFloat)_fSteps{
    self->fSteps = _fSteps;
}

- (void)setFMinY:(CGFloat)_fMinY{
    self->fMinY = _fMinY;
    if(self.objectsLine)
    {
        self.objectsLine.fMinY = fMinY;
    }
}

- (void)setFMaxY:(CGFloat)_fMaxY{
    self->fMaxY = _fMaxY;
    if(self.objectsLine)
    {
        self.objectsLine.fMaxY = fMaxY;
    }
}

#pragma mark Reload

- (void)reload{
    
    if([self.delegate respondsToSelector:@selector(graphScrollableViewDidStartRedraw:)]){
        
        [self.delegate graphScrollableViewDidStartRedraw: self];
    }
    
    CGRect newFrame = [self frameForCurrentZoomRate];
    
    [self.delegate graphScrollableView:self willUpdateFrame:newFrame];
    
    self.frame = newFrame;
    
    //[self recalculateStartDate];
    
    [self removeOldSubviews];
    
    [self setNeedsDisplay];
    
    [self reloadWithStartDay:0 completionCallback:^{
       
        if([self.delegate respondsToSelector:@selector(graphScrollableViewDidEndRedraw:)]){
            
            [self.delegate graphScrollableViewDidEndRedraw: self];
        }
    }];
}

- (void)reloadOnlyPointLine:(NSArray *)objectsArray {
    [self.objectsLine removeFromSuperview];
    self.objectsLine = nil;
    self.objectsArray = objectsArray;
    
    [self reloadWithStartDay:0 completionCallback:^{
        
        if([self.delegate respondsToSelector:@selector(graphScrollableViewDidEndRedraw:)]){
            
            [self.delegate graphScrollableViewDidEndRedraw: self];
        }
    }];
}

#pragma mark Remove Old Subviews

- (void)removeOldSubviews{
    
    [self.objectsLine removeFromSuperview];
    self.objectsLine = nil;
    
    for(UIView *view in self.subviews){
        
        if([view isKindOfClass:[GraphPoint class]]){
            
            [view removeFromSuperview];
        }
    }
}

#pragma mark Value to point convertion

- (CGPoint)pointForValue:(NSNumber *)value atDayNumber:(float)dayNumber{
    
    float x = self.dayIntervalWidth * dayNumber;
    float y = self.frame.size.height - Y_OFFSET_FOR_GRAPH_POINTS - [value floatValue] * self->fSteps;
    
    return CGPointMake(x, y);
}

- (CGFloat)xCoordinateForDayNumber:(float)dayNumber{
    
    return self.dayIntervalWidth * dayNumber;
}

#pragma mark Lines

- (void)drawLineWithPointsArray:(NSArray *)pointsArray{
    
    self.objectsLine = [[GraphLine alloc] initWithFrame:self.bounds pointsArray:pointsArray];
    self.objectsLine.fMinY = fMinY;
    self.objectsLine.fMaxY = fMaxY;
    [self addSubview: self.objectsLine];
}

#pragma mark Reload

- (void)reloadWithStartDay:(NSInteger)startDay completionCallback:(void(^)(void))callback{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    
        NSMutableArray *objectsLinePoints = [NSMutableArray array];

        for (int i = 0; i < [self.objectsArray count]; i++) {
            GraphDataObject *object = [self.objectsArray objectAtIndex:i];
            
            if (i == 0) {
                [objectsLinePoints insertObject:[NSValue valueWithCGPoint: [self pointForValue:[NSNumber numberWithInt:0] atDayNumber:0]] atIndex:[objectsLinePoints count]];
            }
            
            [objectsLinePoints addObject: [NSValue valueWithCGPoint: [self pointForValue:object.value atDayNumber:i]]];
            
            if (i == [self.objectsArray count] - 1) {
                CGPoint lastPoint = CGPointMake(self.dayIntervalWidth * i - 1, self.frame.size.height - Y_OFFSET_FOR_GRAPH_POINTS);
                [objectsLinePoints insertObject:[NSValue valueWithCGPoint: lastPoint] atIndex:[objectsLinePoints count]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([objectsLinePoints count] > 0){
                [self drawLineWithPointsArray:objectsLinePoints];
            }

            callback();
        });
    });
}

#pragma mark Size

- (CGRect)frameForCurrentZoomRate{
    
    CGSize newSize = [self newSizeForCurrentZoomRate];
    CGRect frame = self.frame;
    
    frame.size.width = (newSize.width <= frame.size.width) ? frame.size.width : newSize.width;
    
    return frame;
}

- (CGSize)newSizeForCurrentZoomRate{
    if (self.zoomRate > 1) {
        self.dayIntervalWidth = (self.frame.size.width) / ((float)self.zoomRate - 1);
    }
    else
    {
        self.dayIntervalWidth = self.frame.size.width;
    }
    
    float newGraphWidth = self.dayIntervalWidth * self.numberOfDays;
    
    return CGSizeMake(newGraphWidth, self.frame.size.height);
}

#pragma mark Number of days in width

- (NSInteger)numberOfDaysInWidth:(CGFloat)width{
    
    int numberOfDays = (int)(width / self.dayIntervalWidth + 0.5);
    
    return numberOfDays;
}

#pragma mark Draw

- (void)drawDateForDayNumber:(NSInteger)dayNumber{

    NSDate *localDateForDayNumber = [[self.startDate dateWithDaysAhead: dayNumber] localDate];
    NSString *month = [localDateForDayNumber monthShortStringDescription];
    
    if (dayNumber == 0) {
        
        self.strMonth = month;
        self.strFirMonth = month;
        self.colorFriPaint = [UIColor colorWithRed:100.0/255.0 green:210.0/255.0 blue:1.0 alpha:1.0];
        self.colorPaint = [UIColor colorWithRed:100.0/255.0 green:210.0/255.0 blue:1.0 alpha:1.0];
    }
    else if(![month isEqualToString:self.strMonth])
    {
        self.colorPaint = [UIColor colorWithRed:0./255. green:127.0/255. blue:234./255 alpha:1.0f];
        self.colorSecPaint = self.colorPaint;
    }
    
    [self.colorPaint set];
    NSInteger day = [localDateForDayNumber dayNumber];
    //NSString *dayString = [NSString stringWithFormat: @"%@%d", (day < 10) ? @"0" : @"", day];
    NSString *dayString = [NSString stringWithFormat: @"%d", day];
    
    //Day number
    float x = [self xCoordinateForDayNumber: dayNumber];
    CGRect dayStringFrame = CGRectMake(0, self.frame.size.height - Y_OFFSET_FOR_GRAPH_POINTS + 2, 25, 14);
    NSTextAlignment textModeDay = NSTextAlignmentCenter;
    
    if (dayNumber == 0) {
        dayStringFrame.origin.x = x;
        textModeDay = NSTextAlignmentLeft;
    }
    else
    {
        if(dayNumber == [self numberOfDaysInWidth: self.frame.size.width])
        {
            textModeDay = NSTextAlignmentLeft;
        }
        
        dayStringFrame.origin.x = x - dayStringFrame.size.width / 2;
    }
        
    [dayString drawInRect:dayStringFrame withFont:[UIFont defaultGraphBoldFontWithSize: 11.]lineBreakMode:NSLineBreakByTruncatingTail alignment:textModeDay];
    
    //[[UIColor graphDarkPurpleColor] set];
    
    //Divider
    /*UIBezierPath *horizontalLine = [[UIBezierPath alloc] init];
    
    [horizontalLine setLineCapStyle:kCGLineCapSquare];
    [horizontalLine setLineWidth: 1.f];
    
    [horizontalLine moveToPoint: CGPointMake(dayStringFrame.origin.x, dayStringFrame.origin.y + 14)];
    [horizontalLine addLineToPoint: CGPointMake(dayStringFrame.origin.x + dayStringFrame.size.width, dayStringFrame.origin.y + 14)];
    
    [horizontalLine stroke];
    
    [[UIColor graphLightPurpleColor] set];*/
    
    //Month
    if (![month isEqualToString:self.strMonth])
    {
        self.strSecMonth = month;
        self.strMonth = month;
        CGRect monthStringFrame = CGRectMake(0, dayStringFrame.origin.y + 12, 30, 20);
        
        if(dayNumber == [self numberOfDaysInWidth: self.frame.size.width])
        {
            monthStringFrame.origin.x = x - monthStringFrame.size.width;
        }
        else
        {
            monthStringFrame.origin.x = x - monthStringFrame.size.width / 2;
        }

        [month drawInRect:monthStringFrame withFont:[UIFont defaultGraphBoldFontWithSize: 11.]lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        
        if (dayNumber != 0) {
            self.xMonthEnd = [self xCoordinateForDayNumber: dayNumber - 1];
            self.xNewMonthBegin = x + monthStringFrame.size.width / 2.0 - 2;
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    //Vertical dash
    NSInteger numberOfVisibleDays = [self numberOfDaysInWidth: self.frame.size.width];
    
    if (self.numberOfDays == 0) {
        numberOfVisibleDays = 0;
    }
    
    //for(int day = 0; day <= numberOfVisibleDays; day++){
        /*[[UIColor graphBrownColor] set];
        CGPoint startPoint = CGPointMake(self.dayIntervalWidth * day + GRAPH_SCROLLABLE_VIEW_FRAME_WIDTH_DELTA / 2, self.frame.size.height - Y_OFFSET_FOR_GRAPH_POINTS);
        UIBezierPath *datePoint = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(startPoint.x - X_AXIS_DATE_POINT_RADIUS, startPoint.y - X_AXIS_DATE_POINT_RADIUS, X_AXIS_DATE_POINT_RADIUS * 2, X_AXIS_DATE_POINT_RADIUS * 2)];
        [datePoint fill];
        
        [[UIColor graphLightPurpleColor] set];
        UIBezierPath *dateBorder = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(startPoint.x - X_AXIS_DATE_POINT_BORDER_OVAL_RADIUS, startPoint.y - X_AXIS_DATE_POINT_BORDER_OVAL_RADIUS, X_AXIS_DATE_POINT_BORDER_OVAL_RADIUS * 2, X_AXIS_DATE_POINT_BORDER_OVAL_RADIUS * 2)];
        [dateBorder stroke];*/

        //Draw dates
    //    [self drawDateForDayNumber: day];
   // }
    
    for (int i = 0; i < [self.objectsArray count]; i++) {
        GraphDataObject *object = [self.objectsArray objectAtIndex:i];
        NSDate *dateTime = object.time;
        NSString *month = [dateTime monthShortStringDescription];
        
        if (i == 0) {
            
            self.strMonth = month;
            self.strFirMonth = month;
            self.colorFriPaint = [UIColor colorWithRed:100.0/255.0 green:210.0/255.0 blue:1.0 alpha:1.0];
            self.colorPaint = [UIColor colorWithRed:100.0/255.0 green:210.0/255.0 blue:1.0 alpha:1.0];
        }
        else if(![month isEqualToString:self.strMonth])
        {
            self.colorPaint = [UIColor colorWithRed:0./255. green:127.0/255. blue:234./255 alpha:1.0f];
            self.colorSecPaint = self.colorPaint;
        }

        [self.colorPaint set];

        NSInteger unitflag = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents* comp = [myCal components:unitflag fromDate:dateTime];
        NSString *timeString = [NSString stringWithFormat: @"%02ld/%02ld\n%02ld:%02ld", comp.month, comp.day, comp.hour, comp.minute];
        
        NSTimeInterval secondsPerDay = 24 * 60 * 60;
        NSDate *today = [[NSDate alloc] init];
        NSDate *yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
        
        NSDateComponents* compToday = [myCal components:unitflag fromDate:today];
        NSDateComponents* compYesterday = [myCal components:unitflag fromDate:yesterday];
        
        if (comp.month == compToday.month && comp.day == compToday.day)
        {
            timeString = [NSString stringWithFormat: @"今天\n%02ld:%02ld", comp.hour, comp.minute];
        } else if (comp.month == compYesterday.month && comp.day == compYesterday.day)
        {
            timeString = [NSString stringWithFormat: @"昨天\n%02ld:%02ld", comp.hour, comp.minute];
        }
        
        //NSString *dayString = [NSString stringWithFormat: @"%@%d", (day < 10) ? @"0" : @"", day];
        
        
        //Day number
        float x = [self xCoordinateForDayNumber: i];
        CGRect dayStringFrame = CGRectMake(0, self.frame.size.height - Y_OFFSET_FOR_GRAPH_POINTS + 2, 40, 30);
        NSTextAlignment textModeDay = NSTextAlignmentCenter;
        
        if (i == 0) {
            dayStringFrame.origin.x = x;
            textModeDay = NSTextAlignmentLeft;
        }
        else
        {
            if(i == [self numberOfDaysInWidth: self.frame.size.width])
            {
                textModeDay = NSTextAlignmentRight;
                dayStringFrame.origin.x = x - 40;
            }
            else
            {
                dayStringFrame.origin.x = x - 20;
            }
        }
        
        [timeString drawInRect:dayStringFrame withFont:[UIFont defaultGraphBoldFontWithSize: 11.]lineBreakMode:NSLineBreakByTruncatingTail alignment:textModeDay];
        
        //Month
        if (![month isEqualToString:self.strMonth])
        {
            self.strSecMonth = month;
            self.strMonth = month;
            CGRect monthStringFrame = CGRectMake(0, dayStringFrame.origin.y + 12, 30, 20);
            
            if(i == [self numberOfDaysInWidth: self.frame.size.width])
            {
                monthStringFrame.origin.x = x - monthStringFrame.size.width;
            }
            else
            {
                monthStringFrame.origin.x = x - monthStringFrame.size.width / 2;
            }
        }
    }
}

@end
