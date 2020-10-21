//
//  ViewController.m
//  Zoom
//
//  Created by Ben Taylor on 5/3/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "thisViewController.h"
#import "FaceRect.h"
#import "OLFacebookImagePickerController.h"
#import <QuartzCore/QuartzCore.h>
#import "FXBlurView.h"
#import "LLSimpleCamera.h"
#import "ImageViewController.h"
#import "HomeViewController.h"
#import "UIImage-Extensions.h"
#import "UIImage+FixOrientation.h"
#import "CustomSegue.h"
#import "CustomUnwindSegue.h"
#import "SecondViewController.h"
#import "UIImage+animatedGIF.h"
#import "FLAnimatedImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+GIF.h"
//#import "OLInstagramImagePickerController.h"
//#import "OLInstagramImage.h"
#import <OLInstagramImagePickerController.h>
#import <OLInstagramImage.h>
#import <PECropViewController.h>
#import "OLFacebookImagePickerCell.h"
#import "SettingsViewController.h"
#include <AudioToolbox/AudioToolbox.h>
#import <MessageUI/MessageUI.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "PopUpViewController.h"
#import "APPViewController.h"

#import "FaceRect.h"
#import "myPanner.h"
#import "Haneke.h"

/*
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
 */
#import "MasterViewController.h"

@interface UIPlaceHolderTextView ()

@property (nonatomic, retain) UILabel *placeHolderLabel;

@end

@implementation UIPlaceHolderTextView

CGFloat const UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION = 0.25;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    [_placeHolderLabel release]; _placeHolderLabel = nil;
    [_placeholderColor release]; _placeholderColor = nil;
    [_placeholder release]; _placeholder = nil;
    [super dealloc];
#endif
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    [UIView animateWithDuration:UI_PLACEHOLDER_TEXT_CHANGED_ANIMATION_DURATION animations:^{
        if([[self text] length] == 0)
        {
            [[self viewWithTag:999] setAlpha:1];
        }
        else
        {
            [[self viewWithTag:999] setAlpha:0];
        }
    }];
    
    
    
}
- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    if( [[self placeholder] length] > 0 )
    {
        if (_placeHolderLabel == nil )
        {
            _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeHolderLabel.numberOfLines = 0;
            _placeHolderLabel.font = self.font;
            _placeHolderLabel.backgroundColor = [UIColor clearColor];
            _placeHolderLabel.textColor = self.placeholderColor;
            _placeHolderLabel.alpha = 0;
            _placeHolderLabel.tag = 999;
            [self addSubview:_placeHolderLabel];
        }
        
        _placeHolderLabel.text = self.placeholder;
        [_placeHolderLabel sizeToFit];
        [self sendSubviewToBack:_placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    [super drawRect:rect];
}

@end



@interface SpecialButton : UIButton

@end

@implementation SpecialButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.imageView.frame;
    frame = CGRectMake(truncf((self.bounds.size.width - frame.size.width) / 2), 0.0f, frame.size.width, frame.size.height);
    self.imageView.frame = frame;
    
    frame = self.titleLabel.frame;
    frame = CGRectMake(truncf((self.bounds.size.width - (frame.size.width)) / 2), self.bounds.size.height - frame.size.height, frame.size.width, frame.size.height);
    self.titleLabel.frame = frame;
    
    
    CGPoint thisCenter = self.titleLabel.center;
    frame = CGRectMake(truncf((self.bounds.size.width - (frame.size.width)) / 2), self.bounds.size.height - frame.size.height, frame.size.width + 60, frame.size.height);
    self.titleLabel.frame = frame;
    self.titleLabel.center = thisCenter;
    
    self.titleLabel.textAlignment = UITextAlignmentCenter;
    
    self.titleLabel.font = [UIFont fontWithName:nil size:14.0f];
}

@end

@interface AlbumCoverCell : UICollectionViewCell

/*
FLAnimatedImageView *cellImageView = [[FLAnimatedImageView alloc] init];
//cellImageView.animatedImage = image;
cellImageView.image = [UIImage imageWithData:gifData];
cellImageView.frame = CGRectMake(0.0, 0.0, 160.0, 160.0);
*/
@property (nonatomic, retain) FLAnimatedImageView *imageView;

//@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@end

@implementation AlbumCoverCell
@synthesize imageView = _imageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[FLAnimatedImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_imageView];
    }
    return self;
}
/*
- (void)dealloc
{
  //  [_imageView release];
  //  [super dealloc];
}
*/
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    // reset image property of imageView for reuse
    //self.imageView.animatedImage = nil;
    
    // update frame position of subviews
    //self.imageView.frame = self.contentView.bounds;
}
@end



@implementation ViewController 


@synthesize myImageView;
@synthesize chooseFromPictures;
@synthesize chooseFromFacebook;
@synthesize chooseFromInsta;
@synthesize cameraButton;
@synthesize thisTimer;
@synthesize zoomButton;
@synthesize myLabel;
@synthesize cloudLayer;
@synthesize cloudLayerAnimation;
@synthesize bluredEffectView;
@synthesize camera;
@synthesize myImage;
@synthesize flashButton;
@synthesize switchButton;
@synthesize snapButton;
@synthesize thisInd;
@synthesize faceLabel;
@synthesize faceLabel2;
@synthesize label1;
@synthesize label2;
@synthesize label3;
@synthesize label4;
@synthesize selectView;
@synthesize pulseTimer;

@synthesize camBack;
@synthesize camAgain;
@synthesize addRect;
@synthesize camBackLabel;
@synthesize camAgainLabel;
@synthesize addRectLabel;

@synthesize indThis;
@synthesize gifView;
@synthesize dragView;
@synthesize gView;
@synthesize yoloView;
@synthesize upImage;
@synthesize myGifLabel;
@synthesize imageArray;
@synthesize pathx;
@synthesize thisLabr;
@synthesize inders;
@synthesize finishedViews;
@synthesize goingToNextView;
@synthesize _imagePicker;
@synthesize secretImage;
@synthesize fullView;
@synthesize bigView;
@synthesize thisScroller;
@synthesize thisTexter;
@synthesize testAlerter;
@synthesize backgroundView;
@synthesize selectCamImage;
@synthesize againCamImage;
@synthesize myCameraThingDogImage;
@synthesize backCamImage;

bool done = NO;
bool camTouched = NO;
CGPoint lastPoint;
CGFloat lastScale;
CGFloat myLastScale;
CGPoint startLocation;
int faceCount = 0;
bool stopFunction = NO;
bool movedAlready = NO;
int totalAddedFrames = 0;
bool alreadyCammed = NO;
bool animateThing = NO;
int camPos = 0;
bool isUp = NO;
bool yoloUp = NO;
bool presseds = NO;
int tappedIndex = -1;
int mySelectInt = 0;
bool takingPic = NO;
float scaleFactor = 1.0;
int collectionSize = 0;
bool isFull = NO;
int actionIndex = -1;
int actionNum = 0;
bool isCray = NO;
int twitterIndex = 0;
bool willShow = NO;
int allKnowingInt = 0;

//UICollectionViewCell *cell;

- (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)showPrompt{
    
    thisLabr = [[UILabel alloc]initWithFrame:CGRectZero];
    [thisLabr setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:(20.0f*scaleFactor)]];
    thisLabr.textColor = [UIColor whiteColor];
    thisLabr.numberOfLines = 2;
    thisLabr.textAlignment = NSTextAlignmentCenter;
    thisLabr.text = @"You haven't created any GIFs yet!\nGo make one already.";
    [thisLabr sizeToFit];
    thisLabr.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2 - 60);
    [dragView insertSubview:thisLabr aboveSubview:gifView];
        
}

-(void)removePrompt{
    [thisLabr removeFromSuperview];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if ([imageArray count] == 0){
        [self showPrompt];
    } else if ([imageArray count] >= 1){
        [self removePrompt];
    }

    return [imageArray count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    AlbumCoverCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"albumIdentifier" forIndexPath:indexPath];

    if (cell == nil)
    {
        cell = [[AlbumCoverCell alloc] init];
    }

    
    NSString *fileName = [imageArray objectAtIndex:indexPath.item];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
    fileName = [fullCachePath stringByAppendingPathComponent:fileName];

    NSData *gifData = [[NSData alloc] initWithContentsOfFile:fileName];
    
    cell.layer.cornerRadius = 10.0;
    
    cell.clipsToBounds = YES;

    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:gifData];
    
    cell.imageView.animatedImage = image;
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale/2;

    //for (UIView *current in [cell.contentView subviews]) {[current removeFromSuperview];}
    // always add to contentView property
//    [cell.contentView addSubview:cellImageView];
    
    UITapGestureRecognizer *thisTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showThisImage:)];
    
    [cell addGestureRecognizer:thisTap];
    
    UILongPressGestureRecognizer *thisPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(copyThisImage:)];
    
    [cell addGestureRecognizer:thisPress];
    
    return cell;
}

-(void)showThisImage:(UITapGestureRecognizer *)tapper{
    
    AlbumCoverCell *cell = (AlbumCoverCell *)tapper.view;
    
    
        if (isFull == NO){
            
            allKnowingInt = 0;

            NSIndexPath *indexPath = [self.gifView indexPathForCell:cell];
            //NSLog(@"%li and this %li",indexPath.row, indexPath.section);
            
            NSString *fileName = [imageArray objectAtIndex:indexPath.row];
            
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
            fileName = [fullCachePath stringByAppendingPathComponent:fileName];

            NSLog(@"log the url: %@", fileName);
            
            [thisScroller setContentOffset:CGPointMake(0, 0) animated:NO];

            
                fullView.hidden = NO;
            
                bigView.animatedImage = cell.imageView.animatedImage;
            
            
                actionIndex = (int)[self.gifView indexPathForCell:cell].row;
            //NSLog(@"int boy deluxe: %i", actionIndex);
            //NSLog(@"%li and this %li",indexPath.row, indexPath.section);
            
            //NSString *fileName = [imageArray objectAtIndex:indexPath.row];

            
                
                //CGFloat newScale2 = [UIScreen mainScreen].bounds.size.width/(thisView.frame.size.width + 40);
                //CGFloat newScale = [UIScreen mainScreen].bounds.size.width/thisView.frame.size.width;
                
                bigView.layer.opacity = 0.0;
            
            
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                    
          
                    fullView.layer.opacity = 1;
                } completion:^(BOOL finished){

                    
                    
                    bigView.hidden = NO;


                    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                        
                        bigView.layer.opacity = 1.0;
                        
                        thisScroller.frame = CGRectMake(-30, bigView.frame.size.height, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - bigView.frame.size.height);

                        
                    } completion:^(BOOL finished){
                        
                        
                        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                            
                            thisScroller.frame = CGRectMake(0, bigView.frame.size.height, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - bigView.frame.size.height);
                            
                        } completion:^(BOOL finished){
                            
                            
                            /*
                             
                            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                                
                                
                            } completion:^(BOOL finished){
 
                            }];
                            
                             */
                            
                            isFull = YES;

                            allKnowingInt = 5;
                        }];
                        
                        
                        
                        
                    }];

                    
                    
                }];
                
            
            
            
        }
    
    
}

-(void)copyThisImage:(UILongPressGestureRecognizer *)presser{
    
    if (presser.state == UIGestureRecognizerStateBegan && presseds == NO){
    
        presseds = YES;
        
        inders = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
        
        inders.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        inders.backgroundColor = [UIColor blackColor];
        inders.layer.opacity = 0.8;
        inders.layer.cornerRadius = 20.0;
        [inders startAnimating];
        UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        loadingLabel.text = @"Copying GIF...";
        
        [loadingLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
        
        loadingLabel.textColor = [UIColor whiteColor];
        
        [loadingLabel sizeToFit];
        
        loadingLabel.center = CGPointMake(100, 120);
        
        [inders addSubview:loadingLabel];
        
        
        [self.view insertSubview:inders aboveSubview:dragView];

    
    UICollectionViewCell *cell = (UICollectionViewCell *)presser.view;
    
    NSIndexPath *indexPath = [self.gifView indexPathForCell:cell];
    //NSLog(@"%li and this %li",indexPath.row, indexPath.section);

    NSString *fileName = [imageArray objectAtIndex:indexPath.row];

        
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
    fileName = [fullCachePath stringByAppendingPathComponent:fileName];
        
    NSData *gifData = [[NSData alloc] initWithContentsOfFile:fileName];

    UIImage* mygif = [UIImage animatedImageWithAnimatedGIFData:gifData];
        
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
    [pasteboard setData:gifData forPasteboardType:@"com.compuserve.gif"];
        
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            
            inders.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
        } completion:^(BOOL finished){
            
            [inders removeFromSuperview];
            
            finishedViews = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 200)];
            
            
            //inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
            
            finishedViews.backgroundColor = [UIColor blackColor];
            finishedViews.layer.opacity = 0.8;
            finishedViews.layer.cornerRadius = 20.0;
            
            // UIImageView *imageThing = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 55, [UIScreen mainScreen].bounds.size.height/2 - 80, 110, 110)];
            
            UIImageView *imageThing = [[UIImageView alloc]initWithFrame:CGRectMake(45, 10, 110, 110)];
            
            
            imageThing.image = [UIImage imageNamed:@"check"];
            
            UILabel *thisLab = [[UILabel alloc]initWithFrame:CGRectZero];
            
            thisLab.text = @"GIF copied\nto clipboard!";
            
            thisLab.textAlignment = NSTextAlignmentCenter;
            
            [thisLab setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f]];
            
            thisLab.numberOfLines = 2;
            
            thisLab.textColor = [UIColor whiteColor];
            
            [thisLab sizeToFit];
            
            thisLab.center = CGPointMake(100, 150);
            
            [finishedViews addSubview:thisLab];
            
            
            
            [finishedViews addSubview:imageThing];
            
            finishedViews.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
            [self.view addSubview:finishedViews];
            
            
            //NSTimer *thisTimed = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(removeThis) userInfo:nil repeats:NO];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                
                finishedViews.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
            }
             
                             completion:^(BOOL finished){
                                 
                                 [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                     
                                     finishedViews.transform = CGAffineTransformMakeScale(0.85, 0.85);
                                     
                                 }
                                  
                                                  completion:^(BOOL finished){
                                                      
                                                      
                                                      [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                          
                                                          finishedViews.transform = CGAffineTransformMakeScale(1, 1);
                                                          
                                                      }
                                                       
                                                                       completion:^(BOOL finished){
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                                               
                                                                               finishedViews.transform = CGAffineTransformMakeScale(1, 1);
                                                                               
                                                                               
                                                                           }
                                                                                            completion:^(BOOL finished){
                                                                                                
                                                                                                [UIView animateWithDuration:0.2 delay:1.3 options:nil animations:^{
                                                                                                    
                                                                                                    finishedViews.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                                                                                    
                                                                                                }
                                                                                                 
                                                                                                                 completion:^(BOOL finished){
                                                                                                                     
                                                                                                                     
                                                                                                                     [finishedViews removeFromSuperview];
                                                                                                                     presseds = NO;
                                                                                                                     
                                                                                                                 }];
                                                                                                
                                                                                            }];
                                                                           
                                                                           
                                                                       }];
                                                      
                                                  }];
                                 
                                 
                             }];
            
            //[self.view addSubview:imageThing];
            
        }];
        

        
    } else {
        
    }
    
    //NSLog(@"thisIndex: %@", thisIndex);

}

- (NSMutableArray *)removeObject:(int)index
{
    //NSUInteger indexOfObject = [self indexOfObject:object];
    NSArray *firstSubArray = [imageArray subarrayWithRange:NSMakeRange(0, index)];
    NSArray *secondSubArray = [imageArray subarrayWithRange:NSMakeRange(index + 1, imageArray.count - index - 1)];
    NSArray *newArray = [firstSubArray arrayByAddingObjectsFromArray:secondSubArray];
    
    NSMutableArray *thisThang = [newArray copy];
    
    return thisThang;
}

-(void)refreshThis{
    [gifView reloadData];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (scaleFactor < 1){
        return CGSizeMake(130, 130);
    } else {
        return CGSizeMake(160.0*scaleFactor, 160*scaleFactor);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UICollectionView class]])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)mover:(myPanner *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded){
        
        //NSLog(@"LOLOLOL");
        
        CGPoint translation = [recognizer translationInView:self.view];
        
        if (dragView.frame.origin.y < 540 && isUp == NO && recognizer.state == UIGestureRecognizerStateEnded){

            
                [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
                
                    
//                    recognizer.view.frame = CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, recognizer.view.frame.size.height);
  
                    dragView.frame = CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, dragView.frame.size.height);
                    
                    yoloView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (60*scaleFactor));



                    
                    gView.frame = dragView.bounds;//CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88);
                    
                 //   yoloView.frame = CGRectMake(recognizer.view.frame.origin.x, recognizer.view.frame.origin.y + 80, recognizer.view.frame.size.width, recognizer.view.frame.size.height-80);
                    
                    if (yoloUp == NO){
                        
                        allKnowingInt = 1;
                        
                        //[pulseTimer invalidate];
                        //upImage.frame = CGRectMake(20, 15, 37.5, 20);
                        upImage.transform = CGAffineTransformMake(1, 0, 0, upImage.transform.d * -1, 0, upImage.transform.ty);

                       // myGifLabel.center = CGPointMake(dragView.center.x, yoloView.center.y);

                        myGifLabel.center = yoloView.center;
                        
                        gifView.frame = CGRectMake(20, (60*(scaleFactor > 1 ? scaleFactor : 1)), [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height - (60*(scaleFactor > 1 ? scaleFactor : 1)) - 84);
                        
                        NSLog(@"int thing is now 1");
                    }
                    
                } completion:^(BOOL finished){
                    
                    isUp = YES;
                    
                    yoloUp = YES;
                    
                }];
                
                //recognizer.view.frame = CGRectMake(recognizer.view.frame.origin.x, recognizer.view.frame.origin.y + translation.y, recognizer.view.frame.size.width, recognizer.view.frame.size.height);
                
            
        } else {
            
            if (dragView.frame.origin.y >= 200 && translation.y >= 0){
                
                
                [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
                    
                    
                    dragView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - (60*(scaleFactor > 1 ? scaleFactor : 1)), [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height);
                    
                    yoloView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, (60*(scaleFactor > 1 ? scaleFactor : 1)));
                    
                    gView.frame = dragView.bounds;//CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88);
                    

                    if (yoloUp == YES){
                        upImage.transform = CGAffineTransformMake(1, 0, 0, upImage.transform.d * -1, 0, upImage.transform.ty);
                        
                        myGifLabel.center = CGPointMake(yoloView.center.x, yoloView.center.y);
                    
                        gifView.frame = CGRectMake(0, (60*(scaleFactor > 1 ? scaleFactor : 1)), [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height - (60*(scaleFactor > 1 ? scaleFactor : 1)) - 84);
                        
                        /*
                        pulseTimer =   [NSTimer scheduledTimerWithTimeInterval:0.8
                                                                        target:self
                                                                      selector:@selector(pulseImageView)
                                                                      userInfo:nil
                                                                       repeats:YES];
                         */
                    }
                    allKnowingInt = 0;
                    
                    NSLog(@"int thing is now 0");
                    
                    yoloUp = NO;
                    
                    isUp = NO;
                    
                    
                } completion:nil];

            } else {
            
            //if (recognizer.state == UIGestureRecognizerStateEnded){
                isUp = NO;
            //}
        
        
//        recognizer.view.frame = CGRectMake(recognizer.view.frame.origin.x, recognizer.view.frame.origin.y + translation.y, recognizer.view.frame.size.width, recognizer.view.frame.size.height);
        
                
        dragView.frame = CGRectMake(dragView.frame.origin.x, dragView.frame.origin.y + translation.y, dragView.frame.size.width, dragView.frame.size.height);

        
        CGRect recognizerFrame = recognizer.view.frame;
        
        CGPoint myPoint = [recognizer touchPointInView:self.view];
        
        //NSLog(@"LOG THIS Pan Origin: %@", NSStringFromCGPoint(myPoint));
        
        NSLog(@"LOG THIS Frame Origin: %@", NSStringFromCGPoint(recognizerFrame.origin));
        
        //NSLog(@"LOG THIS translation: %@", NSStringFromCGPoint(translation));
        
        // Check if UIImageView is completely inside its superView
        
    //    recognizerFrame.origin.x += translation.x;
        //recognizerFrame.origin.y += translation.y;
        CGPoint movePoint = CGPointMake(0, translation.y);
        [recognizer incrementOrigin:&movePoint];
        
        
        
        //if (CGRectContainsRect(self.myImageView.bounds, recognizerFrame)) {
        //    recognizer.view.frame = recognizerFrame;
        //}
        // Else check if UIImageView is vertically and/or horizontally outside of its
        // superView. If yes, then set UImageView's frame accordingly.
        // This is required so that when user pans rapidly then it provides smooth translation.
        
        // Reset translation so that on next pan recognition
        // we get correct translation value
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
            }
        }
    }
}

