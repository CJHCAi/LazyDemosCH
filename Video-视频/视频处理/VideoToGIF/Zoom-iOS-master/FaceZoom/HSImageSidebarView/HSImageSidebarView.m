//
//  HSImageSidebarView.m
//  Sidebar
//
//  Created by BJ Homer on 11/16/10.
//  Copyright 2010 BJ Homer. All rights reserved.
//

#import "HSImageSidebarView.h"
#import <QuartzCore/QuartzCore.h>
#import "myPanner.h"


@interface specialView : UIView

@end

@implementation specialView




/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    touchStart = [[touches anyObject] locationInView:self];
    isResizingLR = (self.bounds.size.width - touchStart.x < kResizeThumbSize && self.bounds.size.height - touchStart.y < kResizeThumbSize);
    
    NSLog(@"this x: %f, and this y: %f", touchStart.x, touchStart.y);
    
    
    isResizingUR = (self.bounds.size.width-touchStart.x < kResizeThumbSize && touchStart.y<kResizeThumbSize);
    isResizingLL = (touchStart.x <kResizeThumbSize && self.bounds.size.height -touchStart.y <kResizeThumbSize);
    
    // isResizingUL = (touchStart.x <kResizeThumbSize && touchStart.y <kResizeThumbSize);
    isResizingUL = (fabs(touchStart.x) < 20 && fabs(touchStart.y) < 20);
}
*/


@end


@interface HSImageSidebarView () <UIScrollViewDelegate>

@property (strong) CAGradientLayer *selectionGradient;

@property (strong) NSMutableArray *viewsForReuse;
@property (strong) NSMutableIndexSet *indexesToAnimate;
@property (assign) BOOL shouldAnimateSelectionLayer;

@property (assign) BOOL initialized;
@property (assign) BOOL isHorizontal;

@property (strong) NSTimer *dragScrollTimer;

@property (strong) UIView *viewBeingDragged;
@property (assign) NSInteger draggedViewOldIndex;
@property (assign) CGPoint dragOffset;

- (void)setupViewHierarchy;
- (void)setupInstanceVariables;
- (void)recalculateScrollViewContentSize;

- (void)enqueueReusableImageView:(UIImageView *)view;
- (UIImageView *)dequeueReusableImageView;

- (CGRect)imageViewFrameInScrollViewForIndex:(NSUInteger)anIndex;
- (CGPoint)imageViewCenterInScrollViewForIndex:(NSUInteger)anIndex;

@end

@implementation HSImageSidebarView

@synthesize scrollView=_scrollView;
@synthesize imageViews;
@synthesize viewsForReuse;
@synthesize indexesToAnimate;
@synthesize shouldAnimateSelectionLayer;
@synthesize selectionGradient;
@synthesize initialized;
@synthesize viewBeingDragged;
@synthesize draggedViewOldIndex;
@synthesize dragOffset;
@synthesize selectedIndex;
@synthesize dragScrollTimer;
@synthesize delegate;
@synthesize rowHeight;
@synthesize isHorizontal;
@synthesize tF;
@synthesize lineAdjuster;
@synthesize invisiView;
@synthesize dot1;
@synthesize dot2;
@synthesize backgroundFrames;
@synthesize imageOffsets;
@synthesize offSet1;
@synthesize offSet2;
@synthesize offSet3;
@synthesize offSet4;
@synthesize offSet5;
@synthesize offSet6;
@synthesize offSet7;
@synthesize offSet8;
@synthesize offSet9;
@synthesize offSet10;
@synthesize secondView;
@synthesize secondLabel;
@synthesize thirdLabel;
@synthesize hasLoadedOnce;
@synthesize isSmall;

bool hasBeenAdjusted = NO;
bool canAdjust = NO;
int selectedNum = 0;
float myOffset = 0;
int currentIndex = 0;
float tmpOffset = 0;
float secondRatio = 50;
float shrinkRatio = 1.0;
float smallRatio = 1.0;
float oldRatio = 1.0;
/*
float offSet1 = 0.0;
float offSet2 = 0.0;
float offSet3 = 0.0;
float offSet4 = 0.0;
float offSet5 = 0.0;
float offSet6 = 0.0;
float offSet7 = 0.0;
float offSet8 = 0.0;
float offSet9 = 0.0;
float offSet10 = 0.0;
*/
#pragma mark -
- (id)initWithFrame:(CGRect)frame {
//	if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y-100, frame.size.width, frame.size.height+100)])) {
    if (self = [super initWithFrame:frame]) {
        
        offSet1 = 0.0;
        offSet2 = 0.0;
        offSet3 = 0.0;
        offSet4 = 0.0;
        offSet5 = 0.0;
        offSet6 = 0.0;
        offSet7 = 0.0;
        offSet8 = 0.0;
        offSet9 = 0.0;
        offSet10 = 0.0;
		// Initialization code
		[self setupInstanceVariables];
		[self setupViewHierarchy];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self setupInstanceVariables];
		[self setupViewHierarchy];
	}
	return self;
}


- (void)dealloc {
	[dragScrollTimer invalidate];
}

#pragma mark -
#pragma mark Setup

/*
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if ( CGRectContainsPoint(self.oversizeButton.frame, point) )
        return YES;
    
    return [super pointInside:point withEvent:event];
}
 */


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(CGRectMake(self.bounds.origin.x, self.bounds.origin.y - 40, self.bounds.size.width, self.bounds.size.height+40), point))
    
   // NSLog(@"point this: %@", NSStringFromCGPoint(point));
     if (CGRectContainsPoint(CGRectMake(0, -40, self.frame.size.width, self.frame.size.height + 40), point))
    {
        NSLog(@"hawt diggity dawg");
        return YES;
    }
    return NO;
}

/*
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGFloat radius = 100.0;
   // CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-100, self.frame.size.width, self.frame.size.height + radius);
    
    CGRect frame = CGRectMake(0, -100, self.frame.size.width, self.frame.size.height + 100);
    
//    NSLog(@"logger: %@", NSStringFromCGRect(frame));
//    NSLog(@"logger 2: %@\n", NSStringFromCGPoint(point));
    
    if (CGRectContainsPoint(frame, point)) {
//        NSLog(@"oh lawdy");
        return self;
    }
    return nil;
}
 */


/*
-(void)scrollViewWillBeginDragging:(UIScrollView*)scrollView{
    NSLog(@"scrollViewWillBeginDragging");
    //scrollView.contentOffset
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndScrollingAnimation");
}
 */


-(void)setOffSetAtIndex:(int)i withVal:(float)thisVal{
    
    if (i == 0){
        offSet1 = thisVal;
    } else if (i == 1){
        offSet2 = thisVal;
    } else if (i == 2){
        offSet3 = thisVal;
    } else if (i == 3){
        offSet4 = thisVal;
    } else if (i == 4){
        offSet5 = thisVal;
    } else if (i == 5){
        offSet6 = thisVal;
    } else if (i == 6){
        offSet7 = thisVal;
    } else if (i == 7){
        offSet8 = thisVal;
    } else if (i == 8){
        offSet9 = thisVal;
    } else if (i == 9){
        offSet10 = thisVal;
    }

}

-(float)offSetAtIndex:(int)i{
    if (i == 0){
        //       NSLog(@"offset1");
        return (offSet1);
    } else if (i==1){
        //       NSLog(@"offset2");
        return (offSet2);
    } else if (i==2){
        //      NSLog(@"offset3");
        return (offSet3);
    } else if (i==3){
        //       NSLog(@"offset4");
        return (offSet4);
    } else if (i==4){
        //      NSLog(@"offset5");
        return (offSet5);
    } else if (i==5){
        //      NSLog(@"offset6");
        return (offSet6);
    } else if (i==6){
        //      NSLog(@"offset7");
        return (offSet7);
    } else if (i==7){
        //      NSLog(@"offset8");
        return (offSet8);
    } else if (i==8){
        //       NSLog(@"offset9");
        return (offSet9);
    } else if (i==9){
        //      NSLog(@"offset10");
        return (offSet10);
    }
    return 0.0;
}

-(float)cummulativeSumOffsetAtIndex:(int)i{
    
    if (i == 0){
        return offSet1;
    } else if (i == 1){
        return offSet1 + offSet2;
    } else if (i == 2){
        return offSet1 + offSet2 + offSet3;
    } else if (i == 3){
        return offSet1 + offSet2 + offSet3 + offSet4;
    } else if (i == 4){
        return offSet1 + offSet2 + offSet3 + offSet4 + offSet5;
    } else if (i == 5){
        return offSet1 + offSet2 + offSet3 + offSet4 + offSet5 + offSet6;
    } else if (i == 6){
        return offSet1 + offSet2 + offSet3 + offSet4 + offSet5 + offSet6 + offSet7;
    } else if (i == 7){
        return offSet1 + offSet2 + offSet3 + offSet4 + offSet5 + offSet6 + offSet7 + offSet8;
    } else if (i == 8){
        return offSet1 + offSet2 + offSet3 + offSet4 + offSet5 + offSet6 + offSet7 + offSet8 + offSet9;
    } else if (i == 9){
        return offSet1 + offSet2 + offSet3 + offSet4 + offSet5 + offSet6 + offSet7 + offSet8 + offSet9 + offSet10;
    }
    return 0.0;
        
}

-(void)readjustAfterRemovingOffsetAtIndex:(int)index{
    if (index == 0){
        offSet1 = offSet2;
        offSet2 = offSet3;
        offSet3 = offSet4;
        offSet4 = offSet5;
        offSet5 = offSet6;
        offSet6 = offSet7;
        offSet7 = offSet8;
        offSet8 = offSet9;
        offSet9 = offSet10;
        offSet10 = 0.0;
    } else if (index == 1){
        offSet2 = offSet3;
        offSet3 = offSet4;
        offSet4 = offSet5;
        offSet5 = offSet6;
        offSet6 = offSet7;
        offSet7 = offSet8;
        offSet8 = offSet9;
        offSet9 = offSet10;
        offSet10 = 0.0;
    } else if (index == 2){
        offSet3 = offSet4;
        offSet4 = offSet5;
        offSet5 = offSet6;
        offSet6 = offSet7;
        offSet7 = offSet8;
        offSet8 = offSet9;
        offSet9 = offSet10;
        offSet10 = 0.0;
    } else if (index == 3){
        offSet4 = offSet5;
        offSet5 = offSet6;
        offSet6 = offSet7;
        offSet7 = offSet8;
        offSet8 = offSet9;
        offSet9 = offSet10;
        offSet10 = 0.0;
    } else if (index == 4){
        offSet5 = offSet6;
        offSet6 = offSet7;
        offSet7 = offSet8;
        offSet8 = offSet9;
        offSet9 = offSet10;
        offSet10 = 0.0;
    } else if (index == 5){
        offSet6 = offSet7;
        offSet7 = offSet8;
        offSet8 = offSet9;
        offSet9 = offSet10;
        offSet10 = 0.0;
    } else if (index == 6){
        offSet7 = offSet8;
        offSet8 = offSet9;
        offSet9 = offSet10;
        offSet10 = 0.0;
    } else if (index == 7){
        offSet8 = offSet9;
        offSet9 = offSet10;
        offSet10 = 0.0;
    } else if (index == 8){
        offSet9 = offSet10;
        offSet10 = 0.0;
    } else if (index == 9){
        offSet10 = 0.0;
    }
}

-(void)addAllOffsets:(float)newOffset{
    offSet1 = offSet1 + newOffset;
    offSet2 = offSet2 + newOffset;
    offSet3 = offSet3 + newOffset;
    offSet4 = offSet4 + newOffset;
    offSet5 = offSet5 + newOffset;
    offSet6 = offSet6 + newOffset;
    offSet7 = offSet7 + newOffset;
    offSet8 = offSet8 + newOffset;
    offSet9 = offSet9 + newOffset;
    offSet10 = offSet10 + newOffset;

}

