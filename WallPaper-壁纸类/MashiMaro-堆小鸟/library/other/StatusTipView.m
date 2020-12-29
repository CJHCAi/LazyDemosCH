//
//  StatusTipView.m
//  italker
//
//  Created by XuxingGuo on 14/10/23.
//  Copyright (c) 2014年 verywill. All rights reserved.
//

#import "StatusTipView.h"

static StatusTipView* instance;
static NSTimer* timer;
static BOOL endWithAnimate;

@interface StatusTipView ()
@property (nonatomic,retain) UIImageView* imageViewBg;
@property (nonatomic,retain) UIImageView* imageViewStatus;
@property (nonatomic,retain) UILabel* labelStatus;
@property (nonatomic,retain) UIActivityIndicatorView* indicatorView;
@property (nonatomic,retain) UIView* holdingView;
@end

@implementation StatusTipView

- (instancetype)init
{
    if (self = [super init]) {
        self.holdingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        self.holdingView.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication].keyWindow addSubview:self.holdingView];
        self.holdingView.hidden = YES;
        
        CGSize sz = (CGSize){140,140};
        CGRect rcFrame = CGRectMake((ScreenWidth - sz.width)/2, (ScreenHeight - sz.height)/2, sz.width, sz.height);
        self.hidden = YES;
        self.frame = rcFrame;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        self.imageViewBg = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageViewBg.image = [[UIImage imageNamed:@"status_tip_bg"] stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        [self addSubview:self.imageViewBg];
        
        self.indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        CGSize indSz = self.indicatorView.bounds.size;
        self.indicatorView.frame = CGRectMake((sz.width - indSz.width)/2, (sz.height - indSz.height)/2 - indSz.height/2 - 5, indSz.width, indSz.height);
        self.indicatorView.hidesWhenStopped = YES;
        [self addSubview:self.indicatorView];
        
        UIImage* img = [UIImage imageNamed:@"status_tip_success"];
        CGSize statusSz = img.size;
        self.imageViewStatus = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, statusSz.width, statusSz.height)];
        self.imageViewStatus.image = [UIImage imageNamed:@"status_tip_success"];
        self.imageViewStatus.frame = CGRectMake((sz.width - statusSz.width)/2, (sz.height - statusSz.height)/2 - statusSz.height/2 + 15, statusSz.width, statusSz.height);
        [self addSubview:self.imageViewStatus];
        
        self.labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(10, self.bounds.size.height /2, self.bounds.size.width - 20, self.bounds.size.height /2)];
        self.labelStatus.textAlignment = NSTextAlignmentCenter;
        self.labelStatus.font = [UIFont systemFontOfSize:13];
        self.labelStatus.textColor = [UIColor whiteColor];
        self.labelStatus.numberOfLines = 2;
        [self addSubview:self.labelStatus];
        
        endWithAnimate = YES;
    }
    return self;
}

+ (void)setHoldingScreen:(BOOL)hold
{
    if (hold == YES) {
        instance.holdingView.hidden = NO;
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront: instance.holdingView];
        
    } else {
        instance.holdingView.hidden = YES;
    }
}


+ (void)showStatusTip:(NSString *)tip status:(enum StatusTipStatus)status
{
    //dispatch_async(dispatch_get_main_queue(), ^{
        if ( instance == nil ) {
            instance = [[StatusTipView alloc]init];
        }
        
    
    instance.hidden = NO;
    
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:instance];
    
    instance.alpha = 1;
    
    instance.labelStatus.text = tip;
    
    if (status == StatusTipBusy){
        instance.indicatorView.hidden = NO;
        if (!instance.indicatorView.isAnimating){
            [instance.indicatorView startAnimating];
        }
        
        instance.imageViewStatus.hidden = YES;
        
    } else {
        instance.indicatorView.hidden = YES;
        if (instance.indicatorView.isAnimating){
            [instance.indicatorView stopAnimating];
        }
        
        instance.imageViewStatus.hidden = NO;
    }
    
    if (status == StatusTipSuccess) {
        instance.imageViewStatus.image = [UIImage imageNamed:@"status_tip_success"];
        
        [StatusTipView hideStatusTipDelay:0.8];
        
    } else if(status == StatusTipFailure) {
        instance.imageViewStatus.image = [UIImage imageNamed:@"status_tip_failure"];
        
        [StatusTipView hideStatusTipDelay:2.5];
        
    }
    
    //});
}

+ (void)hideStatusTipDelay:(NSTimeInterval)delay
{
    [StatusTipView hideStatusTipDelay:delay animate:YES];
}
+ (void) hideStatusTipDelay:(NSTimeInterval)delay animate:(BOOL)animate
{
    [StatusTipView setHoldingScreen:NO];
    
    endWithAnimate = animate;
    
    if (timer) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:delay target:instance selector:@selector(hideTip:) userInfo:nil repeats:NO];
}

- (void)hideTip:(id)sender
{
    //dispatch_async(dispatch_get_main_queue(), ^{
        
    timer = nil;
    
    if (endWithAnimate) {
        [UIView animateWithDuration:0.5 animations:^{
            instance.alpha = 0;
        } completion:^(BOOL finished) {
            instance.hidden = YES;
        }];
    }
    else {
        instance.alpha = 0;
        instance.hidden = YES;
    }
        
    //});
}

@end
