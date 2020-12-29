//
//  SingSectionHeaderView.m
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import "SingSectionHeaderView.h"

@implementation SingSectionHeaderView

+(SingSectionHeaderView *)instanceSingSectionHeaderView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SingSectionHeaderView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

@end
