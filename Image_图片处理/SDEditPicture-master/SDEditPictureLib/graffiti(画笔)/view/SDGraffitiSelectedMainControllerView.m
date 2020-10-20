//
//  SDGraffitiSelectedMainControllerView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDGraffitiSelectedMainControllerView.h"

#import "SDGraffitiResetModel.h"

#import "SDGraffitiSelectedColorModel.h"

#import "SDGraffitiSizeModel.h"

#import "SDGraffitiColorModel.h"

#import "SDGraffitiResetButtonView.h"

#import "SDGraffitiToChooseColorView.h"

#import "SDGraffitiSelectedSizeView.h"

@interface SDGraffitiSelectedMainControllerView ()

@property (nonatomic, weak) SDGraffitiResetButtonView * graffitiResetView;

@property (nonatomic, weak) SDGraffitiToChooseColorView * graffitiSelectedColorView;

@property (nonatomic, weak) UIView * theSelectedSizeContentView;

@property (nonatomic, weak) UIView * theSelectedBrushContentView;

@end

@implementation SDGraffitiSelectedMainControllerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sd_configView];
    }
    return self;
}


- (void)sd_configView
{
    [self graffitiResetView];
    
}

#pragma mark - setter

- (void)setGraffitiResetModel:(SDGraffitiResetModel *)graffitiResetModel
{
    _graffitiResetModel = graffitiResetModel;
    
    self.graffitiResetView.graffitiResetModel = self.graffitiResetModel;
}

- (void)setGraffitiSelectedColorModel:(SDGraffitiSelectedColorModel *)graffitiSelectedColorModel
{
    _graffitiSelectedColorModel = graffitiSelectedColorModel;
    
    self.graffitiSelectedColorView.graffitiSelectedColorModel = self.graffitiSelectedColorModel;
    
}

- (void)setGraffiti_size_list:(NSArray *)graffiti_size_list
{
    _graffiti_size_list = graffiti_size_list;
    
   __block CGFloat lastPointx = CGRectGetMaxX(self.graffitiSelectedColorView.frame);
    
    CGFloat unitWidth = (self.theSelectedBrushContentView.frame.size.width - lastPointx) / self.graffiti_size_list.count;
    
    [self.graffiti_size_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SDGraffitiSizeModel * sizemodel = obj;
        
        SDGraffitiSelectedSizeView * sizeView = [self createGraffSizeWithModel:sizemodel];
        [self.theSelectedBrushContentView addSubview:sizeView];

        sizeView.frame = (CGRect){{lastPointx,0},{unitWidth , sizeView.frame.size.height}};
        
        lastPointx += sizeView.frame.size.width;
    }];
    
    // 设置 EraseView
    [self seteraserList];
    
}

- (SDGraffitiSelectedSizeView * )createGraffSizeWithModel:(SDGraffitiSizeModel *)graffitiSizeModel
{
    SDGraffitiSelectedSizeView * sizeview = [[SDGraffitiSelectedSizeView alloc] initWithSizeModel:graffitiSizeModel];
    
    return sizeview;
}


- (void)seteraserList
{
    CGFloat eraserWidth = self.graffiti_size_list.count * MAXSize(140);
    
    [self.theSelectedSizeContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(eraserWidth);
    }];
    
    __block CGFloat lastPointx = 0;
    
    [self.graffiti_size_list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SDGraffitiSizeModel * sizemodel = obj;
        
        SDGraffitiSelectedSizeView * sizeView = [self createGraffSizeWithModel:sizemodel];
        
        [self.theSelectedSizeContentView addSubview:sizeView];
        
        sizeView.isErearseModel = true;
        sizeView.frame = (CGRect){{lastPointx,0},{MAXSize(140) , sizeView.frame.size.height}};
        
        lastPointx += sizeView.frame.size.width;
    }];
    
    self.theSelectedSizeContentView.hidden = YES;
    
}

- (void)showbrushControllerView
{
    self.theSelectedSizeContentView.hidden = YES;
    
    self.theSelectedBrushContentView.hidden = false;
}

- (void)showEraserControllerView
{
    self.theSelectedBrushContentView.hidden = YES;
    self.theSelectedSizeContentView.hidden = false;
}

#pragma mark - getter
- (SDGraffitiResetButtonView *)graffitiResetView
{
    if (!_graffitiResetView) {
        SDGraffitiResetButtonView * theView = [[SDGraffitiResetButtonView alloc] init];
        
        theView.frame = (CGRect){CGPointZero,theView.frame.size};
        [self addSubview:theView];
        
        _graffitiResetView = theView;
    }
    return _graffitiResetView;
}

- (SDGraffitiToChooseColorView *)graffitiSelectedColorView
{
    if (!_graffitiSelectedColorView) {
        SDGraffitiToChooseColorView * theView = [[SDGraffitiToChooseColorView alloc] init];
        [self.theSelectedBrushContentView addSubview:theView];
        
        theView.frame = (CGRect){{0,0},theView.frame.size};
        
        _graffitiSelectedColorView = theView;
    }
    return _graffitiSelectedColorView;
}

- (UIView *)theSelectedSizeContentView
{
    if (!_theSelectedSizeContentView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        
        [theView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.mas_equalTo(self).offset(MAXSize(196));
            make.height.mas_equalTo(MAXSize(160));
            make.width.mas_equalTo(0);
        }];
        
        _theSelectedSizeContentView = theView;
    }
    return _theSelectedSizeContentView;
}

- (UIView *)theSelectedBrushContentView
{
    if (!_theSelectedBrushContentView) {
        UIView * theView = [[UIView alloc] init];
        [self addSubview:theView];
        
        theView.frame = CGRectMake(CGRectGetMaxX(self.graffitiResetView.frame), 0, self.bounds.size.width - CGRectGetMaxX(self.graffitiResetView.frame), self.bounds.size.height);
        
        _theSelectedBrushContentView = theView;
    }
    return _theSelectedBrushContentView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