-(void)calculateIndex:(int)i {
    if (i == 0){
        NSLog(@"calc Off1");
        offSet1 = lineAdjuster.frame.size.width - rowHeight;
    } else if (i == 1){
        NSLog(@"calc Off2");
        offSet2 = lineAdjuster.frame.size.width - rowHeight;
    } else if (i == 2){
        NSLog(@"calc Off3");
        offSet3 = lineAdjuster.frame.size.width - rowHeight;
    } else if (i == 3){
        NSLog(@"calc Off4");
        offSet4 = lineAdjuster.frame.size.width - rowHeight;
    } else if (i == 4){
        NSLog(@"calc Off5");
        offSet5 = lineAdjuster.frame.size.width - rowHeight;
    } else if (i == 5){
        NSLog(@"calc Off6");
        offSet6 = lineAdjuster.frame.size.width - rowHeight;
    } else if (i == 6){
        NSLog(@"calc Off7");
        offSet7 = lineAdjuster.frame.size.width - rowHeight;
    } else if (i == 7){
        NSLog(@"calc Off8");
        offSet8 = lineAdjuster.frame.size.width - rowHeight;
    } else if (i == 8){
        NSLog(@"calc Off9");
        offSet9 = lineAdjuster.frame.size.width - rowHeight;
    } else if (i == 9){
        NSLog(@"calc Off10");
        offSet10 = lineAdjuster.frame.size.width - rowHeight;
    }

}

-(void)calculateIndex:(int)i withTranslation:(float)amount{
    if (i == 0){
        offSet1 += amount;
    } else if (i == 1){
        offSet2 += amount;
    } else if (i == 2){
        offSet3 += amount;
    } else if (i == 3){
        offSet4 += amount;
    } else if (i == 4){
        offSet5 += amount;
    } else if (i == 5){
        offSet6 += amount;
    } else if (i == 6){
        offSet7 += amount;
    } else if (i == 7){
        offSet8 += amount;
    } else if (i == 8){
        offSet9 += amount;
    } else if (i == 9){
        offSet10 += amount;
    }
    
}

-(void)calculateMyIndex:(int)i withTranslation:(float)amount{
    if (i == 0){
        offSet1 += amount;
    } else if (i == 1){
        offSet2 += amount;
    } else if (i == 2){
        offSet3 += amount;
    } else if (i == 3){
        offSet4 += amount;
    } else if (i == 4){
        offSet5 += amount;
    } else if (i == 5){
        offSet6 += amount;
    } else if (i == 6){
        offSet7 += amount;
    } else if (i == 7){
        offSet8 += amount;
    } else if (i == 8){
        offSet9 += amount;
    } else if (i == 9){
        offSet10 += amount;
    }
    
}

-(void)addUpAtIndex:(int)i withTranslation:(float)amount{
    
    if (i ==0){
        offSet1 += amount;
        offSet2 += amount;
        offSet3 += amount;
        offSet4 += amount;
        offSet5 += amount;
        offSet6 += amount;
        offSet7 += amount;
        offSet8 += amount;
        offSet9 += amount;
        offSet10 += amount;
    } else if (i==1){
        offSet2 += amount;
        offSet3 += amount;
        offSet4 += amount;
        offSet5 += amount;
        offSet6 += amount;
        offSet7 += amount;
        offSet8 += amount;
        offSet9 += amount;
        offSet10 += amount;
    } else if (i==2){
        offSet3 += amount;
        offSet4 += amount;
        offSet5 += amount;
        offSet6 += amount;
        offSet7 += amount;
        offSet8 += amount;
        offSet9 += amount;
        offSet10 += amount;
    } else if (i==3){
            offSet4 += amount;
            offSet5 += amount;
            offSet6 += amount;
            offSet7 += amount;
            offSet8 += amount;
            offSet9 += amount;
            offSet10 += amount;
    } else if (i==4){
                offSet5 += amount;
                offSet6 += amount;
                offSet7 += amount;
                offSet8 += amount;
                offSet9 += amount;
                offSet10 += amount;
    } else if (i==5){
                    offSet6 += amount;
                    offSet7 += amount;
                    offSet8 += amount;
                    offSet9 += amount;
                    offSet10 += amount;
    } else if (i==6){
                        offSet7 += amount;
                        offSet8 += amount;
                        offSet9 += amount;
                        offSet10 += amount;
    } else if (i==7){
                            offSet8 += amount;
                            offSet9 += amount;
                            offSet10 += amount;
    } else if (i==8){
                                offSet9 += amount;
                                offSet10 += amount;
    } else if (i==9){
                                    offSet10 += amount;
    }
}

- (void) setupViewHierarchy {
    hasLoadedOnce = NO;
    isSmall = NO;
    
    secondView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 250)];
    secondView.layer.cornerRadius = 125;
    secondView.center = CGPointMake(([UIScreen mainScreen].bounds.size.width-30)/2.0, -[UIScreen mainScreen].bounds.size.height/2.0 + 100);
    secondView.backgroundColor = [UIColor blackColor];
    secondView.layer.opacity = 0.0;
    secondView.hidden = YES;
    [self addSubview:secondView];
    
    secondLabel = [[UILabel alloc]init];
    secondLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:120];
    secondLabel.text = @"0.1";
    secondLabel.textColor = [UIColor whiteColor];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    [secondLabel sizeToFit];
    secondLabel.center = CGPointMake(125, 115);
    [secondView addSubview:secondLabel];
    
    thirdLabel = [[UILabel alloc]init];
    thirdLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:26];
    thirdLabel.text = @"seconds";
    thirdLabel.textColor = [UIColor whiteColor];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    [thirdLabel sizeToFit];
    thirdLabel.center = CGPointMake(125, 190);
    [secondView addSubview:thirdLabel];
    
    
    hasBeenAdjusted = NO;
    
    //imageOffsets = [[NSMutableArray alloc]init];
    backgroundFrames = [[NSMutableArray alloc]init];
    
	self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
	_scrollView.delegate = self;
	if (self.bounds.size.width > self.bounds.size.height) {
		isHorizontal = YES;
		[_scrollView setAutoresizingMask: UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth];
	}
	else {
		[_scrollView setAutoresizingMask: UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight];
	}

	
	_scrollView.backgroundColor = [UIColor clearColor];
	if (isHorizontal == NO) {
		_scrollView.alwaysBounceVertical = YES;
	}
	else {
		_scrollView.alwaysBounceHorizontal = YES;
	}
	_scrollView.clipsToBounds = NO;
	[self addSubview:_scrollView];
    	
	self.selectionGradient = [CAGradientLayer layer];
	
    UIColor *baseColor = [UIColor colorWithRed:244.0/255.0 green:85.0/255.0 blue:79.0/255.0 alpha:1.0];//[UIColor colorWithHue:0.666 saturation:0.75 brightness:0.8 alpha:1];
	UIColor *topColor = [baseColor colorWithAlphaComponent:0.0];
	UIColor *bottomColor = [baseColor colorWithAlphaComponent:0.0];
	selectionGradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
	selectionGradient.hidden = YES;
	
	[_scrollView.layer addSublayer:selectionGradient];
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedSidebar:)];
    tapRecognizer.numberOfTapsRequired = 1;
	[self addGestureRecognizer:tapRecognizer];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(clonePicture:)];
    doubleTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:doubleTap];
    
    [tapRecognizer requireGestureRecognizerToFail:doubleTap];
	
	UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedSidebar:)];
    pressRecognizer.minimumPressDuration = 0.3;
	[self addGestureRecognizer:pressRecognizer];
    
    tF = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    tF.frame = CGRectMake(-15, 0, self.scrollView.frame.size.width + 30, rowHeight);
    [self insertSubview:tF belowSubview:self.scrollView];
    
}


- (void) setupInstanceVariables {
	selectedIndex = -1;
	self.rowHeight = 100;
	self.imageViews = [NSMutableArray array];
	self.viewsForReuse = [NSMutableArray array];
	self.indexesToAnimate = [NSMutableIndexSet indexSet];
}

#pragma mark -

- (void)layoutSubviews {
	if (!self.initialized) {
		[self reloadData];
		self.initialized = YES;
	}
	
	id noView = [NSNull null];
	
    NSIndexSet *visibleIndices = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0,  imageViews.count)];//[self imageViews].//[self visibleIndices];
	
    
	// Remove any off-screen views
	NSMutableIndexSet *indexesToRelease = [NSMutableIndexSet indexSet];
	[imageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (obj != noView && obj != viewBeingDragged && [visibleIndices containsIndex:idx] == NO) {
			[indexesToRelease addIndex:idx];
			[self enqueueReusableImageView:obj];

		}
	}];
	
	[indexesToRelease enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		[imageViews replaceObjectAtIndex:idx withObject:noView];
	}];
	
	
	// Load any views that need loading
	[visibleIndices enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		UIImageView *existingView = [imageViews objectAtIndex:idx];
		if (existingView == noView) {
			UIImage *image = [delegate sidebar:self imageForIndex:idx];
			
			UIImageView *imageView = [self dequeueReusableImageView];
			if (imageView == nil) {
				imageView = [[UIImageView alloc] init];
			}
			//imageView.image = image;
            //imageView.backgroundColor = [UIColor redColor];
            imageView.backgroundColor = [UIColor blackColor];
            [imageView.layer setBorderColor:[UIColor redColor].CGColor];
            [imageView.layer setBorderWidth:2.0f];
            // THIS LINE IS MUY IMPORTANTE
			imageView.frame = [self imageViewFrameInScrollViewForIndex:idx];
            imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
            imageView.clipsToBounds = YES;
	//		imageView.transform = CGAffineTransformIdentity;
	//		imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            
            //UIView *thisView = [[UIView alloc]initWithFrame:CGRectMake(-4, -4, imageView.frame.size.width+8, imageView.frame.size.height+8)];
            //thisView.backgroundColor = [UIColor purpleColor];
            //[imageView insertSubview:thisView atIndex:0];
            
            UIImageView *thisView = [[UIImageView alloc]initWithFrame:CGRectMake((imageView.frame.size.width - imageView.frame.size.height)/2, 0, imageView.frame.size.height, imageView.frame.size.height)];
            //thisView.center = imageView.center;
            thisView.image = image;
            thisView.tag = idx + 25;
            thisView.transform = CGAffineTransformIdentity;
            thisView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView insertSubview:thisView atIndex:0];// aboveSubview:<#(UIView *)#>];
            
			[_scrollView addSubview:imageView];
			
			if ([indexesToAnimate containsIndex:idx]) {
				imageView.alpha = 0;
				[UIView animateWithDuration:0.2
									  delay:0
									options:UIViewAnimationOptionAllowUserInteraction
								 animations:^{
									 imageView.alpha = 1.0;
								 }
								 completion:NULL];
				[indexesToAnimate removeIndex:idx];
			}
			
			[self.imageViews replaceObjectAtIndex:idx withObject:imageView];
		}
	}];
	
	// Position all the views in their new location
	[UIView animateWithDuration:0.2
						  delay:0
						options:UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 [imageViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
							 UIView *view = obj;
							 if (view != noView && view != self.viewBeingDragged) {
                                 
								 view.center = [self centerImageViewCenterInScrollViewForIndex:idx];
							 }
						 }];
					 }
					completion:NULL];
	
	// Draw selection layer
	if (selectedIndex >= 0) {
		CFBooleanRef disableAnimations = shouldAnimateSelectionLayer ? kCFBooleanFalse : kCFBooleanTrue;
		[CATransaction begin];
		[CATransaction setValue:(__bridge id)disableAnimations
						 forKey:kCATransactionDisableActions];
		
		selectionGradient.hidden = NO;
      //  if (selectedIndex == 0){
      //      selectionGradient.frame = CGRectMake(-15, 0, rowHeight+15, _scrollView.bounds.size.height);

//        } else if (selectedIndex == imageViews.count - 1){
  //          selectionGradient.frame = CGRectMake((100*(imageViews.count-1)), 0, rowHeight+15, _scrollView.bounds.size.height);
            //selectionGradient.position = [self imageViewCenterInScrollViewForIndex:selectedIndex];
    //    } else {
        
            if (isHorizontal) {

                selectionGradient.bounds = CGRectMake([self cummulativeSumOffsetAtIndex:(int)selectedIndex], 0, rowHeight + [self offSetAtIndex:(int)selectedIndex], _scrollView.bounds.size.height);
            }
            else {
                selectionGradient.bounds = CGRectMake(0, 0, _scrollView.bounds.size.width, rowHeight);
            }
        
        //    selectionGradient.position = [self imageViewCenterInScrollViewForIndex:selectedIndex];
        
        CGPoint thisPoint = [self specialImageViewCenterInScrollViewForIndex:selectedIndex];
        selectionGradient.position = CGPointMake(thisPoint.x + [self offSetAtIndex:(int)selectedIndex], thisPoint.y);
        
     //   }
		[CATransaction commit];
		
		// If we should animate, it will explicitly be reset to YES later.
		self.shouldAnimateSelectionLayer = NO;
	}
	else {
		selectionGradient.hidden = YES;
	}
    shrinkRatio = self.scrollView.bounds.size.width/self.scrollView.contentSize.width;// - 0.03;
   // NSLog(@"shrinkRatio: %f", shrinkRatio);
    
    CGFloat otherRatio = 1.0 - shrinkRatio;
    CGFloat topMargin = otherRatio*rowHeight;
    
    if (hasLoadedOnce == NO){
    [UIView animateWithDuration:0.1 animations:^{
    

        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y + topMargin-5, self.scrollView.frame.size.width, shrinkRatio*self.scrollView.frame.size.height+5);
        
        self.tF.frame = CGRectMake(self.tF.frame.origin.x, self.tF.frame.origin.y + topMargin-5, self.tF.frame.size.width, shrinkRatio*self.tF.frame.size.height+5);
    
    } completion:^(BOOL finished){
        
        smallRatio = shrinkRatio;
        self.rowHeight = self.rowHeight*shrinkRatio;
        
        [self reloadData];
    
        hasLoadedOnce = YES;
        isSmall = YES;
        self.scrollView.scrollEnabled = NO;

    
    }];
    }

}