- (void)tapUp:(UITapGestureRecognizer *)myTap{
    
    
    
    if (isUp == NO){
        
        
        /*
        [UIView animateWithDuration:0.15 delay:0.0 options:nil animations:^{
        
            upImage.transform = CGAffineTransformMake(0, 0, 0, upImage.transform.d * 1, 0, upImage.transform.ty);

            
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:0.15 delay:0.0 options:nil animations:^{
                
                upImage.transform = CGAffineTransformMake(1, 0, 0, upImage.transform.d * -1, 0, upImage.transform.ty);

                
            } completion:^(BOOL finished){
                
                
            }];
        
        }];
        */
        
        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            
            
            //                    recognizer.view.frame = CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, recognizer.view.frame.size.height);
            
            dragView.frame = CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, dragView.frame.size.height);
            
            yoloView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, (60*(scaleFactor > 1 ? scaleFactor : 1)));
            
            gifView.frame = CGRectMake(20, (60*(scaleFactor > 1 ? scaleFactor : 1)), [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height - (60*(scaleFactor > 1 ? scaleFactor : 1)) - 84);
            
            upImage.transform = CGAffineTransformMake(1, 0, 0, upImage.transform.d * -1, 0, upImage.transform.ty);

            myGifLabel.center = CGPointMake(dragView.center.x, yoloView.center.y);
            
            gView.frame = dragView.bounds;//CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88);
            
            //   yoloView.frame = CGRectMake(recognizer.view.frame.origin.x, recognizer.view.frame.origin.y + 80, recognizer.view.frame.size.width, recognizer.view.frame.size.height-80);
            
            isUp = YES;
            
        } completion:^(BOOL finished){
            
            yoloUp = YES;
            
            allKnowingInt = 1;

            NSLog(@"int thing is now 1");

        }];
        
        //recognizer.view.frame = CGRectMake(recognizer.view.frame.origin.x, recognizer.view.frame.origin.y + translation.y, recognizer.view.frame.size.width, recognizer.view.frame.size.height);
        
        
    } else {
        
            
            [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
                
                
                dragView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - (60*scaleFactor), [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height);
                
                yoloView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, (60*scaleFactor));
                
                gView.frame = dragView.bounds;//CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88);
                
                gifView.frame = CGRectMake(0, (60*(scaleFactor > 1 ? scaleFactor : 1)), [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height - (60*(scaleFactor > 1 ? scaleFactor : 1)) - 84);
                
                upImage.transform = CGAffineTransformMake(1, 0, 0, upImage.transform.d * -1, 0, upImage.transform.ty);
                
                myGifLabel.center = CGPointMake(yoloView.center.x, yoloView.center.y);
                
                isUp = NO;
                
                yoloUp = NO;
                
                NSLog(@"LOOOOOOL");
                allKnowingInt = 0;

                NSLog(@"int thing is now 0");

                
            } completion:nil];
    }
    
    
}

- (void)settingsPage{
    SettingsViewController *thisControl = [[SettingsViewController alloc]init];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:thisControl];
    //[self presentViewController:thisControl animated:YES completion:nil];
    [self.navigationController presentModalViewController:navC animated:YES];
}

-(void)goAway{
    
    
    if (isFull == YES){
        allKnowingInt = 0;
    [UIView animateWithDuration:0.2 delay:0.0 options:nil animations:^{
        
        bigView.layer.opacity = 0.0;
        
        thisScroller.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + 30, bigView.frame.size.height, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - bigView.frame.size.height);

        
    } completion:^(BOOL finished){
        
        bigView.hidden = YES;

    
        [UIView animateWithDuration:0.2 delay:0.0 options:nil animations:^{
            

            fullView.layer.opacity = 0.0;
            
        } completion:^(BOOL finished){
            
            fullView.hidden = YES;
            isFull = NO;
            bigView.animatedImage = nil;
            
            allKnowingInt = 1;
            
            
            
        }];
        

        
    }];
    }
}

-(void)savePic{
    
    
    
    if (presseds == NO){
        
        presseds = YES;
        
        inders = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
        
        inders.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        inders.backgroundColor = [UIColor blackColor];
        inders.layer.opacity = 0.8;
        inders.layer.cornerRadius = 20.0;
        [inders startAnimating];
        UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        loadingLabel.text = @"Saving GIF...";
        
        [loadingLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
        
        loadingLabel.textColor = [UIColor whiteColor];
        
        [loadingLabel sizeToFit];
        
        loadingLabel.center = CGPointMake(100, 120);
        
        [inders addSubview:loadingLabel];
        
        [self.view insertSubview:inders aboveSubview:dragView];
        
        NSString *fileName = [imageArray objectAtIndex:actionIndex];
        
        //NSFileManager *fileManager = [NSFileManager defaultManager];
        //NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
        //fileName = [fullCachePath stringByAppendingPathComponent:fileName];
        
        //NSData *gifData = [[NSData alloc] initWithContentsOfFile:fileName];
        
        //UIImage* mygif = [UIImage animatedImageWithAnimatedGIFData:gifData];
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
        
        NSData *gifData = [NSData dataWithContentsOfFile:[fileURL path]];

        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:gifData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            
            NSLog(@"Success at %@", [assetURL path] );
        }];
        
        //UIImageWriteToSavedPhotosAlbum(mygif, nil, nil, nil);

        
        //UIImageWriteToSavedPhotosAlbum(mygif, nil, nil, nil);
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            
            inders.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
        } completion:^(BOOL finished){
            
            [inders removeFromSuperview];
            
            finishedViews = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 200)];
            
            
            //inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
            
            finishedViews.backgroundColor = [UIColor blackColor];
            finishedViews.layer.opacity = 0.8;
            finishedViews.layer.cornerRadius = 20.0;
            
            // UIImageView *imageThing = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 55, [UIScreen mainScreen].bounds.size.height/2 - 80, 110, 110)];
            
            UIImageView *imageThing = [[UIImageView alloc]initWithFrame:CGRectMake(45, 10, 110, 110)];
            
            
            imageThing.image = [UIImage imageNamed:@"save"];
            
            UILabel *thisLab = [[UILabel alloc]initWithFrame:CGRectZero];
            
            thisLab.text = @"GIF saved\nto camera roll!";
            
            thisLab.textAlignment = NSTextAlignmentCenter;
            
            [thisLab setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f]];
            
            thisLab.numberOfLines = 2;
            
            thisLab.textColor = [UIColor whiteColor];
            
            [thisLab sizeToFit];
            
            thisLab.center = CGPointMake(100, 150);
            
            [finishedViews addSubview:thisLab];
            
            
            
            [finishedViews addSubview:imageThing];
            
            finishedViews.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
            [self.view addSubview:finishedViews];
            
            
            //NSTimer *thisTimed = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(removeThis) userInfo:nil repeats:NO];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                
                finishedViews.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
            }
             
                             completion:^(BOOL finished){
                                 
                                 [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                     
                                     finishedViews.transform = CGAffineTransformMakeScale(0.85, 0.85);
                                     
                                 }
                                  
                                                  completion:^(BOOL finished){
                                                      
                                                      
                                                      [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                          
                                                          finishedViews.transform = CGAffineTransformMakeScale(1, 1);
                                                          
                                                      }
                                                       
                                                                       completion:^(BOOL finished){
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                                               
                                                                               finishedViews.transform = CGAffineTransformMakeScale(1, 1);
                                                                               
                                                                               
                                                                           }
                                                                                            completion:^(BOOL finished){
                                                                                                
                                                                                                [UIView animateWithDuration:0.2 delay:1.3 options:nil animations:^{
                                                                                                    
                                                                                                    finishedViews.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                                                                                    
                                                                                                }
                                                                                                 
                                                                                                                 completion:^(BOOL finished){
                                                                                                                     
                                                                                                                     
                                                                                                                     [finishedViews removeFromSuperview];
                                                                                                                     presseds = NO;
                                                                                                                     
                                                                                                                 }];
                                                                                                
                                                                                            }];
                                                                           
                                                                           
                                                                       }];
                                                      
                                                  }];
                                 
                                 
                             }];
            
            //[self.view addSubview:imageThing];
            
        }];
        
        
        
    }

}

-(void)copyPic{
    
    if (presseds == NO){
        
        presseds = YES;
        
        inders = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
        
        inders.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        inders.backgroundColor = [UIColor blackColor];
        inders.layer.opacity = 0.8;
        inders.layer.cornerRadius = 20.0;
        [inders startAnimating];
        UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        loadingLabel.text = @"Copying GIF...";
        
        [loadingLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
        
        loadingLabel.textColor = [UIColor whiteColor];
        
        [loadingLabel sizeToFit];
        
        loadingLabel.center = CGPointMake(100, 120);
        
        [inders addSubview:loadingLabel];
        
        [self.view insertSubview:inders aboveSubview:dragView];
        
        NSString *fileName = [imageArray objectAtIndex:actionIndex];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
        fileName = [fullCachePath stringByAppendingPathComponent:fileName];
        
        NSData *gifData = [[NSData alloc] initWithContentsOfFile:fileName];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        [pasteboard setData:gifData forPasteboardType:@"com.compuserve.gif"];
        
        //UIImageWriteToSavedPhotosAlbum(mygif, nil, nil, nil);
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            
            inders.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
        } completion:^(BOOL finished){
            
            [inders removeFromSuperview];
            
            finishedViews = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 200)];
            
            
            //inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
            
            finishedViews.backgroundColor = [UIColor blackColor];
            finishedViews.layer.opacity = 0.8;
            finishedViews.layer.cornerRadius = 20.0;
            
            // UIImageView *imageThing = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 55, [UIScreen mainScreen].bounds.size.height/2 - 80, 110, 110)];
            
            UIImageView *imageThing = [[UIImageView alloc]initWithFrame:CGRectMake(45, 10, 110, 110)];
            
            
            imageThing.image = [UIImage imageNamed:@"check"];
            
            UILabel *thisLab = [[UILabel alloc]initWithFrame:CGRectZero];
            
            thisLab.text = @"GIF copied\nto clipboard!";
            
            thisLab.textAlignment = NSTextAlignmentCenter;
            
            [thisLab setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f]];
            
            thisLab.numberOfLines = 2;
            
            thisLab.textColor = [UIColor whiteColor];
            
            [thisLab sizeToFit];
            
            thisLab.center = CGPointMake(100, 150);
            
            [finishedViews addSubview:thisLab];
            
            
            
            [finishedViews addSubview:imageThing];
            
            finishedViews.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
            [self.view addSubview:finishedViews];
            
            
            //NSTimer *thisTimed = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(removeThis) userInfo:nil repeats:NO];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                
                finishedViews.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
            }
             
                             completion:^(BOOL finished){
                                 
                                 [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                     
                                     finishedViews.transform = CGAffineTransformMakeScale(0.85, 0.85);
                                     
                                 }
                                  
                                                  completion:^(BOOL finished){
                                                      
                                                      
                                                      [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                          
                                                          finishedViews.transform = CGAffineTransformMakeScale(1, 1);
                                                          
                                                      }
                                                       
                                                                       completion:^(BOOL finished){
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                                               
                                                                               finishedViews.transform = CGAffineTransformMakeScale(1, 1);
                                                                               
                                                                               
                                                                           }
                                                                                            completion:^(BOOL finished){
                                                                                                
                                                                                                [UIView animateWithDuration:0.2 delay:1.3 options:nil animations:^{
                                                                                                    
                                                                                                    finishedViews.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                                                                                    
                                                                                                }
                                                                                                 
                                                                                                                 completion:^(BOOL finished){
                                                                                                                     
                                                                                                                     
                                                                                                                     [finishedViews removeFromSuperview];
                                                                                                                     presseds = NO;
                                                                                                                     
                                                                                                                 }];
                                                                                                
                                                                                            }];
                                                                           
                                                                           
                                                                       }];
                                                      
                                                  }];
                                 
                                 
                             }];
            
            //[self.view addSubview:imageThing];
            
        }];
        
        
        
    }
    
}

-(void)messagePic{
    
    inders = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
    
    inders.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    inders.backgroundColor = [UIColor blackColor];
    inders.layer.opacity = 0.8;
    inders.layer.cornerRadius = 20.0;
    [inders startAnimating];
    
    [self.view insertSubview:inders aboveSubview:dragView];

    
    MFMessageComposeViewController* composer = [[MFMessageComposeViewController alloc] init];
    composer.messageComposeDelegate = self;
    //[composer setSubject:@"My Subject"];
    /*
    if([MFMessageComposeViewController canSendText])
    {
        controller.body = @"Check out this sick GIF I made with Zoom!";
        controller.recipients = [NSArray arrayWithObjects:nil];
        
        
        
        controller.attachments = [NSArray arrayWithObjects:nil];
        controller.messageComposeDelegate = self;
        [self presentModalViewController:controller animated:YES];
    }
     */
    
    if([MFMessageComposeViewController respondsToSelector:@selector(canSendAttachments)] && [MFMessageComposeViewController canSendAttachments])
    {
        //NSData* attachment = UIImageJPEGRepresentation(myImage, 1.0);
        
        NSString *fileName = [imageArray objectAtIndex:actionIndex];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
        fileName = [fullCachePath stringByAppendingPathComponent:fileName];
        
        NSData *gifData = [[NSData alloc] initWithContentsOfFile:fileName];
        
        //UIImage* mygif = [UIImage animatedImageWithAnimatedGIFData:gifData];

        
        //NSString* uti = (NSString*)kUTTypeMessage;
        
        //[composer addAttachmentData:gifData typeIdentifier:@"com.compuserve.gif" filename:@"Zoom GIF"];
        [composer addAttachmentData:gifData typeIdentifier:@"public.data" filename:@"zoom.gif"];

    }
    
    composer.body = @"Check out this sick GIF I made with Zoom!";

    [self presentViewController:composer animated:YES completion:nil];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [inders removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
        else if (result == MessageComposeResultSent)
            NSLog(@"Message sent");
            else
                NSLog(@"Message failed");
}

-(void)messengerPic{
    if ([FBSDKMessengerSharer messengerPlatformCapabilities] & FBSDKMessengerPlatformCapabilityAnimatedGIF) {
        NSString *fileName = [imageArray objectAtIndex:actionIndex];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
        fileName = [fullCachePath stringByAppendingPathComponent:fileName];
        
        NSData *gifData = [[NSData alloc] initWithContentsOfFile:fileName];
        
        [FBSDKMessengerSharer shareAnimatedGIF:gifData withOptions:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Messenger Not Installed" message:@"Please install Facebook Messenger to use this feature." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)facebookPic{
    
}

-(void)tweetThis:(NSString *)thisString{
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to access their Twitter account
    [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error)
     {
         // Did user allow us access?
         if (granted == YES)
         {
             // Populate array with all available Twitter accounts
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             
             // Sanity check
             
             
             if ([arrayOfAccounts count] > 0)
             {
                 
                 /*
                 if ([arrayOfAccounts count] > 1){
                     
                   //  NSArray
                     
                     UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Twitter Account:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
                     
                     int i = 0;
                     for (i= 0; i < [arrayOfAccounts count]; i++){
                         [popup addButtonWithTitle:[[arrayOfAccounts objectAtIndex:i] username]];
                     }
                     
                     popup.tag = 1;
                     [popup showInView:[UIApplication sharedApplication].keyWindow];
                     
                 } else {
                  */
                  
                 // Keep it simple, use the first account available
                 ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                 TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://upload.twitter.com/1/statuses/update_with_media.json"] parameters:nil requestMethod:TWRequestMethodPOST];
                 
                 
                 NSString *fileName = [imageArray objectAtIndex:actionIndex];
                 
                 NSFileManager *fileManager = [NSFileManager defaultManager];
                 NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
                 NSString *fileNames = [fullCachePath stringByAppendingPathComponent:fileName];
                 
                 
                 NSData *data = [NSData dataWithContentsOfFile:fileNames];
                 
                 // com.compuserve.gif
                 //[postRequest addMultiPartData:data withName:@"media" type:@"image/gif"];
                 
                 [postRequest addMultiPartData:data withName:@"media" type:@"image/gif"];
                 data = [[NSString stringWithFormat:thisString] dataUsingEncoding:NSUTF8StringEncoding];
                 [postRequest addMultiPartData:data withName:@"status" type:@"text/plain"];
                 
                 [postRequest setAccount:acct];
                 
                 // Block handler to manage the response
                 [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      NSLog(@"Twitter response, HTTP response: %li", (long)[urlResponse statusCode]);
                  }];
                // }
                 
             } else {
                 
                 UIAlertView *thisAll = [[UIAlertView alloc] initWithTitle:@"Twitter Unavailable" message:@"Please log into Twitter to use this feature." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                 
                 [thisAll show];
                 
                 [UIView animateWithDuration:0.5 delay:0.2 options:nil animations:^{
                 
                     //[testAlerter dismissWithClickedButtonIndex:1 animated:YES];
                 
                 } completion:^(BOOL finished){
                 
                     [self doItAgain];
                     
                     }];
                 
                 NSLog(@"nope shitdawg");
             }
         }
     }];

}

-(void)doItAgain{
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Unavailable" message:@"Please log into Twitter to use this feature." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
}

- (BOOL)textView:(UIPlaceHolderTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //NSLog(@"BROOOOO");
    if(textView.text.length + (text.length - range.length) > 140){
        NSString *temp=textView.text;
        textView.text=[temp substringToIndex:[temp length]-1];
    }
    return textView.text.length + (text.length - range.length) <= 140;
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSInteger restrictedLength=140;
    
    NSString *temp=textView.text;
    
    if([[textView text] length] > restrictedLength){
        textView.text=[temp substringToIndex:[temp length]-1];
    }
}


-(void)twitterPic{
    
    actionNum = 1;
    
    testAlerter = [[UIAlertView alloc] initWithTitle:@"Post to Twitter"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Post", nil];
    thisTexter = [UIPlaceHolderTextView new];
    thisTexter.delegate = self;
    thisTexter.placeholder = @"Add Tweet Here";
    thisTexter.placeholderColor = [UIColor lightGrayColor];
    thisTexter.font = [UIFont fontWithName:nil size:16.0];
    thisTexter.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [testAlerter setValue: thisTexter forKey:@"accessoryView"];
    
    testAlerter.backgroundColor = [UIColor colorWithRed:41.0/256.0 green:41.0/256.0 blue:41.0/256.0 alpha:1.0];
    testAlerter.tintColor = [UIColor colorWithRed:20.0/256.0 green:236.0/256.0 blue:153.0/256.0 alpha:1.0];
    
    
    [testAlerter show];

    [thisTexter becomeFirstResponder];


}

-(void)emailPic{
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    
    mailController.mailComposeDelegate = self;
    
    [mailController setSubject:@""];
    
    [mailController setMessageBody:@"Check out this sick GIF I made with Zoom!" isHTML:NO];
    
    //UIImage *pic = [UIImage imageNamed:@"Image box with border-1.png"];
    //NSData *exportData = UIImageJPEGRepresentation(pic ,1.0);
    
    NSString *fileName = [imageArray objectAtIndex:actionIndex];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
    fileName = [fullCachePath stringByAppendingPathComponent:fileName];
    
    NSData *gifData = [[NSData alloc] initWithContentsOfFile:fileName];

    
    [mailController addAttachmentData:gifData mimeType:@"image/gif" fileName:@"Zoom.gif"];
    
    
    [self presentModalViewController:mailController animated:YES];
    //[mailController release];
}

- (void)mailComposeController:(MFMailComposeViewController*)mailController

          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    
    [self becomeFirstResponder];
    
    [self dismissModalViewControllerAnimated:YES];
    
}
    


-(void)deletePic{
    if (presseds == NO){
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete this GIF?"
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes",nil];
    actionNum = 0;
    [alert show];
    }

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 0 = Tapped yes
    if (buttonIndex == 1 && actionNum == 0)
    {
        [self deletePic2];
    } else if (buttonIndex == 1 && actionNum == 1 && isCray == NO){
        //UIPlaceHolderTextView *thisView = [alertView valueForKey:@"accessoryView"];
        NSString *myText = thisTexter.text;
        [testAlerter dismissWithClickedButtonIndex:1 animated:YES];
        [self tweetThis:myText];
    } else if (buttonIndex == 0 && actionNum == 1){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [thisTexter resignFirstResponder];
    }
}

-(void)deletePic2{
    
    if (presseds == NO){
        
        presseds = YES;
        
        inders = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
        
        inders.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        inders.backgroundColor = [UIColor blackColor];
        inders.layer.opacity = 0.8;
        inders.layer.cornerRadius = 20.0;
        [inders startAnimating];
        UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        loadingLabel.text = @"Deleting GIF...";
        
        [loadingLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
        
        loadingLabel.textColor = [UIColor whiteColor];
        
        [loadingLabel sizeToFit];
        
        loadingLabel.center = CGPointMake(100, 120);
        
        [inders addSubview:loadingLabel];
        
        [self.view insertSubview:inders aboveSubview:dragView];
        
        NSString *fileName = [imageArray objectAtIndex:actionIndex];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
        fileName = [fullCachePath stringByAppendingPathComponent:fileName];
        
        [fileManager removeItemAtPath:fileName error:nil];
        
        [self goAway];
        
        imageArray = [[NSMutableArray alloc]initWithArray:[self removeObject:actionIndex] copyItems:YES];//[(NSMutableArray *)[self removeObject:actionIndex] copy];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:imageArray];

        [data writeToFile:pathx options:NSDataWritingAtomic error:nil];
        
        [gifView reloadData];

        NSLog(@"new size: %lu", (unsigned long)imageArray.count);
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            
            inders.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
        } completion:^(BOOL finished){
            
            [inders removeFromSuperview];
            
            finishedViews = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 200)];
            
            
            //inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
            
            finishedViews.backgroundColor = [UIColor blackColor];
            finishedViews.layer.opacity = 0.8;
            finishedViews.layer.cornerRadius = 20.0;
            
            // UIImageView *imageThing = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 55, [UIScreen mainScreen].bounds.size.height/2 - 80, 110, 110)];
            
            UIImageView *imageThing = [[UIImageView alloc]initWithFrame:CGRectMake(45, 10, 110, 110)];
            
            
            imageThing.image = [UIImage imageNamed:@"delete"];
            
            UILabel *thisLab = [[UILabel alloc]initWithFrame:CGRectZero];
            
            thisLab.text = @"GIF deleted!";
            
            thisLab.textAlignment = NSTextAlignmentCenter;
            
            [thisLab setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f]];
            
            thisLab.numberOfLines = 1;
            
            thisLab.textColor = [UIColor whiteColor];
            
            [thisLab sizeToFit];
            
            thisLab.center = CGPointMake(100, 150);
            
            [finishedViews addSubview:thisLab];
            
            
            
            [finishedViews addSubview:imageThing];
            
            finishedViews.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
            [self.view addSubview:finishedViews];
            
            
            //NSTimer *thisTimed = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(removeThis) userInfo:nil repeats:NO];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                
                finishedViews.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
            }
             
                             completion:^(BOOL finished){
                                 
                                 [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                     
                                     finishedViews.transform = CGAffineTransformMakeScale(0.85, 0.85);
                                     
                                 }
                                  
                                                  completion:^(BOOL finished){
                                                      
                                                      
                                                      [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                          
                                                          finishedViews.transform = CGAffineTransformMakeScale(1, 1);
                                                          
                                                      }
                                                       
                                                                       completion:^(BOOL finished){
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                                               
                                                                               finishedViews.transform = CGAffineTransformMakeScale(1, 1);
                                                                               
                                                                               
                                                                           }
                                                                                            completion:^(BOOL finished){
                                                                                                
                                                                                                [UIView animateWithDuration:0.2 delay:1.3 options:nil animations:^{
                                                                                                    
                                                                                                    finishedViews.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                                                                                    
                                                                                                }
                                                                                                 
                                                                                                                 completion:^(BOOL finished){
                                                                                                                     
                                                                                                                     
                                                                                                                     [finishedViews removeFromSuperview];
                                                                                                                     presseds = NO;
                                                                                                                     
                                                                                                                 }];
                                                                                                
                                                                                            }];
                                                                           
                                                                           
                                                                       }];
                                                      
                                                  }];
                                 
                                 
                             }];
            
            //[self.view addSubview:imageThing];
            
        }];
        
        
        
    }
    
}

