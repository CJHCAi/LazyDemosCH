//
//  YLColorSlider.m
//  YLColorSlider
//
//  Created by wlx on 17/3/29.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import "YLColorSlider.h"
#define kcolor_count 10
@implementation YLColorSlider
{
    UIView *_baseView;
    UIView *_sliderBar;
    NSInteger _colorIndex;
    UIColor *_selectColor;
    NSArray *_colors;
    void(^_colorBlock)(UIColor *color);
}

- (instancetype)initWithFrame:(CGRect)frame selectedColorBlock:(void(^)(UIColor *color))colorBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        _colorBlock = [colorBlock copy];
        [self setUpUI];
    }
    return self;
}
-(void)setUpUI
{
    _colors = @[[UIColor redColor],
                [UIColor purpleColor],
                [UIColor brownColor],
                [UIColor orangeColor],
                [UIColor magentaColor],
                [UIColor yellowColor],
                [UIColor cyanColor],
                [UIColor blueColor],
                [UIColor greenColor],
                [UIColor grayColor]];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = self.frame.size.height;
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, h*0.25, w, h*0.5)];
    [self addSubview:_baseView];
    CGFloat aw = 1.0*w/kcolor_count;
    UIView *lastView = nil;
    _sliderBar = [[UIView alloc] init];
    CGPoint center = CGPointMake(aw/2.0, _baseView.center.y);
    _sliderBar.center = center;
    [self addSubview:_sliderBar];
    _sliderBar.backgroundColor = [UIColor redColor];
    _sliderBar.bounds = CGRectMake(0, 0, aw, h);
    _sliderBar.layer.cornerRadius = 5;
    _sliderBar.layer.masksToBounds = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [_sliderBar addGestureRecognizer:pan];
    for (int i = 0; i < kcolor_count; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(lastView ? CGRectGetMaxX(lastView.frame) : 0, 0, aw, h*0.5)];
        view.backgroundColor = _colors[i];
        [_baseView addSubview:view];
        lastView = view;
    }
}
-(void)pan:(UIPanGestureRecognizer*)gr
{
    CGFloat w = self.frame.size.width;
    CGFloat aw = 1.0*w/kcolor_count;
    switch (gr.state) {
        case UIGestureRecognizerStateBegan:
        {
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint offset = [gr locationInView:self];
            if (offset.x < w - aw && offset.x >= 0) {
                _sliderBar.frame = CGRectMake(offset.x, _sliderBar.frame.origin.y, _sliderBar.frame.size.width, _sliderBar.frame.size.height);
            }
            int i = offset.x/aw;
            if (i >= 0 && i < kcolor_count)
            {
                _sliderBar.backgroundColor = _colors[i];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint offset = [gr locationInView:self];
            int i = offset.x/aw;
            if (i >= 0 && i < kcolor_count) {
                [UIView animateWithDuration:0.2 animations:^{
                    _sliderBar.frame = CGRectMake(aw * i, _sliderBar.frame.origin.y, _sliderBar.frame.size.width, _sliderBar.frame.size.height);
                }];
                _colorIndex = i;
                _selectColor = _colors[i];
                    NSLog(@"选中——color：%zd", _colorIndex);
                if (_colorBlock) {
                    _colorBlock(_selectColor);
                }
            }
        }
            break;
        default:
            break;
    }
    
}

@end
