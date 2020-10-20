//
//  ViewController.m
//  ZWMLuckViewDemo
//
//  Created by 伟明 on 2017/12/15.
//  Copyright © 2017年 com.zwm. All rights reserved.
//

#import "ViewController.h"
#import "ZWMLuckView.h"

@interface ViewController ()<ZWMLuckViewDelegate>
@property (nonatomic, strong) ZWMLuckView *luckV;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadLuckView];
}

- (void)loadLuckView{
    // 临时图片数组（正式项目中由后台返回）
    NSMutableArray  * arr =[NSMutableArray array];
    for (int i =0; i<9; i++) {
        [arr addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    _luckV = [[ZWMLuckView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-350)/2.0,(self.view.frame.size.height-350)/2.0, 350, 350) imagesArray:[arr copy]];
    _luckV.rateArray = @[@10,@30,@20,@11,@18,@10,@13,@14];
    _luckV.circleCount=4;
    _luckV.deleagte=self;
    [self.view addSubview:_luckV];
}

#pragma mark --- ZWMLuckViewDelegate
- (void)luckViewDidStopWithIndex:(NSInteger)index{
    // 取到奖品可回传给后台
    NSLog(@"%zd",index);
}

@end
