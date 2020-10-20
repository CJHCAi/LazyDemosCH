//
//  CLCustomRotationGestureRecognizer.m
//  菁优网首页动画
//


#import "CLCustomRotationGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@implementation CLCustomRotationGestureRecognizer


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self state] == UIGestureRecognizerStatePossible) {
        [self setState:UIGestureRecognizerStateBegan];
    } else {
        [self setState:UIGestureRecognizerStateChanged];
    }
    
    // 获取手指触摸view是的任意一个触摸对象
    UITouch *touch = [touches anyObject];
    // 获取是手指触摸的view
    UIView *view = [self view];
    CGPoint center = CGPointMake(CGRectGetMidX([view bounds]), CGRectGetMidY([view bounds]));
    CGPoint currentTouchPoint = [touch locationInView:view];
    CGPoint previousTouchPoint = [touch previousLocationInView:view];
    
    // 根据反正切函数计算角度
    CGFloat angleInRadians = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
    // 给属性赋值 记录每次移动的时候偏转的角度 通过角度的累加实现旋转效果
    [self setRotation:angleInRadians];
   
    
}
#pragma mark - 如果触摸结束也就让手势结束
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Perform final check to make sure a tap was not misinterpreted.
    if ([self state] == UIGestureRecognizerStateChanged) {
        [self setState:UIGestureRecognizerStateEnded];
    } else {
        [self setState:UIGestureRecognizerStateFailed];
    }
}
#pragma mark - 触摸取消也就让手势结束
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setState:UIGestureRecognizerStateFailed];
}

@end
