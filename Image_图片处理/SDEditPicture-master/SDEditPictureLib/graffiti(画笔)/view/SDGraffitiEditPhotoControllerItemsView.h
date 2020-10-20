//
//  SDGraffitiEditPhotoControllerItemsView.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDEditImageEnumModel;

@class SDGraffitiResetModel;
@class SDGraffitiSelectedColorModel;
@interface SDGraffitiEditPhotoControllerItemsView : UIView

@property (nonatomic, strong) SDEditImageEnumModel * cancelModel;

@property (nonatomic, strong) SDEditImageEnumModel * brushModel;

@property (nonatomic, strong) SDEditImageEnumModel * eraserModel;

@property (nonatomic, strong) SDEditImageEnumModel * sureModel;


@property (nonatomic, strong) SDGraffitiResetModel * graffitiResetModel;

@property (nonatomic, strong) SDGraffitiSelectedColorModel * graffitiSelectedColorModel;

@property (nonatomic, strong) NSArray * graffiti_size_list;

@property (nonatomic, strong) NSArray * graffiti_color_list;


- (void)showGraffitiColorView;


- (void)showSelectedbrushView;

- (void)showSelectedEraserView;
@end
