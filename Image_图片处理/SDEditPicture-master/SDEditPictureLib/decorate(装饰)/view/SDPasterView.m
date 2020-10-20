//
//  SDPasterView.m
//  NestHouse
//
//  Created by shansander on 2017/5/6.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import "SDPasterView.h"


#import "SDDecorationFunctionButton.h"

#import "AppFileComment.h"

/**默认的图片上的贴纸大小*/
CGFloat const defaultPasterViewW_H = 120;



@interface SDPasterView ()<UIGestureRecognizerDelegate>
{
    CGFloat minWidth;
    CGFloat minHeight;
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGPoint touchStart;
    CGRect  bgRect ;
    
    CGFloat lastScale;
    
    CGFloat lastRotation;
}/**删除按钮*/
@property (nonatomic, strong) SDDecorationFunctionButton *delegateImageView;
/**缩放和旋转按钮*/
@property (nonatomic, strong) SDDecorationFunctionButton *scaleImageView;
/**贴纸图片*/
@property (nonatomic, strong) UIImageView *pasterImageView;

@end

@implementation SDPasterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.userInteractionEnabled = YES;
    }
    return self;
}
/**
 *  隐藏“删除”和“缩放”按钮
 */
- (void)hiddenBtn
{
    [UIView animateWithDuration:.5 animations:^{
        self.delegateImageView.alpha = 0.0;
        self.delegateImageView.hidden = YES;
        self.scaleImageView.alpha = 0.0;
        self.scaleImageView.hidden = YES;
        
    }];
    
    self.pasterImageView.layer.borderWidth = 0;
}

/**
 *  显示“删除”和“缩放”按钮
 */
- (void)showBtn
{
    [UIView animateWithDuration:.5 animations:^{
        self.delegateImageView.alpha = 1.0;
        self.scaleImageView.alpha = 1.0;
        self.delegateImageView.hidden = NO;
        self.scaleImageView.hidden = NO;
    }];
}


- (void)setupUI
{
    
    minWidth = self.bounds.size.width * 0.5;
    minHeight = self.bounds.size.height * 0.5;
    deltaAngle = atan2(self.frame.origin.y+self.frame.size.height - self.center.y, self.frame.origin.x+self.frame.size.width - self.center.x);
    
    UIImageView *pasterImageView = [[UIImageView alloc]init];
    pasterImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    pasterImageView.layer.borderWidth = 0.5;
    pasterImageView.userInteractionEnabled = YES;
    [self addSubview:pasterImageView];
    self.pasterImageView = pasterImageView;
    
    SDDecorationFunctionButton *delegateImageView = [[SDDecorationFunctionButton alloc]init];
    
    NSString * imageLink = [AppFileComment imagePathStringWithImagename:@"close_icon"];
    [delegateImageView setShowImage:[UIImage imageNamed:imageLink]];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btDeletePressed:)];
    delegateImageView.userInteractionEnabled = YES;
    self.tap.delegate = self;
    [delegateImageView addGestureRecognizer:_tap];
    
    [self addSubview:delegateImageView];
    self.delegateImageView = delegateImageView;
    
    SDDecorationFunctionButton *scaleImageView = [[SDDecorationFunctionButton alloc]init];
    
    NSString * pasterImageLink = [AppFileComment imagePathStringWithImagename:@"editimagerotateicon@2x"];
    
    [scaleImageView setShowImage:[UIImage imageNamed:pasterImageLink]];
    
    self.panResizeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeTranslate:)] ;
        
    scaleImageView.userInteractionEnabled = YES;
    self.panResizeGesture.delegate = self;
    [scaleImageView addGestureRecognizer:_panResizeGesture] ;
    
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyGesture:)];
    self.pinchGesture.delegate = self;
    [self addGestureRecognizer:self.pinchGesture];
    
    self.rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onRotationGesture:)];
    self.rotationGesture.delegate = self;
    [self addGestureRecognizer:self.rotationGesture];
    
    
    [self addSubview:scaleImageView];
    self.scaleImageView = scaleImageView;
    
    self.pasterImageView.frame = CGRectMake(paster_insert_space, paster_insert_space, defaultImageViewW_H, defaultImageViewW_H);
    self.delegateImageView.frame = CGRectMake(0, 0, btnW_H, btnW_H);
    self.scaleImageView.frame = CGRectMake(CGRectGetMaxX(self.pasterImageView.frame) - btnW_H/2, CGRectGetMaxY(self.pasterImageView.frame) - btnW_H/2, btnW_H, btnW_H);
}
/**
 *  旋转手势
 */
