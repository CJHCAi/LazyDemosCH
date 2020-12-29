//
//  AlertManager.m
//  H850App
//
//  Created by zhengying on 4/4/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "AlertManager.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UIImage+Utility.h"
#import "CSButton.h"

@implementation AlertManager

#define DEFAULT_DISSMISS_TIME 1.5

+(void)showAlertText:(NSString*)text {
    [[self class]showAlertText:text InView:nil];
}

+(void)showAlertText:(NSString*)text InView:(UIView*)view {
    [[self class] showAlertText:text InView:view hiddenAfter:DEFAULT_DISSMISS_TIME];
}

+(void)showAlertText:(NSString*)text InView:(UIView*)view hiddenAfter:(NSInteger)sec {
    
    UIView* inView = view;
    if (inView == nil) {
        AppDelegate* delegate = [UIApplication sharedApplication].delegate;
        inView = delegate.mainNavigationController.view;
    }
    
    MBProgressHUD* hudProgress = [[MBProgressHUD alloc] initWithView:inView];
    hudProgress.detailsLabelText = text;
    hudProgress.mode = MBProgressHUDModeText;
    hudProgress.color = [UIColor colorWithRed:238.0 / 255.0 green:238.0 / 255.0 blue:238.0 / 255.0 alpha:1.0];
    
    [inView addSubview:hudProgress];
    [hudProgress show:YES];
    
    [NSTimer scheduledTimerWithTimeInterval:sec
                                     target:[self class]
                                   selector:@selector(timerFiredDissmiss:)
                                   userInfo:hudProgress
                                    repeats: NO];
}

+(id)showCommonProgress {
    return [[self class]showCommonProgressInView:nil];
}

+(id)showCommonProgressInView:(UIView*)view {
    return [[self class]showCommonProgressWithText:nil InView:view];
}

+(id)showCommonProgressWithText:(NSString*)text {
    return [[self class] showCommonProgressWithText:text InView:nil];
}

+(id)showCommonProgressWithText:(NSString*)text InView:(UIView*)view {
    UIView* inView = view;
    if (inView == nil) {
        AppDelegate* delegate = [UIApplication sharedApplication].delegate;
        inView = delegate.mainNavigationController.view;
    }
    MBProgressHUD* hudProgress = [[MBProgressHUD alloc] initWithView:inView];
    
    if (text) {
        hudProgress.labelText = text;
    }
    
    [inView addSubview:hudProgress];
    [hudProgress show:YES];
    return hudProgress;
}

+(void)timerFiredDissmiss:(NSTimer*)timer {
    [[self class] dissmiss:timer.userInfo];
}

+(void)dissmiss:(id)win {
    if ([win isKindOfClass:[MBProgressHUD class]]) {
        MBProgressHUD* hudProgress = win;
        [hudProgress hide:NO];
    } else {
        UIView* view = win;
        [view removeFromSuperview];
    }

}

/*

+(id)showInputAlertTitle:(NSString*)title
                 Message:(NSString*)message
       CancelButtonTitle:(NSString*)cancelButtonTitle
      ConfirmButtonTitle:(NSString*)confirmButtonTitle
        ClickBlock:(InputConfirmBlock)buttonClickBlock
{
    CSAlertView * alert = [[CSAlertView alloc] initWithTitle:title
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:cancelButtonTitle
                                           otherButtonTitles:confirmButtonTitle, nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    alert.buttonClickBlock = buttonClickBlock;
    alert.delegate = self;
    [alert show];
    return alert;
}
 */

#define CONFRIM_VIEW_WIDTH 310.0
#define CONFRIM_VIEW_HEIGHT 154.0
#define CONFRIM_VIEW_TITLE_BAR_HEIGHT 33.0
#define CONFRIM_VIEW_TITLEBAR2CONTENT 15
#define CONFRIM_VIEW_FOOTER_SPACE 20
#define CONFRIM_VIEW_CONTENT2BUTTON_SPACE 20

#define CONFRIM_BUTTON_HEIGHT 38
#define CONFRIM_BUTTON_WIDTH 123

#define CONTENT_SIDE_GAP 10.0
//#define CONFIRM_MESSAGE_FONT [UIFont fontWithName:@"VAG-Rounded-Bold" size:12]
#define CONFIRM_MESSAGE_FONT  [UIFont boldSystemFontOfSize:14]

#define CONTENT_VIEW_DEFUALT_HEIGHT (CONFRIM_VIEW_HEIGHT - \
                                CONFRIM_VIEW_FOOTER_SPACE - \
                                CONFRIM_BUTTON_HEIGHT - \
                                CONFRIM_VIEW_CONTENT2BUTTON_SPACE - \
                                CONFRIM_VIEW_TITLE_BAR_HEIGHT - \
                                CONFRIM_VIEW_TITLEBAR2CONTENT)


