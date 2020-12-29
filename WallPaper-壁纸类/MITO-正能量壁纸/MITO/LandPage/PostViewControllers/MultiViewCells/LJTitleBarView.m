//
//  LJTitleBarView.m
//  FitnessHelper
//
//  Created by 成都千锋 on 15/10/29.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import "LJTitleBarView.h"

#define BUTTON_WIDTH 60
#define BUTTON_BEGIN_TAG 100

@implementation LJTitleBarView{
    NSArray *_titlesArray;//保存标题数组
    NSMutableArray *_titleButtonArray;//保存按钮
    NSInteger _currentButton;//当前按钮
}

- (instancetype)initWithFrame:(CGRect)frame addTitles:(NSArray *)titles {
    if (self = [super initWithFrame:frame]) {
        _titlesArray = titles;
        [self setupUI];
    }
    return self;
}

//创建UI
- (void) setupUI {
    
    _titleButtonArray = [NSMutableArray array];
    //根据button的个数计算scrollSize
    CGSize scrollSize = CGSizeMake((BUTTON_WIDTH *_titlesArray.count > self.frame.size.width) ? BUTTON_WIDTH * _titlesArray.count : self.frame.size.width , self.frame.size.height);
    self.contentSize = scrollSize;
    CGFloat buttonHeight = self.frame.size.height;
    CGFloat buttonWidth = (BUTTON_WIDTH *_titlesArray.count > self.frame.size.width)? BUTTON_WIDTH : self.frame.size.width / _titlesArray.count;
    for (int i = 0; i < _titlesArray.count; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * buttonWidth, 0, buttonWidth, buttonHeight);
        [button setTitle:_titlesArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(scrollButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = BUTTON_BEGIN_TAG + i;
        [self addSubview:button];
        [_titleButtonArray addObject:button];
    }
    _currentButton = BUTTON_BEGIN_TAG;
    UIButton *button = _titleButtonArray[_currentButton - BUTTON_BEGIN_TAG];
    button.selected = YES;
    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
}

- (void) scrollButtonClicked:(UIButton *)sender {
    if (_currentButton != sender.tag) {
        sender.transform = CGAffineTransformMakeScale(1.2, 1.2);
        sender.selected = YES;
        UIButton *button = _titleButtonArray[_currentButton - BUTTON_BEGIN_TAG];
        button.selected = NO;
        button.transform = CGAffineTransformIdentity;
        
    }
    //显示没有显示完的按钮
    if (fabs( sender.frame.origin.x - (self.contentSize.width - BUTTON_WIDTH)) > BUTTON_WIDTH && _currentButton < sender.tag) {
        if (self.frame.size.width - sender.frame.origin.x <   BUTTON_WIDTH * 2) {
            CGPoint point = CGPointMake(self.contentOffset.x +BUTTON_WIDTH, 0);
            [UIView animateWithDuration:0.5 animations:^{
                self.contentOffset = point ;
            }];
        }
    }else if(_currentButton > sender.tag && self.contentOffset.x != 0){
        CGPoint point = CGPointMake(self.contentOffset.x -BUTTON_WIDTH, 0);
        [UIView animateWithDuration:0.5 animations:^{
            self.contentOffset = point ;
        }];
    }
    _currentButton = sender.tag;
    if (self.block) {
        self.block(_currentButton - BUTTON_BEGIN_TAG);
    }
}


- (void)scrollViewIndex:(NSInteger)index {
    UIButton *button = (UIButton *)[self viewWithTag:index + BUTTON_BEGIN_TAG];
    if (button) {
        [self scrollButtonClicked:button];
    }
}


@end
