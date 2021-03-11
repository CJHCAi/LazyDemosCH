//
//  SheetView.m
//  75AG驾校助手
//
//  Created by again on 16/4/9.
//  Copyright © 2016年 again. All rights reserved.
//

#import "SheetView.h"

@interface SheetView()
@property (strong,nonatomic) UIView *superView;
@property (nonatomic, assign) BOOL startMoving;
@property (assign,nonatomic) float hight;
@property (assign,nonatomic) float width;
@property (assign,nonatomic) float y;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (assign,nonatomic) int count;
@end

@implementation SheetView
- (instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView andQuestion:(int)count
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.hight = frame.size.height;
        self.width = frame.size.width;
        self.y = frame.origin.y;
//        NSLog(@"%f", self.y);
        self.superView = superView;
        self.count = count;
        [self createView];
    }
    return self;
}

- (void)createView{
    _backView = [[UIView alloc] initWithFrame:_superView.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0;
    [self.superView addSubview:_backView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, self.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.alpha = 0.8;
    [self addSubview:self.scrollView];
    
    for (int i = 0; i<self.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake((self.width -45*6)/2+45*(i%6), 10+44*(i/6), 40, 40);
        btn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        if (i==0) {
            btn.backgroundColor = [UIColor orangeColor];
        }
        [btn setTitle:[NSString stringWithFormat:@"%d", i+1] forState:UIControlStateNormal];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 8;
        btn.tag = 101 + i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
    }
    int tip = (self.count%6)?1:0;
    self.scrollView.contentSize = CGSizeMake(0, 50+44*(self.count/6+1+tip));
}

- (void)click:(UIButton *)btn{
    int index = (int)btn.tag -100;
    for (int i =0; i<self.count-1; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+101];
        if (i!=index -1) {
            button.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        } else {
            button.backgroundColor = [UIColor orangeColor];
        }
    }
    [self.delegate SheetViewClick:index];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    if (point.y<25) {
        _startMoving = YES;
    }
    if (_startMoving&&self.frame.origin.y>=_y-_hight&&[self convertPoint:point toView:_superView].y>=150) {
        self.frame = CGRectMake(0, [self convertPoint:point toView:_superView].y, _width, _hight);
        float offset = (_superView.frame.size.height - self.frame.origin.y)/_superView.frame.size.height *0.5;
        _backView.alpha = offset;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _startMoving = NO;
    if (self.frame.origin.y>_y-_hight/2) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, _y, _width, self.hight);
            _backView.alpha = 0;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 150, _width, _hight);
//            NSLog(@"%f", _hight);
            _backView.alpha = 0.5;
        }];
    }
}

@end