#define CONTENT_VIEW_DEFUALT_WIDTH (CONFRIM_VIEW_WIDTH - CONTENT_SIDE_GAP*2)

+(CGFloat)widthWithAlertViewContentView {
    return CONTENT_VIEW_DEFUALT_WIDTH;
}

+(id)showConfirmAlertWithTitle:(NSString*)title
                          Text:(NSString*)text
            ConfirmButtonTitle:(NSString*)buttonText
            ConfirmButtonStyle:(eConfirmAlertButtonStyle)style
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock {
    
    return [[self class] showConfirmAlertWithTitle:title
                               Text:text
                 ConfirmButtonTitle:buttonText
                 ConfirmButtonStyle:style
                       ConfirmBlock:ConfirmBlock
                        CancelBlock:nil];

}

+(id)showConfirmAlertWithTitle:(NSString*)title
                          Text:(NSString*)text
            ConfirmButtonTitle:(NSString*)buttonText
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock {
    return [[self class] showConfirmAlertWithTitle:title
                               Text:text
                 ConfirmButtonTitle:buttonText
                 ConfirmButtonStyle:ConfirmAlertButtonStyleNormal
                       ConfirmBlock:ConfirmBlock
                        CancelBlock:nil];
    
}

+(id)showConfirmAlertWithTitle:(NSString*)title
                   ContentView:(UIView*)contentView
            ConfirmButtonTitle:(NSString*)buttonText
            ConfirmButtonStyle:(eConfirmAlertButtonStyle)style
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock {
    
    return [[self class] showConfirmAlertWithTitle:title
                        ContentView:contentView
                 ConfirmButtonTitle:buttonText
                 ConfirmButtonStyle:style
                       ConfirmBlock:ConfirmBlock
                            WithCancelButton:YES
                               CancelBlock:nil];
    
}

+(id)showConfirmAlertWithTitle:(NSString*)title
                   ContentView:(UIView*)contentView
            ConfirmButtonTitle:(NSString*)buttonText
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock {
    
    return [[self class] showConfirmAlertWithTitle:title
                               ContentView:contentView
                        ConfirmButtonTitle:buttonText
                        ConfirmButtonStyle:ConfirmAlertButtonStyleNormal
                              ConfirmBlock:ConfirmBlock
                               WithCancelButton:YES
                               CancelBlock:nil];
}

+(id)showConfirmAlertWithTitle:(NSString*)title
                          Text:(NSString*)text
            ConfirmButtonTitle:(NSString*)buttonText
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock
                   CancelBlock:(CancelBlock)cancelBlock {
    return [[self class] showConfirmAlertWithTitle:title
                                      Text:text
                        ConfirmButtonTitle:buttonText
                        ConfirmButtonStyle:ConfirmAlertButtonStyleNormal
                              ConfirmBlock:ConfirmBlock
                               CancelBlock:cancelBlock];
}

+(id)showConfirmAlertWithTitle:(NSString*)title
                          Text:(NSString*)text
            ConfirmButtonTitle:(NSString*)buttonText
            ConfirmButtonStyle:(eConfirmAlertButtonStyle)style
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock
                   CancelBlock:(CancelBlock)cancelBlock {
    
    CGSize constraint = CGSizeMake(CONFRIM_VIEW_WIDTH - CONTENT_SIDE_GAP * 2  , 20000.0f);
    //CGSize needSize = [text sizeWithFont:CONFIRM_MESSAGE_FONT
    //                   constrainedToSize:constraint
    //                       lineBreakMode:NSLineBreakByWordWrapping];
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGSize needSize = [text boundingRectWithSize:constraint
                                        options:options
                                        attributes:@{NSFontAttributeName:CONFIRM_MESSAGE_FONT} context:nil].size;
    
    CGRect contentLableRect = CGRectMake(0,
                                         0,
                                         CONTENT_VIEW_DEFUALT_WIDTH,
                                         needSize.height);
    
    UILabel* lbltext = [[UILabel alloc]initWithFrame:contentLableRect];
    lbltext.font = CONFIRM_MESSAGE_FONT;
    lbltext.backgroundColor = [UIColor clearColor];
    lbltext.textColor = [UIColor blackColor];
    lbltext.textAlignment = NSTextAlignmentCenter;
    lbltext.numberOfLines = 0;
    lbltext.text = text;
    
    return [[self class] showConfirmAlertWithTitle:title
                               ContentView:lbltext
                        ConfirmButtonTitle:buttonText
                        ConfirmButtonStyle:style
                              ConfirmBlock:ConfirmBlock
                               WithCancelButton:YES
                               CancelBlock:cancelBlock];
}


