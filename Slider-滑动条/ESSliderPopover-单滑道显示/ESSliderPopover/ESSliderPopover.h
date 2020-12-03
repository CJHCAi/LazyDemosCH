//
//  ESSliderPopover.h
//  ESSliderPopover
//
//  Created by 梅守强 on 16/7/18.
//  Copyright © 2016年 eshine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESPopover.h"

@interface ESSliderPopover : UISlider

@property (nonatomic, strong) ESPopover *popover;

- (void)showPopover;
- (void)showPopoverAnimated:(BOOL)animated;
- (void)hidePopover;
- (void)hidePopoverAnimated:(BOOL)animated;

@end
