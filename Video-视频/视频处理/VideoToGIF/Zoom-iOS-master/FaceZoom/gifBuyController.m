//
//  gifBuyController.m
//  Zoom
//
//  Created by Ben Taylor on 6/15/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "gifBuyController.h"
#import "HSImageSidebarView.h"


@implementation gifBuyController
@synthesize delegate;
@synthesize sidebarx;
@synthesize images;
@synthesize actionSheetBlock;
@synthesize offsets;
@synthesize mainImageView;
@synthesize gifTimer;
@synthesize playButton;
@synthesize playImage;
@synthesize pauseImage;
@synthesize plusThing;
@synthesize minusThing;
//@synthesize lineAdjuster;

float scaleFactor4 = 1;
int thisIndex = 0;
int playint = 0;
//bool hasBeenAdjusted = NO;
//bool canAdjust = NO;



-(void)viewDidLoad{
    
    if ([UIScreen mainScreen].nativeBounds.size.height == 960){
        scaleFactor4 = 960.0/1334.0;
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 1136){
        scaleFactor4 = 1136.0/1334.0;
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 1334){
        scaleFactor4 = 1.0;
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 2208){
        scaleFactor4 = 401.0/326.0*333.5/368.0;
    }
    self.view.clipsToBounds = YES;

    playImage = [UIImage imageNamed:@"playgif"];
    pauseImage = [UIImage imageNamed:@"pausegif"];
    playImage = [playImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    pauseImage = [pauseImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [backgroundView setImage:[UIImage imageNamed:@"gifMakeBackground"]];
    [self.view addSubview:backgroundView];
    
    UIVisualEffectView *thisEffect = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    thisEffect.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:thisEffect];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background2"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"AvenirNext-Bold" size:20.0],
      UITextAttributeFont,
      nil]];

    
    self.title = @"GIF Maker";

    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"hasPurchased"]  isEqual: @"NO"]){
    
        
        
        UILabel *gifLabel2 = [[UILabel alloc]initWithFrame:CGRectZero];
    
        [gifLabel2 setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:(14.5f*scaleFactor4)]];
        gifLabel2.textColor = [UIColor whiteColor];
        gifLabel2.textAlignment = NSTextAlignmentCenter;
    
        gifLabel2.text = @"Customize every aspect of your gif, from zoom\nlevels and text placement to the number of\nimages and the time between them.";
        gifLabel2.numberOfLines = 3;
        
        gifLabel2.frame = CGRectMake(20, 40, [UIScreen mainScreen].bounds.size.width,300);
    
        gifLabel2.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 115*scaleFactor4);

        [self.view addSubview:gifLabel2];
    
        UIImageView *phoneView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.width)];
        phoneView.image = [UIImage imageNamed:@"iphone"];
    
        phoneView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, gifLabel2.center.y + 45*scaleFactor4 + [UIScreen mainScreen].bounds.size.width/2);
    
        [self.view addSubview:phoneView];
        
        UIButton *buyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*5/16 )];
        
        [buyButton setImage:[UIImage imageNamed:@"buybutton"] forState:UIControlStateNormal];
        
        [buyButton addTarget:self action:@selector(buyMaker) forControlEvents:UIControlEventTouchUpInside];
        
        buyButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 ,([UIScreen mainScreen].bounds.size.height - phoneView.center.y-phoneView.frame.size.height/2)/2 + phoneView.center.y+phoneView.frame.size.height/2 - 10);
        
        [self.view addSubview:buyButton];
    
    } else {
        
        sidebarx = [[HSImageSidebarView alloc] initWithFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height - 100, [UIScreen mainScreen].bounds.size.width-30, 100)];
        
        sidebarx.delegate = self;

        /*
        UIVisualEffectView *tF = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        tF.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100, [UIScreen mainScreen].bounds.size.width, 100);
        [self.view addSubview:tF];
        
         */
        //sidebarx.imageOffsets = [[NSMutableArray alloc]initWithArray:offsets];//[NSMutableArray arrayWithArray:offsets];
        
        [self.view addSubview:sidebarx];
        
        mainImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-80, [UIScreen mainScreen].bounds.size.width-80)];
        
        mainImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 250);
        
        mainImageView.image = [images objectAtIndex:0];
        
        mainImageView.layer.cornerRadius = 20.0;
        
        mainImageView.clipsToBounds = YES;
        
        [self.view insertSubview:mainImageView belowSubview:sidebarx];
        
        
        playButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        CGFloat yVal = ([UIScreen mainScreen].bounds.size.height - 100 - (mainImageView.frame.origin.y + mainImageView.frame.size.height))/2.0 + mainImageView.frame.origin.y + mainImageView.frame.size.height;
        playButton.center = CGPointMake(mainImageView.center.x, yVal);
        [playButton setImage:pauseImage forState:UIControlStateNormal];
        playButton.adjustsImageWhenHighlighted = NO;
        playButton.adjustsImageWhenDisabled = NO;
        playButton.tintColor = [UIColor whiteColor];

        plusThing = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        plusThing.center = CGPointMake(playButton.center.x + 90, playButton.center.y);
        [plusThing setImage:[UIImage imageNamed:@"plus_cam"] forState:UIControlStateNormal];
        plusThing.adjustsImageWhenHighlighted = NO;
        plusThing.adjustsImageWhenDisabled = NO;
        plusThing.tintColor = [UIColor whiteColor];
        [plusThing addTarget:self action:@selector(plusTime) forControlEvents:UIControlEventTouchUpInside];

        minusThing = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
        minusThing.center = CGPointMake(playButton.center.x - 90, playButton.center.y);
        [minusThing setImage:[UIImage imageNamed:@"minus_cam"] forState:UIControlStateNormal];
        minusThing.adjustsImageWhenHighlighted = NO;
        minusThing.adjustsImageWhenDisabled = NO;
        minusThing.tintColor = [UIColor whiteColor];
        [minusThing addTarget:self action:@selector(minusTime) forControlEvents:UIControlEventTouchUpInside];
        
      //  plusThing.hidden = YES;
      //  minusThing.hidden = YES;
        
        [self.view insertSubview:plusThing belowSubview:sidebarx];
        
        [self.view insertSubview:minusThing belowSubview:sidebarx];
        
        [playButton addTarget:self action:@selector(pausedGif) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view insertSubview:playButton belowSubview:sidebarx];
        
        
        
        gifTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                    target:self
                                                  selector:@selector(frame2)
                                                  userInfo:nil
                                                   repeats:NO];
        
        UITapGestureRecognizer *thisTapper = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(myFunct:)];
        
        [self.view addGestureRecognizer:thisTapper];
    //    [self makeGifShow];
        
     //   NSLog(@"FULL SIZE: %lu", (unsigned long)self.sidebarx.imageViews.count);
    }
}

