//
//  LMFilterChooserViewCell.h
//  LMUpLoadPhoto
//
//  Created by xx11dragon on 15/8/31.
//  Copyright (c) 2015年 xx11dragon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMFilterGroup.h"

@class GPUImageFilterGroup;
@interface LMFilterChooserViewCell : UIView


- (void)setFilter:(LMFilterGroup *)filter;

- (GPUImageFilterGroup *)getFilter;

- (void)setState:(UIControlState)state;

@end
