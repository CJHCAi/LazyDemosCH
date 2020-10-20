//
//  SDEditImageViewModel.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/13.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDBaseEditImageViewModel.h"

#define KEditPhotoMain @"editphotomain"
#define KEditPhotoFilter @"editphotofilter"
#define KEditPhotoCut @"editphotocut"
#define KEditPhotoDecorate @"editphotodecorate"
#define KEditPhotoGraffiti @"editphotograffiti"


@interface SDEditImageViewModel : SDBaseEditImageViewModel


@property (nonatomic, strong) NSMutableDictionary * editInfo;


- (NSArray * )getEditEnumListByModel:(NSString * )model;


@end
