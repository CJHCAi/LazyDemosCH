//
//  MuneItem.m
//  WKMuneController
//
//  Created by macairwkcao on 16/1/25.
//  Copyright © 2016年 CWK. All rights reserved.
//

#import "GBPopMenuButtonItem.h"
#import "GBAnimationTool.h"

@interface GBPopMenuButtonItem (){
    CGPoint _orginPoint; //记录平移前的位置
    CGFloat _angle;      //记录平移时的角度
    CGFloat _radius;     //平移半径
    CGPoint _targetPoint; //目标平移目标点
}

@end

@implementation GBPopMenuButtonItem


-(instancetype)initWithSize:(CGSize)size image:(UIImage *)image heightImage:(UIImage *)heightImage target:(id)target action:(SEL)action{
    self = [super init];
    if (self) {
        [self setImage:image forState:UIControlStateNormal];
        [self setImage:heightImage forState:UIControlStateHighlighted];
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        self.frame = CGRectMake(0, 0, size.width, size.height);
        self.layer.cornerRadius = size.width / 2.0;
        _radius = 400.0f;
        
    }
    return self;
}


/**
 *  MuneItem工厂方法
 *
 *  @param size        尺寸
 *  @param image       图片
 *  @param heightImage 高亮图片
 *  @param target      target
 *  @param action      action
 */
+(GBPopMenuButtonItem *)muneItemWithSize:(CGSize)size image:(UIImage *)image heightImage:(UIImage *)heightImage target:(id)target action:(SEL)action{
    GBPopMenuButtonItem *item = [[GBPopMenuButtonItem alloc] initWithSize:size image:image heightImage:heightImage target:target action:action];
    return item;
}

#pragma mark - 展开方法
/**
 *  展开item,以kMuneItemShowTypeRadRight、kMuneItemShowTypeRadLeft以及kMuneItemShowTypeLine方式打开的item，其中kMuneItemShowTypeLine会调用itemShowWithTargetPoint方法
 *
 *  @param angle 角度
 */
-(void)itemShowWithType:(GBButtonItemShowType)type angle:(CGFloat)angle{
    self.type = type;
    switch (type) {
        case GBButtonItemShowTypeRadRight:
            [self itemShowWithAngle:angle];
            break;
        case GBButtonItemShowTypeRadLeft:
            [self itemShowWithAngle:angle];
            break;
        default:{
            CGPoint targetPoint = [self caculateTargetPointWith:angle];
            [self itemShowWithTargetPoint:targetPoint type:GBButtonItemShowTypeRound];
        }
            break;
    }
}

/**
 *  展开item,以kMuneItemShowTypeLine方式打开的item
 *
 *  @param targetPoint targetPoint 展开item目标点
 */
-(void)itemShowWithTargetPoint:(CGPoint)targetPoint type:(GBButtonItemShowType)type{
    _orginPoint = self.center;
    self.type = type;
    CABasicAnimation *scaleAnimation = [GBAnimationTool scaleAnimationWithDuration:0.4 frameValue:0.1 toValue:1.0];
    CABasicAnimation *opacityAnimation = [GBAnimationTool opacityAnimationWithDuration:0.4 frameValue:0.3 toValue:1];
    CAKeyframeAnimation *keyframeAnimation = [GBAnimationTool moveLineWithDuration:0.4 fromPoint:self.center toPoint:targetPoint delegate:self];
    CAAnimationGroup *groupAnimation = [GBAnimationTool groupAnimationWithAnimations:@[scaleAnimation,keyframeAnimation,opacityAnimation] duration:0.4];
    
    [self.layer addAnimation:groupAnimation forKey:nil];
    self.center = targetPoint;
}

#pragma mark - 隐藏方法
/**
 *  关闭时的平移
 */
-(void)itemHide{
    switch (self.type) {
        case GBButtonItemShowTypeRadRight:
            [self itemHideWithRad];
            break;
        case GBButtonItemShowTypeRadLeft:
            [self itemHideWithRad];
            break;
        default:
            [self itemHideWithPoint:_orginPoint];
            break;
    }
}


#pragma mark - 私有方法

/**
 *  展开item，以kMuneItemShowTypeLine和kMuneItemShowTypeRound方式打开的item
 *
 *  @param angle 展开角度
 */
