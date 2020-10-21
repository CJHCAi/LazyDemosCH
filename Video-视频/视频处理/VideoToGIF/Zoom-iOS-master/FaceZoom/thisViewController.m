//
//  thisViewController.m
//  FaceZoom
//
//  Created by Ben Taylor on 5/5/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "thisViewController.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "webViewController.h"
#import "THLabel.h"
#import "CRGradientNavigationBar.h"


@implementation thisViewController

@synthesize zoomPic;
@synthesize isSomethingEnabled;

@synthesize dvImage;
@synthesize firstImage;
@synthesize secondImage;
@synthesize fourthImage;
@synthesize backButton;
@synthesize textEntry;
@synthesize zoomButton;
@synthesize textLabel;
@synthesize textLabel2;

- (void)drawTextInRect:(CGRect)rect:(UILabel *)myLabel {
    
    CGSize shadowOffset = myLabel.shadowOffset;
    UIColor *textColor = myLabel.textColor;
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 2);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    myLabel.textColor = [UIColor blackColor];
    [myLabel drawTextInRect:rect];
    
    CGContextSetTextDrawingMode(c, kCGTextFill);
    myLabel.textColor = textColor;
    myLabel.shadowOffset = CGSizeMake(0, 0);
    [myLabel drawTextInRect:rect];
    
    myLabel.shadowOffset = shadowOffset;
    
}


- (void)viewDidLoad {
    
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.84375 blue:0.28125 alpha:1];
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.15234375 green:1 blue:0.9296875 alpha:1];
        self.navigationController.navigationBar.translucent = YES;
        //self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:0.15234375 green:1 blue:0.9296875 alpha:1];
        //self.tabBarController.tabBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.15234375 green:1 blue:0.9296875 alpha:1];
        //self.tabBarController.tabBar.tintColor = [UIColor colorWithRed:0.15234375 green:1 blue:0.9296875 alpha:1];
    }
    
    self.navigationController.title = @"Create GIF";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    zoomPic.contentMode = UIViewContentModeScaleAspectFit;
    zoomPic.clipsToBounds = YES;
    [zoomPic setImage:dvImage];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [backButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(dismissKeyboard)];

    [zoomButton addTarget:self action:@selector(createGif:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addGestureRecognizer:tap];

    textEntry.delegate = self;
    
    textLabel = [[THLabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 260)/2, 205, 260, 100)];
    textLabel2 = [[THLabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300)/2, 295, 300, 60)];
    
    textLabel.text= @" ";
    
    textLabel2.text = @"Enter Text Below:";
    
    [textLabel setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
    textLabel.textColor = [UIColor whiteColor];
    
    [textLabel2 setFont:[UIFont fontWithName:@"Impact" size:23.0f]];
    textLabel2.textColor = [UIColor whiteColor];
    
    textLabel.strokeSize = 2.0f;
    textLabel.strokePosition = THLabelStrokePositionOutside;
    textLabel.strokeColor = [UIColor blackColor];
    textLabel.letterSpacing = 1.5f;
    textLabel.textAlignment = NSTextAlignmentCenter;

    textLabel2.strokeSize = 2.0f;
    textLabel2.strokePosition = THLabelStrokePositionOutside;
    textLabel2.strokeColor = [UIColor blackColor];
    textLabel2.letterSpacing = 1.5f;
    textLabel2.textAlignment = NSTextAlignmentCenter;
    
    
    [self.view addSubview:textLabel];
    [self.view addSubview: textLabel2];
    //[self.view addSubview: textLabel];
    [textEntry addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
}

-(void)textFieldDidChange:(id)sender{
    textLabel.text = textEntry.text;
    [textLabel setText:[textLabel.text uppercaseString]];
}

/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textLabel.text = textEntry.text;
    [textLabel setText:[textLabel.text uppercaseString]];
    return YES;
}
*/

-(void)dismissKeyboard {
    [textEntry resignFirstResponder];
}

-(void)buttonTapped:(id)sender {
}

-(void)createGif:(id)sender {
    [self makeAnimatedGif:firstImage :secondImage :dvImage: fourthImage];
}

- (void) makeAnimatedGif:(UIImage *)firstPic : (UIImage *)secondPic : (UIImage *) thirdPic :(UIImage *)fourthPic{
    static NSUInteger const kFrameCount = 5;
    
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    NSDictionary *frameProperties = @{
                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
                                              (__bridge id)kCGImagePropertyGIFDelayTime: @0.3f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                              }
                                      };
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    //for (NSUInteger i = 0; i < kFrameCount; i++) {
       // @autoreleasepool {
            //UIImage *image = frameImage(CGSizeMake(300, 300), M_PI * 2 * i / kFrameCount);
    CGRect rect = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect.size );
    [firstPic drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *img1=[UIImage imageWithData:imageData];
    
    
    
    
    CGRect rect2 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect2.size );
    [secondPic drawInRect:rect2];
    UIImage *picture2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData2 = UIImagePNGRepresentation(picture2);
    UIImage *img2=[UIImage imageWithData:imageData2];
    
    
    
    
    CGRect rect3 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect3.size );
    [thirdPic drawInRect:rect3];
    UIImage *picture3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData3 = UIImagePNGRepresentation(picture3);
    UIImage *img3=[UIImage imageWithData:imageData3];
    
    
    
    CGRect rect4 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect4.size );
    [thirdPic drawInRect:rect4];
    UIImage *picture4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData4 = UIImagePNGRepresentation(picture4);
    UIImage *img4=[UIImage imageWithData:imageData4];
    
    
    
    
    //MEME Part
    
    CGRect rect5 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect5.size );
    [thirdPic drawInRect:rect5];
    
    THLabel *myTextLabel = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
    
    [myTextLabel setFont:[UIFont fontWithName:@"Impact" size:48.0f]];
    myTextLabel.textColor = [UIColor whiteColor];
    
    myTextLabel.strokeSize = 2.0f;
    myTextLabel.strokePosition = THLabelStrokePositionOutside;
    myTextLabel.strokeColor = [UIColor blackColor];
    myTextLabel.letterSpacing = 1.5f;
    myTextLabel.textAlignment = NSTextAlignmentCenter;
    myTextLabel.text = textLabel.text;
    
    [myTextLabel.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *picture5 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData5 = UIImagePNGRepresentation(picture5);
    UIImage *img5=[UIImage imageWithData:imageData5];
    
    //DONE MEME
    
    CGImageDestinationAddImage(destination, img1.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, img2.CGImage, (__bridge CFDictionaryRef)frameProperties);
    //CGImageDestinationAddImage(destination, img3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, img4.CGImage, (__bridge CFDictionaryRef)frameProperties);
    //CGImageDestinationAddImage(destination, img5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, img5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, img5.CGImage, (__bridge CFDictionaryRef)frameProperties);

    
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    
    webViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"webViewControllered"];

    
    //NSLog(@"url=%@", fileURL);
    
    //NSData *myData = UIImagePNGRepresentation(screenshot);

//NSString* htmlString = [NSString stringWithContentsOfFile:fileURL encoding:NSUTF8StringEncoding error:nil];
    
    myController.myString = fileURL;
    
    NSLog(@"GOT THIS: %@", myController.myString);
    
    [self showViewController:myController sender:self];
    
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end