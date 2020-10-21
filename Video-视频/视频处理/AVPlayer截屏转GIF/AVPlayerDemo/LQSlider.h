//
//  LQSlider.h
//  Progress
//
//  Created by 李强 on 17/2/28.
//  Copyright © 2017年 李强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    LQSliderSmall,
    LQSliderMiddle,
    LQSliderBig,
}LQSliderType;

@interface LQSlider : UISlider
@property (nonatomic, assign) LQSliderType type;
@end
