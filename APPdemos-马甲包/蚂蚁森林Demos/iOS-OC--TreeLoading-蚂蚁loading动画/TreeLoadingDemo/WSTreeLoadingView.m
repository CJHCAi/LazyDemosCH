//
//  WSTreeLoadingView.m
//  TreeLoadingDemo
//
//  Created by SongLan on 2017/2/21.
//  Copyright © 2017年 Asong. All rights reserved.
//

#import "WSTreeLoadingView.h"

@interface WSTreeLoadingView()

@property(nonatomic,assign) CGFloat offsetY;
@property(nonatomic,assign) CGFloat moveSpeed;

@property(nonatomic,assign) CGFloat statusF;//1 0


@end

@implementation WSTreeLoadingView



- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewRect = frame;
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
        [self configUI:frame];
    }
    return self;
}
#pragma mark  UI的布局
- (void)configUI:(CGRect)frame {
    
    self.treeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tree2"]];
    self.treeImageView.frame = CGRectMake(0, 0, 100, 100);
    [self addSubview:self.treeImageView];
    self.shapeLayer = [[CAShapeLayer alloc]init];
    self.shapeLayer.fillColor = [UIColor colorWithRed:57/255.0 green:190/255.0 blue:114/255.0 alpha:0.5].CGColor;
    [self.layer addSublayer:self.shapeLayer];
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentShape)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    //移动的速度设置
    self.offsetY =  15;
    self.moveSpeed = 0.5;
    //添加文字
    [self stateDeclare:frame];
}
#pragma mark - 添加文字说明
- (void)stateDeclare:(CGRect)frame{
    UILabel * declareLabel = [[UILabel alloc] init];
    declareLabel.frame = CGRectMake(0, 100, frame.size.width, 20);
    declareLabel.font = [UIFont systemFontOfSize:19];
    declareLabel.text = @"稍等片刻...";
    declareLabel.textColor = [UIColor whiteColor];
    declareLabel.textAlignment = kCTTextAlignmentCenter;
    [self addSubview:declareLabel];
}
#pragma mark - 触发方法
- (void)getCurrentShape{
    if (self.offsetY >= _viewRect.size.height - 15 - 20) {
        self.statusF = 1;
    }else if (self.offsetY <= 15){
        self.statusF = 0;
    }
    if (self.statusF == 1) {
        self.offsetY -= self.moveSpeed;
    }else{
        self.offsetY += self.moveSpeed;
    }
    [self setCurrentStatusShapePath];
}
#pragma mark - 路径设置
- (void)setCurrentStatusShapePath{
    CGMutablePathRef  path =  CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, self.offsetY);
    for (int i = 0; i < self.viewRect.size.width; i ++)  {
        CGPathAddLineToPoint(path, NULL, i, self.offsetY );
    }
    CGPathAddLineToPoint(path, NULL, self.viewRect.size.width, 0 );
    CGPathAddLineToPoint(path, NULL, 0, 0);
    CGPathCloseSubpath(path);
    _shapeLayer.path = path;
    CGPathRelease(path);
}

- (void)dealloc
{
    [self.displayLink invalidate];
}

@end
