//
//  DrawView.h
//  drawBoard
//
//  Created by hyrMac on 15/8/7.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView
{
    CGMutablePathRef _path;
    NSMutableArray *_pathModalArray;
}

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) float width;

- (void)backAction;
- (void)clearAction;
@end
