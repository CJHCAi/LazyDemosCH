//
//  ViewController.m
//  FloatingBall
//
//  Created by CygMac on 2018/6/7.
//  Copyright © 2018年 XunKu. All rights reserved.
//

#import "ViewController.h"
#import "FloatingBallHeader.h"

@interface ViewController () <FloatingBallHeaderDelegate>

@property (nonatomic, strong) FloatingBallHeader *floatingBallHeader;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.floatingBallHeader resetAnimation];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    FloatingBallHeader *floatingBallHeader = [[FloatingBallHeader alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, FloatingBallHeaderHeight)];
    floatingBallHeader.delegate = self;
    floatingBallHeader.dataList = @[@"1.2", @"0.05", @"1.88", @"10.55", @"20", @"33", @"0.01", @"1.23"];
    [self.view addSubview:floatingBallHeader];
    self.floatingBallHeader = floatingBallHeader;
}

- (void)floatingBallHeader:(FloatingBallHeader *)floatingBallHeader didPappaoAtIndex:(NSInteger)index isLastOne:(BOOL)isLastOne {
    NSLog(@"点了%zd", index);
    if (isLastOne) {
        // 点了最后一个，刷新
        self.floatingBallHeader.dataList = @[@"2.2", @"0.15", @"8.88", @"5.55", @"2.22", @"3.33", @"0.11", @"1.23", @"6.66", @"7.89"];
    }
    
}

@end