- (void)handleRotation:(UIRotationGestureRecognizer *)rotateGesture
{
    self.transform = CGAffineTransformRotate(self.transform, rotateGesture.rotation) ;
    rotateGesture.rotation = 0 ;
}

/**
 *  拖动手势
 */
- (void)dragPasterView:(UIPanGestureRecognizer *)dragPasterView
{
    CGPoint point = [dragPasterView translationInView:dragPasterView.view];
    self.center = CGPointMake(self.center.x + point.x, self.center.y + point.y);
    
    [dragPasterView setTranslation:CGPointZero inView:dragPasterView.view];
    
    [self checkIsOut];
}


/**
 *  右下角的缩放和旋转手势
 */
- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer
{

    
    if ([recognizer state] == UIGestureRecognizerStateBegan)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        if (self.bounds.size.width < minWidth || self.bounds.size.height < minHeight)
        {
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, minWidth + 1 , minHeight + 1);
            self.scaleImageView.frame =CGRectMake(self.bounds.size.width-btnW_H,self.bounds.size.height-btnW_H,btnW_H,btnW_H);
            prevPoint = [recognizer locationInView:self];
        }
        else
        {
            CGPoint point = [recognizer locationInView:self];
            float wChange = 0.0, hChange = 0.0;
            wChange = (point.x - prevPoint.x);
            float wRatioChange = (wChange/(float)self.bounds.size.width);
            hChange = wRatioChange * self.bounds.size.height;
            
            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f)
            {
                prevPoint = [recognizer locationOfTouch:0 inView:self];
                return;
            }
            
            CGFloat finalWidth  = self.bounds.size.width + (wChange) ;
            CGFloat finalHeight = self.bounds.size.height + (wChange) ;
            if (finalWidth > PASTER_SLIDE*(1+0.5))
            {
                finalWidth = PASTER_SLIDE*(1+0.5);
            }
            if (finalWidth < PASTER_SLIDE*(1-0.5))
            {
                finalWidth = PASTER_SLIDE*(1-0.5) ;
            }
            if (finalHeight > PASTER_SLIDE*(1+0.5))
            {
                finalHeight = PASTER_SLIDE*(1+0.5) ;
            }
            if (finalHeight < PASTER_SLIDE*(1-0.5))
            {
                finalHeight = PASTER_SLIDE*(1-0.5) ;
            }
            
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, finalWidth, finalHeight);
            self.scaleImageView.frame = CGRectMake(self.bounds.size.width-btnW_H, self.bounds.size.height-btnW_H, btnW_H, btnW_H);
            self.pasterImageView.frame = CGRectMake(paster_insert_space, paster_insert_space, self.bounds.size.width - paster_insert_space*2, self.bounds.size.height - paster_insert_space*2);
            
            [self changePasterContentFrameView];
            prevPoint = [recognizer locationOfTouch:0 inView:self];
        }
        
        /* 旋转 */
        float ang = atan2([recognizer locationInView:self.superview].y - self.center.y, [recognizer locationInView:self.superview].x - self.center.x) ;
        float angleDiff = deltaAngle - ang ;
        self.transform = CGAffineTransformMakeRotation(-angleDiff);
        [self setNeedsDisplay];
        
    }
    else if ([recognizer state] == UIGestureRecognizerStateEnded)
    {
        prevPoint = [recognizer locationInView:self];
        [self setNeedsDisplay];
    }
    
    //检查旋转和缩放是否出界
//    [self checkIsOut];
}

