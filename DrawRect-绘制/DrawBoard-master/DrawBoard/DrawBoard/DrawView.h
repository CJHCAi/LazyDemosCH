//
//  DrawView.h
//  DrawBoard
//
//  Created by 弄潮者 on 15/8/7.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView
{
    CGMutablePathRef path;
    NSMutableArray *pathModalArray;
}

@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) CGFloat lineWidth;

- (void)undoAction;
- (void)clearAction;

@end
