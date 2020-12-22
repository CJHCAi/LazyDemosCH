//
//  MyCardsView.m
//  card
//
//  Created by tmachc on 15/9/14.
//  Copyright (c) 2015年 tmachc. All rights reserved.
//

#import "MyCardsView.h"
#import "CardView.h"
#import "Masonry.h"

@interface MyCardsView ()

@property (nonatomic, assign) int beginNum;
@property (nonatomic, assign) int endNum;

@end

@implementation MyCardsView

+ (void)load
{
    NSLog(@"load");
}

#pragma mark - touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.beginNum = -1;
    self.endNum = -1;
    UITouch *touch = [touches anyObject];
    CGPoint point;
    for (int i = 0; i < self.subviews.count; i ++) {
        point = [touch locationInView:self.subviews[i]];
        if (point.x > 0 && point.x < 30) {
            self.beginNum = i;
            self.endNum = i;
            return;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endSelectNum:[touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endSelectNum:[touches anyObject]];
    [self endSelect];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (CardView *view in self.subviews) {
        view.selected = false;
    }
    [self endSelect];
}

#pragma mark - function

- (void)endSelectNum:(UITouch *)touch
{
    CGPoint point;
    for (int i = 0; i < self.subviews.count; i ++) {
        point = [touch locationInView:self.subviews[i]];
        if (point.x > 0 && point.x < 30 && point.y > 0 && point.y < self.frame.size.height) {
            self.endNum = i;
            break;
        }
    }
    
    for (int i = 0; i < self.subviews.count; i ++) {
        if ((i >= self.beginNum && i <= self.endNum) || (i <= self.beginNum && i >= self.endNum)) {
            ((CardView *)self.subviews[i]).grayBackgroud = YES;
        }
        else {
            ((CardView *)self.subviews[i]).grayBackgroud = NO;
        }
        
    }
}

- (void)selectCard:(UITouch *)touch
{
    CGPoint point;
    for (CardView *view in self.subviews) {
        point = [touch locationInView:view];
        if (point.x > 0 && point.x < 30) {
            view.selected = !view.isSelected;
        }
    }
}

- (void)endSelect
{
    for (CardView *view in self.subviews) {
        if (view.isGrayBackgroud) {
            view.grayBackgroud = false;
            view.selected = !view.isSelected;
            [view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(view.isSelected ? -10 : 0);
            }];
        }
    }
}

@end