//TODO: 放大的手势， 这个是两个手指头
- (void)magnifyGesture:(UIPinchGestureRecognizer * )recognizer
{
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        lastScale = 1.0;
        return;
    }
     CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer *)recognizer scale]);
    
    NSLog(@"--> %f",scale);
    
    if (scale <= 1.5 && scale >= 0.5) {
        CGFloat finalWidth  = self.bounds.size.width * scale;
        CGFloat finalHeight = self.bounds.size.height * scale;
        
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, finalWidth, finalHeight);
        self.scaleImageView.frame = CGRectMake(self.bounds.size.width-btnW_H, self.bounds.size.height-btnW_H, btnW_H, btnW_H);
        self.pasterImageView.frame = CGRectMake(paster_insert_space, paster_insert_space, self.bounds.size.width - paster_insert_space*2, self.bounds.size.height - paster_insert_space*2);
        
        [self changePasterContentFrameView];
        
        lastScale = [(UIPinchGestureRecognizer*)recognizer scale];
    }
    
}
//TODO: 旋转手势
- (void)onRotationGesture:(UIRotationGestureRecognizer *)rotationGesture
{
    if([rotationGesture state] == UIGestureRecognizerStateEnded) {
        
        lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (lastRotation - [rotationGesture rotation]);
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [self setTransform:newTransform];
    [self setNeedsDisplay];
    lastRotation = [rotationGesture rotation];
}

-(void)changePasterContentFrameView
{
    
}


/**
 *  左上角的删除点击手势
 */
- (void)btDeletePressed:(UITapGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteThePaster:)])
    {
        [self.delegate deleteThePaster:self];
    }
    [self removeFromSuperview];
    
}

/**
 *  重写pasterImage的set方法
 */
- (void)setPasterImage:(UIImage *)pasterImage
{
    _pasterImage = pasterImage;
    if (pasterImage) {
        self.pasterImageView.image = pasterImage;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

/**
 *  检查在添加tag的时候是否超出了显示范围，如果超出，移动进显示范围内
 */
- (void)checkIsOut
{
    CGPoint point = self.center;
    CGFloat top;
    CGFloat left;
    CGFloat bottom;
    CGFloat right;
    top = point.y - self.frame.size.height/2;
    bottom = (self.superview.frame.size.height - point.y) - self.frame.size.height/2;
    
    if (point.y < self.superview.frame.size.height/2)//顶部超出范围时
    {
        if (top < 0)
        {
            point.y += ABS(top);
        }
    }
    else//底部超出范围时
    {
        if (bottom < 0)
        {
            point.y -= ABS(bottom);
        }
    }
    
    left = point.x - self.frame.size.width/2;
    right =(self.superview.frame.size.width - point.x) - self.frame.size.width/2;
    if (point.x < self.superview.frame.size.width/2)//左边超出范围时
    {
        if (left < 0)
        {
            point.x += ABS(left);
        }
    }
    else//右边超出范围时
    {
        if (right < 0)
        {
            point.x -= ABS(right);
        }
    }
    
    if (point.x == self.center.x && point.y == self.center.y) {
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            self.center = point;
            
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject] ;
    touchStart = [touch locationInView:self.superview] ;
}

/**
 *  移动
 */
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.scaleImageView.frame, touchLocation)) {
        return;
    }
    CGPoint touch = [[touches anyObject] locationInView:self.superview];
    [self translateUsingTouchLocation:touch];
//    [self checkIsOut];
    touchStart = touch;
}

/**
 *  确保移动时不超出屏幕
 */
- (void)translateUsingTouchLocation:(CGPoint)touchPoint
{
    CGPoint newCenter = CGPointMake(self.center.x + touchPoint.x - touchStart.x,
                                    self.center.y + touchPoint.y - touchStart.y) ;
    
    // Ensure the translation won't cause the view to move offscreen. BEGIN
    CGFloat midPointX = CGRectGetMidX(self.bounds) ;
    if (newCenter.x > self.superview.bounds.size.width - midPointX + SECURITY_LENGTH)
    {
        newCenter.x = self.superview.bounds.size.width - midPointX + SECURITY_LENGTH;
    }
    if (newCenter.x < midPointX - SECURITY_LENGTH)
    {
        newCenter.x = midPointX - SECURITY_LENGTH;
    }
    
    CGFloat midPointY = CGRectGetMidY(self.bounds);
    if (newCenter.y > self.superview.bounds.size.height - midPointY + SECURITY_LENGTH)
    {
        newCenter.y = self.superview.bounds.size.height - midPointY + SECURITY_LENGTH;
    }
    if (newCenter.y < midPointY - SECURITY_LENGTH)
    {
        newCenter.y = midPointY - SECURITY_LENGTH;
    }
    // Ensure the translation won't cause the view to move offscreen. END
    self.center = newCenter;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
