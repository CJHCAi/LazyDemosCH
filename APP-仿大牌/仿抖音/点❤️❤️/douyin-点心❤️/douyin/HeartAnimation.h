//
//  HeartAnimation.h
//  douyin
//
//  Created by liyongjie on 2018/2/6.
//  Copyright © 2018年 world. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HeartAnimation : NSObject<NSCopying>
+(instancetype)sharedManager;
-(void)createHeartWithTap:(UITapGestureRecognizer *)tap;
@end
