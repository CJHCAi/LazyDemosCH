//
//  TreeView.m
//  仿支付宝蚂蚁森林
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import "TreeView.h"

#import "Config.h"

@interface TreeView ()

@property (nonatomic, strong) NSMutableArray <NSValue *> *centerPointArr;

@property (nonatomic, strong) NSMutableArray <UIButton *> *randomBtnArr;

@property (nonatomic, strong) NSMutableArray <UIButton *> *randomBtnArrX;

@property (nonatomic, strong) NSMutableArray <UIButton *> *timeLimitedBtnArr;

@property (nonatomic, strong) NSMutableArray <UIButton *> *unlimitedBtnArr;

@end

@implementation TreeView

static NSInteger const kTimeLimitedBtnTag = 20000;
static NSInteger const kUnlimitedBtnTag = 30000;

static CGFloat const kMargin = 10.0;
static CGFloat const kBtnDiameter = 60.0;
static CGFloat const kBtnMinX = kBtnDiameter * 0.5 + 0;
static CGFloat const kBtnMinY = 0.0;


#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"healthTree_header_bg"];
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

- (void)dealloc
{
    
}


#pragma mark - setter

- (void)setTimeLimitedArr:(NSArray<NSString *> *)timeLimitedArr
{
    _timeLimitedArr = timeLimitedArr;
    
    for (int i = 0; i < timeLimitedArr.count; i ++) {
        [self createRandomBtnWithType:FruitTypeTimeLimited andText:timeLimitedArr[i]];
    }
}

- (void)setUnimitedArr:(NSArray<NSString *> *)unimitedArr
{
    _unimitedArr = unimitedArr;

    for (int i = 0; i < unimitedArr.count; i ++) {
        [self createRandomBtnWithType:FruitTypeUnlimited andText:unimitedArr[i]];
    }
}


#pragma mark - getter

- (NSMutableArray <NSValue *> *)centerPointArr
{
    if (_centerPointArr == nil) {
        _centerPointArr = [NSMutableArray array];
    }
    return _centerPointArr;
}

- (NSMutableArray<UIButton *> *)randomBtnArr
{
    if (_randomBtnArr == nil) {
        _randomBtnArr = [NSMutableArray array];
    }
    return _randomBtnArr;
}

- (NSMutableArray<UIButton *> *)randomBtnArrX
{
    if (_randomBtnArrX == nil) {
        _randomBtnArrX = [NSMutableArray array];
    }
    return _randomBtnArrX;
}

- (NSMutableArray<UIButton *> *)timeLimitedBtnArr
{
    if (_timeLimitedBtnArr == nil) {
        _timeLimitedBtnArr = [NSMutableArray array];
    }
    return _timeLimitedBtnArr;
}

//- (NSMutableArray<UIButton *> *)unlimitedBtnArr
//{
//    if (_unlimitedBtnArr == nil) {
//        _unlimitedBtnArr = [NSMutableArray array];
//    }
//    return _unlimitedBtnArr;
//}


#pragma mark - 随机数

- (NSInteger)getRandomNumber:(CGFloat)from to:(CGFloat)to
{
    return (NSInteger)(from + (arc4random() % ((NSInteger)to - (NSInteger)from + 1)));
}


#pragma mark - 随机按钮

