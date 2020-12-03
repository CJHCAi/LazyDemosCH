//
//  AnimationViewController.m
//  nyl_animation
//
//  Created by 聂银龙 on 2017/12/18.
//  Copyright © 2017年 Hangzhou Jinlian Network Technology Co., LTD. All rights reserved.
//

#import "AnimationViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kDegreesToRadians(x) (M_PI*(x)/180.0)                 //把角度转换成PI的方式

#define MJWeakSelf __weak typeof(self) weakSelf = self;

@interface AnimationViewController ()
@property(nonatomic, strong) UIView *myView;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property(nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    switch (self.index) {
        case 0: {
            [self gradient];
        }  break;
        
        case 1: {
            [self circleProgressView];
        }  break;
            
        case 2: {
            [self sectorProgress]; // 扇形
        }  break;
            
        case 3: {
            [self animationDrawRectPath]; // 矩形线条闭合动画
        }  break;
            
        case 4: {
            [self drawSecondBezierPath]; // 二次贝塞尔曲线
        }  break;
            
        case 5: {
           
        }  break;
            
        case 6: {
           
        }  break;
            
        default:
            break;
    }
    
}

- (UIView *)myView {
    if (!_myView) {
        _myView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 300) / 2, 100, 300, 300)];
        _myView.backgroundColor = [UIColor lightGrayColor];
    }
    return _myView;
}

#pragma mark - 渐变
- (void)gradient {
    [self.view addSubview:self.myView];
    
    CAGradientLayer *graLayer = [CAGradientLayer layer];
    graLayer.frame = self.myView.bounds;
    graLayer.colors = @[(id)[UIColor redColor].CGColor,
                        (id)[UIColor greenColor].CGColor,
                        (id)[UIColor blueColor].CGColor,
                        (id)[UIColor yellowColor].CGColor,
                        (id)[UIColor purpleColor].CGColor];
    graLayer.startPoint = CGPointMake(0, 0);
    graLayer.endPoint = CGPointMake(0, 1);
    [self.myView.layer addSublayer:graLayer];
}

#pragma mark - 圆环进度(带渐变的)
- (void)circleProgressView {
    /*
     步骤
     1、新建UIBezierPath对象bezierPath
     2、新建CAShapeLayer对象caShapeLayer
     3、将bezierPath的CGPath赋值给caShapeLayer的path，即caShapeLayer.path = bezierPath.CGPath
     4、把caShapeLayer添加到某个显示该图形的layer中
     5、设置渐变(可选)
     6、设置CABasicAnimation 动画属性为strokeEnd
     */
    [self.view addSubview:self.myView];
    
    UIBezierPath *backPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(300/2, 300/2) radius:140 startAngle:kDegreesToRadians(270) endAngle:kDegreesToRadians(270) + kDegreesToRadians(360) clockwise:YES];
    UIBezierPath *progressPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(300/2, 300/2) radius:140 startAngle:kDegreesToRadians(270) endAngle:kDegreesToRadians(270) + kDegreesToRadians(360) clockwise:YES];
    
    
    CAShapeLayer *backShapeLayer = [CAShapeLayer layer];
    backShapeLayer.path = backPath.CGPath;
    backShapeLayer.lineWidth = 10;
    backShapeLayer.strokeColor = [UIColor grayColor].CGColor;
    backShapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.myView.layer addSublayer:backShapeLayer];
    
    
    
    CAShapeLayer *proShapeLayer = [CAShapeLayer layer];
    proShapeLayer.lineWidth = 10;
    proShapeLayer.strokeColor = [UIColor redColor].CGColor;
    proShapeLayer.fillColor = [UIColor clearColor].CGColor;
    proShapeLayer.path = progressPath.CGPath;
    [self.myView.layer addSublayer:proShapeLayer];
    
    
    // 设置渐变色
    CAGradientLayer *graLayer = [CAGradientLayer layer];
    graLayer.frame = self.myView.bounds;
    graLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor greenColor].CGColor, (id)[UIColor blueColor].CGColor, (id)[UIColor yellowColor].CGColor,
                        (id)[UIColor purpleColor].CGColor];
    graLayer.locations = @[@0.1, @0.5, @1, @1, @1];//一个可选的NSNumber数组，决定每个渐变颜色的终止位置，这些值必须是递增的，数组的
    graLayer.startPoint = CGPointMake(0, 0);
    graLayer.endPoint   = CGPointMake(1, 1);
    [self.myView.layer addSublayer:graLayer];
    [graLayer setMask:proShapeLayer];
    
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 3;
    [proShapeLayer addAnimation:animation forKey:nil];
    
}




#pragma mark - 扇形图
- (void)sectorProgress {
    
    UIBezierPath *bezPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(300/2, 300/2) radius:150 startAngle:kDegreesToRadians(270) endAngle:kDegreesToRadians(270) + kDegreesToRadians(180) clockwise:YES];
    [bezPath addLineToPoint:CGPointMake(300/2, 300/2)];// 扇形关键代码
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(10, 100, 300, 300);
    shapeLayer.fillColor = [UIColor orangeColor].CGColor;
    shapeLayer.path  = bezPath.CGPath;
    [self.view.layer addSublayer:shapeLayer];
    _shapeLayer = shapeLayer;
    
    _progress = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.018 target:self selector:@selector(actionSectorTimer) userInfo:nil repeats:YES];
    [_timer fire];
    
    
}

- (void)actionSectorTimer {
    _progress +=1;
     UIBezierPath *bezPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(300/2, 300/2) radius:150 startAngle:kDegreesToRadians(270) endAngle:kDegreesToRadians(270) + kDegreesToRadians(_progress) clockwise:YES];
    [bezPath addLineToPoint:CGPointMake(300/2, 300/2)];// 扇形关键代码
    _shapeLayer.path = bezPath.CGPath;
    if (_progress >= 360) {
        [_timer invalidate];
        _timer = nil;
    }
}


#pragma mark - 矩形线条闭合动画
- (void)animationDrawRectPath {
    UIBezierPath *bezPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 30;
    layer.path = bezPath.CGPath;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:layer];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 1;
    animation.fromValue = @0;
    animation.toValue = @1;
    [layer addAnimation:animation forKey:nil];
}


#pragma mark - 画二次贝塞尔曲线
/*
 //画二元曲线，一般和moveToPoint配合使用
 - (void)addQuadCurveToPoint:(CGPoint)endPoint controlPoint:(CGPoint)controlPoint
 参数：
 endPoint:曲线的终点
 controlPoint:画曲线的控制点
 */
- (void)drawSecondBezierPath {
    UIBezierPath *bezPath = [UIBezierPath bezierPath];
    [bezPath moveToPoint:CGPointMake(0, 280)];
    
    //[bezPath addQuadCurveToPoint:CGPointMake(300, 280) controlPoint:CGPointMake(150, 450)];
    [bezPath addCurveToPoint:CGPointMake(kScreenWidth, kScreenHeight/2) controlPoint1:CGPointMake(120, 600) controlPoint2:CGPointMake(320, 70)];
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = bezPath.CGPath;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth  = 10;
    
    [self.view.layer addSublayer:layer];
   
    // 为曲线添加轨迹动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue   = @1;
    animation.duration = 4;
    [layer addAnimation:animation forKey:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