+(id)showConfirmAlertWithTitle:(NSString*)title
                          ContentView:(UIView*)contentView
            ConfirmButtonTitle:(NSString*)buttonText
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock
                   CancelBlock:(CancelBlock)cancelBlock {
    return [[self class] showConfirmAlertWithTitle:title
                               ContentView:contentView
                        ConfirmButtonTitle:buttonText
                        ConfirmButtonStyle:ConfirmAlertButtonStyleNormal
                              ConfirmBlock:ConfirmBlock
                              WithCancelButton:YES
                               CancelBlock:cancelBlock];

}

+(id)showConfirmAlertWithTitle:(NSString*)title
                   ContentView:(UIView*)contentView
            ConfirmButtonTitle:(NSString*)buttonText
                  ConfirmBlock:(ConfirmBlock)ConfirmBlock
              WithCancelButton:(BOOL)bNeedCancelBtn {
    return [[self class] showConfirmAlertWithTitle:title
                                       ContentView:contentView
                                ConfirmButtonTitle:buttonText
                                ConfirmButtonStyle:ConfirmAlertButtonStyleNormal
                                      ConfirmBlock:ConfirmBlock
                                        WithCancelButton:bNeedCancelBtn
                                       CancelBlock:nil];
}

+(id)showConfirmAlertWithTitle:(NSString*)title
                   ContentView:(UIView*)contentView
            ConfirmButtonTitle:(NSString*)buttonText
            ConfirmButtonStyle:(eConfirmAlertButtonStyle)style
                  ConfirmBlock:(ConfirmBlock)confirmBlock
              WithCancelButton:(BOOL)bNeedCancelBtn
                   CancelBlock:(CancelBlock)cancelBlock {
    UIImage* imagebackground = nil;
    UIView* viewFullScreen = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    CGRect contentRect = contentView.frame;
    contentRect.origin = CGPointMake(CONTENT_SIDE_GAP,
                                     CONFRIM_VIEW_TITLE_BAR_HEIGHT);
    contentView.frame = contentRect;
    
    CGSize needSize = contentView.frame.size;
    
    CGRect backgroundSize = CGRectZero;
    CGRect contentLableRect = CGRectZero;
    
    if (needSize.height > CONTENT_VIEW_DEFUALT_HEIGHT) {
        UIImage *imagePop = [UIImage imageNamed:@"popup-bg"];
        imagebackground = [imagePop resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imagePop.size.height / 2) - 10 , floorf(imagePop.size.width / 2) - 10, floorf(imagePop.size.height / 2) + 10, floorf(imagePop.size.width / 2) + 10)];
        
        backgroundSize = CGRectMake(0, 0,
                                    CONFRIM_VIEW_WIDTH,
                                    CONFRIM_VIEW_HEIGHT + needSize.height - CONTENT_VIEW_DEFUALT_HEIGHT);
        
        contentLableRect = CGRectMake(CONTENT_SIDE_GAP,
                                      CONFRIM_VIEW_TITLE_BAR_HEIGHT+CONFRIM_VIEW_TITLEBAR2CONTENT,
                                      CONTENT_VIEW_DEFUALT_WIDTH,
                                      needSize.height);
    } else {
        imagebackground = [UIImage imageNamed:@"popup-bg"];
        backgroundSize = CGRectMake(0, 0, CONFRIM_VIEW_WIDTH, CONFRIM_VIEW_HEIGHT);
        contentLableRect = CGRectMake(CONTENT_SIDE_GAP,
                                      CONFRIM_VIEW_TITLE_BAR_HEIGHT+CONFRIM_VIEW_TITLEBAR2CONTENT,
                                      CONTENT_VIEW_DEFUALT_WIDTH,
                                      CONTENT_VIEW_DEFUALT_HEIGHT);
    }
    
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:backgroundSize];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.image = imagebackground;
    
    
    UIView* comfirmView = [[UIView alloc]initWithFrame:imageView.frame];
    [comfirmView addSubview:imageView];
    
    
    
    UILabel* lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CONFRIM_VIEW_WIDTH, CONFRIM_VIEW_TITLE_BAR_HEIGHT)];
    lblTitle.font = CONFIRM_MESSAGE_FONT;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.numberOfLines = 0;
    lblTitle.text = title;
    
    CSButton* btnQuit = [[CSButton alloc]initWithImage:[UIImage imageNamed:@"button-close-active"] PressImage:[UIImage imageNamed:@"button-close-active"]DisableImage:nil];
    
    __weak UIView *viewWeakFullScreen = viewFullScreen;
    cancelBlock = [cancelBlock copy];
    
    btnQuit.actionBlock = ^void() {
        UIView *viewStrongFullScreen = viewWeakFullScreen;
        
        if (cancelBlock) {
            if (cancelBlock(viewStrongFullScreen)) {
                [viewStrongFullScreen removeFromSuperview];
            }
        } else {
            [viewStrongFullScreen removeFromSuperview];
        }
    };
    
    UIImage *bgImage = nil;
    UIImage *bgImagePress = nil;
    UIImage *bgImageDisable = nil;
    
    UIImage *imgBk = [UIImage imageNamed:@"btn-3-yellow"];
    //imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
    
    UIImage *imgBkDisbale = [UIImage imageNamed:@"btn-3-grey"];
    //imgBkDisbale = [imgBkDisbale resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBkDisbale.size.height / 2) - 2, floorf(imgBkDisbale.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBkDisbale.size.width / 2) + 2)];
    
    switch (style) {
        case ConfirmAlertButtonStyleNormal: {
            bgImage = imgBk;
            bgImagePress = imgBk;
            bgImageDisable = imgBkDisbale;
        }
            break;
        case ConfirmAlertButtonStyleRed: {
            bgImage = [UIImage imageNamed:@"Button-Red-normal"];
            bgImagePress = [UIImage imageNamed:@"Button-Red-pressed"];
            bgImageDisable = [UIImage imageNamed:@"button-grey"];
        }
        default:
            break;
    }
    
    CSButton* confrimButton = [[CSButton alloc]initResizedButtonTitle:title
                                                      BackgroundImage:bgImage
                                                 BackgroundPressImage:bgImagePress
                                               BackgroundDisableImage:bgImageDisable
                                                                 Rect:CGRectMake(CONFRIM_VIEW_WIDTH/2.0 - CONFRIM_BUTTON_WIDTH/2.0,
                                                                                 CGRectGetHeight(comfirmView.frame) - CONFRIM_VIEW_FOOTER_SPACE - CONFRIM_BUTTON_HEIGHT,
                                                                                 CONFRIM_BUTTON_WIDTH,
                                                                                 CONFRIM_BUTTON_HEIGHT)];
    
    [confrimButton setTitle:buttonText forState:UIControlStateNormal];
    confrimButton.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [confrimButton setTitleColor:[UIColor colorWithRed:141.0 / 255.0 green:78.0 / 255.0 blue:3.0 / 255.0 alpha:1.0] forState:UIControlStateNormal];
    [confrimButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
    [confrimButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    confirmBlock = [confirmBlock copy];
    
    confrimButton.actionBlock = ^void(){
        UIView *viewStrongFullScreen = viewWeakFullScreen;

        if (confirmBlock(viewStrongFullScreen)) {
            [viewStrongFullScreen removeFromSuperview];
        }
    };
    
    btnQuit.frame = CGRectOffset(btnQuit.frame, 2, 2);
    [comfirmView addSubview:confrimButton];
    [comfirmView addSubview:contentView];
    [comfirmView addSubview:lblTitle];
    [comfirmView addSubview:btnQuit];
    
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    UIView* inView = delegate.mainNavigationController.view;
    
    viewFullScreen.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    comfirmView.center = viewFullScreen.center;
    [viewFullScreen addSubview:comfirmView];
    viewFullScreen.center = inView.center;
    [inView addSubview:viewFullScreen];
    
    lblTitle.tag = ALERT_VIEW_ITEM_TAG_LABLE_TITLE;
    btnQuit.tag = ALERT_VIEW_ITEM_TAG_BTN_QUIT;
    viewFullScreen.tag = ALERT_VIEW_ITEM_TAG_FULL_VIEW;
    comfirmView.tag = ALERT_VIEW_ITEM_TAG_ALERT_VIEW;
    confrimButton.tag = ALERT_VIEW_ITEM_TAG_BTN_CONFIRM;
    contentView.tag = ALERT_VIEW_ITEM_TAG_CONTENTVIEW;
    
    btnQuit.hidden = !bNeedCancelBtn;
    
    return viewFullScreen;
}

+(void)setCommonProgressViewID:(id)win Text:(NSString*)text {
    MBProgressHUD* hudProgress = win;
    hudProgress.labelText = text;
}

+(id)getViewByID:(id)win Tag:(NSInteger)tag {
    return [(UIView*)win viewWithTag:tag];
}

+(void)setYOffset:(CGFloat)offset ID:(id)win {
    [UIView beginAnimations:@"animiMove" context:nil];
    [UIView setAnimationDuration:0.2];
    UIView* view = (UIView*)win;
    CGRect viewRect  = view.frame;
    viewRect.origin.y = offset;
    view.frame = viewRect;
    [UIView commitAnimations];
}

@end