-(void)minusTime{
    [sidebarx decreaseTime];
}

-(void)plusTime{
  //  NSLog(@"deety od");
    [sidebarx increaseTime];
    //[sidebarx shrinkThis];
}

-(void)myFunct:(UITapGestureRecognizer *)tapper{
 //   CGPoint hitPoint = [tapper locationInView:self.view];
    
    UIView *hitView = [self.sidebarx hitTest:[tapper locationInView:self.view] withEvent:nil];

    
    if (hitView == sidebarx) {
    } else {
    //    NSLog(@"dam yo boy");
        [self.sidebarx dismissAdjuster];
    }
    
    

}

-(void)pausedGif{
    if ([gifTimer isValid]){
        if (self.sidebarx.isSmall){
            
        }
        [gifTimer invalidate];
        [playButton setImage:playImage forState:UIControlStateNormal];
        //playint = 1;
    } else {
        if (!self.sidebarx.isSmall){
            [self.sidebarx dismissAdjuster];
        }
        // playint = 0;
        [playButton setImage:pauseImage forState:UIControlStateNormal];
        [self frame2];
    }
}

-(void)pauseGif:(BOOL)isDelegated{
    if (isDelegated){
        [gifTimer invalidate];
        [playButton setImage:playImage forState:UIControlStateNormal];
        //playint = 1;
    } else {
       // playint = 0;
        [playButton setImage:pauseImage forState:UIControlStateNormal];
        [self frame2];
    }
}

-(void)restartTimer{
    thisIndex = 0;
    gifTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                target:self
                                              selector:@selector(frame2)
                                              userInfo:nil
                                               repeats:NO];
}

