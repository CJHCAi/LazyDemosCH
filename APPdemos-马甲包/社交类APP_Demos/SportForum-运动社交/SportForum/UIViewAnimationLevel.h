//
//  UIViewAnimationLevel.h
//  SportForum
//
//  Created by liyuan on 6/17/15.
//  Copyright (c) 2015 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewAnimationLevel : UIView

-(void)animationStartWithCompleteBlock:(void(^)(void))finishedBlock;

@end
