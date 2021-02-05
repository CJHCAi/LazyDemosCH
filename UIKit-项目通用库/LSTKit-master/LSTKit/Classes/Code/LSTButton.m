//
//  LSTButton.m
//  LSTButton
//
//  Created by LoSenTrad on 2018/2/19.
//  Copyright © 2018年 LoSenTrad. All rights reserved.
//

#import "LSTButton.h"
#import "UIView+LSTView.h"


@implementation LSTButton


#pragma mark - ***** 初始化 *****

+ (instancetype)buttonWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        _imageTextSpacing = 6.0f;
        _isAdaptiveWidth = NO;
        _imageType = LSTButtonImageTypeLeft;
        _titleFont = [UIFont systemFontOfSize:15];
        _titleColor = [UIColor blackColor];
        _corners = UIRectCornerAllCorners;
        _cornerRadius = 0;
        _borderWidth = 0.f;
        _borderColor = [UIColor whiteColor];
        _backgroundColor = [UIColor whiteColor];
    }
    return self;
}


#pragma mark - ***** setupUI 界面布局 *****

- (void)initSubViews {
    
    self.layer.backgroundColor = self.backgroundColor.CGColor;
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.imageView];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    _backgroundColor = backgroundColor;
    self.layer.backgroundColor = backgroundColor.CGColor;
}

- (void)setImageContentMode:(UIViewContentMode)imageContentMode {
    _imageContentMode = imageContentMode;
    self.imageView.contentMode = imageContentMode;
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleAlignment:(NSTextAlignment )titleAlignment {
    _titleAlignment = titleAlignment;
    self.titleLabel.textAlignment = titleAlignment;
}

- (void)layoutSubviews {
    [super layoutSubviews];
   

    
//    NSLog(@"%@",self.subviews);
    
    CGFloat centerX = self.width * 0.5;
    CGFloat centerY = self.height * 0.5;
    CGFloat padding = self.imageTextSpacing * 0.5;
    
    //先改Size和中心点, 否则会有位置显示问题
    if (self.imageSize.width !=0 && self.imageSize.height != 0) {
        self.imageView.y = centerY - self.imageSize.height * 0.5;
        self.imageView.size = self.imageSize;
    }

    CGFloat allWidth = self.imageView.width + self.titleLabel.width;
    CGFloat allHeight = self.imageView.height + self.titleLabel.height;
    
    if (self.imageType == LSTButtonImageTypeLeft) {//图片左
        self.imageView.x = centerX - allWidth * 0.5 - padding;
        self.titleLabel.x = CGRectGetMaxX(self.imageView.frame) + padding * 2;
    } else if (self.imageType == LSTButtonImageTypeTop) {//图片上
        self.imageView.x = centerX - self.imageView.width * 0.5;
        self.imageView.y = centerY - allHeight * 0.5 - padding;
        self.titleLabel.x = 0;
        self.titleLabel.width = self.width;
        self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + padding * 2;
    } else if (self.imageType == LSTButtonImageTypeBottom) {//图片下
        self.titleLabel.x = centerX - self.titleLabel.width * 0.5;
        self.titleLabel.y = centerY - allHeight * 0.5 - padding;
        self.imageView.x = centerX - self.imageView.width * 0.5;
        self.imageView.y = CGRectGetMaxY(self.titleLabel.frame) + padding * 2;
    } else if (self.imageType == LSTButtonImageTypeRight) {//图片右
        self.titleLabel.x = centerX - allWidth * 0.5 - padding;
        self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + padding * 2;
    }
    
}
@end
