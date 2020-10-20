//
//  SDEditImageControllerItemsView.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/13.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDEditImageControllerItemsView.h"
#import "SDEditImageEnumModel.h"
#import "SDEditImageEnumView.h"

@interface SDEditImageControllerItemsView ()

@property (nonatomic, weak) UIView * theBgContentView;

@end


@implementation SDEditImageControllerItemsView

- (instancetype)init
{
    self = [super init];

    if (self) {
        
        CGFloat showContentFrameHeight =  maineditfunctionphotoheight;
        
        self.frame = CGRectMake(0, SCREENH_HEIGHT - showContentFrameHeight, SCREEN_WIDTH, showContentFrameHeight);
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self sd_configView];
    }
    return self;
}

- (void)setEditPtotoShowType:(SDEditPhotoShowType)editPtotoShowType
{
    _editPtotoShowType = editPtotoShowType;
    
}
- (void)setEditList:(NSArray *)editList
{
    _editList = editList;
    
    [self displayEditImageController];
}

- (void)sd_configView
{
    [self theBgContentView];
}

- (void)displayEditImageController
{
    
   __block CGFloat frame_x = MAXSize(30);
    
    CGFloat unit_width = (SCREEN_WIDTH - MAXSize(30) * 2)/self.editList.count;
    [self.editList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SDEditImageEnumModel * model = obj;
        
        SDEditImageEnumView * view = [[SDEditImageEnumView alloc] initWithEditEnumModel:model withSize:CGSizeMake(unit_width, self.bounds.size.height)];
        [self.theBgContentView addSubview:view];
        view.frame = (CGRect){{frame_x,0},{view.frame.size.width,self.bounds.size.height}};
        frame_x += view.frame.size.width;
        
        
    }];
}




- (UIView *)theBgContentView
{
    if (!_theBgContentView) {
        UIView * theView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:theView];
        _theBgContentView = theView;
    }
    return _theBgContentView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
