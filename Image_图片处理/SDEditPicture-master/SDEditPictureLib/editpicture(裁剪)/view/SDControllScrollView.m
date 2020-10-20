//
//  SDControllScrollView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/11.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDControllScrollView.h"

@interface SDControllScrollView ()

@property (nonatomic, weak) UIView * controllView;

@property (nonatomic, weak) UIImageView * controllImageView;

@end

@implementation SDControllScrollView

- (instancetype )initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self controllImageView];
        
    }
    return self;
}

- (void)setOriginImage:(UIImage *)originImage
{
    _originImage = originImage;
    
    self.controllImageView.image = self.originImage;
    [self configView];
    
}


- (void)configView
{
    
}


- (UIView *)controllView
{
    if (!_controllView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        _controllView = theView;
    }
    return _controllView;
}

- (UIImageView *)controllImageView
{
    if (!_controllImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self.controllView addSubview:theView];
        _controllImageView = theView;
    }
    return _controllImageView;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
