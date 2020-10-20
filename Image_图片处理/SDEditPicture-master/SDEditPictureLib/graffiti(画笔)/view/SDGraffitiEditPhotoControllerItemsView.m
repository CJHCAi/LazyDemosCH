//
//  SDGraffitiEditPhotoControllerItemsView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDGraffitiEditPhotoControllerItemsView.h"
#import "SDEditImageEnumModel.h"

#import "SDEditImageEnumView.h"

#import "SDGraffitiSelectedMainControllerView.h"

#import "SDGraffitiResetModel.h"

#import "SDGraffitiSelectedColorModel.h"

#import "SDGraffitiSelectedColorContentView.h"

@interface SDGraffitiEditPhotoControllerItemsView ()

@property (nonatomic, weak) UIView * theMainContentView;

@property (nonatomic, weak) SDGraffitiSelectedMainControllerView * graffitiMainView;

@property (nonatomic, weak) SDGraffitiSelectedColorContentView * graffitiColorContentView;


@end

@implementation SDGraffitiEditPhotoControllerItemsView

- (id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAXSize(306));
        
        [self sd_configView];
    }
    return self;
}

- (void)sd_configView
{
    self.clipsToBounds = false;
}

- (void)showGraffitiColorView
{
    
    //这里应该有个动画,工程太赶，先记着
    self.frame = CGRectMake(0, SCREENH_HEIGHT - MAXSize(438), SCREEN_WIDTH, MAXSize(438));
    
    self.theMainContentView.frame = (CGRect){{0,self.bounds.size.height - self.theMainContentView.frame.size.height},self.theMainContentView.frame.size};
    self.graffitiMainView.frame = (CGRect){{0,MAXSize(132)},self.graffitiMainView.frame.size};

    
    [self graffitiColorContentView];
    self.graffitiColorContentView.frame = (CGRect){CGPointZero,self.graffitiColorContentView.frame.size};
    
    self.graffitiColorContentView.hidden = false;
    
}

- (void)hideGraffitiColorView
{
    self.frame = CGRectMake(0, SCREENH_HEIGHT - MAXSize(306), SCREEN_WIDTH, MAXSize(306));
    
    self.theMainContentView.frame = (CGRect){{0,self.bounds.size.height - self.theMainContentView.frame.size.height},self.theMainContentView.frame.size};
    self.graffitiMainView.frame = (CGRect){{0,0},self.graffitiMainView.frame.size};
    
    self.graffitiColorContentView.hidden = true;
    
}

- (void)showSelectedbrushView
{
    [self.graffitiMainView showbrushControllerView];
}
- (void)showSelectedEraserView
{
    [self hideGraffitiColorView];
    [self.graffitiMainView showEraserControllerView];
}


#pragma mark - setter

- (void)setCancelModel:(SDEditImageEnumModel *)cancelModel
{
    _cancelModel = cancelModel;
    SDEditImageEnumView * view = [[SDEditImageEnumView alloc] initWithEditEnumModel:self.cancelModel withSize:CGSizeMake(MAXSize(216), MAXSize(146))];
    view.frame = (CGRect){{0,0},view.frame.size};
    [self.theMainContentView addSubview:view];
}


- (void)setSureModel:(SDEditImageEnumModel *)sureModel
{
    _sureModel = sureModel;
    
    SDEditImageEnumView * view = [[SDEditImageEnumView alloc] initWithEditEnumModel:self.sureModel withSize:CGSizeMake(MAXSize(216), MAXSize(146))];
    view.frame = (CGRect){{SCREEN_WIDTH - view.frame.size.width,0},view.frame.size};
    [self.theMainContentView addSubview:view];
}

- (void)setBrushModel:(SDEditImageEnumModel *)brushModel
{
    _brushModel = brushModel;
    SDEditImageEnumView * view = [[SDEditImageEnumView alloc] initWithEditEnumModel:self.brushModel withSize:CGSizeMake(MAXSize(216), MAXSize(146))];
    view.center = CGPointMake(self.bounds.size.width / 2.f - view.frame.size.width / 2.f, self.theMainContentView.frame.size.height / 2.f);
    
    [self.theMainContentView addSubview:view];
}

- (void)setEraserModel:(SDEditImageEnumModel *)eraserModel
{
    _eraserModel = eraserModel;
    SDEditImageEnumView * view = [[SDEditImageEnumView alloc] initWithEditEnumModel:self.eraserModel withSize:CGSizeMake(MAXSize(216), MAXSize(146))];
    view.center = CGPointMake(self.bounds.size.width / 2.f + view.frame.size.width / 2.f, self.theMainContentView.frame.size.height / 2.f);
    [self.theMainContentView addSubview:view];
    
}

- (void)setGraffitiResetModel:(SDGraffitiResetModel *)graffitiResetModel
{
    _graffitiResetModel = graffitiResetModel;
    
    self.graffitiMainView.graffitiResetModel = self.graffitiResetModel;
}

- (void)setGraffitiSelectedColorModel:(SDGraffitiSelectedColorModel *)graffitiSelectedColorModel
{
    _graffitiSelectedColorModel = graffitiSelectedColorModel;
    
    self.graffitiMainView.graffitiSelectedColorModel = self.graffitiSelectedColorModel;
}
- (void)setGraffiti_size_list:(NSArray *)graffiti_size_list
{
    _graffiti_size_list = graffiti_size_list;
    
    self.graffitiMainView.graffiti_size_list = self.graffiti_size_list;
}
- (void)setGraffiti_color_list:(NSArray *)graffiti_color_list
{
    _graffiti_color_list = graffiti_color_list;
    
    
    self.graffitiColorContentView.graffitiColorList = self.graffiti_color_list;
    
}
#pragma mark - getter

- (UIView *)theMainContentView
{
    if (!_theMainContentView) {
        UIView * theView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - MAXSize(146), self.bounds.size.width, MAXSize(146))];
        [self addSubview:theView];
        _theMainContentView = theView;
    }
    return _theMainContentView;
}

- (SDGraffitiSelectedMainControllerView *)graffitiMainView
{
    if (!_graffitiMainView) {
        SDGraffitiSelectedMainControllerView * theView = [[SDGraffitiSelectedMainControllerView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, MAXSize(160))];
        [self addSubview:theView];
        _graffitiMainView = theView;
    }
    return _graffitiMainView;
}
- (SDGraffitiSelectedColorContentView *)graffitiColorContentView
{
    if (!_graffitiColorContentView) {
        SDGraffitiSelectedColorContentView * theView = [[SDGraffitiSelectedColorContentView alloc] init];
        theView.frame = (CGRect){{0,self.bounds.size.height},theView.frame.size};
        [self addSubview:theView];
        theView.hidden = true;
        _graffitiColorContentView = theView;
    }
    return _graffitiColorContentView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
