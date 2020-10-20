//
//  AnimationView.h
//  CameraDemo
//
//  Created by apple on 2017/3/21.
//  Copyright © 2017年 yangchao. All rights reserved.
//
#import <UIKit/UIKit.h>
@protocol AnimationViewDeledate <NSObject>

-(void)dismissEndCallBack;

@end

@interface AnimationView : UIView

-(instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic,weak)id<AnimationViewDeledate> AnimationViewDeledate;
@end
