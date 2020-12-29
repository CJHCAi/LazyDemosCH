//
//  WallpaperCell.m
//  WallPaper
//
//  Created by Never on 2017/2/10.
//  Copyright © 2017年 Never. All rights reserved.
//

#import "WallpaperCell.h"
#import "WallPaper.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PixabayModel.h"
#import "YYKit.h"

@implementation WallpaperCell{
    UIImageView *_image;
    YYAnimatedImageView *_webImageView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _image = [[UIImageView alloc] init];
        _image.contentMode = UIViewContentModeScaleAspectFill;
        _image.clipsToBounds = YES;
//        [self.contentView addSubview:_image];
        
        _webImageView = [YYAnimatedImageView new];
        _webImageView.size = self.size;
        _webImageView.clipsToBounds = YES;
        _webImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _webImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_webImageView];
        
    }
    return self;
}


- (void)setPixabayModel:(PixabayModel *)model{

//    WeakSelf
    [_webImageView setImageWithURL:model.webformatURL
                       placeholder:nil
                           options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation
                        completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        if (stage == YYWebImageStageFinished) {
                
                self->_webImageView.alpha = 0;
                //旋转
                self->_webImageView.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(.5, .5), drand48()-0.5);
                //缩放
                self->_webImageView.transform = CGAffineTransformMakeScale(0.6, 0.6);
                
                [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
                    
                    self->_webImageView.transform = CGAffineTransformIdentity;
                    self->_webImageView.alpha = 1;
                    
                } completion:nil];
            }
    }
        ];

}


- (void)layoutSubviews{
    [super layoutSubviews];
//    _image.frame = self.contentView.bounds;
    _webImageView.frame = self.contentView.bounds;
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
//    _image.alpha = selected ? 0.5 : 1;
}
@end