- (void)recalculateScrollViewContentSize {
	if (isHorizontal) {
		_scrollView.contentSize = CGSizeMake(self.imageCount*(rowHeight-1) + [self cummulativeSumOffsetAtIndex:(int)(imageViews.count - 1)], _scrollView.bounds.size.height);
	}
	else {
		_scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, self.imageCount*rowHeight);
	}
}

- (void) reloadData {
	NSUInteger imageCount = [delegate countOfImagesInSidebar:self];

	// clear out the previous imageViews so we get a fresh array to fill
    [imageViews removeAllObjects];
	for (NSUInteger i=0; i<imageCount; ++i) {
		[imageViews addObject:[NSNull null]];
	}
	
    // remove all previous images that were loaded
    NSArray *subViews = [_scrollView subviews];
    for (UIView *view in subViews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
	[self recalculateScrollViewContentSize];
	[self setNeedsLayout];
}

- (void)scrollRowAtIndexToVisible:(NSUInteger)anIndex {
	if (anIndex > self.imageCount - 1) {
		return;
	}
	CGRect scrollBounds = _scrollView.bounds;
	CGRect imageFrame = [self imageViewFrameInScrollViewForIndex:anIndex];
    
	if (isHorizontal == NO) {
		CGFloat scrollTop = CGRectGetMinY(scrollBounds);
		CGFloat scrollBottom = CGRectGetMaxY(scrollBounds);
		CGFloat imageTop = CGRectGetMinY(imageFrame);
		CGFloat imageBottom = CGRectGetMaxY(imageFrame);
		
		CGPoint oldOffset = _scrollView.contentOffset;
		
		if (imageTop < scrollTop) {
			// It's off the top of the screen
			CGFloat distanceBetweenFrameAndRowTop = (int)imageTop % (int)rowHeight;
			CGFloat delta = scrollTop - imageTop + distanceBetweenFrameAndRowTop;
			
			if (anIndex != 0) {
				// Show a bit of the previous row, if one exists
				delta += (rowHeight / 2); 
			}
			CGPoint newOffset = CGPointMake(oldOffset.x, oldOffset.y - delta);
			
			[_scrollView setContentOffset:newOffset animated:YES];
		}
		else if (scrollBottom < imageBottom) {
			// It's off the bottom of the screen
			CGFloat distanceBetweenFrameAndRowBottom = rowHeight - ((int)imageBottom % (int)rowHeight);
			
			CGFloat delta = imageBottom - scrollBottom + distanceBetweenFrameAndRowBottom;
			if (anIndex != [self imageCount] - 1) {
				// Show a bit of the next row, if one exists.
				delta += (rowHeight / 2);	
			}
			CGPoint newOffset = CGPointMake(oldOffset.x, oldOffset.y + delta);
			
			[_scrollView setContentOffset:newOffset animated:YES];
		}
	}
	else {
		CGFloat scrollLeft = CGRectGetMinX(scrollBounds);
		CGFloat scrollRight = CGRectGetMaxX(scrollBounds);
		CGFloat imageLeft = CGRectGetMinX(imageFrame);
		CGFloat imageRight = CGRectGetMaxX(imageFrame);
		
		CGPoint oldOffset = _scrollView.contentOffset;
		
		if (imageLeft < scrollLeft) {
			// It's off the top of the screen
			CGFloat distanceBetweenFrameAndRowLeft = (int)imageLeft % (int)rowHeight;
			CGFloat delta = scrollLeft - imageLeft + distanceBetweenFrameAndRowLeft;
			
			if (anIndex != 0) {
				// Show a bit of the previous row, if one exists
				delta += (rowHeight / 2); 
			}
			CGPoint newOffset = CGPointMake(oldOffset.x - delta, oldOffset.y);
			
			[_scrollView setContentOffset:newOffset animated:YES];
		}
		else if (scrollRight < imageRight) {
			// It's off the bottom of the screen
			CGFloat distanceBetweenFrameAndRowRight = rowHeight - ((int)imageRight % (int)rowHeight);
			
			CGFloat delta = imageRight - scrollRight + distanceBetweenFrameAndRowRight;
			if (anIndex != [self imageCount] - 1) {
				// Show a bit of the next row, if one exists.
				delta += (rowHeight / 2);	
			}
			CGPoint newOffset = CGPointMake(oldOffset.x + delta, oldOffset.y);
			
			[_scrollView setContentOffset:newOffset animated:YES];
		}
	}
}

- (void)insertRowAtIndex:(NSUInteger)anIndex {
    if (anIndex > imageViews.count-1){
        
    } else {
	[imageViews insertObject:[NSNull null] atIndex:anIndex];
	[indexesToAnimate addIndex:anIndex];
	
	if (selectedIndex != -1 && anIndex < selectedIndex) {
		self.selectedIndex += 1;
		self.shouldAnimateSelectionLayer = YES;
	}
	
	[self recalculateScrollViewContentSize];
	[self setNeedsLayout];
    }
}

- (void)deleteRowAtIndex:(NSUInteger)anIndex {
	UIImageView *selectedView = [imageViews objectAtIndex:anIndex];
	if ([selectedView isKindOfClass:[NSNull class]] == NO) {
		[self enqueueReusableImageView:selectedView];
	}
	[imageViews removeObjectAtIndex:anIndex];

	if (selectedIndex != -1 && anIndex < selectedIndex) {
		self.selectedIndex -= 1;
		self.shouldAnimateSelectionLayer = YES;
	}
	else if (selectedIndex == anIndex) {
		self.selectedIndex = -1;
	}
	
	[self recalculateScrollViewContentSize];
	
	[self setNeedsLayout];
}

-(void)increaseTime{
    
    
    
    invisiView.frame = CGRectMake(invisiView.frame.origin.x, invisiView.frame.origin.y, invisiView.frame.size.width + 50, invisiView.frame.size.height);
    lineAdjuster.frame = CGRectMake(lineAdjuster.frame.origin.x, lineAdjuster.frame.origin.y, lineAdjuster.frame.size.width + 50, lineAdjuster.frame.size.height);
    dot2.center = CGPointMake(lineAdjuster.frame.size.width, 1.5);
    
    
    for (int j = 0; j < imageViews.count; j++){
        
        UIImageView *tmpImage = (UIImageView *)[imageViews objectAtIndex:j];
    
        tmpImage.frame = CGRectMake(tmpImage.frame.origin.x, tmpImage.frame.origin.y, tmpImage.frame.size.width + 50, tmpImage.frame.size.height);
    
    
    for (UIView *i in tmpImage.subviews){
        if([i isKindOfClass:[UIView class]]){
            //UILabel *newLbl = (UILabel *)i;
            UIView *thisView = (UIView *)i;
            if(thisView.tag == (j + 25)){
                
                
                
                if (tmpImage.frame.size.width < 100 || thisView.frame.size.width < 98){

                    thisView.frame = CGRectMake(thisView.frame.origin.x, thisView.frame.origin.y-50.0/2.0, tmpImage.frame.size.width, tmpImage.frame.size.width);
                    
                } else {
                    
                    thisView.center = CGPointMake(thisView.center.x + 50.0/2.0, thisView.center.y);
                    
                    
                    
                    
                }
            }
        }
    }
    }
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width + 50*imageViews.count, _scrollView.bounds.size.height);
    shrinkRatio = self.scrollView.bounds.size.width/self.scrollView.contentSize.width;// - 0.03;
    
    
    
    [self addAllOffsets:50.0];

    [self reloadData];
    
    [self shrinkThis];


}

-(void)decreaseTime{
    invisiView.frame = CGRectMake(invisiView.frame.origin.x, invisiView.frame.origin.y, invisiView.frame.size.width - 50, invisiView.frame.size.height);
    lineAdjuster.frame = CGRectMake(lineAdjuster.frame.origin.x, lineAdjuster.frame.origin.y, lineAdjuster.frame.size.width - 50, lineAdjuster.frame.size.height);
    dot2.center = CGPointMake(lineAdjuster.frame.size.width, 1.5);
    
    
    for (int j = 0; j < imageViews.count; j++){
        
        UIImageView *tmpImage = (UIImageView *)[imageViews objectAtIndex:j];
        
        tmpImage.frame = CGRectMake(tmpImage.frame.origin.x, tmpImage.frame.origin.y, tmpImage.frame.size.width - 50, tmpImage.frame.size.height);
        
        
        for (UIView *i in tmpImage.subviews){
            if([i isKindOfClass:[UIView class]]){
                //UILabel *newLbl = (UILabel *)i;
                UIView *thisView = (UIView *)i;
                if(thisView.tag == (j + 25)){
                    
                    
                    
                    if (tmpImage.frame.size.width < 100 || thisView.frame.size.width < 98){
                        
                        thisView.frame = CGRectMake(thisView.frame.origin.x, thisView.frame.origin.y+50.0/2.0, tmpImage.frame.size.width, tmpImage.frame.size.width);
                        
                    } else {
                        
                        thisView.center = CGPointMake(thisView.center.x + -50.0/2.0, thisView.center.y);
                        
                        
                        
                        
                    }
                }
            }
        }
    }
    
    
    _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width + -50*imageViews.count, _scrollView.bounds.size.height);
    shrinkRatio = self.scrollView.bounds.size.width/self.scrollView.contentSize.width;// - 0.03;
    
    
    
    [self addAllOffsets:-50.0];
    
    [self reloadData];
    
    [self shrinkThis];
}

