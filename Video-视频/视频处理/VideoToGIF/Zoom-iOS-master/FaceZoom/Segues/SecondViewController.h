//  Created by Phillipus on 11/10/2013.
//  Copyright (c) 2013 Dada Beatnik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "THLabel.h"
#import <MessageUI/MessageUI.h>
#import "PopUpViewController.h"
#import "ViewController.h"

@protocol senddataProtocol <NSObject>

-(void)sendDataToA:(NSMutableArray *)array; //I am thinking my data is NSArray, you can use another object for store your information.

-(NSMutableArray *)getThisArray;//:(NSMutableArray *)array;

-(void)applyCloudAnimation;

-(void)refreshThis;

-(void)gonnaRemoveThis;

@end

@interface SecondViewController : UIViewController <UITextFieldDelegate, MFMessageComposeViewControllerDelegate, UITextViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) CABasicAnimation *cloudLayerAnimation;
@property (strong, nonatomic) CALayer *cloudLayer;
@property (strong, nonatomic) UIImage *mainImage;
@property (strong, nonatomic) UIImage *croppedImage;
@property (strong, nonatomic) UIView *cropFrame;
@property (strong, nonatomic) UIImageView *imageView;
@property CGPoint myPoint;
@property CGRect zoomFrame;
@property (strong, nonatomic)UIImage *img;
@property (strong, nonatomic)UIImage *img1;
@property (strong, nonatomic)UIImage *img2;
@property (strong, nonatomic)UIImage *img3;
@property (strong, nonatomic)UIImage *img4;
@property (strong, nonatomic)UIImage *img5;
@property (strong, nonatomic)NSTimer *thisTimer;
@property (strong, nonatomic)THLabel *textLabel;
@property (strong ,nonatomic)UITextField *textField;
@property (strong, nonatomic)THLabel *textLabel2;
@property (strong, nonatomic)UITextField *textField2;
@property (strong, nonatomic)UITapGestureRecognizer *myTap;
@property CGRect originalFrame;
@property (strong, nonatomic)UIView *blackoutView;
@property (strong, nonatomic)UIScrollView *scrollView;
@property (strong, nonatomic)UISlider *slider1;
@property (strong, nonatomic)UILongPressGestureRecognizer *toClipboard;
@property (strong, nonatomic)UIActivityIndicatorView *inder;
@property (strong, nonatomic)UIView *finishedView;
@property (strong, nonatomic)UIScrollView *actionMenu;
@property (strong, nonatomic)UILabel *zoomLabel;
@property (strong, nonatomic)UISlider *slider2;
@property (strong, nonatomic)UILabel *threeLabel;

@property (strong, nonatomic)UIView *blackoutView2;
@property (strong, nonatomic)UILabel *fiveLabel;
@property (strong, nonatomic)UIImageView *imageView2;
@property (strong, nonatomic)THLabel *textLabel3;
@property (strong, nonatomic)THLabel *textLabel4;
@property (strong, nonatomic)UITextField *textField3;
@property (strong ,nonatomic)UITextField *textField4;
@property (strong, nonatomic)UITapGestureRecognizer *myTap2;
@property (strong, nonatomic)UILongPressGestureRecognizer *toClipboard2;
@property (strong, nonatomic)NSTimer* thisTimer2;
@property float globalSpeed1;
@property float globalSpeed2;
@property (strong, nonatomic)NSMutableArray *thisArr;
@property(nonatomic,assign)id delegate;
@property (strong, nonatomic) UIScrollView *thisScroller2;
@property (strong, nonatomic) UIPlaceHolderTextView *thisTexter2;
@property (strong, nonatomic) UIAlertView *testAlerter2;
@property (strong, nonatomic) UIScrollView *thisScroller3;
@property (strong, nonatomic) UIPlaceHolderTextView *thisTexter3;
@property (strong, nonatomic) UIAlertView *testAlerter3;
@property (strong, nonatomic) NSString *gifURL1;
@property (strong, nonatomic) NSString *gifURL2;
@property (strong, nonatomic) NSTimer *pulserTimer;
@property (strong, nonatomic) UIImageView *selectView2;
@property (strong, nonatomic) UIView *goingToNextView2;

@end
