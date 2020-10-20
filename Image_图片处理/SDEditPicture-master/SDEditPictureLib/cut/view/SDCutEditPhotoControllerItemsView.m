//
//  SDCutEditPhotoControllerItemsView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDCutEditPhotoControllerItemsView.h"

#import "SDEditImageEnumModel.h"

#import "SDEditImageEnumView.h"

#import "SDCutEditItemsView.h"

@interface SDCutEditPhotoControllerItemsView ()

@property (nonatomic, weak) UIView * theMainContentView;

@property (nonatomic, weak) SDCutEditItemsView * theCutContentView;

@end


@implementation SDCutEditPhotoControllerItemsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAXSize(310));
        [self sd_configView];
    }
    return self;
}

- (void)sd_configView
{
    [self theCutContentView];
    [self theMainContentView];
}


- (void)sd_resetAction
{
    [self.theCutContentView sd_resetFunctionModel];
}


- (void)setCutList:(NSArray *)cutList
{
    _cutList = cutList;
    
    self.theCutContentView.cutList = self.cutList;
    
}

- (void)setCancelModel:(SDEditImageEnumModel *)cancelModel
{
    _cancelModel = cancelModel;
    SDEditImageEnumView * view = [[SDEditImageEnumView alloc] initWithEditEnumModel:self.cancelModel withSize:CGSizeMake(MAXSize(216), MAXSize(146))];
    view.frame = (CGRect){{0,0},view.frame.size};
    [self.theMainContentView addSubview:view];
}

- (void)setCutModel:(SDEditImageEnumModel *)cutModel
{
    _cutModel = cutModel;
    SDEditImageEnumView * view = [[SDEditImageEnumView alloc] initWithEditEnumModel:self.cutModel withSize:CGSizeMake(MAXSize(216), MAXSize(146))];
    view.center = CGPointMake(self.theMainContentView.bounds.size.width / 2.f, self.theMainContentView.bounds.size.height / 2.f);
    [self.theMainContentView addSubview:view];
}
- (void)setSureModel:(SDEditImageEnumModel *)sureModel
{
    _sureModel = sureModel;
    
    SDEditImageEnumView * view = [[SDEditImageEnumView alloc] initWithEditEnumModel:self.sureModel withSize:CGSizeMake(MAXSize(216), MAXSize(146))];
    view.frame = (CGRect){{SCREEN_WIDTH - view.frame.size.width,0},view.frame.size};
    [self.theMainContentView addSubview:view];
}

- (UIView *)theMainContentView
{
    if (!_theMainContentView) {
        UIView * theView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - MAXSize(146), SCREEN_WIDTH, MAXSize(146))];
        [self addSubview:theView];
        _theMainContentView = theView;
    }
    return _theMainContentView;
}

- (SDCutEditItemsView *)theCutContentView
{
    if (!_theCutContentView) {
        SDCutEditItemsView * theView = [[SDCutEditItemsView alloc] initWithFrame:(CGRect){CGPointZero,{self.bounds.size.width,self.bounds.size.height - MAXSize(146)}}];
        [self addSubview:theView];
        _theCutContentView = theView;
    }
    return _theCutContentView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
