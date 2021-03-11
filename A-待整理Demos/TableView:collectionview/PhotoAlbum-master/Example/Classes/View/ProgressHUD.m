//
//  ProgressHUD.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/6/8.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ProgressHUD.h"
#import "Typedefs.h"
#import "ZQAlbumNavVC.h"

@interface ProgressHUD ()
@property (nonatomic, strong) UIView *hUDContainer;
@property (nonatomic, strong) UILabel *hUDLable;
@property (nonatomic, strong) UIActivityIndicatorView *hUDIndicatorView;
@property (nonatomic, strong) UILabel *lblProgress;
@end


@implementation ProgressHUD

+ (instancetype)sharedInstance {
    static ProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[self alloc] initPrivate];
    });
    return hud;
}
- (instancetype)initPrivate {
    CGRect frame = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        self.hUDContainer = [[UIView alloc] init];
        self.hUDContainer.frame = CGRectMake((CGRectGetWidth(frame) - 120) / 2, (CGRectGetHeight(frame) - 90) / 2, 120, 90);
        self.hUDContainer.layer.cornerRadius = 8;
        self.hUDContainer.clipsToBounds = YES;
        self.hUDContainer.backgroundColor = [UIColor darkGrayColor];
        self.hUDContainer.alpha = 0.7;
        
        self.hUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.hUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);
        
        self.hUDLable = [[UILabel alloc] init];
        self.hUDLable.frame = CGRectMake(0,45, 120, 45);
        self.hUDLable.textAlignment = NSTextAlignmentCenter;
        self.hUDLable.text = _LocalizedString(@"TRIP_PHOTO_UPLOAD_1");
        self.hUDLable.font = [UIFont systemFontOfSize:15];
        self.hUDLable.textColor = [UIColor whiteColor];
        
        [self.hUDContainer addSubview:self.hUDLable];
        [self.hUDContainer addSubview:self.hUDIndicatorView];
        
        self.lblProgress = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 50, 45)];
        self.lblProgress.textColor = [UIColor whiteColor];
        self.lblProgress.font = [UIFont systemFontOfSize:17];
        self.lblProgress.textAlignment = NSTextAlignmentCenter;
        self.lblProgress.hidden = YES;
        [self.hUDContainer addSubview:self.lblProgress];
        
        [self addSubview:self.hUDContainer];
    }
    return self;
}

+ (void)show {
    ProgressHUD *hud = [ProgressHUD sharedInstance];
    hud.hUDLable.text = _LocalizedString(@"TRIP_PHOTO_UPLOAD_1");
    hud.lblProgress.hidden = YES;
    hud.hUDIndicatorView.hidden = NO;
    [hud.hUDIndicatorView startAnimating];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
}

+ (void)hide {
    ProgressHUD *hud = [ProgressHUD sharedInstance];
    [hud.hUDIndicatorView stopAnimating];
    [hud removeFromSuperview];
    
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    if (self.lblProgress.hidden == YES) {
        self.lblProgress.hidden = NO;
        self.hUDIndicatorView.hidden = YES;
        self.hUDLable.text = _LocalizedString(@"TRIP_CONTENT_VIDEO_COMPRESSING");
    }
    self.lblProgress.text = [NSString stringWithFormat:@"%.0f%%", progress*100];
    
}

@end
