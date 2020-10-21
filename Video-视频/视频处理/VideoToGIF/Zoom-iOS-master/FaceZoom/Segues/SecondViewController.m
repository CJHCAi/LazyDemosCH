//  Created by Phillipus on 11/10/2013.
//  Copyright (c) 2013 Dada Beatnik. All rights reserved.
//

#import "SecondViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "FXBlurView.h"
#import "THLabel.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIImage+animatedGIF.h"
#import "ViewController.h"
#import <MessageUI/MessageUI.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerShareKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "gifBuyController.h"
#import "SettingsViewController.h"



@interface SpecialButton2 : UIButton

@end

@implementation SpecialButton2

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


@implementation SecondViewController

@synthesize cloudLayer;
@synthesize cloudLayerAnimation;
@synthesize mainImage;
@synthesize cropFrame;
@synthesize imageView;
@synthesize myPoint;
@synthesize zoomFrame;
@synthesize img;
@synthesize img1;
@synthesize img2;
@synthesize img3;
@synthesize img4;
@synthesize img5;
@synthesize thisTimer;
@synthesize textLabel;
@synthesize textField;
@synthesize textLabel2;
@synthesize textField2;
@synthesize myTap;
@synthesize originalFrame;
@synthesize blackoutView;
@synthesize scrollView;
@synthesize slider1;
@synthesize toClipboard;
@synthesize inder;
@synthesize finishedView;
@synthesize actionMenu;
@synthesize zoomLabel;
@synthesize slider2;
@synthesize threeLabel;
@synthesize globalSpeed1;
@synthesize globalSpeed2;


@synthesize fiveLabel;
@synthesize imageView2;
@synthesize blackoutView2;
@synthesize textField3;
@synthesize textField4;
@synthesize textLabel3;
@synthesize textLabel4;
@synthesize myTap2;
@synthesize toClipboard2;
@synthesize thisTimer2;
@synthesize thisArr;
@synthesize delegate;
@synthesize thisScroller2;
@synthesize thisTexter2;
@synthesize testAlerter2;
@synthesize thisScroller3;
@synthesize thisTexter3;
@synthesize testAlerter3;
@synthesize gifURL1;
@synthesize gifURL2;
@synthesize pulserTimer;
@synthesize selectView2;
@synthesize goingToNextView2;

bool isFullscreen = NO;
bool hasBeenSet = NO;
bool isTyping = NO;
bool pressed = NO;
double offsetNum;

//float globalSpeed1 = 0.3;
float globalZoom1 = 1;
bool firstAdjustment1 = YES;

//float globalSpeed2 = 0.2;
bool hasBeenSet2 = NO;
bool isTyping2 = NO;
bool pressed2 = NO;
float scaleFactor2 = 1;

bool saveGIF1 = NO;
bool saveGIF2 = NO;

bool gif1Saved = NO;
bool gif2Saved = NO;

NSInteger viewcount= 2;
int myAction = -1;
int actionNum2 = 0;


-(void)savePic{
    
    
    
    if (pressed == NO){
        
        pressed = YES;
        
        inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
        
        inder.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        inder.backgroundColor = [UIColor blackColor];
        inder.layer.opacity = 0.8;
        inder.layer.cornerRadius = 20.0;
        [inder startAnimating];
        UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        loadingLabel.text = @"Saving GIF...";
        
        [loadingLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
        
        loadingLabel.textColor = [UIColor whiteColor];
        
        [loadingLabel sizeToFit];
        
        loadingLabel.center = CGPointMake(100, 120);
        
        [inder addSubview:loadingLabel];
        
        NSString *fileName;
        
        if (myAction == 0){
            [self.view insertSubview:inder aboveSubview:blackoutView];
            [self makeGifReal:img1 :img2 :img3 :img4];
            //fileName = gifURL1;
        } else {
            [self.view insertSubview:inder aboveSubview:blackoutView2];
            [self makeGifReal2:img1 :img2 :img3 :img4];
            //fileName = gifURL2;
        }
        
        //NSString *fileName = [imageArray objectAtIndex:actionIndex];
        
        //NSFileManager *fileManager = [NSFileManager defaultManager];
        //NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
        //fileName = [fullCachePath stringByAppendingPathComponent:fileName];
        
        //NSData *gifData = [[NSData alloc] initWithContentsOfFile:fileName];
        
        //UIImage* mygif = [UIImage animatedImageWithAnimatedGIFData:gifData];
        
        
        //UIImageWriteToSavedPhotosAlbum(mygif, nil, nil, nil);
        
        
        //UIImageWriteToSavedPhotosAlbum(mygif, nil, nil, nil);
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            
            inder.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
        } completion:^(BOOL finished){
            
            [inder removeFromSuperview];
            
            finishedView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 200)];
            
            
            //inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
            
            finishedView.backgroundColor = [UIColor blackColor];
            finishedView.layer.opacity = 0.8;
            finishedView.layer.cornerRadius = 20.0;
            
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
            
            [finishedView addSubview:thisLab];
            
            
            
            [finishedView addSubview:imageThing];
            
            finishedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
            [self.view addSubview:finishedView];
            
            
            //NSTimer *thisTimed = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(removeThis) userInfo:nil repeats:NO];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                
                finishedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
            }
             
                             completion:^(BOOL finished){
                                 
                                 [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                     
                                     finishedView.transform = CGAffineTransformMakeScale(0.85, 0.85);
                                     
                                 }
                                  
                                                  completion:^(BOOL finished){
                                                      
                                                      
                                                      [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                          
                                                          finishedView.transform = CGAffineTransformMakeScale(1, 1);
                                                          
                                                      }
                                                       
                                                                       completion:^(BOOL finished){
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                                               
                                                                               finishedView.transform = CGAffineTransformMakeScale(1, 1);
                                                                               
                                                                               
                                                                           }
                                                                                            completion:^(BOOL finished){
                                                                                                
                                                                                                [UIView animateWithDuration:0.2 delay:1.3 options:nil animations:^{
                                                                                                    
                                                                                                    finishedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                                                                                    
                                                                                                }
                                                                                                 
                                                                                                                 completion:^(BOOL finished){
                                                                                                                     
                                                                                                                     
                                                                                                                     [finishedView removeFromSuperview];
                                                                                                                     pressed = NO;
                                                                                                                     
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
    
    if (pressed == NO){
        
        pressed = YES;
        
        inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
        
        inder.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        inder.backgroundColor = [UIColor blackColor];
        inder.layer.opacity = 0.8;
        inder.layer.cornerRadius = 20.0;
        [inder startAnimating];
        UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        loadingLabel.text = @"Copying GIF...";
        
        [loadingLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
        
        loadingLabel.textColor = [UIColor whiteColor];
        
        [loadingLabel sizeToFit];
        
        loadingLabel.center = CGPointMake(100, 120);
        
        [inder addSubview:loadingLabel];
        
        NSString *fileName;
        if (myAction == 0){
            [self.view insertSubview:inder aboveSubview:blackoutView];
            fileName = gifURL1;
        } else {
            [self.view insertSubview:inder aboveSubview:blackoutView2];
            fileName = gifURL2;
        }
        
        //NSString *fileName = [imageArray objectAtIndex:actionIndex];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fullCachePath = ((NSURL*)[[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] ).path;
        fileName = [fullCachePath stringByAppendingPathComponent:fileName];
        
        NSData *gifData = [[NSData alloc] initWithContentsOfFile:fileName];
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        [pasteboard setData:gifData forPasteboardType:@"com.compuserve.gif"];
        
        
        
        //UIImageWriteToSavedPhotosAlbum(mygif, nil, nil, nil);
        
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            
            inder.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
        } completion:^(BOOL finished){
            
            [inder removeFromSuperview];
            
            finishedView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 200)];
            
            
            //inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
            
            finishedView.backgroundColor = [UIColor blackColor];
            finishedView.layer.opacity = 0.8;
            finishedView.layer.cornerRadius = 20.0;
            
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
            
            [finishedView addSubview:thisLab];
            
            
            
            [finishedView addSubview:imageThing];
            
            finishedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
            [self.view addSubview:finishedView];
            
            
            //NSTimer *thisTimed = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(removeThis) userInfo:nil repeats:NO];
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                
                finishedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
            }
             
                             completion:^(BOOL finished){
                                 
                                 [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                     
                                     finishedView.transform = CGAffineTransformMakeScale(0.85, 0.85);
                                     
                                 }
                                  
                                                  completion:^(BOOL finished){
                                                      
                                                      
                                                      [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                          
                                                          finishedView.transform = CGAffineTransformMakeScale(1, 1);
                                                          
                                                      }
                                                       
                                                                       completion:^(BOOL finished){
                                                                           
                                                                           
                                                                           
                                                                           
                                                                           [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                                               
                                                                               finishedView.transform = CGAffineTransformMakeScale(1, 1);
                                                                               
                                                                               
                                                                           }
                                                                                            completion:^(BOOL finished){
                                                                                                
                                                                                                [UIView animateWithDuration:0.2 delay:1.3 options:nil animations:^{
                                                                                                    
                                                                                                    finishedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                                                                                    
                                                                                                }
                                                                                                 
                                                                                                                 completion:^(BOOL finished){
                                                                                                                     
                                                                                                                     
                                                                                                                     [finishedView removeFromSuperview];
                                                                                                                     pressed = NO;
                                                                                                                     
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
    
    inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
    
    inder.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    inder.backgroundColor = [UIColor blackColor];
    inder.layer.opacity = 0.8;
    inder.layer.cornerRadius = 20.0;
    [inder startAnimating];
    
    NSString *fileName;
    if (myAction == 0){
        [self.view insertSubview:inder aboveSubview:blackoutView];
        fileName = gifURL1;
    } else {
        [self.view insertSubview:inder aboveSubview:blackoutView2];
        fileName = gifURL2;
    }
    
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
    [inder removeFromSuperview];
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
        NSString *fileName;
        if (myAction == 0){
            //[self.view insertSubview:inder aboveSubview:blackoutView];
            fileName = gifURL1;
        } else {
          //  [self.view insertSubview:inder aboveSubview:blackoutView2];
            fileName = gifURL2;
        }
        
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
                 
                 
                 NSString *fileName;
                 if (myAction == 0){
                    // [self.view insertSubview:inder aboveSubview:blackoutView];
                     fileName = gifURL1;
                 } else {
                   //  [self.view insertSubview:inder aboveSubview:blackoutView2];
                     fileName = gifURL2;
                 }
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
    

    
    testAlerter2 = [[UIAlertView alloc] initWithTitle:@"Post to Twitter"
                                             message:nil
                                            delegate:self
                                   cancelButtonTitle:@"Cancel"
                                   otherButtonTitles:@"Post", nil];
    thisTexter2 = [UIPlaceHolderTextView new];
    thisTexter2.delegate = self;
    thisTexter2.placeholder = @"Add Tweet Here";
    thisTexter2.placeholderColor = [UIColor lightGrayColor];
    thisTexter2.font = [UIFont fontWithName:nil size:16.0];
    thisTexter2.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [testAlerter2 setValue: thisTexter2 forKey:@"accessoryView"];
    
    testAlerter2.backgroundColor = [UIColor colorWithRed:41.0/256.0 green:41.0/256.0 blue:41.0/256.0 alpha:1.0];
    testAlerter2.tintColor = [UIColor colorWithRed:20.0/256.0 green:236.0/256.0 blue:153.0/256.0 alpha:1.0];
    
    
    [testAlerter2 show];
    
    [thisTexter2 becomeFirstResponder];
    
    
}

-(void)emailPic{
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    
    mailController.mailComposeDelegate = self;
    
    [mailController setSubject:@""];
    
    [mailController setMessageBody:@"Check out this sick GIF I made with Zoom!" isHTML:NO];
    
    //UIImage *pic = [UIImage imageNamed:@"Image box with border-1.png"];
    //NSData *exportData = UIImageJPEGRepresentation(pic ,1.0);
    
    NSString *fileName;
    if (myAction == 0){
     //   [self.view insertSubview:inder aboveSubview:blackoutView];
        fileName = gifURL1;
    } else {
       // [self.view insertSubview:inder aboveSubview:blackoutView2];
        fileName = gifURL2;
    }
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


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1){// && actionNum == 1 && isCray == NO){
        //UIPlaceHolderTextView *thisView = [alertView valueForKey:@"accessoryView"];
        NSString *myText = thisTexter2.text;
        [testAlerter2 dismissWithClickedButtonIndex:1 animated:YES];
        [self tweetThis:myText];
    } else if (buttonIndex == 0){// && actionNum == 1){
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [thisTexter2 resignFirstResponder];
    }
}

- (void)settingsPage2{
    SettingsViewController *thisControl = [[SettingsViewController alloc]init];
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:thisControl];
    //[self presentViewController:thisControl animated:YES completion:nil];
    [self.navigationController presentModalViewController:navC animated:YES];
}

-(void)pulseView2:(UIView *)view
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
                                              
                                              [self pulseView2:view];
                                              
                                          }
                          ];
                     }];
    
}

-(void)backToIt:(UITapGestureRecognizer *)tapper{
    
    NSLog(@"cray cray dawg");
    if (isFullscreen){
        
        if(blackoutView.isHidden){
            
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                
                UIView *thisView = imageView2;//tapper.view;
                
                thisScroller3.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + 30, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width);
                
                
                //thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140, 300, 300);
                
                //thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140 + offsetNum - 50, 300, 300);
                if (scaleFactor2 < 1){
                    thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140 + offsetNum - 70, 300, 300);
                    
                } else {
                    thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140 + offsetNum - 50, 300, 300);
                }
                
                thisView.layer.cornerRadius = 20.0;
                
                blackoutView2.layer.opacity = 0.0;
                
                textLabel3.frame = CGRectMake(20, 200, 260, 100);
                
                [textLabel3 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
                
                [textField3 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
                
                textField3.frame = textLabel3.frame;
                
                textLabel4.frame = CGRectMake(20, 0, 260, 100);
                
                [textLabel4 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
                
                [textField4 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
                
                textField4.frame = textLabel4.frame;
                
                
                textField3.hidden = NO;
                textLabel3.hidden = NO;
                textField4.hidden = NO;
                textLabel4.hidden = NO;
                //thisView.frame
                
            } completion:^(BOOL finished){
                
                NSLog(@"THE FRAME: %@", NSStringFromCGRect(originalFrame));
                
                scrollView.scrollEnabled = YES;
                
                
                isFullscreen = NO;
                
                if ([textField3.text  isEqual: @""]){
                    
                    textLabel3.layer.opacity = 0.5;
                    
                }
                
                if ([textField4.text  isEqual: @""]){
                    
                    textLabel4.layer.opacity = 0.5;
                    
                }
                
                textField3.userInteractionEnabled = YES;
                textField4.userInteractionEnabled = YES;
                blackoutView2.hidden = YES;
                
                /*
                 [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                 
                 thisView.frame = CGRectMake(0, tempHeight+50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
                 //thisView.frame
                 
                 } completion:nil];
                 */
            }];

            
            
        } else if(blackoutView2.isHidden){
            
            
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                
                UIView *thisView = imageView;//tapper.view;
                
                thisScroller2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + 30, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width);
                
                
                // thisScroller2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + 30, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width);
                
                
                //thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140, 300, 300);
                
                thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140*scaleFactor2, 300, 300);
                
                thisView.layer.cornerRadius = 20.0;
                
                blackoutView.layer.opacity = 0.0;
                
                textLabel.frame = CGRectMake(20, 200, 260, 100);
                
                [textLabel setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
                
                [textField setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
                
                textField.frame = textLabel.frame;
                
                textLabel2.frame = CGRectMake(20, 0, 260, 100);
                
                [textLabel2 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
                
                [textField2 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
                
                textField2.frame = textLabel2.frame;
                
                
                textField.hidden = NO;
                textLabel.hidden = NO;
                textField2.hidden = NO;
                textLabel2.hidden = NO;
                //thisView.frame
                
            } completion:^(BOOL finished){
                
                NSLog(@"THE FRAME: %@", NSStringFromCGRect(originalFrame));
                
                scrollView.scrollEnabled = YES;
                
                
                isFullscreen = NO;
                
                if ([textField.text  isEqual: @""]){
                    
                    textLabel.layer.opacity = 0.5;
                    
                }
                
                if ([textField2.text  isEqual: @""]){
                    
                    textLabel2.layer.opacity = 0.5;
                    
                }
                
                textField.userInteractionEnabled = YES;
                textField2.userInteractionEnabled = YES;
                blackoutView.hidden = YES;
                
                /*
                 [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                 
                 thisView.frame = CGRectMake(0, tempHeight+50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
                 //thisView.frame
                 
                 } completion:nil];
                 */
            }];

        }
        
    }
}


-(void)viewDidLoad{
    
    gifURL1 = nil;
    gifURL2 = nil;
    
    if ([UIScreen mainScreen].nativeBounds.size.height == 960){
        scaleFactor2 = 960.0/1334.0;
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 1136){
        scaleFactor2 = 1136.0/1334.0;
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 1334){
        scaleFactor2 = 1.0;
    } else if ([UIScreen mainScreen].nativeBounds.size.height == 2208){
        //scaleFactor = 2208.0/1334.0 * 326.0/401.0;
        // scaleFactor = 333.5/368.0 * 2208.0/1334.0;
        scaleFactor2 = 401.0/326.0*333.5/368.0;
    }
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    [self setTitle:@"My GIF"];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"invisilogo"]];
    self.navigationItem.titleView.userInteractionEnabled =YES;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(backToIt:)];
    [self.navigationItem.titleView addGestureRecognizer:singleFingerTap];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings"] style:UIBarButtonItemStylePlain target:self action:@selector(settingsPage2)];
    
    UIBlurEffect *thisEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *thisViews = [[UIVisualEffectView alloc]initWithEffect:thisEffect];
    thisViews.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:thisViews atIndex:1];
    
    
    
    goingToNextView2 = [[UIView alloc]initWithFrame:CGRectMake(0,0,200,130)];
    goingToNextView2.backgroundColor = [UIColor blackColor];
    goingToNextView2.layer.opacity = 0.7;
    goingToNextView2.layer.cornerRadius = 20.0;
    goingToNextView2.clipsToBounds = YES;
    goingToNextView2.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    
    UILabel *badLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    [badLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
    badLabel.textColor = [UIColor whiteColor];
    badLabel.textAlignment = NSTextAlignmentCenter;
    badLabel.text = @"Creating GIF...";
    [badLabel sizeToFit];
    badLabel.center = CGPointMake(100, 95);
    [goingToNextView2 addSubview:badLabel];
   // [self pulseView2:goingToNextView2];
    
    UIActivityIndicatorView *tView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [tView startAnimating];
    tView.center = CGPointMake(100, 40);
    [goingToNextView2 addSubview:tView];
    
    [self.view insertSubview:goingToNextView2 atIndex:100];
    

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // your initialization code
    [self imageScroll];
    [self.view insertSubview:goingToNextView2 atIndex:100];

    
    thisArr = [delegate getThisArray];
    
    offsetNum = 0;//[UIScreen mainScreen].bounds.size.height - 88;

    globalSpeed1 = 0.3;

    globalSpeed2 = 0.2;
    
    
    NSLog(@"THIS IS MY POINT: %@", NSStringFromCGPoint(myPoint));
    
    NSLog(@"LOG ZOOMFRAME: %@", NSStringFromCGRect(zoomFrame));

    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140*scaleFactor2, 300, 300)];
    
    imageView.layer.cornerRadius = 10.0f;
    imageView.clipsToBounds = YES;
    
    imageView.image = mainImage;
    
    textLabel = [[THLabel alloc]initWithFrame:CGRectMake(20, 200, 260, 100)];
    
    textLabel.text= @"ADD TEXT HERE";
    textLabel.layer.opacity = 0.5;
    
    [textLabel setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
    textLabel.textColor = [UIColor whiteColor];
    
    textLabel.strokeSize = 2.0f;
    textLabel.strokePosition = THLabelStrokePositionOutside;
    textLabel.strokeColor = [UIColor blackColor];
    textLabel.letterSpacing = 2.0f;
    textLabel.textAlignment = NSTextAlignmentCenter;
    
    textField = [[UITextField alloc] initWithFrame:textLabel.frame];
    //[textField setBorderStyle:UITextBorderStyleNone];
    [textField setText:@""];
    textField.font = [UIFont fontWithName:@"Impact" size:32.0f];
    textField.textColor = [UIColor clearColor];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    textField.returnKeyType = UIReturnKeyDone;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [textField setDelegate:self];
    textField.userInteractionEnabled=YES;
    imageView.userInteractionEnabled = YES;
    //textField.layer.opacity = 0.1;
    [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [imageView addSubview:textLabel];
    [imageView addSubview:textField];
    
    textLabel2 = [[THLabel alloc]initWithFrame:CGRectMake(20, 0, 260, 100)];
    
    textLabel2.text= @"ADD TEXT HERE";
    textLabel2.layer.opacity = 0.5;
    
    [textLabel2 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
    textLabel2.textColor = [UIColor whiteColor];
    
    textLabel2.strokeSize = 2.0f;
    textLabel2.strokePosition = THLabelStrokePositionOutside;
    textLabel2.strokeColor = [UIColor blackColor];
    textLabel2.letterSpacing = 2.0f;
    textLabel2.textAlignment = NSTextAlignmentCenter;

    textField2 = [[UITextField alloc] initWithFrame:textLabel2.frame];
    textField2.keyboardAppearance = UIKeyboardAppearanceDark;

    //[textField setBorderStyle:UITextBorderStyleNone];
    [textField2 setText:@""];
    textField2.font = [UIFont fontWithName:@"Impact" size:32.0f];
    textField2.textColor = [UIColor clearColor];
    textField2.textAlignment = NSTextAlignmentCenter;
    textField2.returnKeyType = UIReturnKeyDone;
    textField2.autocorrectionType = UITextAutocorrectionTypeNo;
    
    
    [textField2 setDelegate:self];
    textField2.userInteractionEnabled=YES;
    //textField.layer.opacity = 0.1;
    [textField2 addTarget:self action:@selector(textFieldDidChange2:) forControlEvents:UIControlEventEditingChanged];
    [imageView addSubview:textLabel2];
    [imageView addSubview:textField2];
    
    myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goFullscreen:)];
    toClipboard.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:myTap];
    
    toClipboard = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(clipboard:)];
    toClipboard.minimumPressDuration = 0.3;
    [imageView addGestureRecognizer:toClipboard];
    
