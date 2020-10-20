//
//  SDFilterEditPhotoControllerItemsView.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDFilterFunctionModel;
@class SDEditImageEnumModel;
@class SDEditFilterItemsView;


@interface SDFilterEditPhotoControllerItemsView : UIView

@property (nonatomic, weak) UIView * theMainContentView;

@property (nonatomic, weak) SDEditFilterItemsView * theFilterContentView;

@property (nonatomic, strong) SDEditImageEnumModel * cancelModel;
@property (nonatomic, strong) SDEditImageEnumModel * filterModel;
@property (nonatomic, strong) SDEditImageEnumModel * sureModel;

@property (nonatomic, strong) NSArray * filterList;

@end
