//
//  SDEditImageEnumModel.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/13.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDBaseEditPhotoEunmModel.h"
typedef enum : NSUInteger {
    SDEditPhotoMainReset,
    SDEditPhotoMainFilter,
    SDEditPhotoMainCut,
    SDEditPhotoMainDecorate,
    SDEditPhotoMainGraffiti,
    SDEditPhotoCancel,
    SDEditPhotoSure,
    SDEditPhotoFilter,
    SDEditPhotoCut,
    SDEditPhotoDecorate,
    SDEditPhotoTag,
    SDEditPhotoBrush,
    SDEditPhotoEraser,
} SDEditPhotoAction;


@interface SDEditImageEnumModel : SDBaseEditPhotoEunmModel


@property (nonatomic, assign) SDEditPhotoAction photoAction;

@property (nonatomic, strong) NSString * imageLink;

@property (nonatomic, strong) NSString * enumText;


- (instancetype)initWithAction:(SDEditPhotoAction )photoAction;
@end
