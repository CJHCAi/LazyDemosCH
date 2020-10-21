//
//  LQPlayerProgressLine.m
//  Progress
//
//  Created by 李强 on 17/2/28.
//  Copyright © 2017年 李强. All rights reserved.
//

#import "LQPlayerProgressLine.h"
#import "LQProgressLine.h"
#import "LQSlider.h"
@interface LQPlayerProgressLine ()
@property (nonatomic, weak) LQProgressLine *progress;
@property (nonatomic, weak) LQSlider *slider;
@end

@implementation LQPlayerProgressLine

+ (instancetype)playerProgressLineWithFrame:(CGRect)frame{
    return [[self alloc] initWithFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor purpleColor];
        
        LQProgressLine *progress = [LQProgressLine progressLineWithBackColor:@"#aaaaaa" didColor:@"#555555"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(progressTap:)];
        [self addGestureRecognizer:tap];
        [progress addGestureRecognizer:tap];
        
        progress.layer.masksToBounds = YES;
        progress.progress = 0.0;
        self.progress = progress;
        [self addSubview:progress];
        
        LQSlider *slider = [[LQSlider alloc]init];//WithFrame:CGRectMake(0, [self sliderYWithType], self.frame.size.width, self.frame.size.height)];
        [slider addGestureRecognizer:tap];
//        [slider addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [slider addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchCancel];
//        [slider addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpOutside];
//        [slider addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [slider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
        [slider setThumbImage:[self imageWithImageSimple:[UIImage imageNamed:@"全屏播放器-圆点"] scaledToSize:CGSizeMake(40,40)] forState:UIControlStateNormal];
        //    slider.center = progress.center;
        slider.minimumTrackTintColor = [UIColor orangeColor];
        slider.maximumTrackTintColor = [UIColor clearColor];
        slider.value = 0;
        [self addSubview:slider];
        self.slider = slider;
    }
    return self;
}
- (void)progressTap:(UITapGestureRecognizer *)tap{
    CGPoint point = [tap locationOfTouch:0 inView:tap.view];
    NSLog(@"----%.2f",point.x/self.frame.size.width);
    self.slider.value = point.x/self.frame.size.width;
    
}
- (void)changeValue:(LQSlider *)slider{
    if (self.valueChangeBlock) {
        self.valueChangeBlock(slider);
    }
}
- (void)tap:(LQSlider *)slider{
    if (self.tapBlock) {
        self.tapBlock(slider);
    }
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat height = [self progressHeightWithType];
    self.progress.frame = CGRectMake(0, (self.frame.size.height-height)/2.0, self.frame.size.width, height);
    self.progress.layer.cornerRadius = height/2.0;
    NSLog(@"----%@",NSStringFromCGRect(self.slider.frame));
    CGAffineTransform transform = CGAffineTransformMakeScale(self.frame.size.width/100.0, 1);
    CGRect frame = CGRectMake(0, [self sliderYWithType], self.frame.size.width, self.frame.size.height);
//    self.slider.transform = transform;
    self.slider.frame = frame;
    NSLog(@"7878");
}
- (void)setCacheProgress:(CGFloat)cacheProgress{
    _cacheProgress = cacheProgress;
//    self.progress.progress = cacheProgress;
    [self setCacheProgress:cacheProgress animated:YES];
}
- (void)setCacheProgress:(CGFloat)cacheProgress animated:(BOOL)animated{
    _cacheProgress = cacheProgress;
    [self.progress setProgress:cacheProgress animated:animated];
}
- (void)setPlayProgress:(CGFloat)playProgress{
    _playProgress = playProgress;
    self.slider.value = playProgress;
}
- (void)setType:(LQPlayerProgressLineType)type{
    _type = type;
    self.slider.type = (LQSliderType)type;
}
- (CGFloat)progressHeightWithType{
    if (self.type == LQPlayerProgressLineTypeBig) {
        return 6.0;
    } else {
        return 4.0;
    }
}
- (CGFloat)sliderYWithType{
    if (self.type == LQPlayerProgressLineTypeBig) {
        return 0.0;
    } else {
        return 1.0;
    }
}
@end
