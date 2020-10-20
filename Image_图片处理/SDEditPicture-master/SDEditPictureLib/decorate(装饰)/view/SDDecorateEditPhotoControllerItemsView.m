//
//  SDDecorateEditPhotoControllerItemsView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDDecorateEditPhotoControllerItemsView.h"

#import "SDCutEditItemsView.h"
#import "SDEditImageEnumModel.h"

#import "SDEditImageEnumView.h"

#import "SDDecorateEditItemsView.h"

@interface SDDecorateEditPhotoControllerItemsView ()

@property (nonatomic, weak) UIView * theMainContentView;

@property (nonatomic, weak) SDDecorateEditItemsView * decorateView;

@end

@implementation SDDecorateEditPhotoControllerItemsView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, MAXSize(386));
        [self sd_configView];
    }
    return self;
}
- (void)sd_configView
{
    [self theMainContentView];
    
    [self decorateView];
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

- (void)setDecorateModel:(SDEditImageEnumModel *)decorateModel
{
    _decorateModel = decorateModel;
    
    SDEditImageEnumView * view = [[SDEditImageEnumView alloc] initWithEditEnumModel:self.decorateModel withSize:CGSizeMake(MAXSize(216), MAXSize(146))];
    view.center = CGPointMake(self.bounds.size.width / 2.f - view.frame.size.width / 2.f, self.theMainContentView.frame.size.height / 2.f);
    
    [self.theMainContentView addSubview:view];
}
- (void)setTagModel:(SDEditImageEnumModel *)tagModel
{
    _tagModel = tagModel;
    
    SDEditImageEnumView * view = [[SDEditImageEnumView alloc] initWithEditEnumModel:self.tagModel withSize:CGSizeMake(MAXSize(216), MAXSize(146))];
    view.center = CGPointMake(self.bounds.size.width / 2.f + view.frame.size.width / 2.f, self.theMainContentView.frame.size.height / 2.f);
    [self.theMainContentView addSubview:view];
}
- (void)setDecorateList:(NSArray *)decorateList
{
    _decorateList = decorateList;
    
    self.decorateView.decorateList = self.decorateList;
    
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

- (SDDecorateEditItemsView *)decorateView
{
    if (!_decorateList) {
        SDDecorateEditItemsView * theView = [[SDDecorateEditItemsView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - MAXSize(146))];
        
        [self addSubview:theView];
        _decorateView = theView;
    }
    return _decorateView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