- (void)viewDidLoad {
    
    
    if ([UIScreen mainScreen].nativeBounds.size.height == 960){
        scaleFactor = 960.0/1334.0;
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 1136){
        scaleFactor = 1136.0/1334.0;
        NSLog(@"Here I guess: %f", scaleFactor);
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 1334){
        scaleFactor = 1.0;
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 2208){
        //scaleFactor = 2208.0/1334.0 * 326.0/401.0;
       // scaleFactor = 333.5/368.0 * 2208.0/1334.0;
        scaleFactor = 401.0/326.0*333.5/368.0;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {

        
        NSLog(@"ap gov yo");
        // app already launched
    }
    else
    {

    }
    
    selectCamImage = [UIImage imageNamed:@"select_cam"];
    againCamImage = [UIImage imageNamed:@"again_cam"];
    myCameraThingDogImage = [UIImage imageNamed:@"mycammerathingdog"];
    backCamImage = [UIImage imageNamed:@"back_cam"];
    
    
    backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backgroundView];
    
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-15);
    verticalMotionEffect.maximumRelativeValue = @(15);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-15);
    horizontalMotionEffect.maximumRelativeValue = @(15);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    //[myBackgroundView addMotionEffect:group];
    [backgroundView addMotionEffect:group];
    
    //[self.gifView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"lolid"];

    // The Array
    //imageArray = [[NSMutableArray alloc] init];
    
    // Determine Path
    //NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *path = [ [paths objectAtIndex:0] stringByAppendingPathComponent:@"archive.dat"];
    
    //imageArray = [[NSMutableArray alloc]init];//[NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSArray *pather = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    pathx = [ [pather objectAtIndex:0] stringByAppendingPathComponent:@"archive.dat"];

    NSLog(@"the path is this: %@", pathx);
    
    imageArray = [NSKeyedUnarchiver unarchiveObjectWithFile:pathx];

    NSLog(@"count again: %li", [imageArray count]);
    
    if ([imageArray count] == 0){
        imageArray = [[NSMutableArray alloc]init];
    }
    
    [self imageScroll];
    
    dragView = [[UIView alloc]initWithFrame:CGRectMake(20, [UIScreen mainScreen].bounds.size.height - (60*scaleFactor), [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height)];
    dragView.backgroundColor = [UIColor clearColor];
    dragView.layer.cornerRadius = 20.0;
    dragView.clipsToBounds = YES;
    
    gView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    gView.frame = dragView.bounds;//[UIScreen mainScreen].bounds;
    [dragView addSubview:gView];
    
    yoloView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, (60*scaleFactor))];
    yoloView.backgroundColor = [UIColor clearColor];
    yoloView.layer.cornerRadius = 20.0;
    yoloView.clipsToBounds = YES;
    [dragView addSubview:yoloView];
    
    myPanner *thisPanx = [[myPanner alloc]initWithTarget:self action:@selector(mover:)];
    [yoloView addGestureRecognizer:thisPanx];
    
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapUp:)];
    [yoloView addGestureRecognizer:tapper];
    
    upImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, (15*scaleFactor), (37.5*scaleFactor), (20*scaleFactor))];
   // upImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, (37.5*scaleFactor), (20*scaleFactor))];

    upImage.image = [UIImage imageNamed:@"select3"];
    [yoloView addSubview:upImage];
    
    myGifLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    //myGifLabel.center = CGPointMake(yoloView.center.x - 37.75, yoloView.center.y - 13.5);
    [myGifLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
    myGifLabel.textColor = [UIColor whiteColor];
    myGifLabel.textAlignment = NSTextAlignmentCenter;
    myGifLabel.text = @"My GIFs";
    [myGifLabel sizeToFit];
    myGifLabel.center = yoloView.center;
    [yoloView addSubview:myGifLabel];
    
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    gifView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, (60*(scaleFactor > 1 ? scaleFactor : 1)), [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height - (60*(scaleFactor > 1 ? scaleFactor : 1))) collectionViewLayout:layout];
    [gifView setDataSource:self];
    [gifView setDelegate:self];
    //gifView.scrollEnabled =YES;
    
    [gifView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [gifView registerClass:[AlbumCoverCell class] forCellWithReuseIdentifier:@"albumIdentifier"];

    [gifView setBackgroundColor:[UIColor clearColor]];
    
    //[self.view addSubview: gifView];
    
    [dragView addSubview: gifView];
    
    fullView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20))];
    fullView.backgroundColor = [UIColor clearColor];
    fullView.layer.opacity = 0.0;
    fullView.hidden = YES;
    
    UIVisualEffectView *thisf = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    thisf.frame = fullView.bounds;
    [fullView addSubview:thisf];
    
    bigView = [[FLAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    bigView.layer.cornerRadius = 20.0;
    bigView.clipsToBounds = YES;
    bigView.hidden = YES;
    
    [fullView addSubview:bigView];
    
    UIView *tView = [[UIView alloc]initWithFrame:bigView.frame];
    
    tView.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tapBro = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goAway)];
    tapBro.numberOfTapsRequired = 1;
    [tView addGestureRecognizer:tapBro];
    
    [fullView addSubview:tView];
    
  //  UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width - 100 + (self.navigationController.navigationBar.frame.size.height + 20))/4 + [UIScreen mainScreen].bounds.size.width, self.view.frame.size.width, 100)];
    
    thisScroller = [[UIScrollView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width + 30, bigView.frame.size.height, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - bigView.frame.size.height)];

    
    int x = 0;
    for (int i = 0; i < 7; i++) {
        SpecialButton *button = [[SpecialButton alloc] initWithFrame:CGRectMake(x+15, (thisScroller.frame.size.height -100)/2, 100, 100)];
        
    //    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    //    [button addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
   //     [button addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];

        if (i == 0){
            
            [button setImage:[UIImage imageNamed:@"save"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"Save"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(savePic) forControlEvents:UIControlEventTouchUpInside];
            
        } else if (i == 1){
            
            [button setImage:[UIImage imageNamed:@"copy"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"Copy"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(copyPic) forControlEvents:UIControlEventTouchUpInside];
            
        } else if (i == 2){
        
            [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"Delete"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(deletePic) forControlEvents:UIControlEventTouchUpInside];
            
        } else if (i == 3){
            
            [button setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"Message"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(messagePic) forControlEvents:UIControlEventTouchUpInside];
            //[button.titleLabel sizeToFit];
        } else if (i == 4){
            
            [button setImage:[UIImage imageNamed:@"messenger"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"Messenger"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(messengerPic) forControlEvents:UIControlEventTouchUpInside];
        
        //} else if (i == 5) {
        
         //   [button setImage:[UIImage imageNamed:@"facebookstuff"] forState:UIControlStateNormal];
         //   [button setTitle:[NSString stringWithFormat:@"Facebook"] forState:UIControlStateNormal];
         //   [button addTarget:self action:@selector(facebookPic) forControlEvents:UIControlEventTouchUpInside];
        
        } else if (i == 5){
        
            [button setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"Twitter"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(twitterPic) forControlEvents:UIControlEventTouchUpInside];
        
        } else if(i == 6){
        
            [button setImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"Email"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(emailPic) forControlEvents:UIControlEventTouchUpInside];
        

        } else {
            
            [button setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
            [button setTitle:[NSString stringWithFormat:@"More"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(morePic) forControlEvents:UIControlEventTouchUpInside];
            
        }
        [thisScroller addSubview:button];
        
        x += button.frame.size.width;
    }
    
    thisScroller.contentSize = CGSizeMake(x + 20, thisScroller.frame.size.height);
    //scrollView.backgroundColor = [UIColor redColor];
    
    [fullView addSubview:thisScroller];
    
    [thisScroller setShowsHorizontalScrollIndicator:NO];
    [thisScroller setShowsVerticalScrollIndicator:NO];
    
    [dragView insertSubview:fullView atIndex:30];
    
//    [self.view addSubview:dragView];
    
    
    [super viewDidLoad];
    
    [thisTimer invalidate];
    
    
    
    /*                 BAR SHIT
    /
    /
    /
    /
    /
    /
    /*/
     
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:18.0/256.0 green:234.0/256.0 blue:150.0/256.0 alpha:1];
        self.navigationController.navigationBar.translucent = YES;
        //self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.15234375 green:1 blue:0.9296875 alpha:1];
        //self.tabBarController.tabBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:18.0/256.0 green:234.0/256.0 blue:150.0/256.0 alpha:1];
        //self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.15234375 green:1 blue:0.9296875 alpha:1];
    }
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onButtonDoneClicked)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsPage)];

    //self.navigationController.title = @"Make a GIF";
    
    //self.title = @"FaceZoom";
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setTintColor:[UIColor whiteColor]];
        
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo2"]];
    self.navigationItem.titleView.userInteractionEnabled =YES;
    
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(backBoi:)];
    [self.navigationItem.titleView addGestureRecognizer:singleFingerTap];
    
    
    //self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.078125 green:0.921875 blue:0.59765625 alpha:1];
    
    
    UIColor *backgroundColor = [UIColor colorWithRed:0.96 green:0.95 blue:0.94 alpha:1];
    
    // set the bar background color
    //[self.tabBarController.tabBar setBackgroundImage:[self imageFromColor:backgroundColor forSize:CGSizeMake(320, 49) withCornerRadius:0]];
    
    // set the text color for selected state
    [self.tabBarController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateSelected];
    // set the text color for unselected state
    [self.tabBarController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    // set the selected icon color
    [self.tabBarController.tabBar setTintColor:[UIColor whiteColor]];
    [self.tabBarController.tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    // remove the shadow
    [self.tabBarController.tabBar setShadowImage:nil];
    
    // Set the dark color to selected tab (the dimmed background)
    //[self.tabBarController.tabBar setSelectionIndicatorImage:[self imageFromColor:[UIColor colorWithRed:0 green:0.84375 blue:0.28125 alpha:1] forSize:CGSizeMake(188, 49) withCornerRadius:0]];
    [self.tabBarController.tabBar setSelectionIndicatorImage:[self imageFromColor:[UIColor colorWithRed:0.20 green:0.80859375 blue:0.57421875 alpha:1] forSize:CGSizeMake(188, 49) withCornerRadius:0]];
    
    //[UIColor colorWithRed:0 green:0.84375 blue:0.28125 alpha:1];
    
    /*                  END OF BAR SHIT
     /
     /
     /
     /
     /
     /
     /*/
    

    
    
    
   // myLabel = [[THLabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/6, 125, 2*[UIScreen mainScreen].bounds.size.width/3, 66)];
    
    myLabel = [[THLabel alloc]initWithFrame:CGRectZero];
    
    [myLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:(20.0f*scaleFactor)]];
    myLabel.textColor = [UIColor whiteColor];
    myLabel.textAlignment = NSTextAlignmentCenter;

    myLabel.text = @"Create a GIF";
    
    myLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 - (58*scaleFactor), 170 * scaleFactor);
    
    [myLabel sizeToFit];
    
    [backgroundView addSubview:myLabel];
        
    selectView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (28.125*scaleFactor), 228 * scaleFactor, 56.25 * scaleFactor, 26.25 * scaleFactor)];
    
    selectView.image = [UIImage imageNamed:@"select4"];
    
    pulseTimer =   [NSTimer scheduledTimerWithTimeInterval:0.8
                                                target:self
                                                selector:@selector(pulseImageView)
                                                userInfo:nil
                                                repeats:YES];
    
    [self pulseImageView];
    
    [backgroundView addSubview:selectView];
    
    chooseFromPictures = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), (150*scaleFactor))];
    
    if (scaleFactor < 1){
        [chooseFromPictures setImage:[UIImage imageNamed:@"p_newsmall"] forState:UIControlStateNormal];
    } else {
        [chooseFromPictures setImage:[UIImage imageNamed:@"p_new"] forState:UIControlStateNormal];
    }
    [chooseFromPictures addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [chooseFromPictures addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
    [chooseFromPictures addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];
    [chooseFromPictures addTarget:self action:@selector(getPics) forControlEvents:UIControlEventTouchUpInside];

    
    chooseFromPictures.transform = CGAffineTransformMakeScale(0.1,0.1);
    
    chooseFromPictures.adjustsImageWhenHighlighted = NO;
    [backgroundView addSubview:chooseFromPictures];
    
    chooseFromFacebook = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), (150*scaleFactor))];
    
    if (scaleFactor < 1){
        [chooseFromFacebook setImage:[UIImage imageNamed:@"f_newsmall"] forState:UIControlStateNormal];
    } else {
        [chooseFromFacebook setImage:[UIImage imageNamed:@"f_new"] forState:UIControlStateNormal];
    }
    [chooseFromFacebook addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [chooseFromFacebook addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
    [chooseFromFacebook addTarget:self action:@selector(pickFromFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [chooseFromFacebook addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];
    
    chooseFromFacebook.transform = CGAffineTransformMakeScale(0.1,0.1);
    
    chooseFromFacebook.adjustsImageWhenHighlighted = NO;
    [backgroundView addSubview:chooseFromFacebook];
    
    chooseFromInsta = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), (150*scaleFactor))];
    if (scaleFactor < 1){
        [chooseFromInsta setImage:[UIImage imageNamed:@"i_newsmall"] forState:UIControlStateNormal];
    } else {
        [chooseFromInsta setImage:[UIImage imageNamed:@"i_new"] forState:UIControlStateNormal];
    }
    [chooseFromInsta addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [chooseFromInsta addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
    [chooseFromInsta addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];
    [chooseFromInsta addTarget:self action:@selector(getInsta) forControlEvents:UIControlEventTouchUpInside];
    
    chooseFromInsta.transform = CGAffineTransformMakeScale(0.1,0.1);

    chooseFromInsta.adjustsImageWhenHighlighted = NO;
    [backgroundView addSubview:chooseFromInsta];
    
    cameraButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), (150*scaleFactor))];
    
    if (scaleFactor < 1){
        [cameraButton setImage:[UIImage imageNamed:@"c_newsmall"] forState:UIControlStateNormal];
    } else {
        [cameraButton setImage:[UIImage imageNamed:@"c_new"] forState:UIControlStateNormal];
    }
    [cameraButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [cameraButton addTarget:self action:@selector(pickFromCamera:) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];

    cameraButton.transform = CGAffineTransformMakeScale(0.1,0.1);
    
    cameraButton.adjustsImageWhenHighlighted = NO;
    [backgroundView addSubview:cameraButton];
    
    
    zoomButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), (150*scaleFactor))];
    
    if (scaleFactor < 1){
        [zoomButton setImage:[UIImage imageNamed:@"sbuttonsmall"] forState:UIControlStateNormal];
    } else {
        [zoomButton setImage:[UIImage imageNamed:@"sbutton"] forState:UIControlStateNormal];
    }
    [zoomButton addTarget:self action:@selector(showButtons:) forControlEvents:UIControlEventTouchUpInside];
    [zoomButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    //[zoomButton addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
    [zoomButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpOutside];
 
    zoomButton.adjustsImageWhenHighlighted = NO;
    [backgroundView addSubview:zoomButton];
    
  //  NSTimer *thatTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(animateBackground) userInfo:nil repeats:YES];
    [self.view insertSubview:dragView aboveSubview:zoomButton];


}

-(void)backBoi:(UITapGestureRecognizer *)tapper{
    UIView *tV = tapper.view;
    
    if ((tapper.state == UIGestureRecognizerStateEnded || tapper.state == UIGestureRecognizerStateCancelled || tapper.state == UIGestureRecognizerStateFailed) && allKnowingInt != 0){
        
        [UIView animateWithDuration:0.09
                              delay:0.0
                            options: UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             tV.transform = CGAffineTransformMakeScale(1.15,1.15);}
                         completion:^(BOOL finished){
                             
                             //[self animateBack];
                             
                             [UIView animateWithDuration:0.09
                                                   delay:0.0
                                                 options: UIViewAnimationOptionAllowUserInteraction
                                              animations:^{
                                                  tV.transform = CGAffineTransformMakeScale(0.95,0.95);}
                                              completion:^(BOOL finished){
                                                  [UIView animateWithDuration:0.09
                                                                        delay:0.0
                                                                      options: UIViewAnimationOptionAllowUserInteraction
                                                                   animations:^{
                                                                       tV.transform = CGAffineTransformMakeScale(1,1);
                                                                   }
                                                                   completion:nil];
                                                  
                                              }
                              ];
                         }];

        
    }
    
    if (allKnowingInt == 1){
        //if (yoloUp == NO) {
            
            
            [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
                
                
                dragView.frame = CGRectMake(20, [UIScreen mainScreen].bounds.size.height - (60*scaleFactor), [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height);
                
                yoloView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-40, (60*scaleFactor));
                
                gView.frame = dragView.bounds;//CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88);
                
                gifView.frame = CGRectMake(0, (60*(scaleFactor > 1 ? scaleFactor : 1)), [UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height - (60*(scaleFactor > 1 ? scaleFactor : 1)) - 84);
                
                upImage.transform = CGAffineTransformMake(1, 0, 0, upImage.transform.d * -1, 0, upImage.transform.ty);
                
                myGifLabel.center = CGPointMake(yoloView.center.x, yoloView.center.y);
                
                isUp = NO;
                
                yoloUp = NO;
                
                allKnowingInt = 0;
                
                NSLog(@"LOOOOOOL");
                
            } completion:nil];
        //}
    } else if (allKnowingInt == 2) {
        
        
        allKnowingInt = 0;
        
        [thisTimer invalidate];
        selectView.hidden = NO;
        
        
        [label1 removeFromSuperview];
        [label2 removeFromSuperview];
        [label3 removeFromSuperview];
        [label4 removeFromSuperview];
        
        [UIView animateWithDuration:0.1 animations:^{
            
            zoomButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
            if (scaleFactor < 1){
                [zoomButton setImage:[UIImage imageNamed:@"sbuttonsmall"] forState:UIControlStateNormal];
            } else {
                [zoomButton setImage:[UIImage imageNamed:@"sbutton"] forState:UIControlStateNormal];
            }
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:0.10 animations:^{
                zoomButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
                
                
            } completion:^(BOOL finished){
                
                [UIView animateWithDuration:0.15 animations:^{
                    
                    zoomButton.transform = CGAffineTransformMakeScale(1.0, 1.0);

                } completion:nil];
                
                
                
            }];
            
        }];
        
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationCurveLinear
                         animations:^{
                             
                             dragView.frame = CGRectMake(dragView.frame.origin.x, dragView.frame.origin.y - 70, dragView.frame.size.width, dragView.frame.size.height);
                             
                             
                             cameraButton.layer.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                             cameraButton.transform = CGAffineTransformMakeScale(1.0,1.0);
                             
                             chooseFromInsta.layer.frame =   CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), 150);
                             chooseFromInsta.transform = CGAffineTransformMakeScale(1.0,0.0);
                             
                             
                             chooseFromFacebook.layer.frame =   CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                             chooseFromFacebook.transform = CGAffineTransformMakeScale(1.0,1.0);
                             
                             chooseFromPictures.layer.frame =   CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                             chooseFromPictures.transform = CGAffineTransformMakeScale(1.0,1.0);
                             
                             selectView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 28.125, 228, 56.25, 26.25);
                             
                             [self pulseImageView];
                             
                             
                             pulseTimer =   [NSTimer scheduledTimerWithTimeInterval:0.8
                                                                             target:self
                                                                           selector:@selector(pulseImageView)
                                                                           userInfo:nil
                                                                            repeats:YES];
                              
                              
                         }
                         completion:^(BOOL finished){
                             
                             done = NO;
                             
                             myLabel.hidden = NO;
                             willShow = NO;
                             
                         }];

    } else if(allKnowingInt == 3){
        

        
            allKnowingInt = 0;
            [self.camera stop];
            [UIView animateWithDuration:0.35
                                  delay:0.0
                                options: UIViewAnimationCurveEaseInOut
                             animations:^{
                                 
                                 
                                 cameraButton.center = CGPointMake(cameraButton.center.x-20, cameraButton.center.y-75);
                                 chooseFromPictures.center = CGPointMake(chooseFromPictures.center.x+20, chooseFromPictures.center.y-75);
                                 chooseFromFacebook.center = CGPointMake(chooseFromFacebook.center.x-20, chooseFromFacebook.center.y+75);
                                 chooseFromInsta.center = CGPointMake(chooseFromInsta.center.x+20, chooseFromInsta.center.y+75);
                                 
                                 label1.center = CGPointMake(label1.center.x-20, label1.center.y-75);
                                 label2.center = CGPointMake(label2.center.x+20, label2.center.y-75);
                                 label3.center = CGPointMake(label3.center.x-20, label3.center.y+75);
                                 label4.center = CGPointMake(label4.center.x+20, label4.center.y+75);
                                 
                                 zoomButton.transform = CGAffineTransformMakeScale(1.15, 1.15);
                                 
                                 self.camera.view.center = CGPointMake(self.camera.view.center.x, -800);
                                 
                                 self.snapButton.center = CGPointMake(self.snapButton.center.x, 1200);
                                 self.flashButton.center = CGPointMake(self.flashButton.center.x, 1200);
                                 self.switchButton.center = CGPointMake(self.switchButton.center.x, 1200);
                                 

                             }
                             completion:^(BOOL finished){
                                 
                                 [self.camera.view removeFromSuperview];

                                 [self.camera removeFromParentViewController];
                                 //[self.snapButton removeFromSuperview];
                                 //[self.flashButton removeFromSuperview];
                                 //[self.switchButton removeFromSuperview];
                                 
                                 [UIView animateWithDuration:0.15
                                                       delay:0.0
                                                     options: UIViewAnimationCurveEaseInOut
                                                  animations:^{
                                                      
                                                      cameraButton.center = CGPointMake(cameraButton.center.x+20, cameraButton.center.y+20);
                                                      chooseFromPictures.center = CGPointMake(chooseFromPictures.center.x-20, chooseFromPictures.center.y+20);
                                                      chooseFromFacebook.center = CGPointMake(chooseFromFacebook.center.x+20, chooseFromFacebook.center.y-20);
                                                      chooseFromInsta.center = CGPointMake(chooseFromInsta.center.x-20, chooseFromInsta.center.y-20);
                                                      
                                                      label1.center = CGPointMake(label1.center.x+20, label1.center.y+20);
                                                      label2.center = CGPointMake(label2.center.x-20, label2.center.y+20);
                                                      label3.center = CGPointMake(label3.center.x+20, label3.center.y-20);
                                                      label4.center = CGPointMake(label4.center.x-20, label4.center.y-20);
                                                      
                                                      zoomButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                                      
                                                  }
                                                  completion:^(BOOL finished){
                                                      
                                                      faceCount = 0;
                                                      camTouched = NO;
                                                      movedAlready = NO;
                                                      allKnowingInt = 2;
                                                      //selectView.hidden = NO;
                                                      
                                                  }
                                  ];
                                 
                             }];
        
        
        
        
    } else if(allKnowingInt == 4){
        
        [self goBackToHome:nil];
        
        
    } else if(allKnowingInt == 5){
        [self goAway];
    }
    
}







