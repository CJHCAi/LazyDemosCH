//
//  FooterViewController.h
//  H850Samba
//
//  Created by zhengying on 3/25/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FootBarItem : NSObject
@property(nonatomic, strong) UIImage* imageNormal;
@property(nonatomic, strong) UIImage* imageSelect;
@property(nonatomic, strong) UIImage* imageDisable;
@property(nonatomic, weak) UIButton* button;
@property(nonatomic, strong) NSString* tag;
@property(nonatomic, strong) NSString* itemShowText;
@property(nonatomic, assign) BOOL notTab; // not a tab button , just triger an action
@property(nonatomic, assign) BOOL isToggle;
@property(nonatomic, strong) void(^action)();
@property(nonatomic, strong) BOOL(^preAction)(NSString *strTagId); // if true we will call action later or we do nothing.
@end

@interface FooterViewController : UIViewController
@property(nonatomic, assign) CGFloat barHeight;
@property(nonatomic, copy) UIColor *backgoundColor;
@property(nonatomic, copy) UIColor *fontColor;
@property(nonatomic, copy) UIFont *font;
@property(nonatomic, weak) UIView* parentView;
@property(nonatomic, assign) CGFloat leftSpaceWidth;
@property(nonatomic, assign) CGFloat rightSpaceWidth;
@property(nonatomic, assign) CGFloat barItemWidth;
@property(nonatomic, assign) CGFloat barItemHeight;
@property(nonatomic, assign) BOOL animation;
@property(nonatomic, readonly) BOOL isHidden;

-(void)selectItemByTag:(NSString*)tag;
-(void)selectItemForceByTag:(NSString*)tag;

-(FootBarItem*)getFootBarItemByTag:(NSString*)tag;

-(id)initWithHeight:(CGFloat)height BGColor:(UIColor*)color Parent:(UIView*) parentView;

-(void)addCustomView:(UIView*)view;

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                 Action:(void(^)())action;

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                  IsTab:(BOOL)isTab
                                 Action:(void(^)())action;

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                           ImageDisable:(UIImage*)imageDisable
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                  IsToggle:(BOOL)isToggle
                                 Action:(void(^)())action;


-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                           ImageDisable:(UIImage*)imageDisable
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                  IsTab:(BOOL)isTab
                                 Action:(void(^)())action;

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                  IsTab:(BOOL)isTab
                              PreAction:(BOOL(^)(NSString *strTagId))preAction
                                 Action:(void(^)())action;

-(void)addFrontFootBarItemByImageNormal:(UIImage*)imageNormal
                          ImageSelected:(UIImage*)imageSelected
                           ImageDisable:(UIImage*)imageDisable
                                    Tag:(NSString*)tag
                               ShowText:(NSString*)showText
                                  IsTab:(BOOL)isTab
                              PreAction:(BOOL(^)(NSString *strTagId))preAction
                                 Action:(void(^)())action;


+(UIImage*)createFooterBarItemIconByImage:(UIImage*)image
                                     Text:(NSString*)text
                                     Font:(UIFont*)font
                                FontColor:(UIColor*)fontColor;

/*
+(UIButton*)createFooterButtonByImage:(UIImage*)image
                          SelectImage:(UIImage*)selectImage
                         DisableImage:(UIImage*)disalbeImage
                                 Font:(UIFont*)font
                            FontColor:(UIColor*)fontColor
                                 Text:(NSString*)text;
 */

+(UIButton*)createFooterButtonByImage:(UIImage*)image
                          SelectImage:(UIImage*)selectImage
                         DisableImage:(UIImage*)disalbeImage
                       IsToggleButton:(BOOL)isToggleButton
                                 Font:(UIFont*)font
                            FontColor:(UIColor*)fontColor
                                 Text:(NSString*)text;

-(void)updateBarItemByTag:(NSString*)tag
              NormalImage:(UIImage*)normalImage
              SelectImage:(UIImage*)selectImage
             DisableImage:(UIImage*)disableImage Text:(NSString*)text;
    
-(void)updateBarItemByTag:(NSString*)tag
              NormalImage:(UIImage*)normalImage
              SelectImage:(UIImage*)selectImage Text:(NSString*)text;

-(void)updateBarItemByTag:(NSString*)tag
              NormalImage:(UIImage*)normalImage
              SelectImage:(UIImage*)selectImage;

-(void)enableBarItemByTag:(NSString*)tag Enable:(BOOL)enable;
-(void)setHiddenBarItemByTag:(NSString*)tag Hiden:(BOOL)hidden;

-(void)addFrontFootBarItem:(FootBarItem*)footBarItem;

-(void)updateLayoutBarItem;

-(void)dismiss;
-(void)dismissComplete:(void (^)(void))completeAction;
-(void)show;
-(void)show:(void (^)(void))completeAction;

@end