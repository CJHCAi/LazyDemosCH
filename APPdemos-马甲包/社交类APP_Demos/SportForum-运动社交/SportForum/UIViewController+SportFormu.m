//
//  UIViewController+SportFormu.m
//  H850Samba
//
//  Created by zhengying on 3/24/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "UIViewController+SportFormu.h"
#import "AppDelegate.h"

#define BG_IMG @"background-pattern"

@implementation UIViewController (SportFormu)


-(void)setBackgroudImage {
    UIImage *image = [UIImage imageNamed:BG_IMG];
    self.view.layer.contents = (id) image.CGImage;
    //self.view.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:BG_IMG]];
}

-(void)setNavigationTitle:(NSString*)title {
    // this will appear as the title in the navigation bar
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    label.text = title;
    label.font = [UIFont fontWithName:@"VAG-Rounded-Bold" size:20];
    [label sizeToFit];
}

-(void)setBarItemWithLeftButton:(UIButton *)btnLeft
                   LeftSelector:(SEL)leftSelector
                    RightButton:(UIButton *)btnRight
                  RightSelector:(SEL)rightSelector
{
    if(btnLeft)
    {
        UIBarButtonItem * barLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        UIBarButtonItem * negativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
        negativeSpacer.width = 0;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
        {
            negativeSpacer.width = -5;
        }
        
        self.navigationItem.leftBarButtonItems =@[negativeSpacer, barLeft];
        if(leftSelector)
        {
            [btnLeft addTarget:self action:leftSelector forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if(btnRight)
    {
        UIBarButtonItem * barRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
        UIBarButtonItem * negativeSpacer = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                            target:nil action:nil];
        negativeSpacer.width = 0;
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
        {
            negativeSpacer.width = -5;
        }
        
        self.navigationItem.rightBarButtonItems =@[negativeSpacer, barRight];
        
        if(rightSelector)
        {
            [btnRight addTarget:self action:rightSelector forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

-(void)setBarItemWithLeftButtonImage:(UIImage *)imageLeft
          LeftButtonHighlightedImage:(UIImage *)imageLeftHighlight
                        LeftSelector:(SEL)leftSelector
                    RightButtonImage:(UIImage *)imageRight
         RightButtonHighlightedImage:(UIImage *)imageRightHighlight
                       RightSelector:(SEL)rightSelector {
    
    UIButton * btnLeft = nil;
    UIButton * btnRight = nil;
    
    if (imageLeft) {
        
        btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imageLeft.size.width, imageLeft.size.height)];
        
        [btnLeft setImage:imageLeft forState:UIControlStateNormal];
        
        if (imageLeftHighlight) {
            [btnLeft setImage:imageLeftHighlight forState:UIControlStateHighlighted];
        }
    }
    
    if (imageRight) {
        
        btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imageRight.size.width, imageRight.size.height)];
        
        [btnRight setImage:[imageRight resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6 , 6 ,6)] forState:UIControlStateNormal];
        
        if (imageRightHighlight) {
            [btnRight setImage:[imageRightHighlight resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6 , 6 ,6)] forState:UIControlStateHighlighted];
        }
    }
    
    [self setBarItemWithLeftButton:btnLeft LeftSelector:leftSelector RightButton:btnRight RightSelector:rightSelector];
}

-(void)generateCommonViewInParent:(UIView*)viewParent Title:(NSString*)title IsNeedBackBtn:(BOOL)bNeed ActionBlock:(BackBlock) backBlock
{
    UIImage *image = [UIImage imageNamed:@"the-lowest-bg"];
    viewParent.layer.contents = (id) image.CGImage;
    //viewParent.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"the-lowest-bg"]];
    
    UIImage *imgBk = [UIImage imageNamed:@"header-big"];
    imgBk = [imgBk resizableImageWithCapInsets:UIEdgeInsetsMake(floorf(imgBk.size.height / 2) - 2, floorf(imgBk.size.width / 2) - 2, floorf(imgBk.size.height / 2) + 2, floorf(imgBk.size.width / 2) + 2)];
    
    UIImageView *imageViewTop = [[UIImageView alloc]init];
    imageViewTop.frame = CGRectMake(5, 25, viewParent.frame.size.width - 10, 40);
    [imageViewTop setImage:imgBk];
    
    UILabel *labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(viewParent.frame) - 120, 10, 240, 20)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.text = title;
    labelTitle.textAlignment = NSTextAlignmentCenter;
    labelTitle.font = [UIFont boldSystemFontOfSize:16];
    labelTitle.tag = GENERATE_VIEW_TITLE;
    [imageViewTop addSubview:labelTitle];
    
    imageViewTop.tag = GENERATE_VIEW_TITLE_BAR;
    [viewParent addSubview:imageViewTop];
    
    if (bNeed) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 27, 37, 37)];
        [imgView setImage:[UIImage imageNamed:@"nav-back-btn"]];
        imgView.tag = GENERATE_IMAGE_BACK;
        [viewParent addSubview:imgView];
        
        CSButton *btnBack = [CSButton buttonWithType:UIButtonTypeCustom];
        btnBack.frame = CGRectMake(5, 20, 55, 45);
        btnBack.backgroundColor = [UIColor clearColor];
        btnBack.tag = GENERATE_BTN_BACK;
        [viewParent addSubview:btnBack];
        [viewParent bringSubviewToFront:btnBack];
        
        if (backBlock != nil) {
            btnBack.actionBlock = backBlock;
        }
        else
        {
            btnBack.actionBlock = ^void()
            {
                AppDelegate* delegate = [UIApplication sharedApplication].delegate;
                [delegate.mainNavigationController popViewControllerAnimated:YES];
            };
        }
    }
    
    UIView *viewBody = [[UIView alloc]init];
    viewBody.backgroundColor = APP_MAIN_BG_COLOR;
    viewBody.frame = CGRectMake(5, CGRectGetMaxY(imageViewTop.frame), viewParent.frame.size.width - 10, CGRectGetHeight(viewParent.frame) - 120);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:viewBody.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = viewBody.bounds;
    maskLayer.path = maskPath.CGPath;
    viewBody.layer.mask = maskLayer;
    
    viewBody.tag = GENERATE_VIEW_BODY;
    [viewParent addSubview:viewBody];
}

-(void)generateCommonViewInParent:(UIView*)viewParent Title:(NSString*)title IsNeedBackBtn:(BOOL)bNeed
{
    [self generateCommonViewInParent:viewParent Title:title IsNeedBackBtn:bNeed ActionBlock:nil];
}

@end
