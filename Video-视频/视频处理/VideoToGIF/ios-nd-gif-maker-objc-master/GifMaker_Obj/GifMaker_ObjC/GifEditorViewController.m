//
//  GifEditorViewController.m
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 3/4/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import "GifEditorViewController.h"
#import "UIViewController+Theme.h"

#import "GifPreviewViewController.h"
#import "UIImage+animatedGif.h"

#import "GifMaker_Objc-Swift.h"

@interface GifEditorViewController ()

@property (weak, nonatomic) IBOutlet UITextField *captionTextField;

@end

static int const kFrameCount = 16;
static const float kDelayTime = 0.2;
static const int kLoopCount = 0; // 0 means loop forever

@implementation GifEditorViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self subscribeToKeyboardNotifications];
    self.title = @"Add a Caption";
    [self applyTheme:Dark];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.gifImageView.image = self.gif.gifImage;
    
    NSDictionary *defaultAttributes = @{NSStrokeColorAttributeName : [UIColor blackColor],
                                        NSStrokeWidthAttributeName : @(-4),
                                        NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:40.0]};
    [self.captionTextField setDefaultTextAttributes:defaultAttributes];
    [self.captionTextField setTextAlignment:NSTextAlignmentCenter];
    [self.captionTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:@"Add Caption" attributes:defaultAttributes]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unsubscribeFromKeyboardNotifications];
    self.title = @"";
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Observe and respond to keyboard notifications

- (void)subscribeToKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribeFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    if (self.view.frame.origin.y >= 0) {
        CGRect rect = self.view.frame;
        rect.origin.y -= [self getKeyboardHeight:notification];
        self.view.frame = rect;
    }
}

- (void)keyboardWillHide:(NSNotification*)notification {
    if (self.view.frame.origin.y < 0) {
        CGRect rect = self.view.frame;
        rect.origin.y += [self getKeyboardHeight:notification];
        self.view.frame = rect;
    }
}

- (CGFloat)getKeyboardHeight:(NSNotification*)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyboardFrameEnd = [userInfo valueForKey: UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameEndRect = [keyboardFrameEnd CGRectValue];
    return keyboardFrameEndRect.size.height;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

# pragma mark - Preview gif

- (IBAction)presentPreview:(id)sender {
    GifPreviewViewController *previewVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GifPreviewViewController"];
    self.gif.caption = self.captionTextField.text;

    Regift *regift = [[Regift alloc] initWithSourceFileURL:self.gif.videoURL destinationFileURL:nil frameCount:kFrameCount delayTime:kDelayTime loopCount:kLoopCount];
    
    UIFont *captionFont = self.captionTextField.font;
    NSURL *gifURL = [regift createGifWithCaption:self.captionTextField.text font:captionFont];

    Gif *newGif = [[Gif alloc] initWithGifURL:gifURL videoURL:self.gif.videoURL caption:self.captionTextField.text];
    previewVC.gif = newGif;
    
    [self.navigationController pushViewController:previewVC animated:YES];
}

@end
