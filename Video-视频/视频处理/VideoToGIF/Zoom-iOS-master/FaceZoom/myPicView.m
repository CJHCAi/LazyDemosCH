//
//  myPicView.m
//  FaceZoom
//
//  Created by Ben Taylor on 5/18/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import "thisViewController.h"
#import "FaceRect.h"
#import "myPicView.h"
#import "myPanner.h"
#import "CRGradientNavigationBar.h"


@implementation myPicView

@synthesize myPicView;
@synthesize myImage;

CGPoint lastPoint;
CGFloat lastScale;
CGFloat myLastScale;

-(void)viewDidLoad{
    
    
    /*
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    */
    
    
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
    
    [super viewDidLoad];
    
    //NSLog(@"here's the origin: x = %f, and y = %f", self.myPicView.frame.origin.x, self.myPicView.frame.origin.y);
    
    self.myPicView = [[UIImageView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 350)/2, 80, 350, 350)];
    
    
    [self.view addSubview:myPicView];

    self.myPicView.image = self.myImage;
    
    [self faceDetector:self.myPicView];

    
    //UIPinchGestureRecognizer *myPinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(twoFingerPinch:)];
    
    //[self.myPicView addGestureRecognizer:myPinch];
    
    self.myPicView.userInteractionEnabled = YES;
    
   // CGRectMake(([UIScreen mainScreen].bounds.size.width - 400)/2, 100, 400, 400);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)moveMe:(myPanner *)recognizer{

    if(recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded){

    
    CGPoint translation = [recognizer translationInView:self.myPicView];
    CGRect recognizerFrame = recognizer.view.frame;
    
    CGPoint myPoint = [recognizer touchPointInView:self.myPicView];
    
    NSLog(@"LOG THIS Pan Origin: %@", NSStringFromCGPoint(myPoint));
    
    NSLog(@"LOG THIS Frame Origin: %@", NSStringFromCGPoint(recognizerFrame.origin));
    
    // Check if UIImageView is completely inside its superView
    if (fabs(myPoint.x - recognizerFrame.origin.x) < 25 && fabs(myPoint.y - recognizerFrame.origin.y) < 25){
        
        if (recognizerFrame.size.width <= 50 && recognizerFrame.size.height <= 50 && translation.x >= 0 && translation.y >= 0){
            
        } else {
        
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
    
    
    if (CGRectContainsRect(self.myPicView.bounds, recognizerFrame)) {
        recognizer.view.frame = recognizerFrame;
    }
    // Else check if UIImageView is vertically and/or horizontally outside of its
    // superView. If yes, then set UImageView's frame accordingly.
    // This is required so that when user pans rapidly then it provides smooth translation.
    else {
        // Check vertically
        if (recognizerFrame.origin.y < self.myPicView.bounds.origin.y) {
            recognizerFrame.origin.y = 0;
        }
        else if (recognizerFrame.origin.y + recognizerFrame.size.height > self.myPicView.bounds.size.height) {
            recognizerFrame.origin.y = self.view.bounds.size.height - recognizerFrame.size.height;
        }
        
        // Check horizantally
        if (recognizerFrame.origin.x < self.myPicView.bounds.origin.x) {
            recognizerFrame.origin.x = 0;
        }
        else if (recognizerFrame.origin.x + recognizerFrame.size.width > self.myPicView.bounds.size.width) {
            recognizerFrame.origin.x = self.view.bounds.size.width - recognizerFrame.size.width;
        }
    }
    
    // Reset translation so that on next pan recognition
    // we get correct translation value
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.myPicView];
    }
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        myLastScale = 1.0;
        if ([recognizer numberOfTouches] >= 2) { //should always be true when using a PinchGR
            CGPoint touch1 = [recognizer locationOfTouch:0 inView:self.myPicView];
            CGPoint touch2 = [recognizer locationOfTouch:1 inView:self.myPicView];
            CGPoint mid;
            mid.x = ((touch2.x - touch1.x) / 2) + touch1.x;
            mid.y = ((touch2.y - touch1.y) / 2) + touch1.y;
            CGSize imageViewSize = self.myPicView.frame.size;
            CGPoint anchor;
            anchor.x = mid.x / imageViewSize.width;
            anchor.y = mid.y / imageViewSize.height;
            self.myPicView.layer.anchorPoint = anchor;
        }
    }
    
    CGFloat scale = 1.0 - (myLastScale - [recognizer scale]);
    
    CGAffineTransform currentTransform = self.myPicView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.myPicView setTransform:newTransform];
    
    myLastScale = [recognizer scale];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    self.myPicView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
 //   [self.camButton setHidden:TRUE];
    
    [self faceDetector:self.myPicView];
    
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


-(void)markYoFaces:(UIImageView *)facePicture
{
    
    
    CIImage* image = [CIImage imageWithCGImage:facePicture.image.CGImage];
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    NSArray* features = [detector featuresInImage:image];
    
    for(CIFaceFeature* faceFeature in features)
    {
        
        CGRect myRect = CGRectMake(faceFeature.bounds.origin.x/2-10, 20 + self.myPicView.bounds.size.height - (faceFeature.bounds.origin.y/2 + faceFeature.bounds.size.height/2), faceFeature.bounds.size.width/2, faceFeature.bounds.size.height/2);
        
        FaceRect* faceView = [[FaceRect alloc] initWithFrame:myRect];
        
        faceView.layer.borderWidth = 1;
        faceView.layer.borderColor = [[UIColor redColor] CGColor];
        
        if (faceView.bounds.size.width > 50 && faceView.bounds.size.height > 50){
        
            [self.myPicView addSubview:faceView];
        }
            
            
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cropMe:)];
        myTap.numberOfTapsRequired = 1;
        [faceView addGestureRecognizer:myTap];
        
        UIPinchGestureRecognizer *myPinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
        [faceView addGestureRecognizer:myPinch];
        
        myPanner *myPan = [[myPanner alloc]initWithTarget:self action:@selector(moveMe:)];
     
        [faceView addGestureRecognizer:myPan];
    }
    
    [facePicture setUserInteractionEnabled:YES];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(makeRectangle:)];
    longPress.minimumPressDuration = 0.5;
    longPress.numberOfTouchesRequired = 1;
    [facePicture addGestureRecognizer:longPress];
}

