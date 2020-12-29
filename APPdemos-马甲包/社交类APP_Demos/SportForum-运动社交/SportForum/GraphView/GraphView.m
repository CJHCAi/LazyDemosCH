//
//  GraphView.m
//  InflowGraph
//
//  Created by Anton Domashnev on 18.02.13.
//  Copyright (c) 2013 Anton Domashnev. All rights reserved.
//

#import "GraphView.h"
#import "GraphLine.h"
#import "GraphPoint.h"
#import "NSDate+Graph.h"
#import "UIFont+Graph.h"
#import "UIColor+Graph.h"
#import <QuartzCore/QuartzCore.h>

#define X_OFFSET 25.0f
#define Y_OFFSET 34.0f

//#define DEFAULT_GRAPH_VIEW_FRAME CGRectMake(8, 16, 466, 206)
//#define GRAPH_FRAME CGRectMake(X_OFFSET,0,246,206)

//#define VISIBLE_GRAPH_FRAME CGRectMake(0,Y_OFFSET,246,176)

@interface GraphView()<UIScrollViewDelegate, GraphScrollableViewDelegate>

@property (nonatomic, strong) UIScrollView *graphScrollView;

@property (nonatomic, strong) GraphScrollableArea *graphScrollableView;
@property (nonatomic, weak) id<GraphViewDelegate> delegate;

@property (nonatomic, strong) GraphViewLineArea *graphViewLineArea;

@property (nonatomic, unsafe_unretained) BOOL isGraphViewInialized;
@property (nonatomic, assign) CGFloat fMaxYFlow;
@property (nonatomic, assign) CGFloat fMinYFlow;
@property (nonatomic, assign) CGPoint pCurOffset;
@end

@implementation GraphView

@synthesize xUnit = _xUnit;
@synthesize bShowLineUp = _bShowLineUp;
@synthesize graphViewData = _graphViewData;
@synthesize graphScrollView;

- (id)initWithFrame:(CGRect)frame delegate:(id<GraphViewDelegate>)theDelegate
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.delegate = theDelegate;
    }
    
    return self;
}

- (void)reloadData {
    /*if (self.bLoadViewDataOnly) {
        BOOL bIsLoadraphLine = NO;
        
        if ([self getYMaxValue] > self.fMaxYFlow) {
            bIsLoadraphLine = YES;
        }
        
        NSArray *allOfSubviews = [self subviews];
        for (UIView *view in allOfSubviews) {
            
            if (view == self.graphScrollView || (!bIsLoadraphLine && view == self.graphViewLineArea)) {
                continue;
            }

            [view removeFromSuperview];
        }
        
        self.isGraphViewInialized = NO;
        
        [self addGraphScrollableView];
        
        if (bIsLoadraphLine) {
            [self addGraphLineAreaView];
            [self getYStepValues];
        }
        
        [self.graphScrollableView reload];
    }
    else
    {
        NSArray *allOfSubviews = [self subviews];
        for (UIView *view in allOfSubviews) {
            [view removeFromSuperview];
        }
        
        self.isGraphViewInialized = NO;
        [self addGraphScrollView];
        [self addGraphScrollableView];
        [self addGraphLineAreaView];
        
        [self getYStepValues];
        [self.graphScrollableView reload];
    }
    
	[self setNeedsDisplay];*/
    
    NSArray *allOfSubviews = [self subviews];
    for (UIView *view in allOfSubviews) {
        [view removeFromSuperview];
    }
        
    self.isGraphViewInialized = NO;
    [self addGraphScrollView];
    [self addGraphScrollableView];
    [self addGraphLineAreaView];
        
    [self getYStepValues];
    [self.graphScrollableView reload];
        
    [self setNeedsDisplay];
}

#pragma mark GraphScrollableViewDelegate

- (void)graphScrollableView:(GraphScrollableArea *)view willUpdateFrame:(CGRect)newFrame{
    
    self.graphScrollView.contentSize = newFrame.size;
}

- (void)graphScrollableViewDidEndRedraw:(GraphScrollableArea *)view{
    
    if(!self.isGraphViewInialized){
        
        [self scrollToRecentObjects];
        
        self.isGraphViewInialized = YES;
    }
    
    if([self.delegate respondsToSelector:@selector(graphViewDidUpdate:)]){
        
        [self.delegate graphViewDidUpdate: self];
    }
}

- (void)graphScrollableViewDidStartRedraw:(GraphScrollableArea *)view{

    if([self.delegate respondsToSelector:@selector(graphViewWillUpdate:)]){
        
        [self.delegate graphViewWillUpdate: self];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    self.pCurOffset = [scrollView contentOffset];
    [self updateMonthLable:self.pCurOffset.x];
}

#pragma mark Graph ScrollView

- (void)addGraphScrollView{
    
    self.graphScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(X_OFFSET,0,self.frame.size.width - 1.25 * X_OFFSET,self.frame.size.height)];
    
    self.graphScrollView.delegate = self;
    self.graphScrollView.backgroundColor = [UIColor clearColor];
    [self.graphScrollView setCanCancelContentTouches: YES];
    [self.graphScrollView setUserInteractionEnabled: YES];
    
    [self addSubview: self.graphScrollView];
}