// SCROLLING BACKGROUND IMAGE BEGIN

-(void)getInsta{
    
    
    OLInstagramImagePickerController *imagePicker = [[OLInstagramImagePickerController alloc] initWithClientId:@"3d7c27278110404b8db084c7a43f8ba8" secret:@"347b70e6365e45ba8579b7d75d12d42b" redirectURI:@"ig3d7c27278110404b8db084c7a43f8ba8://authorize"];
    
    imagePicker.delegate = self;
    //imagePicker.selected = self.selectedImages;
    [self presentViewController:imagePicker animated:YES completion:nil];
 
    
    
}

-(void)showTheError{
    UIAlertView *thisAlert = [[UIAlertView alloc]initWithTitle:@"An error occurred." message:@"Please check your internet connection and try again." delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    //thisAlert.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
    [thisAlert show];
    [self applyCloudLayerAnimation];
}



//#pragma mark - OLInstagramImagePickerControllerDelegate methods

- (void)instagramImagePicker:(OLInstagramImagePickerController *)imagePicker didFailWithError:(NSError *)error {
    [self applyCloudLayerAnimation];
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"INSTA ERRORED");
    [self showTheError];
}

- (void)instagramImagePicker:(OLInstagramImagePickerController *)imagePicker didFinishPickingImages:(NSArray *)images {
    //self.selectedImages = images;
    
    if (movedAlready == YES && images.count <= 0){
        [self goBackToHome:nil];
    }
    
    if (images.count > 0){
        NSLog(@"IT'S ABOUT TO COME AHHH");
        NSLog(@"I'M HUGE: %@", NSStringFromCGSize(((UIImage *)[images objectAtIndex:0]).size));
        mySelectInt = 3;
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [self applyCloudLayerAnimation];
        UIImage *newImage;// = [self squareImageFromImage:((UIImage *)[images objectAtIndex:0]) scaledToSize:[UIScreen mainScreen].bounds.size.width-20];
        
        if (scaleFactor > 1){
            newImage = [self squareImageFromImage:((UIImage *)[images objectAtIndex:0]) scaledToSize:([UIScreen mainScreen].bounds.size.width-20)/(scaleFactor*401.0/326.0)];
        } else {
            newImage = [self squareImageFromImage:((UIImage *)[images objectAtIndex:0]) scaledToSize:[UIScreen mainScreen].bounds.size.width-20];
        }
        
        secretImage = ((UIImage *)[images objectAtIndex:0]);

        [self showPic:newImage];
    } else {
        [self applyCloudLayerAnimation];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    [self applyCloudLayerAnimation];

    //for (OLInstagramImage *image in images) {
    //    NSLog(@"User selected instagram image with full URL: %@", image.fullURL);
    //}
}

- (void)instagramImagePickerDidCancelPickingImages:(OLInstagramImagePickerController *)imagePicker {
    if (movedAlready == NO){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self applyCloudLayerAnimation];
    } else {
        [self goBackToHome:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self applyCloudLayerAnimation];
    }
    NSLog(@"INSTA CANCELLED");
}



-(void)animateBackground{
    [UIView transitionWithView:self.view
                      duration:3.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        bluredEffectView.hidden = NO;
                    } completion:nil];
}

-(void)imageScroll {
    
    
    /*
    FXBlurView *thisView = [[FXBlurView alloc]init];
    
    thisView.frame = [UIScreen mainScreen].bounds;
    thisView.blurEnabled = YES;
    thisView.blurRadius = 20;
    thisView.tintColor = [UIColor darkGrayColor];
    thisView.iterations = 5;
    thisView.layer.opacity = 0.6;
    thisView.dynamic = YES;
    
    [self.view addSubview:thisView];
    */
    
    UIImage *cloudsImage = [UIImage imageNamed:@"scrolling_background"];
    
   // cloudsImage = [UIImage blurr];
    
    cloudsImage = [cloudsImage blurredImageWithRadius:3 iterations:6 tintColor:[UIColor blackColor]];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    bluredEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    bluredEffectView.frame = [UIScreen mainScreen].bounds;
    
    [self.view insertSubview:bluredEffectView belowSubview:backgroundView];//] aboveSubview:<#(UIView *)#>:bluredEffectView];
    

    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(0, -cloudsImage.size.height);
    
    cloudLayer = [CALayer layer];
    CGSize viewSize = [UIScreen mainScreen].bounds.size;

    cloudLayer.frame = CGRectMake(0, 0, viewSize.width, cloudsImage.size.height + viewSize.height);
    
    UIColor *cloudPattern = [UIColor colorWithPatternImage:cloudsImage];
    cloudLayer.backgroundColor = cloudPattern.CGColor;
    
    cloudLayer.transform = CATransform3DMakeScale(1, -1, 1);
    
    cloudLayer.anchorPoint = CGPointMake(0, 1);
    
   // [self.view addSubview:thisView];
    
    [self.view.layer addSublayer:cloudLayer];
    
    cloudLayerAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    cloudLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    cloudLayerAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    cloudLayerAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    cloudLayerAnimation.repeatCount = HUGE_VALF;
    cloudLayerAnimation.duration = 12.0;
    
    [self applyCloudLayerAnimation];
}

-(void)applyCloud{
    //if ([cloudLayer animationForKey:@"position"] != cloudLayerAnimation){
    //    [cloudLayer addAnimation:cloudLayerAnimation forKey:@"position"];
   // }
}

- (void)applyCloudLayerAnimation {
    [cloudLayer addAnimation:cloudLayerAnimation forKey:@"position"];
    NSTimer *timeThis = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(applyCloud) userInfo:nil repeats:YES];
}

-(void)pulsateView{
    
    goingToNextView = [[UIView alloc]initWithFrame:CGRectMake(0,0,200,100)];
    goingToNextView.backgroundColor = [UIColor blackColor];
    goingToNextView.layer.opacity = 0.7;
    goingToNextView.layer.cornerRadius = 20.0;
    goingToNextView.clipsToBounds = YES;
    goingToNextView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    
    UILabel *badLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [badLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
    badLabel.textColor = [UIColor whiteColor];
    badLabel.textAlignment = NSTextAlignmentCenter;
    badLabel.text = @"Creating GIF...";
    [badLabel sizeToFit];
    badLabel.center = CGPointMake(100, 50);
    [goingToNextView addSubview:badLabel];
    
    [self.view addSubview:goingToNextView];
    
    [self pulseThis];
}

-(void)pulseThis{
    [UIView animateWithDuration:0.6 delay:0.0 options:nil animations:^{
        goingToNextView.transform = CGAffineTransformMakeScale(1.15, 1.15);
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.6 delay:0.0 options:nil animations:^{
            goingToNextView.transform = CGAffineTransformMakeScale(0.85, 0.85);
        } completion:^(BOOL finished){
            //[self theRestOfIt];
            [self pulseThis];
        }];
    }];
}


- (void)viewDidUnload {
   // [self setCloudsImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)note {
    [self applyCloudLayerAnimation];
}









-(void)pulseImageView{
    
    
    if (movedAlready == NO){

    
    [UIView animateWithDuration:0.4 animations:^{
        
    //    zoomButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
//        myView.frame = CGRectMake(myView.frame.origin.x, myView.frame.origin.y - 7, myView.frame.size.width, myView.frame.size.height);
        selectView.frame = CGRectMake(selectView.frame.origin.x, 203*scaleFactor, selectView.frame.size.width, selectView.frame.size.height);
        upImage.frame = CGRectMake(upImage.frame.origin.x, upImage.frame.origin.y + (10*scaleFactor), upImage.frame.size.width, upImage.frame.size.height);
        
        
      
        
    } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.4 animations:^{

//                    myView.frame = CGRectMake(myView.frame.origin.x, myView.frame.origin.y + 7, myView.frame.size.width, myView.frame.size.height);
  
            selectView.frame = CGRectMake(selectView.frame.origin.x, 213*scaleFactor, selectView.frame.size.width, selectView.frame.size.height);
            
            upImage.frame = CGRectMake(upImage.frame.origin.x, upImage.frame.origin.y - (10*scaleFactor), upImage.frame.size.width, upImage.frame.size.height);

            
        } completion:^(BOOL finished){
         
            
        }];
        
         }];
    
    }
    
}






// SCROLLING BACKGROUND IMAGE END


-(void)showButtons:(UIButton*)button {
    
    [self applyCloud];
    
    if (willShow == NO){
        willShow = YES;
    if (done == NO){
        
    
        [pulseTimer invalidate];

        
        [UIView animateWithDuration:0.15 animations:^{
        
            zoomButton.transform = CGAffineTransformMakeScale(0.01, 0.01);

            dragView.frame = CGRectMake(dragView.frame.origin.x, dragView.frame.origin.y + 70, dragView.frame.size.width, dragView.frame.size.height);
        
        
        } completion:^(BOOL finished){
            
            if (scaleFactor < 1){
                [zoomButton setImage:[UIImage imageNamed:@"backsmall"] forState:UIControlStateNormal];
            } else {
                [zoomButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            }
            [UIView animateWithDuration:0.1 animations:^{
                zoomButton.transform = CGAffineTransformMakeScale(1.3, 1.3);

            
            } completion:^(BOOL finished){
                
                [UIView animateWithDuration:0.15 animations:^{
                
                    zoomButton.transform = CGAffineTransformMakeScale(1.0, 1.0);

                    //[zoomButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
                   // [zoomButton addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
                  //  [zoomButton addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];
                
                } completion:nil];
                
                
                
            }];
            
        }];
        
        
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationCurveLinear
                     animations:^{
                         cameraButton.transform = CGAffineTransformMakeTranslation(115, 120);
                         cameraButton.layer.frame = CGRectMake(cameraButton.frame.origin.x-(105*scaleFactor), cameraButton.frame.origin.y - (120*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                         cameraButton.transform = CGAffineTransformMakeScale(1.2,1.2);

                         chooseFromInsta.transform = CGAffineTransformMakeTranslation(115, 120);
                         chooseFromInsta.layer.frame = CGRectMake(chooseFromInsta.frame.origin.x+(115*scaleFactor), chooseFromInsta.frame.origin.y + (120*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                         chooseFromInsta.transform = CGAffineTransformMakeScale(1.2,1.2);
                         
                         
                         chooseFromFacebook.transform = CGAffineTransformMakeTranslation(115, 120);
                         chooseFromFacebook.layer.frame = CGRectMake(chooseFromFacebook.frame.origin.x-(105*scaleFactor), chooseFromFacebook.frame.origin.y + (120*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                         chooseFromFacebook.transform = CGAffineTransformMakeScale(1.2,1.2);
                         
                         chooseFromPictures.transform = CGAffineTransformMakeTranslation(115, 120);
                         chooseFromPictures.layer.frame = CGRectMake(chooseFromPictures.frame.origin.x+(115*scaleFactor), chooseFromPictures.frame.origin.y - (120*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                         chooseFromPictures.transform = CGAffineTransformMakeScale(1.2,1.2);
                         
                         selectView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 37.5, 320*scaleFactor, 75, 35);
                         
                         selectView.transform = CGAffineTransformMakeScale(0.01,0.01);
                         
                         
                        // zoomButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2, 0, 0);
                         //[myLabel removeFromSuperview];
                         myLabel.hidden = YES;
                         
                         [zoomButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
                         
                         [UIView animateWithDuration:0.2
                                               delay:0.0
                                             options: UIViewAnimationCurveLinear
                                          animations:^{
                                              
                                              //                                              zoomButton.transform = CGAffineTransformMakeScale(1, 1);
                                              
                                              //zoomButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-56, [UIScreen mainScreen].bounds.size.height-56, 112, 112);
                                              
                                              cameraButton.transform = CGAffineTransformMakeScale(1.0,1.0);
                                              //cameraButton.transform = CGAffineTransformMakeTranslation(10, 10);
                                              cameraButton.layer.frame = CGRectMake(cameraButton.frame.origin.x+(5*scaleFactor), cameraButton.frame.origin.y + (10*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                                              
                                              chooseFromInsta.transform = CGAffineTransformMakeScale(1.0,1.0);
                                              // chooseFromInsta.transform = CGAffineTransformMakeTranslation(10, 10);
                                              chooseFromInsta.layer.frame = CGRectMake(chooseFromInsta.frame.origin.x-(15*scaleFactor), chooseFromInsta.frame.origin.y - (10*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                                              
                                              chooseFromFacebook.transform = CGAffineTransformMakeTranslation(15, 10);
                                              chooseFromFacebook.layer.frame = CGRectMake(chooseFromFacebook.frame.origin.x+(5*scaleFactor), chooseFromFacebook.frame.origin.y - (10*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                                              chooseFromFacebook.transform = CGAffineTransformMakeScale(1.0,1.0);
                                              
                                              chooseFromPictures.transform = CGAffineTransformMakeTranslation(5, 10);
                                              chooseFromPictures.layer.frame = CGRectMake(chooseFromPictures.frame.origin.x-(15*scaleFactor), chooseFromPictures.frame.origin.y + (10*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                                              chooseFromPictures.transform = CGAffineTransformMakeScale(1.0,1.0);
                                              
                                              
                                              
                                          }
                                          completion:^(BOOL finished){
                                              selectView.hidden = YES;

                                              //NSLog(@"COMPARING: FB origin: %@, and INSTA origin: %@", NSStringFromCGPoint(chooseFromFacebook.frame.origin), NSStringFromCGPoint(CGPointMake([UIScreen mainScreen].bounds.size.width - chooseFromInsta.frame.origin.x - chooseFromInsta.frame.size.width, chooseFromInsta.frame.origin.y)));
                                              
                                              label1 = [[THLabel alloc] initWithFrame:CGRectZero];
                                              label1.numberOfLines = 1;
                                              label1.text = @"Camera";
                                              //label.lineBreakMode = NSLineBreakByWordWrapping;
                                              label1.backgroundColor = [UIColor clearColor];
                                              label1.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0f];
                                              //faceLabel.textColor = [UIColor whiteColor];
                                              label1.textColor = [UIColor colorWithRed:246.0/256.0 green:246.0/256.0 blue:246.0/256.0 alpha:1.0];
                                              label1.textAlignment = NSTextAlignmentCenter;
                                              [label1 sizeToFit];
                                              label1.center = cameraButton.center;
                                              label1.layer.opacity = 0.0;
                                              //label1.center = CGPointMake(cameraButton.center.x, cameraButton.center.y+65);
                                              [backgroundView insertSubview:label1 belowSubview:cameraButton];
                                              
                                              label2 = [[THLabel alloc] initWithFrame:CGRectZero];
                                              label2.numberOfLines = 1;
                                              label2.text = @"My Pictures";
                                              //label.lineBreakMode = NSLineBreakByWordWrapping;
                                              label2.backgroundColor = [UIColor clearColor];
                                              label2.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0f];
                                              //faceLabel.textColor = [UIColor whiteColor];
                                              label2.textColor = [UIColor colorWithRed:246.0/256.0 green:246.0/256.0 blue:246.0/256.0 alpha:1.0];
                                              label2.textAlignment = NSTextAlignmentCenter;
                                              [label2 sizeToFit];
                                              label2.center = chooseFromPictures.center;
                                              label2.layer.opacity = 0.0;
                                              //label1.center = CGPointMake(cameraButton.center.x, cameraButton.center.y+65);
                                              [backgroundView insertSubview:label2 belowSubview:chooseFromPictures];
                                              
                                              
                                              label3 = [[THLabel alloc] initWithFrame:CGRectZero];
                                              label3.numberOfLines = 1;
                                              label3.text = @"Facebook";
                                              //label.lineBreakMode = NSLineBreakByWordWrapping;
                                              label3.backgroundColor = [UIColor clearColor];
                                              label3.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0f];
                                              //faceLabel.textColor = [UIColor whiteColor];
                                              label3.textColor = [UIColor colorWithRed:246.0/256.0 green:246.0/256.0 blue:246.0/256.0 alpha:1.0];
                                              label3.textAlignment = NSTextAlignmentCenter;
                                              [label3 sizeToFit];
                                              label3.center = chooseFromFacebook.center;
                                              label3.layer.opacity = 0.0;
                                              //label1.center = CGPointMake(cameraButton.center.x, cameraButton.center.y+65);
                                              [backgroundView insertSubview:label3 belowSubview:chooseFromFacebook];
                                              
                                              
                                              label4 = [[THLabel alloc] initWithFrame:CGRectZero];
                                              label4.numberOfLines = 1;
                                              label4.text = @"Instagram";
                                              //label.lineBreakMode = NSLineBreakByWordWrapping;
                                              label4.backgroundColor = [UIColor clearColor];
                                              label4.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0f];
                                              //faceLabel.textColor = [UIColor whiteColor];
                                              label4.textColor = [UIColor colorWithRed:246.0/256.0 green:246.0/256.0 blue:246.0/256.0 alpha:1.0];
                                              label4.textAlignment = NSTextAlignmentCenter;
                                              [label4 sizeToFit];
                                              label4.center = chooseFromInsta.center;
                                              label4.layer.opacity = 0.0;
                                              //label1.center = CGPointMake(cameraButton.center.x, cameraButton.center.y+65);
                                              [backgroundView insertSubview:label4 belowSubview:chooseFromInsta];
                                              
                                              [UIView animateWithDuration:0.2 animations:^{
                                                  
                                                  label1.center = CGPointMake(cameraButton.center.x, cameraButton.center.y-68);
                                                  label2.center = CGPointMake(chooseFromPictures.center.x, chooseFromPictures.center.y-68);
                                                  label3.center = CGPointMake(chooseFromFacebook.center.x, chooseFromFacebook.center.y+68);
                                                  label4.center = CGPointMake(chooseFromInsta.center.x, chooseFromInsta.center.y+68);
                                                  
                                                  label1.layer.opacity = 1.0;
                                                  label2.layer.opacity = 1.0;
                                                  label3.layer.opacity = 1.0;
                                                  label4.layer.opacity = 1.0;
                                                  
                                                  

                                              } completion:^(BOOL finished){
                                                     //                                               selectView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 37.5, 320, 75, 35);
                                                  willShow = NO;
                                                  allKnowingInt = 2;


                                              }];
                                              
                                              
                                          }
                          ];

                         
                     }
                     completion:^(BOOL finished){
                         
                         //[zoomButton removeFromSuperview];
                         done = YES;

                                              }];
        
        //NSTimer *thisTimed = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(animateButton) userInfo:nil repeats:NO];
        
        /*
        thisTimer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                                     target:self
                                                   selector:@selector(animateButton)
                                                   userInfo:nil
                                                    repeats:YES];
*/
        
    } else {
        
        [thisTimer invalidate];
        selectView.hidden = NO;

        allKnowingInt = 0;
        
        [label1 removeFromSuperview];
        [label2 removeFromSuperview];
        [label3 removeFromSuperview];
        [label4 removeFromSuperview];
        
        [UIView animateWithDuration:0.1 animations:^{
            
            zoomButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
            if (scaleFactor < 1){
                [zoomButton setImage:[UIImage imageNamed:@"sbuttonsmall"] forState:UIControlStateNormal];
            } else {
                [zoomButton setImage:[UIImage imageNamed:@"sbutton"] forState:UIControlStateNormal];
            }
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:0.10 animations:^{
                zoomButton.transform = CGAffineTransformMakeScale(1.3, 1.3);
                
                
            } completion:^(BOOL finished){
                
                [UIView animateWithDuration:0.15 animations:^{
                    
                    zoomButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    
                    //[zoomButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
                    //[zoomButton addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpInside];
                    //[zoomButton addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchUpOutside];
                    
                } completion:nil];
                
                
                
            }];
            
        }];
        
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationCurveLinear
                         animations:^{
                             
                             dragView.frame = CGRectMake(dragView.frame.origin.x, dragView.frame.origin.y - 70, dragView.frame.size.width, dragView.frame.size.height);

                             
                            // cameraButton.transform = CGAffineTransformMakeTranslation(115, 120);
                             cameraButton.layer.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                             cameraButton.transform = CGAffineTransformMakeScale(1.0,1.0);
                             
                           //  chooseFromInsta.transform = CGAffineTransformMakeTranslation(115, 120);
                            chooseFromInsta.layer.frame =   CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), 150);
                             chooseFromInsta.transform = CGAffineTransformMakeScale(1.0,0.0);
                             
                             
                           //  chooseFromFacebook.transform = CGAffineTransformMakeTranslation(115, 120);
                            chooseFromFacebook.layer.frame =   CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                             chooseFromFacebook.transform = CGAffineTransformMakeScale(1.0,1.0);
                             
                           //  chooseFromPictures.transform = CGAffineTransformMakeTranslation(115, 120);
                            chooseFromPictures.layer.frame =   CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (75*scaleFactor), [UIScreen mainScreen].bounds.size.height/2 - (75*scaleFactor), (150*scaleFactor), (150*scaleFactor));
                             chooseFromPictures.transform = CGAffineTransformMakeScale(1.0,1.0);
                             
                            // selectView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 37.5, 208, 75, 35);

                             selectView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 28.125, 228, 56.25, 26.25);
                             
                             [self pulseImageView];
                             
                             pulseTimer =   [NSTimer scheduledTimerWithTimeInterval:0.8
                                                                             target:self
                                                                           selector:@selector(pulseImageView)
                                                                           userInfo:nil
                                                                            repeats:YES];
                             // zoomButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2, 0, 0);
                           //  [myLabel removeFromSuperview];
                         }
                         completion:^(BOOL finished){
                             
                             
                             //[zoomButton removeFromSuperview];
                             
                             //[zoomButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
                             /*
                             [UIView animateWithDuration:0.3
                                                   delay:0.0
                                                 options: UIViewAnimationCurveLinear
                                              animations:^{
                                                  
                                                  //                                              zoomButton.transform = CGAffineTransformMakeScale(1, 1);
                                                  
                                                  //zoomButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-56, [UIScreen mainScreen].bounds.size.height-56, 112, 112);
                                                  
                                                  cameraButton.transform = CGAffineTransformMakeScale(1.0,1.0);
                                                  //cameraButton.transform = CGAffineTransformMakeTranslation(10, 10);
                                                  cameraButton.layer.frame = CGRectMake(cameraButton.frame.origin.x+5, cameraButton.frame.origin.y + 10, 150, 150);
                                                  
                                                  chooseFromInsta.transform = CGAffineTransformMakeScale(1.0,1.0);
                                                  // chooseFromInsta.transform = CGAffineTransformMakeTranslation(10, 10);
                                                  chooseFromInsta.layer.frame = CGRectMake(chooseFromInsta.frame.origin.x-15, chooseFromInsta.frame.origin.y - 10, 150, 150);
                                                  
                                                  chooseFromFacebook.transform = CGAffineTransformMakeTranslation(15, 10);
                                                  chooseFromFacebook.layer.frame = CGRectMake(chooseFromFacebook.frame.origin.x+5, chooseFromFacebook.frame.origin.y - 10, 150, 150);
                                                  chooseFromFacebook.transform = CGAffineTransformMakeScale(1.0,1.0);
                                                  
                                                  chooseFromPictures.transform = CGAffineTransformMakeTranslation(5, 10);
                                                  chooseFromPictures.layer.frame = CGRectMake(chooseFromPictures.frame.origin.x-15, chooseFromPictures.frame.origin.y + 10, 150, 150);
                                                  chooseFromPictures.transform = CGAffineTransformMakeScale(1.0,1.0);
                                                  
                                                  
                                              }
                                              completion:nil
                              ];
                              
                              */
                             done = NO;

                             myLabel.hidden = NO;
                             willShow = NO;

                         }];
        

        
        
    }
    }
    
}

- (void) animateButton {
    
    //NSLog(@"THIS HAPPENED");
    
//    [UIView beginAnimations:@"ScaleButton" context:NULL];
//    [UIView setAnimationDuration: 0.3f];
//    cameraButton.transform = CGAffineTransformMakeScale(1.1,1.1);
//    [UIView commitAnimations];
  
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         cameraButton.transform = CGAffineTransformMakeScale(1.2,1.2);}
                     completion:^(BOOL finished){
                         
                         //[self animateBack];
                         
                         [UIView animateWithDuration:0.15
                                               delay:0.0
                                             options: UIViewAnimationCurveEaseInOut
                                          animations:^{
                                              cameraButton.transform = CGAffineTransformMakeScale(1.0,1.0);}
                                          completion:nil
                          ];
                     }];
    
    [UIView animateWithDuration:0.15
                          delay:0.10
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         chooseFromPictures.transform = CGAffineTransformMakeScale(1.2,1.2);}
                     completion:^(BOOL finished){
                         
                         //[self animateBack];
                         
                         [UIView animateWithDuration:0.15
                                               delay:0.0
                                             options: UIViewAnimationCurveEaseInOut
                                          animations:^{
                                              chooseFromPictures.transform = CGAffineTransformMakeScale(1.0,1.0);}
                                          completion:nil
                          ];
                     }];
    
    [UIView animateWithDuration:0.15
                          delay:0.18
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         chooseFromFacebook.transform = CGAffineTransformMakeScale(1.2,1.2);}
                     completion:^(BOOL finished){
                         
                         //[self animateBack];
                         
                         [UIView animateWithDuration:0.15
                                               delay:0.0
                                             options: UIViewAnimationCurveEaseInOut
                                          animations:^{
                                              chooseFromFacebook.transform = CGAffineTransformMakeScale(1.0,1.0);}
                                          completion:nil
                          ];
                     }];
    
    [UIView animateWithDuration:0.15
                          delay:0.26
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         chooseFromInsta.transform = CGAffineTransformMakeScale(1.2,1.2);}
                     completion:^(BOOL finished){
                         
                         //[self animateBack];
                         
                         [UIView animateWithDuration:0.15
                                               delay:0.0
                                             options: UIViewAnimationCurveEaseInOut
                                          animations:^{
                                              chooseFromInsta.transform = CGAffineTransformMakeScale(1.0,1.0);}
                                          completion:nil
                          ];
                     }];
    
   // [self animateBack];
    /*
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.12f];
    cameraButton.transform = CGAffineTransformMakeScale(1.0,1.0);
    [UIView commitAnimations];
     */
}

-(void) animateBack {
    NSLog(@"Got here");
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.3f];
    cameraButton.transform = CGAffineTransformMakeScale(1.0,1.0);
    [UIView commitAnimations];
}

