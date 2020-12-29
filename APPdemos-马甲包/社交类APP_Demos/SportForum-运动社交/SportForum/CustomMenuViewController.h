//
//  CustomMenuViewController.h
//  housefinder
//
//  Created by zhengying on 8/5/13.
//  Copyright (c) 2013 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ButtonAction)(id sender);

@interface CustomMenuViewController : UIViewController

@property (assign, nonatomic) CGFloat verticalSpacing;
@property (assign, nonatomic) CGFloat buttionHeight;
@property (assign, nonatomic) CGFloat bottomSpace;
@property (assign, nonatomic) CGFloat sideSpace;

-(void)addButtonFromBackTitle:(NSString*)title ActionBlock:(ButtonAction)action;

-(void)addButtonFromBackTitle:(NSString*)title
                   Hightlight:(BOOL)isHightlight
                  ActionBlock:(ButtonAction)action;

-(void)showInView:(UIView*)view;
-(void)hide;
@end