//    [myTap requireGestureRecognizerToFail:toClipboard];

    
    //UIBlurEffect *thisEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //UIVisualEffectView *thisViews = [[UIVisualEffectView alloc]initWithEffect:thisEffect];
    //thisViews.frame = [UIScreen mainScreen].bounds;
    [self.view insertSubview:thisViews atIndex:1];
    
        
        
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    scrollView.backgroundColor = [UIColor clearColor];
    //scrollview.layer.opacity = 0.0;
    
    for(int i = 0; i< viewcount; i++) {
        
        CGFloat y = i * self.view.frame.size.height;
        
       // UIBlurEffect *thisEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
       // UIVisualEffectView *thisView = [[UIVisualEffectView alloc]initWithEffect:thisEffect];
        
        UIView *thisView = [[UIView alloc]init];
        
        thisView.backgroundColor = [UIColor clearColor];
        
        thisView.frame = CGRectMake(0, y,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        if (i == 0){
            blackoutView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            blackoutView.backgroundColor = [UIColor clearColor];
            blackoutView.layer.opacity = 0.0;
            blackoutView.hidden = YES;
            
            UIVisualEffectView *thisd = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
            thisd.frame = blackoutView.bounds;
            [blackoutView addSubview:thisd];
            
            thisScroller2 = [[UIScrollView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width + 30, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width)];
            
            
            int x = 0;
            for (int i = 0; i < 6; i++) {
                SpecialButton2 *button = [[SpecialButton2 alloc] initWithFrame:CGRectMake(x+15, (thisScroller2.frame.size.height -100)/2, 100, 100)];
                
                
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
               
                    /*
                } else if (i == 2){
                    
                    [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"Delete"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(deletePic) forControlEvents:UIControlEventTouchUpInside];
                    */
                } else if (i == 2){
                    
                    [button setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"Message"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(messagePic) forControlEvents:UIControlEventTouchUpInside];
                    //[button.titleLabel sizeToFit];
                } else if (i == 3){
                    
                    [button setImage:[UIImage imageNamed:@"messenger"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"Messenger"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(messengerPic) forControlEvents:UIControlEventTouchUpInside];
                    
                    //} else if (i == 5) {
                    
                    //   [button setImage:[UIImage imageNamed:@"facebookstuff"] forState:UIControlStateNormal];
                    //   [button setTitle:[NSString stringWithFormat:@"Facebook"] forState:UIControlStateNormal];
                    //   [button addTarget:self action:@selector(facebookPic) forControlEvents:UIControlEventTouchUpInside];
                    
                } else if (i == 4){
                    
                    [button setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"Twitter"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(twitterPic) forControlEvents:UIControlEventTouchUpInside];
                    
                } else if(i == 5){
                    
                    [button setImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"Email"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(emailPic) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                } else {
                    
                    [button setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"More"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(morePic) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                [thisScroller2 addSubview:button];
                
                x += button.frame.size.width;
            }
            
            thisScroller2.contentSize = CGSizeMake(x + 20, thisScroller2.frame.size.height);
            //scrollView.backgroundColor = [UIColor redColor];
            
            [blackoutView addSubview:thisScroller2];
            
            [thisScroller2 setShowsHorizontalScrollIndicator:NO];
            [thisScroller2 setShowsVerticalScrollIndicator:NO];
            
            //[dragView insertSubview:fullView atIndex:30];

            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300*scaleFactor2)/2, ([UIScreen mainScreen].bounds.size.height - 10*scaleFactor2), 300*scaleFactor2, 2)];
            lineView.backgroundColor = [UIColor whiteColor];
            [thisView addSubview:lineView];
            
           // [self drawRect:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300)/2, [UIScreen mainScreen].bounds.size.height, 300, 1)];
            
            //[self.view insertSubview:blackoutView belowSubview:imageView];
            
            threeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            
            threeLabel.text = @"Three";
            
            [threeLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:22.0f]];
            
            threeLabel.textColor = [UIColor whiteColor];
            
            [threeLabel sizeToFit];
            
            if (scaleFactor2 < 1){
                threeLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, 92.0f);
            } else {
            threeLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, 102.0f);
            }
            threeLabel.layer.borderColor = (__bridge CGColorRef)([UIColor redColor]);
            threeLabel.layer.borderWidth = 1.0f;
            threeLabel.layer.cornerRadius = 5.0f;
            
            [thisView insertSubview:threeLabel belowSubview:imageView];
            
            
            UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            
            infoLabel.text = @"Tap GIF to share.\nTouch and hold to copy GIF to clipboard.";
            
            infoLabel.numberOfLines = 2;
            
            [infoLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.5f]];
            
            infoLabel.textColor = [UIColor whiteColor];
            
            infoLabel.textAlignment = UITextAlignmentCenter;
            
            [infoLabel sizeToFit];
            
            if (scaleFactor2 < 1){
                infoLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, imageView.frame.origin.y + imageView.frame.size.height + 53 - 20);
            } else {
                infoLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, imageView.frame.origin.y + imageView.frame.size.height + 53*scaleFactor2);
            }
            

            
           // infoLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, imageView.frame.origin.y + imageView.frame.size.height + 38);
            
            [thisView addSubview:infoLabel];
            
            
            UILabel *speedLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            
            speedLabel.text = @"GIF Speed";
            
            [speedLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0f]];
            
            speedLabel.textColor = [UIColor whiteColor];
            
            [speedLabel sizeToFit];
            
            if (scaleFactor2 < 1){
                speedLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, imageView.frame.origin.y + imageView.frame.size.height + 118*scaleFactor2 - 25);
            } else {
                speedLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, imageView.frame.origin.y + imageView.frame.size.height + 118*scaleFactor2);
            }
            
            
            [thisView addSubview:speedLabel];
            
            slider1 = [[UISlider alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + 10, imageView.frame.origin.y + imageView.frame.size.height + 115*scaleFactor2, imageView.frame.size.width - 20*scaleFactor2, 80*scaleFactor2)];
            
            if (scaleFactor2 < 1){
                slider1 = [[UISlider alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + 10, imageView.frame.origin.y + imageView.frame.size.height + 115*scaleFactor2-25, imageView.frame.size.width - 20, 80*scaleFactor2)];
            } else {
                slider1 = [[UISlider alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + 10, imageView.frame.origin.y + imageView.frame.size.height + 115*scaleFactor2, imageView.frame.size.width - 20, 80*scaleFactor2)];
            }
            
            slider1.continuous = YES;
            [slider1 addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
            [slider1 addTarget:self action:@selector(valueEnded:) forControlEvents:UIControlEventEditingDidEnd];
            [slider1 setMaximumValue:0.5];
            [slider1 setMinimumValue:0.1];
            slider1.value = 0.3;
            slider1.userInteractionEnabled = YES;
            slider1.minimumTrackTintColor = [UIColor colorWithRed:20.0/256.0 green:236.0/256.0 blue:153.0/256.0 alpha:1];
            slider1.minimumValueImage = [UIImage imageNamed:@"speed_min"];
            slider1.maximumValueImage = [UIImage imageNamed:@"speed_max"];
            //[thisView insertSubview:slider1 aboveSubview:blackoutView];
            [thisView addSubview:slider1];

            
            
            [thisView addSubview:blackoutView];
            [thisView addSubview:imageView];


            [scrollView addSubview:thisView];

        } else {
            
            if (scaleFactor2 < 1){
                imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140 + offsetNum - 70, 300, 300)];
                
            } else {
                imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140 + offsetNum - 50, 300, 300)];
            }
            
            imageView2.layer.cornerRadius = 10.0f;
            imageView2.clipsToBounds = YES;
            
            imageView2.image = mainImage;
            
            textLabel3 = [[THLabel alloc]initWithFrame:CGRectMake(20, 200, 260, 100)];
            
            textLabel3.text= @"ADD TEXT HERE";
            textLabel3.layer.opacity = 0.5;
            
            [textLabel3 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
            textLabel3.textColor = [UIColor whiteColor];
            
            textLabel3.strokeSize = 2.0f;
            textLabel3.strokePosition = THLabelStrokePositionOutside;
            textLabel3.strokeColor = [UIColor blackColor];
            textLabel3.letterSpacing = 2.0f;
            textLabel3.textAlignment = NSTextAlignmentCenter;
            
            textField3 = [[UITextField alloc] initWithFrame:textLabel3.frame];
            //[textField setBorderStyle:UITextBorderStyleNone];
            [textField3 setText:@""];
            textField3.font = [UIFont fontWithName:@"Impact" size:32.0f];
            textField3.textColor = [UIColor clearColor];
            textField3.textAlignment = NSTextAlignmentCenter;
            textField3.keyboardAppearance = UIKeyboardAppearanceDark;
            textField3.returnKeyType = UIReturnKeyDone;
            textField3.autocorrectionType = UITextAutocorrectionTypeNo;
            
            [textField3 setDelegate:self];
            textField3.userInteractionEnabled=YES;
            imageView2.userInteractionEnabled = YES;
            //textField.layer.opacity = 0.1;
            [textField3 addTarget:self action:@selector(textFieldDidChange3:) forControlEvents:UIControlEventEditingChanged];
            [imageView2 addSubview:textLabel3];
            [imageView2 addSubview:textField3];
            
            textLabel4 = [[THLabel alloc]initWithFrame:CGRectMake(20, 0, 260, 100)];
            
            textLabel4.text= @"ADD TEXT HERE";
            textLabel4.layer.opacity = 0.5;
        
            [textLabel4 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
            textLabel4.textColor = [UIColor whiteColor];
            
            textLabel4.strokeSize = 2.0f;
            textLabel4.strokePosition = THLabelStrokePositionOutside;
            textLabel4.strokeColor = [UIColor blackColor];
            textLabel4.letterSpacing = 2.0f;
            textLabel4.textAlignment = NSTextAlignmentCenter;
            
            textField4 = [[UITextField alloc] initWithFrame:textLabel4.frame];
            textField4.keyboardAppearance = UIKeyboardAppearanceDark;
            
            //[textField setBorderStyle:UITextBorderStyleNone];
            [textField4 setText:@""];
            textField4.font = [UIFont fontWithName:@"Impact" size:32.0f];
            textField4.textColor = [UIColor clearColor];
            textField4.textAlignment = NSTextAlignmentCenter;
            textField4.returnKeyType = UIReturnKeyDone;
            textField4.autocorrectionType = UITextAutocorrectionTypeNo;
            
            
            [textField4 setDelegate:self];
            textField4.userInteractionEnabled=YES;
            //textField.layer.opacity = 0.1;
            [textField4 addTarget:self action:@selector(textFieldDidChange4:) forControlEvents:UIControlEventEditingChanged];
            [imageView2 addSubview:textLabel4];
            [imageView2 addSubview:textField4];
            
            myTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goFullscreen2:)];
            [imageView2 addGestureRecognizer:myTap2];
            
            toClipboard2 = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(clipboard2:)];
            toClipboard2.minimumPressDuration = 0.3;
            [imageView2 addGestureRecognizer:toClipboard2];

            
            
            
            UIView *thisView2 = [[UIView alloc]init];
            
            thisView2.backgroundColor = [UIColor clearColor];
            
            thisView2.frame = CGRectMake(0, y,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

            
            blackoutView2 = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
            blackoutView2.backgroundColor = [UIColor clearColor];
            blackoutView2.layer.opacity = 0.0;
            blackoutView2.hidden = YES;
            
            UIVisualEffectView *thisd2 = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
            thisd2.frame = blackoutView2.bounds;
            [blackoutView2 addSubview:thisd2];
            
            thisScroller3 = [[UIScrollView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width + 30, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width)];
            
            
            int x = 0;
            for (int i = 0; i < 6; i++) {
                SpecialButton2 *button = [[SpecialButton2 alloc] initWithFrame:CGRectMake(x+15, (thisScroller2.frame.size.height -100)/2, 100, 100)];
                
                
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
                    
                    /*
                } else if (i == 2){
                    
                    [button setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"Delete"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(deletePic) forControlEvents:UIControlEventTouchUpInside];
                    
                     */
                } else if (i == 2){
                    
                    [button setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"Message"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(messagePic) forControlEvents:UIControlEventTouchUpInside];
                    //[button.titleLabel sizeToFit];
                } else if (i == 3){
                    
                    [button setImage:[UIImage imageNamed:@"messenger"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"Messenger"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(messengerPic) forControlEvents:UIControlEventTouchUpInside];
                    
                    //} else if (i == 5) {
                    
                    //   [button setImage:[UIImage imageNamed:@"facebookstuff"] forState:UIControlStateNormal];
                    //   [button setTitle:[NSString stringWithFormat:@"Facebook"] forState:UIControlStateNormal];
                    //   [button addTarget:self action:@selector(facebookPic) forControlEvents:UIControlEventTouchUpInside];
                    
                } else if (i == 4){
                    
                    [button setImage:[UIImage imageNamed:@"twitter"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"Twitter"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(twitterPic) forControlEvents:UIControlEventTouchUpInside];
                    
                } else if(i == 5){
                    
                    [button setImage:[UIImage imageNamed:@"email"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"Email"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(emailPic) forControlEvents:UIControlEventTouchUpInside];
                    
                    
                } else {
                    
                    [button setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
                    [button setTitle:[NSString stringWithFormat:@"More"] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(morePic) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                [thisScroller3 addSubview:button];
                
                x += button.frame.size.width;
            }
            
            thisScroller3.contentSize = CGSizeMake(x + 20, thisScroller3.frame.size.height);
            //scrollView.backgroundColor = [UIColor redColor];
            
            [blackoutView2 addSubview:thisScroller3];
            
            [thisScroller3 setShowsHorizontalScrollIndicator:NO];
            [thisScroller3 setShowsVerticalScrollIndicator:NO];

            
            fiveLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            
            fiveLabel.text = @"Four";
            
            [fiveLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:22.0f]];
            
            fiveLabel.textColor = [UIColor whiteColor];
            
            [fiveLabel sizeToFit];
            
            if (scaleFactor2 < 1){
                fiveLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, 102.0f + offsetNum - 65);

            } else {
                fiveLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, 102.0f + offsetNum - 50*scaleFactor2);
            }
            
            [thisView2 insertSubview:fiveLabel belowSubview:imageView2];
            
            
            UILabel *infoLabel2 = [[UILabel alloc]initWithFrame:CGRectZero];
            
            infoLabel2.text = @"Tap GIF to share.\nTouch and hold to copy GIF to clipboard.";
            
            infoLabel2.numberOfLines = 2;
            
            [infoLabel2 setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:14.5f]];
            
            infoLabel2.textColor = [UIColor whiteColor];
            
            infoLabel2.textAlignment = UITextAlignmentCenter;
            
            [infoLabel2 sizeToFit];
            
            if (scaleFactor2 < 1){
                infoLabel2.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, imageView.frame.origin.y + imageView.frame.size.height + 53 + offsetNum - 70);
                
            } else {
                infoLabel2.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, imageView.frame.origin.y + imageView.frame.size.height + 53 + offsetNum - 50);
            }
            
            
            // infoLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, imageView.frame.origin.y + imageView.frame.size.height + 38);
            
            [thisView2 addSubview:infoLabel2];
            
            
            UILabel *speedLabel = [[UILabel alloc]initWithFrame:CGRectZero];
            
            speedLabel.text = @"GIF Speed";
            
            [speedLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:16.0f]];
            
            speedLabel.textColor = [UIColor whiteColor];
            
            [speedLabel sizeToFit];
            
            if (scaleFactor2 < 1){
                speedLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, imageView.frame.origin.y + imageView.frame.size.height + 118 + offsetNum - 90);
                
            } else {
                speedLabel.center = CGPointMake(imageView.frame.origin.x + imageView.frame.size.width/2, imageView.frame.origin.y + imageView.frame.size.height + 118 + offsetNum - 50);
            }
            
            [thisView2 addSubview:speedLabel];
            
            
            if (scaleFactor2 < 1){
                slider2 = [[UISlider alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + 10, imageView.frame.origin.y + imageView.frame.size.height + 115 + offsetNum- 90, imageView.frame.size.width - 20, 80)];
                
            } else {
                slider2 = [[UISlider alloc]initWithFrame:CGRectMake(imageView.frame.origin.x + 10, imageView.frame.origin.y + imageView.frame.size.height + 115 + offsetNum- 50, imageView.frame.size.width - 20, 80)];
            }
            
            
            slider2.continuous = YES;
            [slider2 addTarget:self action:@selector(valueChanged2:) forControlEvents:UIControlEventValueChanged];
            [slider2 setMaximumValue:0.5];
            [slider2 setMinimumValue:0.1];
            slider2.value = 0.4;
            slider2.userInteractionEnabled = YES;
            slider2.minimumTrackTintColor = [UIColor colorWithRed:20.0/256.0 green:236.0/256.0 blue:153.0/256.0 alpha:1];
            slider2.minimumValueImage = [UIImage imageNamed:@"speed_min"];
            slider2.maximumValueImage = [UIImage imageNamed:@"speed_max"];
            //[thisView insertSubview:slider1 aboveSubview:blackoutView];
            [thisView2 addSubview:slider2];

            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 300*scaleFactor2)/2, slider2.center.y + 65, 300*scaleFactor2, 2)];
            
            
            lineView.backgroundColor = [UIColor whiteColor];
            [thisView2 addSubview:lineView];

            
            [thisView2 addSubview:blackoutView2];
            [thisView2 addSubview:imageView2];
            
            
            
            //[thisView insertSubview:actionMenu aboveSubview:imageView];
            
            [scrollView addSubview:thisView2];
            
            
            
            
        }

    }
    
    
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height *viewcount + 270);
    
    UIButton *gifMake = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, (150*scaleFactor2), (150*scaleFactor2))];
    gifMake.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.view.frame.size.height*viewcount+140);
    [gifMake setImage:[UIImage imageNamed:@"gbutton"] forState:UIControlStateNormal];
    [gifMake addTarget:self action:@selector(showBuyScreen) forControlEvents:UIControlEventTouchUpInside];
    [gifMake addTarget:self action:@selector(buttonPresser:) forControlEvents:UIControlEventTouchDown];
    [gifMake addTarget:self action:@selector(buttonReleaser:) forControlEvents:UIControlEventTouchUpInside];
    [gifMake addTarget:self action:@selector(buttonReleaser:) forControlEvents:UIControlEventTouchUpOutside];
    
    gifMake.adjustsImageWhenHighlighted = NO;

    [scrollView addSubview:gifMake];
    
    UILabel *gifLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    
    [gifLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:(20.0f*scaleFactor2)]];
    gifLabel.textColor = [UIColor whiteColor];
    gifLabel.textAlignment = NSTextAlignmentCenter;
    
    gifLabel.text = @"Customize with GIF Maker";
    
    [gifLabel sizeToFit];
    
    gifLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.view.frame.size.height*viewcount-5);
    
    selectView2 = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - (28.125*scaleFactor2), 228 * scaleFactor2, 56.25 * scaleFactor2, 26.25 * scaleFactor2)];
    
    selectView2.image = [UIImage imageNamed:@"select4"];
    
    selectView2.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.view.frame.size.height*viewcount+33);
    
    [scrollView insertSubview:selectView2 atIndex:0];
    
 
    pulserTimer =   [NSTimer scheduledTimerWithTimeInterval:0.8
                                                    target:self
                                                   selector:@selector(pulserImageView)
                                                  userInfo:nil
                                                   repeats:YES];
  
    [self pulserImageView];

    


    
    [scrollView insertSubview:gifLabel atIndex:0];
    
    
    [self.view insertSubview:scrollView atIndex:2];
        
        
                             
    [UIView animateWithDuration:0.2 delay:0.1 options:nil animations:^{
                                 
         goingToNextView2.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                 
    } completion:^(BOOL finished){
        
        [goingToNextView2 removeFromSuperview];
        
    }];
                             
                        
    
    
    [self createThreeGIF];
    
    
    });

}

