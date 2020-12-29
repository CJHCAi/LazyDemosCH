//
//  ImageEditViewController.m
//  housefinder
//
//  Created by zhengying on 7/24/13.
//  Copyright (c) 2013 zhengying. All rights reserved.
//

#import "ImageEditViewController.h"
#import "ApplicationContext.h"
#import "MBProgressHUD.h"
#import "UIViewController+SportFormu.h"
#import "SportForumAPI.h"

enum eQuitType{
    quit_Type_none,
    quit_Type_cancel,
    quit_Type_done,
};

@interface ImageEditViewController ()

@end

@implementation ImageEditViewController {
    NSOperationQueue *_operationQueue;
    MBProgressHUD * _HUD;
    BOOL _isFullscreen;
    UIView *_viewSideStatusBar;
    eQuitType quitType;
    CGSize _cropPortrait;
    CGSize _cropLandscape;
    UIAlertView *_alertView;
    BOOL _uploading;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        
        self.minimumScale = 0.2;
        self.maximumScale = 10;
        self.rotateEnabled = YES;
        [self reset:NO];
        _operationQueue = [[NSOperationQueue alloc]init];
        [self setCropSize:CGSizeMake([UIScreen screenWidth],320)];

    }
    return self;
}
 
-(CGSize)calcLandscapeSizeByPortraitSize:(CGSize)protraitSize {
    
    if (protraitSize.height == 0) {
        NSLog(@"Error!!, height is 0");
        return CGSizeMake(300, 300);
    }
    
    CGSize crrentSceenSize = [UIScreen mainScreen].bounds.size;
    CGSize protraitScreenSize = crrentSceenSize;
    
    if (crrentSceenSize.width > crrentSceenSize.height) {
        protraitScreenSize.width = crrentSceenSize.height;
        protraitScreenSize.height = crrentSceenSize.width;
    }
    
    CGSize landscapeScreeSize = CGSizeMake(protraitScreenSize.height, protraitScreenSize.width);
    CGFloat landscapeWHRate = protraitSize.width / protraitSize.height;
    
    
    CGSize landscapeCropSize;
    landscapeCropSize.height = landscapeScreeSize.height-[UIApplication sharedApplication].statusBarFrame.size.height;
    landscapeCropSize.width =  landscapeWHRate * landscapeCropSize.height;
    return landscapeCropSize;
}

-(void)setCropSize:(CGSize)cropSize {
    [super setCropSize:cropSize];
    _cropPortrait = cropSize;
    _cropLandscape = [self calcLandscapeSizeByPortraitSize:cropSize];
}

-(void)initSideStatusBar {
    
    CGFloat buttonWidth = 44;
    CGFloat buttonHeight = 44;
    CGFloat spaceLeft = 5;
    CGFloat spaceTop = 5;
    CGFloat spaceBottom = 10;
    CGFloat siderViewWidth = 54;
    
    if (_viewSideStatusBar == nil) {
        
        _viewSideStatusBar = [UIView new];
        
        [_viewSideStatusBar setOpaque:YES];
        
        [_viewSideStatusBar setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.1]];
        
        CGRect frame = [[self view] bounds];
        frame.origin.y = 0;
        frame.origin.x = frame.size.width - siderViewWidth;

        frame.size.width = siderViewWidth;
        
        [_viewSideStatusBar setFrame:frame];
        [_viewSideStatusBar setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight)];
        
        CGRect rectOK = CGRectMake(spaceLeft, spaceTop, buttonWidth, buttonHeight);
        
        CGRect rectCancel = CGRectMake(spaceLeft, _viewSideStatusBar.frame.size.height-buttonHeight-spaceBottom, buttonWidth, buttonHeight);
        
        UIButton *buttonOK = [[UIButton alloc]initWithFrame:rectOK];
        [buttonOK setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth)];
        
        UIButton *buttonCancel = [[UIButton alloc] initWithFrame:rectCancel];
        [buttonCancel setAutoresizingMask:(UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth)];
        
        [buttonOK setImage:[UIImage imageNamed:@"landscape-v-normal"] forState:UIControlStateNormal];
        [buttonOK setImage:[UIImage imageNamed:@"landscape-v-pressed"] forState:UIControlStateHighlighted];
        
        
        [buttonCancel setImage:[UIImage imageNamed:@"landscape-X-normal"] forState:UIControlStateNormal];
        [buttonCancel setImage:[UIImage imageNamed:@"landscape-X-pressed"] forState:UIControlStateHighlighted];
        
        
        [_viewSideStatusBar addSubview:buttonOK];
        [_viewSideStatusBar addSubview:buttonCancel];
        
        [buttonOK addTarget:self action:@selector(landscapDone:) forControlEvents:UIControlEventTouchUpInside];
        [buttonCancel addTarget:self action:@selector(landscapCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //[self.view insertSubview:_viewSideStatusBar atIndex:0];
    [self.view addSubview:_viewSideStatusBar];
    [self.view bringSubviewToFront:_viewSideStatusBar];
    
    [_viewSideStatusBar setTransform:CGAffineTransformMakeTranslation(self.view.frame.size.width, 0)];
    
    [UIView
     animateWithDuration:0.5
     animations:^{
         [_viewSideStatusBar setTransform:CGAffineTransformIdentity];
     }
     completion:^(BOOL finished) {
         //_visible = YES;
     }];
    
}


-(void)protraitDone:(id)sender {
    
    [self hudMessageShow:YES];
    [super performSelector:@selector(doneAction:) withObject:sender];
}



-(void)protraitCancel:(id)sender {
    [super performSelector:@selector(cancelAction:) withObject:sender];
}

-(void)landscapDone:(id)sender {
    
    [self exitFullscreen];
    [self performSelector:@selector(doneAction:)];
}

-(void)landscapCancel:(id)sender {
    [self exitFullscreen];
    [self performSelector:@selector(cancelAction:)];

}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self hudMessageShow:NO];
}

