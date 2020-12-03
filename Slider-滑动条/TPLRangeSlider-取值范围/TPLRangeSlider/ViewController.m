//
//  ViewController.m
//  TPLRangeSlider
//
//  Created by 谭鄱仑 on 15-1-28.
//  Copyright (c) 2015年 谭鄱仑. All rights reserved.
//

#import "ViewController.h"


#import "TPLRangeSlider.h"

@interface ViewController ()
{
    TPLRangeSlider * _rangeSlider;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSliderBackView];
	// Do any additional setup after loading the view, typically from a nib.
}
//添加滚动视图背景
-(void)addSliderBackView
{
    UIImageView * sliderBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 150)];
    //    _sliderBackView.backgroundColor = [UIColor colorWithRed:0.733 green:0.920 blue:0.756 alpha:1.000];
    sliderBackView.userInteractionEnabled = YES;
    sliderBackView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:sliderBackView];
    
    UILabel * signLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20,200, 20)];
    signLabel.backgroundColor = [UIColor clearColor];
    signLabel.textColor = [UIColor colorWithWhite:0.560 alpha:1.000];
    signLabel.font = [UIFont systemFontOfSize:18];
    signLabel.text = @"适合阶段：";
    [sliderBackView addSubview:signLabel];
    
    /* tpl 使用方法 */
    _rangeSlider = [[TPLRangeSlider alloc] initWithFrame:CGRectMake(10,signLabel.frame.size.height + signLabel.frame.origin.y + 10, sliderBackView.frame.size.width - 10*2, sliderBackView.frame.size.height - signLabel.frame.size.height - 10)];
    _rangeSlider.backgroundColor = [UIColor redColor];
    [sliderBackView addSubview:_rangeSlider];
    
    _rangeSlider.titleArray = @[@"0.1",@"0.2",@"0.3",@"0.4",@"0.6",@"0.7",@"0.8"];
    _rangeSlider.titleHeight = 30;
    _rangeSlider.titleFont = [UIFont systemFontOfSize:13];
    _rangeSlider.sliderItemSize = 25;
    
    
    //因为Slider是继承的UIControl,所以可以注册信息
    [_rangeSlider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    
    /* tpl 使用方法 */
    
}

-(void)valueChange:(id)sender
{
    
}



@end
