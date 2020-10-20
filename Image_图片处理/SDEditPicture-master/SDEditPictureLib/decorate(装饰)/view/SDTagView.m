//
//  SDTagView.m
//  NestHouse
//
//  Created by shansander on 2017/5/6.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import "SDTagView.h"
#import "UILabel+adjustsFontSizeToFitWidth.h"
#import "SDDecorationFunctionButton.h"
#import "AppFileComment.h"
#define max_tag_height 40

#define tag_btn_w_h MAXSize(64)

/**缩放和删除按钮与图片的间隔距离*/
#define paster_insert_tag_space tag_btn_w_h/2

/**总高度*/
#define PASTER_SLIDE_2 120 * 2

#define PASTER_SLIDE_HEIGHT PASTER_SLIDE




@interface SDTagView ()<UIGestureRecognizerDelegate>
{
    CGFloat minWidth;
    CGFloat minHeight;
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGPoint touchStart;
    CGRect  bgRect ;

}

@property (nonatomic, weak) SDTagContentView * tagView;
/**删除按钮*/
@property (nonatomic, strong) SDDecorationFunctionButton *delegateImageView;
/**缩放和旋转按钮*/
@property (nonatomic, strong) SDDecorationFunctionButton *scaleImageView;

@property (nonatomic, weak) UIView * thePerverView;
@end

@implementation SDTagView
#pragma mark - lazy tagView
- (SDTagContentView *)tagView
{
    if (!_tagView) {
        
        CGFloat tag_height = self.bounds.size.height - paster_insert_tag_space;
        
        CGFloat left_spacing = paster_insert_tag_space + 10;
        SDTagContentView * theView = [[SDTagContentView alloc] initWithFrame:CGRectMake(left_spacing, (tag_height - max_tag_height) /2.f, self.bounds.size.width - left_spacing*2, max_tag_height)];
        
        theView.tagModel = self.tagModel;
        [self insertSubview:theView aboveSubview:self.thePerverView];
        _tagView = theView;
    }
    return _tagView;
}