-(void)makeRectangle:(UILongPressGestureRecognizer *)longPress {
    
    if ( longPress.state == UIGestureRecognizerStateBegan ) {
        
        CGPoint location = [longPress locationInView:self.view];
        
        CGRect frame = CGRectMake(location.x - 50 - self.myPicView.frame.origin.x, location.y - 50 - self.myPicView.frame.origin.y, 100, 100);
        
        //NSLog(@"Here's the point: %@, and here's the frame: %@", NSStringFromCGPoint(location), NSStringFromCGRect(frame));
        
        //NSLog(@"Unchecked Rect: %@", NSStringFromCGRect(frame));
        //NSLog(@"Picture frame: %@", NSStringFromCGRect(self.myPicView.frame));
        
        frame = [self otherCheckedCGRect:&frame :self.myPicView];

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
    
    
    FaceRect *myView = myTap.view;
    
    CGRect myRect = CGRectMake(myView.frame.origin.x, myView.frame.origin.y, myView.bounds.size.width, myView.bounds.size.height);
    
    NSLog(@"VIEW RECT:   %@\n", NSStringFromCGRect(myRect));
    
    
    CGRect cropRect2 = CGRectMake(myRect.origin.x - myRect.size.width, myRect.origin.y - myRect.size.height, myRect.size.width*3, myRect.size.height*3);
    
    //cropRect2 = [self otherCheckedCGRect:&cropRect2 :self.myPicView];

    
    CGRect myNewRect2 = [self cropRectForFrame:cropRect2];
    
    CGImageRef imageRef2 = CGImageCreateWithImageInRect([self.myPicView.image CGImage], myNewRect2);
    UIImage *img2 = [UIImage imageWithCGImage:imageRef2];
    CGImageRelease(imageRef2);
    
    
    
    
    CGRect cropRect3 = CGRectMake(myRect.origin.x - myRect.size.width/4, myRect.origin.y - myRect.size.height/4, myRect.size.width*1.5, myRect.size.height*1.5);

    //cropRect3 = [self otherCheckedCGRect:&cropRect3 :self.myPicView];
    
    CGRect myNewRect3 = [self cropRectForFrame:cropRect3];
    
    CGImageRef imageRef3 = CGImageCreateWithImageInRect([self.myPicView.image CGImage], myNewRect3);
    UIImage *img3 = [UIImage imageWithCGImage:imageRef3];
    CGImageRelease(imageRef3);
    
    
    
    
    
    CGRect cropRect = CGRectMake(myRect.origin.x, myRect.origin.y, myRect.size.width, myRect.size.height);
    
    CGRect myNewRect = [self cropRectForFrame:cropRect];
    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.myPicView.image CGImage], myNewRect);
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    
    
    
    CGRect cropRect4 = CGRectMake(myRect.origin.x+ myRect.size.width/6, myRect.origin.y+myRect.size.height/6, 2*myRect.size.width/3, 2*myRect.size.height/3);
    
    CGRect myNewRect4 = [self cropRectForFrame:cropRect4];
    
    CGImageRef imageRef4 = CGImageCreateWithImageInRect([self.myPicView.image CGImage], myNewRect4);
    UIImage *img4 = [UIImage imageWithCGImage:imageRef4];
    CGImageRelease(imageRef4);
    
    
    thisViewController *myController = [self.storyboard instantiateViewControllerWithIdentifier:@"thisViewControllered"];

    
    myController.firstImage = img2;
    myController.secondImage = img3;
    myController.dvImage = img;
    myController.fourthImage = img4;
    
    
    myController.originalImage = self.myPicView.image;
    //[self presentViewController:myController animated:YES completion:nil];//:myController animated:YES];
    [self showViewController:myController sender:self];
    //[self performSegueWithIdentifier:myFaceSegue sender:self];
    
    
    //thisViewController *thisController = [self.storyboard instantiateViewControllerWithIdentifier:@"thisViewControllered"];
    //[self presentViewController:myController animated:YES];
    
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
    
    CGFloat widthScale = self.myPicView.bounds.size.width / self.myPicView.image.size.width;
    CGFloat heightScale = self.myPicView.bounds.size.height / self.myPicView.image.size.height;
    float x, y, w, h, offset;
    if (widthScale<heightScale) {
        offset = (self.myPicView.bounds.size.height - (self.myPicView.image.size.height*widthScale))/2;
        x = frame.origin.x / widthScale;
        y = (frame.origin.y-offset) / widthScale;
        w = frame.size.width / widthScale;
        h = frame.size.height / widthScale;
    } else {
        offset = (self.myPicView.bounds.size.width - (self.myPicView.image.size.width*heightScale))/2;
        x = (frame.origin.x-offset) / heightScale;
        y = frame.origin.y / heightScale;
        w = frame.size.width / heightScale;
        h = frame.size.height / heightScale;
    }
    return CGRectMake(x, y, w, h);
}





@end

