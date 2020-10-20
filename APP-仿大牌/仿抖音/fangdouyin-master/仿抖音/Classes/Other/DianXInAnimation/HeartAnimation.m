//
//  HeartAnimation.m
//  douyin
//
//  Created by liyongjie on 2018/2/6.
//  Copyright © 2018年 world. All rights reserved.
//

#import "HeartAnimation.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


const CGFloat heart_width = 100;
const CGFloat heart_height = 100;


@interface HeartAnimation()
@property (nonatomic,strong)UIImageView *tmpImageView;
@end

@implementation HeartAnimation
#pragma mark - 单例
static HeartAnimation *heart;
+(instancetype)sharedManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        heart = [[super allocWithZone:NULL]init];
    });
    return heart;
}
+(id)allocWithZone:(struct _NSZone *)zone{
    
    return [HeartAnimation sharedManager];
}
-(id)copyWithZone:(NSZone *)zone{
    return [HeartAnimation sharedManager];
}


#pragma mark -创建心形图片
-(void)createHeartWithTap:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:[tap view]];
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"img_like"]];
    img.frame = CGRectMake(0, 0, heart_width, heart_height);
    img.center = point;
    img.contentMode = UIViewContentModeScaleToFill;
    self.tmpImageView = img;
    int isRight = arc4random()%2 ? 1 : -1;
    
    img.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(arc4random()%20)*isRight);
    [[tap view] addSubview:img];
    //弹簧动画
    [img.layer addAnimation:[self springAnimationWithFrame:img.frame] forKey:@"springAnimation"];
 
    //放大，透明度变化同时进行
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[[self makeScaleAnimatin],[self makeOpacityAnimation]];
    groupAnimation.duration = 2;
    groupAnimation.fillMode = kCAFillModeForwards;
    groupAnimation.removedOnCompletion = NO;
    [img.layer addAnimation:groupAnimation forKey:@"groupAnimation"];

    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tmpImageView removeFromSuperview];
        weakSelf.tmpImageView = nil;
    });
    
    
}
//弹簧动画
-(CASpringAnimation *)springAnimationWithFrame:(CGRect)frame{
    CASpringAnimation *springAni = [CASpringAnimation animationWithKeyPath:@"bounds"];
    springAni.fromValue = [NSValue valueWithCGRect:frame];
    springAni.toValue = [NSValue valueWithCGRect:CGRectMake(frame.origin.x+8, frame.origin.y+8, frame.size.width-16, frame.size.height-16)];
    springAni.mass = 50;
    springAni.stiffness = 100;
    springAni.damping = 15;
    springAni.initialVelocity = 15;
    springAni.duration = .2;
    springAni.removedOnCompletion = NO;
    springAni.fillMode = kCAFillModeForwards;
    
    return springAni;
}
//放大动画
-(CABasicAnimation *)makeScaleAnimatin{
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = [NSNumber numberWithFloat:1];
    scaleAnim.toValue = [NSNumber numberWithFloat:1.9];
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.fillMode = kCAFillModeForwards;
    scaleAnim.duration = 1;

    return scaleAnim;
}
-(CABasicAnimation *)makeOpacityAnimation{
    
    CABasicAnimation *showViewAnn = [CABasicAnimation animationWithKeyPath:@"opacity"];
    showViewAnn.fromValue = [NSNumber numberWithFloat:1.0];
    showViewAnn.toValue = [NSNumber numberWithFloat:0.0];
    showViewAnn.duration = 1;
    showViewAnn.fillMode = kCAFillModeForwards;
    showViewAnn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    showViewAnn.removedOnCompletion = NO;


    return showViewAnn;
}

@end
