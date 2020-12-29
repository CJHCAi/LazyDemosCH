//
//  JFReminderAppearance.m
//  StepUp
//
//  Created by syfll on 15/4/28.
//  Copyright (c) 2015年 JFT0M. All rights reserved.
//

#import "JFReminderAppearance.h"

@implementation JFReminderAppearance

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    [self setDefaultValues];
    
    return self;
}
-(void)setDefaultValues{
    //self.lineColor = [UIColor colorWithRed:172.0/255.0 green:0 blue:0 alpha:1];
    self.lineColor = [UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:1];
    self.lineWidth = 3;
}

@end