- (void)enterFullscreen
{
    if (_isFullscreen ) {
        return;
    }
	_isFullscreen = YES;

	//[self.navigationController setNavigationBarHidden:YES animated:YES];
    [self initSideStatusBar];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if ([self.navigationController.topViewController isKindOfClass:[ImageEditViewController class]]) {
        UIInterfaceOrientation currentDeviceOrientation =  [UIApplication sharedApplication].statusBarOrientation;
        
        if (currentDeviceOrientation == UIInterfaceOrientationPortrait ||
            currentDeviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
           //[self.navigationController setNavigationBarHidden:NO animated:YES];
            [super setCropSize:_cropPortrait];
            [self reset:YES];
        } else if (currentDeviceOrientation == UIInterfaceOrientationLandscapeLeft ||
                   currentDeviceOrientation == UIInterfaceOrientationLandscapeRight) {
            //[self.navigationController setNavigationBarHidden:YES animated:YES];
            [super setCropSize:_cropLandscape];
            [self reset:YES];
        }
    }
}

- (void)exitFullscreen
{
    
    _isFullscreen = NO;
    
    [_viewSideStatusBar removeFromSuperview];
    _viewSideStatusBar = nil;
}

- (void)enableApp
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


- (void)disableApp
{
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

#define cButtonLeftSpace 10
#define cButtonRightSpace 10

#define cButtonWidth 80
#define cButtonHeight 40

#define cButtonTopSpace 20

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //set status bar
    /*
    
    [self setBarItemWithLeftButtonImage:[UIImage imageNamed:@"X_btn_normal"]
             LeftButtonHighlightedImage:[UIImage imageNamed:@"X_btn_pressed"]
                           LeftSelector:@selector(protraitCancel:)
                       RightButtonImage:[UIImage imageNamed:@"correct_btn_normal"]
            RightButtonHighlightedImage:[UIImage imageNamed:@"correct_btn_pressed"]
                          RightSelector:@selector(protraitDone:)];
     
     */
    
    UIButton* btnCancel = [[UIButton alloc]initWithFrame:CGRectMake(cButtonLeftSpace, cButtonTopSpace, cButtonWidth, cButtonHeight)];
    [btnCancel setTitle: @"取消" forState:UIControlStateNormal];
    
    UIButton* btnConfrim = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width -
                                                                     cButtonWidth-cButtonRightSpace,
                                                                     cButtonTopSpace,
                                                                     cButtonWidth,
                                                                     cButtonHeight)];
    
    [btnCancel addTarget:self action:@selector(protraitCancel:) forControlEvents:UIControlEventTouchUpInside];
    [btnConfrim setTitle: @"确定" forState:UIControlStateNormal];
    
    [self.view addSubview:btnCancel];
    [self.view addSubview:btnConfrim];
    
    [self.navigationController.navigationBar setHidden:YES];
    
    self.view.backgroundColor = [UIColor blackColor];
    [btnConfrim addTarget:self action:@selector(protraitDone:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleOrientationChangeNotification:) name: UIDeviceOrientationDidChangeNotification object: nil];
}


