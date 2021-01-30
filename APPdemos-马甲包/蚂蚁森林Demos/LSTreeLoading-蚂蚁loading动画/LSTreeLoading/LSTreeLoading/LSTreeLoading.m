



//
//  LSTreeLoading.m
//  LSTreeLoading
//
//  Created by liusong on 2017/10/27.
//  Copyright © 2017年 liusong. All rights reserved.
//

#import "LSTreeLoading.h"

@interface  LSTreeLoading()

@property (nonatomic,assign) CGFloat progress ;
@property (nonatomic,assign) BOOL reduce;


@end



@implementation LSTreeLoading

+(void)show
{
   UIWindow *window= [UIApplication sharedApplication].delegate.window;
//    UIImage *  image=[UIImage imageNamed:@"alipay_msp_3rdApp_loading"];
    //替换图片即可
    UIImage *  image=[UIImage imageNamed:@"zhi"];
    CGSize size=image.size;
    LSTreeLoading *loading=[LSTreeLoading layer];
    loading.progress=1;
    loading.backgroundColor=[UIColor redColor].CGColor;
    //98deb7
    loading.colors=@[(id)[UIColor colorWithRed:152/255.0 green:222/255.0 blue:183/255.0 alpha:1].CGColor,(id)[UIColor whiteColor].CGColor];
    loading.startPoint=CGPointMake(0, 0);
    loading.endPoint=CGPointMake(0, 1);
    loading.locations=@[@(loading.progress),@(loading.progress)];
    loading.frame=CGRectMake((window.bounds.size.width-size.width)/2, (window.bounds.size.height-size.height)/2, size.width,size.height);
    [window.layer addSublayer:loading];

    CALayer *mask=[CALayer layer];
    mask.frame=loading.bounds;
    mask.contents=(id)image.CGImage;
    loading.mask=mask;

    CADisplayLink *link=[CADisplayLink displayLinkWithTarget:loading selector:@selector(handleTimer)];
    link.frameInterval=6;
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];

}

-(void)handleTimer
{
    
    self.locations=@[@(self.progress),@(self.progress)];
    
    if (self.reduce) {
        self.progress-=0.1;
    }else{
        self.progress+=0.1;
    }
    
    if (self.progress>1) {
        self.reduce=YES;
        self.progress=1;
    }
    
    if (self.progress<=0) {
        self.reduce=NO;
        self.progress=0;
    }
    
    
}

+(void)hide
{
UIWindow *window= [UIApplication sharedApplication].delegate.window;
    for (CALayer *Layer in window.layer.sublayers) {
        if ([Layer isKindOfClass:[LSTreeLoading class]]) {
            [Layer removeFromSuperlayer];
            break;
        }
    }
    
}
@end