- (UIView *)thePerverView
{
    if (!_thePerverView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
     
        
        _thePerverView = theView;
    }
    return _thePerverView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configTagView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame DecorationFunction:(SDDecorationTagModel )tagModel
{
    self = [super initWithFrame:frame];
    if (self) {
        _tagModel = tagModel;
        [self configTagView];
        self.userInteractionEnabled = YES;

        
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}
//TODO: 初始化界面
- (void)configTagView
{
    
    self.thePerverView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.thePerverView.layer.borderWidth = 1.f;
    
    
    UITapGestureRecognizer * sim_tap = [[UITapGestureRecognizer alloc] init];
    [self.tagView addGestureRecognizer:sim_tap];
    sim_tap.delegate = self;
    
    @weakify_self
    [[sim_tap rac_gestureSignal] subscribeNext:^(UIGestureRecognizer *tap) {
        NSLog(@"tag content gesture");
        @strongify_self
        if (self.delegate && [self.delegate respondsToSelector:@selector(SimplpTapForTagContentWithIndex: inView:)]) {
            [self.delegate SimplpTapForTagContentWithIndex:self.index inView:self];
        }
        
    }];
    
    
 
    
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
    [self addSubview:scaleImageView];
    self.scaleImageView = scaleImageView;
    
    
    self.tagView.center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    self.delegateImageView.frame = CGRectMake(0, 0, tag_btn_w_h, tag_btn_w_h);
//    self.scaleImageView.frame = CGRectMake(CGRectGetMaxX(self.tagView.frame) - tag_btn_w_h/2, CGRectGetMaxY(self.tagView.frame) - tag_btn_w_h/2, tag_btn_w_h, tag_btn_w_h);

    self.thePerverView.frame = CGRectMake(tag_btn_w_h / 2.f, tag_btn_w_h / 2.f, self.frame.size.width - tag_btn_w_h, self.frame.size.height - tag_btn_w_h);
    self.scaleImageView.frame = CGRectMake(CGRectGetMaxX(self.thePerverView.frame) - tag_btn_w_h/2, CGRectGetMaxY(self.thePerverView.frame) - tag_btn_w_h/2, tag_btn_w_h, tag_btn_w_h);
    
}
//TODO: function set
- (void)setTag_string:(NSString *)tag_string
{
    _tag_string = tag_string;
    
    UIFont * tag_font = self.tagView.theTagLabel.font;
    
    CGSize tag_size = [_tag_string sizeWithAttributes:@{NSFontAttributeName:tag_font}];
    CGFloat tag_width = tag_size.width + 30 + paster_insert_tag_space*2;
    if (tag_width > PASTER_SLIDE_2*(1+0.5))
    {
        tag_width = PASTER_SLIDE_2*(1+0.5);
    }
    if (tag_width < PASTER_SLIDE_2*(1-0.2))
    {
        tag_width = PASTER_SLIDE_2*(1-0.2) ;
    }
    self.frame = (CGRect){self.frame.origin,{tag_width , self.frame.size.height}};
    self.thePerverView.frame = CGRectMake(tag_btn_w_h / 2.f, tag_btn_w_h / 2.f, self.frame.size.width - tag_btn_w_h, self.frame.size.height - tag_btn_w_h);
    self.scaleImageView.frame = CGRectMake(CGRectGetMaxX(self.thePerverView.frame) - tag_btn_w_h/2, CGRectGetMaxY(self.thePerverView.frame) - tag_btn_w_h/2, tag_btn_w_h, tag_btn_w_h);
    [self changePasterContentFrameView];
    self.tagView.tag_string = self.tag_string;
}

- (void)hideTagLine
{
    self.thePerverView.hidden = YES;
    
    self.delegateImageView.hidden = YES;
    self.scaleImageView.hidden = YES;
}
//TODO: 刷新tagView的frame
- (void)changePasterContentFrameView
{

    CGFloat tag_height = self.bounds.size.height - paster_insert_tag_space;
    
    CGFloat left_spacing = paster_insert_tag_space + 10;

    self.tagView.frame = CGRectMake(left_spacing, (tag_height - max_tag_height) /2.f, self.bounds.size.width - left_spacing*2, max_tag_height);
    
    self.tagView.center = CGPointMake(self.bounds.size.width / 2.f, self.bounds.size.height / 2.f);
    

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
            self.scaleImageView.frame =CGRectMake(self.bounds.size.width-tag_btn_w_h,self.bounds.size.height-tag_btn_w_h,tag_btn_w_h,tag_btn_w_h);
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
            if (finalWidth > PASTER_SLIDE_2*(1+0.5))
            {
                finalWidth = PASTER_SLIDE_2*(1+0.5);
            }
            if (finalWidth < PASTER_SLIDE_2*(1-0.2))
            {
                finalWidth = PASTER_SLIDE_2*(1-0.2) ;
            }
            
            finalHeight = PASTER_SLIDE_HEIGHT;
//
//            if (finalHeight > PASTER_SLIDE_HEIGHT*(1+0.5))
//            {
//                finalHeight = PASTER_SLIDE_HEIGHT*(1+0.5) ;
//            }
//            if (finalHeight < PASTER_SLIDE_HEIGHT*(1-0.5))
//            {
//                finalHeight = PASTER_SLIDE_HEIGHT*(1-0.5) ;
//            }
            
            self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, finalWidth, finalHeight);
            self.scaleImageView.frame = CGRectMake(self.bounds.size.width-tag_btn_w_h, self.bounds.size.height-tag_btn_w_h, tag_btn_w_h, tag_btn_w_h);
//            self.thePerverView.frame = CGRectMake(tag_btn_w_h/2.f, tag_btn_w_h /2.f, self.frame.size.width - tag_btn_w_h, self.frame.size.height - tag_btn_w_h);
            self.thePerverView.frame = CGRectMake(tag_btn_w_h / 2.f, tag_btn_w_h / 2.f, finalWidth - tag_btn_w_h, finalHeight - tag_btn_w_h);

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
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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
        [self checkIsOut];
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
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
}


@end

#pragma mark - tag Content View

@implementation SDTagContentView
NSString * const TagContentLabelString = @"点击编辑文字";
#pragma mark - lazy label;
- (UILabel *)theTagLabel
{
    if (!_theTagLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self addSubview:theView];
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(25.f);
            make.right.equalTo(self).offset(-5);
            make.height.mas_equalTo(20.f);
        }];
        theView.textColor = [UIColor whiteColor];
        theView.textAlignment = NSTextAlignmentCenter;
//        theView.adjustsFontSizeToFitWidth = true;
//        [theView.text sizeWithFont:<#(UIFont *)#> constrainedToSize:<#(CGSize)#>]
        _theTagLabel = theView;
    }
    return _theTagLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.theTagLabel.text = TagContentLabelString;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setTagModel:(SDDecorationTagModel)tagModel
{
    _tagModel = tagModel;
    if (self.tagModel == SDDecorationTagLeft) {
        [self.theTagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-25.f);
            make.left.equalTo(self).offset(5);
        }];
    }
    [self setNeedsDisplay];
}

