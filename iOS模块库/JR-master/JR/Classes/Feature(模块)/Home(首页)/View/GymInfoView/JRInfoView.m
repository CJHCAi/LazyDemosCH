
//
//  JRInfoView.m
//  JR
//
//  Created by Zj on 17/8/20.
//  Copyright © 2017年 Zj. All rights reserved.
//

#import "JRInfoView.h"

@implementation JRInfoView

#pragma mark - lifeCycle
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubViews];
    }
    return self;
}


#pragma mark - private
- (void)setupSubViews{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height / 3)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:_imageView];
    
    _label = [UILabel labelWithFrame:CGRectMake(0, self.height / 2, self.width, self.height / 4) text:nil color:JRCommonTextColor font:JRCommonFont(JRSmallTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_label];
    
    _detailLabel = [UILabel labelWithFrame:CGRectMake(0, _label.bottom, self.width, self.height / 4) text:nil color:JRLightTextColor font:JRThinFont(JRCommonTextFontSize) textAlignment:NSTextAlignmentCenter];
    
    [self addSubview:_detailLabel];
}

@end
