//
//  netErrorPage.m
//  SeeFood
//
//  Created by 纪洪波 on 15/11/27.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "netErrorPage.h"
#import "PrefixHeader.pch"

@implementation netErrorPage
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIView *errorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        errorView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _refreash = [UIButton buttonWithType:UIButtonTypeCustom];
        _refreash.frame = CGRectMake(0, 0, 50, 50);
        _refreash.center = CGPointMake(KScreenWidth / 2, KScreenHeight / 2 - 100);
        [_refreash setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        [errorView addSubview:_refreash];
        
        UILabel *warn = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        warn.center = CGPointMake(KScreenWidth / 2, KScreenHeight / 2 - 50);
        warn.text = @"No network connected";
        warn.textColor = [UIColor redColor];
        warn.textAlignment = NSTextAlignmentCenter;
        [errorView addSubview:warn];
        [self addSubview:errorView];
        self.warn = warn;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
