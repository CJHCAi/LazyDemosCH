//
//  LHPhotoModel.h
//  LHand
//
//  Created by 小华 on 15/5/16.
//  Copyright (c) 2015年 chenstone. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ImageListModel;

@interface LHPhotoModel : NSObject
/** 缩略图 */
@property (nonatomic, copy) ImageListModel *IML;

@property (nonatomic, copy) NSString *bmiddle_pic;

@end
