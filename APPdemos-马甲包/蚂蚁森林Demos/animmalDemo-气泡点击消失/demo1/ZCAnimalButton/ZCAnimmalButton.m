//
//  ZCAnimmalButton.m
//  demo1
//
//  Created by apple2 on 2018/6/20.
//  Copyright © 2018年 Guoao. All rights reserved.
//

#import "ZCAnimmalButton.h"
@interface ZCAnimmalButton()<CAAnimationDelegate>
@property (nonatomic,strong)NSMutableArray *coinTagArray;
@property (nonatomic,assign)CGPoint point;
@end
@implementation ZCAnimmalButton
- (instancetype)initWithFrame:(CGRect)frame andEndPoint:(CGPoint)point
{
    self = [super initWithFrame:frame];
    if (self) {
        self.setting = [ZCAnimmalButtonSetting defaultSetting];
        self.point = CGPointMake(point.x, point.y);
        [self addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)buttonAction{
    for(int i = 0; i < self.setting.totalCount; i ++){
        //延时 注意时间要乘i 这样才会生成一串，要不然就是拥挤在一起的
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*self.setting.timeSpace * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self initCoinViewWithInt:i];
        });
    }
    
    if (self.headImgViewBtnDelegate &&[self.headImgViewBtnDelegate respondsToSelector:@selector(buttonClickBut)]) {
     
    }
    
    
}
- (void)initCoinViewWithInt:(int)i{
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.setting.iconImage ?: self.imageView.image];
    //设置中心位置
    imageView.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    //初始化view控件的位置
    imageView.tag = i + 1000; //设置tag时尽量设置大点的数值
    //将tag添加到数组，用于判断移除
    [self.coinTagArray addObject:[NSNumber numberWithInt:(int)imageView.tag]];
    [self addSubview:imageView];
    [self setAnimationWithLayer:imageView];
}
- (void)setAnimationWithLayer:(UIView *)imageView{
    
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    [movePath moveToPoint:CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0)];
    
    switch (self.setting.animationType) {
        case AnimmalButtonYypeLine://直线
            [movePath addLineToPoint:self.point];
            break;
        case AnimmalButtonTypeCurve://曲线
            //抛物线
            [movePath addQuadCurveToPoint:self.point controlPoint:CGPointMake(self.point.x, self.center.y)];
            break;
        default:
            break;
    }
    
    //位移动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //移动路径
    animation.path = movePath.CGPath;
    animation.duration = self.setting.duration;
    animation.autoreverses = NO;
    animation.repeatCount = 1;
    animation.calculationMode = kCAAnimationPaced;
    animation.delegate = self;
    [imageView.layer addAnimation:animation forKey:@"position"];
    
}
-(void)animationDidStart:(CAAnimation *)anim{
    self.hidden = YES;
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag){//动画执行结束移除view
        NSLog(@"动画结束");
        UIView *coinView =(UIView *)[self viewWithTag:[[self.coinTagArray firstObject] intValue]];
        [coinView removeFromSuperview];
        [self removeFromSuperview];
        [self.coinTagArray removeObjectAtIndex:0];
    }
}

@end

#pragma mark - Setting Methods
@implementation ZCAnimmalButtonSetting

+ (ZCAnimmalButtonSetting *)defaultSetting{
    ZCAnimmalButtonSetting *defaultSetting = [[ZCAnimmalButtonSetting alloc] init];
    defaultSetting.totalCount = 1;//动画产生imagView的个数
    defaultSetting.timeSpace = 0.1;//产生imageVIew的时间间隔
    defaultSetting.duration = 1;//动画时长
    defaultSetting.animationType = AnimmalButtonTypeCurve;//默认为曲线
    return defaultSetting;
}
@end