- (void) buttonPress:(UIButton*)button {
    [thisTimer invalidate];
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.12f];
    button.transform = CGAffineTransformMakeScale(0.9,0.9);
    [UIView commitAnimations];
}

// Scale down on button release
- (void) buttonRelease:(UIButton*)button {
   if (!thisTimer.isValid){
       /* thisTimer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                                     target:self
                                                   selector:@selector(animateButton)
                                                   userInfo:nil
                                                    repeats:YES];
        */
    }

    [UIView animateWithDuration:0.09
                          delay:0.0
                        options: UIViewAnimationCurveLinear
                     animations:^{
                         button.transform = CGAffineTransformMakeScale(1.15,1.15);}
                     completion:^(BOOL finished){
                         
                         //[self animateBack];
                         
                         [UIView animateWithDuration:0.09
                                               delay:0.0
                                             options: UIViewAnimationCurveLinear
                                          animations:^{
                                              button.transform = CGAffineTransformMakeScale(0.95,0.95);}
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.09
                                                                    delay:0.0
                                                                  options: UIViewAnimationCurveEaseInOut
                                                               animations:^{
                                                                   button.transform = CGAffineTransformMakeScale(1,1);}
                                                               completion:nil];

                                          }
                          ];
                     }];
}

- (void)buttonReleased:(UIButton *)button {
    [UIView animateWithDuration:0.09
                          delay:0.0
                        options: UIViewAnimationCurveLinear
                     animations:^{
                         button.transform = CGAffineTransformMakeScale(1.15,1.15);}
                     completion:^(BOOL finished){
                         
                         //[self animateBack];
                         
                         [UIView animateWithDuration:0.09
                                               delay:0.0
                                             options: UIViewAnimationCurveLinear
                                          animations:^{
                                              button.transform = CGAffineTransformMakeScale(0.95,0.95);}
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.09
                                                                    delay:0.0
                                                                  options: UIViewAnimationCurveEaseInOut
                                                               animations:^{
                                                                   button.transform = CGAffineTransformMakeScale(1,1);
                                                               }
                                                               completion:nil];
                                              
                                          }
                          ];
                     }];
}

- (void)pickFromImages:(id)sender {
    
    if (willShow == NO){
    
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.allowsEditing = YES;
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_imagePicker animated:YES completion:NULL];
    }
}

-(void)getInstagram{
    
    
    if (willShow == NO){
    OLInstagramImagePickerController *imagePicker = [[OLInstagramImagePickerController alloc] initWithClientId:@"3d7c27278110404b8db084c7a43f8ba8" secret:@"347b70e6365e45ba8579b7d75d12d42b" redirectURI:@"ig3d7c27278110404b8db084c7a43f8ba8://authorize"];
    
    imagePicker.delegate = self;
    //imagePicker.selected = self.selectedImages;
    [self presentViewController:imagePicker animated:YES completion:nil];

    
    
    [UIView animateWithDuration:1.0 delay:0.0 options:nil animations:^{
        
        //     totalAddedFrames = 0;
        self.myImageView.layer.opacity = 0.0;
        self.faceLabel.layer.opacity = 0.0;
        self.faceLabel2.layer.opacity = 0.0;
        self.camBack.layer.opacity = 0.0;
        self.camBackLabel.layer.opacity = 0.0;
        self.camAgain.layer.opacity = 0.0;
        self.camAgainLabel.layer.opacity = 0.0;
        self.addRect.layer.opacity = 0.0;
        self.addRectLabel.layer.opacity = 0.0;
        
        
    } completion:^(BOOL finished){
        
        [self.myImageView removeFromSuperview];
        [self.faceLabel removeFromSuperview];
        [self.faceLabel2 removeFromSuperview];
        [self.camBack removeFromSuperview];
        [self.camBackLabel removeFromSuperview];
        [self.camAgain removeFromSuperview];
        [self.camAgainLabel removeFromSuperview];
        [self.addRect removeFromSuperview];
        [self.addRectLabel removeFromSuperview];
        
        
    }];
    
    
    }
}

-(void)getFacebook{
    
    if (willShow == NO){
    
    OLFacebookImagePickerController *picker = [[OLFacebookImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
    
    [UIView animateWithDuration:1.0 delay:0.0 options:nil animations:^{
        
        //     totalAddedFrames = 0;
        self.myImageView.layer.opacity = 0.0;
        self.faceLabel.layer.opacity = 0.0;
        self.faceLabel2.layer.opacity = 0.0;
        self.camBack.layer.opacity = 0.0;
        self.camBackLabel.layer.opacity = 0.0;
        self.camAgain.layer.opacity = 0.0;
        self.camAgainLabel.layer.opacity = 0.0;
        self.addRect.layer.opacity = 0.0;
        self.addRectLabel.layer.opacity = 0.0;
        
        
    } completion:^(BOOL finished){
        
        [self.myImageView removeFromSuperview];
        [self.faceLabel removeFromSuperview];
        [self.faceLabel2 removeFromSuperview];
        [self.camBack removeFromSuperview];
        [self.camBackLabel removeFromSuperview];
        [self.camAgain removeFromSuperview];
        [self.camAgainLabel removeFromSuperview];
        [self.addRect removeFromSuperview];
        [self.addRectLabel removeFromSuperview];
        
        
    }];
    
    }

    
}

-(void)getPicsAgain{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    
    [UIView animateWithDuration:1.0 delay:0.0 options:nil animations:^{
        
   //     totalAddedFrames = 0;
        self.myImageView.layer.opacity = 0.0;
        self.faceLabel.layer.opacity = 0.0;
        self.faceLabel2.layer.opacity = 0.0;
        self.camBack.layer.opacity = 0.0;
        self.camBackLabel.layer.opacity = 0.0;
        self.camAgain.layer.opacity = 0.0;
        self.camAgainLabel.layer.opacity = 0.0;
        self.addRect.layer.opacity = 0.0;
        self.addRectLabel.layer.opacity = 0.0;
        
        
    } completion:^(BOOL finished){
    
        [self.myImageView removeFromSuperview];
        [self.faceLabel removeFromSuperview];
        [self.faceLabel2 removeFromSuperview];
        [self.camBack removeFromSuperview];
        [self.camBackLabel removeFromSuperview];
        [self.camAgain removeFromSuperview];
        [self.camAgainLabel removeFromSuperview];
        [self.addRect removeFromSuperview];
        [self.addRectLabel removeFromSuperview];
        
    
    }];
    
}

-(void)getPics{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)pulseButton:(UIButton *)button{
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options: UIViewAnimationCurveLinear
                     animations:^{
                         button.transform = CGAffineTransformMakeScale(1.08,1.08);}
                     completion:^(BOOL finished){
                         
                         //[self animateBack];
                         
                         [UIView animateWithDuration:1.0
                                               delay:0.0
                                             options: UIViewAnimationCurveLinear
                                          animations:^{
                                              button.transform = CGAffineTransformMakeScale(0.95,0.95);}
                                          completion:^(BOOL finished){
                                              
                                              [self pulseButton:button];
                                              
                                          }
                          ];
                     }];
}


- (void)pickFromCamera:(id)sender {
    
    if (willShow == NO){
    /*
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
     */
    
    
    
  //  HomeViewController *thisControl = [[HomeViewController alloc]init];
    
  //  [self showViewController:thisControl sender:self];
    
    takingPic = NO;
    
    if (camTouched == NO){
        
        camTouched = YES;
    
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // ----- initialize camera -------- //
    
    // create camera vc
    
    if (camPos == 2){
    
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:CameraPositionBack
                                             videoEnabled:NO];
    } else {
     
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"CameraPosition"]  isEqual: @"Back"]){

                self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                     position:CameraPositionBack
                                                 videoEnabled:NO];
        }   else {
            self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                         position:CameraPositionFront
                                                     videoEnabled:NO];
            }
        
    }
    
    // attach to a view controller
    

    
   // [self.camera attachToViewController:self withFrame:CGRectMake(10 , chooseFromPictures.frame.origin.y, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.width-20)];

       [self.camera attachToViewController:self withFrame:CGRectMake([UIScreen mainScreen].bounds.size.width + 5, chooseFromPictures.frame.origin.y + 5, [UIScreen mainScreen].bounds.size.width-10, [UIScreen mainScreen].bounds.size.width-10)];
        
        allKnowingInt = 3;
    
    /*
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(userSwiped:)];
    
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.camera.view addGestureRecognizer:swipeRecognizer];
    */
    
    //myPanner *myPanned = [[myPanner alloc]initWithTarget:self action:@selector(moveThis:)];
    
    //[self.camera.view addGestureRecognizer:myPanned];
    
    NSLog(@"THIS FRAME: %@", NSStringFromCGPoint(chooseFromPictures.frame.origin));
    
    
                         
                         
    //self.camera.view.frame = [UIScreen mainScreen].bounds;
    
    self.camera.view.layer.cornerRadius = 20.0f ;
    //[self addChildViewController:camera];
    
    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = YES;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
        if([self.camera isFlashAvailable]) {
            flashButton.hidden = NO;
            
            if(self.camera.flash == CameraFlashOff) {
                flashButton.selected = NO;
            }
            else {
                flashButton.selected = YES;
            }
        }
        else {
            //flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                
             //   if(weakSelf.errorLabel) {
             //       [weakSelf.errorLabel removeFromSuperview];
              //  }
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"We need permission for the camera.\nPlease go to your settings.";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:18.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                UIView *thisView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                thisView.backgroundColor = [UIColor darkGrayColor];
                [thisView addSubview:label];
               // weakSelf.errorLabel = label;
                //[weakSelf.view addSubview:label];
                UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 35, 400*scaleFactor, 70, 70)];
                [backButton setImage:[UIImage imageNamed:@"back_error"] forState:UIControlStateNormal];
                [backButton addTarget:self action:@selector(removeView:) forControlEvents:UIControlEventTouchUpInside];

                [thisView addSubview:backButton];
                
                [self.view addSubview:thisView];
                [snapButton removeFromSuperview];
                [flashButton removeFromSuperview];
                [switchButton removeFromSuperview];
                [self.camera stop];
                [self.camera removeFromParentViewController];
                [self.camera.view removeFromSuperview];
                camTouched = NO;
                
            }
        }
    }];
    
        
    // ----- camera buttons -------- //
    
    // snap button to capture image
    snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    snapButton.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2-35, [UIScreen mainScreen].bounds.size.height/2 - 35, 70.0f, 70.0f);
    snapButton.clipsToBounds = YES;
    snapButton.layer.cornerRadius = 40.0f;
    snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    snapButton.layer.borderWidth = 3.0f;
    snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    snapButton.layer.shouldRasterize = YES;
    [snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    snapButton.layer.opacity = 0.0f;
    [snapButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [snapButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [snapButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    [self.view insertSubview:snapButton belowSubview:self.camera.view];
    
    
    
    /*
    [UIView animateWithDuration:0.5
                          delay:2.0
                        options: UIViewAnimationCurveLinear
                     animations:^{
                         //myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.camera.view.frame.origin.x - 10, self.camera.view.frame.origin.y - 10, self.camera.view.frame.size.width, self.camera.view.frame.size.height)];
                         myImageView = [[UIImageView alloc]initWithFrame:self.camera.view.frame];
                         myImageView.layer.cornerRadius = 20.0f;
                         //[self.view insertSubview:myImageView belowSubview:self.camera.view];
                         [self.view addSubview:myImageView];

                     }
                     completion:nil
     
     ];
     */
    
    
    
    
    myImageView = [[UIImageView alloc]initWithFrame:self.camera.view.frame];
    myImageView.layer.cornerRadius = 20.0f;
    //[self.view insertSubview:myImageView belowSubview:self.camera.view];
    NSLog(@"THIS IMAGE FRAME: %@", NSStringFromCGRect(self.camera.view.frame));
    
    
    
    
    NSLog(@"Log button frame: %@", NSStringFromCGRect(self.camera.view.frame));
    
    NSLog(@"Screen Size: %@", NSStringFromCGRect([UIScreen mainScreen].bounds));
    
    // button to toggle flash
    flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    flashButton.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.height/2 - 50, 100.0, 100.0);
    flashButton.tintColor = [UIColor whiteColor];
    [flashButton setImage:[UIImage imageNamed:@"flash"] forState:UIControlStateNormal];
    flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    flashButton.layer.opacity = 0.0f;
    [self.view addSubview:flashButton];
    
    // button to toggle camera positions
    switchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //switchButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 57, 535, 100.0, 100.0);
    switchButton.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2-50, [UIScreen mainScreen].bounds.size.height/2 - 50, 100.0, 100.0);
    
    switchButton.tintColor = [UIColor whiteColor];
    [switchButton setImage:[UIImage imageNamed:@"flipcam"] forState:UIControlStateNormal];
    switchButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [switchButton addTarget:self action:@selector(switchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    switchButton.layer.opacity = 0.0f;
    [self.view addSubview:switchButton];
    
    /*
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Picture",@"Video"]];
    self.segmentedControl.frame = CGRectMake(12.0f, screenRect.size.height - 67.0f, 120.0f, 32.0f);
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.tintColor = [UIColor whiteColor];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];
     */
    
    
    [UIView animateWithDuration:0.3
                          delay:0.2
                        options: UIViewAnimationCurveLinear
                     animations:^{
                         
                         if (movedAlready == NO){
                         
                             cameraButton.center = CGPointMake(cameraButton.center.x, cameraButton.center.y+55);
                             chooseFromPictures.center = CGPointMake(chooseFromPictures.center.x, chooseFromPictures.center.y+55);
                             chooseFromFacebook.center = CGPointMake(chooseFromFacebook.center.x, chooseFromFacebook.center.y-55);
                             chooseFromInsta.center = CGPointMake(chooseFromInsta.center.x, chooseFromInsta.center.y-55);
                         
                             label1.center = CGPointMake(label1.center.x, label1.center.y+55);
                             label2.center = CGPointMake(label2.center.x, label2.center.y+55);
                             label3.center = CGPointMake(label3.center.x, label3.center.y-55);
                             label4.center = CGPointMake(label4.center.x, label4.center.y-55);
                             
                             zoomButton.transform = CGAffineTransformMakeScale(0.5, 0.5);
                             
                             selectView.hidden = YES;
                             
                             movedAlready = YES;
                         }
                        
                         switchButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 57, ([UIScreen mainScreen].bounds.size.height - 100)*scaleFactor, 100.0, 100.0);
                         switchButton.layer.opacity = 0.7f;

                         flashButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 157, ([UIScreen mainScreen].bounds.size.height - 100)*scaleFactor, 100.0, 100.0);
                         
                         
                         if (camPos == 2){
                             
                             flashButton.layer.opacity = 1.0f;
                             flashButton.enabled = YES;
                             
                         } else {
                             flashButton.enabled = NO;

                             flashButton.layer.opacity = 0.5f;
                             
                         }
                         //flashButton.layer.opacity = 0.5f;
                         
                         snapButton.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2-40, ([UIScreen mainScreen].bounds.size.height - 75)*scaleFactor, 80.0f, 80.0f);
                         snapButton.layer.opacity = 0.7f;
                         
                         //[self.camera attachToViewController:self withFrame:CGRectMake(chooseFromPictures.frame.origin.x , chooseFromPictures.frame.origin.y, 1, 1)];
                         
                     }
                     completion:^(BOOL finished){
                         
                         //[self animateBack];
                         
                         [UIView animateWithDuration:0.3
                                               delay:0.0
                                             options: UIViewAnimationCurveLinear
                                          animations:^{
                                              
                                              switchButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 57, 535*scaleFactor, 100.0, 100.0);
                                              switchButton.layer.opacity = 1.0f;

                                              flashButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 157, 535*scaleFactor, 100.0, 100.0);
                                              //flashButton.layer.opacity = 1.0f;
                                              
                                              snapButton.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2-40, 545*scaleFactor, 80.0f, 80.0f);
                                              snapButton.layer.opacity = 1.0f;
                                              
                                          }
                                          completion:^(BOOL finished){
                                              takingPic = YES;
                                              [self pulseButton:snapButton];
                                          }];
                     }];
    
    
        [self.camera start];

    
        NSLog(@"THIS DIM: %@", NSStringFromCGRect( camera.view.bounds));

    }
    }
}

