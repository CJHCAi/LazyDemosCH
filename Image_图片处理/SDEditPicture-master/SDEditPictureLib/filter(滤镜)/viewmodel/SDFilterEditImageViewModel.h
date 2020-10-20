//
//  SDFilterEditImageViewModel.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDBaseEditImageViewModel.h"

@class SDEditImageEnumModel;

@interface SDFilterEditImageViewModel : SDBaseEditImageViewModel

@property (nonatomic, strong) SDEditImageEnumModel * cancelModel;

@property (nonatomic, strong) SDEditImageEnumModel * filterModel;

@property (nonatomic, strong) SDEditImageEnumModel * sureModel;

@property (nonatomic, strong) NSArray * filterList;

@end
