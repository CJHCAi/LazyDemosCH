//
//  CSButton.h
//  H850App
//
//  Created by zhengying on 4/9/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSButton : UIButton

@property(nonatomic, copy) void (^actionBlock)();
@property(nonatomic, copy) void (^longPressBlock)();

//H850 Navigation button
-(instancetype)initNavBackButtonTitle:(NSString*)title;
-(instancetype)initNavBackButton;
-(instancetype)initNavNormalButtonTitle:(NSString*)title;

//H850 normal button
-(instancetype)initNormalButtonTitle:(NSString*)text Rect:(CGRect)rect;

//custom image button, the size just the same as image
-(instancetype)initWithImage:(UIImage*)image;
-(instancetype)initWithImage:(UIImage*)image
                  PressImage:(UIImage*)imagePressed
                DisableImage:(UIImage*)imageDisable;

//custom backgroundimage button, the size just the same as backgroundimage

-(instancetype)initWithTitle:(NSString*)title
             BackgroundImage:(UIImage*)image
      BackgroundImagePressed:(UIImage*)imagePressed
     BackgroundImageDisabled:(UIImage*)imageDisabled;

-(instancetype)initWithTitle:(NSString*)title
             BackgroundImage:(UIImage*)image
      BackgroundImagePressed:(UIImage*)imagePressed
     BackgroundImageDisabled:(UIImage*)imageDisabled
                        Font:(UIFont*)font;

-(instancetype)initWithTitle:(NSString*)title
             BackgroundImage:(UIImage*)image
      BackgroundImagePressed:(UIImage*)imagePressed
     BackgroundImageDisabled:(UIImage*)imageDisabled
                        Font:(UIFont*)font
                    Position:(CGPoint)point;

//custom image button,  resize is possible
-(instancetype)initResizedButtonImage:(UIImage*)image
                           PressImage:(UIImage*)imagePressed
                         DisableImage:(UIImage*)imageDisabled
                                 Rect:(CGRect)rect;

-(instancetype)initResizedButtonTitle:(NSString*)title
                      BackgroundImage:(UIImage*)image
                 BackgroundPressImage:(UIImage*)imagePressed
               BackgroundDisableImage:(UIImage*)imageDisabled
                                 Rect:(CGRect)rect
                                 Font:(UIFont*)font;

-(instancetype)initResizedButtonTitle:(NSString*)title
                      BackgroundImage:(UIImage*)image
                 BackgroundPressImage:(UIImage*)imagePressed
               BackgroundDisableImage:(UIImage*)imageDisabled
                                 Rect:(CGRect)rect;


@end
