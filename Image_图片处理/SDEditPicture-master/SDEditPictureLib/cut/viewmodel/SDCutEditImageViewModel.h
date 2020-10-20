//
//  SDCutEditImageViewModel.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDBaseEditImageViewModel.h"
@class SDEditImageEnumModel;

@interface SDCutEditImageViewModel : SDBaseEditImageViewModel

@property (nonatomic, strong) SDEditImageEnumModel * cancelModel;

@property (nonatomic, strong) SDEditImageEnumModel * cutModel;

@property (nonatomic, strong) SDEditImageEnumModel * sureModel;

@property (nonatomic, strong) NSArray * cutList;
@end
