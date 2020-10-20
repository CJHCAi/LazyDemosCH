//
//  HomeTableView.m
//  MVVM-demo
//
//  Created by shen_gh on 16/4/12.
//  Copyright © 2016年 申冠华. All rights reserved.
//

#import "HomeTableView.h"
#import "Define.h"

@implementation HomeTableView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:kAppMainBgColor];
    }
    return self;
}

@end