-(void)showBuyScreen{
    
    gifBuyController *controlThis = [[gifBuyController alloc]init];
    controlThis.delegate = self;
    //for (int i=0; i<10; ++i) {
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"hasPurchased"]  isEqual: @"YES"]){

        controlThis.images = [[NSMutableArray alloc]init];
        controlThis.originalImage = mainImage;
        [controlThis.images addObject:img1];
        [controlThis.images addObject:img4];
        [controlThis.images addObject:img2];
        [controlThis.images addObject:img3];
        
        
        for (int i = 0; i < 4; ++i){
            NSNumber *num = [NSNumber numberWithFloat:0.0f];
            //[imageOffsets addObject:num];
            [controlThis.offsets insertObject:num atIndex:i];
        }
        
        
    }
    
    [self showViewController:controlThis sender:self];

    //}
    
    
}




- (void) buttonPresser:(UIButton*)button {
    [UIView beginAnimations:@"ScaleButton" context:NULL];
    [UIView setAnimationDuration: 0.12f];
    button.transform = CGAffineTransformMakeScale(0.9,0.9);
    [UIView commitAnimations];
}

// Scale down on button release
- (void) buttonReleaser:(UIButton*)button {
    
    [UIView animateWithDuration:0.09
                          delay:0.0
                        options: UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         button.transform = CGAffineTransformMakeScale(1.15,1.15);}
                     completion:^(BOOL finished){
                         
                         //[self animateBack];
                         
                         [UIView animateWithDuration:0.09
                                               delay:0.0
                                             options: UIViewAnimationOptionAllowUserInteraction
                                          animations:^{
                                              button.transform = CGAffineTransformMakeScale(0.95,0.95);}
                                          completion:^(BOOL finished){
                                              [UIView animateWithDuration:0.09
                                                                    delay:0.0
                                                                  options: UIViewAnimationOptionAllowUserInteraction
                                                               animations:^{
                                                                   button.transform = CGAffineTransformMakeScale(1,1);}
                                                               completion:nil];
                                              
                                          }
                          ];
                     }];
}



-(void)pulserImageView{
    
    
   // if (movedAlready == NO){
    
    
        [UIView animateWithDuration:0.4 animations:^{
            
            //    zoomButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
            
            //        myView.frame = CGRectMake(myView.frame.origin.x, myView.frame.origin.y - 7, myView.frame.size.width, myView.frame.size.height);
            selectView2.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.view.frame.size.height*viewcount+28);
            //upImage.frame = CGRectMake(upImage.frame.origin.x, upImage.frame.origin.y + (10*scaleFactor), upImage.frame.size.width, upImage.frame.size.height);
            
            
            
            
        } completion:^(BOOL finished){
            
            [UIView animateWithDuration:0.4 animations:^{
                
                //                    myView.frame = CGRectMake(myView.frame.origin.x, myView.frame.origin.y + 7, myView.frame.size.width, myView.frame.size.height);
                
                selectView2.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, self.view.frame.size.height*viewcount+38);
                
             //   upImage.frame = CGRectMake(upImage.frame.origin.x, upImage.frame.origin.y - (10*scaleFactor), upImage.frame.size.width, upImage.frame.size.height);
                
                
            } completion:^(BOOL finished){
                
               // [self pulserImageView];
                
            }];
            
        }];
        
   // }
    
}