-(void)showPic:(UIImage *)thisImage{
    
//    myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, chooseFromPictures.frame.origin.y, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.width-20)];
    myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 148.5, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.width-20)];

    myImageView.layer.cornerRadius = 20.0f;
    myImageView.clipsToBounds = YES;
    
    NSLog(@"this point: %f", chooseFromPictures.frame.origin.y);
    
    [self.view addSubview:myImageView];
    
    thisInd = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    thisInd.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, [UIScreen mainScreen].bounds.size.height/2 -50, 100, 100);
    
    [thisInd startAnimating];
    
    [self.view insertSubview:thisInd belowSubview:self.myImageView];
    
    if (movedAlready == NO){
    
    
        cameraButton.center = CGPointMake(cameraButton.center.x, cameraButton.center.y+55);
        chooseFromPictures.center = CGPointMake(chooseFromPictures.center.x, chooseFromPictures.center.y+55);
        chooseFromFacebook.center = CGPointMake(chooseFromFacebook.center.x, chooseFromFacebook.center.y-55);
        chooseFromInsta.center = CGPointMake(chooseFromInsta.center.x, chooseFromInsta.center.y-55);
        
        label1.center = CGPointMake(label1.center.x, label1.center.y+55);
        label2.center = CGPointMake(label2.center.x, label2.center.y+55);
        label3.center = CGPointMake(label3.center.x, label3.center.y-55);
        label4.center = CGPointMake(label4.center.x, label4.center.y-55);
        
        zoomButton.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        selectView.hidden = YES;
        
        movedAlready = YES;
    }
    
    myImageView.image = thisImage;

    
    [self faceDetector:self.myImageView];
    
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options: UIViewAnimationCurveLinear
                     animations:^{
                         
                                thisInd.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2-40, 545*scaleFactor, 80.0f, 80.0f);
                         
                                 }
                     completion:^(BOOL finished){
                                              //[self pulseButton:snapButton];
                                }];
    

    
}

- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
    //BOOL done = [self.camera.position == CameraPositionBack];
    if (self.camera.position == CameraPositionBack){
        camPos = 2;
        flashButton.layer.opacity = 1.0f;
        flashButton.enabled = YES;
        flashButton.selected = NO;
        [self.camera updateFlashMode:CameraFlashOff];
    } else {
        camPos = 1;
        flashButton.layer.opacity = 0.5f;
        flashButton.enabled = NO;
        flashButton.tintColor = [UIColor whiteColor];
        flashButton.selected = NO;
    }
}

- (void)flashButtonPressed:(UIButton *)button {
    
    if(self.camera.flash == CameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:CameraFlashOn];
        if(done) {
            flashButton.selected = YES;
            flashButton.tintColor = [UIColor yellowColor];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:CameraFlashOff];
        if(done) {
            flashButton.selected = NO;
            flashButton.tintColor = [UIColor whiteColor];
        }
    }
}

static inline double radians (double degrees) {return degrees * M_PI/180;}
UIImage* rotate(UIImage* src, UIImageOrientation orientation)
{
    //UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }
    
    //[src drawAtPoint:CGPointMake(0, 0)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    return image;
}

-(void)removeView:(UIButton *)button {
    UIView *parentView = [(UIView *)button superview];
    [parentView removeFromSuperview];
}

- (void)snapButtonPressed:(UIButton *)button {
    
    allKnowingInt = 0;
    
    if (takingPic == YES){
        
        SystemSoundID soundID;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"photoShutter2" ofType:@"caf"];
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        AudioServicesPlaySystemSound(soundID);
        
        [UIView animateWithDuration:0.2 delay:0.0 options:nil animations:nil completion:^(BOOL finished){
        


    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            // we should stop the camera, since we don't need it anymore. We will open a new vc.
            // this very important, otherwise you may experience memory crashes
            
           // myImageView.image = image;
            //[self.view addSubview:myImageView];
            
            //UIImageView *thisImageView = [[UIImageView alloc]initWithFrame:self.camera.view.frame];
            myImageView = [[UIImageView alloc]initWithFrame:self.camera.view.frame];
            myImageView.layer.cornerRadius = 20.0;
            myImageView.clipsToBounds = YES;
            

            if (self.camera.position == CameraPositionFront){
                myImageView.image = [image fixOtherOrientation];
            } else {
                myImageView.image = image;
            }
            /*
            myImageView.image = [UIImage imageWithCGImage:image.CGImage
                                                      scale:image.scale
                                                orientation:UIImageOrientationUpMirrored];
            */
            //    myImage = [facePicture.image imageRotatedByDegrees:90.0];

            //myImageView.image = image;
            
            UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc]
                                                         initWithTarget:self action:@selector(userSwiped:)];
            
            swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
            
            //[myImageView addGestureRecognizer:swipeRecognizer];
            
            
            [self.view insertSubview:myImageView aboveSubview:self.camera.view];
            
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);

            
            [camera stop];
            [self.camera removeFromParentViewController];
            [self.camera.view removeFromSuperview];
            
            thisInd = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            
            thisInd.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 50, [UIScreen mainScreen].bounds.size.height/2 -50, 100, 100);
            
            [thisInd startAnimating];
            
            [self.view insertSubview:thisInd belowSubview:self.myImageView];
            
            [UIView animateWithDuration:0.3
                                  delay:0.2
                                options: UIViewAnimationCurveLinear
                             animations:^{
                                 
                                 switchButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 57, [UIScreen mainScreen].bounds.size.height + 100, 100.0, 100.0);
                                 
                                 flashButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 157, [UIScreen mainScreen].bounds.size.height + 100, 100.0, 100.0);
                                 
                                 snapButton.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2-40, [UIScreen mainScreen].bounds.size.height + 150, 80.0f, 80.0f);
                                 
                                thisInd.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2-40, [UIScreen mainScreen].bounds.size.height - 100, 80.0f, 80.0f);
                                 
                                 //[self.camera attachToViewController:self withFrame:CGRectMake(chooseFromPictures.frame.origin.x , chooseFromPictures.frame.origin.y, 1, 1)];
                                 
                             }
                             completion:^(BOOL finished){
                                 
                                 //[self animateBack];
                                 
                                 [UIView animateWithDuration:0.2
                                                       delay:0.0
                                                     options: UIViewAnimationCurveLinear
                                                  animations:^{
                                                      
                                                      thisInd.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2-40, 545, 80.0f, 80.0f);
                                                      
                                                  }
                                                  completion:^(BOOL finished){
                                                      //[self pulseButton:snapButton];
                                                  }];
                             }];

            
            
           // NSLog(@"THESE ARE NOW THE IMAGEVIEW MEASUREMENTS: %@", NSStringFromCGRect(myImageView.frame));
            
           // NSLog(@"Image Dimensions: %@", NSStringFromCGSize(image.size));
            
            //[self.camera.view removeFromSuperview];
            
            self.camera.view.hidden = YES;
            
            // show the image
            //ImageViewController *imageVC = [[ImageViewController alloc] initWithImage:image];
            //[self presentViewController:imageVC animated:NO completion:nil];
            
            mySelectInt = 0;

            
            [self faceDetector:self.myImageView];
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];

    
         }];
    }
}

//Action method
- (void)userSwiped:(UIGestureRecognizer *)sender
{
    //[self dismissViewControllerAnimated:YES completion:nil];
    UIView *myView = sender.view;
    
    //if (sender.state == UIGestureRecognizerStateBegan) {
    //    startLocation = [sender locationInView:self.view];
    //}
    //else
    if (sender.state == UIGestureRecognizerStateChanged || sender.state == UIGestureRecognizerStateBegan) {
        //CGPoint translation = [sender translationInView:self.myImageView];

        CGPoint stopLocation = [sender locationInView:sender.view];
        CGFloat dx = stopLocation.x - startLocation.x;
        CGFloat dy = stopLocation.y - startLocation.y;
        //CGFloat distance = sqrt(dx*dx + dy*dy );
        //NSLog(@"Distance: %f", distance);
        
        NSLog(@"This x dist: %f", dx);
        
        myView.frame = CGRectMake(myView.frame.origin.x - dx, myView.frame.origin.y, myView.frame.size.width, myView.frame.size.height);
        
    }
}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFinishPickingImages:(NSArray/*<OLFacebookImage>*/ *)images {
    
    
    NSLog(@"nope nope");
    
    if (movedAlready == YES && images.count <= 0){
        [self goBackToHome:nil];
    }
    [self applyCloudLayerAnimation];
    
    if (images.count > 0){
        NSLog(@"IT'S ABOUT TO COME AHHH");
        NSLog(@"I'M HUGE: %@", NSStringFromCGSize(((UIImage *)[images objectAtIndex:0]).size));
        mySelectInt = 2;
    
        //[self dismissViewControllerAnimated:YES completion:nil];
        [self applyCloudLayerAnimation];
        UIImage *newImage;
        if (scaleFactor > 1){
            newImage = [self squareImageFromImage:((UIImage *)[images objectAtIndex:0]) scaledToSize:([UIScreen mainScreen].bounds.size.width-20)/(scaleFactor*401.0/326.0)];
        } else {
            newImage = [self squareImageFromImage:((UIImage *)[images objectAtIndex:0]) scaledToSize:[UIScreen mainScreen].bounds.size.width-20];
        }
        secretImage = ((UIImage *)[images objectAtIndex:0]);
        
        [self showPic:newImage];
        [self applyCloudLayerAnimation];

    } else {
        [self applyCloudLayerAnimation];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    /*
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    //OLFacebookImagePickerCell *cell = (OLFacebookImagePickerCell *)thisTap.view;
    controller.image = images[0];
    //controller.image = self.selectedImagesInFuturePages[0];
    //controller.image = self.selectedImagesInFuturePages[0];
    [self showViewController:controller sender:self];
    NSLog(@"nopedy nope lol");

    //[self dismissViewControllerAnimated:YES completion:nil];
    [self applyCloudLayerAnimation];
    // do something with the OLFacebookImage image objects
     */
}

- (void)facebookImagePickerDidCancelPickingImages:(OLFacebookImagePickerController *)imagePicker {

    NSLog(@"sad sad sad");
    if (movedAlready == NO){
        [self dismissViewControllerAnimated:YES completion:nil];
        [self applyCloudLayerAnimation];
    } else {
        [self goBackToHome:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self applyCloudLayerAnimation];
    }

}

- (void)facebookImagePicker:(OLFacebookImagePickerController *)imagePicker didFailWithError:(NSError *)error {
    // do something with the error such as display an alert to the user
    [self dismissViewControllerAnimated:YES completion:nil];
    [self applyCloudLayerAnimation];
    [self showTheError];
}

-(void)pickFromFacebook:(id)sender {
    
    
    OLFacebookImagePickerController *picker = [[OLFacebookImagePickerController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
 //   FacebookAlbumPicker *objPicker = [[FacebookAlbumPicker alloc] initWithNibName:@"FacebookAlbumPicker" bundle:nil];
 //   objPicker.delegate = self;
 //   UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:objPicker];
    
 //   [self presentViewController:navController animated:YES completion:nil];
 
    
    /*
    if ([FBSDKAccessToken currentAccessToken]) {

        if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_photos"]) {
            
            [thisTimer invalidate];
            UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            CGRect activityViewFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            activityView.layer.backgroundColor = [UIColor blackColor].CGColor;
            activityView.layer.opacity = 0.3;
            activityView.frame = activityViewFrame;
            [self.view addSubview:activityView];
            [activityView startAnimating];
            
            

        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me/albums"
                                      parameters:nil
                                      HTTPMethod:@"GET"];
            
            

            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {

            
                NSArray *theCourses = result[@"data"];

                NSLog(@"THIS SIZE:   %lu \n\n\n\n", (unsigned long)theCourses.count);
                
                for (int i = 0; i < (unsigned long)theCourses.count; i++){

                
                
                    NSDictionary *theCourse = theCourses[i];
                
                    NSLog(@"album id: %@", theCourse[@"id"]);
                    
                    NSLog(@"album name: %@", theCourse[@"name"]);
                
                
                }

        }];
            
        } else {
            NSLog(@"DIDN'T WORK BRO");
        }
        
    } else {

// ....
        
        //chooseFromFacebook.readPermissions = @[@"email", @"user_friends", @"user_photos"];
        //chooseFromFacebook.publishPermissions = @[@"publish_actions"];
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithReadPermissions:@[@"email", @"user_friends", @"user_photos", @"friends_photos"]  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            //TODO: process error or result
            [self pickFromFacebook:self];
        }];
    }
    */
}

-(void)pickFromInsta:(id)sender {
   // FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
   // [loginManager logOut];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    if (movedAlready == YES){
        [self goBackToHome:nil];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self applyCloudLayerAnimation];

}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    secretImage = chosenImage;
    
    if (scaleFactor > 1){
        chosenImage = [self squareImageFromImage:chosenImage scaledToSize:([UIScreen mainScreen].bounds.size.width-20)/(scaleFactor*401.0/326.0)];
    } else {
        chosenImage = [self squareImageFromImage:chosenImage scaledToSize:[UIScreen mainScreen].bounds.size.width-20];
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    mySelectInt = 1;
    
    [self applyCloudLayerAnimation];
    [self showPic:chosenImage];
    
}



-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    viewController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/256.0 green:41.0/256.0 blue:41.0/256.0 alpha:1.0];//[UIColor darkGrayColor];
    viewController.navigationController.navigationBar.tintColor = [UIColor colorWithRed:20.0/256.0 green:236.0/256.0 blue:153.0/256.0 alpha:1.0];//[UIColor darkGrayColor];
    [_imagePicker.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    viewController.navigationController.navigationBar.translucent = NO;
    viewController.view.backgroundColor = [UIColor colorWithRed:87.0/256.0 green:87.0/256.0 blue:87.0/256.0 alpha:1.0];
    [viewController.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




/*                      FaceZooming shit
/
/
/

/
 /
 /
 /
 /
 
 
 /
 /*/

-(void)moveThis:(myPanner *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded){
        
        
        CGPoint translation = [recognizer translationInView:self.camera.view];
        CGRect recognizerFrame = recognizer.view.frame;
        
        CGPoint myPoint = [recognizer touchPointInView:self.camera.view];
        
        NSLog(@"LOG THIS Pan Origin: %@", NSStringFromCGPoint(myPoint));
        
        NSLog(@"LOG THIS Frame Origin: %@", NSStringFromCGPoint(recognizerFrame.origin));
        
        // Check if UIImageView is completely inside its superView
        
        recognizerFrame.origin.x += translation.x;
        recognizerFrame.origin.y += translation.y;
        CGPoint movePoint = CGPointMake(translation.x, translation.y);
        [recognizer incrementOrigin:&movePoint];
        
        
        
        //if (CGRectContainsRect(self.myImageView.bounds, recognizerFrame)) {
        //    recognizer.view.frame = recognizerFrame;
        //}
        // Else check if UIImageView is vertically and/or horizontally outside of its
        // superView. If yes, then set UImageView's frame accordingly.
        // This is required so that when user pans rapidly then it provides smooth translation.
        
        // Reset translation so that on next pan recognition
        // we get correct translation value
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.camera.view];
    }
}




-(void)moveMe:(myPanner *)recognizer{
    
    if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded){
        
        
        CGPoint translation = [recognizer translationInView:self.myImageView];
        CGRect recognizerFrame = recognizer.view.frame;
        
        CGPoint myPoint = [recognizer touchPointInView:self.myImageView];
        
        NSLog(@"LOG THIS Pan Origin: %@", NSStringFromCGPoint(myPoint));
        
        NSLog(@"LOG THIS Frame Origin: %@", NSStringFromCGPoint(recognizerFrame.origin));
        
        // Check if UIImageView is completely inside its superView
        if (fabs(myPoint.x - recognizerFrame.origin.x) < 25 && fabs(myPoint.y - recognizerFrame.origin.y) < 25){
            
            if (recognizerFrame.size.width <= 50 && recognizerFrame.size.height <= 50 && translation.x >= 0 && translation.y >= 0){
                
            } else {
                
                /*
                
                if ( (recognizerFrame.size.width-translation.x) > ( recognizerFrame.size.height-translation.y) ){
                    
                    recognizerFrame.size.width -= translation.x;
                    recognizerFrame.size.height -= translation.x;
                    recognizerFrame.origin.x += translation.x;
                    recognizerFrame.origin.y += translation.x;
                    CGPoint movePoint = CGPointMake(translation.x, translation.x);
                    [recognizer incrementOrigin:&movePoint];
                    
                    
                } else if ( (recognizerFrame.size.width-translation.x) < ( recognizerFrame.size.height-translation.y) ){
                    
                    recognizerFrame.size.width -= translation.y;
                    recognizerFrame.size.height -= translation.y;
                    recognizerFrame.origin.x += translation.y;
                    recognizerFrame.origin.y += translation.y;
                    CGPoint movePoint = CGPointMake(translation.y, translation.y);
                    [recognizer incrementOrigin:&movePoint];
                    
                } else {
                    
                    recognizerFrame.size.width -= translation.x;
                    recognizerFrame.size.height -= translation.y;
                    recognizerFrame.origin.x += translation.x;
                    recognizerFrame.origin.y += translation.y;
                    CGPoint movePoint = CGPointMake(translation.x, translation.y);
                    [recognizer incrementOrigin:&movePoint];
                }
                
                */
                
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
            //recognizerFrame.size.width -= translation.x;
            //recognizerFrame.size.height -= translation.y;
            //myPoint.x += translation.x;
            //myPoint.y += translation.y;
            
            //[recognizer incrementOrigin:&translation];
            
        } else {
            recognizerFrame.origin.x += translation.x;
            recognizerFrame.origin.y += translation.y;
            CGPoint movePoint = CGPointMake(translation.x, translation.y);
            [recognizer incrementOrigin:&movePoint];
        }
        
        
        if (CGRectContainsRect(self.myImageView.bounds, recognizerFrame)) {
            recognizer.view.frame = recognizerFrame;
        }
        // Else check if UIImageView is vertically and/or horizontally outside of its
        // superView. If yes, then set UImageView's frame accordingly.
        // This is required so that when user pans rapidly then it provides smooth translation.
        else {
            // Check vertically
            if (recognizerFrame.origin.y < self.myImageView.bounds.origin.y) {
                recognizerFrame.origin.y = 0;
            }
            else if (recognizerFrame.origin.y + recognizerFrame.size.height > self.myImageView.bounds.size.height) {
                recognizerFrame.origin.y = self.view.bounds.size.height - recognizerFrame.size.height;
            }
            
            // Check horizantally
            if (recognizerFrame.origin.x < self.myImageView.bounds.origin.x) {
                recognizerFrame.origin.x = 0;
            }
            else if (recognizerFrame.origin.x + recognizerFrame.size.width > self.myImageView.bounds.size.width) {
                recognizerFrame.origin.x = self.view.bounds.size.width - recognizerFrame.size.width;
            }
        }
        
        // Reset translation so that on next pan recognition
        // we get correct translation value
        [recognizer setTranslation:CGPointMake(0, 0) inView:self.myImageView];
    }
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        myLastScale = 1.0;
        if ([recognizer numberOfTouches] >= 2) { //should always be true when using a PinchGR
            CGPoint touch1 = [recognizer locationOfTouch:0 inView:self.myImageView];
            CGPoint touch2 = [recognizer locationOfTouch:1 inView:self.myImageView];
            CGPoint mid;
            mid.x = ((touch2.x - touch1.x) / 2) + touch1.x;
            mid.y = ((touch2.y - touch1.y) / 2) + touch1.y;
            CGSize imageViewSize = self.myImageView.frame.size;
            CGPoint anchor;
            anchor.x = mid.x / imageViewSize.width;
            anchor.y = mid.y / imageViewSize.height;
            self.myImageView.layer.anchorPoint = anchor;
        }
    }
    
    CGFloat scale = 1.0 - (myLastScale - [recognizer scale]);
    
    CGAffineTransform currentTransform = self.myImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.myImageView setTransform:newTransform];
    
    myLastScale = [recognizer scale];
    
}


