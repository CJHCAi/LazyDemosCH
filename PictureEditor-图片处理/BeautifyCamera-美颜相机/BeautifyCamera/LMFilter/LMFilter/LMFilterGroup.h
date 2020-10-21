//
//  LMFilterGroup.h
//  Test1030
//
//  Created by xx11dragon on 15/11/4.
//  Copyright © 2015年 xx11dragon. All rights reserved.
//

#import "GPUImageFilterGroup.h"

@interface LMFilterGroup: GPUImageFilterGroup

@property (nonatomic , copy) NSString *title;

@property (nonatomic, assign) CGFloat combiIntensity;

@property (nonatomic) UIImage *effectIcon;

@end
