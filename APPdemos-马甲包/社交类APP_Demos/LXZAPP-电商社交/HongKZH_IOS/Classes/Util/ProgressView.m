//
//  ProgressView.m
//  ProgressViewDome
//
//  Created by Rainy on 2017/12/28.
//  Copyright © 2017年 Rainy. All rights reserved.
//

#define kProgressTintColor       [UIColor redColor]
#define kTrackTintColor          [UIColor lightGrayColor]

#define kPopupWindowIMG          [UIImage imageNamed:@"popupWindow"]

#define kProgressView_H          5
#define kInterval                5

#import "ProgressView.h"

@interface ProgressView ()

@property (nonatomic, strong) UIImageView *progressAccountIMG;
@property (nonatomic, strong) UILabel * progressTitleLabel;
@property (nonatomic, strong) UILabel * progressAccountLabel;
@property (nonatomic, strong) UIProgressView * rateProgressView;

@end

@implementation ProgressView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

-(void)addColorNew:(UIColor *)color selcolorNew:(UIColor *)selcolor
{
    self.rateProgressView.progressTintColor = selcolor;
    self.rateProgressView.trackTintColor = color;
}

-(void)addAccountIMG:(UIImage *)imageNew
{
    self.progressAccountIMG.image = imageNew;
    _progressAccountIMG.frame = CGRectMake(-25, 0, 50, 46);
//    [self addSubview:self.progressAccountIMG];
}


- (void)setupViews
{
    self.progressAccountIMG = [[UIImageView alloc]initWithImage:kPopupWindowIMG];
    _progressAccountIMG.frame = CGRectMake(-25, 0, 50, 46);
    [self addSubview:self.progressAccountIMG];
    
//    self.progressTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.rateProgressView.frame) + kInterval, 100, self.frame.size.height - self.progressTitleLabel.frame.origin.y)];
//    self.progressTitleLabel.textAlignment = NSTextAlignmentCenter;
//    self.progressTitleLabel.textColor = kProgressTintColor;
//    [self addSubview:self.progressTitleLabel];
//
//    self.progressAccountLabel =  [[UILabel alloc] initWithFrame:CGRectMake(0, -2, self.progressAccountIMG.bounds.size.width, self.progressAccountIMG.bounds.size.height)];
//    self.progressAccountLabel.textColor = kProgressTintColor;
//    self.progressAccountLabel.textAlignment = NSTextAlignmentCenter;
//    self.progressAccountLabel.backgroundColor = [UIColor clearColor];
//    [self.progressAccountIMG addSubview:self.progressAccountLabel];
    
    // 进度条初始化
    self.rateProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    _rateProgressView.frame = CGRectMake(0, CGRectGetMaxY(self.progressAccountIMG.frame) + kInterval, self.frame.size.width, kProgressView_H);
    _rateProgressView.frame = CGRectMake(0,0, self.frame.size.width, kProgressView_H);
    // 进度条的底色
//    self.rateProgressView.progressTintColor = kProgressTintColor;
//    self.rateProgressView.trackTintColor = kTrackTintColor;
    
   
//    self.rateProgressView.layer.masksToBounds = YES;
    self.rateProgressView.layer.cornerRadius = kProgressView_H / 2;
    
    [self addSubview:self.rateProgressView];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setSubviewsFrame];
}
- (void)setSubviewsFrame
{
    CGSize tempSize = [self sizeWithString:self.progressTitleLabel.text font:self.progressTitleLabel.font];
    
    
    CGFloat tempX = (self.bounds.size.width * self.rateProgressView.progress < tempSize.width) ? 0 : self.bounds.size.width * self.rateProgressView.progress - tempSize.width;
    
    
    [UIView animateWithDuration:self.rateProgressView.progress animations:^{
        self.progressAccountIMG.frame = CGRectMake(self.bounds.size.width * self.rateProgressView.progress - 25, 0, 50, 46);
        
        self.progressAccountLabel.frame = CGRectMake(0, -2, self.progressAccountIMG.bounds.size.width, self.progressAccountIMG.bounds.size.height);
        
//        self.rateProgressView.frame = CGRectMake(0, CGRectGetMaxY(self.progressAccountIMG.frame) + kInterval, CGRectGetWidth(self.frame), kProgressView_H);
        self.rateProgressView.frame = CGRectMake(0,0, CGRectGetWidth(self.frame), kProgressView_H);
        self.progressTitleLabel.frame = CGRectMake(tempX, CGRectGetMaxY(self.rateProgressView.frame) + kInterval, tempSize.width, tempSize.height);
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(self.progressTitleLabel.frame));
        
    }];
}
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self.rateProgressView setProgress:progress animated:YES];
    self.progressAccountLabel.text = [NSString stringWithFormat:@"%%%.0f",progress * 100];
}
- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    self.progressTitleLabel.text = titleString;
}


@end
