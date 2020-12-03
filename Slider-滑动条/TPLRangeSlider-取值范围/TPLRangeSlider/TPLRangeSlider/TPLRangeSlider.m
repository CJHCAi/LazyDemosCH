//
//  IFRangeSlider.m
//  MaMaShoppingPro
//
//  Created by 谭鄱仑 on 14-9-19.
//  Copyright (c) 2014年 谭鄱仑. All rights reserved.
//

#import "TPLRangeSlider.h"



#define dealocInfo NSLog(@"%@ 释放了",[self class])
#define baseColor [UIColor colorWithRed:0.389 green:0.670 blue:0.265 alpha:1.000]



@implementation TPLRangeSliderItem
-(void)dealloc
{
    dealocInfo;
}


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.userInteractionEnabled = YES;
       //添加手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
        
        
    }
    return self;
}


-(void)pan:(UIPanGestureRecognizer *)pan
{
    if (self.pan)
    {
        typeof(self) __weak weak_self = self;
        self.pan(pan,_itemStyle,weak_self);
    }
}


@end


@interface TPLRangeSlider ()
{
//data
    NSMutableArray * _titleLabelArray;
    
    int _mixValue;
    int _maxValue;
    
//View
//    IFRangeSliderItem * _leftItem;
//    IFRangeSliderItem * _rightItem;
    
    UIImageView * _bottomView;
    UIImageView * _upView;
    
}

//@property(nonatomic,strong)IFRangeSliderItem * leftItem;
//@property(nonatomic,strong)IFRangeSliderItem * rightItem;
@property(nonatomic,strong)UIImageView * upView;

@end

@implementation TPLRangeSlider
@synthesize leftItem = _leftItem;
@synthesize rightItem = _rightItem;
@synthesize upView = _upView;


-(void)dealloc
{
    dealocInfo;
}

#pragma mark
#pragma mark           porperty
#pragma mark


-(void)setTitleHeight:(CGFloat )titleHeight
{
    _titleHeight = titleHeight;
    [self refreshView];
}

-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    if(_maxValue == 0)
        _maxValue = (int)titleArray.count - 1;
    [self refreshView];
}
-(void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self refreshView];
}
-(void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    [self refreshView];
}



//滑块
-(void)setBottomColor:(UIColor *)bottomColor
{
    _bottomColor = bottomColor;
    [self refreshView];
}

-(void)setUpColor:(UIColor *)upColor
{
    _upColor = upColor;
    [self refreshView];
}

-(void)setSliderItemSize:(CGFloat)sliderItemSize
{
    _sliderItemSize = sliderItemSize;
    [self refreshView];
}

-(void)setBottomViewHeight:(CGFloat)bottomViewHeight
{
    _bottomViewHeight = bottomViewHeight;
    [self refreshView];
}

-(void)setUpViewHeight:(CGFloat)upViewHeight
{
    _upViewHeight = upViewHeight;
    [self refreshView];
}

#pragma mark
#pragma mark           init view
#pragma mark
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        
        //init data
        _titleLabelArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        //init config
        _titleHeight = 0;
        _titleColor = [UIColor grayColor];
        _titleFont = [UIFont systemFontOfSize:12.0f];
        
        
        
        _upViewHeight = 5;
        _bottomViewHeight = 5;
        _bottomColor = [UIColor colorWithWhite:0.788 alpha:1.000];
        _upColor = baseColor;
        _sliderItemSize = 20;
        _maxValue = 0;
        _mixValue = 0;
        
        
        
        
        [self refreshView];
    }
    return self;
}



