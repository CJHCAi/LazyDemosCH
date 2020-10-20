//
//  SDGraffitiSelectedColorView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDGraffitiSelectedColorView.h"

#import "SDGraffitiColorModel.h"

@interface SDGraffitiSelectedColorView ()

@property (nonatomic, weak) UIView * theColorView;

@end

@implementation SDGraffitiSelectedColorView

- (instancetype)initWithGraffitiColor:(SDGraffitiColorModel *)colorModel
{
    self = [super init];
    if (self) {
        _graffitiColorModel = colorModel;
        self.frame = CGRectMake(0, 0, MAXSize(106), MAXSize(132));
        
        [self sd_configView];
    }
    return self;
}

- (void)sd_configView
{
    UIColor * color = self.graffitiColorModel.graffitiColor;
    
    self.theColorView.backgroundColor = color;
    
    if ([[color hexRGB] isEqualToString:@"ffffff"]) {
        self.theColorView.layer.borderColor = [UIColor blackColor].CGColor;
        self.theColorView.layer.borderWidth = 1.f;
    }
    
    [self addTarget:self action:@selector(onTapSelectedColor:) forControlEvents:UIControlEventTouchUpInside];

}
- (void)onTapSelectedColor:(id)sender
{
    [self.graffitiColorModel.done_subject sendNext:@"1"];
    
}



- (UIView *)theColorView
{
    if (!_theColorView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(MAXSize(46), MAXSize(46)));
        }];
        
        theView.layer.masksToBounds = YES;
        theView.layer.cornerRadius = MAXSize(23);
        
        
        _theColorView = theView;
    }
    return _theColorView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
