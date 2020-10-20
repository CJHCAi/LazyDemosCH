//
//  SDDrawingView.h
//  NestHouse
//
//  Created by shansander on 2017/5/6.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDDrawingContentData;
@interface SDDrawingView : UIView

@property (nonatomic, strong) NSMutableArray * pointList;

@property (nonatomic, assign) CGMutablePathRef drawingPath;

@property (nonatomic, strong) UIColor * current_color;

@property (nonatomic, assign) CGFloat current_size;

@property (nonatomic, assign) BOOL isEarse;

@property (nonatomic, strong) UIColor * previous_drawColor;

@property (nonatomic, assign) BOOL canreset;


- (void)clearDrawPath;

@end
