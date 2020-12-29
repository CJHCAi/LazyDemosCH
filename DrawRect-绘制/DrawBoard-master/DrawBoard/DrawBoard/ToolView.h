//
//  ToolView.h
//  DrawBoard
//
//  Created by 弄潮者 on 15/8/7.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ColorSelectBlock)(UIColor *color);
typedef void (^WidthSelectBlock)(CGFloat width);
typedef void (^OtherSelectBlock)(void);

@interface ToolView : UIView
{
    UIView *colorView;
    UIView *widthView;
    
    NSDictionary *_colorDic;    //可以用数组来实现
    
    UIImageView *bgImageView;
    UIImageView *widthBgImageView;
    UIImageView *colorBgImageView;
}

@property (nonatomic,copy) ColorSelectBlock colorBlock;
@property (nonatomic,copy) WidthSelectBlock widthBlock;
@property (nonatomic,copy) OtherSelectBlock eraserBlock;
@property (nonatomic,copy) OtherSelectBlock undoBlock;
@property (nonatomic,copy) OtherSelectBlock clearBlock;

@end