//TODO: function set
- (void)setTag_string:(NSString *)tag_string
{
    _tag_string = tag_string;
    
    self.theTagLabel.text = self.tag_string;
    
//    [self.theTagLabel sizeToFit];
}
//TODO: 界面改动，刷新界面，主要是为了改变
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize textSize = [self.theTagLabel intrinsicContentSize];

    NSInteger font_size = [self.theTagLabel getFontSize];
    
    self.theTagLabel.font = [UIFont systemFontOfSize:font_size];
    
    NSLog(@"--> %@",NSStringFromCGSize(textSize));
        
    [self setNeedsDisplay];
    
}
//TODO: 制作标签 圆点的路径
- (UIBezierPath *)getTagPoint
{
    CGFloat hegiht = self.bounds.size.height;
    
    CGFloat oval_widht = 8;
    
    
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, (hegiht - oval_widht)/ 2.f, oval_widht, oval_widht)];
    
    if (self.tagModel == SDDecorationTagLeft) {
        path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.bounds.size.width - oval_widht, (hegiht - oval_widht)/ 2.f, oval_widht, oval_widht)];
    }
    return path;
}
//TODO: 制作标签整体的路径，重头
- (UIBezierPath * )getTagRoundPath
{
    CGFloat hegiht = self.bounds.size.height;
    
    CGFloat widht = self.bounds.size.width;
    
    CGFloat tag_width = widht;

    CGFloat tag_height = hegiht / 2.f;
  
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(tag_width, 0)];
    [bezierPath addLineToPoint: CGPointMake(30.86, 0)];
    [bezierPath addLineToPoint: CGPointMake(15.05, 18)];
    [bezierPath addCurveToPoint: CGPointMake(15.05, 22) controlPoint1: CGPointMake(14.18, 19.21) controlPoint2: CGPointMake(14.18, 20.79)];
    [bezierPath addLineToPoint: CGPointMake(30.86, 40)];
    [bezierPath addLineToPoint: CGPointMake(tag_width, 40)];
    [bezierPath addCurveToPoint: CGPointMake(tag_width + 3.55, 36.55) controlPoint1: CGPointMake(tag_width + 1.66, 40) controlPoint2: CGPointMake(tag_width + 3.55, 38.45)];
    [bezierPath addLineToPoint: CGPointMake(tag_width + 3.55, 3.45)];
    [bezierPath addCurveToPoint: CGPointMake(tag_width, 0) controlPoint1: CGPointMake(tag_width + 3.55, 1.55) controlPoint2: CGPointMake(tag_width + 1.66, 0)];
    [bezierPath addLineToPoint: CGPointMake(tag_width, 0)];
    [bezierPath closePath];
    
    return bezierPath;
}

- (UIBezierPath *)getLeftTagRoundPath
{
    CGFloat hegiht = self.bounds.size.height;
    
    CGFloat widht = self.bounds.size.width;
    
    CGFloat tag_width = widht;
    
    CGFloat tag_height = hegiht / 2.f;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(0, 0)];
    [bezierPath addLineToPoint: CGPointMake(tag_width - 30.86, 0)];
    [bezierPath addLineToPoint: CGPointMake(tag_width - 15.05, 18)];
    [bezierPath addCurveToPoint: CGPointMake(tag_width - 15.05, 22) controlPoint1: CGPointMake(tag_width - 14.18, 19.21) controlPoint2: CGPointMake(tag_width - 14.18, 20.79)];
    [bezierPath addLineToPoint: CGPointMake(tag_width - 30.86, 40)];
    [bezierPath addLineToPoint: CGPointMake(0, 40)];
    [bezierPath addCurveToPoint: CGPointMake(0 - 3.55, 36.55) controlPoint1: CGPointMake(0 - 1.66, 40) controlPoint2: CGPointMake(0 - 3.55, 38.45)];
    [bezierPath addLineToPoint: CGPointMake(0 - 3.55, 3.45)];
    [bezierPath addCurveToPoint: CGPointMake(0, 0) controlPoint1: CGPointMake(0 - 3.55, 1.55) controlPoint2: CGPointMake(0 - 1.66, 0)];
    [bezierPath addLineToPoint: CGPointMake(0, 0)];
    [bezierPath closePath];
    
    return bezierPath;
}

- (void)drawRect:(CGRect)rect
{
    //// Color Declarations
    UIColor* fillColor = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    UIColor* fillColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
    
    //// Group 2
    {
        //// Oval Drawing
        UIBezierPath* ovalPath = [self getTagPoint];
        [fillColor setFill];
        [ovalPath fill];
        
        if (self.tagModel == SDDecorationTagLeft) {
            //// Bezier Drawing
            UIBezierPath* bezierPath = [self getLeftTagRoundPath];
            bezierPath.usesEvenOddFillRule = YES;
            [fillColor2 setFill];
            [bezierPath fill];
        }else{
            //// Bezier Drawing
            UIBezierPath* bezierPath = [self getTagRoundPath];
            bezierPath.usesEvenOddFillRule = YES;
            [fillColor2 setFill];
            [bezierPath fill];
        }
        
    }
}

@end
