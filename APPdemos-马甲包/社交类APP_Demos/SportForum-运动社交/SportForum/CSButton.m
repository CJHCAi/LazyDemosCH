//
//  CSButton.m
//  H850App
//
//  Created by zhengying on 4/9/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "CSButton.h"

#define NAVIGATION_BUTTON_FONT  [UIFont systemFontOfSize:11]
#define DEFAULT_BUTTON_FONT  [UIFont systemFontOfSize:12]

@implementation CSButton {
    UILongPressGestureRecognizer *_longPressGesture;
}

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//    }
//    return self;
//}

-(void)setActionBlock:(void (^)())actionBlock {
    _actionBlock = actionBlock;
    [self addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)actionButtonClicked:(id)sender {
    if (_actionBlock) {
        _actionBlock();
    }
}

-(instancetype)initNavBackButtonTitle:(NSString*)title {
    self = [self initWithTitle:title
               BackgroundImage:[UIImage imageNamed:@"buttonBack-normal"]
        BackgroundImagePressed:[UIImage imageNamed:@"buttonBack-pressed"]
       BackgroundImageDisabled:nil
                          Font:NAVIGATION_BUTTON_FONT];
    self.titleEdgeInsets = UIEdgeInsetsMake(2, 10, 2, 2);
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return self;
}

-(instancetype)initNavBackButton {
    return [self initNavBackButtonTitle:@"Back"];
}

-(instancetype)initNavNormalButtonTitle:(NSString*)title {
    return  [self initNormalButtonTitle:title Rect:CGRectMake(0, 0, 60, [UIImage imageNamed:@"button-normal"].size.height)];
}

-(instancetype)initResizedButtonImage:(UIImage*)image
                           PressImage:(UIImage*)imagePressed
                         DisableImage:(UIImage*)imageDisabled
                                 Rect:(CGRect)rect {
    
    self = [super initWithFrame:rect];
    
    if (self) {
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(floorf(image.size.height / 2) - 10, floorf(image.size.width / 2) - 10, floorf(image.size.height / 2) + 10, floorf(image.size.width / 2) + 10);
        
        [self setBackgroundImage:[image resizableImageWithCapInsets:edgeInsets] forState:UIControlStateNormal];
        
        if (imagePressed) {
            [self setBackgroundImage:[imagePressed resizableImageWithCapInsets:edgeInsets] forState:UIControlStateHighlighted];
        }
        
        if (imageDisabled) {
            [self setBackgroundImage:[imagePressed resizableImageWithCapInsets:edgeInsets] forState:UIControlStateDisabled];
        }
        
    }
    
    return self;
}

-(instancetype)initResizedButtonTitle:(NSString*)title
                      BackgroundImage:(UIImage*)image
                 BackgroundPressImage:(UIImage*)imagePressed
               BackgroundDisableImage:(UIImage*)imageDisabled
                                 Rect:(CGRect)rect
                                 Font:(UIFont*)font {
    
    self = [super initWithFrame:rect];
    
    if (self) {
        
        [self setTitle:title forState:UIControlStateNormal];
        
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(floorf(image.size.height / 2) - 10, floorf(image.size.width / 2) - 10, floorf(image.size.height / 2) + 10, floorf(image.size.width / 2) + 10);
        
        [self setBackgroundImage:[image resizableImageWithCapInsets:edgeInsets] forState:UIControlStateNormal];
        
        if (imagePressed) {
            [self setBackgroundImage:[imagePressed resizableImageWithCapInsets:edgeInsets] forState:UIControlStateHighlighted];
        }
        
        if (imageDisabled) {
            [self setBackgroundImage:[imageDisabled resizableImageWithCapInsets:edgeInsets] forState:UIControlStateDisabled];
        }
        
        if (font) {
            [self titleLabel].font = font;
        } else {
            [self titleLabel].font = DEFAULT_BUTTON_FONT;
        }
        
    }
    
    return self;
}

-(instancetype)initResizedButtonTitle:(NSString*)title
                      BackgroundImage:(UIImage*)image
                 BackgroundPressImage:(UIImage*)imagePressed
               BackgroundDisableImage:(UIImage*)imageDisabled
                                 Rect:(CGRect)rect {
    return [self initResizedButtonTitle:title
                        BackgroundImage:image
                   BackgroundPressImage:imagePressed
                 BackgroundDisableImage:imageDisabled
                                   Rect:rect
                                   Font:nil];
}

-(instancetype)initNormalButtonTitle:(NSString*)title Rect:(CGRect)rect{
    
    return [self initResizedButtonTitle:title
                        BackgroundImage:[UIImage imageNamed:@"button-normal"]
                   BackgroundPressImage:[UIImage imageNamed:@"button-pressed"]
                 BackgroundDisableImage:[UIImage imageNamed:@"button-grey"]
            //Rect:CGRectMake(0, 0, 60, [UIImage imageNamed:@"button-pressed"].size.height)
                                   Rect:rect
                                   Font:nil];
}

-(instancetype)initWithImage:(UIImage*)image
                  PressImage:(UIImage*)imagePressed
                DisableImage:(UIImage*)imageDisabled {
    //NSAssert(image != nil, @"button image is empty");
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    if (self) {
        [self setImage:image forState:UIControlStateNormal];
        
        if (imagePressed) {
            [self setImage:imagePressed forState:UIControlStateHighlighted];
        }
        
        if (imageDisabled) {
            [self setImage:imageDisabled forState:UIControlStateDisabled];
        }
    }
    
    return self;
}

-(instancetype)initWithImage:(UIImage*)image {
    return [self initWithImage:image PressImage:nil DisableImage:nil];
}

-(instancetype)initWithTitle:(NSString*)title
             BackgroundImage:(UIImage*)image
      BackgroundImagePressed:(UIImage*)imagePressed
     BackgroundImageDisabled:(UIImage*)imageDisabled {
    return [self initWithTitle:title BackgroundImage:image
        BackgroundImagePressed:imagePressed
       BackgroundImageDisabled:imageDisabled
                          Font:nil];
}

-(instancetype)initWithTitle:(NSString*)title
             BackgroundImage:(UIImage*)image
      BackgroundImagePressed:(UIImage*)imagePressed
     BackgroundImageDisabled:(UIImage*)imageDisabled
                        Font:(UIFont*)font
                    Position:(CGPoint)point {
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        
        if (image) {
            [self setBackgroundImage:image forState:UIControlStateNormal];
        }
        
        if (imagePressed) {
            [self setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
        }
        
        if (imageDisabled) {
            [self setBackgroundImage:imageDisabled forState:UIControlStateDisabled];
        }
        
        if (font) {
            self.titleLabel.font = font;
        } else {
            [self titleLabel].font = DEFAULT_BUTTON_FONT;
        }
    }
    
    return self;
}

-(instancetype)initWithTitle:(NSString*)title
             BackgroundImage:(UIImage*)image
      BackgroundImagePressed:(UIImage*)imagePressed
     BackgroundImageDisabled:(UIImage*)imageDisabled
                        Font:(UIFont*)font {
    return [self initWithTitle:title
               BackgroundImage:image
        BackgroundImagePressed:imagePressed
       BackgroundImageDisabled:imageDisabled
                          Font:font
                      Position:CGPointMake(0, 0)];
}


-(void)setLongPressBlock:(void (^)())longPressBlock {
    _longPressBlock = longPressBlock;

    if (_longPressGesture == nil) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleLongPress:)];
        
        [self removeGestureRecognizer:_longPressGesture];
        [self addGestureRecognizer:_longPressGesture];
    }
}

-(void)handleLongPress:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
        if (self.longPressBlock) {
            self.longPressBlock();
        }
    }
}

@end
