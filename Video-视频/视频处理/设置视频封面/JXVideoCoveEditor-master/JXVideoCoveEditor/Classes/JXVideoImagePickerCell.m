//
//  JXVideoImagePickerCell.m
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "JXVideoImagePickerCell.h"
#import "JXVideoImageGenerator.h"

@interface JXVideoImagePickerCell ()
@property(nonatomic, strong) UIImageView *imageView;
@end
@implementation JXVideoImagePickerCell


- (UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}



- (void)setVideoImage:(JXVideoImage *)videoImage{
    _videoImage = videoImage;
    
    self.imageView.image = videoImage.image;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    JXWeakSelf(self);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        JXStrongSelf(self);
        make.left.bottom.top.right.mas_equalTo(self.contentView);
    }];
}

@end
