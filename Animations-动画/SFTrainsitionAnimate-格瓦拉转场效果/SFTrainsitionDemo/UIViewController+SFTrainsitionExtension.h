//
//  UIViewController+SFTrainsitionExtension.h
//  SFTrainsitionDemo
//
//  Created by sfgod on 16/5/14.
//  Copyright © 2016年 sufan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface UIViewController (SFTrainsitionExtension)

@property (assign, nonatomic) CGFloat sf_targetHeight;
@property (weak  , nonatomic) UIView *sf_targetView;

@end