-(void)clonePicture:(UITapGestureRecognizer *)tapper{
 
    UIView *hitView = [self hitTest:[tapper locationInView:self] withEvent:nil];
    if (hitView == _scrollView) {
        

        if (isSmall == YES){
            
        } else {
        
        CGPoint hitPoint = [tapper locationInView:_scrollView];
        
        CGFloat thisFloat = hitPoint.x;
        
        CGFloat oldRowHeight = rowHeight;
    //    NSLog(@"rattatat: %f", oldRowHeight);
        oldRatio = 1.0;
        
        
        if (thisFloat > 0 && thisFloat <= (oldRowHeight + [self cummulativeSumOffsetAtIndex:0]*oldRatio)){
            self.selectedIndex = 0;
        } else if (thisFloat > (oldRowHeight + [self cummulativeSumOffsetAtIndex:0]*oldRatio) && (thisFloat < (2*oldRowHeight + [self cummulativeSumOffsetAtIndex:1]*oldRatio))){
            self.selectedIndex = 1;
        } else if (thisFloat > (2*oldRowHeight + [self cummulativeSumOffsetAtIndex:1]*oldRatio) && (thisFloat < (3*oldRowHeight + [self cummulativeSumOffsetAtIndex:2]*oldRatio))){
            self.selectedIndex = 2;
        } else if (thisFloat > (3*oldRowHeight + [self cummulativeSumOffsetAtIndex:2]*oldRatio) && (thisFloat < (4*oldRowHeight + [self cummulativeSumOffsetAtIndex:3]*oldRatio))){
            self.selectedIndex = 3;
        } else if (thisFloat > (4*oldRowHeight + [self cummulativeSumOffsetAtIndex:3]*oldRatio) && (thisFloat < (5*oldRowHeight + [self cummulativeSumOffsetAtIndex:4]*oldRatio))){
            self.selectedIndex = 4;
        } else if (thisFloat > (5*oldRowHeight + [self cummulativeSumOffsetAtIndex:4]*oldRatio) && (thisFloat < (6*oldRowHeight + [self cummulativeSumOffsetAtIndex:5]*oldRatio))){
            self.selectedIndex = 5;
        } else if (thisFloat > (6*oldRowHeight + [self cummulativeSumOffsetAtIndex:5]*oldRatio) && (thisFloat < (7*oldRowHeight + [self cummulativeSumOffsetAtIndex:6]*oldRatio))){
            self.selectedIndex = 6;
        } else if (thisFloat > (7*oldRowHeight + [self cummulativeSumOffsetAtIndex:6]*oldRatio) && (thisFloat < (8*oldRowHeight + [self cummulativeSumOffsetAtIndex:7]*oldRatio))){
            self.selectedIndex = 7;
        } else if (thisFloat > (8*oldRowHeight + [self cummulativeSumOffsetAtIndex:7]*oldRatio) && (thisFloat < (9*oldRowHeight + [self cummulativeSumOffsetAtIndex:8]*oldRatio))){
            self.selectedIndex = 8;
        } else if (thisFloat > (9*oldRowHeight + [self cummulativeSumOffsetAtIndex:8]*oldRatio) && (thisFloat < (10*oldRowHeight + [self cummulativeSumOffsetAtIndex:9]*oldRatio))){
            self.selectedIndex = 9;
        }
        
        //        tmpImage =(UIImageView *)[imageViews objectAtIndex:self.selectedIndex];
        
        
        //NSLog(@"THIS HIT: %f", hitPoint.x);
        //NSInteger newSelection = (hitPoint.x / rowHeight);
        
        NSInteger newSelection = self.selectedIndex;
        
        if (newSelection > self.imageCount - 1 || self.imageCount == 0) {
            self.selectedIndex = -1;
        } else {
        
            currentIndex = (int)newSelection;
  //          NSLog(@"copied index: %i", self.selectedIndex);
            NSInteger insertionIndex = self.selectedIndex;
            
     //       UIImageView *cloneView = [[UIImageView alloc]init];
     //       cloneView.bounds = ((UIImageView *)[imageViews objectAtIndex:self.selectedIndex]).bounds;
      //      cloneView.image = ((UIImageView *)[imageViews objectAtIndex:self.selectedIndex]).image;
            [self insertRowAtIndex:insertionIndex];
            [self scrollRowAtIndexToVisible:insertionIndex];
            self.selectedIndex = insertionIndex;
            
            [delegate cloneArrayObjectAtIndex:(int)self.selectedIndex];
            
        }
        
        
        
        
        
        

        NSLog(@"YASSSSS");
        /*
        NSInteger insertionIndex = _sidebar.selectedIndex + 1;
        [colors insertObject:[NSNumber numberWithInt:arc4random()%3]
                     atIndex:insertionIndex];
        [_sidebar insertRowAtIndex:insertionIndex];
        [_sidebar scrollRowAtIndexToVisible:insertionIndex];
        _sidebar.selectedIndex = insertionIndex;

         */
        }
    }
}


-(void)resizePic:(myPanner *)recognizer{
    
    UIImageView *tmpImage =(UIImageView *)[imageViews objectAtIndex:currentIndex];
    
    CGFloat thisSeconds = floorf(tmpImage.frame.size.width/75)/10.0 + 0.1;
    // NSLog(@"%.1f", thisSeconds);
    secondLabel.text = [NSString stringWithFormat:@"%.1f", thisSeconds];
    if (thisSeconds == 1.0){
        thirdLabel.text = @"second";
        thirdLabel.center = CGPointMake(125, 190);
    } else if ([thirdLabel.text isEqualToString:@"second"] && thisSeconds != 1.0){
        thirdLabel.text = @"seconds";
        thirdLabel.center = CGPointMake(125, 190);
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan){
        secondView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            
            secondView.layer.opacity = 0.7;
            
        } completion:^(BOOL finished){
            
            
        }];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:0.2 animations:^{
            
            secondView.layer.opacity = 0.0;
            
        } completion:^(BOOL finished){
            secondView.hidden = YES;
        }];
    }
    
    if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded){
        
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
       // CGRect recognizerFrame = recognizer.view.frame;
        
        CGPoint myPoint = [recognizer touchPointInView:recognizer.view];
        
//        NSLog(@"LOG THIS Pan Origin: %@", NSStringFromCGPoint(myPoint));
  
  //      NSLog(@"LOG THIS Translation: %@", NSStringFromCGPoint(translation));
        
//        NSLog(@"LOG THIS Frame Origin: %@", NSStringFromCGPoint(recognizerFrame.origin));
        
        // Check if UIImageView is completely inside its superView
        
        if ((fabs(myPoint.x) < 50 && fabs(myPoint.y) < 50)  ||  (fabs(myPoint.x - recognizer.view.frame.size.width) < 50 && fabs(myPoint.y) < 50)){
            
            
            
            
            if ((fabs(myPoint.x - recognizer.view.frame.size.width) < 50 && fabs(myPoint.y) < 50)){
                

                if (tmpImage.frame.size.width + translation.x < 50){

                
                } else {
                    
                invisiView.frame = CGRectMake(invisiView.frame.origin.x, invisiView.frame.origin.y, invisiView.frame.size.width + translation.x, invisiView.frame.size.height);
                lineAdjuster.frame = CGRectMake(lineAdjuster.frame.origin.x, lineAdjuster.frame.origin.y, lineAdjuster.frame.size.width + translation.x, lineAdjuster.frame.size.height);
                dot2.center = CGPointMake(lineAdjuster.frame.size.width, 1.5);
                CGPoint movePoint = CGPointMake(translation.x, 0);
                

                [recognizer incrementOrigin:&movePoint];
                

                tmpImage.frame = CGRectMake(tmpImage.frame.origin.x, tmpImage.frame.origin.y, tmpImage.frame.size.width + translation.x, tmpImage.frame.size.height);
                
                
                for (UIView *i in tmpImage.subviews){
                    if([i isKindOfClass:[UIView class]]){
                        //UILabel *newLbl = (UILabel *)i;
                        UIView *thisView = (UIView *)i;
                        if(thisView.tag == (currentIndex + 25)){
                            
                         //   NSLog(@"Compare this center: %@ with this center: %@", NSStringFromCGPoint(tmpImage.center), NSStringFromCGPoint(thisView.center));

                            
                            if (tmpImage.frame.size.width < 100 || thisView.frame.size.width < 98){
//                                thisView.frame = CGRectMake(thisView.frame.origin.x-translation.x/2.0, thisView.frame.origin.y-translation.x/2.0, thisView.frame.size.width+translation.x, thisView.frame.size.height+translation.x);//tmpImage.center;
                                thisView.frame = CGRectMake(thisView.frame.origin.x, thisView.frame.origin.y-translation.x/2.0, tmpImage.frame.size.width, tmpImage.frame.size.width);//tmpImage.center;
                                if (currentIndex > 0){
                                 //   thisView.center = CGPointMake(tmpImage.center.x + [self cummulativeSumOffsetAtIndex:((int)currentIndex -1) - [self offSetAtIndex:(int)currentIndex]], tmpImage.center.y+ 2.0);
                                   // thisView.center = CGPointMake(tmpImage.center.x, tmpImage.center.y+ 2.0);

                             //       thisView.center = CGPointMake(tmpImage.center.x + [self cummulativeSumOffsetAtIndex:((int)currentIndex -1)] + [self offSetAtIndex:(int)currentIndex], tmpImage.center.y+ 2.0);

                                } else {
                             //       thisView.center = CGPointMake(tmpImage.center.x, tmpImage.center.y+ 2.0);
                                }
                              //  thisView.center = lineAdjuster.center;
                                
                                NSLog(@"the index: %i", currentIndex);

                                
                                
                            } else {
                            
                                thisView.center = CGPointMake(thisView.center.x + translation.x/2.0, thisView.center.y);
                            
                            
                            
                            
                            }
                            //tmpImage.center;
                            /// Write your code
                        }
                    }
                }
                
                //UIView *thisView = [[UIView alloc]viewWithTag:currentIndex + 25];
                
                _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width + translation.x, _scrollView.bounds.size.height);
                    shrinkRatio = self.scrollView.bounds.size.width/self.scrollView.contentSize.width;// - 0.03;

                
                [self calculateIndex:currentIndex];
                
           //     CGFloat scrollVal = self.scrollView.contentOffset.x;
                
           //     self.scrollView.contentOffset = CGPointMake(scrollVal - translation.x,0);
                }

            } else if (fabs(myPoint.x) < 50 && fabs(myPoint.y) < 50){
                
              //  CGFloat moveValue = translation.x;
                
                invisiView.frame = CGRectMake(invisiView.frame.origin.x, invisiView.frame.origin.y, invisiView.frame.size.width - translation.x, invisiView.frame.size.height);
                lineAdjuster.frame = CGRectMake(lineAdjuster.frame.origin.x, lineAdjuster.frame.origin.y, lineAdjuster.frame.size.width - translation.x, lineAdjuster.frame.size.height);
                dot1.center = CGPointMake(0, 1.5);
                dot2.center = CGPointMake(lineAdjuster.frame.size.width, 1.5);
                CGPoint movePoint = CGPointMake(translation.x, 0);
                
                [recognizer incrementOrigin:&movePoint];
                
                tmpImage.frame = CGRectMake(tmpImage.frame.origin.x + translation.x/2.0, tmpImage.frame.origin.y, tmpImage.frame.size.width - translation.x, tmpImage.frame.size.height);
                
                
                for (UIView *i in tmpImage.subviews){
                    if([i isKindOfClass:[UIView class]]){
                        //UILabel *newLbl = (UILabel *)i;
                        UIView *thisView = (UIView *)i;
                        if(thisView.tag == (currentIndex + 25)){
                            
                            NSLog(@"Compare this center: %@ with this center: %@", NSStringFromCGPoint(tmpImage.center), NSStringFromCGPoint(thisView.center));
                            
                            if (tmpImage.frame.size.width < 100 || thisView.frame.size.width < 98){
                                //                                thisView.frame = CGRectMake(thisView.frame.origin.x-translation.x/2.0, thisView.frame.origin.y-translation.x/2.0, thisView.frame.size.width+translation.x, thisView.frame.size.height+translation.x);//tmpImage.center;
                                thisView.frame = CGRectMake(thisView.frame.origin.x, thisView.frame.origin.y+translation.x/2.0, tmpImage.frame.size.width, tmpImage.frame.size.width);//tmpImage.center;
                                if (currentIndex > 0){
                                    //   thisView.center = CGPointMake(tmpImage.center.x + [self cummulativeSumOffsetAtIndex:((int)currentIndex -1) - [self offSetAtIndex:(int)currentIndex]], tmpImage.center.y+ 2.0);
                                    NSLog(@"");
                                    // thisView.center = CGPointMake(tmpImage.center.x, tmpImage.center.y+ 2.0);
                                    
                                    //       thisView.center = CGPointMake(tmpImage.center.x + [self cummulativeSumOffsetAtIndex:((int)currentIndex -1)] + [self offSetAtIndex:(int)currentIndex], tmpImage.center.y+ 2.0);
                                    
                                } else {
                                    //       thisView.center = CGPointMake(tmpImage.center.x, tmpImage.center.y+ 2.0);
                                }
                                //  thisView.center = lineAdjuster.center;
                                
                                NSLog(@"the index: %i", currentIndex);
                                
                                
                                
                            } else {
                                
                                thisView.center = CGPointMake(thisView.center.x - translation.x/2.0, thisView.center.y);
                                
                                
                                
                                
                            }
                            //tmpImage.center;
                            /// Write your code
                        }
                    }
                }

                _scrollView.contentSize = CGSizeMake(_scrollView.contentSize.width - translation.x, _scrollView.bounds.size.height);
                shrinkRatio = self.scrollView.bounds.size.width/self.scrollView.contentSize.width;// - 0.03;


                [self calculateIndex:currentIndex];
                
            //    CGFloat scrollVal = self.scrollView.contentOffset.x;
                
            //    self.scrollView.contentOffset = CGPointMake(scrollVal - translation.x,0);

            }
            
         //   NSLog(@"YEAH BABY: %@", NSStringFromCGPoint(myPoint));
        }
            
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];

        
        /*
        if (fabs(myPoint.x - recognizerFrame.origin.x) < 25 && fabs(myPoint.y - recognizerFrame.origin.y) < 25){
            
            if (recognizerFrame.size.width <= 50 && recognizerFrame.size.height <= 50 && translation.x >= 0 && translation.y >= 0){
                
            } else {
                
                if ( (recognizerFrame.size.width-translation.x) > ( recognizerFrame.size.height-translation.y) ){
                    
                    recognizerFrame.size.width -= 2*translation.x;
                    recognizerFrame.size.height -= 2*translation.x;
                    recognizerFrame.origin.x += translation.x;
                    recognizerFrame.origin.y += translation.x;
                    CGPoint movePoint = CGPointMake(translation.x, translation.x);
                    [recognizer incrementOrigin:&movePoint];
                    
                    
                } else if ( (recognizerFrame.size.width-translation.x) < ( recognizerFrame.size.height-translation.y) ){
                    
                    recognizerFrame.size.width -= 2*translation.y;
                    recognizerFrame.size.height -= 2*translation.y;
                    recognizerFrame.origin.x += translation.y;
                    recognizerFrame.origin.y += translation.y;
                    CGPoint movePoint = CGPointMake(translation.y, translation.y);
                    [recognizer incrementOrigin:&movePoint];
                    
                } else {
                    
                    recognizerFrame.size.width -= 2*translation.x;
                    recognizerFrame.size.height -= 2*translation.y;
                    recognizerFrame.origin.x += translation.x;
                    recognizerFrame.origin.y += translation.y;
                    CGPoint movePoint = CGPointMake(translation.x, translation.y);
                    [recognizer incrementOrigin:&movePoint];
                }
                
            }

        } else {
            recognizerFrame.origin.x += translation.x;
            recognizerFrame.origin.y += translation.y;
            CGPoint movePoint = CGPointMake(translation.x, translation.y);
            [recognizer incrementOrigin:&movePoint];
        }
        
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];
         
         */
    }

}


