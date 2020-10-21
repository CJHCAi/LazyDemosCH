//
//  LQProgressLine.m
//  LQProgressLine
//
//  Created by 李强 on 16/7/20.
//  Copyright © 2016年 李强. All rights reserved.
//

#import "LQProgressLine.h"

@interface LQProgressLine ()

@property (nonatomic,strong) NSArray *backColorArray;
@property (nonatomic,strong) NSArray *didColorArray;
//@property (nonatomic, weak) UIView *backView;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, assign) BOOL animated;

@end

@implementation LQProgressLine

+(instancetype)progressLineWithBackColor:(NSString *)bColor didColor:(NSString *)dColor{
    return [[self alloc]initWithBackColor:bColor didColor:dColor];
}
- (instancetype)initWithBackColor:(NSString *)bColor didColor:(NSString *)dColor{
    if (self = [super init]) {
        [self addSubview:self.progressView];
        self.backColor = bColor;
        self.didColor = dColor;
    }
    return self;
}
- (void)setBackColor:(NSString *)backColor{
    _backColor = backColor;
    self.backColorArray = [self RGBFromStr:backColor];
    self.backgroundColor = [UIColor colorWithRed:[self.backColorArray[0] floatValue] green:[self.backColorArray[1] floatValue] blue:[self.backColorArray[2] floatValue] alpha:1];
}
- (void)setDidColor:(NSString *)didColor{
    _didColor = didColor;
    self.didColorArray = [self RGBFromStr:didColor];
    self.progressView.backgroundColor = [UIColor colorWithRed:[self.didColorArray[0] floatValue] green:[self.didColorArray[1] floatValue] blue:[self.didColorArray[2] floatValue] alpha:1];
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self updateProgress];
}
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    _progress = progress;
    _animated = animated;
    
    [self updateProgress];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [self updateProgress];
}
- (void)updateProgress{
    CGFloat width = self.frame.size.width * self.progress;
    if (width <= 0) {
        return;
    }
    if (self.animated) {
        self.animated = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.progressView.frame = CGRectMake(0, 0, width, self.frame.size.height);
        }];
    } else {
        self.progressView.frame = CGRectMake(0, 0, width, self.frame.size.height);
    }

}

- (NSArray *)RGBFromStr:(NSString *)hexColor{
    
    NSString *str = nil;
    if([hexColor rangeOfString:@"#"].length>0){
        str = [hexColor substringFromIndex:1];
    }else{
        str = hexColor;
    }
    if(str.length<=0)return nil;
    
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[str substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[str substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[str substringWithRange:range]]scanHexInt:&blue];
    return @[@(red/255.0),@(green/255.0),@(blue/255.0)];
}
- (UIView *)progressView{
    if (_progressView == nil) {
        _progressView = [[UIView alloc]init];
    }
    return _progressView;
}

@end