-(UIImage *)imageFixer:(UIImage *)og{
    
    if (og.size.height > og.size.width){
        CGRect rect = CGRectMake(0, 0, og.size.height, og.size.height);
        UIGraphicsBeginImageContext( rect.size );
        [og drawInRect:rect];
        UIImage *newpic = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newpic;
   
    } else if (og.size.width > og.size.height){
        CGRect rect = CGRectMake(0, 0, og.size.width, og.size.width);
        UIGraphicsBeginImageContext( rect.size );
        [og drawInRect:rect];
        UIImage *newpic = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newpic;
    } else {

        return og;

    }

}



-(void)clipboard:(UILongPressGestureRecognizer *)myPress{
    if (myPress.state == UIGestureRecognizerStateBegan && pressed == NO){
        
        pressed = YES;
        
       //[SVProgressHUD show];

        
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
        inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
        
        inder.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        inder.backgroundColor = [UIColor blackColor];
        inder.layer.opacity = 0.8;
        inder.layer.cornerRadius = 20.0;
        [inder startAnimating];
        UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        loadingLabel.text = @"Creating GIF...";
        
        [loadingLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
        
        loadingLabel.textColor = [UIColor whiteColor];
        
        [loadingLabel sizeToFit];
        
        loadingLabel.center = CGPointMake(100, 120);
        
        [inder addSubview:loadingLabel];


        [self.view insertSubview:inder aboveSubview:imageView];
        
      //  - (void) makeMyGif:(UIImage *)firstPic : (UIImage *)secondPic : (UIImage *) thirdPic :(UIImage *)fourthPic{
        
        [self makeMyGif:img1 :img2 :img3 :img4];
        

    }

}


-(void)clipboard2:(UILongPressGestureRecognizer *)myPress{
    if (myPress.state == UIGestureRecognizerStateBegan && pressed == NO){
        
        pressed = YES;
        
        //[SVProgressHUD show];
        
        
        NSLog(@"UIGestureRecognizerStateBegan.");
        //Do Whatever You want on Began of Gesture
        inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
        
        inder.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        inder.backgroundColor = [UIColor blackColor];
        inder.layer.opacity = 0.8;
        inder.layer.cornerRadius = 20.0;
        [inder startAnimating];
        UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        loadingLabel.text = @"Creating GIF...";
        
        [loadingLabel setFont:[UIFont fontWithName:@"AvenirNext-DemiBold" size:20.0f]];
        
        loadingLabel.textColor = [UIColor whiteColor];
        
        [loadingLabel sizeToFit];
        
        loadingLabel.center = CGPointMake(100, 120);
        
        [inder addSubview:loadingLabel];
        
        
        [self.view insertSubview:inder aboveSubview:imageView2];
        
        
        [self makeMyGif2:img1 :img2 :img3 :img4];
        
        
    }
    
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



-(void)valueChanged:(UISlider *)thisSlider{
    
    //[thisSlider setValue:((int)((thisSlider.value + 2.5) / 5) * 5) animated:NO];
    globalSpeed1 = 0.6 - thisSlider.value;
}

-(void)valueChanged2:(UISlider *)thisSlider{
    
    //[thisSlider setValue:((int)((thisSlider.value + 2.5) / 5) * 5) animated:NO];
    globalSpeed2 = 0.6 - thisSlider.value;
}




-(void)zoomChanged:(UISlider *)thisSlider{
    
    //[thisSlider setValue:((int)((thisSlider.value + 2.5) / 5) * 5) animated:NO];
    [thisTimer invalidate];
    globalZoom1 = thisSlider.value;
    [self createThreeGIF];
}


-(void)valueEnded:(UISlider *)thisSlider{
    if (thisSlider.value > 0.27 || thisSlider.value < 0.33){
        [thisSlider setValue:0.3 animated:NO];
    }
}

-(void)goFullscreen2:(UITapGestureRecognizer *)tap{
    
    if (isFullscreen == NO){
        
        
        if (isTyping == YES){
            [self dismissKeyboard];
            isTyping = NO;
        } else {
            
            myAction = 1;
            
            blackoutView2.hidden = NO;
            
            textLabel3.layer.opacity = 0;
            
            textLabel4.layer.opacity = 0;
            
            UIView *thisView = tap.view;
            
            
            //CGFloat newScale2 = [UIScreen mainScreen].bounds.size.width/(thisView.frame.size.width + 40);
            CGFloat newScale = [UIScreen mainScreen].bounds.size.width/thisView.frame.size.width;
            
            CGFloat tempHeight = self.navigationController.navigationBar.frame.size.height + 20 - 50;
            
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                
                
                thisScroller3.frame = CGRectMake(-30, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width);

                
                thisView.frame = CGRectMake(0, tempHeight+50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
                
                textLabel3.frame = CGRectMake(20*newScale, 2*[UIScreen mainScreen].bounds.size.width/3, 260*newScale, [UIScreen mainScreen].bounds.size.width/3);
                [textLabel3 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                [textField3 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                textField3.frame = textLabel3.frame;
                
                textLabel4.frame = CGRectMake(20*newScale, 0, 260*newScale, [UIScreen mainScreen].bounds.size.width/3);
                [textLabel4 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                [textField4 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                textField4.frame = textLabel4.frame;
                
                
                thisView.layer.cornerRadius = 0.0;
                blackoutView2.layer.opacity = 1;
                
                [scrollView setContentOffset:CGPointMake(0, [UIScreen mainScreen].bounds.size.height) animated:YES];
                
                scrollView.scrollEnabled = NO;
                
                /*
                 textLabel.frame = CGRectMake(20*newScale2, 2*([UIScreen mainScreen].bounds.size.width + 40)/3, 260*newScale2, ([UIScreen mainScreen].bounds.size.width + 40)/3);
                 [textLabel setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale2]];
                 [textField setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale2]];
                 textField.frame = textLabel.frame;
                 
                 textLabel2.frame = CGRectMake(20*newScale2, 0, 260*newScale2, ([UIScreen mainScreen].bounds.size.width + 40)/3);
                 [textLabel2 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale2]];
                 [textField2 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale2]];
                 textField2.frame = textLabel2.frame;
                 */
                
            } completion:^(BOOL finished){
                
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                    
                    
                    thisScroller3.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width);

                    
                    /*
                     thisView.frame = CGRectMake(0, tempHeight+50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
                     
                     textLabel.frame = CGRectMake(20*newScale, 2*[UIScreen mainScreen].bounds.size.width/3, 260*newScale, [UIScreen mainScreen].bounds.size.width/3);
                     [textLabel setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                     [textField setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                     textField.frame = textLabel.frame;
                     
                     textLabel2.frame = CGRectMake(20*newScale, 0, 260*newScale, [UIScreen mainScreen].bounds.size.width/3);
                     [textLabel2 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                     [textField2 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                     textField2.frame = textLabel2.frame;
                     */
                    
                    if (![textField3.text  isEqual: @""]){
                        
                        textLabel3.layer.opacity = 1;
                        
                    }
                    
                    if (![textField4.text  isEqual: @""]){
                        
                        textLabel4.layer.opacity = 1;
                        
                    }
                    
                    isFullscreen = YES;
                    
                    // NSLog(@"THE FRAME: %@", NSStringFromCGRect(originalFrame));
                    
                    textField3.userInteractionEnabled = NO;
                    
                    textField4.userInteractionEnabled = NO;
                    
                    
                } completion:^(BOOL finished){
                
                    
                    [self makeGifSilently2:img1 :img2 :img3 :img4];

                    
                }];
                
            }];
            
        }
        
        
    } else {
        
        
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
            
            UIView *thisView = tap.view;
            
            thisScroller3.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + 30, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width);

            
            //thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140, 300, 300);
            
            //thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140 + offsetNum - 50, 300, 300);
            if (scaleFactor2 < 1){
                thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140 + offsetNum - 70, 300, 300);
                
            } else {
                thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140 + offsetNum - 50, 300, 300);
            }
            
            thisView.layer.cornerRadius = 20.0;
            
            blackoutView2.layer.opacity = 0.0;
            
            textLabel3.frame = CGRectMake(20, 200, 260, 100);
            
            [textLabel3 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
            
            [textField3 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
            
            textField3.frame = textLabel3.frame;
            
            textLabel4.frame = CGRectMake(20, 0, 260, 100);
            
            [textLabel4 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        
            [textField4 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
            
            textField4.frame = textLabel4.frame;
            
            
            textField3.hidden = NO;
            textLabel3.hidden = NO;
            textField4.hidden = NO;
            textLabel4.hidden = NO;
            //thisView.frame
            
        } completion:^(BOOL finished){
            
            NSLog(@"THE FRAME: %@", NSStringFromCGRect(originalFrame));
            
            scrollView.scrollEnabled = YES;
            
            
            isFullscreen = NO;
            
            if ([textField3.text  isEqual: @""]){
                
                textLabel3.layer.opacity = 0.5;
                
            }
            
            if ([textField4.text  isEqual: @""]){
                
                textLabel4.layer.opacity = 0.5;
                
            }
            
            textField3.userInteractionEnabled = YES;
            textField4.userInteractionEnabled = YES;
            blackoutView2.hidden = YES;
            
            /*
             [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
             
             thisView.frame = CGRectMake(0, tempHeight+50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
             //thisView.frame
             
             } completion:nil];
             */
        }];
        
        
    }
    

}

-(void)goFullscreen:(UITapGestureRecognizer *)tap{
    
    if (isFullscreen == NO){
        
        if (isTyping == YES){
            [self dismissKeyboard];
            isTyping = NO;
        } else {
            
            myAction = 0;
            
            blackoutView.hidden = NO;

            textLabel.layer.opacity = 0;
            
            textLabel2.layer.opacity = 0;
            
            UIView *thisView = tap.view;
            
            [thisScroller2 setContentOffset:CGPointMake(0, 0) animated:NO];
        
    
        //CGFloat newScale2 = [UIScreen mainScreen].bounds.size.width/(thisView.frame.size.width + 40);
            CGFloat newScale = [UIScreen mainScreen].bounds.size.width/thisView.frame.size.width;
        
            CGFloat tempHeight = self.navigationController.navigationBar.frame.size.height + 20 - 50;
        
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                
                thisScroller2.frame = CGRectMake(-30, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width);
            
            
                thisView.frame = CGRectMake(0, tempHeight+50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
            
                textLabel.frame = CGRectMake(20*newScale, 2*[UIScreen mainScreen].bounds.size.width/3, 260*newScale, [UIScreen mainScreen].bounds.size.width/3);
                [textLabel setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                [textField setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                textField.frame = textLabel.frame;
            
                textLabel2.frame = CGRectMake(20*newScale, 0, 260*newScale, [UIScreen mainScreen].bounds.size.width/3);
                [textLabel2 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                [textField2 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                textField2.frame = textLabel2.frame;
            
            
                thisView.layer.cornerRadius = 0.0;
                blackoutView.layer.opacity = 1;
            
                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
                scrollView.scrollEnabled = NO;
            
            /*
            textLabel.frame = CGRectMake(20*newScale2, 2*([UIScreen mainScreen].bounds.size.width + 40)/3, 260*newScale2, ([UIScreen mainScreen].bounds.size.width + 40)/3);
            [textLabel setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale2]];
            [textField setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale2]];
            textField.frame = textLabel.frame;
            
            textLabel2.frame = CGRectMake(20*newScale2, 0, 260*newScale2, ([UIScreen mainScreen].bounds.size.width + 40)/3);
            [textLabel2 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale2]];
            [textField2 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale2]];
            textField2.frame = textLabel2.frame;
            */
            
            } completion:^(BOOL finished){
            
                [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                
                    //blackoutView.layer.opacity = 1;

                    thisScroller2.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width);

                /*
                thisView.frame = CGRectMake(0, tempHeight+50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
                
                textLabel.frame = CGRectMake(20*newScale, 2*[UIScreen mainScreen].bounds.size.width/3, 260*newScale, [UIScreen mainScreen].bounds.size.width/3);
                [textLabel setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                [textField setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                textField.frame = textLabel.frame;
                
                textLabel2.frame = CGRectMake(20*newScale, 0, 260*newScale, [UIScreen mainScreen].bounds.size.width/3);
                [textLabel2 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                [textField2 setFont:[UIFont fontWithName:@"Impact" size:32.0 * newScale]];
                textField2.frame = textLabel2.frame;
                 */
                
                    if (![textField.text  isEqual: @""]){
                
                        textLabel.layer.opacity = 1;
                
                    }
                
                    if (![textField2.text  isEqual: @""]){
                
                        textLabel2.layer.opacity = 1;
                
                    }
                
                    isFullscreen = YES;
                
               // NSLog(@"THE FRAME: %@", NSStringFromCGRect(originalFrame));

                    textField.userInteractionEnabled = NO;
                
                    textField2.userInteractionEnabled = NO;

                
                } completion:^(BOOL finished){
                
                    [self makeGifSilently:img1 :img2 :img3 :img4];

                    
                }];
            
            }];
            
        }

    
    } else {

        
     //   [UIView animateWithDuration:0.2 delay:0.0 options:nil animations:^{
            
    //        thisScroller2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + 30, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width);

        
     //   } completion:^(BOOL finished){
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
            
            UIView *thisView = tap.view;
            
            thisScroller2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + 30, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width);

            
           // thisScroller2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width + 30, [UIScreen mainScreen].bounds.size.width + self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, [UIScreen mainScreen].bounds.size.height - (self.navigationController.navigationBar.frame.size.height + 20) - [UIScreen mainScreen].bounds.size.width);

            
            //thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140, 300, 300);
            
            thisView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 150, 140*scaleFactor2, 300, 300);
            
            thisView.layer.cornerRadius = 20.0;
            
            blackoutView.layer.opacity = 0.0;
            
            textLabel.frame = CGRectMake(20, 200, 260, 100);
            
            [textLabel setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
            
            [textField setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
            
            textField.frame = textLabel.frame;
            
            textLabel2.frame = CGRectMake(20, 0, 260, 100);
            
            [textLabel2 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
            
            [textField2 setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
            
            textField2.frame = textLabel2.frame;

            
            textField.hidden = NO;
            textLabel.hidden = NO;
            textField2.hidden = NO;
            textLabel2.hidden = NO;
            //thisView.frame
            
        } completion:^(BOOL finished){
            
            NSLog(@"THE FRAME: %@", NSStringFromCGRect(originalFrame));
            
            scrollView.scrollEnabled = YES;

            
            isFullscreen = NO;
            
            if ([textField.text  isEqual: @""]){
                
                textLabel.layer.opacity = 0.5;
                
            }
            
            if ([textField2.text  isEqual: @""]){
                
                textLabel2.layer.opacity = 0.5;
                
            }
            
            textField.userInteractionEnabled = YES;
            textField2.userInteractionEnabled = YES;
            blackoutView.hidden = YES;

            /*
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveLinear animations:^{
                
                thisView.frame = CGRectMake(0, tempHeight+50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
                //thisView.frame
                
            } completion:nil];
            */
        }];

    
    //}];
      
        
        
    }
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textFields { //Keyboard becomes visible
    
    [thisTimer invalidate];
    
    [thisTimer2 invalidate];
    
    
    if (textFields == textField || textFields == textField2){
        
        if (scaleFactor2 < 1){
            [scrollView setContentOffset:CGPointMake(0, 53) animated:YES];
        } else {
        [scrollView setContentOffset:CGPointMake(0, 10) animated:YES];
        }
        if ([textField.text isEqual:@""]){

            if (isFullscreen == NO){
                
                textLabel.layer.opacity = 0.5;
                
            } else {
                
                textLabel.layer.opacity = 0.0;
                
            }
        
        } else {
            
            textLabel.layer.opacity = 1.0;
            
        }
        
        if ([textField2.text isEqual:@""]){

            if (isFullscreen == NO){
                
                textLabel2.layer.opacity = 0.5;
                
            } else {
                
                textLabel2.layer.opacity = 0.0;
                
            }
        
        } else {
            
            textLabel2.layer.opacity = 1.0;
            
        }

    } else {
        
        
        [thisTimer2 invalidate];
        
        if (scaleFactor2 < 1){
            [scrollView setContentOffset:CGPointMake(0, 10 - 7 + [UIScreen mainScreen].bounds.size.height) animated:YES];
        } else {
            [scrollView setContentOffset:CGPointMake(0, 10 - 50 + [UIScreen mainScreen].bounds.size.height) animated:YES];
        }
        
        if ([textField3.text isEqual:@""]){
            
            if (isFullscreen == NO){
                
                textLabel3.layer.opacity = 0.5;
                
            } else {
                
                textLabel3.layer.opacity = 0.0;
                
            }
            
        } else {
            
            textLabel3.layer.opacity = 1.0;
            
        }
        
        if ([textField4.text isEqual:@""]){
            
            if (isFullscreen == NO){
                
                textLabel4.layer.opacity = 0.5;
                
            } else {
                
                textLabel4.layer.opacity = 0.0;
                
            }
            
        } else {
            
            textLabel4.layer.opacity = 1.0;
            
        }
        
    }
    
    scrollView.scrollEnabled = NO;
    
    isTyping = YES;
    
}

-(void)textFieldDidChange:(id)sender{
    [self frame4];
    [thisTimer invalidate];
    [textField setText:[textField.text uppercaseString]];
    textLabel.layer.opacity = 1.0;
    textLabel.text = textField.text;
}

-(void)textFieldDidChange2:(id)sender{
    [self frame4];
    [thisTimer invalidate];
    [textField2 setText:[textField2.text uppercaseString]];
    textLabel2.layer.opacity = 1.0;
    textLabel2.text = textField2.text;
}

-(void)textFieldDidChange3:(id)sender{
    //[self frame4];
    [self frame25];
    [thisTimer2 invalidate];
    [textField3 setText:[textField3.text uppercaseString]];
    textLabel3.layer.opacity = 1.0;
    textLabel3.text = textField3.text;
}

-(void)textFieldDidChange4:(id)sender{
    [self frame25];
    [thisTimer2 invalidate];
    [textField4 setText:[textField4.text uppercaseString]];
    textLabel4.layer.opacity = 1.0;
    textLabel4.text = textField4.text;
}


-(void)dismissKeyboard{
    isTyping = NO;
    [textField resignFirstResponder];
    [textField2 resignFirstResponder];
    [textField3 resignFirstResponder];
    [textField4 resignFirstResponder];

    thisTimer = [NSTimer scheduledTimerWithTimeInterval:0.6
                                                 target:self
                                               selector:@selector(frame1)
                                               userInfo:nil
                                                repeats:NO];
    
    /*
    thisTimer2 = [NSTimer scheduledTimerWithTimeInterval:0.6
                                                 target:self
                                               selector:@selector(frame21)
                                               userInfo:nil
                                                repeats:NO];
    NSLog(@"text 1: %@", textField.text);
    NSLog(@"text 2: %@", textField2.text);
     */
    
    [self frame21];
    
    scrollView.scrollEnabled = YES;
    
    if ([textField.text  isEqual: @""] && [textLabel.text isEqual: @""]){
        
        textLabel.text = @"ADD TEXT HERE";
        
        textLabel.layer.opacity = 0.5;
        
    }
    
    if ([textField2.text  isEqual: @""] && [textLabel2.text isEqual: @""]){
        
        textLabel2.text = @"ADD TEXT HERE";
        
        textLabel2.layer.opacity = 0.5;
        
    }
    
    if ([textField3.text  isEqual: @""] && [textLabel3.text isEqual: @""]){
        
        textLabel3.text = @"ADD TEXT HERE";
        
        textLabel3.layer.opacity = 0.5;
        
    }
    
    if ([textField4.text  isEqual: @""] && [textLabel4.text isEqual: @""]){
        
        textLabel4.text = @"ADD TEXT HERE";
        
        textLabel4.layer.opacity = 0.5;
        
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textFields
{
    
    isTyping = NO;
    
    if ([textField.text  isEqual: @""] && [textLabel.text isEqual: @""]){
        
        textLabel.text = @"ADD TEXT HERE";
        
        textLabel.layer.opacity = 0.5;
        
    }
    
    if ([textField2.text  isEqual: @""] && [textLabel2.text isEqual: @""]){
        
        textLabel2.text = @"ADD TEXT HERE";
        
        textLabel2.layer.opacity = 0.5;
        
    }
    
    if ([textField3.text  isEqual: @""] && [textLabel3.text isEqual: @""]){
        
        textLabel3.text = @"ADD TEXT HERE";
        
        textLabel3.layer.opacity = 0.5;
        
    }
    
    if ([textField4.text  isEqual: @""] && [textLabel4.text isEqual: @""]){
        
        textLabel4.text = @"ADD TEXT HERE";
        
        textLabel4.layer.opacity = 0.5;
        
    }
    
    
    scrollView.scrollEnabled = YES;
    
    [textFields resignFirstResponder];
    
    thisTimer = [NSTimer scheduledTimerWithTimeInterval:0.6
                                                 target:self
                                               selector:@selector(frame1)
                                               userInfo:nil
                                                repeats:NO];

    
    thisTimer2 = [NSTimer scheduledTimerWithTimeInterval:0.6
                                                 target:self
                                               selector:@selector(frame21)
                                               userInfo:nil
                                                repeats:NO];
    
    
    return YES;
    
}


-(CGRect) cropRectForFrame:(CGRect)frame
{
    
    CGFloat widthScale = self.imageView.bounds.size.width / self.imageView.image.size.width;
    CGFloat heightScale = self.imageView.bounds.size.height / self.imageView.image.size.height;
    float x, y, w, h, offset;
    if (widthScale<heightScale) {
        offset = (self.imageView.bounds.size.height - (self.imageView.image.size.height*widthScale))/2;
        x = frame.origin.x / widthScale;
        y = (frame.origin.y-offset) / widthScale;
        w = frame.size.width / widthScale;
        h = frame.size.height / widthScale;
    } else {
        offset = (self.imageView.bounds.size.width - (self.imageView.image.size.width*heightScale))/2;
        x = (frame.origin.x-offset) / heightScale;
        y = frame.origin.y / heightScale;
        w = frame.size.width / heightScale;
        h = frame.size.height / heightScale;
    }
    NSLog(@"making it mofo: %@", NSStringFromCGRect(CGRectMake(x, y, w, h)));
    NSLog(@"FRAME SIZE: %@", NSStringFromCGRect(self.imageView.frame));
    if (x < 0){
        x = 0;
    }
    if (y < 0){
        y = 0;
    }
  //  if (x > frame.size.width){
   //     x = frame.size.width - w;
  //  }
  //  if (y > frame.size.height){
     //   y = frame.size.height - h;
  //  }
    if ((x+w)>self.imageView.image.size.width){
        x = self.imageView.image.size.width - w;
    }
    if ((y+h)>self.imageView.image.size.height){
        y = self.imageView.image.size.height - h;
    }
    if (w > self.imageView.image.size.width){
        w = self.imageView.image.size.width;
        h = self.imageView.image.size.height;
        x = 0;
        y = 0;
    }
    if (h > self.imageView.image.size.height){
        w = self.imageView.image.size.width;
        h = self.imageView.image.size.height;
        x = 0;
        y = 0;
    }
    NSLog(@"IMAGE SIZE: %@", NSStringFromCGSize(self.imageView.image.size));
    return CGRectMake(x, y, w, h);
}

-(void)createThreeGIF{
    
    
    CGRect myRects = zoomFrame;
    
    NSLog(@"VIEW RECT:   %@\n", NSStringFromCGRect(myRects));
    
    CGRect myRect = CGRectMake(zoomFrame.origin.x + zoomFrame.size.width/2 - globalZoom1 * zoomFrame.size.width/2, zoomFrame.origin.y + zoomFrame.size.height/2 - globalZoom1 * zoomFrame.size.height/2, globalZoom1 * zoomFrame.size.width, globalZoom1 * zoomFrame.size.height);
    
    NSLog(@"Log the rect: %@", NSStringFromCGRect(myRect));
    
    CGRect cropRect2 = CGRectMake(myRect.origin.x - myRect.size.width, myRect.origin.y - myRect.size.height, myRect.size.width*3, myRect.size.height*3);
    
    //cropRect2 = [self otherCheckedCGRect:&cropRect2 :self.myPicView];
    
    CGRect myNewRect2 = [self cropRectForFrame:cropRect2];
    
    CGImageRef imageRef2 = CGImageCreateWithImageInRect([self.imageView.image CGImage], myNewRect2);
    img1 = [UIImage imageWithCGImage:imageRef2];
    
//    NSLog(@"Image size 1: %@", NSStringFromCGSize(img2.size));
    
    CGImageRelease(imageRef2);
    
    CGRect cropRect3 = CGRectMake(myRect.origin.x - myRect.size.width/4, myRect.origin.y - myRect.size.height/4, myRect.size.width*1.5, myRect.size.height*1.5);
    
    //cropRect3 = [self otherCheckedCGRect:&cropRect3 :self.myPicView];
    
    CGRect myNewRect3 = [self cropRectForFrame:cropRect3];
    
    CGImageRef imageRef3 = CGImageCreateWithImageInRect([self.imageView.image CGImage], myNewRect3);
    img2 = [UIImage imageWithCGImage:imageRef3];
    CGImageRelease(imageRef3);

 //   NSLog(@"Image size 2: %@", NSStringFromCGSize(img3.size));
    
    CGRect cropRect = CGRectMake(myRect.origin.x, myRect.origin.y, myRect.size.width, myRect.size.height);
    
    CGRect myNewRect = [self cropRectForFrame:cropRect];
    
  //  NSLog(@"WE CHANGED IT TOGETHER: %@", myNewRect);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.imageView.image CGImage], myNewRect);
    img3 = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);

//    NSLog(@"Image size 3: %@", NSStringFromCGSize(img.size));
    
    CGRect cropRect4 = CGRectMake(myRect.origin.x- myRect.size.width/2, myRect.origin.y-myRect.size.height/2, 2*myRect.size.width, 2*myRect.size.height);
    
    CGRect myNewRect4 = [self cropRectForFrame:cropRect4];
    
    CGImageRef imageRef4 = CGImageCreateWithImageInRect([self.imageView.image CGImage], myNewRect4);
    img4 = [UIImage imageWithCGImage:imageRef4];
    CGImageRelease(imageRef4);
    
//    NSLog(@"Image size 4: %@", NSStringFromCGSize(img4.size));

    [self makeAnimatedGif:img1 :img2 :img3 :img4];

}

-(void)frame1{
    
    if ([textField.text isEqual:@""]){
        
        if (isFullscreen == NO){
            
            textLabel.layer.opacity = 0.5;
            
        } else {
            
            textLabel.layer.opacity = 0.0;
            
        }
        
    } else {
        
        textLabel.layer.opacity = 1.0;
        
    }
    
    if ([textField2.text isEqual:@""]){
        
        if (isFullscreen == NO){
            
            textLabel2.layer.opacity = 0.5;
            
        } else {
            
            textLabel2.layer.opacity = 0.0;
            
        }
        
    } else {
        
        textLabel2.layer.opacity = 1.0;
        
    }
    
    self.imageView.image = img1;
    
    textLabel.layer.opacity = 0.0;
    
    textLabel2.layer.opacity = 0.0;
    
    thisTimer = [NSTimer scheduledTimerWithTimeInterval:globalSpeed1
                                                          target:self
                                                        selector:@selector(frame2)
                                                        userInfo:nil
                                                         repeats:NO];
    
}


-(void)frame2{
    
    self.imageView.image = img2;
    
    thisTimer = [NSTimer scheduledTimerWithTimeInterval:globalSpeed1
                                                          target:self
                                                        selector:@selector(frame3)
                                                        userInfo:nil
                                                         repeats:NO];
    
}


-(void)frame3{
    
    self.imageView.image = img3;
    
    thisTimer = [NSTimer scheduledTimerWithTimeInterval:globalSpeed1
                                                          target:self
                                                        selector:@selector(frame4)
                                                        userInfo:nil
                                                         repeats:NO];
    
}


-(void)frame4{
    
    if ([textField.text isEqual:@""]){
        
        if (isFullscreen == NO){
            
            textLabel.layer.opacity = 0.5;
            
        } else {
            
            textLabel.layer.opacity = 0.0;
            
        }
        
    } else {
        
        textLabel.layer.opacity = 1.0;
        
    }
    
    if ([textField2.text isEqual:@""]){
        
        if (isFullscreen == NO){
            
            textLabel2.layer.opacity = 0.5;
            
        } else {
            
            textLabel2.layer.opacity = 0.0;
            
        }
        
    } else {
        
        textLabel2.layer.opacity = 1.0;
        
    }


    
    thisTimer = [NSTimer scheduledTimerWithTimeInterval:(2*globalSpeed1)
                                                          target:self
                                                        selector:@selector(frame1)
                                                        userInfo:nil
                                                         repeats:NO];
}


-(void)frame21{
    
    self.imageView2.image = img1;

    textLabel3.layer.opacity = 0.0;
    
    textLabel4.layer.opacity = 0.0;
    
    thisTimer2 = [NSTimer scheduledTimerWithTimeInterval:globalSpeed2
                                                 target:self
                                               selector:@selector(frame22)
                                               userInfo:nil
                                                repeats:NO];

}

-(void)frame22{
    
    self.imageView2.image = img4;
    
    thisTimer2 = [NSTimer scheduledTimerWithTimeInterval:globalSpeed2
                                                 target:self
                                               selector:@selector(frame23)
                                               userInfo:nil
                                                repeats:NO];
}

-(void)frame23{
    
    self.imageView2.image = img2;
    
    thisTimer2 = [NSTimer scheduledTimerWithTimeInterval:globalSpeed2
                                                 target:self
                                               selector:@selector(frame24)
                                               userInfo:nil
                                                repeats:NO];
}

-(void)frame24{
    
    self.imageView2.image = img3;

    thisTimer2 = [NSTimer scheduledTimerWithTimeInterval:(2*globalSpeed2)
                                                 target:self
                                               selector:@selector(frame25)
                                               userInfo:nil
                                                repeats:NO];
}

-(void)frame25{

    
    
    if ([textField3.text isEqual:@""]){
        
        if (isFullscreen == NO){
            
            textLabel3.layer.opacity = 0.5;
            
        } else {
            
            textLabel3.layer.opacity = 0.0;
            
        }
        
    } else {
        
        textLabel3.layer.opacity = 1.0;
        
    }
    
    if ([textField4.text isEqual:@""]){
        
        if (isFullscreen == NO){
            
            textLabel4.layer.opacity = 0.5;
            
        } else {
            
            textLabel4.layer.opacity = 0.0;
            
        }
        
    } else {
        
        textLabel4.layer.opacity = 1.0;
        
    }
    
    
    
    thisTimer2 = [NSTimer scheduledTimerWithTimeInterval:(3*globalSpeed2)
                                                 target:self
                                               selector:@selector(frame21)
                                               userInfo:nil
                                                repeats:NO];
}

// SCROLLING BACKGROUND IMAGE BEGIN


-(void)imageScroll {
    
    
    UIImage *cloudsImage = [UIImage imageNamed:@"scrolling_background"];
    
    
    cloudsImage = [cloudsImage blurredImageWithRadius:3 iterations:6 tintColor:[UIColor blackColor]];
    
    
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

- (void)applyCloudLayerAnimation {
    [cloudLayer addAnimation:cloudLayerAnimation forKey:@"position"];
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
    
    //[delegate sendDataToA:thisArr];

}

- (void)viewWillDisappear:(BOOL)animated {
    [delegate applyCloudLayerAnimation];
    [delegate gonnaRemoveThis];
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)note {
    [self applyCloudLayerAnimation];
}


// SCROLLING BACKGROUND IMAGE END



/*
-(void)createGif:(id)sender {
    [self makeAnimatedGif:firstImage :secondImage :dvImage: fourthImage];
}
 */


- (void) makeAnimatedGif:(UIImage *)firstPic : (UIImage *)secondPic : (UIImage *) thirdPic :(UIImage *)fourthPic{
    static NSUInteger const kFrameCount = 5;
    
   /* NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    

    /*
    NSDictionary *frameProperties = @{
                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
                                              (__bridge id)kCGImagePropertyGIFDelayTime: @0.3, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
                                              }
                                      };
     */
    
    /*
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSDictionary
                                                           dictionaryWithObject:[NSNumber numberWithFloat:globalSpeed1]
                                                           forKey:(NSString *) kCGImagePropertyGIFDelayTime]
                                     forKey:(NSString *) kCGImagePropertyGIFDictionary];
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    */
    //for (NSUInteger i = 0; i < kFrameCount; i++) {
    // @autoreleasepool {
    //UIImage *image = frameImage(CGSizeMake(300, 300), M_PI * 2 * i / kFrameCount);
    CGRect rect = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect.size );
    [firstPic drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    //picture1 = [self imageFixer:picture1];
    //- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGFloat)newSize {
    picture1 = [self squareImageFromImage:picture1 scaledToSize:300];
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    img1=[UIImage imageWithData:imageData];
    
    
    
    
    //CGRect rect2 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect.size );
    [secondPic drawInRect:rect];
    UIImage *picture2 = UIGraphicsGetImageFromCurrentImageContext();
    picture2 = [self squareImageFromImage:picture2 scaledToSize:300];
    UIGraphicsEndImageContext();
    
    NSData *imageData2 = UIImagePNGRepresentation(picture2);
    img2=[UIImage imageWithData:imageData2];
    
    
    
    
    //CGRect rect3 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect.size );
    [thirdPic drawInRect:rect];
    UIImage *picture3 = UIGraphicsGetImageFromCurrentImageContext();
    picture3 = [self squareImageFromImage:picture3 scaledToSize:300];
    UIGraphicsEndImageContext();
    
    NSData *imageData3 = UIImagePNGRepresentation(picture3);
    img3=[UIImage imageWithData:imageData3];
    
    
    
    //CGRect rect4 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect.size );
    [fourthPic drawInRect:rect];
    UIImage *picture4 = UIGraphicsGetImageFromCurrentImageContext();
    picture4 = [self squareImageFromImage:picture4 scaledToSize:300];
    UIGraphicsEndImageContext();
    
    NSData *imageData4 = UIImagePNGRepresentation(picture4);
    img4=[UIImage imageWithData:imageData4];
    
    
    
    
    //MEME Part
    
    UIGraphicsBeginImageContext( rect.size );
    [thirdPic drawInRect:rect];
    
    THLabel *myTextLabel = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
    
    [myTextLabel setFont:[UIFont fontWithName:@"Impact" size:48.0f]];
    myTextLabel.textColor = [UIColor whiteColor];
    
    myTextLabel.strokeSize = 2.0f;
    myTextLabel.strokePosition = THLabelStrokePositionOutside;
    myTextLabel.strokeColor = [UIColor blackColor];
    myTextLabel.letterSpacing = 1.5f;
    myTextLabel.textAlignment = NSTextAlignmentCenter;
    //myTextLabel.text = textLabel.text;
    
    [myTextLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *picture5 = UIGraphicsGetImageFromCurrentImageContext();
    picture5 = [self squareImageFromImage:picture5 scaledToSize:300];
    UIGraphicsEndImageContext();
    
    //NSData *imageData5 = UIImagePNGRepresentation(picture5);
    //img5=[UIImage imageWithData:imageData5];
    
    /*
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
     
    
    
    //myWebView = [[UIWebView alloc]initWithFrame:CGRectMake(xorigin, 30, 300, 300)];
    
    NSString *imagePath = [[NSBundle mainBundle] resourcePath];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    //imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    //imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSLog(@"this is image path: %@", imagePath);
    
    NSString *HTMLData = @"<meta name='viewport' content='width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=no;'/><html style='height:300px; width:300px'><img src='animated.gif' alt=''style='width:300px; height:300px; margin-top:-8px; margin-left:-8px;' /></html>";
    
    //[myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    
    //[myWebView loadHTMLString:HTMLData baseURL:[NSURL URLWithString: [NSString stringWithFormat:@"file:/%@//",imagePath]]];
    
    NSString *mypath = @"";
    
    mypath = [imagePath stringByAppendingString:@"/animated.gif"];
    
    NSLog(@"this is my path: %@", mypath);
    
    NSData *gifData = [[NSData alloc] initWithContentsOfFile:mypath];
    
    UIImage* mygif = [UIImage animatedImageWithAnimatedGIFData:gifData];
    
    //self.imageView.image = mygif;

    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setData:gifData forPasteboardType:@"com.compuserve.gif"];
    
    NSTimer *thisTimer = [NSTimer scheduledTimerWithTimeInterval:0.3
                                                          target:self
                                                        selector:@selector(frame1)
                                                        userInfo:nil
                                                         repeats:NO];
    */
    [self frame1];
    [self frame21];
}

- (void)createScrollMenu
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height + 250, self.view.frame.size.width, 200)];
    
    int x = 25;
    for (int i = 0; i < 8; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(x, 25, 150, 150)];
        [button setTitle:[NSString stringWithFormat:@"Button %d", i] forState:UIControlStateNormal];
        
        [scrollView addSubview:button];
        
        x += button.frame.size.width + 50;
    }
    
    scrollView.contentSize = CGSizeMake(x, scrollView.frame.size.height);
    scrollView.backgroundColor = [UIColor blackColor];
    
    
    
    [self.view addSubview:scrollView];
}


-(void)makeGifSilently:(UIImage *)firstPic : (UIImage *)secondPic : (UIImage *) thirdPic :(UIImage *)fourthPic{
    static NSUInteger const kFrameCount = 5;
    
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSDictionary
                                                           dictionaryWithObject:[NSNumber numberWithFloat:globalSpeed1]
                                                           forKey:(NSString *) kCGImagePropertyGIFDelayTime]
                                     forKey:(NSString *) kCGImagePropertyGIFDictionary];
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSString *stringCount = [NSString stringWithFormat:@"/tmpname1.gif"];
    
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:stringCount];
    
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
    
    //   NSData *imageData = UIImagePNGRepresentation(picture1);
    //   img1=[UIImage imageWithData:imageData];
    
    
    
    
    CGRect rect2 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect2.size );
    [secondPic drawInRect:rect2];
    UIImage *picture2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData2 = UIImagePNGRepresentation(picture2);
    //   img2=[UIImage imageWithData:imageData2];
    
    
    
    
    CGRect rect3 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect3.size );
    [thirdPic drawInRect:rect3];
    UIImage *picture3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData3 = UIImagePNGRepresentation(picture3);
    //   img3=[UIImage imageWithData:imageData3];
    
    
    
    CGRect rect4 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect4.size );
    [thirdPic drawInRect:rect4];
    UIImage *picture4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData4 = UIImagePNGRepresentation(picture4);
    //   img4=[UIImage imageWithData:imageData4];
    
    
    
    
    //MEME Part
    
    CGRect rect5 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect5.size );
    [thirdPic drawInRect:rect5];
    
    /*
     THLabel *myTextLabel = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
     
     [myTextLabel setFont:[UIFont fontWithName:@"Impact" size:48.0f]];
     myTextLabel.textColor = [UIColor whiteColor];
     
     myTextLabel.strokeSize = 2.0f;
     myTextLabel.strokePosition = THLabelStrokePositionOutside;
     myTextLabel.strokeColor = [UIColor blackColor];
     myTextLabel.letterSpacing = 1.5f;
     myTextLabel.textAlignment = NSTextAlignmentCenter;
     //myTextLabel.text = textLabel.text;
     
     [myTextLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
     
     */
    
    if (![textField2.text isEqual: @""]){
        
        
        THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
        
        textLabelx.text= textLabel2.text;
        //textLabelx.layer.opacity = 0.5;
        
        [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        textLabelx.textColor = [UIColor whiteColor];
        
        textLabelx.strokeSize = 2.0f;
        textLabelx.strokePosition = THLabelStrokePositionOutside;
        textLabelx.strokeColor = [UIColor blackColor];
        textLabelx.letterSpacing = 2.0f;
        textLabelx.textAlignment = NSTextAlignmentCenter;
        
        //textLabelx.hidden = YES;
        
        [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
        
    }
    
    if (![textField.text isEqual: @""]){
        
        //THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
        
        THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
        
        
        textLabelx.text= textLabel.text;
        //textLabelx.layer.opacity = 0.5;
        
        [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        textLabelx.textColor = [UIColor whiteColor];
        
        textLabelx.strokeSize = 2.0f;
        textLabelx.strokePosition = THLabelStrokePositionOutside;
        textLabelx.strokeColor = [UIColor blackColor];
        textLabelx.letterSpacing = 2.0f;
        textLabelx.textAlignment = NSTextAlignmentCenter;
        
        [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
    }
    
    NSLog(@"THE SIZE: %@", NSStringFromCGSize(thirdPic.size));
    UIImage *picture5 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // NSData *imageData5 = UIImagePNGRepresentation(picture5);
    // img5=[UIImage imageWithData:imageData5];
    
    //DONE MEME
    
    CGImageDestinationAddImage(destination, picture1.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture2.CGImage, (__bridge CFDictionaryRef)frameProperties);
    //CGImageDestinationAddImage(destination, img3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    //CGImageDestinationAddImage(destination, img5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    
    NSString *imagePath = [[NSBundle mainBundle] resourcePath];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSLog(@"this is image path: %@", imagePath);
    
    NSString *mypath = @"";
    
    // Archive Array
    
    //ViewController *thisControl = [[ViewController alloc]init];
    
    // NSArray *pather = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // NSString *pathx = [ [pather objectAtIndex:0] stringByAppendingPathComponent:@"archive.dat"];
    
    //mypath = [imagePath stringByAppendingString:@"/animated.gif"];
    
    //[thisControl setImageArray:thisArray];
    
    //mypath = [imagePath stringByAppendingString:@".gif"];
    
    mypath = [imagePath stringByAppendingString:stringCount];
    
    NSString *documentsDirectory = @"";
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:stringCount];
    mypath = documentsDirectory;
    

    
    gifURL1 = mypath;
    
}


-(void)makeGifSilently2:(UIImage *)firstPic : (UIImage *)secondPic : (UIImage *) thirdPic :(UIImage *)fourthPic{
    static NSUInteger const kFrameCount = 8;
    
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSDictionary
                                                           dictionaryWithObject:[NSNumber numberWithFloat:globalSpeed2]
                                                           forKey:(NSString *) kCGImagePropertyGIFDelayTime]
                                     forKey:(NSString *) kCGImagePropertyGIFDictionary];
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSString *stringCount = [NSString stringWithFormat:@"/tmpname2.gif"];
    
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:stringCount];
    
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
    
    //   NSData *imageData = UIImagePNGRepresentation(picture1);
    //   img1=[UIImage imageWithData:imageData];
    
    
    
    
    CGRect rect2 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect2.size );
    [secondPic drawInRect:rect2];
    UIImage *picture2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData2 = UIImagePNGRepresentation(picture2);
    //   img2=[UIImage imageWithData:imageData2];
    
    
    
    
    CGRect rect3 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect3.size );
    [thirdPic drawInRect:rect3];
    UIImage *picture3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData3 = UIImagePNGRepresentation(picture3);
    //   img3=[UIImage imageWithData:imageData3];
    
    
    
    CGRect rect4 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect4.size );
    [fourthPic drawInRect:rect4];
    UIImage *picture4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData4 = UIImagePNGRepresentation(picture4);
    //   img4=[UIImage imageWithData:imageData4];
    
    
    
    
    //MEME Part
    
    CGRect rect5 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect5.size );
    [thirdPic drawInRect:rect5];
    
    /*
     THLabel *myTextLabel = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
     
     [myTextLabel setFont:[UIFont fontWithName:@"Impact" size:48.0f]];
     myTextLabel.textColor = [UIColor whiteColor];
     
     myTextLabel.strokeSize = 2.0f;
     myTextLabel.strokePosition = THLabelStrokePositionOutside;
     myTextLabel.strokeColor = [UIColor blackColor];
     myTextLabel.letterSpacing = 1.5f;
     myTextLabel.textAlignment = NSTextAlignmentCenter;
     //myTextLabel.text = textLabel.text;
     
     [myTextLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
     
     */
    
    if (![textField4.text isEqual: @""]){
        
        
        THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
        
        textLabelx.text= textLabel4.text;
        //textLabelx.layer.opacity = 0.5;
        
        [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        textLabelx.textColor = [UIColor whiteColor];
        
        textLabelx.strokeSize = 2.0f;
        textLabelx.strokePosition = THLabelStrokePositionOutside;
        textLabelx.strokeColor = [UIColor blackColor];
        textLabelx.letterSpacing = 2.0f;
        textLabelx.textAlignment = NSTextAlignmentCenter;
        
        //textLabelx.hidden = YES;
        
        [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
        
    }
    
    if (![textField3.text isEqual: @""]){
        
        //THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
        
        THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
        
        
        textLabelx.text= textLabel3.text;
        //textLabelx.layer.opacity = 0.5;
        
        [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        textLabelx.textColor = [UIColor whiteColor];
        
        textLabelx.strokeSize = 2.0f;
        textLabelx.strokePosition = THLabelStrokePositionOutside;
        textLabelx.strokeColor = [UIColor blackColor];
        textLabelx.letterSpacing = 2.0f;
        textLabelx.textAlignment = NSTextAlignmentCenter;
        
        [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
    }
    
    NSLog(@"THE SIZE: %@", NSStringFromCGSize(thirdPic.size));
    UIImage *picture5 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // NSData *imageData5 = UIImagePNGRepresentation(picture5);
    // img5=[UIImage imageWithData:imageData5];
    
    //DONE MEME
    
    CGImageDestinationAddImage(destination, picture1.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture4.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture2.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    
    
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    
    NSString *imagePath = [[NSBundle mainBundle] resourcePath];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSLog(@"this is image path: %@", imagePath);
    
    NSString *mypath = @"";
    
    // Archive Array
    
    //ViewController *thisControl = [[ViewController alloc]init];
    
    // NSArray *pather = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // NSString *pathx = [ [pather objectAtIndex:0] stringByAppendingPathComponent:@"archive.dat"];
    
    //mypath = [imagePath stringByAppendingString:@"/animated.gif"];
    
    //[thisControl setImageArray:thisArray];
    
    //mypath = [imagePath stringByAppendingString:@".gif"];
    
    mypath = [imagePath stringByAppendingString:stringCount];
    
    NSString *documentsDirectory = @"";
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:stringCount];
    mypath = documentsDirectory;
    
        
    gifURL2 = mypath;

}

- (void)makeGifReal:(UIImage *)firstPic : (UIImage *)secondPic : (UIImage *) thirdPic :(UIImage *)fourthPic{

    
    static NSUInteger const kFrameCount = 5;
    
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSDictionary
                                                           dictionaryWithObject:[NSNumber numberWithFloat:globalSpeed1]
                                                           forKey:(NSString *) kCGImagePropertyGIFDelayTime]
                                     forKey:(NSString *) kCGImagePropertyGIFDictionary];
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSString *stringCount = [NSString stringWithFormat:@"/animated%li.gif", [[NSUserDefaults standardUserDefaults] integerForKey:@"fullSize"]];
    
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:stringCount];
    
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
    
    //   NSData *imageData = UIImagePNGRepresentation(picture1);
    //   img1=[UIImage imageWithData:imageData];
    
    
    
    
    CGRect rect2 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect2.size );
    [secondPic drawInRect:rect2];
    UIImage *picture2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData2 = UIImagePNGRepresentation(picture2);
    //   img2=[UIImage imageWithData:imageData2];
    
    
    
    
    CGRect rect3 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect3.size );
    [thirdPic drawInRect:rect3];
    UIImage *picture3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData3 = UIImagePNGRepresentation(picture3);
    //   img3=[UIImage imageWithData:imageData3];
    
    
    
    CGRect rect4 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect4.size );
    [thirdPic drawInRect:rect4];
    UIImage *picture4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData4 = UIImagePNGRepresentation(picture4);
    //   img4=[UIImage imageWithData:imageData4];
    
    
    
    
    //MEME Part
    
    CGRect rect5 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect5.size );
    [thirdPic drawInRect:rect5];
    
    /*
     THLabel *myTextLabel = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
     
     [myTextLabel setFont:[UIFont fontWithName:@"Impact" size:48.0f]];
     myTextLabel.textColor = [UIColor whiteColor];
     
     myTextLabel.strokeSize = 2.0f;
     myTextLabel.strokePosition = THLabelStrokePositionOutside;
     myTextLabel.strokeColor = [UIColor blackColor];
     myTextLabel.letterSpacing = 1.5f;
     myTextLabel.textAlignment = NSTextAlignmentCenter;
     //myTextLabel.text = textLabel.text;
     
     [myTextLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
     
     */
    
    if (![textField2.text isEqual: @""]){
        
        
        THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
        
        textLabelx.text= textLabel2.text;
        //textLabelx.layer.opacity = 0.5;
        
        [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        textLabelx.textColor = [UIColor whiteColor];
        
        textLabelx.strokeSize = 2.0f;
        textLabelx.strokePosition = THLabelStrokePositionOutside;
        textLabelx.strokeColor = [UIColor blackColor];
        textLabelx.letterSpacing = 2.0f;
        textLabelx.textAlignment = NSTextAlignmentCenter;
        
        //textLabelx.hidden = YES;
        
        [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
        
    }
    
    if (![textField.text isEqual: @""]){
        
        //THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
        
        THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
        
        
        textLabelx.text= textLabel.text;
        //textLabelx.layer.opacity = 0.5;
        
        [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        textLabelx.textColor = [UIColor whiteColor];
        
        textLabelx.strokeSize = 2.0f;
        textLabelx.strokePosition = THLabelStrokePositionOutside;
        textLabelx.strokeColor = [UIColor blackColor];
        textLabelx.letterSpacing = 2.0f;
        textLabelx.textAlignment = NSTextAlignmentCenter;
        
        [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
    }
    
    NSLog(@"THE SIZE: %@", NSStringFromCGSize(thirdPic.size));
    UIImage *picture5 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // NSData *imageData5 = UIImagePNGRepresentation(picture5);
    // img5=[UIImage imageWithData:imageData5];
    
    //DONE MEME
    
    CGImageDestinationAddImage(destination, picture1.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture2.CGImage, (__bridge CFDictionaryRef)frameProperties);
    //CGImageDestinationAddImage(destination, img3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    //CGImageDestinationAddImage(destination, img5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    
    NSString *imagePath = [[NSBundle mainBundle] resourcePath];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    
    NSString *mypath = @"";
    
    // Archive Array
    
    //ViewController *thisControl = [[ViewController alloc]init];
    
    // NSArray *pather = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // NSString *pathx = [ [pather objectAtIndex:0] stringByAppendingPathComponent:@"archive.dat"];
    
    //mypath = [imagePath stringByAppendingString:@"/animated.gif"];
    
    //[thisControl setImageArray:thisArray];
    
    //mypath = [imagePath stringByAppendingString:@".gif"];
    
    mypath = [imagePath stringByAppendingString:stringCount];
    
    NSString *documentsDirectory = @"";
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:stringCount];
    mypath = documentsDirectory;
    int fullNum = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"fullSize"];
    fullNum = fullNum+1;
    [[NSUserDefaults standardUserDefaults] setInteger:fullNum forKey:@"fullSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    [thisArr addObject:mypath];
    
    //[thisArr insertObject:mypath atIndex:thisArr.count];
    
    [delegate sendDataToA:thisArr];
    
    [delegate refreshThis];
    
    NSLog(@"this is image path: %@", mypath);

    
    documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    fileURL = [documentsDirectoryURL URLByAppendingPathComponent:mypath];
    
    NSData *gifData = [NSData dataWithContentsOfFile:[fileURL path]];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:gifData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
        NSLog(@"Success at %@", [assetURL path] );
    }];
    
}



