//
//  ViewController.m
//  拖拽截图
//
//  Created by 七啸网络 on 2017/6/2.
//  Copyright © 2017年 CJH. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,assign)CGPoint startP;
@property(nonatomic,strong)UIView * clipView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)] ];

    
    
}

-(void)pan:(UIPanGestureRecognizer *)pan
{
    
    
    
    //拖拽截取图片
    [self setPanClipImage:pan];

    //图片擦除
//    [self setImageErase:pan];
}

/**
 拖拽截取图片
 */
-(void)setPanClipImage:(UIPanGestureRecognizer *)pan
{
    CGPoint endP=CGPointZero;
    
    if (pan.state==UIGestureRecognizerStateBegan) {
        //获取开始点
        _startP =[pan locationInView:self.view];
        
        
        
    }else if (pan.state==UIGestureRecognizerStateChanged){
        //拖动计算拖动范围
        endP=[pan locationInView:self.view];
        //计算截取范围
        CGFloat w=endP.x-_startP.x;
        CGFloat h=endP.y-_startP.y;
        
        CGRect clipFrame=CGRectMake(_startP.x, _startP.y, w, h);
        
        
        //生成截屏的view
        self.clipView.frame=clipFrame;
        
        
        
    }else if (pan.state==UIGestureRecognizerStateEnded){
        //获取新的图片
        //开启上下文
        UIGraphicsBeginImageContextWithOptions(_imageView.bounds.size,NO, 0);
        //描述路径 设置裁剪区域
        UIBezierPath * path=[UIBezierPath   bezierPathWithRect:_clipView.frame];
        [path addClip];
        
        //获取上下文 渲染图层
        CGContextRef ctx=UIGraphicsGetCurrentContext();
        [_imageView.layer renderInContext:ctx];
        
        //从上下文获取新的图片
        _imageView.image=UIGraphicsGetImageFromCurrentImageContext();
        //关闭上下文
        UIGraphicsEndImageContext();
        
        //先移除，截取view设置为nil
        [_clipView removeFromSuperview];
        _clipView=nil;
        
        
    }




}


-(UIView *)clipView
{

    if (_clipView==nil) {
       UIView * view=[[UIView alloc]init];
        _clipView=view;
        _clipView.backgroundColor=[UIColor blackColor];
        _clipView.alpha=0.5;
        [self.view addSubview:view];
        
        
    }
    
    return _clipView;

}




/**
 图片擦除
 */
-(void)setImageErase:(UIPanGestureRecognizer *)pan{

   //获取擦除范围
    CGPoint curentP=[pan locationInView:self.view];
    CGFloat WH=50;
    CGFloat x=curentP.x-WH*0.5;
    CGFloat y=curentP.y-WH*0.5;
    CGRect eraseFrame=CGRectMake(x, y, WH, WH);
    
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(_imageView.bounds.size, NO, 0);
    //获取上下文 渲染图层
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    [_imageView.layer renderInContext:ctx];
    //设置擦除范围
    CGContextClearRect(ctx, eraseFrame);
    
    //获取新图片
    _imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    

}
@end
