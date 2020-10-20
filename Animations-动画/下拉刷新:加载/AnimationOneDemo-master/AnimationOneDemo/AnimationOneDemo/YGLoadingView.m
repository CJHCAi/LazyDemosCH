//
//  YGLoadingView.m
//  AnimationOneDemo
//
//  Created by 数联通 on 2019/3/29.
//  Copyright © 2019年 dothisday. All rights reserved.
//

#import "YGLoadingView.h"
#import <AudioToolbox/AudioToolbox.h>

typedef NS_ENUM(NSInteger,RrefreshControlState) {
    Normal = 0,
    Pulling = 1,
    Rrefreshing = 2,
};

//相位偏移量
static CGFloat phaseShift = 0.25;
//下拉视图高度
static CGFloat pullLoadingHeight = 64.0;

@interface YGLoadingView(){
    //初始相位
    CGFloat phase;
}
//通用---------------------
@property (nonatomic, strong) UIView *contentView;
//
@property (nonatomic, strong) CADisplayLink *displayLink;
//遮罩图层
@property (nonatomic, strong) CAShapeLayer *waveLayer;
//遮罩图层frame
@property (nonatomic) CGRect shapeFrame;

//中心loading相关---------------------
//蒙板
@property (nonatomic, strong) UIView *maskView;

//下拉loading相关---------------------
@property (nonatomic, assign) RrefreshControlState refreshState;
@property (nonatomic, assign) RrefreshControlState oldState;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy)   void(^refreshAction)(YGLoadingView *refreshView);
@property (nonatomic, assign) BOOL isFirstPull;

@end

@implementation YGLoadingView

#pragma mark - 居中刷新
-(instancetype)initCenterLoadingWithSuperView:(UIView *)superView{
    phase = 0;
    //
    self = [super init];
    if (self) {
        [self setupSubviewsWithFrame:superView.bounds];
        [superView addSubview:self];
    }
    return self;
}

#pragma mark - 下拉刷新
-(instancetype)initPullLoadingWithScrollerView:(UIScrollView *)scrollerView refreshingBlock:(nonnull void (^)(YGLoadingView *refreshView))refreshingBlcok{
    self = [super init];
    if (self) {
        self.refreshAction = refreshingBlcok;
        self.isFirstPull = YES;
        //
        self.scrollView = scrollerView;
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        //
        [scrollerView insertSubview:self atIndex:0];
        //
        [self setupSubviewsWithFrame:self.bounds];
    }
    return self;
}
-(void)setupSubviewsWithFrame:(CGRect)frame{
    UIImage *image = [UIImage imageNamed:@"youguloading_w"];
    CGFloat width = 44.0;
    CGFloat height = width*image.size.height/image.size.width;
    CGFloat loadingWidth = width+20.0;
    CGFloat loadingHeight = width+20.0;
    //
    
    self.frame = CGRectMake((frame.size.width-loadingWidth)/2.0, (frame.size.height-loadingHeight)/2.0, loadingWidth, loadingHeight);
    if (self.scrollView) {
        self.frame = CGRectMake(0, -pullLoadingHeight, self.scrollView.frame.size.width, loadingHeight);
    }
    self.contentView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width-loadingWidth)/2.0, (self.frame.size.height-loadingHeight)/2.0, loadingWidth, loadingHeight)];
    [self addSubview:_contentView];
    
    if (!self.scrollView) {
        self.maskView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0.0, loadingWidth, loadingHeight)];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.2;
        _maskView.layer.cornerRadius = 3.0;
        [_contentView addSubview:_maskView];
    }
    //
    
    UIImageView *imageBlackLine = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width/2.0-width/2.0, self.contentView.frame.size.height/2.0-height/2.0, width, height)];
    imageBlackLine.image = [UIImage imageNamed:@"youguloading_w"];
    [_contentView addSubview:imageBlackLine];
    
    UIImageView *imageGreenLine = [[UIImageView alloc]initWithFrame:imageBlackLine.frame];
    imageGreenLine.image = [UIImage imageNamed:@"youguloading_y"];
    [_contentView addSubview:imageGreenLine];
    
    self.waveLayer = [CAShapeLayer layer];
    _waveLayer.frame = CGRectMake(0, height, width, height);
    self.shapeFrame = imageBlackLine.frame;
    
    
    imageGreenLine.layer.mask = _waveLayer;
    
    self.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0];
}
/**
 *  监听方法
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    [self refreshChangeState];
}
/**
 *  通过监听当前scrollView的状态,来改变refreshControl控件的状态
 */
