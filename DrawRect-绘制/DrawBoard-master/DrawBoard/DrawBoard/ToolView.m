//
//  ToolView.m
//  DrawBoard
//
//  Created by 弄潮者 on 15/8/7.
//  Copyright (c) 2015年 弄潮者. All rights reserved.
//

#import "ToolView.h"

/**
 *  工具栏实现的基本思路:1、功能选择，颜色选择，线宽选择等，都是将不同选择的button添加到view上面，并且添加动作
                      2、为了更高效循环添加button，动作响应根据tag来判断是哪个button，从而做出不同的响应
                      3、功能选择动作响应：不同的button响应不同的block
                      4、颜色和线宽响应：不同的button响应后设置颜色/线宽
                      5、添加一个背景图片，当选择某一个button时，这个图片也会移动到该button上方（block来实现）
 */
#define Zwidth [UIScreen mainScreen].bounds.size.width
#define Zheight [UIScreen mainScreen].bounds.size.height

@implementation ToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _creatButtonView];
        [self _creatColorView];
        [self _creatWidthView];
    }
    return self;
}

//工具选择的实现
- (void)_creatButtonView {
    CGFloat buttonwWidth = Zwidth/5;
    CGFloat buttonHeight = 50;
    
    NSArray *nameArray = @[@"颜色",@"线宽",@"橡皮",@"撤销",@"清屏"];
    for (int i = 0; i < 5; i++) {
        CGRect frame = CGRectMake(i*buttonwWidth, 0, buttonwWidth, buttonHeight);
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button setTitle:nameArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor lightGrayColor];
        button.tag = i+100;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
//    选择动画的添加
    bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonwWidth, buttonHeight)];
    bgImageView.backgroundColor = [UIColor cyanColor];
    bgImageView.alpha = 0.3;
    [self addSubview:bgImageView];
}

//宽度选择视图的实现
- (void)_creatWidthView {
    widthView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, Zwidth, 70)];
    widthView.backgroundColor = [UIColor brownColor];
    [self addSubview:widthView];
    widthView.hidden = YES;
    
//    添加button
    CGFloat widthWidth = Zwidth/7;
    CGFloat widthHeight = 70;

    NSArray *widthArray = @[@"1点",@"3点",@"5点",@"8点",@"10点",@"15点",@"20点"];
    for (int i = 0; i < 7; i++) {
        CGRect frame = CGRectMake(i*widthWidth, 0, widthWidth, widthHeight);
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button setTitle:widthArray[i] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor lightGrayColor];
        button.tag = i+200;
        [button addTarget:self action:@selector(widthbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [widthView addSubview:button];
    }
    
//    选择动画的添加
    widthBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, widthWidth, widthHeight)];
    widthBgImageView.backgroundColor = [UIColor cyanColor];
    widthBgImageView.alpha = 0.3;
    [widthView addSubview:widthBgImageView];
}

- (void)_creatColorView {
    colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, Zwidth, 70)];
    colorView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:colorView];
    colorView.hidden = NO;
    
    CGFloat colorWidth = (Zwidth-45)/9;
    CGFloat colorHeight = 70;
    _colorDic = @{@"0" : [UIColor grayColor],    @"1" : [UIColor redColor],
                  @"2" : [UIColor greenColor],   @"3" : [UIColor blueColor],
                  @"4" : [UIColor yellowColor],  @"5" : [UIColor orangeColor],
                  @"6" : [UIColor purpleColor],  @"7" : [UIColor brownColor],
                  @"8" : [UIColor blackColor]};
    for (int i = 0; i < 9; i++) {
        NSString *str = [NSString stringWithFormat:@"%i",i];
        UIColor *color = _colorDic[str];
        
        CGRect frame = CGRectMake(i*(colorWidth+5), 0, colorWidth, colorHeight);
        UIButton *colorBtn = [[UIButton alloc] initWithFrame:frame];
        colorBtn.backgroundColor = color;
        colorBtn.tag = 300+i;
        [colorBtn addTarget:self  action:@selector(colorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [colorView addSubview:colorBtn];
    }
    
    colorBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, colorWidth, colorHeight)];
    colorBgImageView.backgroundColor = [UIColor cyanColor];
    colorBgImageView.alpha = 0.2;
    [colorView addSubview:colorBgImageView];
}

//工具栏选择按钮Action实现
- (void)buttonAction:(UIButton *)btn{
    if (btn.tag == 100) {
        colorView.hidden = NO;
        widthView.hidden = YES;
    }else if (btn.tag == 101) {
        colorView.hidden = YES;
        widthView.hidden = NO;
    }else if (btn.tag == 103){
        if (self.undoBlock) {
            self.undoBlock();
        }
    }else if (btn.tag == 104) {
        if (self.clearBlock) {
            self.clearBlock();
        }
    }else {
        if (self.eraserBlock) {
            self.eraserBlock();
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        bgImageView.center = btn.center;
    }];    
}

//线宽选择按钮Action实现
- (void)widthbuttonAction:(UIButton *)btn {
    if (btn.tag <= 202 ) {
        if (_widthBlock) {
            _widthBlock((btn.tag-200)*2+1);
        }
    }else if(btn.tag <= 205) {
        if (_widthBlock) {
            _widthBlock(btn.tag-195);
        }
    }else {
        if (_widthBlock) {
            _widthBlock(btn.tag*5-1015);
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        widthBgImageView.center = btn.center;
    }];
}

//颜色选择按钮Action的实现
- (void)colorButtonAction:(UIButton *)btn {
    NSInteger i = btn.tag-300;
    NSString *str = [NSString stringWithFormat:@"%li",i];
    if (_colorBlock) {
        _colorBlock(_colorDic[str]);
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        colorBgImageView.center = btn.center;
    }];
}

@end
