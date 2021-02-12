//
//  LvCircleLoadingView.m
//  LvCircleLoadingViewTest
//
//  Created by lv on 2016/11/10.
//  Copyright © 2016年 lv. All rights reserved.
//

#import "LvCircleLoadingView.h"
#import "LvCircleView.h"
#import "UIColor+Lv.h"

@interface LvCircleLoadingView ()
{
    CAShapeLayer *_shapeLayer;
    UIView *_viewBg;
}

@end

@implementation LvCircleLoadingView

+(void)showWithText:(NSString *)text imgLogo:(UIImage *)image
{
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIColor *colorStart=[[UIColor whiteColor]colorWithAlphaComponent:1];
    UIColor *colorEnd=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
    
    CGSize size=[UIScreen mainScreen].bounds.size;
    LvCircleLoadingView *circle=[[LvCircleLoadingView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    circle.center=CGPointMake(size.width/2, size.height/2);
    circle.imageLogo=image;
    circle.colorStart=colorStart;
    circle.colorEnd=colorEnd;
    
    [window addSubview:circle];
    
    circle.alertText=text;
}



+(void)showWithText:(NSString *)text
{

    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIColor *colorStart=[[UIColor whiteColor]colorWithAlphaComponent:1];
    UIColor *colorEnd=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
    
    CGSize size=[UIScreen mainScreen].bounds.size;
    LvCircleLoadingView *circle=[[LvCircleLoadingView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    circle.center=CGPointMake(size.width/2, size.height/2);
//    circle.imageLogo=[UIImage imageNamed:@"logo"];
    circle.colorStart=colorStart;
    circle.colorEnd=colorEnd;
   
    [window addSubview:circle];
    
     circle.alertText=text;
}

+(void)hidden
{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"LvCircleLoadingView"]) {
            [obj removeFromSuperview];
        }
    }];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        [self initUI:frame];
    
    }
    return self;
}

-(void)initUI:(CGRect)frame 
{
    _viewBg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    _viewBg.backgroundColor=[UIColor blackColor];
    _viewBg.alpha=0.6;
    [self addSubview:_viewBg];
    
    UITapGestureRecognizer *tapBg=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBg:)];
    [_viewBg addGestureRecognizer:tapBg];
    
    self.lineWidth=2;
    self.lineSpacing=self.lineWidth*4;
    
    self.labText=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    self.labText.textAlignment=NSTextAlignmentCenter;
    self.labText.backgroundColor=[UIColor clearColor];
    self.labText.font=[UIFont systemFontOfSize:14];
    self.labText.textColor=[UIColor whiteColor];
    [self addSubview:self.labText];
}
-(void)tapBg:(UITapGestureRecognizer *)tap
{
//    [self removeFromSuperview];
}


-(void)drawRect:(CGRect)rect
{

    LvCircleView *circle=[[LvCircleView alloc]initWithFrame:CGRectMake(0, 0, 70, 70)];
   
    circle.colorStart=self.colorStart;
    circle.colorEnd=self.colorEnd;
    circle.lineWidth=self.lineWidth;
    circle.imageLogo=self.imageLogo;
    circle.lineSpacing=self.lineSpacing;
    circle.backgroundColor=[UIColor clearColor];
    [self addSubview:circle];

    if (self.alertText==nil||[self.alertText isEqualToString:@""])
    {
         circle.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    }
    else
    {
        circle.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2-15);
    }
    
//    self.imgLogo.bounds=CGRectMake(0, 0, self.frame.size.width-self.lineSpacing-2*self.lineWidth, self.frame.size.width-self.lineSpacing-2*self.lineWidth);
//    self.imgLogo.layer.cornerRadius=self.imgLogo.bounds.size.width/2;
//    self.imgLogo.clipsToBounds=YES;
//    self.imgLogo.center=CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//    
    self.labText.frame=CGRectMake(0, circle.center.y+circle.bounds.size.height/2+5, self.frame.size.width, 30);
    self.labText.text=self.alertText;
 
}

@end
