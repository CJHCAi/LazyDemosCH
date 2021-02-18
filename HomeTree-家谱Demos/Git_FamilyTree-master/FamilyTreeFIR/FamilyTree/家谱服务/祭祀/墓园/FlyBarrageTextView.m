//
//  FlyBarrageTextView.m
//  FamilyTree
//
//  Created by 姚珉 on 16/7/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "FlyBarrageTextView.h"

@implementation FlyBarrageTextView{
    CGFloat Y;
    CGFloat Height;
    CGRect  SuperRect;
    CGFloat WordSize;
}



-(instancetype)initWithY:(CGFloat)y AndText:(NSString*)text AndWordSize:(CGFloat)wordSize{
    SuperRect = [ [UIScreen mainScreen] bounds];
    CGFloat width = text.length * wordSize;
    Y = y;
    WordSize = wordSize;
    Height = wordSize * 1.2;
    self = [super initWithFrame:CGRectMake(SuperRect.size.width, y, width, Height)];
    if(self){
        self.text = text;
        self.font = [UIFont systemFontOfSize:wordSize];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:8 block:^(NSTimer * _Nonnull timer) {
            [self starFly];
        } repeats:YES];
        [self.timer setFireDate:[NSDate distantPast]];
    }
    return self;
}

-(void)starFly{
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.frame = CGRectMake(SuperRect.size.width, Y, self.text.length * WordSize, Height);
    [UIView animateWithDuration:8 animations:^{
        self.frame = CGRectMake(SuperRect.origin.x - self.frame.size.width, Y, self.frame.size.width, Height);
    }];
}

@end