- (void)makeGifReal2:(UIImage *)firstPic : (UIImage *)secondPic : (UIImage *) thirdPic :(UIImage *)fourthPic{


    static NSUInteger const kFrameCount = 8;
    
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSDictionary
                                                           dictionaryWithObject:[NSNumber numberWithFloat:globalSpeed2]
                                                           forKey:(NSString *) kCGImagePropertyGIFDelayTime]
                                     forKey:(NSString *) kCGImagePropertyGIFDictionary];
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSString *stringCount = [NSString stringWithFormat:@"/animated%li.gif", [[NSUserDefaults standardUserDefaults] integerForKey:@"fullSize"]];
    
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:stringCount];
    
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
    
    //   NSData *imageData = UIImagePNGRepresentation(picture1);
    //   img1=[UIImage imageWithData:imageData];
    
    
    
    
    CGRect rect2 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect2.size );
    [secondPic drawInRect:rect2];
    UIImage *picture2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData2 = UIImagePNGRepresentation(picture2);
    //   img2=[UIImage imageWithData:imageData2];
    
    
    
    
    CGRect rect3 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect3.size );
    [thirdPic drawInRect:rect3];
    UIImage *picture3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData3 = UIImagePNGRepresentation(picture3);
    //   img3=[UIImage imageWithData:imageData3];
    
    
    
    CGRect rect4 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect4.size );
    [fourthPic drawInRect:rect4];
    UIImage *picture4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData4 = UIImagePNGRepresentation(picture4);
    //   img4=[UIImage imageWithData:imageData4];
    
    
    
    
    //MEME Part
    
    CGRect rect5 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect5.size );
    [thirdPic drawInRect:rect5];
    
    /*
     THLabel *myTextLabel = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
     
     [myTextLabel setFont:[UIFont fontWithName:@"Impact" size:48.0f]];
     myTextLabel.textColor = [UIColor whiteColor];
     
     myTextLabel.strokeSize = 2.0f;
     myTextLabel.strokePosition = THLabelStrokePositionOutside;
     myTextLabel.strokeColor = [UIColor blackColor];
     myTextLabel.letterSpacing = 1.5f;
     myTextLabel.textAlignment = NSTextAlignmentCenter;
     //myTextLabel.text = textLabel.text;
     
     [myTextLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
     
     */
    
    if (![textField4.text isEqual: @""]){
        
        
        THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
        
        textLabelx.text= textLabel4.text;
        //textLabelx.layer.opacity = 0.5;
        
        [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        textLabelx.textColor = [UIColor whiteColor];
        
        textLabelx.strokeSize = 2.0f;
        textLabelx.strokePosition = THLabelStrokePositionOutside;
        textLabelx.strokeColor = [UIColor blackColor];
        textLabelx.letterSpacing = 2.0f;
        textLabelx.textAlignment = NSTextAlignmentCenter;
        
        //textLabelx.hidden = YES;
        
        [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
        
    }
    
    if (![textField3.text isEqual: @""]){
        
        //THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
        
        THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
        
        
        textLabelx.text= textLabel3.text;
        //textLabelx.layer.opacity = 0.5;
        
        [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        textLabelx.textColor = [UIColor whiteColor];
        
        textLabelx.strokeSize = 2.0f;
        textLabelx.strokePosition = THLabelStrokePositionOutside;
        textLabelx.strokeColor = [UIColor blackColor];
        textLabelx.letterSpacing = 2.0f;
        textLabelx.textAlignment = NSTextAlignmentCenter;
        
        [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
    }
    
    NSLog(@"THE SIZE: %@", NSStringFromCGSize(thirdPic.size));
    UIImage *picture5 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // NSData *imageData5 = UIImagePNGRepresentation(picture5);
    // img5=[UIImage imageWithData:imageData5];
    
    //DONE MEME
    
    CGImageDestinationAddImage(destination, picture1.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture4.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture2.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    
    
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    
    NSString *imagePath = [[NSBundle mainBundle] resourcePath];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSString *mypath = @"";
    
    // Archive Array
    
    //ViewController *thisControl = [[ViewController alloc]init];
    
    // NSArray *pather = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // NSString *pathx = [ [pather objectAtIndex:0] stringByAppendingPathComponent:@"archive.dat"];
    
    //mypath = [imagePath stringByAppendingString:@"/animated.gif"];
    
    //[thisControl setImageArray:thisArray];
    
    //mypath = [imagePath stringByAppendingString:@".gif"];
    
    mypath = [imagePath stringByAppendingString:stringCount];
    
    NSString *documentsDirectory = @"";
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:stringCount];
    mypath = documentsDirectory;
    
    NSLog(@"this is my path: %@", mypath);

    
    [thisArr addObject:mypath];
    
    int fullNum = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"fullSize"];
    fullNum = fullNum+1;
    [[NSUserDefaults standardUserDefaults] setInteger:fullNum forKey:@"fullSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    //[thisArr insertObject:mypath atIndex:thisArr.count];
    
    [delegate sendDataToA:thisArr];
    
    [delegate refreshThis];
    
    documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    fileURL = [documentsDirectoryURL URLByAppendingPathComponent:mypath];
    
    NSData *gifData = [NSData dataWithContentsOfFile:[fileURL path]];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:gifData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        
        NSLog(@"Success at %@", [assetURL path] );
    }];
    

}




- (void) makeMyGif:(UIImage *)firstPic : (UIImage *)secondPic : (UIImage *) thirdPic :(UIImage *)fourthPic{
    static NSUInteger const kFrameCount = 5;
    
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    

    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSDictionary
                                                           dictionaryWithObject:[NSNumber numberWithFloat:globalSpeed1]
                                                           forKey:(NSString *) kCGImagePropertyGIFDelayTime]
                                     forKey:(NSString *) kCGImagePropertyGIFDictionary];
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSString *stringCount = [NSString stringWithFormat:@"/animated%li.gif", [[NSUserDefaults standardUserDefaults] integerForKey:@"fullSize"]];
    
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:stringCount];
    
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
    
 //   NSData *imageData = UIImagePNGRepresentation(picture1);
 //   img1=[UIImage imageWithData:imageData];
    
    
    
    
    CGRect rect2 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect2.size );
    [secondPic drawInRect:rect2];
    UIImage *picture2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
 //   NSData *imageData2 = UIImagePNGRepresentation(picture2);
 //   img2=[UIImage imageWithData:imageData2];
    
    
    
    
    CGRect rect3 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect3.size );
    [thirdPic drawInRect:rect3];
    UIImage *picture3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
 //   NSData *imageData3 = UIImagePNGRepresentation(picture3);
 //   img3=[UIImage imageWithData:imageData3];
    
    
    
    CGRect rect4 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect4.size );
    [thirdPic drawInRect:rect4];
    UIImage *picture4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
 //   NSData *imageData4 = UIImagePNGRepresentation(picture4);
 //   img4=[UIImage imageWithData:imageData4];
    
    
    
    
    //MEME Part
    
    CGRect rect5 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect5.size );
    [thirdPic drawInRect:rect5];
    
    /*
    THLabel *myTextLabel = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
    
    [myTextLabel setFont:[UIFont fontWithName:@"Impact" size:48.0f]];
    myTextLabel.textColor = [UIColor whiteColor];
    
    myTextLabel.strokeSize = 2.0f;
    myTextLabel.strokePosition = THLabelStrokePositionOutside;
    myTextLabel.strokeColor = [UIColor blackColor];
    myTextLabel.letterSpacing = 1.5f;
    myTextLabel.textAlignment = NSTextAlignmentCenter;
    //myTextLabel.text = textLabel.text;
    
    [myTextLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
    
     */
    
    if (![textField2.text isEqual: @""]){
        
        
        THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
        
        textLabelx.text= textLabel2.text;
        //textLabelx.layer.opacity = 0.5;
        
        [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        textLabelx.textColor = [UIColor whiteColor];
        
        textLabelx.strokeSize = 2.0f;
        textLabelx.strokePosition = THLabelStrokePositionOutside;
        textLabelx.strokeColor = [UIColor blackColor];
        textLabelx.letterSpacing = 2.0f;
        textLabelx.textAlignment = NSTextAlignmentCenter;
        
        //textLabelx.hidden = YES;
        
        [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];
        

        
    }
    
    if (![textField.text isEqual: @""]){
    
    //THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
    
    THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];

        
    textLabelx.text= textLabel.text;
    //textLabelx.layer.opacity = 0.5;
    
    [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
    textLabelx.textColor = [UIColor whiteColor];
    
    textLabelx.strokeSize = 2.0f;
    textLabelx.strokePosition = THLabelStrokePositionOutside;
    textLabelx.strokeColor = [UIColor blackColor];
    textLabelx.letterSpacing = 2.0f;
    textLabelx.textAlignment = NSTextAlignmentCenter;
    
    [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];

        
    }
    
    NSLog(@"THE SIZE: %@", NSStringFromCGSize(thirdPic.size));
    UIImage *picture5 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   // NSData *imageData5 = UIImagePNGRepresentation(picture5);
   // img5=[UIImage imageWithData:imageData5];
    
    //DONE MEME
    
    CGImageDestinationAddImage(destination, picture1.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture2.CGImage, (__bridge CFDictionaryRef)frameProperties);
    //CGImageDestinationAddImage(destination, img3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    //CGImageDestinationAddImage(destination, img5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    
    NSString *imagePath = [[NSBundle mainBundle] resourcePath];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    
    NSString *mypath = @"";
    
    // Archive Array
    
    //ViewController *thisControl = [[ViewController alloc]init];
    
    // NSArray *pather = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    // NSString *pathx = [ [pather objectAtIndex:0] stringByAppendingPathComponent:@"archive.dat"];
    
    //mypath = [imagePath stringByAppendingString:@"/animated.gif"];
    
    //[thisControl setImageArray:thisArray];
    
    //mypath = [imagePath stringByAppendingString:@".gif"];
    
    mypath = [imagePath stringByAppendingString:stringCount];
    
    NSString *documentsDirectory = @"";
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:stringCount];
    mypath = documentsDirectory;
    
    NSLog(@"this is my path: %@", mypath);

    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveOnCopy"]  isEqual: @"NO"]){

    } else {
    
        [thisArr addObject:mypath];
        
        int fullNum = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"fullSize"];
        fullNum = fullNum+1;
        [[NSUserDefaults standardUserDefaults] setInteger:fullNum forKey:@"fullSize"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        
        
        gifURL1 = mypath;
        NSLog(@"gif url: %@", gifURL1);

        
        //[thisArr insertObject:mypath atIndex:thisArr.count];
    
        [delegate sendDataToA:thisArr];
    
        [delegate refreshThis];
    }
    
    
    
    
    NSString *newPath = [imagePath stringByAppendingString:stringCount];
    
    NSLog(@"LOG THIS SIZE YOYOOYYO: %li", [thisArr count]);
    
    // NSData *data = [NSKeyedArchiver archivedDataWithRootObject:thisArr];
    // [data writeToFile:pathx options:NSDataWritingAtomic error:nil];
    
    NSLog(@"this is my path: %@", newPath);
    
    NSData *gifData = [[NSData alloc] initWithContentsOfFile:newPath];
    
    //UIImage* mygif = [UIImage animatedImageWithAnimatedGIFData:gifData];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setData:gifData forPasteboardType:@"com.compuserve.gif"];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveOnCopy"]  isEqual: @"NO"]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:newPath error:nil];
        //if (!success) NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    NSLog(@"\n\n\n\n\n\n\ncopied dat shit\n\n\n\n\n");
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
    
        inder.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished){
        
        [inder removeFromSuperview];
        
        finishedView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 200)];
        
        
        //inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
        
        finishedView.backgroundColor = [UIColor blackColor];
        finishedView.layer.opacity = 0.8;
        finishedView.layer.cornerRadius = 20.0;
        
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
        
        [finishedView addSubview:thisLab];

        
        
        [finishedView addSubview:imageThing];
        
        finishedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        [self.view addSubview:finishedView];
        
        
        //NSTimer *thisTimed = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(removeThis) userInfo:nil repeats:NO];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            
            finishedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        }
        
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                 
                                 finishedView.transform = CGAffineTransformMakeScale(0.85, 0.85);
                                 
                             }
                              
                                              completion:^(BOOL finished){
                                                  
                                                  
                                                  [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                      
                                                      finishedView.transform = CGAffineTransformMakeScale(1, 1);
                                                      
                                                  }
                                                   
                                                                   completion:^(BOOL finished){
                                                                       
                                                                       
                                                                       
                                                                       
                                                                       [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                                           
                                                                           finishedView.transform = CGAffineTransformMakeScale(1, 1);

                                                                           
                                                                       }
                                                                                        completion:^(BOOL finished){
                                                                                            
                                                                                            [UIView animateWithDuration:0.2 delay:1.3 options:nil animations:^{
                                                                                                
                                                                                                finishedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                                                                                
                                                                                            }
                                                                                             
                                                                                                             completion:^(BOOL finished){
                                                                                                                 
                                                                                                                 
                                                                                                                 [finishedView removeFromSuperview];
                                                                                                                 pressed = NO;
                                                                                                                 
                                                                                                             }];
                                                                                            
                                                                                        }];
                                                                       
                                                                       
                                                                   }];
                                                  
                                              }];
                             
                             
                         }];
        
        //[self.view addSubview:imageThing];
        
    }];

}


