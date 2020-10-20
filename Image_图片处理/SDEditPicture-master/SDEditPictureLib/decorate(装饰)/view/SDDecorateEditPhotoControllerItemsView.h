//
//  SDDecorateEditPhotoControllerItemsView.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDEditImageEnumModel;

@interface SDDecorateEditPhotoControllerItemsView : UIView

@property (nonatomic, strong) SDEditImageEnumModel * cancelModel;

@property (nonatomic, strong) SDEditImageEnumModel * decorateModel;

@property (nonatomic, strong) SDEditImageEnumModel * tagModel;

@property (nonatomic, strong) SDEditImageEnumModel * sureModel;

@property (nonatomic, strong) NSArray * decorateList;
@end
