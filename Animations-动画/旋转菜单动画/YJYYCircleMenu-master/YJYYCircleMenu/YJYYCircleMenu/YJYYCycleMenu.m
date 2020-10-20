//
//  YJYYCycleMenu.m
//  YJYYCircleMenu
//
//  Created by 遇见远洋 on 17/1/2.
//  Copyright © 2017年 遇见远洋. All rights reserved.
//

#import "YJYYCycleMenu.h"

@interface YJYYCycleMenu ()
/**<按钮数组*/
@property (strong,nonatomic)NSMutableArray *btnsArray;
/**<标题数组*/
@property (strong,nonatomic)NSArray *titiles;
/**<开始角度*/
@property (strong,nonatomic)NSMutableArray *startAngle;
/**<结束角度*/
@property (strong,nonatomic)NSMutableArray *endAngle;
/** 半径 */
@property(nonatomic,assign) CGFloat radius;
/** 中心点 */
@property(nonatomic,assign) CGPoint centerPoint;
/** 按钮宽高 */
@property(nonatomic,assign) CGFloat itemHW;
@end

@implementation YJYYCycleMenu

+ (instancetype)cycleMenuWithTitles:(NSArray<NSString *> *)titles menuWidth:(CGFloat)menuWidth center:(CGPoint)center radius:(CGFloat)radius {
    YJYYCycleMenu * menu = [[YJYYCycleMenu alloc]init];
    menu.titiles = titles;
    menu.radius = radius;
    menu.centerPoint = center;
    menu.itemHW = menuWidth;
    [menu startAnimation];
    return menu;
}

- (NSMutableArray *)btnsArray {
    if (!_btnsArray) {
        _btnsArray = [NSMutableArray arrayWithCapacity:self.titiles.count];
        for (int i = 0; i < self.titiles.count; i++) {
            UIButton * circleBtn  = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _itemHW, _itemHW)];
            [circleBtn setTitle:self.titiles[i] forState:UIControlStateNormal];
            circleBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
            circleBtn.layer.cornerRadius = _itemHW*0.5;
            circleBtn.layer.masksToBounds = YES;
            [circleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            circleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
            [self addSubview:circleBtn];
            [_btnsArray addObject:circleBtn];
        }
    }
    return _btnsArray;
}

- (NSArray *)titiles {
    if (!_titiles) {
        _titiles = [NSArray array];
    }
    return _titiles;
}

- (NSMutableArray *)startAngle {
    if (!_startAngle) {
        _startAngle = [NSMutableArray array];
        for (int i = 0; i<self.titiles.count;i++ ) {
            [_startAngle addObject:@(2*M_PI/self.titiles.count*i)];
        }
        
        NSLog(@"%@",_startAngle);
    }
    return _startAngle;
}


- (NSMutableArray *)endAngle {
    if (!_endAngle) {
        _endAngle = [NSMutableArray array];
        for (int i = 0; i<self.titiles.count;i++ ) {
            CGFloat angle = 2*M_PI - (2*M_PI/self.titiles.count*i);
            if (angle + [self.startAngle[i] floatValue] != 2*M_PI) {
                
                angle = -angle;
                
                NSLog(@"%f========%f",[self.startAngle[i] floatValue],angle);
            }
            
            [_endAngle addObject:@(angle)];
        }
    }
    return _endAngle;
}


#pragma  mark -  事件处理
#pragma  mark -
/**
 *  开始转圈动画
 */
- (void)startAnimation {
    [self.btnsArray enumerateObjectsUsingBlock:^(UIButton  * circleBtn, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%@",circleBtn.currentTitle);
        [self keyFrameWithStart:[self.startAngle[idx] floatValue] endAngle:[self.endAngle[idx] floatValue] animationView:circleBtn];
    }];
}


/**
 *  帧动画封装
 *
 *  @param startAngle    开始角度
 *  @param endAngle      结束角度
 *  @param animationView 动画view
 */
- (void)keyFrameWithStart:(CGFloat)startAngle endAngle:(CGFloat)endAngle animationView:(UIView *)animationView{
    CAKeyframeAnimation * keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    //创建一条路径
    UIBezierPath * bezierPath = [UIBezierPath bezierPathWithArcCenter:self.centerPoint radius:self.radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    keyFrame.path = bezierPath.CGPath;
    //1.2设置动画执行完毕后，不删除动画
    keyFrame.removedOnCompletion=NO;
    //1.3设置保存动画的最新状态
    keyFrame.fillMode=kCAFillModeForwards;
    //1.4设置动画执行的时间
    keyFrame.duration=15.0;
    keyFrame.repeatCount = NSIntegerMax;
    //1.5设置动画的节奏
    keyFrame.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //2.添加核心动画
    [animationView.layer addAnimation:keyFrame forKey:nil];
}



@end