- (void)tappedSidebar:(UITapGestureRecognizer *)recognizer  {
	UIView *hitView = [self hitTest:[recognizer locationInView:self] withEvent:nil];
	if (hitView == _scrollView) {
        
        
        //[delegate invalidateTimer];
        
        [delegate pauseGif:true];
        
        if (hasBeenAdjusted == NO && isSmall == YES){
            //     shrinkRatio = self.scrollView.bounds.size.width/self.scrollView.contentSize.width;
            //CGFloat expandRatio = 1.0/shrinkRatio;//self.scrollView.contentSize.width/self.scrollView.bounds.size.width;
            
            //CGFloat otherRatio = expandRatio - 1.0;
            //CGFloat topMargin = otherRatio*rowHeight;
            
            smallRatio = 1.0;
            
            oldRatio = 2.0 - shrinkRatio;
            
            [UIView animateWithDuration:0.02 animations:^{
                
                self.rowHeight = 100;
                
                self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x,0, self.scrollView.frame.size.width, rowHeight);
                
                self.tF.frame = CGRectMake(self.tF.frame.origin.x, 0, self.tF.frame.size.width,rowHeight);

                
          //      self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y - topMargin, self.scrollView.frame.size.width, expandRatio*self.scrollView.frame.size.height);
                
          //      self.tF.frame = CGRectMake(self.tF.frame.origin.x, self.tF.frame.origin.y - topMargin, self.tF.frame.size.width, expandRatio*self.tF.frame.size.height);
                
            } completion:^(BOOL finished){
                 [self reloadData];

                //self.rowHeight = 100;//self.rowHeight*expandRatio;
                
                //hasLoadedOnce = YES;
                self.scrollView.scrollEnabled = YES;

                isSmall = NO;
                
            }];
            
        }
        
		CGPoint hitPoint = [recognizer locationInView:_scrollView];
        
        CGFloat thisFloat = hitPoint.x;
        
        
        
        /*
        if (thisFloat > 0 && thisFloat <= (rowHeight + [self cummulativeSumOffsetAtIndex:0])){
            self.selectedIndex = 0;
        } else if (thisFloat > (rowHeight + [self cummulativeSumOffsetAtIndex:0]) && (thisFloat < (2*rowHeight + [self cummulativeSumOffsetAtIndex:1]))){
            self.selectedIndex = 1;
        } else if (thisFloat > (2*rowHeight + [self cummulativeSumOffsetAtIndex:1]) && (thisFloat < (3*rowHeight + [self cummulativeSumOffsetAtIndex:2]))){
            self.selectedIndex = 2;
        } else if (thisFloat > (3*rowHeight + [self cummulativeSumOffsetAtIndex:2]) && (thisFloat < (4*rowHeight + [self cummulativeSumOffsetAtIndex:3]))){
            self.selectedIndex = 3;
        } else if (thisFloat > (4*rowHeight + [self cummulativeSumOffsetAtIndex:3]) && (thisFloat < (5*rowHeight + [self cummulativeSumOffsetAtIndex:4]))){
            self.selectedIndex = 4;
        } else if (thisFloat > (5*rowHeight + [self cummulativeSumOffsetAtIndex:4]) && (thisFloat < (6*rowHeight + [self cummulativeSumOffsetAtIndex:5]))){
            self.selectedIndex = 5;
        } else if (thisFloat > (6*rowHeight + [self cummulativeSumOffsetAtIndex:5]) && (thisFloat < (7*rowHeight + [self cummulativeSumOffsetAtIndex:6]))){
            self.selectedIndex = 6;
        } else if (thisFloat > (7*rowHeight + [self cummulativeSumOffsetAtIndex:6]) && (thisFloat < (8*rowHeight + [self cummulativeSumOffsetAtIndex:7]))){
            self.selectedIndex = 7;
        } else if (thisFloat > (8*rowHeight + [self cummulativeSumOffsetAtIndex:7]) && (thisFloat < (9*rowHeight + [self cummulativeSumOffsetAtIndex:8]))){
            self.selectedIndex = 8;
        } else if (thisFloat > (9*rowHeight + [self cummulativeSumOffsetAtIndex:8]) && (thisFloat < (10*rowHeight + [self cummulativeSumOffsetAtIndex:9]))){
            self.selectedIndex = 9;
        }
        */
        
        CGFloat oldRowHeight = rowHeight;//rowHeight*oldRatio;
        NSLog(@"rattatat: %f", oldRowHeight);
        oldRatio = 1.0;
        //oldRatio = oldRatio;
        
        
        if (thisFloat > 0 && thisFloat <= (oldRowHeight + [self cummulativeSumOffsetAtIndex:0]*oldRatio)){
            self.selectedIndex = 0;
        } else if (thisFloat > (oldRowHeight + [self cummulativeSumOffsetAtIndex:0]*oldRatio) && (thisFloat < (2*oldRowHeight + [self cummulativeSumOffsetAtIndex:1]*oldRatio))){
            self.selectedIndex = 1;
        } else if (thisFloat > (2*oldRowHeight + [self cummulativeSumOffsetAtIndex:1]*oldRatio) && (thisFloat < (3*oldRowHeight + [self cummulativeSumOffsetAtIndex:2]*oldRatio))){
            self.selectedIndex = 2;
        } else if (thisFloat > (3*oldRowHeight + [self cummulativeSumOffsetAtIndex:2]*oldRatio) && (thisFloat < (4*oldRowHeight + [self cummulativeSumOffsetAtIndex:3]*oldRatio))){
            self.selectedIndex = 3;
        } else if (thisFloat > (4*oldRowHeight + [self cummulativeSumOffsetAtIndex:3]*oldRatio) && (thisFloat < (5*oldRowHeight + [self cummulativeSumOffsetAtIndex:4]*oldRatio))){
            self.selectedIndex = 4;
        } else if (thisFloat > (5*oldRowHeight + [self cummulativeSumOffsetAtIndex:4]*oldRatio) && (thisFloat < (6*oldRowHeight + [self cummulativeSumOffsetAtIndex:5]*oldRatio))){
            self.selectedIndex = 5;
        } else if (thisFloat > (6*oldRowHeight + [self cummulativeSumOffsetAtIndex:5]*oldRatio) && (thisFloat < (7*oldRowHeight + [self cummulativeSumOffsetAtIndex:6]*oldRatio))){
            self.selectedIndex = 6;
        } else if (thisFloat > (7*oldRowHeight + [self cummulativeSumOffsetAtIndex:6]*oldRatio) && (thisFloat < (8*oldRowHeight + [self cummulativeSumOffsetAtIndex:7]*oldRatio))){
            self.selectedIndex = 7;
        } else if (thisFloat > (8*oldRowHeight + [self cummulativeSumOffsetAtIndex:7]*oldRatio) && (thisFloat < (9*oldRowHeight + [self cummulativeSumOffsetAtIndex:8]*oldRatio))){
            self.selectedIndex = 8;
        } else if (thisFloat > (9*oldRowHeight + [self cummulativeSumOffsetAtIndex:8]*oldRatio) && (thisFloat < (10*oldRowHeight + [self cummulativeSumOffsetAtIndex:9]*oldRatio))){
            self.selectedIndex = 9;
        }

//        tmpImage =(UIImageView *)[imageViews objectAtIndex:self.selectedIndex];

        
        //NSLog(@"THIS HIT: %f", hitPoint.x);
        NSLog(@"THIS INDEX: %ld", (long)self.selectedIndex);
		//NSInteger newSelection = (hitPoint.x / rowHeight);
		
        NSInteger newSelection = self.selectedIndex;
        
		if (newSelection > self.imageCount - 1 || self.imageCount == 0) {
			self.selectedIndex = -1;
		}
		else {
		
			// Send the delegate method before changing selection state,
			// so that the user can determine whether the tap was on an
			// already-selected item by querying the selection state.
            currentIndex = (int)newSelection;
            NSLog(@"thisIndex: %i", currentIndex);
			if ([delegate respondsToSelector:@selector(sidebar:didTapImageAtIndex:)]) {
                
				[delegate sidebar:self didTapImageAtIndex:newSelection];
                
                
                UIImageView *tmpImage =(UIImageView *)[imageViews objectAtIndex:self.selectedIndex];
                
                
                
                if ( (tmpImage.frame.origin.x + tmpImage.frame.size.width) > [UIScreen mainScreen].bounds.size.width + self.scrollView.contentOffset.x){
                    
                    //        [scrollView setContentOffset:CGPointMake(0, 53) animated:YES];
                    
              //      [self.scrollView setContentOffset:CGPointMake((self.scrollView.contentOffset.x + 100 + [UIScreen mainScreen].bounds.size.width > self.scrollView.contentSize.width ? self.scrollView.contentSize.width-[UIScreen mainScreen].bounds.size.width + 30 : self.scrollView.contentOffset.x + 100 + [self cummulativeSumOffsetAtIndex:(int)currentIndex]) , 0) animated:YES];
                    
                   // [self.scrollView setContentOffset:CGPointMake(((self.selectedIndex == (imageViews.count - 1)) ? ((tmpImage.frame.origin.x + tmpImage.frame.size.width) - [UIScreen mainScreen].bounds.size.width) + 40: tmpImage.frame.origin.x - 15) , 0) animated:YES];
                    
                    [self.scrollView setContentOffset:CGPointMake(((tmpImage.frame.origin.x + tmpImage.frame.size.width) - [UIScreen mainScreen].bounds.size.width + 40), 0) animated:YES];
                    
                } else if ((tmpImage.frame.origin.x - self.scrollView.contentOffset.x) < 0){
                    
                //    [self.scrollView setContentOffset:CGPointMake(((self.selectedIndex == 0) ? 0 : self.scrollView.contentOffset.x - ([self offSetAtIndex:0])) , 0) animated:YES];
                    //UIImageView *tmpImage =(UIImageView *)[imageViews objectAtIndex:newSelection];

                    [self.scrollView setContentOffset:CGPointMake(((self.selectedIndex == 0) ? 0 : tmpImage.frame.origin.x - 15) , 0) animated:YES];

                    
                }
                myOffset = tmpImage.frame.origin.x;

              //  if (isSmall == NO){
                if (hasBeenAdjusted == NO){
                    canAdjust = NO;
                    //    lineAdjuster = [[UIView alloc] initWithFrame:CGRectMake(tmpImage.frame.origin.x - sidebar.scrollView.contentOffset.x + 7.5, [UIScreen mainScreen].bounds.size.height - 120, tmpImage.frame.size.width, 2)];
                    //selectedNum = (int)selectedIndex
                 
                    //lineAdjuster = [[UIView alloc] initWithFrame:CGRectMake(100*currentIndex + 7.5 - self.scrollView.contentOffset.x, 20, tmpImage.frame.size.width - 60, 4)];
                   // currentIndex = 0;
                   // UIImageView *tmpImage =(UIImageView *)[imageViews objectAtIndex:currentIndex];
                 
                    lineAdjuster = [[UIView alloc] initWithFrame:CGRectMake(rowHeight*currentIndex - self.scrollView.contentOffset.x, 20, rowHeight + [self offSetAtIndex:(int)selectedIndex], 4)];

                    lineAdjuster.frame = CGRectMake(myOffset - self.scrollView.contentOffset.x + oldRatio*rowHeight*currentIndex, -25, rowHeight + [self offSetAtIndex:currentIndex], 2);
                    
                   // lineAdjuster.center = CGPointMake(tmpImage.center.x, lineAdjuster.center.y);
                    
//                    imageViewCenterX = rowHeight * anIndex + (rowHeight / 2.0) + ([self offSetAtIndex:(int)anIndex])/2*smallRatio;

                    
              //      lineAdjuster.center = CGPointMake(rowHeight * currentIndex + (rowHeight/2 + [self offSetAtIndex:(int)currentIndex])/2*(1.0/oldRatio), lineAdjuster.center.y);
                
                    lineAdjuster.center = CGPointMake([self centerImageViewCenterInScrollViewForIndex:(int)currentIndex].x - self.scrollView.contentOffset.x, -25 );

                    
                    //rowHeight + [self offSetAtIndex:(int)selectedIndex]
                    
                    //lineAdjuster.center = CGPointMake(tmpImage.center.x, 20);
                    
                    invisiView = [[UIView alloc] initWithFrame:CGRectMake(-10, 0, lineAdjuster.frame.size.width+40, 50)];
                    invisiView.backgroundColor = [UIColor clearColor];
                    invisiView.layer.opacity = 0.5;
                    invisiView.center = lineAdjuster.center;
                    
                    lineAdjuster.backgroundColor = [UIColor whiteColor];
                    
                    //   [sidebar.scrollView addSubview:lineAdjuster];
                    
                    dot1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dot"]];
                    dot2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dot"]];
                    dot1.frame = CGRectMake(0, 0, 20, 20);
                    dot2.frame = CGRectMake(0, 0, 20, 20);
                    dot1.center = CGPointMake(0,1.5);
                    dot2.center = CGPointMake(lineAdjuster.frame.size.width, 1.5);
                    [lineAdjuster addSubview:dot1];
                    [lineAdjuster addSubview:dot2];
                    invisiView.center = lineAdjuster.center;

                    myPanner *panThat = [[myPanner alloc]initWithTarget:self action:@selector(resizePic:)];
                    [invisiView addGestureRecognizer:panThat];

                //    UIView *invisiView = [[UIView alloc]initWithFrame:<#(CGRect)#>];
                    hasBeenAdjusted = YES;
                    
                    //[self addSubview:lineAdjuster];
                    
                    lineAdjuster.layer.opacity = 0.0;
                    
                    [self insertSubview:lineAdjuster belowSubview:tmpImage];
                    
                    [self addSubview:invisiView];

                    
                    [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        
                 //       lineAdjuster.frame = CGRectMake(rowHeight*currentIndex - self.scrollView.contentOffset.x - ([self offSetAtIndex:(int)currentIndex])/2, -25, tmpImage.frame.size.width + [self offSetAtIndex:currentIndex], 2);
                      
                        
                        
                        //imageViewCenterX = rowHeight * anIndex + (rowHeight/2 + [self cummulativeSumOffsetAtIndex:(int)anIndex-1]*smallRatio) + ([self offSetAtIndex:(int)anIndex])/2*smallRatio;
                        
                        
                        
                        // + [self offSetAtIndex:(int)selectedIndex]/2;//[self cummulativeSumOffsetAtIndex:(int)anIndex];//+ tmpOffset;

                        
                        lineAdjuster.layer.opacity = 1.0;
                        
                    } completion:^(BOOL finished){
                        
                        canAdjust = YES;
                    }];
                    
                    //[thisView addSubview:lineView];
                } else {
                    
                    canAdjust = NO;
                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        
                      //  lineAdjuster.frame = CGRectMake(100*currentIndex - self.scrollView.contentOffset.x, -25, tmpImage.frame.size.width + 15, 2);
                      //  invisiView.center = lineAdjuster.center;
                        
                    //    lineAdjuster.frame = CGRectMake(myOffset - 7.5 - self.scrollView.contentOffset.x, -25, tmpImage.frame.size.width + 15+ [self offSetAtIndex:currentIndex], 2);
                        
                        lineAdjuster.frame = CGRectMake(myOffset - self.scrollView.contentOffset.x, -25, rowHeight + [self offSetAtIndex:currentIndex], 2);
                        lineAdjuster.center = CGPointMake([self centerImageViewCenterInScrollViewForIndex:(int)currentIndex].x - self.scrollView.contentOffset.x, -25 );


                       // lineAdjuster.frame = CGRectMake(myOffset - 7.5 - self.scrollView.contentOffset.x - ([self offSetAtIndex:(int)currentIndex])/2, -25, 100 + 15+ [self offSetAtIndex:currentIndex], 2);
                        invisiView.frame = CGRectMake(-10, 0, lineAdjuster.frame.size.width+20, 50);
                        invisiView.center = lineAdjuster.center;

                        dot1.center = CGPointMake(0, 1.5);
                        dot2.center = CGPointMake(lineAdjuster.frame.size.width, 1.5);

                        
                    } completion:^(BOOL finished){
                        
                        canAdjust = YES;
                    }];
                }
               // }
                
                
                /*
                 NSLog(@"this frame: %@", NSStringFromCGRect(((UIImageView *)[sidebar.imageViews objectAtIndex:anIndex]).frame));
                 
                 if (sidebar.selectedIndex == anIndex) {
                 NSLog(@"this frame: %@", NSStringFromCGRect(((UIImageView *)[sidebar.imageViews objectAtIndex:anIndex]).frame));
                 UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Delete image?"
                 delegate:self
                 cancelButtonTitle:@"Cancel"
                 destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
                 
                 self.actionSheetBlock = ^(NSUInteger selectedIndex) {
                 if (selectedIndex == sheet.destructiveButtonIndex) {
                 [sidebar deleteRowAtIndex:anIndex];
                 self.actionSheetBlock = nil;
                 }
                 };
                 
                 [sheet showFromRect:[sidebar frameOfImageAtIndex:anIndex]
                 inView:sidebar
                 animated:YES];
                 
                 }
                 */

                
			}
			
			if (newSelection != selectedIndex) {
				self.selectedIndex = newSelection;
			}
		}
    } else if (hitView == invisiView){
        NSLog(@"we dun as");
    } else {
        //NSLog(@"dammmmmmm");
        if (hasBeenAdjusted == YES){
            [self dismissAdjuster];
        }
            
    }
}