-(void)faceDetector:(UIImageView *)facePicture
{
    
    [self performSelectorInBackground:@selector(markYoFaces:) withObject:facePicture];
    
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(void)pulseView:(UIView *)view
{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         view.transform = CGAffineTransformMakeScale(1.07,1.07);}
                     completion:^(BOOL finished){
                         
                         //[self animateBack];
                         
                         [UIView animateWithDuration:1.0
                                               delay:0.0
                                             options: UIViewAnimationCurveEaseInOut
                                          animations:^{
                                              view.transform = CGAffineTransformMakeScale(0.93,0.93);}
                                          completion:^(BOOL finished){
                                              
                                              [self pulseView:view];
                                              
                                          }
                          ];
                     }];

}


-(void)goBackToHome:(UIButton *)button
{
    allKnowingInt = 0;
    [self applyCloudLayerAnimation];
    selectView.hidden = YES;
    totalAddedFrames = 0;
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         
                         
                         cameraButton.center = CGPointMake(cameraButton.center.x-20, cameraButton.center.y-75);
                         chooseFromPictures.center = CGPointMake(chooseFromPictures.center.x+20, chooseFromPictures.center.y-75);
                         chooseFromFacebook.center = CGPointMake(chooseFromFacebook.center.x-20, chooseFromFacebook.center.y+75);
                         chooseFromInsta.center = CGPointMake(chooseFromInsta.center.x+20, chooseFromInsta.center.y+75);
                         
                         label1.center = CGPointMake(label1.center.x-20, label1.center.y-75);
                         label2.center = CGPointMake(label2.center.x+20, label2.center.y-75);
                         label3.center = CGPointMake(label3.center.x-20, label3.center.y+75);
                         label4.center = CGPointMake(label4.center.x+20, label4.center.y+75);
                         
                         zoomButton.transform = CGAffineTransformMakeScale(1.15, 1.15);
                         
                         self.myImageView.center = CGPointMake(self.myImageView.center.x, -800);
                         self.faceLabel.center = CGPointMake(self.faceLabel.center.x, 1200);
                         self.faceLabel2.center = CGPointMake(self.faceLabel2.center.x, 1200);
                         self.camBack.center = CGPointMake(self.camBack.center.x, 1200);
                         self.camBackLabel.center = CGPointMake(self.camBackLabel.center.x, 1200);
                         self.camAgain.center = CGPointMake(self.camAgain.center.x, 1200);
                         self.camAgainLabel.center = CGPointMake(self.camAgainLabel.center.x, 1200);
                         self.addRect.center = CGPointMake(self.addRect.center.x, 1200);
                         self.addRectLabel.center = CGPointMake(self.addRectLabel.center.x, 1200);
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self.myImageView removeFromSuperview];
                         [self.faceLabel removeFromSuperview];
                         [self.faceLabel2 removeFromSuperview];
                         [self.camBack removeFromSuperview];
                         [self.camBackLabel removeFromSuperview];
                         [self.camAgain removeFromSuperview];
                         [self.camAgainLabel removeFromSuperview];
                         [self.addRect removeFromSuperview];
                         [self.addRectLabel removeFromSuperview];
                         
                        [UIView animateWithDuration:0.15
                                               delay:0.0
                                             options: UIViewAnimationCurveEaseInOut
                                          animations:^{
                                              
                                              cameraButton.center = CGPointMake(cameraButton.center.x+20, cameraButton.center.y+20);
                                              chooseFromPictures.center = CGPointMake(chooseFromPictures.center.x-20, chooseFromPictures.center.y+20);
                                              chooseFromFacebook.center = CGPointMake(chooseFromFacebook.center.x+20, chooseFromFacebook.center.y-20);
                                              chooseFromInsta.center = CGPointMake(chooseFromInsta.center.x-20, chooseFromInsta.center.y-20);
                                              
                                              label1.center = CGPointMake(label1.center.x+20, label1.center.y+20);
                                              label2.center = CGPointMake(label2.center.x-20, label2.center.y+20);
                                              label3.center = CGPointMake(label3.center.x+20, label3.center.y-20);
                                              label4.center = CGPointMake(label4.center.x-20, label4.center.y-20);
                                              
                                              zoomButton.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                              
                                          }
                                          completion:^(BOOL finished){
                                              
                                              faceCount = 0;
                                              camTouched = NO;
                                              movedAlready = NO;
                                              //selectView.hidden = NO;
                                              allKnowingInt = 2;
                                          }
                          ];
                         
                     }];
}

-(void)reselectPicture:(UIButton *)button
{
    totalAddedFrames = 0;
    faceCount = 0;
    [self getPicsAgain];
}

-(void)reselectFacebook:(UIButton *)button
{
    totalAddedFrames = 0;
    faceCount = 0;
    [self getFacebook];
}

-(void)reselectInstagram:(UIButton *)button
{
    totalAddedFrames = 0;
    faceCount = 0;
    [self getInstagram];
}

-(void)retakePicture:(UIButton *)button
{
    totalAddedFrames = 0;
    [self.camera updateFlashMode:CameraFlashOff];
    NSLog(@"Got This Doe");
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options: UIViewAnimationCurveEaseInOut
                     animations:^{
                         
                         
                         self.myImageView.center = CGPointMake(self.myImageView.center.x, -800);
                         self.faceLabel.center = CGPointMake(self.faceLabel.center.x, 1200);
                         self.faceLabel2.center = CGPointMake(self.faceLabel2.center.x, 1200);
                         self.camBack.center = CGPointMake(self.camBack.center.x, 1200);
                         self.camBackLabel.center = CGPointMake(self.camBackLabel.center.x, 1200);
                         self.camAgain.center = CGPointMake(self.camAgain.center.x, 1200);
                         self.camAgainLabel.center = CGPointMake(self.camAgainLabel.center.x, 1200);
                         self.addRect.center = CGPointMake(self.addRect.center.x, 1200);
                         self.addRectLabel.center = CGPointMake(self.addRectLabel.center.x, 1200);
                         
                         faceCount = 0;
                         camTouched = NO;
                         [self performSelector:@selector(pickFromCamera:) withObject:self];
                         

                        // self.camera.view.hidden = NO;
                        // [camera start];
                         
                     }
                     completion:^(BOOL finished){
                         
                         [myImageView removeFromSuperview];
                         [faceLabel removeFromSuperview];
                         [faceLabel2 removeFromSuperview];
                         [camBack removeFromSuperview];
                         [camBackLabel removeFromSuperview];
                         [camAgain removeFromSuperview];
                         [camAgainLabel removeFromSuperview];
                         [addRect removeFromSuperview];
                         [addRectLabel removeFromSuperview];
                         
                         
                         //[self.myImageView removeFromSuperview];
                     }];
}

- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    if (image.size.width > image.size.height) {
        CGFloat scaleRatio = newSize / image.size.height;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    } else {
        CGFloat scaleRatio = newSize / image.size.width;
        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
        
        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    }
    
    CGSize size = CGSizeMake(newSize, newSize);
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, scaleTransform);
    
    [image drawAtPoint:origin];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

-(void)markYoFaces:(UIImageView *)facePicture
{
    NSLog(@"we at least got here");
    
    totalAddedFrames = 0;

    //myImage = rotate(myImage, UIImageOrientationRight);
    
//    myImage = [facePicture.image imageRotatedByDegrees:90.0];

    myImage = facePicture.image;
    
    NSLog(@"My Sizer: %@", NSStringFromCGRect(facePicture.frame));
    NSLog(@"My Sizer2: %@", NSStringFromCGSize(myImage.size));
  
    CIImage* image = [CIImage imageWithCGImage:myImage.CGImage];
    
///    NSLog(@"Image dims: %@", NSStringFromCGRect(image.extent));
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    NSArray* features = [detector featuresInImage:image];
    
    for(CIFaceFeature* faceFeature in features)
    {
        NSLog(@"WE HAS A FACE");
        
        NSLog(@"FACE BOUNDS: %@", NSStringFromCGRect(faceFeature.bounds));
        
        CGRect myRect;
        
        if (scaleFactor > 1){
            if (mySelectInt != 0){
               // myRect = CGRectMake(faceFeature.bounds.origin.x/(2*scaleFactor), (20 + self.myImageView.bounds.size.height - 15 - (faceFeature.bounds.origin.y/2 + faceFeature.bounds.size.height/2))/scaleFactor, faceFeature.bounds.size.width/(2*scaleFactor), faceFeature.bounds.size.height/(2*scaleFactor));
                //myRect = CGRectMake(faceFeature.bounds.origin.x/(4*scaleFactor), (20 + self.myImageView.bounds.size.height - 15 - (faceFeature.bounds.origin.y/2 + faceFeature.bounds.size.height/2))/(2*scaleFactor), faceFeature.bounds.size.width/(2*401/326), faceFeature.bounds.size.height/(2*401/326));
                myRect = CGRectMake((faceFeature.bounds.origin.x/2)/scaleFactor, (20 + self.myImageView.bounds.size.height - 15 - (faceFeature.bounds.origin.y/2 + faceFeature.bounds.size.height/2))*scaleFactor, faceFeature.bounds.size.width/2, faceFeature.bounds.size.height/2);

            } else {
                
                myRect = CGRectMake(faceFeature.bounds.origin.x/2-10, 20 + self.myImageView.bounds.size.height - (faceFeature.bounds.origin.y/2 + faceFeature.bounds.size.height/2), faceFeature.bounds.size.width/2, faceFeature.bounds.size.height/2);

            }
        } else {
            if (mySelectInt != 0){
                myRect = CGRectMake(faceFeature.bounds.origin.x/2, 20 + self.myImageView.bounds.size.height - 15 - (faceFeature.bounds.origin.y/2 + faceFeature.bounds.size.height/2), faceFeature.bounds.size.width/2, faceFeature.bounds.size.height/2);

            } else {
                myRect = CGRectMake(faceFeature.bounds.origin.x/2-10, 20 + self.myImageView.bounds.size.height - (faceFeature.bounds.origin.y/2 + faceFeature.bounds.size.height/2), faceFeature.bounds.size.width/2, faceFeature.bounds.size.height/2);
            }
        }
        NSLog(@"RECT SIZE: %@", NSStringFromCGRect(myRect));
        
        
        //CRASHES AFTER THIS
        
        
        //FaceRect* faceView = [[FaceRect alloc] initWithFrame:CGRectMake(myRect.origin.x+myRect.size.width/2-2, myRect.origin.y+myRect.size.height/2-2, 4, 4)];
        FaceRect* faceView = [[FaceRect alloc] initWithFrame:myRect];

        //[self pulseView:faceView];
        
        faceView.layer.borderWidth = 1.5;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        faceView.layer.opacity = 0.0;
        
        if (faceView.bounds.size.width > 50 && faceView.bounds.size.height > 50){
            
            faceCount = faceCount + 1;
            [self.myImageView addSubview:faceView];


          //  [self.myImageView addSubview:faceView];

            
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options: UIViewAnimationCurveEaseInOut
                             animations:^{
                                 //faceView.transform = CGAffineTransformMakeScale(1.07,1.07);
                                 faceView.frame = CGRectMake(myRect.origin.x - 15, myRect.origin.y - 15, myRect.size.width + 30, myRect.size.height + 30);
                                 faceView.layer.opacity = 1.0;
                             }
                             completion:^(BOOL finished){
                                 
                                 //[self animateBack];
                                 
                                 [UIView animateWithDuration:0.2
                                                       delay:0.0
                                                     options: UIViewAnimationCurveEaseInOut
                                                  animations:^{
                                                      //view.transform = CGAffineTransformMakeScale(0.93,0.93);
                                                      faceView.frame = myRect;
                                                  }
                                                  completion:^(BOOL finished){
                                                      
                                                      //[self pulseView:view];
                                                      NSLog(@"HERE'S THE FACE: %@", NSStringFromCGRect(myRect));

                                                  }
                                  ];
                             }];
                
            
        }
        
        
        
        
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cropMe:)];
        myTap.numberOfTapsRequired = 1;
        [faceView addGestureRecognizer:myTap];
        
        UIPinchGestureRecognizer *myPinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
        [faceView addGestureRecognizer:myPinch];
        
        myPanner *myPan = [[myPanner alloc]initWithTarget:self action:@selector(moveMe:)];
        
        [camBack addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
        
        [faceView addGestureRecognizer:myPan];
        
    }
    
/*
    
        goingToNextView = [[UIView alloc]initWithFrame:CGRectMake(0,0,200,100)];
        goingToNextView.backgroundColor = [UIColor blackColor];
        goingToNextView.layer.opacity = 0.7;
        goingToNextView.layer.cornerRadius = 20.0;
        goingToNextView.clipsToBounds = YES;
        goingToNextView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    
    UILabel *badLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [badLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
    badLabel.textColor = [UIColor whiteColor];
    badLabel.textAlignment = NSTextAlignmentCenter;
    badLabel.text = @"Creating GIF...";
    [badLabel sizeToFit];
    badLabel.center = CGPointMake(100, 50);
    [goingToNextView addSubview:badLabel];
    
    [self.view insertSubview:goingToNextView aboveSubview:myImageView];
    
    goingToNextView.hidden = YES;
    */
    
    
    [facePicture setUserInteractionEnabled:YES];
    
    //UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(makeRectangle:)];
    //longPress.minimumPressDuration = 0.5;
    //longPress.numberOfTouchesRequired = 1;
    //[facePicture addGestureRecognizer:longPress];
    
    //faceLabel = [[THLabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2 - 40, 200, 80)];
    
    if (alreadyCammed == NO){
    
    camBack = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4 - 60, ([UIScreen mainScreen].bounds.size.height +150)*scaleFactor, 80, 80)];
    
    //THREAD 31: EXC_BAD_ACCESS (code=EXC_I1386_GPFLT)
    //[camBack setImage:[UIImage imageNamed:@"back_cam"] forState:UIControlStateNormal];
    [camBack addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [camBack addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [camBack addTarget:self action:@selector(goBackToHome:) forControlEvents:UIControlEventTouchUpInside];
    [camBack addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    camBack.adjustsImageWhenHighlighted = NO;
    
    [self.view addSubview:camBack];
    
        
    //THREAD 75: EXC_BAD_ACCESS (CODE=1, ADDRESS=0xb5d8beb8)
    [camBack setImage:backCamImage forState:UIControlStateNormal];

        
    camBackLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    camBackLabel.text = @"Back";
    
    camBackLabel.numberOfLines = 1;
    camBackLabel.backgroundColor = [UIColor clearColor];
    camBackLabel.textColor = [UIColor colorWithRed:246.0/256.0 green:246.0/256.0 blue:246.0/256.0 alpha:1.0];
    camBackLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:(13.0f*scaleFactor)];
    camBackLabel.textAlignment = NSTextAlignmentCenter;
    [camBackLabel sizeToFit];
    camBackLabel.center = CGPointMake(camBack.center.x, camBack.center.y+(45*scaleFactor));
    [self.view addSubview:camBackLabel];
    
        
        
        
    camAgain = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 40, ([UIScreen mainScreen].bounds.size.height +150)*scaleFactor, 80, 80)];
    
    camAgainLabel = [[UILabel alloc]initWithFrame:CGRectZero];

        


        
    [camAgain addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [camAgain addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [camAgain addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    camAgain.adjustsImageWhenHighlighted = NO;
    
    [self.view addSubview:camAgain];
    
        if (mySelectInt == 0){
            
            //JUST THREW AN ERROR
            [camAgain setImage:againCamImage forState:UIControlStateNormal];
            
            
            
            
            [camAgain addTarget:self action:@selector(retakePicture:) forControlEvents:UIControlEventTouchUpInside];
            
            camAgainLabel.text = @"Retake";
            
        } else if(mySelectInt == 1){
            [camAgain setImage:selectCamImage forState:UIControlStateNormal];
            [camAgain addTarget:self action:@selector(reselectPicture:) forControlEvents:UIControlEventTouchUpInside];
            
            camAgainLabel.text = @"Choose Another Pic";
        } else if (mySelectInt == 2){
            //EXC_BAD_ACCESS
            [camAgain setImage:selectCamImage forState:UIControlStateNormal];
            [camAgain addTarget:self action:@selector(reselectFacebook:) forControlEvents:UIControlEventTouchUpInside];
            
            camAgainLabel.text = @"Choose Another Pic";
        } else if (mySelectInt == 3){
            [camAgain setImage:selectCamImage forState:UIControlStateNormal];
            [camAgain addTarget:self action:@selector(reselectInstagram:) forControlEvents:UIControlEventTouchUpInside];
            
            camAgainLabel.text = @"Choose Another Pic";
        }
    
    camAgainLabel.numberOfLines = 1;
    camAgainLabel.backgroundColor = [UIColor clearColor];
    camAgainLabel.textColor = [UIColor colorWithRed:246.0/256.0 green:246.0/256.0 blue:246.0/256.0 alpha:1.0];
    camAgainLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:(13.0f*scaleFactor)];
    camAgainLabel.textAlignment = NSTextAlignmentCenter;
    [camAgainLabel sizeToFit];
    camAgainLabel.center = CGPointMake(camAgain.center.x, camAgain.center.y+(45*scaleFactor));
    [self.view addSubview:camAgainLabel];
    
    addRect = [[UIButton alloc]initWithFrame:CGRectMake(3*[UIScreen mainScreen].bounds.size.width/4-20, ([UIScreen mainScreen].bounds.size.height +150)*scaleFactor, 80, 80)];
    
        
        
        
        
        
    ///THIS LINE IS CAUSING EXC_BAD_ACCESS ERRORS SOMETIMES
//    [addRect setImage:[UIImage imageNamed:@"mycammerathingdog"] forState:UIControlStateNormal];
    
        
        
        
        
    
        
    [addRect addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown];
    [addRect addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside];
    [addRect addTarget:self action:@selector(addFrame) forControlEvents:UIControlEventTouchUpInside];
    [addRect addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpOutside];
    addRect.adjustsImageWhenHighlighted = NO;
    
    [self.view addSubview:addRect];
        
    [addRect setImage:myCameraThingDogImage forState:UIControlStateNormal];

    
    addRectLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    addRectLabel.text = @"Add Frame";
    
    addRectLabel.numberOfLines = 1;
    addRectLabel.backgroundColor = [UIColor clearColor];
    addRectLabel.textColor = [UIColor colorWithRed:246.0/256.0 green:246.0/256.0 blue:246.0/256.0 alpha:1.0];
    addRectLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:(13.0f*scaleFactor)];
    addRectLabel.textAlignment = NSTextAlignmentCenter;
    [addRectLabel sizeToFit];
    addRectLabel.center = CGPointMake(addRect.center.x, addRect.center.y+(45*scaleFactor));
    [self.view addSubview:addRectLabel];
    
    }
    faceLabel = [[THLabel alloc] initWithFrame:CGRectZero];
    
    if (faceCount == 0){
        faceLabel.text = @"No faces found!";
    } else if (faceCount == 1){
        faceLabel.text = @"1 face recognized.";
    } else {
        NSString *faceString = [NSString stringWithFormat:@"%i faces recognized.", faceCount];
        faceLabel.text = faceString;
    }
    
    faceLabel.numberOfLines = 1;
    //label.lineBreakMode = NSLineBreakByWordWrapping;
    faceLabel.backgroundColor = [UIColor clearColor];
    //faceLabel.textColor = [UIColor whiteColor];
    faceLabel.textColor = [UIColor colorWithRed:246.0/256.0 green:246.0/256.0 blue:246.0/256.0 alpha:1.0];
    faceLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:(25.0f*scaleFactor)];
    faceLabel.textAlignment = NSTextAlignmentCenter;
    [faceLabel sizeToFit];
    faceLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, (585*scaleFactor));
    [thisInd removeFromSuperview];
    [self.view insertSubview:faceLabel belowSubview:self.myImageView];
    
    faceLabel2 = [[THLabel alloc] initWithFrame:CGRectZero];
    
    if (faceCount == 0){
        faceLabel2.text = @"Add a frame, position it, and tap it to create a GIF.";
        faceLabel2.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:(12.5f*scaleFactor)];
    } else if (faceCount == 1){
        faceLabel2.text = @"Resize the frame and tap it to create a GIF.";
        faceLabel2.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:(15.0f*scaleFactor)];
    } else {
        faceLabel2.text = @"Resize a frame and tap it to create a GIF.";
        faceLabel2.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:(15.0f*scaleFactor)];
    }
    
    faceLabel2.backgroundColor = [UIColor clearColor];
    //faceLabel.textColor = [UIColor whiteColor];
    faceLabel2.textColor = [UIColor colorWithRed:246.0/256.0 green:246.0/256.0 blue:246.0/256.0 alpha:1.0];
    faceLabel2.textAlignment = NSTextAlignmentCenter;
    [faceLabel2 sizeToFit];
    faceLabel2.center = CGPointMake(faceLabel.center.x, faceLabel.center.y - (55*scaleFactor));
    faceLabel2.layer.opacity = 0.0;
    [self.view insertSubview:faceLabel2 belowSubview:faceLabel];
    
        
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         if (scaleFactor > 1){
                             self.myImageView.frame = CGRectMake(self.myImageView.frame.origin.x, self.myImageView.frame.origin.y-105 + (35*scaleFactor*2),self.myImageView.frame.size.width, self.myImageView.frame.size.height);
                             
                             self.camera.view.frame = CGRectMake(self.camera.view.frame.origin.x, self.camera.view.frame.origin.y-(35*scaleFactor),self.camera.view.frame.size.width, self.camera.view.frame.size.height);
                             
                             faceLabel.frame = CGRectMake(faceLabel.frame.origin.x, faceLabel.frame.origin.y - (90*scaleFactor), faceLabel.frame.size.width, faceLabel.frame.size.height);
                             
                             faceLabel2.center = CGPointMake(faceLabel.center.x, faceLabel.center.y+(30*scaleFactor));
                             faceLabel2.layer.opacity = 1.0;
                             
                             
                             camBack.center = CGPointMake(camBack.center.x, faceLabel.frame.origin.y + (faceLabel.frame.size.height + 70)*scaleFactor);
                             
                             camBackLabel.center = CGPointMake(camBackLabel.center.x, faceLabel.frame.origin.y + faceLabel.frame.size.height + 115*scaleFactor);
                             
                             camAgain.center = CGPointMake(camAgain.center.x, faceLabel.frame.origin.y + (faceLabel.frame.size.height + 70)*scaleFactor);
                             
                             camAgainLabel.center = CGPointMake(camAgainLabel.center.x, faceLabel.frame.origin.y + faceLabel.frame.size.height + 115*scaleFactor);
                             
                             addRect.center = CGPointMake(addRect.center.x, faceLabel.frame.origin.y + (faceLabel.frame.size.height + 70)*scaleFactor);
                             
                             addRectLabel.center = CGPointMake(addRectLabel.center.x, faceLabel.frame.origin.y + faceLabel.frame.size.height +115*scaleFactor);
                         
                         } else {
                         
                         self.myImageView.frame = CGRectMake(self.myImageView.frame.origin.x, self.myImageView.frame.origin.y-105 + (35*scaleFactor*2),self.myImageView.frame.size.width, self.myImageView.frame.size.height);
                         
                         self.camera.view.frame = CGRectMake(self.camera.view.frame.origin.x, self.camera.view.frame.origin.y-(35*scaleFactor),self.camera.view.frame.size.width, self.camera.view.frame.size.height);
                         
                         faceLabel.frame = CGRectMake(faceLabel.frame.origin.x, faceLabel.frame.origin.y - (90*scaleFactor), faceLabel.frame.size.width, faceLabel.frame.size.height);
                         
                         faceLabel2.center = CGPointMake(faceLabel.center.x, faceLabel.center.y+(30*scaleFactor));
                         faceLabel2.layer.opacity = 1.0;
                         
                         
                         camBack.center = CGPointMake(camBack.center.x, faceLabel.frame.origin.y + (faceLabel.frame.size.height + 80)*scaleFactor);
                         
                         camBackLabel.center = CGPointMake(camBackLabel.center.x, faceLabel.frame.origin.y + faceLabel.frame.size.height + 125*scaleFactor);
                         
                         camAgain.center = CGPointMake(camAgain.center.x, faceLabel.frame.origin.y + (faceLabel.frame.size.height + 80)*scaleFactor);
                         
                         camAgainLabel.center = CGPointMake(camAgainLabel.center.x, faceLabel.frame.origin.y + faceLabel.frame.size.height + 125*scaleFactor);
                         
                         addRect.center = CGPointMake(addRect.center.x, faceLabel.frame.origin.y + (faceLabel.frame.size.height + 80)*scaleFactor);
                         
                         addRectLabel.center = CGPointMake(addRectLabel.center.x, faceLabel.frame.origin.y + faceLabel.frame.size.height + 125*scaleFactor);
                         
                         }
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                         //NSLog(@"this point: %f", faceLabel.frame.origin.y + faceLabel.frame.size.height + 7.5);
                         
                         /*
                         
                         [UIView animateWithDuration:0.3
                                               delay:0.0
                                             options: UIViewAnimationCurveLinear
                                          animations:^{
                                              
                                              switchButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 57, 535, 100.0, 100.0);
                                              switchButton.layer.opacity = 1.0f;
                                              
                                              flashButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 157, 535, 100.0, 100.0);
                                              //flashButton.layer.opacity = 1.0f;
                                              flashButton.enabled = NO;
                                              
                                              snapButton.frame = CGRectMake( [UIScreen mainScreen].bounds.size.width/2-40, 545, 80.0f, 80.0f);
                                              snapButton.layer.opacity = 1.0f;
                                              
                                          }
                                          completion:^(BOOL finished){
                                              [self pulseButton:snapButton];
                                          }];
                     
                          
                    */
                         
                         allKnowingInt = 4;
                    }];

    
    
}