- (void) makeMyGif2:(UIImage *)firstPic : (UIImage *)secondPic : (UIImage *) thirdPic :(UIImage *)fourthPic{
    static NSUInteger const kFrameCount = 8;
    
    NSDictionary *fileProperties = @{
                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
                                             }
                                     };
    
    
    NSDictionary *frameProperties = [NSDictionary
                                     dictionaryWithObject:[NSDictionary
                                                           dictionaryWithObject:[NSNumber numberWithFloat:globalSpeed2]
                                                           forKey:(NSString *) kCGImagePropertyGIFDelayTime]
                                     forKey:(NSString *) kCGImagePropertyGIFDictionary];
    
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
    
    NSString *stringCount = [NSString stringWithFormat:@"/animated%li.gif", [[NSUserDefaults standardUserDefaults] integerForKey:@"fullSize"]];
    
    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:stringCount];
    
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
    
    //   NSData *imageData = UIImagePNGRepresentation(picture1);
    //   img1=[UIImage imageWithData:imageData];
    
    
    
    
    CGRect rect2 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect2.size );
    [secondPic drawInRect:rect2];
    UIImage *picture2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData2 = UIImagePNGRepresentation(picture2);
    //   img2=[UIImage imageWithData:imageData2];
    
    
    
    
    CGRect rect3 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect3.size );
    [thirdPic drawInRect:rect3];
    UIImage *picture3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData3 = UIImagePNGRepresentation(picture3);
    //   img3=[UIImage imageWithData:imageData3];
    
    
    
    CGRect rect4 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect4.size );
    [fourthPic drawInRect:rect4];
    UIImage *picture4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //   NSData *imageData4 = UIImagePNGRepresentation(picture4);
    //   img4=[UIImage imageWithData:imageData4];
    
    
    
    
    //MEME Part
    
    CGRect rect5 = CGRectMake(0,0,300,300);
    UIGraphicsBeginImageContext( rect5.size );
    [thirdPic drawInRect:rect5];
    
    /*
     THLabel *myTextLabel = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
     
     [myTextLabel setFont:[UIFont fontWithName:@"Impact" size:48.0f]];
     myTextLabel.textColor = [UIColor whiteColor];
     
     myTextLabel.strokeSize = 2.0f;
     myTextLabel.strokePosition = THLabelStrokePositionOutside;
     myTextLabel.strokeColor = [UIColor blackColor];
     myTextLabel.letterSpacing = 1.5f;
     myTextLabel.textAlignment = NSTextAlignmentCenter;
     //myTextLabel.text = textLabel.text;
     
     [myTextLabel.layer renderInContext:UIGraphicsGetCurrentContext()];
     
     */
    
    if (![textField4.text isEqual: @""]){
        
        
        THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
        
        textLabelx.text= textLabel4.text;
        //textLabelx.layer.opacity = 0.5;
        
        [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        textLabelx.textColor = [UIColor whiteColor];
        
        textLabelx.strokeSize = 2.0f;
        textLabelx.strokePosition = THLabelStrokePositionOutside;
        textLabelx.strokeColor = [UIColor blackColor];
        textLabelx.letterSpacing = 2.0f;
        textLabelx.textAlignment = NSTextAlignmentCenter;
        
        //textLabelx.hidden = YES;
        
        [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
        
    }
    
    if (![textField3.text isEqual: @""]){
        
        //THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 400, 300, 100)];
        
        THLabel *textLabelx = [[THLabel alloc]initWithFrame:CGRectMake(0, 0, 300, 500)];
        
        
        textLabelx.text= textLabel3.text;
        //textLabelx.layer.opacity = 0.5;
        
        [textLabelx setFont:[UIFont fontWithName:@"Impact" size:32.0f]];
        textLabelx.textColor = [UIColor whiteColor];
        
        textLabelx.strokeSize = 2.0f;
        textLabelx.strokePosition = THLabelStrokePositionOutside;
        textLabelx.strokeColor = [UIColor blackColor];
        textLabelx.letterSpacing = 2.0f;
        textLabelx.textAlignment = NSTextAlignmentCenter;
        
        [textLabelx.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        
    }
    
    NSLog(@"THE SIZE: %@", NSStringFromCGSize(thirdPic.size));
    UIImage *picture5 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // NSData *imageData5 = UIImagePNGRepresentation(picture5);
    // img5=[UIImage imageWithData:imageData5];
    
    //DONE MEME
    
    CGImageDestinationAddImage(destination, picture1.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture4.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture2.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture3.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);
    CGImageDestinationAddImage(destination, picture5.CGImage, (__bridge CFDictionaryRef)frameProperties);

    
    
    if (!CGImageDestinationFinalize(destination)) {
        NSLog(@"failed to finalize image destination");
    }
    CFRelease(destination);
    
    
    NSString *imagePath = [[NSBundle mainBundle] resourcePath];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
    imagePath = [imagePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    imagePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSLog(@"this is image path: %@", imagePath);
    
    NSString *mypath = @"";
    
    // Archive Array
    
    //ViewController *thisControl = [[ViewController alloc]init];
    
   // NSArray *pather = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSString *pathx = [ [pather objectAtIndex:0] stringByAppendingPathComponent:@"archive.dat"];
    
    //mypath = [imagePath stringByAppendingString:@"/animated.gif"];
    
    //[thisControl setImageArray:thisArray];
    
    //mypath = [imagePath stringByAppendingString:@".gif"];
    
    mypath = [imagePath stringByAppendingString:stringCount];
    
    NSString *documentsDirectory = @"";
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:stringCount];
    mypath = documentsDirectory;
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveOnCopy"]  isEqual: @"NO"]){
        
    } else {
        
        [thisArr addObject:mypath];
        
        //[thisArr insertObject:mypath atIndex:thisArr.count];
        
        int fullNum = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"fullSize"];
        fullNum = fullNum+1;
        [[NSUserDefaults standardUserDefaults] setInteger:fullNum forKey:@"fullSize"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [delegate sendDataToA:thisArr];
        
        [delegate refreshThis];
        
        gifURL2 = mypath;
        NSLog(@"gif url: %@", gifURL2);
    }
    
    NSString *newPath = [imagePath stringByAppendingString:stringCount];
    
    NSLog(@"LOG THIS SIZE YOYOOYYO: %li", [thisArr count]);
    
    // NSData *data = [NSKeyedArchiver archivedDataWithRootObject:thisArr];
    // [data writeToFile:pathx options:NSDataWritingAtomic error:nil];
    
    NSLog(@"this is my path: %@", newPath);
    
    NSData *gifData = [[NSData alloc] initWithContentsOfFile:newPath];
    
    //UIImage* mygif = [UIImage animatedImageWithAnimatedGIFData:gifData];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    [pasteboard setData:gifData forPasteboardType:@"com.compuserve.gif"];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"SaveOnCopy"]  isEqual: @"NO"]){
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:newPath error:nil];
        //if (!success) NSLog(@"Error: %@", [error localizedDescription]);
     //   gifURL2 = nil;
        
    }

    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        
        inder.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished){
        
        [inder removeFromSuperview];
        
        finishedView = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 200)];
        
        
        //inder = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, [UIScreen mainScreen].bounds.size.height/2 - 100, 200, 150)];
        
        finishedView.backgroundColor = [UIColor blackColor];
        finishedView.layer.opacity = 0.8;
        finishedView.layer.cornerRadius = 20.0;
        
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
        
        [finishedView addSubview:thisLab];
        
        
        
        [finishedView addSubview:imageThing];
        
        finishedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
        [self.view addSubview:finishedView];
        
        
        //NSTimer *thisTimed = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(removeThis) userInfo:nil repeats:NO];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
            
            finishedView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
        }
         
                         completion:^(BOOL finished){
                             
                             [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                 
                                 finishedView.transform = CGAffineTransformMakeScale(0.85, 0.85);
                                 
                             }
                              
                                              completion:^(BOOL finished){
                                                  
                                                  
                                                  [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                      
                                                      finishedView.transform = CGAffineTransformMakeScale(1, 1);
                                                      
                                                  }
                                                   
                                                                   completion:^(BOOL finished){
                                                                       
                                                                       
                                                                       
                                                                       
                                                                       [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationCurveEaseInOut animations:^{
                                                                           
                                                                           finishedView.transform = CGAffineTransformMakeScale(1, 1);
                                                                           
                                                                           
                                                                       }
                                                                                        completion:^(BOOL finished){
                                                                                            
                                                                                            [UIView animateWithDuration:0.2 delay:1.3 options:nil animations:^{
                                                                                                
                                                                                                finishedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
                                                                                                
                                                                                            }
                                                                                             
                                                                                                             completion:^(BOOL finished){
                                                                                                                 
                                                                                                                 
                                                                                                                 [finishedView removeFromSuperview];
                                                                                                                 pressed = NO;
                                                                                                                 
                                                                                                             }];
                                                                                            
                                                                                        }];
                                                                       
                                                                       
                                                                   }];
                                                  
                                              }];
                             
                             
                         }];
        
        //[self.view addSubview:imageThing];
        
    }];
    
}



-(void)removeThis{
    
    NSLog(@"this is something i guess");
    
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseInOut animations:^{
        
        finishedView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    }
     
                     completion:^(BOOL finished){
                         
                         
                         [finishedView removeFromSuperview];
                         
                     }];
}






- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}





@end
