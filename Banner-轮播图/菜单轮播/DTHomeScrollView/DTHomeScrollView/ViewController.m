//
//  ViewController.m
//  DTHomeScrollView
//
//  Created by 信达 on 2018/7/24.
//  Copyright © 2018年 ymh. All rights reserved.
//

#import "ViewController.h"
#import "DTHomeScrollView.h"
#import "DTHomeButton.h"
@interface ViewController ()<DTHomeScrollViewDelegate>
@property (nonatomic,strong)DTHomeScrollView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSMutableArray *views = [NSMutableArray array];
    NSArray *titles = @[@"课程",@"阿米巴",@"创客",@"大赛",@"人才银行",@"小邮局",@"蚤市",@"创客",@"大赛",@"人才银行",@"小邮局",@"蚤市",@"大赛",@"人才银行",@"小邮局",@"蚤市"];
    for (int i = 0; i < titles.count; i++) {
        DTHomeButton *btn = [[DTHomeButton alloc]initWithFrame:CGRectZero withTitle:titles[i] withImageURLString:@""];
//        [btn setTitle:titles[i] forState:0];
//        [btn setTitleColor:[UIColor redColor] forState:0];
    
        [views addObject:btn];
        
    }
 
    //坐标自己需要设置
    CGFloat margin = 20;
    CGFloat WH = (self.view.bounds.size.width -margin*4)/3;
    CGFloat scrollH = WH * 2 + margin + 20;
    self.scrollView = [[DTHomeScrollView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, scrollH) viewsArray:views];
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    
}

#pragma DTHomeScrollViewDelegate
- (void)buttonUpInsideWithView:(UIButton *)btn withIndex:(NSInteger)index withView:(DTHomeScrollView *)view{
    NSLog(@"%ld",index);
}



@end
