//
//  SDFilterEditPhotoControllerItemsView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDFilterEditPhotoControllerItemsView.h"


#import "SDEditImageEnumModel.h"

#import "SDFilterFunctionModel.h"

#import "SDEditImageEnumView.h"

#import "SDEditFilterItemsView.h"

@implementation SDFilterEditPhotoControllerItemsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, SCREENH_HEIGHT - MAXSize(466), SCREEN_WIDTH, MAXSize(466));
        
        [self theFilterContentView];
        
    }
    return self;
}

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
- (void)setFilterModel:(SDEditImageEnumModel *)filterModel
{
    _filterModel = filterModel;
    
    SDEditImageEnumView * view = [[SDEditImageEnumView alloc] initWithEditEnumModel:self.filterModel withSize:CGSizeMake(MAXSize(216), MAXSize(146))];
    view.center = CGPointMake(self.theMainContentView.bounds.size.width / 2.f, self.theMainContentView.bounds.size.height / 2.f);
    [self.theMainContentView addSubview:view];
}

- (void)setFilterList:(NSArray *)filterList
{
    _filterList = filterList;
    
    self.theFilterContentView.filterList = self.filterList;
    
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

- (SDEditFilterItemsView *)theFilterContentView
{
    if (!_theFilterContentView) {
        SDEditFilterItemsView * theView = [[SDEditFilterItemsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height - MAXSize(146))];
        [self addSubview:theView];
        _theFilterContentView = theView;
    }
    return _theFilterContentView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
