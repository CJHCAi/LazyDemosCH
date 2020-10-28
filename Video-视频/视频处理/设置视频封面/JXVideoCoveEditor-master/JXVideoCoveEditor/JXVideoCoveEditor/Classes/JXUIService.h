//
//  JXUIService.h
//  JXVideoImagePicker
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class JXVideoImage;
static NSString  *const kVideoCellIdentifier = @"cell";

@interface JXUIService : NSObject<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic, strong) NSArray <JXVideoImage *>*displayKeyframeImages;

@end
