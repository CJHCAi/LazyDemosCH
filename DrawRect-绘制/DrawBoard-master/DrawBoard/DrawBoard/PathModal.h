//
//  PathModal.h
//  DrawBoard
//
//  Created by 弄潮者 on 15/8/7.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PathModal : NSObject

@property (nonatomic,strong) UIColor *color;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGMutablePathRef path;


@end