-(void)addFrame{
    //CGPoint location = [longPress locationInView:self.view];
    
    if (totalAddedFrames <3){
    
    CGPoint location = self.myImageView.center;
    
    CGRect frame = CGRectMake(location.x - 50 - self.myImageView.frame.origin.x, location.y - 50 - self.myImageView.frame.origin.y, 100, 100);
    
    //NSLog(@"Here's the point: %@, and here's the frame: %@", NSStringFromCGPoint(location), NSStringFromCGRect(frame));
    
    //NSLog(@"Unchecked Rect: %@", NSStringFromCGRect(frame));
    //NSLog(@"Picture frame: %@", NSStringFromCGRect(self.myPicView.frame));
    
    frame = [self otherCheckedCGRect:&frame :self.myImageView];
    
    //FaceRect* faceView = [[FaceRect alloc] initWithFrame:CGRectMake(myRect.origin.x+myRect.size.width/2-2, myRect.origin.y+myRect.size.height/2-2, 4, 4)];
    FaceRect* faceView = [[FaceRect alloc] initWithFrame:frame];
    
    //[self pulseView:faceView];
    
    faceView.layer.borderWidth = 1.5;
    faceView.layer.borderColor = [[UIColor redColor] CGColor];
    
    faceView.layer.opacity = 0.0;
        
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cropMe:)];
        myTap.numberOfTapsRequired = 1;
        [faceView addGestureRecognizer:myTap];
        
        myPanner *myPan = [[myPanner alloc]initWithTarget:self action:@selector(moveMe:)];
        
        [faceView addGestureRecognizer:myPan];
    
    
        [self.myImageView addSubview:faceView];
        
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationCurveEaseInOut
                         animations:^{
                             //faceView.transform = CGAffineTransformMakeScale(1.07,1.07);
                             faceView.frame = CGRectMake(frame.origin.x - 15, frame.origin.y - 15, frame.size.width + 30, frame.size.height + 30);
                             faceView.layer.opacity = 1.0;
                         }
                         completion:^(BOOL finished){
                             
                             //[self animateBack];
                             
                             [UIView animateWithDuration:0.2
                                                   delay:0.0
                                                 options: UIViewAnimationCurveEaseInOut
                                              animations:^{
                                                  //view.transform = CGAffineTransformMakeScale(0.93,0.93);
                                                  faceView.frame = frame;
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  //[self pulseView:view];
                                                  
                                              }
                              ];
                         }];
        totalAddedFrames = totalAddedFrames + 1;
    }
    
    /*
    //NSLog(@"Checked Rect: %@", NSStringFromCGRect(frame));
    
    FaceRect* view = [[FaceRect alloc] initWithFrame:frame];
    
    view.alpha = 0.0f;
    
    view.layer.borderColor = [UIColor redColor].CGColor;
    view.layer.borderWidth = 1.0f;
    view.opaque = NO;
    UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cropMe:)];
    myTap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:myTap];
    
    
    UIPinchGestureRecognizer *myPinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
    [view addGestureRecognizer:myPinch];
    
    myPanner *myPan = [[myPanner alloc]initWithTarget:self action:@selector(moveMe:)];
    
    [view addGestureRecognizer:myPan];
    
    
    [self.myImageView addSubview:view];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    
    view.alpha = 1.0;
    
    [UIView commitAnimations];
     */
}

-(void)makeRectangle:(UILongPressGestureRecognizer *)longPress {
    
    if ( longPress.state == UIGestureRecognizerStateBegan ) {
        
        CGPoint location = [longPress locationInView:self.view];
        
        CGRect frame = CGRectMake(location.x - 50 - self.myImageView.frame.origin.x, location.y - 50 - self.myImageView.frame.origin.y, 100, 100);
        
        //NSLog(@"Here's the point: %@, and here's the frame: %@", NSStringFromCGPoint(location), NSStringFromCGRect(frame));
        
        //NSLog(@"Unchecked Rect: %@", NSStringFromCGRect(frame));
        //NSLog(@"Picture frame: %@", NSStringFromCGRect(self.myPicView.frame));
        
        frame = [self otherCheckedCGRect:&frame :self.myImageView];
        
        //NSLog(@"Checked Rect: %@", NSStringFromCGRect(frame));
        
        FaceRect* view = [[FaceRect alloc] initWithFrame:frame];
        
        view.alpha = 0.0f;
        
        view.layer.borderColor = [UIColor redColor].CGColor;
        view.layer.borderWidth = 1.0f;
        view.opaque = NO;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cropMe:)];
        myTap.numberOfTapsRequired = 1;
        [view addGestureRecognizer:myTap];
        
        
        UIPinchGestureRecognizer *myPinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
        [view addGestureRecognizer:myPinch];
        
        myPanner *myPan = [[myPanner alloc]initWithTarget:self action:@selector(moveMe:)];
        
        [view addGestureRecognizer:myPan];
        
        
        [longPress.view addSubview:view];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.75];
        
        view.alpha = 1.0;
        
        [UIView commitAnimations];
        
    }
    
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)sender {
    
    UIView *myView = sender.view;
    
    if ([sender numberOfTouches] < 2)
        return;
    
    NSLog(@"lol\n\n\n\n\n");
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        lastScale = 1.0;
        lastPoint = [sender locationInView:myView];
    }
    
    // Scale
    CGFloat scale = 1.0 - (lastScale - sender.scale);
    [myView.layer setAffineTransform:
     CGAffineTransformScale([myView.layer affineTransform],
                            scale,
                            scale)];
    lastScale = sender.scale;
    
    // Translate
    CGPoint point = [sender locationInView:myView];
    [myView.layer setAffineTransform:
     CGAffineTransformTranslate([myView.layer affineTransform],
                                point.x - lastPoint.x,
                                point.y - lastPoint.y)];
    lastPoint = [sender locationInView:myView];
}


-(void)cropMe:(UITapGestureRecognizer *)myTap
{
    
    //[self pulsateView];
    
   // NSLog(@"Lerpd");
    
   // goingToNextView.hidden = NO;
    
    //[self pulseThis];
    
    FaceRect *myView = myTap.view;
 
    
    
    CGRect myRect = CGRectMake(myView.frame.origin.x, myView.frame.origin.y, myView.bounds.size.width, myView.bounds.size.height);
 
    
    SecondViewController *mySecond = [[SecondViewController alloc]init];
    
    if (mySelectInt == 0){
        mySecond.mainImage = self.myImageView.image;
    } else {
        mySecond.mainImage = secretImage;
    }
    mySecond.imageView.frame = self.myImageView.frame;
   // mySecond.globalSpeed1 = 0.3;
   // mySecond.globalSpeed2 = 0.2;
    
    mySecond.cropFrame.frame = myRect;
    mySecond.myPoint = CGPointMake(300*myView.center.x/self.myImageView.bounds.size.width, 300*myView.center.y/self.myImageView.bounds.size.height);
    NSLog(@"JUST A LOGGING A RECT: %@", NSStringFromCGRect(myRect));
    
    mySecond.zoomFrame = CGRectMake(myRect.origin.x *300/self.myImageView.bounds.size.width, myRect.origin.y * 300 / self.myImageView.bounds.size.height, myRect.size.width  * 300 / self.myImageView.bounds.size.width, myRect.size.height  * 300 / self.myImageView.bounds.size.height);
    
   // NSLog(@"LOG ANOTHER RECT: %@", CGRectMake(myRect.origin.x *300/self.myImageView.bounds.size.width, myRect.origin.y * 300 / self.myImageView.bounds.size.height, myRect.size.width  * 300 / self.myImageView.bounds.size.width, myRect.size.height  * 300 / self.myImageView.bounds.size.height));
    
    mySecond.delegate = self;
    
    
    
    //THIS LINE FIXES EVERYTHING
    

    [self showViewController:mySecond sender:self];
    
    //[indThis removeFromSuperview];
    
    //[indThis stopAnimating];
    
    //[self performSegueWithIdentifier:@"CustomSegued" sender: myTap.view ];//]myTap.view];
    
    //[self performSegueWithIdentifier:myFaceSegue sender:self];
    //[self showViewController:myController sender:self];

    
    //thisViewController *thisController = [self.storyboard instantiateViewControllerWithIdentifier:@"thisViewControllered"];
    //[self presentViewController:myController animated:YES];
    //[goingToNextView removeFromSuperview];
        


}

-(void)gonnaRemoveThis{
    //[goingToNextView removeFromSuperview];
    goingToNextView.hidden = YES;
    selectView.hidden = YES;
}

-(void)sendDataToA:(NSMutableArray *)array
{
    // data will come here inside of ViewControllerA
    
    imageArray = array;
    
    NSLog(@"WE DUN WHO KNEW LOLOLOL THIS VIEW IS CRAY");
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    [data writeToFile:pathx options:NSDataWritingAtomic error:nil];
    
    NSLog(@"SIZE NOW: %li", [imageArray count]);
}

-(NSMutableArray *)getThisArray{//:(NSMutableArray *)array{
    return imageArray;
}

// Prepare for the segue going forward
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue isKindOfClass:[CustomSegue class]]) {
        // Set the start point for the animation to center of the button for the animation
        
        UIView *parentView = [(UIView *)sender superview];

        ((CustomSegue *)segue).originatingPoint = parentView.center;
        
        //CGPointMake([UIScreen mainScreen].bounds.origin.x + [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.origin.y + [UIScreen mainScreen].bounds.size.height/2);//parentView.center;   //self.segueButton.center;
        
        NSLog(@"THIS POINT: %@", NSStringFromCGPoint(((CustomSegue *)segue).originatingPoint));
    }
}

// This is the IBAction method referenced in the Storyboard Exit for the Unwind segue.
// It needs to be here to create a link for the unwind segue.
// But we'll do nothing with it.
- (IBAction)unwindFromViewController:(UIStoryboardSegue *)sender {
}

// We need to over-ride this method from UIViewController to provide a custom segue for unwinding
- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
    // Instantiate a new CustomUnwindSegue
    CustomUnwindSegue *segue = [[CustomUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    // Set the target point for the animation to the center of the button in this VC
    segue.targetPoint = CGPointMake([UIScreen mainScreen].bounds.origin.x + [UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.origin.y + [UIScreen mainScreen].bounds.size.height/2);//self.segueButton.center;
    return segue;
}


CGRect SquareFaceRectAtCenter(CGFloat centerX, CGFloat centerY, CGFloat size) {
    CGFloat x = centerX - size / 2.0;
    CGFloat y = centerY - size / 2.0;
    return CGRectMake(x, y, size, size);
}



-(FaceRect *)boundsCheckedRect:(FaceRect *)thisRect:(UIImageView *)myView{
    
    CGPoint myRectCenter = CGPointMake(thisRect.frame.origin.x + thisRect.frame.size.width/2.0f, thisRect.frame.origin.y + thisRect.frame.size.height/2.0f);
    
    if (thisRect.frame.origin.x < myView.frame.origin.x || thisRect.frame.origin.x + thisRect.frame.size.width > myView.frame.origin.x + myView.frame.size.width){
        CGFloat newSize = 2.0f * fabs(myView.frame.origin.x - myRectCenter.x);
        CGRect frame = SquareFaceRectAtCenter(myRectCenter.x, myRectCenter.y, newSize);
        FaceRect *newRect = [[FaceRect alloc] initWithFrame:frame];
        return newRect;
    } else if (thisRect.frame.origin.y < myView.frame.origin.y || thisRect.frame.origin.y + thisRect.frame.size.height > myView.frame.origin.y + myView.frame.size.height){
        CGFloat newSize = 2.0f * fabs(myView.frame.origin.y - myRectCenter.y);
        CGRect frame = SquareFaceRectAtCenter(myRectCenter.x, myRectCenter.y, newSize);
        FaceRect *newRect = [[FaceRect alloc] initWithFrame:frame];
        return newRect;
    } else {
        return thisRect;
    }
}

-(CGRect)boundsCheckedCGRect:(CGRect *)thisRect:(UIImageView *)myView{
    
    CGPoint myRectCenter = CGPointMake(thisRect->origin.x + thisRect->size.width/2.0f, thisRect->origin.y + thisRect->size.height/2.0f);
    
    if (thisRect->origin.x < myView.frame.origin.x || thisRect->origin.x + thisRect->size.width > myView.frame.origin.x + myView.frame.size.width){
        CGFloat newSize = 2.0f * fabs(myView.frame.origin.x - myRectCenter.x);
        CGRect frame = SquareFaceRectAtCenter(myRectCenter.x, myRectCenter.y, newSize);
        return frame;
    } else if (thisRect->origin.y < myView.frame.origin.y || thisRect->origin.y + thisRect->size.height > myView.frame.origin.y + myView.frame.size.height){
        CGFloat newSize = 2.0f * fabs(myView.frame.origin.y - myRectCenter.y);
        CGRect frame = SquareFaceRectAtCenter(myRectCenter.x, myRectCenter.y, newSize);
        return frame;
    } else {
        return *thisRect;
    }
}


-(CGRect)otherCheckedCGRect:(CGRect *)thisRect:(UIImageView *)myView{
    
    //CGPoint myRectCenter = CGPointMake(thisRect->origin.x + thisRect->size.width/2.0f, thisRect->origin.y + thisRect->size.height/2.0f);
    
    if (thisRect->origin.x < myView.frame.origin.x){
        
        //CGFloat newSize = 2.0f * fabs(myView.frame.origin.x - myRectCenter.x);
        //CGRect frame = SquareFaceRectAtCenter(myRectCenter.x, myRectCenter.y, newSize);
        NSLog(@"Eagle One");
        *thisRect = CGRectMake(myView.frame.origin.x, thisRect->origin.y, thisRect->size.width, thisRect->size.height);
    }
    if (thisRect->origin.y < myView.frame.origin.y){
        NSLog(@"Eagle Two");
        
        *thisRect = CGRectMake(thisRect->origin.x, myView.frame.origin.y, thisRect->size.width, thisRect->size.height);
    }
    
    if (thisRect->origin.x + thisRect->size.width > myView.frame.origin.x + myView.frame.size.width){
        NSLog(@"Eagle Three");
        
        *thisRect = CGRectMake(myView.frame.origin.x + myView.frame.size.width - thisRect->size.width, thisRect->origin.y, thisRect->size.width, thisRect->size.height);
    }
    
    if (thisRect->origin.y + thisRect->size.height > myView.frame.origin.y + myView.frame.size.height){
        NSLog(@"Eagle Four");
        
        *thisRect = CGRectMake(thisRect->origin.x, myView.frame.origin.y + myView.frame.size.height - thisRect->size.height, thisRect->size.width, thisRect->size.height);
    }
    
    return *thisRect;
    
}



-(CGRect) cropRectForFrame:(CGRect)frame
{
    
    CGFloat widthScale = self.myImageView.bounds.size.width / self.myImageView.image.size.width;
    CGFloat heightScale = self.myImageView.bounds.size.height / self.myImageView.image.size.height;
    float x, y, w, h, offset;
    if (widthScale<heightScale) {
        offset = (self.myImageView.bounds.size.height - (self.myImageView.image.size.height*widthScale))/2;
        x = frame.origin.x / widthScale;
        y = (frame.origin.y-offset) / widthScale;
        w = frame.size.width / widthScale;
        h = frame.size.height / widthScale;
    } else {
        offset = (self.myImageView.bounds.size.width - (self.myImageView.image.size.width*heightScale))/2;
        x = (frame.origin.x-offset) / heightScale;
        y = frame.origin.y / heightScale;
        w = frame.size.width / heightScale;
        h = frame.size.height / heightScale;
    }
    return CGRectMake(x, y, w, h);
}



@end
