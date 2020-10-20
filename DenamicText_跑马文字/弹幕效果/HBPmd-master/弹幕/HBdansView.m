//
//  HBdansView.m
//  弹幕
//
//  Created by 伍宏彬 on 15/10/14.
//  Copyright (c) 2015年 伍宏彬. All rights reserved.
//

#import "HBdansView.h"
#import "HBdansLable.h"

@interface HBdansView()<HBdansLableDelegate>

@property (nonatomic, strong) NSMutableSet *randomSet;

@property (nonatomic, strong) NSMutableArray *randomMutableArray;

@end

@implementation HBdansView

#define defaultH 25

- (instancetype)initDansViewFrame:(CGRect)frame contents:(NSMutableArray *)contents
{
    self = [super initWithFrame:frame];
    if (self) {
        self.randomMutableArray = contents;
        [self setInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setInit];
    }
    return self;
}
#pragma mark - initIvar
- (void)setInit
{
    self.textBackColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.countInScreen = 1;
    self.clipsToBounds = YES;
    
}
- (void)starDans
{
    if (!self.randomMutableArray.count) return;
    [self addRandomText:[self.randomMutableArray firstObject]];
    [self.randomMutableArray removeObjectAtIndex:0];
}

- (void)addRandomText:(NSString *)randomText
{
    if (randomText.length){
        
        if (![self dequeRandomLable:randomText]) {
            
            [self.randomMutableArray addObject:randomText];
            
        }
    }
}
#pragma mark - CustomMethod
- (HBdansLable *)dequeRandomLable:(NSString *)text
{
    HBdansLable *randomLable = [self.randomSet anyObject];
    
    if (!randomLable) return nil;
    
    [self setRandomStyle:randomLable];
    
    [self addSubview:randomLable];
    
    [self.randomSet removeObject:randomLable];
        
    randomLable.text = text;
        
    return randomLable;
}
- (void)setRandomStyle:(HBdansLable *)lable
{
    lable.layer.cornerRadius = self.roundVaule;
    lable.layer.borderColor = self.lineColor.CGColor;
    lable.layer.borderWidth = self.lineWidth;
    lable.backgroundColor = self.textBackColor;
    lable.textColor = self.textColor;
}
- (CGRect)randomFrame
{
    
    CGFloat randomW = 10;
    CGFloat randomH = defaultH;
    CGFloat randomX = CGRectGetMaxX(self.frame);
    CGFloat randomY = 0;
    
    return CGRectMake(randomX, randomY, randomW, randomH);
}
#pragma mark - HBdansLableDelegate
- (void)dansLable:(HBdansLable *)dansLable isOutScreen:(BOOL)isOutScreen
{
    if (isOutScreen) {
        
        dansLable.x = CGRectGetMaxX(self.frame);
        
        [dansLable removeFromSuperview];
        [self.randomSet addObject:dansLable];
        
        if (self.randomMutableArray.count){
            
            [self dequeRandomLable:[self.randomMutableArray firstObject]];
            [self.randomMutableArray removeObjectAtIndex:0];
            
        }
    }
}
#pragma mark - getter
- (NSMutableArray *)randomMutableArray
{
    if (!_randomMutableArray) {
        _randomMutableArray = [NSMutableArray array];
    }
    return _randomMutableArray;
}
- (NSMutableSet *)randomSet
{
    if (!_randomSet) {
        
        _randomSet = [NSMutableSet set];
        
    }
    return _randomSet;
}
- (void)setCountInScreen:(NSInteger)countInScreen
{
    _countInScreen = countInScreen;
    
    if (self.randomSet.count) [self.randomSet removeAllObjects];
    //    随机
    if (_countInScreen > 10) _countInScreen = 10;
    CGFloat margin = (self.height - _countInScreen * defaultH) / (_countInScreen + 1);
    for (NSInteger i = 0; i < _countInScreen; i++) {
        HBdansLable *randomLable = [HBdansLable dansLableFrame:[self randomFrame]];
        randomLable.y = i * (margin + defaultH) + margin;
        randomLable.delegate = self;
        randomLable.layer.masksToBounds = YES;
        
        [self.randomSet addObject:randomLable];
        
    }
    
}
@end