#pragma mark GraphScrollableView

- (void)scrollToRecentObjects{
    if (self.bToRecent) {
        
        if (self.graphScrollView.contentSize.width > self.graphScrollView.frame.size.width) {
            CGPoint graphPoint = self.graphScrollView.contentOffset;
            graphPoint.x = self.graphScrollView.contentSize.width - self.graphScrollView.frame.size.width;
            self.graphScrollView.contentOffset = graphPoint;
        }
    }

    //[self updateMonthLable:self.graphScrollView.contentOffset.x];
}

- (void)addGraphScrollableView{
    CGRect rect = CGRectMake(0,Y_OFFSET,self.graphScrollView.frame.size.width,self.graphScrollView.frame.size.height - Y_OFFSET);
    
    if (!self.xUnit) {
        rect = CGRectMake(0, Y_OFFSET / 3.0, self.graphScrollView.frame.size.width,self.graphScrollView.frame.size.height - Y_OFFSET / 3.0);
    }
    
    self.graphScrollableView = [[GraphScrollableArea alloc] initWithGraphDataObjectsArray:rect data:self.graphViewData delegate:self];
    self.graphScrollableView.backgroundColor = [UIColor clearColor];
    [self.graphScrollView addSubview: self.graphScrollableView];
}

- (void)addGraphLineAreaView{
    if (self.bShowLineUp) {
        GraphDataObject *objectStart = [self.graphViewData objectAtIndex:0];
        self.graphViewLineArea = [[GraphViewLineArea alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) StartDay:objectStart.time XOffset:X_OFFSET YOffset:Y_OFFSET];
        self.graphViewLineArea.xUnit = self.xUnit;
        self.graphViewLineArea.backgroundColor = [UIColor clearColor];
        self.graphViewLineArea.userInteractionEnabled = NO;
        
        [self addSubview: self.graphViewLineArea];
    }
}

#pragma mark Values Labels
- (void)updateMonthLable:(CGFloat) xOffset {
    if (self.graphScrollableView.strSecMonth == nil || self.graphScrollableView.xNewMonthBegin == 0) {
        [self.graphViewLineArea setLabelMonthText:self.graphScrollableView.strFirMonth Color:self.graphScrollableView.colorFriPaint];
    }
    else
    {
        if (xOffset > self.graphScrollableView.xNewMonthBegin) {
            [self.graphViewLineArea setLabelMonthText:self.graphScrollableView.strSecMonth Color:self.graphScrollableView.colorSecPaint];
        }
        else if(xOffset > self.graphScrollableView.xMonthEnd && xOffset < self.graphScrollableView.xNewMonthBegin)
        {
            [self.graphViewLineArea setLabelMonthText:@"" Color:self.graphScrollableView.colorFriPaint];
        }
        else if(xOffset < self.graphScrollableView.xMonthEnd)
        {
            [self.graphViewLineArea setLabelMonthText:self.graphScrollableView.strFirMonth Color:self.graphScrollableView.colorFriPaint];
        }
    }
}

- (CGFloat) getYMaxValue {
    CGFloat minY = 0.0;
	CGFloat maxY = 10.0;
	
    for (NSUInteger valueIndex = 0; valueIndex < self.graphViewData.count; valueIndex++) {
        
        GraphDataObject *object = [self.graphViewData objectAtIndex:valueIndex];
        if ([object.value floatValue] > maxY) {
            maxY = [object.value floatValue];
        }
        
        if ([object.value floatValue] < minY) {
            minY = [object.value floatValue];
        }
    }
	
	if (maxY < 100) {
		maxY = ceil(maxY / 10) * 10;
	}
	
	if (maxY > 100 && maxY < 1000) {
		maxY = ceil(maxY / 100) * 100;
	}
	
	if (maxY > 1000 && maxY < 10000) {
		maxY = ceil(maxY / 1000) * 1000;
	}
	
	if (maxY > 10000 && maxY < 100000) {
		maxY = ceil(maxY / 10000) * 10000;
	}
    
    if (minY < 0 && minY > -100) {
		minY = floor(minY / 10) * 10;
	}
	
	if (minY < -100 && minY > -1000) {
		minY = floor(minY / 100) * 100;
	}
	
	if (minY < -1000 && minY > -10000) {
		minY = floor(minY / 1000) * 1000;
	}
	
	if (minY < -10000 && minY > -100000) {
		minY = floor(minY / 10000) * 10000;
	}

    return maxY;
}

