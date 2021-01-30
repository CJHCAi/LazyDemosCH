//
//  FloatingBallHeader.m
//  FloatingBall
//
//  Created by CygMac on 2018/6/7.
//  Copyright © 2018年 XunKu. All rights reserved.
//

#import "FloatingBallHeader.h"
#import "PaopaoButton.h"
#import <RBBAnimation/RBBTweenAnimation.h>

// 最多显示泡泡的数量
static NSInteger const PaopaoMaxNum = 10;

@interface FloatingBallHeader ()

// 背景图
@property (nonatomic, strong) UIImageView *bgIcon;
// 泡泡button，固定十个，隐藏显示控制
@property (nonatomic, strong) NSArray <PaopaoButton *> *paopaoBtnArray;
// 当前显示的泡泡数据
@property (nonatomic, strong) NSMutableArray *showDatas;
// x最多可选取的随机数值因数
@property (nonatomic, strong) NSMutableArray <NSNumber *> *xFactors;
// y最多可选取的随机数值因数
@property (nonatomic, strong) NSMutableArray <NSNumber *> *yFactors;

@end

@implementation FloatingBallHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 初始化数组
        self.showDatas = [NSMutableArray arrayWithCapacity:PaopaoMaxNum];
        
        // 布局
        [self addSubview:self.bgIcon];
        self.bgIcon.frame = frame;
        
        for (UIButton *paopao in self.paopaoBtnArray) {
            paopao.frame = CGRectMake(0, 0, 60, 60);
            [self addSubview:paopao];
        }
    }
    return self;
}

- (void)setDataList:(NSArray *)dataList {
    _dataList = dataList;
    for (NSInteger i = 0; i < dataList.count; i++) {
        if (self.showDatas.count == PaopaoMaxNum) {
            return;
        }
        PaopaoButton *paopao = self.paopaoBtnArray[i];
        paopao.tag = i;
        paopao.hidden = NO;
        [paopao setTitle:dataList[i]];
        CGPoint randomPoint = [self getRandomPoint];
        paopao.center = randomPoint;
        [self addFloatAnimationWithPaopao:paopao];
        [self.showDatas addObject:dataList[i]];
    }
}

#pragma mark - 泡泡加动画

- (void)addFloatAnimationWithPaopao:(PaopaoButton *)paopao {
    RBBTweenAnimation *sinus = [RBBTweenAnimation animationWithKeyPath:@"position.y"];
    sinus.fromValue = @(0);
    sinus.toValue = @(3);
    sinus.easing = ^CGFloat (CGFloat fraction) {
        return sin((fraction) * 2 * M_PI);
    };
    sinus.additive = YES;
    sinus.duration = [self getRandomNumber:3 to:5];
    sinus.repeatCount = HUGE_VALF;
    [paopao.layer addAnimation:sinus forKey:@"sinus"];
}

// 重置动画，因为页面disappear会将layer动画移除
- (void)resetAnimation {
    for (NSInteger i = 0; i < self.showDatas.count; i++) {
        PaopaoButton *paopao = self.paopaoBtnArray[i];
        [self addFloatAnimationWithPaopao:paopao];
    }
}

// 移除所有泡泡
- (void)removeAllPaopao {
    for (PaopaoButton *paopao in self.paopaoBtnArray) {
        paopao.hidden = YES;
    }
    [self.showDatas removeAllObjects];
}

#pragma mark - 获取随机点坐标

- (CGPoint)getRandomPoint {
    CGFloat x = [self getRandomX];
    CGFloat y = [self getRandomY];
    return CGPointMake(x, y);
}

- (CGFloat)getRandomX {
    NSInteger index = arc4random() % self.xFactors.count;
    CGFloat factor = self.xFactors[index].floatValue;
    CGFloat x = 33 + (self.frame.size.width - 60) * factor;
    [self.xFactors removeObjectAtIndex:index];
    return x;
}

- (CGFloat)getRandomY {
    NSInteger index = arc4random() % self.yFactors.count;
    CGFloat factor = self.yFactors[index].floatValue;
    CGFloat y = 130 + (FloatingBallHeaderHeight - 130 - 160) * factor;
    [self.yFactors removeObjectAtIndex:index];
    return y;
}

/*
 - (CGPoint)getRandomPoint {
 CGFloat x = [self getRandomNumber:50 to:SCREEN_WIDTH - 50];
 CGFloat y = [self getRandomNumber:130 to:HomeHeaderBgIconHeight - 160];
 return CGPointMake(x, y);
 }
 */
- (int)getRandomNumber:(int)from to:(int)to {
    return (int)(from + (arc4random() % (to - from + 1)));
}


#pragma mark - 泡泡点击

- (void)paopaoClick:(PaopaoButton *)sender {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        sender.frame = CGRectMake(sender.frame.origin.x, -70, sender.frame.size.width, sender.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            sender.hidden = YES;
            NSInteger num = 0;
            for (NSInteger i = 0; i < self.paopaoBtnArray.count; i++) {
                PaopaoButton *paopao = self.paopaoBtnArray[i];
                if (paopao.isHidden) {
                    num++;
                }
            }
            if (num == PaopaoMaxNum) {
                [self.showDatas removeAllObjects];
                self.xFactors = nil;
                self.yFactors = nil;
            }
            if ([self.delegate respondsToSelector:@selector(floatingBallHeader:didPappaoAtIndex:isLastOne:)]) {
                [self.delegate floatingBallHeader:self didPappaoAtIndex:sender.tag isLastOne:num == PaopaoMaxNum];
            }
        }
    }];
}

#pragma mark - Get

- (UIImageView *)bgIcon {
    if (!_bgIcon) {
        _bgIcon = [[UIImageView alloc] init];
        _bgIcon.contentMode = UIViewContentModeScaleAspectFill;
        _bgIcon.clipsToBounds = YES;
        _bgIcon.image = [UIImage imageNamed:@"BG_home_default"];
    }
    return _bgIcon;
}



- (NSArray<PaopaoButton *> *)paopaoBtnArray {
    if (!_paopaoBtnArray) {
        NSMutableArray *marr = [NSMutableArray arrayWithCapacity:PaopaoMaxNum];
        for (NSInteger i = 0; i < PaopaoMaxNum; i++) {
            PaopaoButton *button = [[PaopaoButton alloc] init];
            [button setPaopaoImage:[UIImage imageNamed:@"ic_float_paopao"]];
            button.hidden = YES;
            [button addTarget:self action:@selector(paopaoClick:) forControlEvents:UIControlEventTouchUpInside];
            [marr addObject:button];
        }
        _paopaoBtnArray = marr;
    }
    return _paopaoBtnArray;
}

- (NSMutableArray<NSNumber *> *)xFactors {
    if (!_xFactors) {
        _xFactors = [NSMutableArray arrayWithArray:@[@(0.00f), @(0.11f), @(0.22f), @(0.33f), @(0.44f), @(0.55f), @(0.66f), @(0.77f), @(0.88f), @(0.99)]];
    }
    return _xFactors;
}

- (NSMutableArray<NSNumber *> *)yFactors {
    if (!_yFactors) {
        _yFactors = [NSMutableArray arrayWithArray:@[@(0.00f), @(0.11f), @(0.22f), @(0.33f), @(0.44f), @(0.55f), @(0.66f), @(0.77f), @(0.88f), @(0.99)]];
    }
    return _yFactors;
}

@end
