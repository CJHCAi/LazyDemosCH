//
//  Text1.m
//  CQTopBar
//
//  Created by yto on 2018/1/22.
//  Copyright © 2018年 CQ. All rights reserved.
//

#import "Text1.h"
#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
@interface Text1 ()

@end

@implementation Text1

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 200)];
    view.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view];
}

@end
