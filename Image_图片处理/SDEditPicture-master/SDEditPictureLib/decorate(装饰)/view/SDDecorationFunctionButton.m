//
//  SDDecorationFunctionButton.m
//  NestHouse
//
//  Created by shansander on 2017/6/23.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import "SDDecorationFunctionButton.h"

@implementation SDDecorationFunctionButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MAXSize(64), MAXSize(64));
        [self configView];
    }
    return self;
}

- (void)configView
{
    [self setBackgroundColor:[UIColor whiteColor]];
    

}

- (void)setShowImage:(UIImage *)showImage
{
    _showImage = showImage;
    self.showImageView.image = self.showImage;

}

- (void)layoutSubviews
{
    self.layer.cornerRadius=  self.bounds.size.width / 2.f;
    
    self.showImageView.frame = CGRectMake(self.bounds.size.width / 4.f, self.bounds.size.height / 4.f, self.bounds.size.width/2.f, self.bounds.size.height / 2.f);
    
}


#pragma mark - lazy

- (UIImageView *)showImageView
{
    if (!_showImageView) {
        UIImageView * theView = [[UIImageView alloc] init];
        [self addSubview:theView];
        theView.frame = self.bounds;
        theView.layer.cornerRadius = self.bounds.size.width / 2.f;
        _showImageView = theView;
    }
    return _showImageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