-(void)itemShowWithAngle:(CGFloat)angle{
    //展开动画属性设置
    _angle = angle;
    CGFloat startAngle = - M_PI;
    CGPoint center = CGPointMake(self.center.x + _radius, self.center.y);
    _orginPoint = center;
    CGFloat endAngle = startAngle + angle;
    BOOL clockwise = NO;
    if (self.type == GBButtonItemShowTypeRadLeft) {
        startAngle = 0;
        center = CGPointMake(self.center.x - _radius, self.center.y);
        clockwise = YES;
        endAngle = startAngle - angle;
        _orginPoint = center;
        
    }
    //添加动画
    //1）移动动画
    CAKeyframeAnimation *moveAccAnimation = [GBAnimationTool moveAccWithDuration:0.4 fromPoint:self.center startAngle:startAngle endAngle:endAngle center:center radius:_radius delegate:self clockwise:clockwise];
    //2）缩放动画
    CABasicAnimation *scaleAnimation = [GBAnimationTool scaleAnimationWithDuration:0.4 frameValue:0.1 toValue:1.0];
    //3）透明度动画
    CABasicAnimation *opacityAnimation = [GBAnimationTool opacityAnimationWithDuration:0.4 frameValue:0.3 toValue:1];
    //4)动画组
    CAAnimationGroup *groupAnimation = [GBAnimationTool groupAnimationWithAnimations:@[scaleAnimation,moveAccAnimation,opacityAnimation] duration:0.4];
    //5）将动画添加到图层
    [self.layer addAnimation:groupAnimation forKey:nil];
    
    //动画完成后设置item的位置
    CGFloat y;
    CGFloat temp;
    CGFloat x;
    if (self.type == GBButtonItemShowTypeRadLeft) {
        y = self.center.y + sin(endAngle) * _radius;
        temp = fabs(cos(endAngle) * _radius);
        x = self.center.x - (_radius - temp);
    }
    else{
        y = self.center.y + sin(endAngle) * _radius;
        temp = fabs(cos(endAngle) * _radius);
        x = self.center.x + _radius - temp;
    }
    self.center = CGPointMake( x, y);
}


/**
 *  展开方式为kMuneItemShowTypeRound时根据角度计算目标点
 *
 *  @param angle 需要平移的角度
 *
 *  @return targetPoint 平移目标点
 */
-(CGPoint)caculateTargetPointWith:(CGFloat)angle{
    CGFloat x = self.center.x;
    CGFloat y = self.center.y;
    
    x += 100 * cos(angle);
    y -= 100 * sin(angle);
    CGPoint targetPoint = CGPointMake(x, y);
    return targetPoint;
}

/**
 *  隐藏item,以kMuneItemShowTypeLine和kMuneItemShowTypeRound方式打开的item
 *
 *  @param point item的初始位置
 */
-(void)itemHideWithPoint:(CGPoint)point{
    //添加动画
    CABasicAnimation *scaleAnimation = [GBAnimationTool scaleAnimationWithDuration:0.4 frameValue:0.1 toValue:1.0];
    CABasicAnimation *opacityAnimation = [GBAnimationTool opacityAnimationWithDuration:0.4 frameValue:0.3 toValue:1];
    CAKeyframeAnimation *keyframeAnimation = [GBAnimationTool moveLineWithDuration:0.4 fromPoint:self.center toPoint:point delegate:self];
    CAAnimationGroup *groupAnimation = [GBAnimationTool groupAnimationWithAnimations:@[scaleAnimation,keyframeAnimation,opacityAnimation] duration:0.4];
    
    [self.layer addAnimation:groupAnimation forKey:nil];
    self.center = point;
}

/**
 *  隐藏item，以kMuneItemShowTypeRadLeft和kMuneItemShowTypeRadRight方式打开的Item
 */
-(void)itemHideWithRad{
    CGFloat endAngle;
    CGFloat startAngle;
    BOOL clockwise = YES;
    //展开方向
    if (self.type == GBButtonItemShowTypeRadLeft) {
        endAngle = 0;
        startAngle = endAngle - _angle;
        clockwise = NO;

    }else{
        endAngle = - M_PI;
        startAngle = endAngle + _angle;
    }
    
     //添加动画
    //1)移动动画
    CAKeyframeAnimation *moveAccAnimation = [GBAnimationTool moveAccWithDuration:0.4 fromPoint:self.center startAngle:startAngle endAngle:endAngle center:_orginPoint radius:_radius delegate:self clockwise:clockwise];
    //2)缩放动画
    CABasicAnimation *scaleAnimation = [GBAnimationTool scaleAnimationWithDuration:0.4 frameValue:1 toValue:0.1];
    //3)透明度动画
    CABasicAnimation *opacityAnimation = [GBAnimationTool opacityAnimationWithDuration:0.4 frameValue:1 toValue:0.3];
    //动画组
    CAAnimationGroup *groupAnimation = [GBAnimationTool groupAnimationWithAnimations:@[moveAccAnimation,scaleAnimation,opacityAnimation] duration:0.4];
    //将动画添加到图层
    [self.layer addAnimation:groupAnimation forKey:nil];
    
    //动画完成设置item位置
    CGFloat y;
    CGFloat x;
    if (self.type == GBButtonItemShowTypeRadLeft) {
        y = self.center.y - sin(startAngle) * _radius;
        CGFloat temp = _radius - fabs(cos(startAngle) * _radius);
        x = self.center.x + temp;
    }
    else{
        y = self.center.y - sin(startAngle) * _radius;
        CGFloat temp = _radius - fabs(cos(startAngle) * _radius);
        x = self.center.x - temp;
    }
    self.center = CGPointMake(x , y);
}

@end