-(void)refreshView
{
   //清空之前的title
    while (_titleLabelArray.count > 0)
    {
        [_titleLabelArray.lastObject removeFromSuperview];
        [_titleLabelArray removeLastObject];
    }
    
    //重新加载新标题
    CGFloat width = _titleArray == nil ? 0 : self.frame.size.width/_titleArray.count;
    for (int i = 0; i < _titleArray.count; i++)
    {
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:(CGRect){{i*width,0},{width,_titleHeight}}];
        titleLabel.textColor = _titleColor;
        titleLabel.font = _titleFont;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if (0 == i)
        {
            titleLabel.textAlignment = NSTextAlignmentLeft;
        }
        else if (_titleArray.count - 1 == i)
        {
            titleLabel.textAlignment = NSTextAlignmentRight;
        }
        [self addSubview:titleLabel];
        titleLabel.text = [_titleArray objectAtIndex:i];
        [_titleLabelArray addObject:titleLabel];
    }
    
    
    //加载滑块
    //加底部线
    [_bottomView removeFromSuperview];
    if (_bottomView == nil)
    {
        _bottomView = [[UIImageView alloc] init];
    }
    _bottomView.frame = CGRectMake(0,_titleHeight + 10 + _sliderItemSize/2 - _bottomViewHeight/2, self.frame.size.width, _bottomViewHeight);
    _bottomView.backgroundColor = _bottomColor;
    [self addSubview:_bottomView];
    //加上部线
    [_upView removeFromSuperview];
    if (_upView == nil)
    {
        _upView = [[UIImageView alloc] init];
    }
    CGFloat mixX = _mixValue == 0 ? _sliderItemSize/2 :(_mixValue*width + width/2);
    CGFloat maxX = _maxValue == 0 || _maxValue == _titleArray.count - 1 ? (self.frame.size.width - _sliderItemSize/2) : _maxValue*width + width/2;
    _upView.frame = CGRectMake(mixX,_titleHeight + 10 + _sliderItemSize/2 - _upViewHeight/2,maxX - mixX, _upViewHeight);
    _upView.backgroundColor = _upColor;
    [self addSubview:_upView];
    //加滑块
    
    [_leftItem removeFromSuperview];
    if (_leftItem == nil)
    {
        _leftItem = [[TPLRangeSliderItem alloc] init];
    }
    _leftItem.frame = CGRectMake(0, 0, _sliderItemSize, _sliderItemSize);
    _leftItem.layer.cornerRadius = _sliderItemSize/2;
    _leftItem.backgroundColor = _upColor;
    _leftItem.itemStyle = 0;
    _leftItem.center = CGPointMake(mixX, _upView.center.y);
    [self addSubview:_leftItem];
    
    
    [_rightItem removeFromSuperview];
    if (_rightItem == nil)
    {
        _rightItem = [[TPLRangeSliderItem alloc] init];
    }
    _rightItem.frame = CGRectMake(0, 0, _sliderItemSize, _sliderItemSize);
    _rightItem.layer.cornerRadius = _sliderItemSize/2;
    _rightItem.backgroundColor = _upColor;
    _rightItem.itemStyle = 1;
    _rightItem.range = (int)_titleArray.count - 1;
    _rightItem.center = CGPointMake(maxX, _upView.center.y);
    [self addSubview:_rightItem];


    
    //滑块的滑动block
    typeof(self)__weak weak_self = self;
    void (^pan)(UIPanGestureRecognizer * pan,int itemStyle ,TPLRangeSliderItem * item) = ^(UIPanGestureRecognizer * pan,int itemStyle,TPLRangeSliderItem * item)
    {
        typeof(weak_self) __strong strong_self = weak_self;
        if (strong_self)
        {
            
            if (pan.state == UIGestureRecognizerStateBegan)
            {
                
            }
            
            if (pan.state == UIGestureRecognizerStateChanged)
            {
                CGPoint point = [pan locationInView:strong_self];
                CGFloat x = point.x;
                if(0 == itemStyle)//左滑块
                {
                    if (x < strong_self.sliderItemSize/2)//最左边
                    {
                        x = strong_self.sliderItemSize/2;
                    }
                    
                    if(x > strong_self.rightItem.center.x - strong_self.sliderItemSize)//不能超过右边
                    {
                        x = strong_self.rightItem.center.x - strong_self.sliderItemSize;
                    }
                    item.center = CGPointMake(x, item.center.y);
                }
                else if (1 == itemStyle)//右滑块
                {
                    if (x > (strong_self.frame.size.width - strong_self.sliderItemSize/2))
                    {
                        x = strong_self.frame.size.width - strong_self.sliderItemSize/2;
                    }
                    
                    if(x < strong_self.leftItem.center.x + strong_self.sliderItemSize)
                    {
                        x = strong_self.leftItem.center.x + strong_self.sliderItemSize;
                    }
                    item.center = CGPointMake(x, item.center.y);
                }
                
                //跳整上面的浮动
                CGFloat width = self.rightItem.center.x - self.leftItem.center.x;
                strong_self.upView.frame = CGRectMake(0 == itemStyle ? x + strong_self.sliderItemSize/2 : strong_self.leftItem.center.x + strong_self.sliderItemSize/2, strong_self.upView.frame.origin.y,width,strong_self.upViewHeight);
            }
            
            if (pan.state == UIGestureRecognizerStateEnded)
            {
                [strong_self adjustSliderItem];
            }

        }
    };
    
    _leftItem.pan = pan;
    _rightItem.pan = pan;
    
}


//调整滑块到正确的结点
-(void)adjustSliderItem
{
    CGFloat width = _titleArray == nil ? 0 : self.frame.size.width/_titleArray.count;

    //左边
    int range = _leftItem.center.x/width;
    if (range == _titleArray.count - 1)
    {
        range--;
    }
    if (range == 0)
    {
        if (_leftItem.center.x > width/2)
        {
            range++;
        }
    }
    if (_rightItem.center.x == range*width + width/2)
    {
        range--;
    }
    CGPoint center =  CGPointMake(range == 0 ? _sliderItemSize/2 : range*width + width/2, _leftItem.center.y);
    [UIView animateWithDuration:0.2 animations:^{
        
        _leftItem.center = center;
        _upView.frame = CGRectMake(center.x, _upView.frame.origin.y, _rightItem.center.x - center.x, _upView.frame.size.height);
        
    } completion:^(BOOL finished){
    
        _leftItem.range = range;
        _mixValue = range;
         //此处加值变化通知
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }];
    //右边
    range = _rightItem.center.x/width;
    if (range == _titleArray.count - 1)
    {
        if (_rightItem.center.x < self.frame.size.width -  width/2)
        {
            range--;
        }
    }
    if (range == 0)
    {
        range = 1;
    }
    if (_leftItem.center.x == range*width + width/2)
    {
        range++;
    }
    center =  CGPointMake(range == _titleArray.count - 1 ? self.frame.size.width - _sliderItemSize/2 : range*width + width/2, _rightItem.center.y);
    [UIView animateWithDuration:0.2 animations:^{
        
        _rightItem.center = center;
        _upView.frame = CGRectMake(_upView.frame.origin.x, _upView.frame.origin.y, _rightItem.center.x - _leftItem.center.x, _upView.frame.size.height);
        
    } completion:^(BOOL finished){
        _rightItem.range = range;
        _maxValue = range;
        
        //此处加值变化通知
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }];
    
}




@end