- (void) getYStepValues {
    CGFloat minY = 0.0;
	CGFloat maxY = [self getYMaxValue];
	
    for (NSUInteger valueIndex = 0; valueIndex < self.graphViewData.count; valueIndex++) {
        
        GraphDataObject *object = [self.graphViewData objectAtIndex:valueIndex];
        if ([object.value floatValue] > maxY) {
            maxY = [object.value floatValue];
        }
        
        if ([object.value floatValue] < minY) {
            minY = [object.value floatValue];
        }
    }
	
	if (maxY < 100) {
		maxY = ceil(maxY / 10) * 10;
	}
	
	if (maxY > 100 && maxY < 1000) {
		maxY = ceil(maxY / 100) * 100;
	}
	
	if (maxY > 1000 && maxY < 10000) {
		maxY = ceil(maxY / 1000) * 1000;
	}
	
	if (maxY > 10000 && maxY < 100000) {
		maxY = ceil(maxY / 10000) * 10000;
	}
    
    if (minY < 0 && minY > -100) {
		minY = floor(minY / 10) * 10;
	}
	
	if (minY < -100 && minY > -1000) {
		minY = floor(minY / 100) * 100;
	}
	
	if (minY < -1000 && minY > -10000) {
		minY = floor(minY / 1000) * 1000;
	}
	
	if (minY < -10000 && minY > -100000) {
		minY = floor(minY / 10000) * 10000;
	}
    
    self.fMaxYFlow = maxY;
    self.fMinYFlow = minY;
    self.graphScrollableView.fSteps = (self.graphScrollableView.frame.size.height - Y_OFFSET) / (maxY - minY);
    self.graphScrollableView.fMinY = 0;
    self.graphScrollableView.fMaxY = self.graphScrollableView.frame.size.height - Y_OFFSET;
    
    if (self.bShowLineUp)
    {
        self.graphViewLineArea.fSteps = (self.graphScrollableView.frame.size.height - Y_OFFSET) / (maxY - minY);
        self.graphViewLineArea.fMinY = minY;
        self.graphViewLineArea.fMaxY = maxY;
    }
}

#pragma mark Draw Rect
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!self.bShowLineUp)
    {
        UIFont *font = [UIFont defaultGraphBoldFontWithSize: 12.];
        CGFloat step = (self.fMaxYFlow - self.fMinYFlow) / 5;
        NSInteger value = self.fMinYFlow - step;
        
        for(int i = 0; i < 6; i++){
            float yOrigin = (i * step) * self.graphScrollableView.fSteps;
            value = value + step;
            
            NSNumber *valueToFormat = [NSNumber numberWithInt:value];
            NSString *valueString;
            valueString = [valueToFormat stringValue];
            
            [[UIColor darkGrayColor] set];
            CGRect valueStringRect = CGRectMake((X_OFFSET - 30.0f) / 2.0, self.graphScrollableView.frame.size.height + self.graphScrollableView.frame.origin.y - Y_OFFSET - yOrigin - 8.0f , 30.0f, 20.0f);
            
            [valueString drawInRect:valueStringRect withFont:font
                      lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
            
            [[UIColor graphHorizontalLineColorAlpha] set];
            
            //Horizontal dash
            UIBezierPath *bezier = [[UIBezierPath alloc] init];
            CGPoint startPoint = CGPointMake(X_OFFSET, self.frame.size.height - yOrigin - Y_OFFSET);
            CGPoint endPoint = CGPointMake(self.frame.size.width - 0.5 * X_OFFSET, self.frame.size.height - yOrigin - Y_OFFSET);
            
            [bezier moveToPoint:startPoint];
            [bezier addLineToPoint:endPoint];
            [bezier setLineWidth:1.f];
            [bezier setLineCapStyle:kCGLineCapSquare];
            
            CGFloat dashPattern[2] = {6., 3.};
            [bezier setLineDash:dashPattern count:2 phase:0];
            [[UIColor graphHorizontalLineColor] set];
            [bezier stroke];
            
            //Add unit-x.
            if (i == 5) {
                if (self.xUnit) {
                    [self.xUnit drawInRect:CGRectMake(self.frame.size.width / 2.0 - 50.0f, self.frame.size.height - yOrigin - Y_OFFSET - 25.0f, 100.0f, 20.0f) withFont:font
                             lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
                }
            }
        }
        
        //DrawAxisX
        UIBezierPath *bezier = [[UIBezierPath alloc] init];
        CGPoint startPoint = CGPointMake(X_OFFSET, self.graphScrollableView.frame.size.height + self.graphScrollableView.frame.origin.y - Y_OFFSET);
        CGPoint endPoint = CGPointMake(X_OFFSET, self.graphScrollableView.frame.origin.y);
        [bezier moveToPoint:startPoint];
        [bezier addLineToPoint:endPoint];
        [bezier setLineWidth:1.f];
        [bezier setLineCapStyle:kCGLineCapSquare];
        
        [bezier stroke];
    }
}

@end