-(void)shrinkThis{
    
    shrinkRatio = self.scrollView.bounds.size.width/self.scrollView.contentSize.width;
    //CGFloat expandRatio = self.scrollView.contentSize.width/self.scrollView.bounds.size.width;
    smallRatio = shrinkRatio;
    CGFloat otherRatio = 1.0 - shrinkRatio;// - 1.0;
    CGFloat topMargin = otherRatio*rowHeight;
    
    //     CGFloat scrollValue =
    
    [UIView animateWithDuration:0.1 animations:^{
        
        
        self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y + topMargin, self.scrollView.frame.size.width, self.scrollView.frame.size.height - topMargin);
        
        self.tF.frame = CGRectMake(self.tF.frame.origin.x, self.tF.frame.origin.y + topMargin, self.tF.frame.size.width, self.tF.frame.size.height - topMargin);
        
    } completion:^(BOOL finished){
        
        self.rowHeight = self.rowHeight*shrinkRatio;
        
        [self reloadData];
        
        // [delegate restartTimer];
        
        //     [delegate pauseGif:false];
        
        //hasLoadedOnce = YES;
        isSmall = YES;
        //            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.scrollView.scrollEnabled = NO;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        
        
    }];

}

-(void)dismissAdjuster{
    
    if (isSmall == NO){
        
        shrinkRatio = self.scrollView.bounds.size.width/self.scrollView.contentSize.width;
        //CGFloat expandRatio = self.scrollView.contentSize.width/self.scrollView.bounds.size.width;
        smallRatio = shrinkRatio;
        CGFloat otherRatio = 1.0 - shrinkRatio;// - 1.0;
        CGFloat topMargin = otherRatio*rowHeight;
        
   //     CGFloat scrollValue =
        
        [UIView animateWithDuration:0.1 animations:^{
            
            
            self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x, self.scrollView.frame.origin.y + topMargin - 5, self.scrollView.frame.size.width, shrinkRatio*self.scrollView.frame.size.height + 5);
            
            self.tF.frame = CGRectMake(self.tF.frame.origin.x, self.tF.frame.origin.y + topMargin - 5, self.tF.frame.size.width, shrinkRatio*self.tF.frame.size.height + 5);
            
        } completion:^(BOOL finished){
            
            self.rowHeight = self.rowHeight*shrinkRatio;
            
            [self reloadData];
            
           // [delegate restartTimer];
            
       //     [delegate pauseGif:false];
            
            //hasLoadedOnce = YES;
            isSmall = YES;
//            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            self.scrollView.scrollEnabled = NO;
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];

            
        }];
        
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        lineAdjuster.layer.opacity = 0.0;
        //lineAdjuster.center = CGPointMake(lineAdjuster.center.x, lineAdjuster.center.y + 100);
    } completion:^(BOOL finished){
    
        [lineAdjuster removeFromSuperview];
        [invisiView removeFromSuperview];
        hasBeenAdjusted = NO;
    }];
}