- (void)refreshChangeState{
    CGFloat offsetY = self.scrollView.contentOffset.y;
    // 用户是否在拖动
    if (self.scrollView.dragging) {
        if (offsetY > -pullLoadingHeight) {//这里的数值是根据frame来的
            
            self.refreshState = Normal;
        }else if(offsetY <= -pullLoadingHeight){
            self.refreshState = Pulling;
            //短震  3D Touch中的peek震动反馈
            if (self.isFirstPull) {
                AudioServicesPlaySystemSound(1519);
                self.isFirstPull = NO;
            }
        }
    }else{
        if (offsetY <= -pullLoadingHeight) {
            self.refreshState = Rrefreshing;
        }
    }
}
/**
 *  提供给外界调用的方法,  .h文件里面声明这个方法
 */
- (void)endRefreshing{
    // 1.把状态改为正常
    self.refreshState = Normal;
}
/**
 *  刷新状态发生改变,进行对应的修改
 *
 *  @param refreshState 刷新状态
 */
-(void)setRefreshState:(RrefreshControlState)refreshState{
    // 这句话千万不能少,
    _refreshState = refreshState;
    UIEdgeInsets inset = self.scrollView.contentInset;
    
    switch (refreshState) {
        case Normal:{
            self.isFirstPull = YES;
            if (self.oldState == Rrefreshing) {//======= 这里要做判断, 不然会有bug
                self.scrollView.contentInset = UIEdgeInsetsMake(0.0, inset.left, inset.bottom, inset.right);
            }
        }break;
        case Pulling:
            
            break;
        case Rrefreshing:{
            [UIView animateWithDuration:0.2 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(pullLoadingHeight, inset.left, inset.bottom, inset.right);
            }];
            [self setupSubviewsWithFrame:self.bounds];
            [self startLoading];
            
            // 告知外界刷新了
            self.refreshAction(self);
        }break;
        default:
            break;
    }
    self.oldState = refreshState;//======用来做判断的
}

#pragma mark - 基础方法
- (void)hideLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.scrollView) {
            UIEdgeInsets inset = self.scrollView.contentInset;
            [UIView animateWithDuration:0.2 animations:^{
                self.scrollView.contentInset = UIEdgeInsetsMake(0.0, inset.left, inset.bottom, inset.right);
            }];
            for (UIView *view in self.subviews) {
                [view removeFromSuperview];
            }
        }else{
            [self removeFromSuperview];
        }
    });
}
-(void)startLoading{
    [self startAnimating];
}
- (void)startAnimating {
    [self.displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    CGPoint position = self.waveLayer.position;
    position.y = position.y - self.shapeFrame.size.height;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [NSValue valueWithCGPoint:self.waveLayer.position];
    animation.toValue = [NSValue valueWithCGPoint:position];
    animation.duration = 3.0;
    animation.repeatCount = HUGE_VALF;
    animation.removedOnCompletion = NO;
    [self.waveLayer addAnimation:animation forKey:nil];
    
}
//波浪滚动 phase相位每桢变化值：phaseShift
- (void)update {
    CGRect frame = self.shapeFrame;
    phase += phaseShift;
    UIGraphicsBeginImageContext(frame.size);
    UIBezierPath *wavePath = [UIBezierPath bezierPath];
    CGFloat endX = 0;
    for(CGFloat x = 0; x < frame.size.width ; x += 1) {
        endX=x;
        //正弦函数，求y值
        CGFloat y = 2 * sinf(2 * M_PI *(x / frame.size.width)  + phase) ;
        if (x==0) {
            [wavePath moveToPoint:CGPointMake(x, y)];
        }else {
            [wavePath addLineToPoint:CGPointMake(x, y)];
        }
    }
    CGFloat endY = CGRectGetHeight(frame);
    [wavePath addLineToPoint:CGPointMake(endX, endY)];
    [wavePath addLineToPoint:CGPointMake(0, endY)];
    //修改每桢的wavelayer.path
    self.waveLayer.path = [wavePath CGPath];
    UIGraphicsEndImageContext();
}
@end
