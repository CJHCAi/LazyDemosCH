//
//  ViewController.h
//  FaceZoom
//
//  Created by Ben Taylor on 5/3/15.
//  Copyright (c) 2015 Ben Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OLFacebookImagePickerController.h"
#import "THLabel.h"
#import "LLSimpleCamera.h"
//#import "OLInstagramImagePickerController.h"
//#import "OLInstagramImage.h"
#import <OLInstagramImagePickerController.h>
#import <OLInstagramImage.h>
#import <PECropViewController.h>
//#import "FacebookAlbumPicker.h"
#import "FLAnimatedImage.h"
#import <MessageUI/MessageUI.h>
#import "PopUpViewController.h"

//#import <FBSDKCoreKit/FBSDKCoreKit.h>
//#import <FBSDKLoginKit/FBSDKLoginKit.h>

//@class ViewController;


@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end




@interface ViewController : UIViewController <UIGestureRecognizerDelegate, OLFacebookImagePickerControllerDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, OLInstagramImagePickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PECropViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITextViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) UIButton *chooseFromPictures;
@property (strong, nonatomic) UIButton *chooseFromFacebook;
//@property (strong, nonatomic) FBSDKLoginButton *chooseFromFacebook;
@property (strong, nonatomic) UIButton *chooseFromInsta;
@property (strong, nonatomic) UIButton *cameraButton;

@property (strong,nonatomic) UIImageView *myImageView;
@property (strong,nonatomic) UIImage *myImage;
@property (strong, nonatomic) CAGradientLayer *gradient;

@property (strong, nonatomic) NSTimer *thisTimer;
@property (strong, nonatomic) THLabel *myLabel;
@property (strong, nonatomic) UIButton *zoomButton;
@property (strong, nonatomic) CABasicAnimation *cloudLayerAnimation;
@property (strong, nonatomic) CALayer *cloudLayer;
@property (strong, nonatomic) UIVisualEffectView *bluredEffectView;
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIActivityIndicatorView *thisInd;
@property (strong, nonatomic) THLabel *faceLabel;
@property (strong, nonatomic) THLabel *faceLabel2;
@property (strong, nonatomic) THLabel *label1;
@property (strong, nonatomic) THLabel *label2;
@property (strong, nonatomic) THLabel *label3;
@property (strong, nonatomic) THLabel *label4;
@property (strong, nonatomic) UIImageView *selectView;
@property (strong, nonatomic) NSTimer *pulseTimer;

@property (strong, nonatomic) UIButton *camBack;
@property (strong, nonatomic) UIButton *camAgain;
@property (strong, nonatomic) UIButton *addRect;
@property (strong, nonatomic) UILabel *camBackLabel;
@property (strong, nonatomic) UILabel *camAgainLabel;
@property (strong, nonatomic) UILabel *addRectLabel;

@property (strong, nonatomic) UIActivityIndicatorView *indThis;
@property (strong, nonatomic) UICollectionView *gifView;
@property (strong, nonatomic) UIView *dragView;
@property (strong, nonatomic) UIVisualEffectView *gView;
@property (strong, nonatomic) UIView *yoloView;
@property (strong, nonatomic) UIImageView *upImage;
@property (strong, nonatomic) UILabel *myGifLabel;
@property (nonatomic,retain)  NSMutableArray * imageArray;
@property (strong, nonatomic) NSString *pathx;
@property (strong, nonatomic) UILabel *thisLabr;
@property (strong, nonatomic) UIActivityIndicatorView *inders;
@property (strong, nonatomic) UIView *finishedViews;
@property (strong, nonatomic) UIView *goingToNextView;
@property (strong, nonatomic) UIImagePickerController *_imagePicker;
@property (strong, nonatomic) UIImage *secretImage;
@property (strong, nonatomic) UIView *fullView;
@property (strong, nonatomic) FLAnimatedImageView *bigView;
@property (strong, nonatomic) UIScrollView *thisScroller;
@property (strong, nonatomic) UIPlaceHolderTextView *thisTexter;
@property (strong, nonatomic) UIAlertView *testAlerter;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImage *selectCamImage;
@property (strong, nonatomic) UIImage *againCamImage;
@property (strong, nonatomic) UIImage *myCameraThingDogImage;
@property (strong, nonatomic) UIImage *backCamImage;

@end

