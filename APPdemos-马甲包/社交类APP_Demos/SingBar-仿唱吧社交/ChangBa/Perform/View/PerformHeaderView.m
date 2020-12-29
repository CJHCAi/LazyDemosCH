//
//  PerformHeaderView.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/17.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "PerformHeaderView.h"

@implementation PerformHeaderView
//400*172

+(PerformHeaderView *)instancePerformHeaderView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PerformHeaderView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