- (void)pressedSidebar:(UILongPressGestureRecognizer *)recognizer {
    
  //  NSLog(@"THE OFFSET: %f", myOffset);
    
    if (isSmall == YES){
        
    } else {
    
	CGPoint hitPoint = [recognizer locationInView:_scrollView];
	BOOL isInScrollView = CGRectContainsPoint([_scrollView bounds], hitPoint);
	NSInteger newIndex = (isHorizontal ? hitPoint.x : hitPoint.y) / rowHeight;
	
    CGFloat thisFloat = hitPoint.x;
    
     

    if (thisFloat > 0 && thisFloat <= (rowHeight + [self cummulativeSumOffsetAtIndex:0])){
        newIndex = 0;
    } else if (thisFloat > (rowHeight + [self cummulativeSumOffsetAtIndex:0]) && (thisFloat < (2*rowHeight + [self cummulativeSumOffsetAtIndex:1]))){
        newIndex = 1;
    } else if (thisFloat > (2*rowHeight + [self cummulativeSumOffsetAtIndex:1]) && (thisFloat < (3*rowHeight + [self cummulativeSumOffsetAtIndex:2]))){
        newIndex = 2;
    } else if (thisFloat > (3*rowHeight + [self cummulativeSumOffsetAtIndex:2]) && (thisFloat < (4*rowHeight + [self cummulativeSumOffsetAtIndex:3]))){
        newIndex = 3;
    } else if (thisFloat > (4*rowHeight + [self cummulativeSumOffsetAtIndex:3]) && (thisFloat < (5*rowHeight + [self cummulativeSumOffsetAtIndex:4]))){
        newIndex = 4;
    } else if (thisFloat > (5*rowHeight + [self cummulativeSumOffsetAtIndex:4]) && (thisFloat < (6*rowHeight + [self cummulativeSumOffsetAtIndex:5]))){
        newIndex = 5;
    } else if (thisFloat > (6*rowHeight + [self cummulativeSumOffsetAtIndex:5]) && (thisFloat < (7*rowHeight + [self cummulativeSumOffsetAtIndex:6]))){
        newIndex = 6;
    } else if (thisFloat > (7*rowHeight + [self cummulativeSumOffsetAtIndex:6]) && (thisFloat < (8*rowHeight + [self cummulativeSumOffsetAtIndex:7]))){
        newIndex = 7;
    } else if (thisFloat > (8*rowHeight + [self cummulativeSumOffsetAtIndex:7]) && (thisFloat < (9*rowHeight + [self cummulativeSumOffsetAtIndex:8]))){
        newIndex = 8;
    } else if (thisFloat > (9*rowHeight + [self cummulativeSumOffsetAtIndex:8]) && (thisFloat < (10*rowHeight + [self cummulativeSumOffsetAtIndex:9]))){
        newIndex = 9;
    }
    
    if (newIndex > self.imageViews.count - 1) {
        newIndex = self.imageViews.count - 1;
    }
    else if (newIndex < 0) {
        newIndex = 0;
    }
    
	if (isInScrollView == NO) {
		newIndex = self.draggedViewOldIndex;
	}
    
  //  [UIView animateWithDuration:0.2 animations:^{
   //     lineAdjuster.frame = CGRectMake(rowHeight*newIndex - self.scrollView.contentOffset.x, -25, lineAdjuster.frame.size.width, 2);
  //      invisiView.center = lineAdjuster.center;
        
//    }];recognizer.state == UIGestureRecognizerStateEnded
    
    NSLog(@"OLD INDEX MUTHAFUKA: %li", self.draggedViewOldIndex);

    NSLog(@"NEW INDEX MUTHAFUKA: %li", newIndex);
	
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		UIImageView *hitView = [self.imageViews objectAtIndex:newIndex];
		self.selectedIndex = -1;
		[UIView animateWithDuration:0.1
						 animations:^{
							 hitView.alpha = 0.5;
							 hitView.transform = CGAffineTransformMakeScale(1.1, 1.1);
						 }
		 ];
		self.viewBeingDragged = hitView;
		self.draggedViewOldIndex = newIndex;
		self.dragOffset = CGPointMake(hitPoint.x - hitView.center.x, hitPoint.y - hitView.center.y);
		[_scrollView bringSubviewToFront:viewBeingDragged];
	}
	else if (recognizer.state == UIGestureRecognizerStateChanged) {
		viewBeingDragged.center = CGPointMake(hitPoint.x - self.dragOffset.x, hitPoint.y - self.dragOffset.y);
		if (isInScrollView == NO) {
			// Don't scroll if we're not over the scrollview
			[dragScrollTimer invalidate];
			self.dragScrollTimer = nil;
            if (self.draggedViewOldIndex == currentIndex){
          //      currentIndex = (currentIndex-1 < 0 ? currentIndex + 1 : currentIndex - 1);
          //      myOffset = 100*currentIndex + 7.5;
                [UIView animateWithDuration:0.2 animations:^{
                    lineAdjuster.frame = CGRectMake(lineAdjuster.frame.origin.x, lineAdjuster.frame.origin.y+100, lineAdjuster.frame.size.width, 2);
                } completion:^(BOOL finished){
                    
                    [lineAdjuster removeFromSuperview];
                    [invisiView removeFromSuperview];
                    hasBeenAdjusted = NO;
                    
                }];
            }
			[imageViews removeObject:viewBeingDragged];
			[self setNeedsLayout];
		}
		else {
          //  if (recognizer.state == UIGestureRecognizerStateEnded){
			[imageViews removeObject:viewBeingDragged];
            
            if([imageViews count] > 0){
                if (newIndex <= (imageViews.count-1)){
                [imageViews insertObject:viewBeingDragged atIndex:newIndex];
                if (self.draggedViewOldIndex == currentIndex){
                    currentIndex = (int)newIndex;
                    myOffset = rowHeight*currentIndex;
                    [UIView animateWithDuration:0.2 animations:^{
                        lineAdjuster.frame = CGRectMake(myOffset - self.scrollView.contentOffset.x, -25, lineAdjuster.frame.size.width, 2);
                        invisiView.center = lineAdjuster.center;
                        
                    }];
                }
                }
            } else {
                [imageViews insertObject:viewBeingDragged atIndex:0];
                if (self.draggedViewOldIndex == currentIndex){
                    currentIndex = 0;
                    myOffset = 0;//7.5;
                    [UIView animateWithDuration:0.2 animations:^{
                        lineAdjuster.frame = CGRectMake(myOffset - self.scrollView.contentOffset.x, -25, lineAdjuster.frame.size.width, 2);
                        invisiView.center = lineAdjuster.center;

                    }];
                }
            }
            //}
			[self setNeedsLayout];
			
			if ((isHorizontal && CGRectGetMaxX(_scrollView.bounds) - hitPoint.x < 50) ||
				(!isHorizontal && CGRectGetMaxY(_scrollView.bounds) - hitPoint.y < 50)) {
				if (dragScrollTimer == nil) {
					self.dragScrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
																			target:self
																		  selector:@selector(scrollDown:)
																		  userInfo:nil
																		   repeats:YES];
				}
			}
			else if ((isHorizontal && hitPoint.x - CGRectGetMinX(_scrollView.bounds) < 50) ||
					 (!isHorizontal && hitPoint.y - CGRectGetMinY(_scrollView.bounds) < 50)) {
				if (dragScrollTimer == nil) {
					self.dragScrollTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
																			target:self
																		  selector:@selector(scrollUp:)
																		  userInfo:nil
																		   repeats:YES];
				}
			}
			else {
				[dragScrollTimer invalidate];
				self.dragScrollTimer = nil;
			}
            }
		
	}
	else {
		// Stop scrolling, if we were
		[self.dragScrollTimer invalidate];
		self.dragScrollTimer = nil;
		
		CGRect safeZone = CGRectInset(_scrollView.bounds, -30, -30);
		
		if (isInScrollView || CGRectContainsPoint(safeZone, hitPoint)) {
			CGPoint finalPosition = [self imageViewCenterInScrollViewForIndex:newIndex];
			[UIView animateWithDuration:0.2
							 animations:^{
								 viewBeingDragged.center = finalPosition;
								 viewBeingDragged.alpha = 1.0;
								 viewBeingDragged.transform = CGAffineTransformIdentity;
							 }
							 completion:^(BOOL finished){
								 self.selectedIndex = newIndex;
								 [self setNeedsLayout];
							 }];
			[imageViews removeObject:viewBeingDragged];
			[imageViews insertObject:viewBeingDragged atIndex:newIndex];
      //      NSLog(@"log it asshole: old = %f and new = %f", [self offSetAtIndex:(int)self.draggedViewOldIndex], [self offSetAtIndex:(int)newIndex]);
            
            CGFloat offset1 = [self offSetAtIndex:(int)self.draggedViewOldIndex];
            
            [self setOffSetAtIndex:(int)self.draggedViewOldIndex withVal:[self offSetAtIndex:(int)newIndex]];
            [self setOffSetAtIndex:(int)newIndex withVal:offset1];
            
        //    NSLog(@"log it asshole: old = %f and new = %f", [self offSetAtIndex:(int)self.draggedViewOldIndex], [self offSetAtIndex:(int)newIndex]);
            currentIndex = (int)newIndex;
            UIImageView *tmpImage =(UIImageView *)[imageViews objectAtIndex:currentIndex];
            lineAdjuster.frame = CGRectMake(lineAdjuster.frame.origin.x, lineAdjuster.frame.origin.y, tmpImage.frame.size.width, lineAdjuster.frame.size.height);
            lineAdjuster.center = CGPointMake([self centerImageViewCenterInScrollViewForIndex:(int)currentIndex].x - self.scrollView.contentOffset.x, -25 );
            dot2.center = CGPointMake(lineAdjuster.frame.size.width, 1.5);
            invisiView.frame = CGRectMake(-10, 0, lineAdjuster.frame.size.width+20, 50);
            invisiView.center = lineAdjuster.center;
            
            UIView *newView = (UIView *)[self viewWithTag:(currentIndex+25)];
            UIView *oldView = (UIView *)[self viewWithTag:(self.draggedViewOldIndex + 25)];
            
            newView.tag = self.draggedViewOldIndex + 25;
            oldView.tag = currentIndex+25;
            
            [delegate swapIndex1:(int)currentIndex withIndex2:(int)self.draggedViewOldIndex];
            
            /*
            for (UIView *i in tmpImage.subviews){
                if([i isKindOfClass:[UIView class]]){
                    //UILabel *newLbl = (UILabel *)i;
                    UIView *thisView = (UIView *)i;
                    if(thisView.tag == (currentIndex + 25)){
                        NSLog(@"old tag1: %li", (long)thisView.tag);
                        thisView.tag = (self.draggedViewOldIndex + 25);
                        NSLog(@"new tag1: %li", (long)thisView.tag);
                    }
                }
            }
            
            UIImageView *oldImage =(UIImageView *)[imageViews objectAtIndex:self.draggedViewOldIndex];
            
            for (UIView *i in oldImage.subviews){
                if([i isKindOfClass:[UIView class]]){
                    //UILabel *newLbl = (UILabel *)i;
                    UIView *thisView = (UIView *)i;
                    if(thisView.tag == (self.draggedViewOldIndex + 25)){
                        NSLog(@"old tag2: %li", (long)thisView.tag);
                        thisView.tag = (currentIndex + 25);
                        NSLog(@"new tag2: %li", (long)thisView.tag);
                    }
                }
            }
            */
			if (draggedViewOldIndex != newIndex && [delegate respondsToSelector:@selector(sidebar:didMoveImageAtIndex:toIndex:)]) {
				[delegate sidebar:self didMoveImageAtIndex:draggedViewOldIndex toIndex:newIndex];
			}
		}
		else {
			[UIView animateWithDuration:0.2
								  delay:0
								options:UIViewAnimationCurveEaseOut
							 animations:^{
								 viewBeingDragged.transform = CGAffineTransformMakeScale(0.8, 0.8);
								 viewBeingDragged.alpha = 0.0;
							 }
							 completion:^(BOOL finished) {
								 self.selectedIndex = -1;
								 [UIView animateWithDuration:0.2 animations:^{
									 [self recalculateScrollViewContentSize];
								 }];
								 [self setNeedsLayout];
							 }];
			[imageViews removeObject:viewBeingDragged];
			
			if ([delegate respondsToSelector:@selector(sidebar:didRemoveImageAtIndex:)]) {
				[delegate sidebar:self didRemoveImageAtIndex:self.draggedViewOldIndex];
//                [self readjustAfterRemovingOffsetAtIndex:(int)self.draggedViewOldIndex];
			}
		}
		
		self.draggedViewOldIndex = -1;
		self.dragOffset = CGPointZero;
		self.viewBeingDragged = nil;
	}
    }
}

