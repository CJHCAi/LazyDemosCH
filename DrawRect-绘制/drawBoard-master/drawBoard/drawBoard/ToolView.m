//
//  ToolView.m
//  drawBoard
//
//  Created by hyrMac on 15/8/7.
//  Copyright (c) 2015年 hyrMac. All rights reserved.
//

#import "ToolView.h"

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@implementation ToolView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        _colorArray = @[[UIColor grayColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor],[UIColor blackColor]];
        _lineArray = @[@1,@5,@10,@15,@20,@25];
        
        [self _createSelFunc];
        [self _createColorView];
        [self _createLineWidthView];
    }
    return self;
}


- (void)_createSelFunc {
    

    NSArray *titleArray = @[@"颜色",@"线宽",@"橡皮",@"撤销",@"清屏"];
    
    _funcView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 50)];
    _funcView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_funcView];
    
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/5*i,0,kWidth/5,50)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 100+i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_funcView addSubview:btn];
    }
    
    
}

- (void)_createColorView {
    _colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kWidth, 60)];
    _colorView.backgroundColor = [UIColor clearColor];
    [self addSubview:_colorView];
    
    for (NSInteger i = 0; i < _colorArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/_colorArray.count*i,0,kWidth/_colorArray.count-5,60)];
        btn.tag = 100+i;
        btn.backgroundColor = _colorArray[i];
        [btn addTarget:self action:@selector(colorAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_colorView addSubview:btn];
    }
    
}

- (void)_createLineWidthView {
    
    _lineWidthView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, kWidth, 60)];
    _lineWidthView.backgroundColor = [UIColor clearColor];
    _lineWidthView.hidden = YES;
    [self addSubview:_lineWidthView];
    
    for (NSInteger i = 0; i < _lineArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth/_lineArray.count*i,0,kWidth/_lineArray.count,60)];
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor blackColor];
        float width = [_lineArray[i] floatValue];
        [btn setTitle:[NSString stringWithFormat:@"%.0f点",width] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(lineWidthAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_lineWidthView addSubview:btn];
    }
}




- (void)btnAction:(UIButton *)btn {
    switch (btn.tag) {
        case 100:
            _lineWidthView.hidden = YES;
            _colorView.hidden = NO;
            
            break;
        case 101:
            _colorView.hidden = YES;
            _lineWidthView.hidden = NO;
            break;
        case 102:
            if (_eraserBlock) {
                _eraserBlock();
            }
            break;
        case 103:
            if (_backBlock) {
                _backBlock();
            }
            
            break;
        case 104:
            if (_clearBlock) {
                _clearBlock();
            }
            
            break;
        default:
            break;
    }
}

- (void)colorAction:(UIButton *)btn {
    UIColor *color = _colorArray[btn.tag-100];
    NSLog(@"%@",color);
    if (_colorBlock) {
        _colorBlock(color);
    }

}

- (void)lineWidthAction:(UIButton *)btn {
    
    if (_widthBlock) {
        _widthBlock([_lineArray[btn.tag-100] floatValue]);
    }
}



@end
