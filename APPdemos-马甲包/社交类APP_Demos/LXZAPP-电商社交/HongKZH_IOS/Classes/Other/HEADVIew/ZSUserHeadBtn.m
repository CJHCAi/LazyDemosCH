//
//  ZSUserHeadBtn.m
//  HandsUp
//
//  Created by wanghui on 2018/6/22.
//  Copyright © 2018年 HandsUp.Network. All rights reserved.
//

#import "ZSUserHeadBtn.h"
#import "UIImage+YY.h"
@implementation ZSUserHeadBtn

-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state{
//    CGFloat wh = image.size.height<image.size.width?image.size.height:image.size.width*0.5;
//    image =[image zsyy_imageByResizeToSize:CGSizeMake(wh, wh) contentMode:UIViewContentModeScaleAspectFill];
//    image = [image zsyy_imageByRoundCornerRadius:wh*0.5];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       UIImage* image2 = [image zsyy_imageByResizeToSize:CGSizeMake(0, 0) roundCornerRadius:0];
        dispatch_async(dispatch_get_main_queue(), ^{
          [super setBackgroundImage:image2 forState:state];
        });
    });
   
    
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage* image2 = [image zsyy_imageByResizeToSize:CGSizeMake(0, 0) roundCornerRadius:0];
        dispatch_async(dispatch_get_main_queue(), ^{
             [super setImage:image2 forState:state];
        });
    });
   
}
@end
