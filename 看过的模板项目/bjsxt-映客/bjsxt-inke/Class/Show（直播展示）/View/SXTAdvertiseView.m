//
//  SXTAdvertiseView.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/6.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTAdvertiseView.h"
#import "SXTLiveHandler.h"
#import "SXTAdvertise.h"
#import "SXTCacheHelper.h"

static NSInteger showTime = 3;

@interface SXTAdvertiseView ()

@property (weak, nonatomic) IBOutlet UIImageView *backView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation SXTAdvertiseView

+ (instancetype)loadAdvertiseView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SXTAdvertiseView" owner:self options:nil] lastObject];
}


//广告页初始化方法
- (void)awakeFromNib {
    
    self.frame = [UIScreen mainScreen].bounds;
    
    //展示广告
    [self showAd];
    
    //下载广告
    [self downAd];
    
    //倒计时
    [self startTimer];
}

- (void)showAd {
    
    
    NSString * filename = [SXTCacheHelper getAdvertise];
    NSString * filePath = [NSString stringWithFormat:@"%@%@",IMAGE_HOST,filename];
    
    UIImage * lastCacheImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:filePath];
    if (lastCacheImage) {
        self.backView.image = lastCacheImage;
    } else {
        self.hidden = YES;
    }
    
}

- (void)downAd {
    
    //获取最新广告数据
    [SXTLiveHandler executeGetAdvertiseTaskWithSuccess:^(id obj) {
        
        SXTAdvertise * ad = obj;
        
        NSURL * imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,ad.image]];
        
        //SDWebImageAvoidAutoSetImage 下载完不给imageView赋值
        [[SDWebImageManager sharedManager] downloadImageWithURL:imageUrl options:SDWebImageAvoidAutoSetImage progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            [SXTCacheHelper setAdvertise:ad.image];

            NSLog(@"图片下载成功");
            
        }];
        
    } failed:^(id obj) {
        NSLog(@"%@",obj);
    }];
    
}

- (void)startTimer {
    
    __block NSUInteger timeout = showTime + 1;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    
    self.timer = timer;
    
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        
        if (timeout <= 0) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dissmiss];
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.timeLabel.text = [NSString stringWithFormat:@"跳过 %zd",timeout];
            });
            
            timeout-- ;

        }
    });
    dispatch_resume(timer);
}

- (void)dissmiss {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        
        
        [self removeFromSuperview];
    }];
}

@end