- (void)createRandomBtnWithType:(FruitType)fruitType andText:(NSString *)textString
{
    CGFloat minY = WZC_ScaleHeight(120);
    CGFloat maxY = WZC_ScaleHeight(300);
    CGFloat minX = WZC_ScaleWidth(80);
    CGFloat maxX = WZC_ScaleWidth(300);
    
    CGFloat x = [self getRandomNumber:minX to:maxX];
    CGFloat y = [self getRandomNumber:minY to:maxY];
    
    BOOL success = YES;
    for (int i = 0; i < self.centerPointArr.count; i ++) {
        NSValue *pointValue = self.centerPointArr[i];
        CGPoint point = [pointValue CGPointValue];
        //如果是圆 /^2 如果不是圆 不用/^2
        if (sqrt(pow(point.x - x, 2) + pow(point.y - y, 2)) <= kBtnDiameter + kMargin) {
            success = NO;
            [self createRandomBtnWithType:fruitType andText:textString];
            return;
        }
    }
    if (success == YES) {
        NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [self.centerPointArr addObject:pointValue];
        
        UIButton *randomBtn = [UIButton buttonWithType:0];
        randomBtn.bounds = CGRectMake(0, 0, kBtnDiameter, kBtnDiameter);
        randomBtn.center = CGPointMake(x, y);
        [randomBtn setTitleColor:[UIColor whiteColor] forState:0];
        [self addSubview:randomBtn];
        [randomBtn addTarget:self action:@selector(randomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.randomBtnArr addObject:randomBtn];
        [self.randomBtnArrX addObject:randomBtn];
       
        //区分
        if (fruitType == FruitTypeTimeLimited) {
            randomBtn.tag = kUnlimitedBtnTag + self.centerPointArr.count - 1;
            [self.timeLimitedBtnArr addObject:randomBtn];
            [randomBtn setBackgroundImage:[UIImage imageNamed:@"pingguo"] forState:0];
        } else if (fruitType == FruitTypeUnlimited) {
            randomBtn.tag = kTimeLimitedBtnTag + self.centerPointArr.count - 1;
            [self.unlimitedBtnArr addObject:randomBtn];
            [randomBtn setBackgroundImage:[UIImage imageNamed:@"chengzi"] forState:0];
        }
        [randomBtn setTitle:textString forState:0];
        
        [self animationScaleOnceWithView:randomBtn];
        [self animationUpDownWithView:randomBtn];
    }
}


#pragma mark - 随机按钮被点击

- (void)randomBtnClick:(UIButton *)randomBtn
{
    [UIView animateWithDuration:0.1 animations:^{
        randomBtn.transform = CGAffineTransformMakeScale(1.15, 1.15);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            randomBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            if (randomBtn.tag >= kUnlimitedBtnTag) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(selectTimeLimitedBtnAtIndex:)]) {
                    [self.delegate selectTimeLimitedBtnAtIndex:randomBtn.tag - kUnlimitedBtnTag];
                }
            } else if (randomBtn.tag >= kTimeLimitedBtnTag) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(selectUnlimitedBtnAtIndex:)]) {
                    [self.delegate selectUnlimitedBtnAtIndex:randomBtn.tag - kTimeLimitedBtnTag];
                }
            }
        }];
    }];
}


#pragma mark - 移除随机按钮

- (void)removeRandomIndex:(NSInteger)index
{
    UIButton *randomBtn = self.randomBtnArr[index];
    
    [UIView animateWithDuration:0.1 animations:^{
        randomBtn.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [randomBtn removeFromSuperview];
        [self.randomBtnArrX removeObject:randomBtn];
        if ([self.timeLimitedBtnArr containsObject:randomBtn]) {
            [self.timeLimitedBtnArr removeObject:randomBtn];
        } else if ([self.unlimitedBtnArr containsObject:randomBtn]) {
            [self.unlimitedBtnArr removeObject:randomBtn];
        }
        if (self.timeLimitedBtnArr.count == 0 && self.unlimitedBtnArr.count == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(allCollected)]) {
                [self.delegate allCollected];
            }
        }
    }];
}

- (void)removeAllRandomBtn
{
    for (int i = 0; i < self.randomBtnArr.count; i ++) {
        UIButton *randomBtn = self.randomBtnArr[i];
        [randomBtn removeFromSuperview];
    }
    self.unlimitedBtnArr = [NSMutableArray array];
    self.timeLimitedBtnArr = [NSMutableArray array];
    self.randomBtnArr = [NSMutableArray array];
    self.randomBtnArrX = [NSMutableArray array];
    self.centerPointArr = [NSMutableArray array];
}


#pragma mark - 动画

- (void)animationScaleOnceWithView:(UIView *)view
{
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)animationUpDownWithView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint fromPoint = CGPointMake(position.x, position.y);
    CGPoint toPoint = CGPointZero;
    
    uint32_t typeInt = arc4random() % 100;
    CGFloat distanceFloat = 0.0;
    while (distanceFloat == 0) {
        distanceFloat = (6 + (int)(arc4random() % (9 - 7 + 1))) * 100.0 / 101.0;
    }
    if (typeInt % 2 == 0) {
        toPoint = CGPointMake(position.x, position.y - distanceFloat);
    } else {
        toPoint = CGPointMake(position.x, position.y + distanceFloat);
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.autoreverses = YES;
    CGFloat durationFloat = 0.0;
    while (durationFloat == 0.0) {
        durationFloat = 0.9 + (int)(arc4random() % (100 - 70 + 1)) / 31.0;
    }
    [animation setDuration:durationFloat];
    [animation setRepeatCount:MAXFLOAT];

    [viewLayer addAnimation:animation forKey:nil];
}

@end
