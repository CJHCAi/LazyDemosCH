//
//  SDGraffitiSelectedColorContentView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDGraffitiSelectedColorContentView.h"

#import "SDGraffitiSelectedColorView.h"

#import "SDGraffitiSelectedColorModel.h"

@interface SDGraffitiSelectedColorContentView ()

@property (nonatomic, weak) UIView * theContentView;

@end


@implementation SDGraffitiSelectedColorContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAXSize(132));
    }
    return self;
}

- (void)sd_configView
{
    [self theContentView];
}

- (void)setGraffitiColorList:(NSArray *)graffitiColorList
{
    _graffitiColorList = graffitiColorList;
    
    NSInteger count = self.graffitiColorList.count;
    CGFloat contetn_width = count * MAXSize(106);
    
    [self.theContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(contetn_width);
    }];
    
    __block CGFloat lastPointx = 0;
    [self.graffitiColorList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SDGraffitiColorModel * model = obj;
        SDGraffitiSelectedColorView * colorView = [self createGraffitiColorViewWithColorModel:model];
        colorView.frame = (CGRect){{lastPointx,0},colorView.frame.size};
        lastPointx += colorView.frame.size.width;
    }];
}

- (SDGraffitiSelectedColorView *)createGraffitiColorViewWithColorModel:(SDGraffitiColorModel * )colorModel
{
    SDGraffitiSelectedColorView * colorView = [[SDGraffitiSelectedColorView alloc] initWithGraffitiColor:colorModel];
    
    [self.theContentView addSubview:colorView];
    
    return colorView;
}


- (UIView *)theContentView
{
    if (!_theContentView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.bottom.equalTo(self);
            make.height.mas_equalTo(self.bounds.size.height);
            make.centerX.equalTo(self);
            
            make.width.mas_equalTo(0);
        }];
        
        _theContentView = theView;
    }
    return _theContentView;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
