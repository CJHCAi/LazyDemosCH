//
//  DFGridImageView.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFGridImageView : UIView

-(void) updateWithImages:(NSMutableArray *)images srcImages:(NSMutableArray *)srcImages oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight;

+(CGFloat) getHeight:(NSMutableArray *) images maxWidth:(CGFloat)maxWidth oneImageWidth:(CGFloat)oneImageWidth oneImageHeight:(CGFloat)oneImageHeight;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com