//
//  SheetView.m
//  StudyDrive
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "SheetView.h"
@interface SheetView()
{
    UIView * _superView;
    UILabel *_titleLabel;
    BOOL _startMoving;
    float _hight;
    float _width;
    float _y;
    UIScrollView * _scrollView;
    int _count;
}
@end
@implementation SheetView
- (instancetype)initWithFrame:(CGRect)frame withSuperView:(UIView *)superView andQuesCount:(int)count title:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        _hight=frame.size.height;
        _width=frame.size.width;
        _y=frame.origin.y;
        _superView=superView;
        _count=count;
        [self creatViewWithTitle:title];
    }
    return self;
}
-(void)creatViewWithTitle:(NSString*)title{
    _backView = [[UIView alloc]initWithFrame:_superView.frame];
    _backView.backgroundColor=[UIColor blackColor];
    _backView.alpha=0;
    [_superView addSubview:_backView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 50)];
    _titleLabel.text = title;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];

    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, self.frame.size.width, self.frame.size.height-70)];
    [self addSubview:_scrollView];
    
    for (int i=0; i<_count; i++) {
       
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame=CGRectMake((_width-44*6)/2+44*(i%6), 10+44*(i/6), 40, 40);
        btn.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        if (i==0) {
            btn.backgroundColor = [UIColor orangeColor];
        }
        [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        btn.layer.masksToBounds=YES;
        btn.layer.cornerRadius=8;
        btn.tag=101+i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
    }
    int tip = (_count%6)?1:0;
    _scrollView.contentSize=CGSizeMake(0, 20+44*(_count/6+1+tip));
}

-(void)click:(UIButton *)btn{
    int index = (int)btn.tag-100;
    for (int i=0; i<_count-1; i++) {
        UIButton * button = (UIButton *)[self viewWithTag:i+101];
        if (i!=index-1) {
           button.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
        }else{
           button.backgroundColor=[UIColor orangeColor];
        }
    }
    [_delegate SheetViewClick:index];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    if (point.y<25) {
        _startMoving=YES;
    }
    if (_startMoving&&self.frame.origin.y>=_y-_hight&&[self convertPoint:point toView:_superView].y>=80) {
        self.frame=CGRectMake(0, [self convertPoint:point toView:_superView].y, _width, _hight);
        float offset = (_superView.frame.size.height-self.frame.origin.y)/_superView.frame.size.height*0.8;
        _backView.alpha=offset;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _startMoving=NO;
    if (self.frame.origin.y>_y-_hight/2) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame=CGRectMake(0, _y, _width, _hight);
            _backView.alpha=0;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.frame=CGRectMake(0, _y-_hight, _width, _hight);
            _backView.alpha=0.8;
        }];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
