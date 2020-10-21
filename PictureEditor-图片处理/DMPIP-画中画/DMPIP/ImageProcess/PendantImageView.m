//
//  PendantImageView.m
//  GifDemo
//
//  Created by Rick on 15/5/27.
//  Copyright (c) 2015年 Rick. All rights reserved.
//

#import "PendantImageView.h"

@implementation PendantImageView

//-(instancetype)init{
//    self = [super init];
//    if (self) {
//        self.userInteractionEnabled = YES;
////        self.backgroundColor = [UIColor redColor];
//    }
//    return self;
//}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView  *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    }else{
        return hitView;
    }
//    return nil;
    
}

//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
//    return NO;
//}
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"-----");
//}

@end
