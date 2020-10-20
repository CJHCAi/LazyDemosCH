//
//  SDGraffitiToChooseColorView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDGraffitiToChooseColorView.h"

#import "SDGraffitiSelectedColorModel.h"

@interface SDGraffitiToChooseColorView ()

@property (nonatomic, weak) UIView * theColorView;

@property (nonatomic, weak) UILabel * theColorLabel;

@end

@implementation SDGraffitiToChooseColorView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = (CGRect){CGPointZero,{MAXSize(166),MAXSize(160)}};
        
        [self sd_configView];
    }
    return self;
}

- (void)setGraffitiSelectedColorModel:(SDGraffitiSelectedColorModel *)graffitiSelectedColorModel
{
    _graffitiSelectedColorModel = graffitiSelectedColorModel;
    
    RAC(self,selected_color) = RACObserve(self.graffitiSelectedColorModel, graffitiColor);
}

- (void)setSelected_color:(UIColor *)selected_color
{
    _selected_color = selected_color;
    
    self.theColorView.backgroundColor = self.selected_color;
    self.theColorView.layer.borderColor = [UIColor blackColor].CGColor;
    self.theColorView.layer.borderWidth = 0.;

    NSString * color_string = @"";
    if ([[self.selected_color hexRGB] isEqualToString:@"ff1744"]) {
        color_string = @"红色";
    }else if ([[self.selected_color hexRGB] isEqualToString:@"ff3d00"]){
        color_string = @"橙色";
    }else if ([[self.selected_color hexRGB] isEqualToString:@"ffc400"]){
        color_string = @"黄色";
    }else if ([[self.selected_color hexRGB] isEqualToString:@"00e5ff"]){
        color_string = @"绿色";
    }else if ([[self.selected_color hexRGB] isEqualToString:@"3d5afe"]){
        color_string = @"蓝色";
    }else if ([[self.selected_color hexRGB] isEqualToString:@"ffffff"]){
        color_string = @"白色";
        self.theColorView.layer.borderWidth = 1.f;
    }
    self.theColorLabel.text = color_string;
    
    CGSize size = [self.theColorLabel.text sizeWithAttributes:@{NSFontAttributeName:self.theColorLabel.font}];
    
    [self.theColorLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    
}

- (void)sd_configView
{
    [self addTarget:self action:@selector(onToSelectedColorAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onToSelectedColorAction:(id)sender
{
    // 通知 viewcontroller 我点击了去选择图片
    [self.graffitiSelectedColorModel.done_subject sendNext:@"1"];
}


- (UIView *)theColorView
{
    if (!_theColorView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(MAXSize(30));
            make.size.mas_equalTo(CGSizeMake(MAXSize(46), MAXSize(46)));
        }];
        
        _theColorView = theView;
    }
    return _theColorView;
}

- (UILabel *)theColorLabel
{
    if (!_theColorLabel) {
        UILabel * theView = [[UILabel alloc] init];
        [self addSubview:theView];
        
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.theColorView.mas_bottom).offset(MAXSize(10));
            make.centerX.equalTo(self.theColorView);
            make.size.mas_equalTo(CGSizeZero);
        }];
        
        theView.textColor = [UIColor colorWithHexRGB:0x757575];
        
        theView.font = [UIFont systemFontOfSize:DFont(32)];
        theView.lineBreakMode = NSLineBreakByWordWrapping;
        
        _theColorLabel = theView;
    }
    return _theColorLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
