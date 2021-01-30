//
//  WSTreeLoadingView.h
//  TreeLoadingDemo
//
//  Created by SongLan on 2017/2/21.
//  Copyright © 2017年 Asong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSTreeLoadingView : UIView
@property(nonatomic,strong) CADisplayLink * displayLink;
@property(nonatomic,strong) CAShapeLayer * shapeLayer;
@property(nonatomic,strong) UIImageView * treeImageView;
@property(nonatomic) CGRect viewRect;

@end
