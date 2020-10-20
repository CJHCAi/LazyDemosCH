//
//  TouchButton.m
//  TouchBut
//
//  Created by 邱荣贵 on 2017/12/6.
//  Copyright © 2017年 邱久. All rights reserved.
//

#import "TouchButton.h"

@implementation TouchButton

@synthesize MoveEnable;
@synthesize MoveEnabled;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
//开始触摸的方法
//触摸-清扫
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    MoveEnabled = NO;
    [super touchesBegan:touches withEvent:event];
    if (!MoveEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    beginpoint = [touch locationInView:self];
}

//触摸移动的方法

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    MoveEnabled = YES;//单击事件可用
    if (!MoveEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    //偏移量
    float offsetX = currentPosition.x - beginpoint.x;
    float offsetY = currentPosition.y - beginpoint.y;
    //移动后的中心坐标
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
    
    //x轴左右极限坐标
    if (self.center.x > (self.superview.frame.size.width-self.frame.size.width/2))
    {
        CGFloat x = self.superview.frame.size.width-self.frame.size.width/2;
        self.center = CGPointMake(x, self.center.y + offsetY);
    }else if (self.center.x < self.frame.size.width/2)
    {
        CGFloat x = self.frame.size.width/2;
        self.center = CGPointMake(x, self.center.y + offsetY);
    }
    
    //y轴上下极限坐标
    if (self.center.y > (self.superview.frame.size.height-self.frame.size.height/2)) {
        CGFloat x = self.center.x;
        CGFloat y = self.superview.frame.size.height-self.frame.size.height/2;
        self.center = CGPointMake(x, y);
    }else if (self.center.y <= self.frame.size.height/2){
        CGFloat x = self.center.x;
        CGFloat y = self.frame.size.height/2;
        self.center = CGPointMake(x, y);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!MoveEnable) {
        return;
    }
    
    if (self.center.x >= self.superview.frame.size.width/2) {//向右侧移动
        //偏移动画
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        self.frame=CGRectMake(self.superview.frame.size.width - 40,self.center.y-20, 40.f,40.f);
        //提交UIView动画
        [UIView commitAnimations];
    }else{//向左侧移动
        
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:1];
        [UIView setAnimationDelegate:self];
        self.frame=CGRectMake(0.f,self.center.y-20, 40.f,40.f);
        //提交UIView动画
        [UIView commitAnimations];
        
    }
    
    //不加此句话，UIButton将一直处于按下状态
    [super touchesEnded: touches withEvent: event];
    
}

//外界因素取消touch事件，如进入电话
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
