//
//  ToolView.h
//  drawBoard
//
//  Created by hyrMac on 15/8/7.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ColorSelBlock) (UIColor *);
typedef void (^WidthSelBlock) (float);
typedef void (^FuncBlock) (void);

@interface ToolView : UIView
{
    UIView *_funcView;
    UIView *_colorView;
    UIView *_lineWidthView;
    
    
    NSArray *_colorArray;
    NSArray *_lineArray;
}

@property (nonatomic, copy) ColorSelBlock colorBlock;
@property (nonatomic, copy) WidthSelBlock widthBlock;

@property (nonatomic, copy) FuncBlock eraserBlock;
@property (nonatomic, copy) FuncBlock backBlock;
@property (nonatomic, copy) FuncBlock clearBlock;

@end
