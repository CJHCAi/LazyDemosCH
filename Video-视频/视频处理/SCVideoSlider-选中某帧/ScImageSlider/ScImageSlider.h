//
//  ScImageSlider.h
//  ScImageSlider
//
//  Created by SunChao on 15/7/16.
//  Copyright (c) 2015年 SunChao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScImageSlider : UIControl
@property (nonatomic) float maximumValue;
@property (nonatomic) float minimumValue;
@property (nonatomic) float knobValue;
@property (nonatomic,strong)NSMutableArray * imageArray;


//Method
-(void)createTheImageWall;
-(void)updateTheKnobImage:(UIImage*)image;
-(void)moveKnobWithSelectedValue:(float)value;
@end
