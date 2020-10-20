//
//  XMAutoScrollTextView.m
//  AlphaGoFinancial
//
//  Created by 千锋 on 16/6/27.
//  Copyright © 2016年 wxm. All rights reserved.
//

#import "XMAutoScrollTextView.h"

#define LABEL_TAG_INIT 10

//滚动时间间隔
#define SCROLL_TIME_INTERVAL 3

//每次滚动距离
#define SCROLL_DISTANCE 100

@implementation XMAutoScrollTextView

-(instancetype)initWithFrame:(CGRect)frame textArray:(NSArray *)textArray colorArray:(NSArray *)textColorArray{
    
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=self.backgroundColorOfCanvas;
        
        //*************属性赋值*************
        _textArray=textArray;
        
        _textColorArray=textColorArray;
        
        _fontOfSize=15.0;
        
        //*********创建scrollView内容*********
        [self createContentOfScrollView];
        
        //************自动滚动timer************
        NSTimer *timer=[NSTimer scheduledTimerWithTimeInterval:SCROLL_TIME_INTERVAL target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];

        //立即启动定时器
        [timer setFireDate:[NSDate date]];
        
        self.timer=timer;
        
    }
    
    return self;
}

#pragma mark - 创建scrollView内容
-(void)createContentOfScrollView{
 
    //创建contentView
    self.contentSize=CGSizeMake(0, self.bounds.size.height);
    
    //偏移量初值设为0
    self.contentOffset=CGPointMake(0, 0);
    
    //关闭指示条
    self.showsHorizontalScrollIndicator=NO;
    
    //创建label

    CGFloat labelY=0;
    CGFloat labelW=200;
    CGFloat labelH=self.bounds.size.height;
    
    //添加两次一样的内容，无限循环使用
    for (int j=0; j<2;j++ ) {
        
    for (int i=0; i<self.textArray.count; i++) {
           
        UILabel *textLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.contentSize.width, labelY, labelW, labelH)];
        
        //******标签背景******
        UIImageView *labelBackGroundView=[[UIImageView alloc] initWithFrame:textLabel.frame];
        
        //标签背景图片
        labelBackGroundView.image=self.backgroundImageOfCanvas;
        
        //*****label文字******
        if (i<self.textArray.count) {
            textLabel.text=self.textArray[i];
        }else{
            textLabel.text=@"----";
        }
        
        //label文字颜色(判断文字颜色数组是否存有对应的颜色，没有则使用默认颜色)
        if (i<self.textColorArray.count) {
            textLabel.textColor=self.textColorArray[i];
        }else{
            //默认颜色
            textLabel.textColor=[UIColor blackColor];
        }
        
        //******字体大小********
        textLabel.font=[UIFont systemFontOfSize:self.fontOfSize];
        
        //label标签tag值
        textLabel.tag=LABEL_TAG_INIT + i + 100 * j;
        
        //每创建一个label在contenSize上加上一个label的宽度
        self.contentSize=CGSizeMake(self.contentSize.width+labelW, self.bounds.size.height);
        
        [self addSubview:labelBackGroundView];
        [self addSubview:textLabel];
        
    }
    }
    
}

//布局子控件
-(void)layoutSubviews{
    
    for (int j=0; j<2;j++ ) {
        
        for (int i=0; i<self.textArray.count; i++) {

            UILabel *textLabel=(UILabel *)[self viewWithTag:LABEL_TAG_INIT + i + 100 * j];
            
            //文字
            textLabel.text=self.textArray[i];
            
            //label文字颜色(判断文字颜色数组是否存有对应的颜色，没有则使用默认颜色)
            if (i<self.textColorArray.count) {
                textLabel.textColor=self.textColorArray[i];
            }else{
                //默认颜色
                textLabel.textColor=[UIColor whiteColor];
            }
        }
    }
}

//自动滚动
- (void)autoScroll{
    
    //滚动速度
    CGFloat offSet=SCROLL_DISTANCE;
    
    //若果字幕滚动到第二部分重复的部分则把偏移置0，设为第一部分,实现无限循环
    if (self.contentOffset.x>=self.contentSize.width / 2) {
        
        self.contentOffset=CGPointMake(0, 0);
    }
    
    //切割每次动画滚动距离
    
    [UIView animateWithDuration:SCROLL_TIME_INTERVAL delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.contentOffset=CGPointMake(self.contentOffset.x+offSet, self.contentOffset.y);
    } completion:nil];
}
@end
