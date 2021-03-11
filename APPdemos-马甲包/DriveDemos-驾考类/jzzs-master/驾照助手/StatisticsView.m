//
//  StatisticsView.m
//  驾照助手
//
//  Created by 淡定独行 on 16/5/13.
//  Copyright © 2016年 肖辉良. All rights reserved.
//

#import "StatisticsView.h"
#define kScreenX [UIScreen      mainScreen].bounds.size.width //屏幕宽度
#define kScreenY [UIScreen      mainScreen].bounds.size.height//屏幕高度

@implementation StatisticsView

{
    //UIView *view;
    UIView *_backView;
    UIView *_superView;
    BOOL _startMoving;
    float _height;
    float _width;
    float _y;
}


-(instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _height = frame.size.height;
        _width = frame.size.width;
        _y = frame.origin.y;
        _superView = superView;
        
        [self createStatisticsView];
    }
    
    return self;
}




-(void)createStatisticsView
{
    _backView = [[UIView alloc]initWithFrame:_superView.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0;
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 10,kScreenX, 40)];
    centerView.backgroundColor = [UIColor grayColor];
    NSArray *arr = @[@"答对",@"答错",@"未答"];
    for(int i=0;i<3;i++){
        UILabel *label= [[UILabel alloc]init];
        label.frame = CGRectMake(10*(i+1)+80*(i+1), 10, 40, 40);
        label.text = arr[i];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor blackColor];
        [centerView addSubview:label];
    }
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+50, kScreenX, kScreenY-64-10-40)];
    footView.backgroundColor = [UIColor whiteColor];
    
    
    
    [self addSubview:centerView];
    [self addSubview:footView];
    
    [_superView addSubview:_backView];
    
    
    
    
    
}





//-(void)createStatisticsView
//{
//    //view = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenY, kScreenX, kScreenY-64)];
//    //view.backgroundColor = [UIColor clearColor];
//    
//    
//    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,kScreenX, 100)];
//    headView.backgroundColor = [UIColor colorWithRed:0.126 green:0.129 blue:0.098 alpha:0.393];
//    
//    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 100,kScreenX, 40)];
//    centerView.backgroundColor = [UIColor whiteColor];
//    NSArray *arr = @[@"答对",@"答错",@"未答"];
//    for(int i=0;i<3;i++){
//        UILabel *label= [[UILabel alloc]init];
//        label.frame = CGRectMake(10*(i+1)+80*(i+1), 20, 40, 40);
//        label.text = arr[i];
//        label.textAlignment = NSTextAlignmentLeft;
//        label.textColor = [UIColor blackColor];
//        [centerView addSubview:label];
//    }
//    
//    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 100+50, kScreenX, kScreenY-64-100-40)];
//    footView.backgroundColor = [UIColor whiteColor];
//    
//    [view addSubview:headView];
//    [view addSubview:centerView];
//    [view addSubview:footView];
//    
//    
//    //动画效果
//    [UIView animateWithDuration:0.4 animations:^{
//        view.frame = CGRectMake(0, 64, kScreenX, kScreenY-64);
//    
//    }];
//    
//    [_superView addSubview:view];
//
//}



-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //_startMoving = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    
    if (point.y<25) {
        _startMoving = YES;
    }
    if (_startMoving && self.frame.origin.y >= _y-_height && [self convertPoint:point toView:_superView].y>=150) {
        NSLog(@"%f---%f---%f---%f----%f",self.frame.origin.y,_y,_height,[self convertPoint:point toView:_superView].y,point.y);
        self.frame = CGRectMake(0, [self convertPoint:point toView:_superView].y, _width, _height);
        _backView.alpha = 0.9-self.frame.origin.y/1000;
        
    }
    
    
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _startMoving = NO;
    
    if(self.frame.origin.y < _height/2+75){
        [UIView animateWithDuration:0.4 animations:^{
            self.frame=CGRectMake(0, 150, _superView.frame.size.width, _superView.frame.size.height-150);
            
        }];
        _backView.alpha = 0.9-self.frame.origin.y/1000;
        
    }else{
        [UIView animateWithDuration:0.4 animations:^{
            self.frame=CGRectMake(0, _superView.frame.size.height, _superView.frame.size.width, _superView.frame.size.height-150);
            
        }];
        _backView.alpha = 0;
    }
    
    
}




@end
