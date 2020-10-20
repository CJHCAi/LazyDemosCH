//
//  SDDecorateEditImageViewModel.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDEditImageViewModel.h"

@class SDEditImageEnumModel;

@interface SDDecorateEditImageViewModel : SDEditImageViewModel
@property (nonatomic, strong) SDEditImageEnumModel * cancelModel;

@property (nonatomic, strong) SDEditImageEnumModel * decorateModel;

@property (nonatomic, strong) SDEditImageEnumModel * tagModel;

@property (nonatomic, strong) SDEditImageEnumModel * sureModel;

@property (nonatomic, strong) NSArray * decorateList;

@property (nonatomic, strong) NSArray * tagList;

@end
