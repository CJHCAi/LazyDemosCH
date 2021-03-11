//
//  SheetView.m
//  DriverAssistant
//
//  Created by C on 16/3/31.
//  Copyright © 2016年 C. All rights reserved.
//

#import "SheetView.h"

@interface SheetView() {
    UIView *_superView;
    BOOL _startMoving;
    float _height;
    float _width;
    float _y;
    int _count;
    UIScrollView *_scrollView;


}
@end
@implementation SheetView

- (instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView andQuestionCount:(int)count
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _height = frame.size.height;
        _width = frame.size.width;
        _y = frame.origin.y;
        _superView = superView;
        _count = count;
        [self creatView];
    }
    return self;
}
- (void)creatView
{
    [self creatBackView];
    [self creatTopView];
    [self creatButtonView];

}

#pragma mark - 创建sheetView
/**
 创建背景视图
 */
- (void)creatBackView
{
    _backView = [[UIView alloc] initWithFrame:_superView.frame];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0;
    [_superView addSubview:_backView];
}
/**
 创建头部视图
 */
- (void)creatTopView
{
    CGFloat marginTop = 5;
    CGFloat lineLabelW = 80;
    CGFloat lineLabelH = 8;
    for (int i = 0; i<2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(_width/2-lineLabelW/2, marginTop+(marginTop+lineLabelH)*i, lineLabelW, lineLabelH)];
        lineView.backgroundColor = [UIColor grayColor];
        lineView.layer.cornerRadius = lineLabelH/2;
        lineView.layer.masksToBounds = YES;
        [self addSubview:lineView];
    }

    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 36, 40, 21)];
    label1.text = @"答对";
    [self addSubview:label1];
    UILabel *rightNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 36, 40, 21)];
    rightNumLabel.text = @"0";
    rightNumLabel.textColor = [UIColor greenColor];
    rightNumLabel.tag = 601;
    [self addSubview:rightNumLabel];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(95, 36, 40, 21)];
    label2.text = @"答错";
    [self addSubview:label2];
    UILabel *wrongNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 36, 40, 21)];
    wrongNumLabel.textColor = [UIColor redColor];
    wrongNumLabel.text = @"0";
    wrongNumLabel.tag = 602;
    [self addSubview:wrongNumLabel];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(175, 36, 40, 21)];
    label3.text = @"未答";
    [self addSubview:label3];
    UILabel *undoNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 36, 40, 21)];
    undoNumLabel.text = [NSString stringWithFormat:@"%d",_count];
    undoNumLabel.textColor = [UIColor grayColor];
    undoNumLabel.tag = 603;
    [self addSubview:undoNumLabel];
    
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(265, 30, 85, 30);
    [clearBtn setTitle:@"清空数据" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    clearBtn.backgroundColor = [UIColor cyanColor];
    clearBtn.layer.cornerRadius = 15;
    clearBtn.layer.masksToBounds = YES;
    [clearBtn addTarget:self action:@selector(clickClearBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:clearBtn];
    
}

- (void)clickClearBtn{
    UILabel *labelright = (UILabel *)[self viewWithTag:601];
    UILabel *labelwrong = (UILabel *)[self viewWithTag:602];
    UILabel *labelnoanswer = (UILabel *)[self viewWithTag:603];
    labelright.text = [NSString stringWithFormat:@"%d", 0];
    labelwrong.text = [NSString stringWithFormat:@"%d", 0];
    labelnoanswer.text = [NSString stringWithFormat:@"%d",_count];
    [_delegate clearAnswerData];

}

/**
 创建题目选项按钮
 */
- (void)creatButtonView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height-70)];
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
    for (int i = 0; i<_count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake((_width-54*6)/2+54*(i%6), 10+54*(i/6), 50, 50);
        btn.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        //设置当前题目编号为1时的按钮背景颜色
        if (i == 0) {
            btn.backgroundColor = [UIColor orangeColor];
        }
        btn.layer.cornerRadius = 8;
        btn.layer.masksToBounds = YES;
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        btn.tag = 1001 + i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
    int tip = _count%6?2:1;
    _scrollView.contentSize = CGSizeMake(0, 20+54*(_count/6+1+tip));
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    if (point.y>25) {
        _startMoving = YES;
    }
    if (_startMoving&&self.frame.origin.y>=_y-_height&&[self convertPoint:point toView:_superView].y>=80) {
        self.frame = CGRectMake(0, [self convertPoint:point toView:_superView].y, _width, _height);
        float offset = (_superView.frame.size.height - self.frame.origin.y)/_superView.frame.size.height * 0.8;
        _backView.alpha = offset;
        
    }
                     
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _startMoving = NO;
    if (self.frame.origin.y>_y-_height/2) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, _y, _width, _height);
            _backView.alpha = 0;
        }];
    }else
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, _y-_height, _width, _height);
            _backView.alpha = 0.8;
        }];
    }
}
- (void)click:(UIButton *)btn
{
    int index = (int)btn.tag - 1000;
    for (int i = 0; i<_count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+1001];
        if (i!=index-1) {
            button.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        }else{
            button.backgroundColor = [UIColor orangeColor];
        }
    }
    [_delegate SheetViewClick:index];
}
@end
