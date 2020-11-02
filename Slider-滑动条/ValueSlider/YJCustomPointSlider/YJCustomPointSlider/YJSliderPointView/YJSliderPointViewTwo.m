//
//  YJSliderPointViewTwo.m
//  YJCustomPointSlider
//
//  Created by 于英杰 on 2019/5/15.
//  Copyright © 2019 YYJ. All rights reserved.
//

#import "YJSliderPointViewTwo.h"
#import "UIView+YJUiView.h"

@interface YJSliderPointViewTwo ()
{
    
    CGFloat _pointX;
    NSInteger _sectionIndex;//当前选中的那个
    CGFloat _sectionLength;//根据数组分段后一段的长度

    
}


@property (nonatomic,assign)CGFloat defaultIndx;
@property(nonatomic,strong)NSMutableArray*itemarray;
@property (strong,nonatomic)UIView *TapTipView;
@property (strong,nonatomic)UIView *lineView;
@property (strong,nonatomic)UIImageView *TapTip;
@property (strong,nonatomic)UILabel *tipLab;
@property (nonatomic, strong) CAGradientLayer *lineLayer;
@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSArray *colorLocationArray;


@end


@implementation YJSliderPointViewTwo

#define TapTip_W       16.0
#define SLiderLine_H    1.0


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.itemarray= @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"].mutableCopy;
        [self SetupUI];
        _pointX=0;
        _sectionIndex=0;
        self.defaultIndx=1;
        
    }
    return self;
}

-(void)SetupUI{
    
   
    [self addSubview:self.lineView];
    [self addSubview:self.TapTipView];
    [self addSubview:self.tipLab];
    for (int i=0; i<=_itemarray.count; i++) {
        UIView *view = [UIView new];
        view.frame = CGRectMake(i *_sectionLength+4, self.height/2+SLiderLine_H/2-4, 8, 8);
        view.layer.cornerRadius=4;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
        view.layer.borderWidth = 1;
        view.userInteractionEnabled=NO;
        [self addSubview:view];
        
        if (i%2!=0) {
            view.hidden = YES;
        }
        
    }
    [self addSubview:self.TapTip];

}

-(UIView*)lineView{
    
    if (_lineView==nil) {
        _lineView =[[UIView alloc] initWithFrame:CGRectMake(TapTip_W/2, self.height/2, self.width-TapTip_W, SLiderLine_H)];
        _lineView.backgroundColor = [UIColor clearColor];
        _lineView.layer.cornerRadius=SLiderLine_H/2;
        _lineView.userInteractionEnabled=NO;
        [_lineView.layer addSublayer:self.lineLayer];

    }
    return _lineView;
}
-(CAGradientLayer*)lineLayer{
    if (_lineLayer==nil) {
        self.colorArray = @[(id)[[UIColor colorWithHex:0xFF5E37] CGColor],
                            (id)[[UIColor colorWithHex:0xFFA301] CGColor],
                            (id)[[UIColor colorWithHex:0x10B345] CGColor]];
        self.colorLocationArray = @[@0.4, @0.6, @1];
        _lineLayer =  [CAGradientLayer layer];
        _lineLayer.frame = CGRectMake(0, 0, _lineView.frame.size.width, 1);
        [_lineLayer setLocations:self.colorLocationArray];
        [_lineLayer setColors:self.colorArray];
        [_lineLayer setStartPoint:CGPointMake(0, 0)];
        [_lineLayer setEndPoint:CGPointMake(1, 0)];
    }
    return _lineLayer;
}
-(UIView*)TapTipView{
    
    if (_TapTipView==nil) {
        _TapTipView =[[UIView alloc] initWithFrame:CGRectMake(TapTip_W/2, self.height/2, self.width-TapTip_W, SLiderLine_H)];
        _TapTipView.backgroundColor = [UIColor clearColor];
        _TapTipView.layer.cornerRadius=SLiderLine_H/2;
        _TapTipView.userInteractionEnabled=NO;
    }
    return _TapTipView;
}

-(UIImageView*)TapTip{
    
    if (_TapTip==nil) {
        _TapTip=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, TapTip_W, TapTip_W)];
        _TapTip.center=CGPointMake(TapTip_W/2, self.height/2+SLiderLine_H/2);
        _TapTip.userInteractionEnabled=NO;
        _TapTip.layer.cornerRadius=TapTip_W/2;
        _TapTip.alpha=1;
        _TapTip.backgroundColor = [UIColor orangeColor];
    }
    return _TapTip;
}

-(UILabel*)tipLab{
    
    if (_tipLab==nil) {
        _tipLab=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 15)];
        _tipLab.center=CGPointMake(TapTip_W/2, self.height/2+SLiderLine_H/2-5);
        _tipLab.textColor=[UIColor redColor];
        _tipLab.font=[UIFont systemFontOfSize:14];
        _tipLab.textAlignment=1;
        _tipLab.layer.cornerRadius = 10;
        _tipLab.clipsToBounds=YES;
        _tipLab.backgroundColor = [UIColor clearColor];
    }
    return _tipLab;
}

-(void)setDefaultIndx:(CGFloat)defaultIndx{
    CGFloat withPress=defaultIndx/(_itemarray.count-1);
    //设置默认位置
    CGRect rect=[_TapTipView frame];
    rect.size.width = withPress*self.lineView.width;
    _TapTipView.frame=rect;
    _pointX=withPress*self.lineView.width;
    _sectionIndex=defaultIndx;
    [self refreshSlider];
}

-(void)setItemarray:(NSMutableArray *)itemarray{
    _itemarray=itemarray;
    _sectionLength=(self.lineView.width/(itemarray.count-1));
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    _pointX=_sectionIndex*(_sectionLength);
    [self refreshSlider];
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    [self refreshSlider];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self changePointX:touch];
    _pointX=_sectionIndex*(_sectionLength);
//    if (self.block) {
//        self.block((int)_sectionIndex);
//    }
    [self refreshSlider];
}

-(void)refreshSlider{
    _pointX=_pointX+TapTip_W/2;
    _TapTip.center=CGPointMake(_pointX, self.height/2+SLiderLine_H/2);
    CGRect rect = [_TapTipView frame];
    rect.size.width=_pointX-TapTip_W/2;
    _TapTipView.frame=rect;
    
    _tipLab.text=[NSString stringWithFormat:@"%@",_itemarray[_sectionIndex]];
    _tipLab.center=CGPointMake(_pointX, 7);
    
}

-(void)changePointX:(UITouch *)touch{
    CGPoint point = [touch locationInView:self];
    _pointX=point.x;
    if (point.x<0) {
        _pointX=TapTip_W/2;
    }else if (point.x>self.lineView.width){
        _pointX=self.lineView.width+TapTip_W/2;
    }
    //取整
    _sectionIndex=(int)roundf(_pointX/_sectionLength);
    
}
@end