-(void)frame2{
    
    self.mainImageView.image = [images objectAtIndex:thisIndex];
    
 //   self.mainImageView.image = ((UIImageView *)[sidebarx.imageViews objectAtIndex:thisIndex]).image;
    
    //CGFloat duration = ((UIImageView *)[sidebarx.imageViews objectAtIndex:thisIndex]).frame.size.width/sidebarx.scrollView.contentSize.width;
    
    CGFloat duration = floorf(((UIImageView *)[sidebarx.imageViews objectAtIndex:thisIndex]).frame.size.width*(100.0/sidebarx.scrollView.frame.size.height)/75)/10.0 + 0.1;

    NSLog(@"this dur: %f", duration);
    
    NSLog(@"height this: %f", sidebarx.scrollView.frame.size.height);

    thisIndex = (thisIndex == sidebarx.imageViews.count-1 ? 0 : thisIndex + 1);

    gifTimer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                 target:self
                                               selector:@selector(frame2)
                                               userInfo:nil
                                                repeats:NO];
    
}

- (void)sidebar:(HSImageSidebarView *)sidebar didTapImageAtIndex:(NSUInteger)anIndex{
  //  [self invalidateTimer];
}

-(void)invalidateTimer{
    [gifTimer invalidate];
}

-(void)makeGifShow{
    UIImageView *tmpImage = [[UIImageView alloc]init];//(UIImageView *)[imageViews objectAtIndex:currentIndex];

    CGFloat duration = 0.0;
    
    NSLog(@"FULL SIZE: %lu", (unsigned long)self.sidebarx.imageViews.count);
    
    for (int i = 0; i < images.count; ++i){
        
        tmpImage = [sidebarx.imageViews objectAtIndex:i];
        
        duration = tmpImage.frame.size.width/sidebarx.scrollView.contentSize.width;
       
        //self.mainImageView.image = tmpImage.image;
        
        self.mainImageView.image = [images objectAtIndex:i];
        
        NSLog(@"this duration: %f", duration);
        
        [UIView animateWithDuration:duration/2.0 delay:duration/2.0 options:nil animations:^{
        
            
        } completion:^(BOOL finished){
        
        //    if (i == (images.count-1)){
        //        [self makeGifShow];
        //    }
        
        }];
    
    //    self.mainImageView.image = tmpImage.image;
        
 //       gifTimer = [NSTimer scheduledTimerWithTimeInterval:duration
  //                                                    target:self
   //                                                 selector:nil
    //                                                userInfo:nil
   //                                                  repeats:NO];

        
    }
}


-(NSUInteger)countOfImagesInSidebar:(HSImageSidebarView *)sidebar {
    return [images count];
}

-(UIImage *)sidebar:(HSImageSidebarView *)sidebar imageForIndex:(NSUInteger)anIndex {
    return (UIImage *)[images objectAtIndex:anIndex];
}

-(void)swapIndex1:(int)index1 withIndex2:(int)index2{
    /*
    UIImage *image1 = [images objectAtIndex:index1];
    [images insertObject:[images objectAtIndex:index2] atIndex:index1];
    [images insertObject:image1 atIndex:index2];
     */
    [images exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}

- (NSMutableArray *)cloneObject:(int)index
{
    //NSUInteger indexOfObject = [self indexOfObject:object];
    NSArray *firstSubArray = [images subarrayWithRange:NSMakeRange(0, index+1)];
    NSArray *secondSubArray = [images subarrayWithRange:NSMakeRange(index, images.count - index)];
    NSArray *newArray = [firstSubArray arrayByAddingObjectsFromArray:secondSubArray];
    
    NSMutableArray *thisThang = [newArray copy];
    
    return thisThang;
}

-(void)cloneArrayObjectAtIndex:(int)index{
    images  = [[self cloneObject:index] copy];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    actionSheetBlock(buttonIndex);
}

/*
UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300*scaleFactor2)/2, ([UIScreen mainScreen].bounds.size.height - 10*scaleFactor2), 300*scaleFactor2, 2)];
lineView.backgroundColor = [UIColor whiteColor];
[thisView addSubview:lineView];

*/


-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background2"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"AvenirNext-Bold" size:20.0],
      UITextAttributeFont,
      nil]];

}

-(void)buyMaker{
    [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"hasPurchased"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)viewWillDisappear:(BOOL)animated{
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:18.0/256.0 green:234.0/256.0 blue:150.0/256.0 alpha:1];
    [delegate applyCloudLayerAnimation];
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
      UITextAttributeTextShadowOffset,
      [UIFont  boldSystemFontOfSize:17.0],
      UITextAttributeFont,
      nil]];
    thisIndex = 0;
    [gifTimer invalidate];
}

-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:18.0/256.0 green:234.0/256.0 blue:150.0/256.0 alpha:1];
    [delegate applyCloudLayerAnimation];

}

@end
