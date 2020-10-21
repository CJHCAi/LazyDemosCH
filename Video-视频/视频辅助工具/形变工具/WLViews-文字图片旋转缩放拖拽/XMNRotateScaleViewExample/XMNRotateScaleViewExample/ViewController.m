//
//  ViewController.m
//  XMNRotateScaleViewExample
//
//  Created by shscce on 15/11/30.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "ViewController.h"

#import "XMNRotateScaleView.h"

@interface ViewController () <XMNRotateScaleViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /** 配置一个contentView 是UIImageView 的XMNRotateScaleView **/
    
    XMNRotateScaleView *rotateScaleView = [[XMNRotateScaleView alloc] initWithFrame:CGRectMake(100, 50, 120, 120)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sampleImage.jpg"]];
    rotateScaleView.contentView = imageView;
    
    [self.view addSubview:rotateScaleView];
    
    
    /** 配置一个contentView 是UILabel的XMNRotateScaleView **/
    UILabel *testLabel = [[UILabel alloc] init];
    testLabel.text = @"just test it 你没有看错  是的  你就最强王者";
    testLabel.font = [UIFont systemFontOfSize:16.0f];
    
    //调用[testLabel sizeToFit]方法 用来确认testLabel的最小区域
    [testLabel sizeToFit];
    
    //实例化一个XMNRotateScalView,frame主要是用来确定view的位置
    XMNRotateScaleView *rotateScaleTextView = [[XMNRotateScaleView alloc] initWithFrame:CGRectMake(100, 150, 120, 120)];
    //设置最小区域,如果是label的话 推荐设置,否则可能会出现bug,最好在设置contentView前面设置
    [rotateScaleTextView setMinSize:CGSizeMake(testLabel.frame.size.width + 10, testLabel.frame.size.height)];
    rotateScaleTextView.contentView = testLabel;
    //设置代理,则可以在代理中调用adjustFont 方法,自适应字体
    rotateScaleTextView.delegate = self;
    [testLabel adjustFont];
    [self.view addSubview:rotateScaleTextView];
    
}



#pragma mark - XMNRotateScaleViewDelegate

- (void)rotateScaleViewDidRotateAndScale:(XMNRotateScaleView *)rotateScaleView {
    UILabel *testLabel = (UILabel *)rotateScaleView.contentView;
    [testLabel adjustFont];
}
@end
