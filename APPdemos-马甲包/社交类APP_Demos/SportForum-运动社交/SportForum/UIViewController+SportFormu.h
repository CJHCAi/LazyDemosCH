//
//  UIViewController+SportFormu.h
//  SportFormu
//
//  Created by zhengying on 3/24/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GENERATE_VIEW_TITLE_BAR 9
#define GENERATE_VIEW_BODY 10
#define GENERATE_VIEW_TITLE 11
#define GENERATE_BTN_BACK 12
#define GENERATE_IMAGE_BACK 13
typedef void (^BackBlock)(void);

@interface UIViewController (SportFormu)
-(void)setBackgroudImage;
-(void)setNavigationTitle:(NSString*)title;
-(void)setBarItemWithLeftButton:(UIButton *)btnLeft
                   LeftSelector:(SEL)leftSelector
                    RightButton:(UIButton *)btnRight
                  RightSelector:(SEL)rightSelector;
-(void)setBarItemWithLeftButtonImage:(UIImage *)imageLeft
          LeftButtonHighlightedImage:(UIImage *)imageLeftHighlight
                        LeftSelector:(SEL)leftSelector
                    RightButtonImage:(UIImage *)imageRight
         RightButtonHighlightedImage:(UIImage *)imageRightHighlight
                       RightSelector:(SEL)rightSelector;
-(void)generateCommonViewInParent:(UIView*)viewParent Title:(NSString*)title IsNeedBackBtn:(BOOL)bNeed;
-(void)generateCommonViewInParent:(UIView*)viewParent Title:(NSString*)title IsNeedBackBtn:(BOOL)bNeed ActionBlock:(BackBlock) backBlock;

@end