-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self dismissAlertView];
}


-(void)dismissAlertView {
    if (_alertView) {
        [_alertView dismissWithClickedButtonIndex:0 animated:YES];
        _alertView.delegate = nil;
        _alertView = nil;
    }
}

-(void)handleOrientationChangeNotification:(NSNotification*) notification {
    if ([self.navigationController.topViewController isKindOfClass:[ImageEditViewController class]]) {
        UIInterfaceOrientation currentDeviceOrientation =  [UIApplication sharedApplication].statusBarOrientation;
        
        if (currentDeviceOrientation == UIInterfaceOrientationLandscapeLeft ||
            currentDeviceOrientation == UIInterfaceOrientationLandscapeRight) {
            [self enterFullscreen];
        } else {
            [self exitFullscreen];
        }
        
        [super setCropSize:self.cropSize];
        [self reset:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hudMessageShow:(BOOL)show {
    if (_HUD == nil) {
        _HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    }
    
    if (show) {
        [_HUD show:YES];
    } else {
        [_HUD hide:YES];
    }
}

-(UIImage*)convertImage:(UIImage*)image {
    
    if(image == nil) {
        return nil;
    }
    
    CGFloat factor = image.size.width / image.size.height;
    CGRect newRect = CGRectZero;
    
    if (factor == 0) {
        factor = 0.1;
    }
    
    if ( image.size.width > 1136 ) {
        newRect.size.width = 1136;
        newRect.size.height = newRect.size.width / factor;
    }
    else {
        newRect.size = image.size;
    }
    
    UIGraphicsBeginImageContext(newRect.size);
    [image drawInRect:newRect blendMode:kCGBlendModePlusDarker alpha:1];
    UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tmpImage;
}

#define COMPRESSED_RATE 0.5

-(HFImageEditorDoneCallback)commonDoneCallbackWithUserDoneCallBack:(UserDoneCallBack)usercallback {
    
    __weak ImageEditViewController *thisPointer = self;
    
    HFImageEditorDoneCallback callback = ^(UIImage *editedImage, BOOL canceled) {
        
        ImageEditViewController* strongThis = thisPointer;
        
        if(!canceled) {
            
            [strongThis->_operationQueue addOperationWithBlock:^{

                NSData *imageData = UIImageJPEGRepresentation([self convertImage: editedImage], COMPRESSED_RATE);

                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        
                        UIImage* uploadImage = [UIImage imageWithData:imageData];
                        
                        NSUInteger nUpload = [[[ApplicationContext sharedInstance]getObjectByKey:@"ProfileUpload"]integerValue];
                        NSUInteger nSize = (nUpload == 1 ? 500 : 0);
                        
                        [[SportForumAPI sharedInstance] imageUploadByUIImage:uploadImage Width:nSize Height:nSize IsCompress:YES                                                        UploadProgressBlock:nil
                                                               FinishedBlock:^(int errorCode, NSString *imageID, NSString *imageURL) {
                                                                   [strongThis hudMessageShow: NO];
                                                                   
                                                                   if(errorCode == 0) {
                                                                       usercallback(uploadImage, imageURL, YES);
                                                                       [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ProfileUpload"];
                                                                       [strongThis.navigationController popViewControllerAnimated:YES];
                                                                   }
                                                                   else {
                                                                       [strongThis dismissAlertView];
                                                                       strongThis->_alertView =[[UIAlertView alloc]initWithTitle:@"提示"
                                                                                                                         message:@"上传图像失败，请重试！"
                                                                                                                        delegate:nil
                                                                                                               cancelButtonTitle:@"确定"
                                                                                                               otherButtonTitles:nil];
                                                                       
                                                                       [strongThis->_alertView show];
                                                                       
                                                                       usercallback(nil, nil, NO);
                                                                   }
                                                               }];
                                                               }];
            }];
        } else {
            usercallback(nil, nil, NO);
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ProfileUpload"];
            [strongThis.navigationController popViewControllerAnimated:YES];
        }
    };
    
    return callback;
}


#pragma mark Hooks
- (void)startTransformHook
{
    //self.saveButton.tintColor = [UIColor colorWithRed:0 green:49/255.0f blue:98/255.0f alpha:1];
}

- (void)endTransformHook
{
    //self.saveButton.tintColor = [UIColor colorWithRed:0 green:128/255.0f blue:1 alpha:1];
}


@end