- (void)scrollWithDelta:(CGFloat)scrollDelta duration:(NSTimeInterval)duration {
	
	if (scrollDelta > 0) {
		// Scrolling down; make sure we don't go beyond the end.
		CGFloat contentBottom = _scrollView.contentSize.height;
		CGFloat scrollBottom = CGRectGetMaxY(_scrollView.bounds);
		
		if (isHorizontal) {
			contentBottom = _scrollView.contentSize.width;
			scrollBottom = CGRectGetMaxX(_scrollView.bounds);
		}
		
		CGFloat availableContentSpace = contentBottom - scrollBottom;
		if (availableContentSpace <= 0) {
			scrollDelta = 0;
		}
		else if (availableContentSpace < scrollDelta) {
			scrollDelta = availableContentSpace;
		}
	}
	else {
		// Scrolling up; make sure we don't go beyond the top.
		CGFloat contentTop = _scrollView.contentOffset.y;
		if (isHorizontal) {
			contentTop = _scrollView.contentOffset.x;
		}
		
		if (contentTop < (-1 * scrollDelta)) {
			scrollDelta = -1 * contentTop;
		}
	}
	
	
	if (scrollDelta != 0) {
		CGPoint currentContentOffset = _scrollView.contentOffset;
		CGPoint newOffset = CGPointMake(0, currentContentOffset.y + scrollDelta);
		CGPoint newViewCenter = CGPointMake(viewBeingDragged.center.x, viewBeingDragged.center.y + scrollDelta);
		
		if (isHorizontal) {
			newOffset = CGPointMake(currentContentOffset.x + scrollDelta, 0);
			newViewCenter = CGPointMake(viewBeingDragged.center.x + scrollDelta, viewBeingDragged.center.y);
		}
		
		[UIView animateWithDuration:duration
							  delay:0
							options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveLinear
						 animations:^(void) {
							 CGRect newBounds = {.origin = newOffset, .size = _scrollView.bounds.size};
							 _scrollView.bounds = newBounds;
							 viewBeingDragged.center = newViewCenter;
						 }
						 completion:^(BOOL finished) {
							 NSUInteger newRow = (isHorizontal ? newViewCenter.x : newViewCenter.y) / rowHeight; 
							 [imageViews removeObject:viewBeingDragged];
							 [imageViews insertObject:viewBeingDragged atIndex:newRow];
							 [self setNeedsLayout];
						 }];
	}

}

- (void)scrollDown:(NSTimer *)timer {
	[self scrollWithDelta:30 duration:[timer timeInterval]];
}

- (void)scrollUp:(NSTimer *)timer {
	[self scrollWithDelta:-30 duration:[timer timeInterval]];
}

#pragma mark -
#pragma mark Accessors

- (NSInteger)selectedIndex {
	return selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)newIndex {
	selectedIndex = newIndex;
	[self setNeedsLayout];
}

- (CGFloat)rowHeight {
	return rowHeight;
}

- (void)setRowHeight:(CGFloat)newHeight {
	rowHeight = newHeight;
	[self setNeedsLayout];
}

- (NSUInteger)imageCount {
	return [imageViews count];
}


- (void)enqueueReusableImageView:(UIImageView *)view {
	[viewsForReuse addObject:view];
	
	view.image = nil;
	[view removeFromSuperview];
}

- (UIImageView *)dequeueReusableImageView {
	UIImageView *view = [viewsForReuse lastObject];
	if (view != nil) {
		[viewsForReuse removeLastObject];
	}
	return view;	
}

- (CGRect)frameOfImageAtIndex:(NSUInteger)anIndex {
	CGRect rectInScrollView = [self imageViewFrameInScrollViewForIndex:anIndex];
	return [self convertRect:rectInScrollView fromView:_scrollView];
}

- (CGRect)imageViewFrameInScrollViewForIndex:(NSUInteger)anIndex {
	if (isHorizontal == NO) {
		CGFloat rowWidth = _scrollView.bounds.size.width;
		CGFloat imageViewWidth =  rowWidth * 9.0 / 10.0;
		CGFloat imageViewHeight = rowHeight * 9.0 / 10.0;
		
		CGFloat imageOriginX = (rowWidth - imageViewWidth) / 2.0;
		CGFloat imageOriginY = (rowHeight - imageViewHeight) / 2.0;
			
		return CGRectMake(imageOriginX, rowHeight*anIndex + imageOriginY, imageViewWidth, imageViewHeight);
	}
	else {
        
        //NSLog(@"here at least bag");
        //THIS LINE IS MUY IMPORTANTE
		CGFloat scrollerHeight = _scrollView.bounds.size.height;
        CGFloat imageViewHeight = rowHeight;// * 8.5 / 10.0;
        CGFloat imageViewWidth = rowHeight + [self offSetAtIndex:(int)anIndex]*smallRatio;// * 8.5 / 10.0;

		CGFloat imageOriginX = (rowHeight - imageViewWidth) / 2.0;
		CGFloat imageOriginY = (scrollerHeight - imageViewHeight) / 2.0;
		

        return CGRectMake(rowHeight*anIndex + imageOriginX, imageOriginY, imageViewWidth, imageViewHeight);
        
	}
}

- (CGPoint)centerImageViewCenterInScrollViewForIndex:(NSUInteger)anIndex {
    CGFloat imageViewCenterX = 0;
    CGFloat imageViewCenterY = 0;
    if (isHorizontal == NO) {
        imageViewCenterX = CGRectGetMidX(_scrollView.bounds);
        imageViewCenterY = rowHeight * anIndex + (rowHeight / 2.0);
    }
    else {
        if (anIndex > 0){
            //tmpImage.frame.size.width + 15+ [self offSetAtIndex:currentIndex]
            
            imageViewCenterX = rowHeight * anIndex + (rowHeight/2 + [self cummulativeSumOffsetAtIndex:(int)anIndex-1]*smallRatio) + ([self offSetAtIndex:(int)anIndex])/2*smallRatio;// + [self offSetAtIndex:(int)selectedIndex]/2;//[self cummulativeSumOffsetAtIndex:(int)anIndex];//+ tmpOffset;
        } else {
            imageViewCenterX = rowHeight * anIndex + (rowHeight / 2.0) + ([self offSetAtIndex:(int)anIndex])/2*smallRatio;
        }
        imageViewCenterY = CGRectGetMidY(_scrollView.bounds);
        //  } else {
        //     imageViewCenterX = rowHeight * anIndex + (rowHeight / 2.0);
        //     imageViewCenterY = CGRectGetMidY(_scrollView.bounds);
        // }
    }
    return CGPointMake(imageViewCenterX, imageViewCenterY);
}

- (CGPoint)specialImageViewCenterInScrollViewForIndex:(NSUInteger)anIndex {
    CGFloat imageViewCenterX = 0;
    CGFloat imageViewCenterY = 0;
    if (isHorizontal == NO) {
        imageViewCenterX = CGRectGetMidX(_scrollView.bounds);
        imageViewCenterY = rowHeight * anIndex + (rowHeight / 2.0);
    }
    else {
        /*
        if (anIndex > 0){
            imageViewCenterX = rowHeight * anIndex + (rowHeight/2 - [self cummulativeSumOffsetAtIndex:(int)anIndex-1]);//[self cummulativeSumOffsetAtIndex:(int)anIndex];//+ tmpOffset;
        } else {
            imageViewCenterX = rowHeight * anIndex + (rowHeight / 2.0) - [self cummulativeSumOffsetAtIndex:(int)anIndex]/2;
        }
         */
        if (anIndex > 0){
            imageViewCenterX = rowHeight * anIndex + (rowHeight / 2.0) - [self offSetAtIndex:(int)anIndex]/2 + [self cummulativeSumOffsetAtIndex:(int)anIndex-1];
        } else {
            imageViewCenterX = rowHeight * anIndex + (rowHeight / 2.0) - [self offSetAtIndex:(int)anIndex]/2;
        }
            
        imageViewCenterY = CGRectGetMidY(_scrollView.bounds);
        //  } else {
        //     imageViewCenterX = rowHeight * anIndex + (rowHeight / 2.0);
        //     imageViewCenterY = CGRectGetMidY(_scrollView.bounds);
        // }
    }
    return CGPointMake(imageViewCenterX, imageViewCenterY);
}

- (CGPoint)imageViewCenterInScrollViewForIndex:(NSUInteger)anIndex {
	CGFloat imageViewCenterX = 0;
	CGFloat imageViewCenterY = 0;
	if (isHorizontal == NO) {
		imageViewCenterX = CGRectGetMidX(_scrollView.bounds);
		imageViewCenterY = rowHeight * anIndex + (rowHeight / 2.0);
	}
	else {
        if (anIndex > 0){
            imageViewCenterX = rowHeight * anIndex + (rowHeight/2 + [self cummulativeSumOffsetAtIndex:(int)anIndex-1]);// + [self offSetAtIndex:(int)selectedIndex]/2;//[self cummulativeSumOffsetAtIndex:(int)anIndex];//+ tmpOffset;
        } else {
            imageViewCenterX = rowHeight * anIndex + (rowHeight / 2.0);
        }
		imageViewCenterY = CGRectGetMidY(_scrollView.bounds);
      //  } else {
       //     imageViewCenterX = rowHeight * anIndex + (rowHeight / 2.0);
       //     imageViewCenterY = CGRectGetMidY(_scrollView.bounds);
       // }
	}
	return CGPointMake(imageViewCenterX, imageViewCenterY);
}

/*
- (CGPoint)imageViewCenterInScrollViewForIndex:(NSUInteger)anIndex {
    CGFloat imageViewCenterX = 0;
    CGFloat imageViewCenterY = 0;
    if (isHorizontal == NO) {
        imageViewCenterX = CGRectGetMidX(_scrollView.bounds);
        imageViewCenterY = rowHeight * anIndex + (rowHeight / 2.0);
    }
    else {
        imageViewCenterX = rowHeight * anIndex + (rowHeight / 2.0) + [self offSetAtIndex:anIndex];
        imageViewCenterY = CGRectGetMidY(_scrollView.bounds);
    }
    return CGPointMake(imageViewCenterX, imageViewCenterY);
}
 */

- (BOOL)imageAtIndexIsVisible:(NSUInteger)anIndex {
	CGRect imageRect = [self imageViewFrameInScrollViewForIndex:anIndex];
	return CGRectIntersectsRect([_scrollView bounds], imageRect);
}

- (NSIndexSet *)visibleIndices {
	NSInteger firstRow = 0;
	NSInteger lastRow = 0;
	if (isHorizontal == NO) {
		firstRow = _scrollView.contentOffset.y / rowHeight;
		lastRow = (CGRectGetMaxY(_scrollView.bounds)) / rowHeight;
	}
	else {
		firstRow = _scrollView.contentOffset.x / rowHeight;
		lastRow = (CGRectGetMaxX(_scrollView.bounds)) / rowHeight;
	}
	NSInteger imageCount = self.imageCount;
	if (lastRow > imageCount - 1 || imageCount == 0) {
		lastRow = imageCount - 1;
	}
	if (firstRow < 0) {
		firstRow = 0;
	}
	
	return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(firstRow, lastRow - firstRow + 1)];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self setNeedsLayout];
    //lineAdjuster.frame = CGRectMake(100*currentIndex - self.scrollView.contentOffset.x + [self cummulativeSumOffsetAtIndex:(int)currentIndex], -25, lineAdjuster.frame.size.width, 2);
    lineAdjuster.center = CGPointMake([self centerImageViewCenterInScrollViewForIndex:(int)currentIndex].x - self.scrollView.contentOffset.x, -25 );
    invisiView.center = lineAdjuster.center;

}

@end
